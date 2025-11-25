# main.py
import os
import datetime
import asyncio
from typing import Optional, List, Dict, Any
from dotenv import load_dotenv

import httpx
import uvicorn
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from motor.motor_asyncio import AsyncIOMotorClient

from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import re

# ----- Load environment -----
load_dotenv()

MONGO_URI = os.getenv("MONGO_URI")
if not MONGO_URI:
    raise RuntimeError("Please set MONGO_URI environment variable.")

MONGO_DB_NAME = os.getenv("MONGO_DB_NAME", "translation_db")
MONGO_COLLECTION = os.getenv("MONGO_COLLECTION", "history")

KANJI_API_BASE = "https://kanjiapi.dev/v1/kanji"

# ----- NLLB-200 model config -----
MODEL_NAME = "facebook/nllb-200-distilled-600M"
SRC_LANG = "jpn_Jpan"
TGT_LANG = "vie_Latn"

# ----- App & DB -----
app = FastAPI(title="JA/VI Translation API (NLLB-200)")
mongo_client = AsyncIOMotorClient(MONGO_URI)
db = mongo_client[MONGO_DB_NAME]
history_coll = db[MONGO_COLLECTION]

# ----- Load model -----
print("Loading NLLB-200 model... (may take a while on first run)")
tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
model = AutoModelForSeq2SeqLM.from_pretrained(MODEL_NAME)
print("NLLB-200 model loaded.")


# ----- Pydantic -----
class TranslateRequest(BaseModel):
    text: str
    src_lang: Optional[str] = None
    tgt_lang: Optional[str] = None


# ----- Helpers -----
def is_single_kanji(s: str) -> bool:
    s = s.strip()
    if len(s) != 1:
        return False
    code = ord(s)
    ranges = [
        (0x4E00, 0x9FFF),
        (0x3400, 0x4DBF),
        (0x20000, 0x2A6DF),
        (0x2A700, 0x2B73F),
    ]
    return any(start <= code <= end for start, end in ranges)


def is_hiragana(s: str) -> bool:
    return all(0x3040 <= ord(c) <= 0x309F for c in s)


VIET_REGEX = re.compile(r"[a-zA-ZÀ-ỹ]+")
def is_vietnamese(s: str) -> bool:
    return bool(VIET_REGEX.search(s))


async def translate_text(text: str, src_lang: str, tgt_lang: str) -> str:
    def _generate(t):
        inputs = tokenizer(t, return_tensors="pt", padding=True, truncation=True)
        generated = model.generate(
            **inputs,
            forced_bos_token_id=tokenizer.lang_code_to_id[tgt_lang],
            max_length=200,
            num_beams=5
        )
        return tokenizer.batch_decode(generated, skip_special_tokens=True)[0]

    return await asyncio.to_thread(_generate, text)


async def fetch_kanji_data(kanji: str) -> Dict[str, Any]:
    async with httpx.AsyncClient(timeout=20.0) as client:
        kanji_url = f"{KANJI_API_BASE}/{kanji}"

        try:
            r = await client.get(kanji_url)
            if r.status_code != 200:
                raise HTTPException(status_code=404, detail=f"Kanji data not found for {kanji}")
            raw = r.json()
        except httpx.RequestError:
            raise HTTPException(status_code=503, detail="Failed to contact kanji API service.")

        meanings = raw.get("meanings", [])
        kun = raw.get("kun_readings", [])
        on = raw.get("on_readings", [])
        stroke_count = raw.get("stroke_count")
        jlpt = raw.get("jlpt") or None
        radical = raw.get("radical", {})
        components = raw.get("components", [])

        result = {
            "kanji": kanji,
            "romaji": kun[0] if kun else on[0] if on else None,
            "kunyomi": kun[0] if kun else None,
            "onyomi": on[0] if on else None,
            "stroke_count": stroke_count,
            "jlpt": jlpt,
            "radical": {
                "symbol": radical.get("symbol"),
                "meaning": radical.get("meaning")
            } if radical else None,
            "components": components,
            "meaning": meanings[0] if meanings else None,
            "translation": None,
            "definition": "；".join(meanings) if meanings else None,
            "usages": [],
            "examples": []
        }

        # Examples from kanjiapi
        try:
            ex_r = await client.get(f"{KANJI_API_BASE}/{kanji}/examples")
            if ex_r.status_code == 200:
                ex_json = ex_r.json()
                examples = []
                for e in ex_json[:10]:
                    j = e.get("japanese")
                    if isinstance(j, str):
                        sent = j
                    elif isinstance(j, dict):
                        sent = j.get("word") or j.get("reading") or ""
                    else:
                        sent = ""
                    reading = e.get("reading")
                    translation = e.get("meanings", [None])[0]
                    examples.append({
                        "sentence": sent,
                        "reading": reading,
                        "translation": translation
                    })
                result["examples"] = examples
        except:
            pass

        # Usages from Jisho API
        try:
            jisho_q = f"https://jisho.org/api/v1/search/words?keyword={kanji}"
            jr = await client.get(jisho_q, timeout=15.0)
            if jr.status_code == 200:
                data = jr.json()
                usages = []
                for item in data.get("data", [])[:10]:
                    japanese = item.get("japanese", [])
                    senses = item.get("senses", [])
                    word = japanese[0].get("word") if japanese and japanese[0].get("word") else japanese[0].get("reading")
                    reading = japanese[0].get("reading") if japanese else None
                    meaning = senses[0]["english_definitions"][0] if senses else None
                    usages.append({
                        "word": word,
                        "reading": reading,
                        "meaning": meaning
                    })
                result["usages"] = usages
        except:
            pass

        # Translate meaning to Vietnamese
        try:
            if result["meaning"]:
                translation_text = await translate_text(result["meaning"], src_lang=SRC_LANG, tgt_lang=TGT_LANG)
                result["translation"] = translation_text
        except:
            result["translation"] = None

        return result


# ----- Endpoints -----
@app.post("/translate")
async def translate(req: TranslateRequest):
    text = req.text.strip()
    if not text:
        raise HTTPException(status_code=400, detail="Empty text.")

    # Single word: Kanji/Hiragana/Vietnamese
    if is_single_kanji(text) or is_hiragana(text) or is_vietnamese(text):
        if is_single_kanji(text):
            data = await fetch_kanji_data(text)
        else:
            src = SRC_LANG if not is_vietnamese(text) else TGT_LANG
            tgt = TGT_LANG if not is_vietnamese(text) else SRC_LANG
            translated = await translate_text(text, src_lang=src, tgt_lang=tgt)
            data = {"word": text, "translation": translated}

        await history_coll.insert_one({
            "input": text,
            "type": "word",
            "result": data,
            "ts": datetime.datetime.utcnow()
        })
        return data

    # Phrase or sentence
    contains_japanese = any(is_single_kanji(c) or is_hiragana(c) for c in text)
    if contains_japanese:
        translated = await translate_text(text, src_lang=SRC_LANG, tgt_lang=TGT_LANG)
    else:
        translated = await translate_text(text, src_lang=TGT_LANG, tgt_lang=SRC_LANG)

    result = {"translation": translated}
    await history_coll.insert_one({
        "input": text,
        "type": "text",
        "result": result,
        "ts": datetime.datetime.utcnow()
    })
    return result


@app.get("/history")
async def history(limit: int = 50):
    cursor = history_coll.find().sort("ts", -1).limit(limit)
    out = []
    async for doc in cursor:
        doc["_id"] = str(doc.get("_id"))
        out.append(doc)
    return {"count": len(out), "items": out}


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000)
