-- Create and use the JLEARNING database
CREATE DATABASE JLEARNING;
DROP DATABASE IF EXISTS JLEARNING;
USE JLEARNING;

-- Create UserAccount table
CREATE TABLE UserAccount (
    userNum INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) UNIQUE, -- Removed computed column; handle ID formatting in application
    username VARCHAR(255) NOT NULL,
    fullName VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Student', 'Teacher', 'Admin', 'Coordinator')),
    registrationDate DATE DEFAULT (CURRENT_DATE),
    profilePicture VARCHAR(255),
    phone VARCHAR(20),
    birthDate DATE
);

-- Create Student table
CREATE TABLE Student (
    studentNum INT AUTO_INCREMENT PRIMARY KEY,
    studentID VARCHAR(10) UNIQUE, -- Removed computed column
    userID VARCHAR(10) UNIQUE,
    enrollmentDate DATE DEFAULT (CURRENT_DATE),
    vote INT DEFAULT 0,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID) ON DELETE CASCADE
);

-- Create Teacher table
CREATE TABLE Teacher (
    teacherNum INT AUTO_INCREMENT PRIMARY KEY,
    teacherID VARCHAR(10) UNIQUE, -- Removed computed column
    userID VARCHAR(10) UNIQUE NOT NULL,
    specialization VARCHAR(255),
    experienceYears INT CHECK (experienceYears >= 0),
    FOREIGN KEY (userID) REFERENCES UserAccount(userID) ON DELETE CASCADE
);

-- Create Courses table
CREATE TABLE Courses (
    courseNum INT AUTO_INCREMENT PRIMARY KEY,
    courseID VARCHAR(10) UNIQUE, -- Removed computed column
    title VARCHAR(255) NOT NULL,
    description TEXT,
    fee DECIMAL(10, 2) DEFAULT 0.00,
    duration INT,
    startDate DATE,
    endDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    CONSTRAINT CHK_Course_Dates CHECK (endDate >= startDate)
);

-- Create Course_Enrollments table
CREATE TABLE Course_Enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentID VARCHAR(10) NOT NULL,
    courseID VARCHAR(10) NOT NULL,
    enrollmentDate DATE DEFAULT (CURRENT_DATE),
    completionDate DATE,
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);

-- Create Course_Reviews table
CREATE TABLE Course_Reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    courseID VARCHAR(10) NOT NULL,
    userID VARCHAR(10) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    reviewText TEXT,
    reviewDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);

-- Create Lesson table
CREATE TABLE Lesson (
    id INT AUTO_INCREMENT PRIMARY KEY,
    courseID VARCHAR(10) NOT NULL,
    skill VARCHAR(20) NOT NULL CHECK (skill IN ('Listening', 'Speaking', 'Reading', 'Writing')),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    mediaUrl VARCHAR(500),
    duration INT,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);

-- Create Progress table
CREATE TABLE Progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentID VARCHAR(10) NOT NULL,
    enrollmentID INT NOT NULL,
    lessonID INT NOT NULL,
    completionStatus VARCHAR(20) NOT NULL DEFAULT 'in progress' CHECK (completionStatus IN ('complete', 'in progress')),
    startDate DATE,
    endDate DATE,
    score DECIMAL(5, 2),
    feedback VARCHAR(500),
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (enrollmentID) REFERENCES Course_Enrollments(id),
    FOREIGN KEY (lessonID) REFERENCES Lesson(id)
);

-- Create Document table
CREATE TABLE Document (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lessonID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    fileUrl VARCHAR(500),
    uploadDate DATETIME DEFAULT NOW(),
    uploadedBy VARCHAR(10),
    FOREIGN KEY (lessonID) REFERENCES Lesson(id),
    FOREIGN KEY (uploadedBy) REFERENCES Teacher(teacherID)
);

-- Create Exercise table (renamed from 'exercise' to avoid reserved keyword)
CREATE TABLE Exercise (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lessonID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    dueDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (lessonID) REFERENCES Lesson(id)
);

-- Create Tests table
CREATE TABLE Tests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    testType VARCHAR(20) NOT NULL CHECK (testType IN ('CourseTest', 'JLPT')),
    courseID VARCHAR(10),
    lessonID INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    jlptLevel VARCHAR(10) CHECK (jlptLevel IN ('N5', 'N4', 'N3', 'N2', 'N1')),
    totalMarks INT CHECK (totalMarks >= 0),
    totalQuestions INT CHECK (totalQuestions >= 0),
    dueDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
    FOREIGN KEY (lessonID) REFERENCES Lesson(id),
    CONSTRAINT CHK_TestType CHECK (
        (testType = 'CourseTest' AND courseID IS NOT NULL) OR
        (testType = 'JLPT' AND courseID IS NULL)
    )
);

-- Create Question table
CREATE TABLE Question (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exerciseID INT,
    testID INT,
    questionType VARCHAR(20) NOT NULL CHECK (questionType IN ('MultipleChoice', 'Essay')),
    questionText TEXT NOT NULL,
    optionA VARCHAR(255),
    optionB VARCHAR(255),
    optionC VARCHAR(255),
    optionD VARCHAR(255),
    correctOption CHAR(1) CHECK (correctOption IN ('A', 'B', 'C', 'D')),
    essayAnswer TEXT,
    mark INT DEFAULT 1 CHECK (mark >= 0),
    FOREIGN KEY (exerciseID) REFERENCES Exercise(id) ON DELETE CASCADE,
    FOREIGN KEY (testID) REFERENCES Tests(id) ON DELETE CASCADE,
    CONSTRAINT CHK_Question CHECK (
        (exerciseID IS NOT NULL AND testID IS NULL) OR
        (exerciseID IS NULL AND testID IS NOT NULL)
    )
);

-- Create Payment table
CREATE TABLE Payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    studentID VARCHAR(10) NOT NULL,
    enrollmentID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paymentMethod VARCHAR(50),
    paymentStatus VARCHAR(20) NOT NULL CHECK (paymentStatus IN ('Cancell', 'Pending', 'Complete')),
    paymentDate DATETIME DEFAULT NOW(),
    transactionID VARCHAR(100),
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (enrollmentID) REFERENCES Course_Enrollments(id)
);

-- Create Class table
CREATE TABLE Class (
    id INT AUTO_INCREMENT PRIMARY KEY,
    courseID VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    teacherID VARCHAR(10) NOT NULL,
    studentID VARCHAR(10) NOT NULL,
    FOREIGN KEY (studentID) REFERENCES Student(studentID),
    FOREIGN KEY (courseID) REFERENCES Courses(courseID),
    FOREIGN KEY (teacherID) REFERENCES Teacher(teacherID)
);

-- Create Announcement table
CREATE TABLE Announcement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    postedDate DATETIME DEFAULT NOW(),
    postedBy VARCHAR(10),
    FOREIGN KEY (postedBy) REFERENCES UserAccount(userID)
);

-- Create Discount table
CREATE TABLE Discount (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    courseID VARCHAR(10) NOT NULL,
    discountPercent INT CHECK (discountPercent BETWEEN 0 AND 100),
    startDate DATE,
    endDate DATE,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (courseID) REFERENCES Courses(courseID)
);

-- Create ForumPost table
CREATE TABLE ForumPost (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    postedBy VARCHAR(10) NOT NULL,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(50),
    viewCount INT DEFAULT 0,
    voteCount INT DEFAULT 0,
    picture VARCHAR(500),
    FOREIGN KEY (postedBy) REFERENCES UserAccount(userID)
);

-- Create ForumComment table
CREATE TABLE ForumComment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    postID INT NOT NULL,
    commentText TEXT NOT NULL,
    commentedBy VARCHAR(10) NOT NULL,
    commentedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    voteCount INT DEFAULT 0,
    FOREIGN KEY (postID) REFERENCES ForumPost(id) ON DELETE CASCADE,
    FOREIGN KEY (commentedBy) REFERENCES UserAccount(userID)
);

-- Create ForumCommentVote table

CREATE TABLE ForumCommentVote (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commentID INT,
    postID INT,
    userID VARCHAR(10) NOT NULL,
    voteValue INT NOT NULL,
    voteDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (commentID) REFERENCES ForumComment(id) ON DELETE CASCADE,
    FOREIGN KEY (postID) REFERENCES ForumPost(id) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID),
    CONSTRAINT UC_Comment_User UNIQUE (commentID, postID, userID),
    CONSTRAINT chk_vote_value CHECK (voteValue IN (1, -1))
);

-- Drop the existing unique index
ALTER TABLE ForumCommentVote
DROP INDEX UC_Comment_User;

-- Add the new unique constraint
ALTER TABLE ForumCommentVote
ADD CONSTRAINT UC_Comment_Or_Post_User UNIQUE (commentID, postID, userID);

-- Create UserActivityScore table
CREATE TABLE UserActivityScore (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) NOT NULL,
    totalComments INT,
    totalVotes INT,
    ranking INT,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);

-- Create TestTopScorer table
CREATE TABLE TestTopScorer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    testID INT NOT NULL,
    userID VARCHAR(10) NOT NULL,
    score INT,
    takenDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (testID) REFERENCES Tests(id),
    FOREIGN KEY (userID) REFERENCES UserAccount(userID),
    CONSTRAINT chk_score CHECK (score >= 0)
);
-- Create Achievements table
CREATE TABLE Achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userID VARCHAR(10) NOT NULL,
    achievementType VARCHAR(50) NOT NULL CHECK (achievementType IN ('TopActiveUser', 'HighTestScorer')),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    achievedDate DATE DEFAULT (CURRENT_DATE),
    relatedID INT,
    isActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (userID) REFERENCES UserAccount(userID)
);

-- Create Trigger EnsureJLPTOnly
DELIMITER //
CREATE TRIGGER EnsureJLPTOnly
AFTER INSERT ON TestTopScorer
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Tests t
        WHERE t.id = NEW.testID AND t.testType != 'JLPT'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'TestTopScorer chỉ lưu điểm cho bài test JLPT!';
    END IF;
END //
DELIMITER ;

-- Create Procedure AddTopActiveUserAchievements
DELIMITER //
CREATE PROCEDURE AddTopActiveUserAchievements()
BEGIN
    INSERT INTO Achievements (userID, achievementType, title, description, achievedDate, relatedID)
    SELECT 
        userID,
        'TopActiveUser',
        CONCAT('Top ', ranking, ' Người Chăm Chỉ Tháng ', MONTH(NOW()), '/', YEAR(NOW())),
        CONCAT('Đứng top ', ranking, ' người dùng hoạt động tích cực nhất tháng ', MONTH(NOW()), '/', YEAR(NOW()), ' với ', totalComments, ' bình luận và ', totalVotes, ' lượt vote'),
        NOW(),
        NULL
    FROM UserActivityScore
    WHERE ranking <= 5
    ORDER BY ranking ASC
    LIMIT 5;
END //
DELIMITER ;

-- Create Trigger AddHighTestScorerAchievement
DELIMITER //
CREATE TRIGGER AddHighTestScorerAchievement
AFTER INSERT ON TestTopScorer
FOR EACH ROW
BEGIN
    INSERT INTO Achievements (userID, achievementType, title, description, achievedDate, relatedID)
    SELECT 
        NEW.userID,
        'HighTestScorer',
        CONCAT('Điểm Cao JLPT ', t.jlptLevel),
        CONCAT('Đạt điểm ', NEW.score, ' trong bài test JLPT ', t.jlptLevel, ' vào ngày ', DATE_FORMAT(NEW.takenDate, '%d/%m/%Y')),
        CURRENT_DATE,
        NEW.id
    FROM Tests t
    WHERE t.id = NEW.testID
    AND NEW.score >= 90
    AND t.testType = 'JLPT';
END //
DELIMITER ;

-- INSERT DATA FOR JLEARNING DATABASE

-- 1. UserAccount (15 records)
INSERT INTO UserAccount (userID, fullName, username, email, password, role, profilePicture, phone, birthDate) VALUES
    ('U001', 'Trần Đình Qúy', 'quy123', 'quy123@gmail.com', 'password123', 'Student', '1.jpg', '1234567890', '1990-01-15'),
    ('U002', 'Trần Văn Tùng', 'tung123', 'tung123@gmail.com', 'password123', 'Teacher', '2.jpg', '0987654321', '1985-05-20'),
    ('U003', 'Lê Quốc Hùng', 'hung123', 'hung@gmail.com', 'password123', 'Student', '3.jpg', '1122334455', '1980-09-10'),
    ('U004', 'Phan Nguyễn Gia Huy', 'huy123', 'huy@gmail.com', 'password123', 'Coordinator', '4.jpg', '9988776655', '1992-12-25'),
    ('U005', 'Vũ Lê Duy', 'duy123', 'duy@gmail.com', 'password123', 'Admin', '5.jpg', '1231231230', '1988-07-30'),
    ('U006', 'Nguyễn Thị Mai', 'mai123', 'mai@gmail.com', 'password123', 'Student', '6.jpg', '0901234567', '1995-03-12'),
    ('U007', 'Phạm Văn Nam', 'nam123', 'nam@gmail.com', 'password123', 'Teacher', '7.jpg', '0912345678', '1983-11-08'),
    ('U008', 'Lê Thị Lan', 'lan123', 'lan@gmail.com', 'password123', 'Student', '8.jpg', '0923456789', '1998-06-22'),
    ('U009', 'Hoàng Văn Minh', 'minh123', 'minh@gmail.com', 'password123', 'Student', '9.jpg', '0934567890', '1997-02-14'),
    ('U010', 'Trần Thị Hoa', 'hoa123', 'hoa@gmail.com', 'password123', 'Teacher', '10.jpg', '0945678901', '1986-09-18'),
    ('U011', 'Võ Thị Thu', 'thu123', 'thu@gmail.com', 'password123', 'Student', '11.jpg', '0956789012', '1999-04-18'),
    ('U012', 'Đỗ Văn Khoa', 'khoa123', 'khoa@gmail.com', 'password123', 'Student', '12.jpg', '0967890123', '1996-08-07'),
    ('U013', 'Bùi Thị Linh', 'linh123', 'linh@gmail.com', 'password123', 'Student', '13.jpg', '0978901234', '1994-12-03'),
    ('U014', 'Ngô Văn Đức', 'duc123', 'duc@gmail.com', 'password123', 'Student', '14.jpg', '0989012345', '1993-10-15'),
    ('U015', 'Lý Thị An', 'an123', 'an@gmail.com', 'password123', 'Student', '15.jpg', '0990123456', '1991-05-28'),
    ('U016', 'Cao Thị Yến', 'yen123', 'yen@gmail.com', 'password123', 'Teacher', '16.jpg', '0901111111', '1982-03-25'),
    ('U017', 'Đinh Văn Sơn', 'son123', 'son@gmail.com', 'password123', 'Teacher', '17.jpg', '0902222222', '1984-07-12');

-- 2. Student (10 records)
INSERT INTO Student (studentID, userID, enrollmentDate, vote) VALUES
    ('S001', 'U001', '2024-01-15', 5),
    ('S002', 'U003', '2024-02-20', 8),
    ('S003', 'U006', '2024-03-10', 12),
    ('S004', 'U008', '2024-04-05', 3),
    ('S005', 'U009', '2024-05-12', 7),
    ('S006', 'U011', '2024-06-18', 15),
    ('S007', 'U012', '2024-07-22', 4),
    ('S008', 'U013', '2024-08-08', 9),
    ('S009', 'U014', '2024-09-14', 6),
    ('S010', 'U015', '2024-10-25', 11);

-- 3. Teacher (5 records)
INSERT INTO Teacher (teacherID, userID, specialization, experienceYears) VALUES
    ('T001', 'U002', 'Ngữ pháp tiếng Nhật', 8),
    ('T002', 'U007', 'Kanji và Từ vựng', 5),
    ('T003', 'U010', 'Hội thoại tiếng Nhật', 12),
    ('T004', 'U016', 'JLPT N1-N2', 10),
    ('T005', 'U017', 'Văn hóa Nhật Bản', 6);

-- 4. Courses (10 records)
INSERT INTO Courses (courseID, title, description, fee, duration, startDate, endDate, isActive) VALUES
    ('CO001', 'Tiếng Nhật Cơ Bản N5', 'Khóa học tiếng Nhật cho người mới bắt đầu', 2000000.00, 120, '2024-01-15', '2024-05-15', TRUE),
    ('CO002', 'Tiếng Nhật Trung Cấp N4', 'Khóa học tiếng Nhật trình độ trung cấp', 2500000.00, 150, '2024-02-01', '2024-07-01', TRUE),
    ('CO003', 'Tiếng Nhật Cao Cấp N3', 'Khóa học tiếng Nhật trình độ cao cấp', 3000000.00, 180, '2024-03-01', '2024-09-01', TRUE),
    ('CO004', 'JLPT N2 Luyện Thi', 'Khóa học luyện thi JLPT N2', 3500000.00, 200, '2024-04-01', '2024-11-01', TRUE),
    ('CO005', 'JLPT N1 Chuyên Sâu', 'Khóa học chuyên sâu cho JLPT N1', 4000000.00, 240, '2024-05-01', '2024-12-01', TRUE),
    ('CO006', 'Kanji Mastery', 'Khóa học chuyên về Kanji', 1800000.00, 100, '2024-06-01', '2024-09-01', TRUE),
    ('CO007', 'Hội Thoại Thực Tế', 'Khóa học hội thoại tiếng Nhật thực tế', 2200000.00, 80, '2024-07-01', '2024-09-01', TRUE),
    ('CO008', 'Văn Hóa Nhật Bản', 'Tìm hiểu văn hóa và xã hội Nhật Bản', 1500000.00, 60, '2024-08-01', '2024-10-01', TRUE),
    ('CO009', 'Tiếng Nhật Thương Mại', 'Tiếng Nhật cho môi trường công việc', 3200000.00, 160, '2024-09-01', '2025-01-01', TRUE),
    ('CO010', 'Luyện Nghe N3-N2', 'Khóa học chuyên luyện kỹ năng nghe', 1900000.00, 90, '2024-10-01', '2024-12-01', TRUE);

-- 5. Course_Enrollments (10 records)
INSERT INTO Course_Enrollments (studentID, courseID, enrollmentDate, completionDate) VALUES
    ('S001', 'CO001', '2024-01-20', '2024-05-20'),
    ('S002', 'CO002', '2024-02-05', NULL),
    ('S003', 'CO001', '2024-01-25', '2024-05-25'),
    ('S004', 'CO003', '2024-03-10', NULL),
    ('S005', 'CO002', '2024-02-15', NULL),
    ('S006', 'CO004', '2024-04-05', NULL),
    ('S007', 'CO003', '2024-03-20', NULL),
    ('S008', 'CO005', '2024-05-10', NULL),
    ('S009', 'CO001', '2024-01-30', '2024-05-30'),
    ('S010', 'CO006', '2024-06-05', NULL);

-- 6. Course_Reviews (10 records)
INSERT INTO Course_Reviews (courseID, userID, rating, reviewText, reviewDate) VALUES
    ('CO001', 'U001', 5, 'Khóa học rất hay, giảng viên nhiệt tình', '2024-05-25'),
    ('CO002', 'U003', 4, 'Nội dung phong phú, cần thêm bài tập', '2024-06-10'),
    ('CO001', 'U006', 5, 'Phù hợp cho người mới bắt đầu', '2024-05-28'),
    ('CO003', 'U008', 4, 'Khóa học chất lượng cao', '2024-07-15'),
    ('CO002', 'U009', 3, 'Tốc độ hơi nhanh với tôi', '2024-06-20'),
    ('CO004', 'U001', 5, 'Chuẩn bị thi JLPT rất tốt', '2024-08-01'),
    ('CO003', 'U003', 4, 'Giảng viên giải thích rõ ràng', '2024-07-20'),
    ('CO005', 'U006', 5, 'Khóa học chuyên sâu và hữu ích', '2024-09-01'),
    ('CO001', 'U008', 4, 'Bài học được sắp xếp logic', '2024-05-30'),
    ('CO006', 'U009', 5, 'Học Kanji hiệu quả', '2024-09-15');

-- 7. Lesson (10 records)
INSERT INTO Lesson (courseID, skill, title, description, mediaUrl, duration, isActive) VALUES
    ('CO001', 'Reading', 'Hiragana Cơ Bản', 'Học bảng chữ cái Hiragana', 'lesson1.mp4', 60, TRUE),
    ('CO001', 'Writing', 'Katakana Cơ Bản', 'Học bảng chữ cái Katakana', 'lesson2.mp4', 60, TRUE),
    ('CO001', 'Listening', 'Số Đếm 1-10', 'Học cách đếm số từ 1 đến 10', 'lesson3.mp4', 45, TRUE),
    ('CO001', 'Speaking', 'Chào Hỏi Cơ Bản', 'Các cách chào hỏi thông dụng', 'lesson4.mp4', 50, TRUE),
    ('CO002', 'Reading', 'Kanji Cơ Bản', '50 Kanji đầu tiên', 'lesson5.mp4', 90, TRUE),
    ('CO002', 'Writing', 'Ngữ Pháp て-form', 'Cách chia động từ dạng て', 'lesson6.mp4', 75, TRUE),
    ('CO002', 'Listening', 'Hội Thoại Mua Sắm', 'Giao tiếp khi đi mua sắm', 'lesson7.mp4', 65, TRUE),
    ('CO003', 'Speaking', 'Thể Kính Ngữ', 'Cách sử dụng thể kính ngữ', 'lesson8.mp4', 80, TRUE),
    ('CO003', 'Reading', 'Đọc Hiểu Văn Bản', 'Luyện đọc hiểu văn bản N3', 'lesson9.mp4', 100, TRUE),
    ('CO004', 'Writing', 'Viết Luận N2', 'Kỹ năng viết luận JLPT N2', 'lesson10.mp4', 120, TRUE);

-- 8. Progress (10 records)
INSERT INTO Progress (studentID, enrollmentID, lessonID, completionStatus, startDate, endDate, score, feedback) VALUES
    ('S001', 1, 1, 'complete', '2024-01-21', '2024-01-21', 85.5, 'Làm tốt, cần luyện thêm viết'),
    ('S001', 1, 2, 'complete', '2024-01-22', '2024-01-22', 90.0, 'Xuất sắc'),
    ('S001', 1, 3, 'in progress', '2024-01-23', NULL, NULL, NULL),
    ('S002', 2, 5, 'complete', '2024-02-06', '2024-02-06', 78.0, 'Cần ôn lại Kanji'),
    ('S002', 2, 6, 'in progress', '2024-02-07', NULL, NULL, NULL),
    ('S003', 3, 1, 'complete', '2024-01-26', '2024-01-26', 92.5, 'Rất tốt'),
    ('S003', 3, 2, 'complete', '2024-01-27', '2024-01-27', 88.0, 'Tiến bộ tốt'),
    ('S004', 4, 8, 'in progress', '2024-03-11', NULL, NULL, NULL),
    ('S005', 5, 5, 'complete', '2024-02-16', '2024-02-16', 82.0, 'Cần luyện thêm'),
    ('S006', 6, 10, 'in progress', '2024-04-06', NULL, NULL, NULL);

-- 9. Document (10 records)
INSERT INTO Document (lessonID, title, description, fileUrl, uploadDate, uploadedBy) VALUES
    (1, 'Bảng Hiragana PDF', 'Tài liệu bảng chữ cái Hiragana', 'hiragana.pdf', '2024-01-15', 'T001'),
    (2, 'Bảng Katakana PDF', 'Tài liệu bảng chữ cái Katakana', 'katakana.pdf', '2024-01-15', 'T001'),
    (3, 'Số Đếm Audio', 'File âm thanh luyện số đếm', 'numbers.mp3', '2024-01-15', 'T002'),
    (4, 'Hội Thoại Mẫu', 'Các mẫu hội thoại chào hỏi', 'greetings.pdf', '2024-01-15', 'T003'),
    (5, '50 Kanji Đầu Tiên', 'Danh sách 50 Kanji cơ bản', 'kanji50.pdf', '2024-02-01', 'T001'),
    (6, 'Bài Tập て-form', 'Bài tập luyện động từ dạng て', 'te-form.pdf', '2024-02-01', 'T002'),
    (7, 'Từ Vựng Mua Sắm', 'Từ vựng chủ đề mua sắm', 'shopping.pdf', '2024-02-01', 'T003'),
    (8, 'Kính Ngữ Cơ Bản', 'Tài liệu về kính ngữ', 'keigo.pdf', '2024-03-01', 'T001'),
    (9, 'Đề Đọc Hiểu N3', 'Bài tập đọc hiểu JLPT N3', 'reading-n3.pdf', '2024-03-01', 'T002'),
    (10, 'Mẫu Viết Luận', 'Các mẫu viết luận JLPT N2', 'essay-n2.pdf', '2024-04-01', 'T003');

-- 10. Exercise (10 records)
INSERT INTO Exercise (lessonID, title, description, dueDate, isActive) VALUES
    (1, 'Bài Tập Hiragana', 'Viết và đọc các ký tự Hiragana', '2024-01-25', TRUE),
    (2, 'Bài Tập Katakana', 'Viết và đọc các ký tự Katakana', '2024-01-28', TRUE),
    (3, 'Luyện Đếm Số', 'Bài tập về số đếm 1-10', '2024-01-30', TRUE),
    (4, 'Thực Hành Chào Hỏi', 'Bài tập hội thoại chào hỏi', '2024-02-02', TRUE),
    (5, 'Nhận Biết Kanji', 'Bài tập nhận biết 50 Kanji', '2024-02-10', TRUE),
    (6, 'Chia Động Từ て-form', 'Bài tập chia động từ', '2024-02-12', TRUE),
    (7, 'Hội Thoại Mua Sắm', 'Thực hành giao tiếp mua sắm', '2024-02-15', TRUE),
    (8, 'Sử Dụng Kính Ngữ', 'Bài tập về kính ngữ', '2024-03-10', TRUE),
    (9, 'Đọc Hiểu Văn Bản', 'Bài tập đọc hiểu N3', '2024-03-15', TRUE),
    (10, 'Viết Luận Ngắn', 'Bài tập viết luận N2', '2024-04-10', TRUE);

-- 11. Tests (10 records)
INSERT INTO Tests (testType, courseID, lessonID, title, description, jlptLevel, totalMarks, totalQuestions, dueDate, isActive) VALUES
    ('CourseTest', 'CO001', 1, 'Kiểm Tra Hiragana', 'Kiểm tra khả năng đọc viết Hiragana', NULL, 100, 20, '2024-02-01', TRUE),
    ('CourseTest', 'CO001', 3, 'Kiểm Tra Số Đếm', 'Kiểm tra việc đếm số', NULL, 50, 10, '2024-02-05', TRUE),
    ('CourseTest', 'CO002', 5, 'Kiểm Tra Kanji', 'Kiểm tra 50 Kanji cơ bản', NULL, 150, 30, '2024-02-20', TRUE),
    ('JLPT', NULL, NULL, 'JLPT N5 Thử', 'Bài thi thử JLPT N5', 'N5', 180, 60, '2024-12-01', TRUE),
    ('JLPT', NULL, NULL, 'JLPT N4 Thử', 'Bài thi thử JLPT N4', 'N4', 180, 60, '2024-12-01', TRUE),
    ('JLPT', NULL, NULL, 'JLPT N3 Thử', 'Bài thi thử JLPT N3', 'N3', 180, 60, '2024-12-01', TRUE),
    ('JLPT', NULL, NULL, 'JLPT N2 Thử', 'Bài thi thử JLPT N2', 'N2', 180, 60, '2024-12-01', TRUE),
    ('JLPT', NULL, NULL, 'JLPT N1 Thử', 'Bài thi thử JLPT N1', 'N1', 180, 60, '2024-12-01', TRUE),
    ('CourseTest', 'CO003', 8, 'Kiểm Tra Kính Ngữ', 'Kiểm tra sử dụng kính ngữ', NULL, 80, 16, '2024-03-20', TRUE),
    ('CourseTest', 'CO004', 10, 'Kiểm Tra Viết Luận', 'Kiểm tra kỹ năng viết', NULL, 120, 5, '2024-04-20', TRUE);

-- 12. Question (10 records)
INSERT INTO Question (exerciseID, testID, questionType, questionText, optionA, optionB, optionC, optionD, correctOption, essayAnswer, mark) VALUES
    (1, NULL, 'MultipleChoice', 'Ký tự あ đọc là gì?', 'a', 'i', 'u', 'e', 'A', NULL, 2),
    (1, NULL, 'MultipleChoice', 'Ký tự か đọc là gì?', 'ka', 'ki', 'ku', 'ke', 'A', NULL, 2),
    (2, NULL, 'MultipleChoice', 'Ký tự ア đọc là gì?', 'a', 'i', 'u', 'e', 'A', NULL, 2),
    (3, NULL, 'MultipleChoice', 'Số 5 bằng tiếng Nhật là?', 'go', 'roku', 'nana', 'hachi', 'A', NULL, 3),
    (NULL, 1, 'MultipleChoice', 'おはよう có nghĩa là gì?', 'Chào buổi sáng', 'Chào buổi chiều', 'Tạm biệt', 'Xin lỗi', 'A', NULL, 5),
    (NULL, 3, 'MultipleChoice', 'Kanji 人 có nghĩa là gì?', 'Người', 'Nhà', 'Ăn', 'Đi', 'A', NULL, 5),
    (4, NULL, 'Essay', 'Viết một đoạn hội thoại chào hỏi bằng tiếng Nhật', NULL, NULL, NULL, NULL, NULL, 'A: おはようございます。B: おはようございます。げんきですか。A: げんきです。ありがとうございます。', 10),
    (NULL, 4, 'Essay', 'Viết về sở thích của bản thân bằng tiếng Nhật (50 từ)', NULL, NULL, NULL, NULL, NULL, 'わたしのしゅみは...', 15),
    (5, NULL, 'MultipleChoice', 'Kanji 水 đọc là gì?', 'mizu', 'hi', 'ki', 'ishi', 'A', NULL, 4),
    (NULL, 2, 'MultipleChoice', 'Số 15 bằng tiếng Nhật là?', 'juugo', 'juuyon', 'juuroku', 'juunana', 'A', NULL, 3);

-- 13. Payment (10 records)
INSERT INTO Payment (studentID, enrollmentID, amount, paymentMethod, paymentStatus, paymentDate, transactionID) VALUES
    ('S001', 1, 2000000.00, 'Credit Card', 'Complete', '2024-01-20', 'TXN001'),
    ('S002', 2, 2500000.00, 'Bank Transfer', 'Complete', '2024-02-05', 'TXN002'),
    ('S003', 3, 2000000.00, 'Cash', 'Complete', '2024-01-25', 'TXN003'),
    ('S004', 4, 3000000.00, 'Credit Card', 'Pending', '2024-03-10', 'TXN004'),
    ('S005', 5, 2500000.00, 'Bank Transfer', 'Complete', '2024-02-15', 'TXN005'),
    ('S006', 6, 3500000.00, 'Credit Card', 'Complete', '2024-04-05', 'TXN006'),
    ('S007', 7, 3000000.00, 'Bank Transfer', 'Pending', '2024-03-20', 'TXN007'),
    ('S008', 8, 4000000.00, 'Cash', 'Complete', '2024-05-10', 'TXN008'),
    ('S009', 9, 2000000.00, 'Credit Card', 'Complete', '2024-01-30', 'TXN009'),
    ('S010', 10, 1800000.00, 'Bank Transfer', 'Cancell', '2024-06-05', 'TXN010');

-- 14. Class (3 records - incomplete in original, adjusted to match available IDs)
INSERT INTO Class (courseID, name, teacherID, studentID) VALUES
    ('CO001', 'Lớp N5-A Sáng', 'T001', 'S001'),
    ('CO002', 'Lớp N4-B Chiều', 'T002', 'S002'),
    ('CO003', 'Lớp N3-C Tối', 'T003', 'S004');

-- 15. Announcement (10 records)
INSERT INTO Announcement (title, content, postedDate, postedBy) VALUES
    ('Khai Giảng Khóa N5 Tháng 2', 'Thông báo khai giảng khóa học tiếng Nhật N5 vào ngày 1/2/2024', '2024-01-25', 'U004'),
    ('Lịch Thi JLPT Tháng 7', 'Kỳ thi JLPT tháng 7/2024 sẽ được tổ chức vào ngày 7/7/2024', '2024-05-15', 'U005'),
    ('Chương Trình Giảm Học Phí', 'Giảm 20% học phí cho học viên đăng ký sớm', '2024-01-10', 'U004'),
    ('Thay Đổi Lịch Học', 'Lịch học lớp N3-C chuyển từ 19h sang 20h', '2024-03-05', 'U005'),
    ('Kết Quả Thi Thử N2', 'Kết quả bài thi thử N2 đã được công bố', '2024-04-20', 'U004'),
    ('Nghỉ Lễ Tết Nguyên Đán', 'Trung tâm nghỉ từ 8/2 đến 15/2/2024', '2024-02-01', 'U005'),
    ('Workshop Văn Hóa Nhật', 'Tổ chức workshop về văn hóa Nhật Bản', '2024-06-01', 'U004'),
    ('Thi Thử JLPT Miễn Phí', 'Tổ chức thi thử JLPT miễn phí cho học viên', '2024-05-01', 'U005'),
    ('Khai Giảng Lớp Hội Thoại', 'Khai giảng lớp luyện hội thoại tiếng Nhật', '2024-07-01', 'U004'),
    ('Thông Báo Bảo Trì Hệ Thống', 'Hệ thống sẽ bảo trì từ 2h-4h sáng ngày 15/6', '2024-06-10', 'U005');

-- 16. Discount (7 records - incomplete in original, adjusted to match available courseIDs)
INSERT INTO Discount (code, courseID, discountPercent, startDate, endDate, isActive) VALUES
    ('NEWBIE2024', 'CO001', 20, '2024-01-01', '2024-03-31', TRUE),
    ('SUMMER2024', 'CO002', 15, '2024-06-01', '2024-08-31', TRUE),
    ('JLPTN3SALE', 'CO003', 25, '2024-04-01', '2024-06-30', TRUE),
    ('EARLYBIRD', 'CO004', 30, '2024-03-01', '2024-04-30', TRUE),
    ('PREMIUM2024', 'CO005', 10, '2024-05-01', '2024-12-31', TRUE),
    ('KANJI50', 'CO006', 40, '2024-06-01', '2024-07-31', TRUE),
    ('SPEAKING', 'CO007', 20, '2024-07-01', '2024-08-31', TRUE);

-- 17. ForumPost (10 records)
INSERT INTO ForumPost (title, content, postedBy, createdDate, category, viewCount, voteCount, picture)
VALUES
    ('Cách học Hiragana hiệu quả', 'Mọi người chia sẻ kinh nghiệm học Hiragana nhanh nhé!', 'U001', '2024-01-20 15:35:00', 'Ngữ pháp', 150, 10, 'uploads/hiragana.jpg'),
    ('Luyện thi N5 cần bao lâu?', 'Mình mới bắt đầu học, muốn thi N5 sau 6 tháng có được không?', 'U003', '2024-02-05 15:35:00', 'N5', 89, 5, NULL),
    ('Kanji khó nhớ quá!', 'Có ai có mẹo gì để nhớ Kanji lâu không ạ?', 'U006', '2024-02-15 15:35:00', 'Kanji', 234, 15, 'uploads/kanji.jpg'),
    ('Kinh nghiệm thi JLPT N3', 'Vừa thi N3 xong, chia sẻ một số kinh nghiệm', 'U008', '2024-03-01 15:35:00', 'N3', 167, 8, NULL),
    ('Phần nghe trong JLPT', 'Phần nghe của JLPT có khó không các bạn?', 'U009', '2024-03-10 15:35:00', 'Kinh nghiệm thi', 98, 3, 'uploads/listening.jpg'),
    ('Sách học tiếng Nhật hay', 'Giới thiệu một số cuốn sách học tiếng Nhật tốt', 'U001', '2024-03-20 15:35:00', 'Tài liệu', 145, 7, NULL),
    ('Văn hóa Nhật Bản thú vị', 'Chia sẻ về văn hóa Nhật mà mình biết được', 'U003', '2024-04-01 15:35:00', 'Văn hóa', 201, 12, 'uploads/culture.jpg'),
    ('Lỗi thường gặp khi học', 'Những lỗi mà người mới học thường mắc phải', 'U006', '2024-04-15 15:35:00', 'Ngữ pháp', 87, 4, NULL),
    ('Ứng dụng học tiếng Nhật', 'Các app học tiếng Nhật trên điện thoại', 'U008', '2024-05-01 15:35:00', 'Công cụ', 156, 6, 'uploads/apps.jpg'),
    ('Chuẩn bị cho N2', 'Bắt đầu chuẩn bị thi N2, cần lưu ý gì?', 'U009', '2024-05-10 15:35:00', 'N2', 78, 2, NULL);

-- 18. ForumComment (10 records)
INSERT INTO ForumComment (postID, commentText, commentedBy, commentedDate, voteCount) VALUES
    (1, 'Mình học bằng cách viết nhiều lần, rất hiệu quả!', 'U002', '2024-01-21', 5),
    (1, 'Nên học theo thứ tự a-ka-sa-ta-na...', 'U004', '2024-01-22', 3),
    (2, '6 tháng hơi gấp đấy, nên học 8-10 tháng cho chắc', 'U005', '2024-02-06', 7),
    (3, 'Mình dùng flashcard, rất hay!', 'U007', '2024-02-16', 4),
    (4, 'Cảm ơn bạn đã chia sẻ, rất hữu ích!', 'U010', '2024-03-02', 8),
    (5, 'Phần nghe khó nhất là nghe nhanh và phát âm âm thanh', 'U002', '2024-03-11', 6),
    (6, 'Mina no Nihongo rất tốt cho người mới bắt đầu', 'U004', '2024-03-21', 9),
    (7, 'Văn hóa cúi chào rất thú vị và lịch sự', 'U005', '2024-04-02', 2),
    (8, 'Lỗi chia động từ là phổ biến nhất', 'U007', '2024-04-16', 5);

-- 19. UserActivityScore (10 records)
INSERT INTO UserActivityScore (userID, totalComments, totalVotes, ranking)
VALUES
    ('U001', 15, 10, 1),
    ('U002', 10, 5, 2),
    ('U003', 8, 3, 3),
    ('U004', 12, 7, 4),
    ('U005', 5, 2, 5),
    ('U006', 20, 15, 1),
    ('U007', 7, 4, 6),
    ('U008', 9, 6, 7),
    ('U009', 11, 8, 8),
    ('U010', 6, 3, 9);