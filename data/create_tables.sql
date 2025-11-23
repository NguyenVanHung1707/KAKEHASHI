--
-- Bảng cho Người dùng (User)
--
CREATE TABLE "User" (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    user_phone VARCHAR(20),
    user_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

--
-- Bảng cho Vai trò (Role)
--
CREATE TABLE "Role" (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(100) UNIQUE NOT NULL,
    role_description VARCHAR(255)
);

--
-- Bảng trung gian Người dùng - Vai trò (User_Role)
--
CREATE TABLE User_Role (
    user_role_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES "Role"(role_id) ON DELETE CASCADE,
    UNIQUE (user_id, role_id)
);

--
-- Bảng cho Quyền hạn (Permission)
--
CREATE TABLE Permission (
    permission_id SERIAL PRIMARY KEY,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    permission_description VARCHAR(255)
);

--
-- Bảng trung gian Vai trò - Quyền hạn (Role_Permission)
--
CREATE TABLE Role_Permission (
    role_permission_id SERIAL PRIMARY KEY,
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES "Role"(role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES Permission(permission_id) ON DELETE CASCADE,
    UNIQUE (role_id, permission_id)
);

--
-- Bảng cho Hoạt động Gần đây (Recent_Activitie)
--
CREATE TABLE Recent_Activitie (
    activity_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    activity_type VARCHAR(100) NOT NULL,
    activity_detail TEXT,
    activity_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

--
-- Bảng cho Flashcard
--
CREATE TABLE Flashcard (
    flashcard_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    flashcard_front TEXT NOT NULL,
    flashcard_back TEXT NOT NULL,
    flashcard_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

--
-- Bảng cho Slide
--
CREATE TABLE Slide (
    slide_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    slide_title VARCHAR(255) NOT NULL,
    slide_file_path VARCHAR(255) NOT NULL,
    slide_description TEXT,
    slide_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

--
-- Bảng cho Ghi chú Slide (Slide_Note)
--
CREATE TABLE Slide_Note (
    slide_note_id SERIAL PRIMARY KEY,
    slide_id INT NOT NULL,
    user_id INT NOT NULL,
    slide_note_page INT NOT NULL,
    slide_note_content TEXT,
    slide_note_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (slide_id) REFERENCES Slide(slide_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    UNIQUE (slide_id, user_id, slide_note_page) -- Một người dùng chỉ có 1 ghi chú/trang/slide
);

--
-- Bảng cho Thẻ (Tag)
--
CREATE TABLE Tag (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(100) UNIQUE NOT NULL
);

--
-- Bảng trung gian Slide - Thẻ (Slide_Tag)
--
CREATE TABLE Slide_Tag (
    slide_tag_id SERIAL PRIMARY KEY,
    slide_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY (slide_id) REFERENCES Slide(slide_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tag(tag_id) ON DELETE CASCADE,
    UNIQUE (slide_id, tag_id)
);

--
-- Bảng cho Bài tập (Assignment)
--
CREATE TABLE Assignment (
    assignment_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    assignment_title VARCHAR(255) NOT NULL,
    assignment_description TEXT,
    assignment_deadline DATE NOT NULL,
    assignment_score INT,
    assignment_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE RESTRICT -- Giữ lại assignment nếu user bị xóa
);

--
-- Bảng cho Câu hỏi (Question)
--
CREATE TABLE Question (
    question_id SERIAL PRIMARY KEY,
    assignment_id INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL,
    question_score INT NOT NULL,
    FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id) ON DELETE CASCADE
);

--
-- Bảng cho Bài nộp Bài tập (Assignment_Submission)
--
CREATE TABLE Assignment_Submission (
    submission_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    assignment_id INT NOT NULL,
    submission_status VARCHAR(50) NOT NULL,
    submission_score INT,
    submission_submitted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE RESTRICT, -- Giữ lại submission nếu user bị xóa
    FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id) ON DELETE CASCADE,
    UNIQUE (user_id, assignment_id) -- Mỗi user chỉ nộp 1 bài cho 1 assignment
);

--
-- Bảng cho Câu trả lời (Answers)
--
CREATE TABLE Answers (
    answer_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_text TEXT NOT NULL,
    answer_submitted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    answer_score INT,
    FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE RESTRICT, -- Giữ lại câu trả lời nếu user bị xóa
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE,
    UNIQUE (user_id, question_id) -- Mỗi user chỉ có 1 câu trả lời cho 1 câu hỏi
);