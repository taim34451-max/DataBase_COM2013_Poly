/*
==========================================================
MÔN: CƠ SỞ DỮ LIỆU (COM2013)
ASSIGNMENT FINAL
Họ tên: MAI THÀNH TÀI
MSSV: PS47934
==========================================================
*/

/* ==========================================================
   Y1. PHÂN TÍCH BÀI TOÁN – XÁC ĐỊNH THỰC THỂ & THUỘC TÍNH
   ==========================================================

   1. Thực thể CATEGORY (Loại sách)
      - LoaiID (Primary Key)
      - TenLoai

   2. Thực thể BOOK (Sách)
      - MaSach (Primary Key)
      - TenSach
      - NhaXuatBan
      - TacGia
      - SoTrang ( > 5 )
      - SoLuongBanSao ( > 0 )
      - GiaNhapKho ( > 0 )
      - LoaiID (Foreign Key → Category)

   3. Thực thể STUDENT (Sinh viên)
      - MaSV (Primary Key)
      - TenSV
      - Nganh
      - Email
      - SoDienThoai

   4. Thực thể LOAN (Phiếu mượn)
      - MaPhieu (Primary Key – Identity)
      - MaSV (Foreign Key → Student)
      - NgayMuon
      - NgayTraPhai
      - TrangThai

   5. Thực thể LOAN_DETAIL (Chi tiết phiếu mượn)
      - MaPhieu (Primary Key, FK → Loan)
      - MaSach (Primary Key, FK → Book)
      - SoLuong (≤ 3 quyển theo yêu cầu đề)

   ==========================================================

   Y2. THIẾT KẾ SƠ ĐỒ QUAN HỆ ERD
   ==========================================================

   - CATEGORY (1) —— (N) BOOK
       Một loại sách có nhiều sách.

   - STUDENT (1) —— (N) LOAN
       Một sinh viên có nhiều phiếu mượn.

   - LOAN (1) —— (N) LOAN_DETAIL

   - BOOK (1) —— (N) LOAN_DETAIL

   → Quan hệ giữa STUDENT và BOOK là quan hệ N-N
     được tách thành 2 bảng trung gian:
     LOAN và LOAN_DETAIL.

   ==========================================================

   Y3. CHUẨN HÓA CƠ SỞ DỮ LIỆU
   ==========================================================

   1NF:
   - Không có thuộc tính lặp.
   - Mỗi ô chứa giá trị nguyên tố.
   → Đạt chuẩn 1NF.

   2NF:
   - Các thuộc tính không khóa phụ thuộc hoàn toàn
     vào khóa chính.
   - LoanDetail có khóa kép (MaPhieu, MaSach).
   - SoLuong phụ thuộc toàn bộ khóa kép.
   → Đạt chuẩn 2NF.

   3NF:
   - Không có phụ thuộc bắc cầu.
   - TenLoai không lưu trong bảng Book
     mà tham chiếu qua LoaiID.
   → Đạt chuẩn 3NF.

========================================================== */

/* ==========================================================
   Y4. TẠO DATABASE & TABLE (MySQL)
========================================================== */

DROP DATABASE IF EXISTS QuanLyThuVien;
CREATE DATABASE QuanLyThuVien
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE QuanLyThuVien;

CREATE TABLE Category(
    LoaiID INT PRIMARY KEY,
    TenLoai VARCHAR(100) NOT NULL
);

CREATE TABLE Book(
    MaSach VARCHAR(10) PRIMARY KEY,
    TenSach VARCHAR(200) NOT NULL,
    NhaXuatBan VARCHAR(100),
    TacGia VARCHAR(100),
    SoTrang INT CHECK (SoTrang > 5),
    SoLuongBanSao INT CHECK (SoLuongBanSao >= 0),
    GiaNhapKho DECIMAL(12,2) CHECK (GiaNhapKho > 0),
    LoaiID INT NOT NULL,
    CONSTRAINT fk_book_category
        FOREIGN KEY (LoaiID) REFERENCES Category(LoaiID)
);

CREATE TABLE Student(
    MaSV VARCHAR(10) PRIMARY KEY,
    TenSV VARCHAR(100) NOT NULL,
    Nganh VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    SoDienThoai VARCHAR(15)
);

CREATE TABLE Loan(
    MaPhieu INT AUTO_INCREMENT PRIMARY KEY,
    MaSV VARCHAR(10) NOT NULL,
    NgayMuon DATE NOT NULL,
    NgayTraPhai DATE NOT NULL,
    TrangThai VARCHAR(50) DEFAULT 'Chưa trả',
    CONSTRAINT ck_ngay CHECK (NgayTraPhai >= NgayMuon),
    CONSTRAINT fk_loan_student
        FOREIGN KEY (MaSV) REFERENCES Student(MaSV)
);

CREATE TABLE LoanDetail(
    MaPhieu INT,
    MaSach VARCHAR(10),
    SoLuong INT CHECK (SoLuong BETWEEN 1 AND 3),
    PRIMARY KEY (MaPhieu, MaSach),
    CONSTRAINT fk_ld_loan
        FOREIGN KEY (MaPhieu) REFERENCES Loan(MaPhieu)
        ON DELETE CASCADE,
    CONSTRAINT fk_ld_book
        FOREIGN KEY (MaSach) REFERENCES Book(MaSach)
);

/* ==========================================================
   Y5. INSERT DATA
========================================================== */

INSERT INTO Category VALUES
(1,'Công nghệ thông tin'),
(2,'Kinh tế'),
(3,'Du lịch'),
(4,'Văn học'),
(5,'Ngoại ngữ');

INSERT INTO Book VALUES
('S01','Lập trình C#','NXB Trẻ','Nguyễn Văn A',200,10,120000,1),
('S02','Quản trị kinh doanh','NXB Lao Động','Trần Văn B',150,5,150000,2),
('S03','Du lịch Việt Nam','NXB Du lịch','Lê Văn C',120,7,90000,3),
('S04','Truyện Kiều','NXB Văn học','Nguyễn Du',300,8,110000,4),
('S05','Tiếng Anh cơ bản','NXB Giáo dục','Phạm Văn D',180,12,100000,5);

INSERT INTO Student VALUES
('SV01','Nguyễn Văn Nam','CNTT','nam@gmail.com','0901111111'),
('SV02','Trần Thị Lan','QTKD','lan@gmail.com','0902222222'),
('SV03','Lê Văn Minh','Du lịch','minh@gmail.com','0903333333'),
('SV04','Phạm Thị Hoa','Văn học','hoa@gmail.com','0904444444'),
('SV05','Đỗ Văn Hùng','Ngoại ngữ','hung@gmail.com','0905555555');

INSERT INTO Loan(MaSV,NgayMuon,NgayTraPhai,TrangThai) VALUES
('SV01','2017-01-05','2017-01-12','Đã trả'),
('SV02','2024-01-10','2024-01-17','Chưa trả'),
('SV03','2023-05-01','2023-05-10','Đã trả'),
('SV04','2024-02-01','2024-02-10','Chưa trả'),
('SV05','2024-03-01','2024-03-08','Chưa trả');

INSERT INTO LoanDetail VALUES
(1,'S01',1),
(1,'S02',1),
(2,'S03',2),
(3,'S04',1),
(4,'S05',1);

/* ==========================================================
   Y6. TRUY VẤN (MySQL)
========================================================== */

-- 1
SELECT MaSach, TenSach, LoaiID, GiaNhapKho, TacGia FROM Book;

-- 2
SELECT L.MaPhieu, S.TenSV, B.TenSach, L.NgayMuon
FROM Loan L
JOIN Student S ON L.MaSV = S.MaSV
JOIN LoanDetail LD ON L.MaPhieu = LD.MaPhieu
JOIN Book B ON LD.MaSach = B.MaSach
WHERE MONTH(L.NgayMuon) = 1 AND YEAR(L.NgayMuon) = 2017;

-- 3
SELECT * FROM Loan
WHERE TrangThai = 'Chưa trả'
ORDER BY NgayMuon ASC;

-- 4
SELECT C.TenLoai, COUNT(B.MaSach) AS TongSach
FROM Category C
LEFT JOIN Book B ON C.LoaiID = B.LoaiID
GROUP BY C.TenLoai;

-- 5
SELECT S.TenSV, COUNT(L.MaPhieu) AS SoLanMuon
FROM Student S
LEFT JOIN Loan L ON S.MaSV = L.MaSV
GROUP BY S.TenSV;

-- 6
ALTER TABLE Loan ADD COLUMN GhiChu VARCHAR(200);

-- 7
SELECT S.MaSV, S.TenSV, L.MaPhieu, L.NgayMuon, L.NgayTraPhai
FROM Student S
JOIN Loan L ON S.MaSV = L.MaSV;

-- 8
SELECT B.TenSach, COUNT(*) AS SoLanMuon
FROM LoanDetail LD
JOIN Book B ON LD.MaSach = B.MaSach
GROUP BY B.TenSach
HAVING COUNT(*) >= 1;

-- 9
UPDATE Loan SET TrangThai = 'Đã trả'
WHERE MaSV = 'SV02';

-- 10
SELECT * FROM Loan
WHERE NgayTraPhai < CURDATE()
AND TrangThai = 'Chưa trả';

-- 11
UPDATE Student SET Email = 'updated@gmail.com'
WHERE MaSV = 'SV01';

-- 12
SELECT B.TenSach, COUNT(*) AS LuotMuon
FROM LoanDetail LD
JOIN Book B ON LD.MaSach = B.MaSach
GROUP BY B.TenSach
HAVING COUNT(*) >= 1;

-- 13
DELETE FROM Loan
WHERE NgayMuon < '2010-01-01';

/* ==========================================================
   Y7. BACKUP (MySQL)
========================================================== */
/*
Thực hiện bằng command:

mysqldump -u root -p QuanLyThuVien > QuanLyThuVien.sql

*/