-- 1. Thêm dữ liệu vào bảng Role (2 quyền: GV và HS)
INSERT INTO "Role" (role_name, role_description) VALUES 
('Teacher', 'Giáo viên - Có quyền tạo nội dung'), -- ID sẽ là 1
('Student', 'Học sinh - Có quyền học tập');      -- ID sẽ là 2

-- 2. Thêm dữ liệu vào bảng Permission (4 quyền)
INSERT INTO Permission (permission_name, permission_description) VALUES 
('create_slide', 'Quyền tạo slide bài giảng'),     -- ID 1 (Của GV)
('create_question', 'Quyền tạo ngân hàng câu hỏi'), -- ID 2 (Của GV)
('search', 'Quyền tra cứu thông tin'),             -- ID 3 (Chung)
('use_flashcard', 'Quyền sử dụng Flashcard');      -- ID 4 (Chung)

-- 3. Phân quyền cho Role (Cần bảng Role_Permission để liên kết)
-- Giả sử Role ID 1 = GV, Role ID 2 = HS
-- Giả sử Perm ID 1,2 = GV only; Perm ID 3,4 = Chung

INSERT INTO Role_Permission (role_id, permission_id) VALUES
-- Quyền cho Giáo Viên (Có tất cả các quyền hoặc chỉ quyền quản lý + quyền chung)
(1, 1), -- GV được tạo slide
(1, 2), -- GV được tạo câu hỏi
(1, 3), -- GV được tra cứu
(1, 4), -- GV được dùng flashcard

-- Quyền cho Học Sinh (Chỉ có quyền chung)
(2, 3), -- HS được tra cứu
(2, 4); -- HS được dùng flashcard

-- 4. Thêm dữ liệu vào bảng User (2 GV và 10 HS)
INSERT INTO "User" (user_name, user_email, user_password, user_phone) VALUES 
-- 2 Giáo viên
('Nguyen Van GV1', 'gv1@school.edu.vn', 'password123', '0901111111'), -- User ID 1
('Tran Thi GV2', 'gv2@school.edu.vn', 'password123', '0902222222'),   -- User ID 2

-- 10 Học sinh
('Hoc Sinh A', 'hs1@school.edu.vn', 'pass123', '0911111111'), -- User ID 3
('Hoc Sinh B', 'hs2@school.edu.vn', 'pass123', '0911111112'), -- User ID 4
('Hoc Sinh C', 'hs3@school.edu.vn', 'pass123', '0911111113'), -- User ID 5
('Hoc Sinh D', 'hs4@school.edu.vn', 'pass123', '0911111114'), -- User ID 6
('Hoc Sinh E', 'hs5@school.edu.vn', 'pass123', '0911111115'), -- User ID 7
('Hoc Sinh F', 'hs6@school.edu.vn', 'pass123', '0911111116'), -- User ID 8
('Hoc Sinh G', 'hs7@school.edu.vn', 'pass123', '0911111117'), -- User ID 9
('Hoc Sinh H', 'hs8@school.edu.vn', 'pass123', '0911111118'), -- User ID 10
('Hoc Sinh I', 'hs9@school.edu.vn', 'pass123', '0911111119'), -- User ID 11
('Hoc Sinh K', 'hs10@school.edu.vn', 'pass123', '0911111120'); -- User ID 12

-- 5. Gán User vào Role (Bảng User_Role)
-- User ID 1, 2 là Giáo viên (Role ID 1)
-- User ID 3 -> 12 là Học sinh (Role ID 2)
INSERT INTO User_Role (user_id, role_id) VALUES
-- Gán 2 GV
(1, 1),
(2, 1),

-- Gán 10 HS
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2);

-- 6. Thêm dữ liệu Flashcard (Mỗi User 5 thẻ - Từ vựng Tiếng Nhật/Việt)
INSERT INTO Flashcard (user_id, flashcard_front, flashcard_back) VALUES
-- User 1 (Teacher): Từ vựng CNTT
(1, 'Pasokon (パソコン)', 'Máy tính cá nhân'),
(1, 'Mausu (マウス)', 'Chuột máy tính'),
(1, 'Kiiboodo (キーボード)', 'Bàn phím'),
(1, 'Gamen (画面)', 'Màn hình'),
(1, 'Intaanetto (インターネット)', 'Mạng Internet'),

-- User 2 (Teacher): Từ vựng Trường học
(2, 'Sensei (先生)', 'Giáo viên'),
(2, 'Kyoushitsu (教室)', 'Lớp học'),
(2, 'Kokuban (黒板)', 'Bảng đen'),
(2, 'Jugyou (授業)', 'Giờ học'),
(2, 'Shukudai (宿題)', 'Bài tập về nhà'),

-- User 3 (Student): Chào hỏi cơ bản
(3, 'Konnichiwa (こんにちは)', 'Xin chào (ban ngày)'),
(3, 'Ohayou (おはよう)', 'Chào buổi sáng'),
(3, 'Konbanwa (こんばんは)', 'Chào buổi tối'),
(3, 'Arigatou (ありがとう)', 'Cảm ơn'),
(3, 'Sayounara (さようなら)', 'Tạm biệt'),

-- User 4 (Student): Đồ dùng học tập
(4, 'Hon (本)', 'Sách'),
(4, 'Enpitsu (鉛筆)', 'Bút chì'),
(4, 'Kaban (鞄)', 'Cặp sách'),
(4, 'Nooto (ノート)', 'Vở ghi chép'),
(4, 'Keshigomu (消しゴム)', 'Cục tẩy'),

-- User 5 (Student): Gia đình
(5, 'Kazoku (家族)', 'Gia đình'),
(5, 'Chichi (父)', 'Bố (của mình)'),
(5, 'Haha (母)', 'Mẹ (của mình)'),
(5, 'Ani (兄)', 'Anh trai'),
(5, 'Ane (姉)', 'Chị gái'),

-- User 6 (Student): Động vật
(6, 'Inu (犬)', 'Con chó'),
(6, 'Neko (猫)', 'Con mèo'),
(6, 'Tori (鳥)', 'Con chim'),
(6, 'Sakana (魚)', 'Con cá'),
(6, 'Uma (馬)', 'Con ngựa'),

-- User 7 (Student): Màu sắc
(7, 'Aka (赤)', 'Màu đỏ'),
(7, 'Ao (青)', 'Màu xanh dương'),
(7, 'Shiro (白)', 'Màu trắng'),
(7, 'Kuro (黒)', 'Màu đen'),
(7, 'Kiiro (黄色)', 'Màu vàng'),

-- User 8 (Student): Số đếm
(8, 'Ichi (一)', 'Số 1'),
(8, 'Ni (二)', 'Số 2'),
(8, 'San (三)', 'Số 3'),
(8, 'Yon (四)', 'Số 4'),
(8, 'Go (五)', 'Số 5'),

-- User 9 (Student): Động từ cơ bản 1
(9, 'Tabemasu (食べます)', 'Ăn'),
(9, 'Nomimasu (飲みます)', 'Uống'),
(9, 'Ikimasu (行きます)', 'Đi'),
(9, 'Kimasu (来ます)', 'Đến'),
(9, 'Kaerimasu (帰ります)', 'Trở về'),

-- User 10 (Student): Động từ cơ bản 2
(10, 'Mimasu (見ます)', 'Xem, nhìn'),
(10, 'Kikimasu (聞きます)', 'Nghe'),
(10, 'Yomimasu (読みます)', 'Đọc'),
(10, 'Kakimasu (書きます)', 'Viết'),
(10, 'Hanashimasu (話します)', 'Nói chuyện'),

-- User 11 (Student): Thời gian
(11, 'Ima (今)', 'Bây giờ'),
(11, 'Mainichi (毎日)', 'Mỗi ngày'),
(11, 'Asa (朝)', 'Buổi sáng'),
(11, 'Hiru (昼)', 'Buổi trưa'),
(11, 'Yoru (夜)', 'Buổi tối'),

-- User 12 (Student): Phương tiện
(12, 'Kuruma (車)', 'Ô tô'),
(12, 'Jitensha (自転車)', 'Xe đạp'),
(12, 'Densha (電車)', 'Tàu điện'),
(12, 'Basu (バス)', 'Xe buýt'),
(12, 'Hikouki (飛行機)', 'Máy bay');

-- 7. Thêm dữ liệu Tag (4 Tag)
INSERT INTO Tag (tag_name) VALUES 
('Nihongo'), -- Tag ID 1
('Vietnam'), -- Tag ID 2
('ITSS1'),   -- Tag ID 3
('ITSS2');   -- Tag ID 4

-- 8. Thêm dữ liệu Slide (3 Slides cho GV1 và GV2)
INSERT INTO Slide (user_id, slide_title, slide_file_path, slide_description) VALUES
-- Slide 1: Của GV1 (User ID 1)
(1, '03_Webアプリ - 仕様書(1)_事前課題.pdf', 'https://drive.google.com/file/d/17JAUFfKzMTKD9FTJP9qlpfbSN8Zv7Vxk/view?usp=sharing', 'Tài liệu đặc tả yêu cầu và bài tập chuẩn bị.'),

-- Slide 2: Của GV2 (User ID 2)
(2, '07_Webアプリ - プロダクトバックログ(2).pdf', 'https://drive.google.com/file/d/1ApLH2dB1IUbWc9KxlqCdmEUzFV1Cg1Dp/view?usp=sharing', 'Tài liệu chi tiết về Product Backlog.'),

-- Slide 3: Của GV2 (User ID 2)
(2, '09_Webアプリ - スプリント1バックログ作成報告.pdf', 'https://drive.google.com/file/d/1flAgQuLKwZH37bND3-H4nGa9ilOGyo1T/view?usp=sharing', 'Báo cáo kết quả tạo Backlog cho Sprint 1.');

-- 9. Gán Tag cho Slide (Slide_Tag)
-- Yêu cầu: Tất cả các slide trên đều có 2 tag: Nihongo (ID 1) và ITSS1 (ID 3)
INSERT INTO Slide_Tag (slide_id, tag_id) VALUES
-- Slide 1 (ID 1)
(1, 1), (1, 3),
-- Slide 2 (ID 2)
(2, 1), (2, 3),
-- Slide 3 (ID 3)
(3, 1), (3, 3);

-- 10. Thêm Ghi chú cho Slide (Slide_Note)
-- Yêu cầu: Mỗi sinh viên (User ID 3-12) có 1 ghi chú trên 1 trang ngẫu nhiên (1-5) của 1 slide ngẫu nhiên (1-3)
INSERT INTO Slide_Note (slide_id, user_id, slide_note_page, slide_note_content) VALUES
-- HS A (User 3) - Slide 1, Page 2
(1, 3, 2, 'Trang này nhiều thuật ngữ khó quá, chưa hiểu rõ.'),

-- HS B (User 4) - Slide 2, Page 5
(2, 4, 5, 'Phần backlog này giải thích rất chi tiết, dễ hiểu.'),

-- HS C (User 5) - Slide 3, Page 1
(3, 5, 1, 'Mục tiêu sprint chưa được làm rõ ở đoạn mở đầu.'),

-- HS D (User 6) - Slide 1, Page 3
(1, 6, 3, 'Biểu đồ này rất trực quan, giúp em hiểu luồng dữ liệu.'),

-- HS E (User 7) - Slide 2, Page 4
(2, 7, 4, 'Em nghĩ phần priority này cần xem lại logic.'),

-- HS F (User 8) - Slide 3, Page 2
(3, 8, 2, 'Chỗ này có lỗi chính tả trong tên biến.'),

-- HS G (User 9) - Slide 1, Page 5
(1, 9, 5, 'Phần bài tập về nhà này deadline là khi nào ạ?'),

-- HS H (User 10) - Slide 2, Page 1
(2, 10, 1, 'Slide mở đầu hơi dài dòng.'),

-- HS I (User 11) - Slide 3, Page 3
(3, 11, 3, 'Em chưa hiểu cách tính story point ở trang này.'),

-- HS K (User 12) - Slide 2, Page 3
(2, 12, 3, 'Đoạn mô tả user story này rất hay!');

-- 11. Thêm Bài tập (Assignment) - 3 Bài tương ứng 3 Slide
-- Logic: Slide 1 của GV1 -> Assignment 1
--        Slide 2, 3 của GV2 -> Assignment 2, 3
INSERT INTO Assignment (user_id, assignment_title, assignment_description, assignment_deadline, assignment_score) VALUES
(1, 'Bài tập Slide 1: Đặc tả yêu cầu', 'Hoàn thành câu hỏi trắc nghiệm và tự luận về tài liệu đặc tả.', '2023-12-01', 100), -- ID 1
(2, 'Bài tập Slide 2: Product Backlog', 'Kiểm tra kiến thức về các hạng mục trong Backlog.', '2023-12-05', 100),        -- ID 2
(2, 'Bài tập Slide 3: Sprint 1 Report', 'Phân tích báo cáo Sprint 1 và đề xuất cải tiến.', '2023-12-10', 100);       -- ID 3

-- 12. Thêm Câu hỏi (Question) - Mỗi Assignment 2 câu (30đ/70đ)
INSERT INTO Question (assignment_id, question_text, question_type, question_score) VALUES
-- Assignment 1 (ID 1)
(1, 'Đâu là thành phần bắt buộc trong tài liệu đặc tả?', 'Trắc nghiệm', 30), -- QID 1
(1, 'Hãy viết đoạn văn ngắn mô tả luồng đi của chức năng Đăng nhập.', 'Tự luận', 70),   -- QID 2

-- Assignment 2 (ID 2)
(2, 'Ai là người chịu trách nhiệm chính về Product Backlog?', 'Trắc nghiệm', 30), -- QID 3
(2, 'Tại sao việc ưu tiên (Prioritization) lại quan trọng trong Backlog?', 'Tự luận', 70), -- QID 4

-- Assignment 3 (ID 3)
(3, 'Sprint Review diễn ra khi nào?', 'Trắc nghiệm', 30),                         -- QID 5
(3, 'Dựa trên báo cáo, hãy liệt kê 3 điểm cần khắc phục cho Sprint sau.', 'Tự luận', 70);   -- QID 6

-- 13. Thêm Câu trả lời & Bài nộp (Answers & Assignment_Submission)
-- Logic: 
-- Ass 1: User 3, 4, 5, 6, 7 nộp
-- Ass 2: User 4, 5, 6, 7, 8 nộp
-- Ass 3: User 8, 9, 10, 11, 12 nộp

-- === ASSIGNMENT 1 (User 3,4,5,6,7) ===
-- User 3: 25 + 60 = 85
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (3, 1, 'Đáp án A', 25), (3, 2, 'Mô tả chi tiết...', 60);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (3, 1, 'Đã nộp', 85);

-- User 4: 30 + 50 = 80
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (4, 1, 'Đáp án B', 30), (4, 2, 'User nhập user/pass...', 50);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (4, 1, 'Đã nộp', 80);

-- User 5: 10 + 40 = 50
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (5, 1, 'Đáp án C', 10), (5, 2, 'Không rõ lắm...', 40);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (5, 1, 'Đã nộp', 50);

-- User 6: 28 + 65 = 93
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (6, 1, 'Đáp án A', 28), (6, 2, 'Rất chi tiết...', 65);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (6, 1, 'Đã nộp', 93);

-- User 7: 15 + 30 = 45
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (7, 1, 'Đáp án D', 15), (7, 2, 'Viết sơ sài...', 30);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (7, 1, 'Đã nộp', 45);


-- === ASSIGNMENT 2 (User 4,5,6,7,8) ===
-- User 4: 30 + 65 = 95
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (4, 3, 'Product Owner', 30), (4, 4, 'Để tối ưu giá trị...', 65);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (4, 2, 'Đã nộp', 95);

-- User 5: 20 + 50 = 70
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (5, 3, 'Scrum Master', 20), (5, 4, 'Để làm nhanh hơn...', 50);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (5, 2, 'Đã nộp', 70);

-- User 6: 30 + 70 = 100
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (6, 3, 'Product Owner', 30), (6, 4, 'Phân tích xuất sắc...', 70);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (6, 2, 'Đã nộp', 100);

-- User 7: 10 + 20 = 30
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (7, 3, 'Dev Team', 10), (7, 4, 'Không biết...', 20);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (7, 2, 'Đã nộp', 30);

-- User 8: 25 + 55 = 80
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (8, 3, 'Product Owner', 25), (8, 4, 'Khá ổn...', 55);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (8, 2, 'Đã nộp', 80);


-- === ASSIGNMENT 3 (User 8,9,10,11,12) ===
-- User 8: 30 + 60 = 90
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (8, 5, 'Cuối Sprint', 30), (8, 6, 'Giao tiếp, Code, Test', 60);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (8, 3, 'Đã nộp', 90);

-- User 9: 15 + 40 = 55
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (9, 5, 'Đầu Sprint', 15), (9, 6, 'Không có ý kiến', 40);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (9, 3, 'Đã nộp', 55);

-- User 10: 30 + 68 = 98
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (10, 5, 'Cuối Sprint', 30), (10, 6, 'Phân tích rất sâu...', 68);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (10, 3, 'Đã nộp', 98);

-- User 11: 20 + 50 = 70
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (11, 5, 'Giữa Sprint', 20), (11, 6, 'Cần họp ít hơn', 50);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (11, 3, 'Đã nộp', 70);

-- User 12: 30 + 40 = 70
INSERT INTO Answers (user_id, question_id, answer_text, answer_score) VALUES (12, 5, 'Cuối Sprint', 30), (12, 6, 'Tài liệu chưa rõ', 40);
INSERT INTO Assignment_Submission (user_id, assignment_id, submission_status, submission_score) VALUES (12, 3, 'Đã nộp', 70);


-- 14. Thêm Hoạt động gần đây (Recent_Activitie)
-- Yêu cầu: GV lưu hoạt động tạo Assignment, HS lưu hoạt động Nộp bài (Assignment_Submission)

-- Hoạt động của GV (Tạo bài tập)
INSERT INTO Recent_Activitie (user_id, activity_type, activity_detail) VALUES
(1, 'Tạo bài tập', 'Đã tạo bài tập: Bài tập Slide 1: Đặc tả yêu cầu'),
(2, 'Tạo bài tập', 'Đã tạo bài tập: Bài tập Slide 2: Product Backlog'),
(2, 'Tạo bài tập', 'Đã tạo bài tập: Bài tập Slide 3: Sprint 1 Report');

-- Hoạt động của HS (Nộp bài tập) - Lưu cho các user đã nộp ở trên
INSERT INTO Recent_Activitie (user_id, activity_type, activity_detail) VALUES
-- Ass 1
(3, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 1: Đặc tả yêu cầu'),
(4, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 1: Đặc tả yêu cầu'),
(5, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 1: Đặc tả yêu cầu'),
(6, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 1: Đặc tả yêu cầu'),
(7, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 1: Đặc tả yêu cầu'),
-- Ass 2
(4, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 2: Product Backlog'),
(5, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 2: Product Backlog'),
(6, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 2: Product Backlog'),
(7, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 2: Product Backlog'),
(8, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 2: Product Backlog'),
-- Ass 3
(8, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 3: Sprint 1 Report'),
(9, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 3: Sprint 1 Report'),
(10, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 3: Sprint 1 Report'),
(11, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 3: Sprint 1 Report'),
(12, 'Nộp bài tập', 'Đã nộp bài cho: Bài tập Slide 3: Sprint 1 Report');