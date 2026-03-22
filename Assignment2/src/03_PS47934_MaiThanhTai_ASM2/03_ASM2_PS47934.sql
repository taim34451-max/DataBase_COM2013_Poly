/*
==========================================================
MÔN: CƠ SỞ DỮ LIỆU (COM2013)
ASSIGNMENT – GIAI ĐOẠN 2
Họ tên: MAI THÀNH TÀI
MSSV: PS47934
==========================================================
*/

-- ======================================================
-- 1. TẠO CƠ SỞ DỮ LIỆU
-- ======================================================

CREATE DATABASE IF NOT EXISTS QuanLyMuonSach;
USE QuanLyMuonSach;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS ChiTietPhieuMuon;
DROP TABLE IF EXISTS PhieuMuon;
DROP TABLE IF EXISTS Sach;
DROP TABLE IF EXISTS SinhVien;
DROP TABLE IF EXISTS LoaiSach;
SET FOREIGN_KEY_CHECKS = 1;

-- ======================================================
-- Y4. TẠO BẢNG VÀ RÀNG BUỘC
-- ======================================================

-- 1. Bảng LoaiSach
CREATE TABLE LoaiSach (
    MaLoai VARCHAR(10) PRIMARY KEY,
    TenLoai VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 2. Bảng SinhVien
CREATE TABLE SinhVien (
    MaSV VARCHAR(10) PRIMARY KEY,
    TenSV VARCHAR(50) NOT NULL,
    NgayHetHan DATE,
    ChuyenNganh VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    SDT VARCHAR(15) UNIQUE
) ENGINE=InnoDB;

-- 3. Bảng Sach
CREATE TABLE Sach (
    MaSach VARCHAR(10) PRIMARY KEY,
    TieuDe VARCHAR(100) NOT NULL,
    NhaXuatBan VARCHAR(50),
    TacGia VARCHAR(50),
    SoTrang INT,
    SoLuongBanSao INT,
    GiaTien DECIMAL(10,2),
    NgayNhapKho DATE,
    ViTri VARCHAR(50),
    MaLoai VARCHAR(10),
    CONSTRAINT FK_Sach_Loai FOREIGN KEY (MaLoai)
        REFERENCES LoaiSach(MaLoai),
    CONSTRAINT CHK_Sach CHECK (
        SoTrang > 5 AND 
        SoLuongBanSao >= 1 AND 
        GiaTien > 0
    )
) ENGINE=InnoDB;

-- 4. Bảng PhieuMuon
CREATE TABLE PhieuMuon (
    SoPhieu INT AUTO_INCREMENT PRIMARY KEY,
    MaSV VARCHAR(10),
    NgayMuon DATE,
    NgayPhaiTra DATE,
    TrangThai VARCHAR(20) DEFAULT 'Chưa trả',
    CONSTRAINT FK_PM_SV FOREIGN KEY (MaSV)
        REFERENCES SinhVien(MaSV),
    CONSTRAINT CHK_Ngay CHECK (NgayPhaiTra >= NgayMuon)
) ENGINE=InnoDB;

-- 5. Bảng ChiTietPhieuMuon
CREATE TABLE ChiTietPhieuMuon (
    SoPhieu INT,
    MaSach VARCHAR(10),
    GhiChu VARCHAR(100),
    PRIMARY KEY (SoPhieu, MaSach),
    FOREIGN KEY (SoPhieu)
        REFERENCES PhieuMuon(SoPhieu)
        ON DELETE CASCADE,
    FOREIGN KEY (MaSach)
        REFERENCES Sach(MaSach)
) ENGINE=InnoDB;

-- ======================================================
-- Y5. NHẬP DỮ LIỆU MẪU (≥ 5 bản ghi mỗi bảng)
-- ======================================================

INSERT INTO LoaiSach VALUES
('IT','Công nghệ thông tin'),
('KT','Kinh tế'),
('DL','Du lịch'),
('NN','Ngoại ngữ'),
('VH','Văn học');

INSERT INTO SinhVien VALUES
('PS47934','MAI THÀNH TÀI','2027-01-01','Phát triển phần mềm','taimt@fpt.edu.vn','0901234567'),
('PD12301','Nguyễn Văn Tèo','2026-12-31','Thiết kế đồ họa','teonv@fpt.edu.vn','0909876543'),
('PS12345','Trần Văn Tí','2025-06-01','Ứng dụng phần mềm','titv@fpt.edu.vn','0912345678'),
('PK00001','Lê Thị Na','2026-09-01','Marketing','nalt@fpt.edu.vn','0933333333'),
('PS99999','Phạm Văn Mách','2025-05-20','Quản trị','machpv@fpt.edu.vn','0944444444');

INSERT INTO Sach VALUES
('IT001','Lập trình Java','NXB GD','Nguyễn Văn A',100,15,50000,'2013-05-20','Kệ A1','IT'),
('IT002','SQL Cơ Bản','NXB TK','Trần Thị B',200,5,120000,'2016-01-15','Kệ A2','IT'),
('KT001','Kinh tế vi mô','NXB LĐ','Lê Văn C',150,10,80000,'2017-02-10','Kệ B1','KT'),
('DL001','Hướng dẫn du lịch','NXB DL','Phạm Văn D',90,20,45000,'2015-11-20','Kệ C1','DL'),
('IT003','Cấu trúc dữ liệu','NXB BK','Đỗ Văn E',300,3,150000,'2009-01-01','Kệ A3','IT');

INSERT INTO PhieuMuon (MaSV,NgayMuon,NgayPhaiTra,TrangThai) VALUES
('PS47934','2017-01-05','2017-01-12','Đã trả'),
('PD12301','2026-02-01','2026-02-08','Chưa trả'),
('PS12345','2009-12-20','2009-12-27','Đã trả'),
('PK00001','2026-01-10','2026-01-17','Chưa trả'),
('PS47934','2026-02-09','2026-02-16','Chưa trả');

INSERT INTO ChiTietPhieuMuon VALUES
(1,'IT001','Mới'),
(1,'IT002','Kèm CD'),
(2,'KT001','Tốt'),
(3,'IT003','Rách bìa'),
(4,'DL001','Mới');

-- ======================================================
-- Y6. TRUY VẤN DỮ LIỆU
-- ======================================================

-- 6.1 Liệt kê sách loại IT
SELECT MaSach,TieuDe,GiaTien,TacGia
FROM Sach
WHERE MaLoai='IT';

-- 6.2 Phiếu mượn tháng 01/2017
SELECT PM.SoPhieu,CT.MaSach,PM.NgayMuon,PM.MaSV
FROM PhieuMuon PM
JOIN ChiTietPhieuMuon CT ON PM.SoPhieu=CT.SoPhieu
WHERE MONTH(PM.NgayMuon)=1 AND YEAR(PM.NgayMuon)=2017;

-- 6.3 Phiếu mượn chưa trả
SELECT *
FROM PhieuMuon
WHERE TrangThai='Chưa trả'
ORDER BY NgayMuon ASC;

-- 6.4 Tổng số lượng bản sao theo loại
SELECT L.MaLoai,L.TenLoai,
       IFNULL(SUM(S.SoLuongBanSao),0) AS TongSoBanSao
FROM LoaiSach L
LEFT JOIN Sach S ON L.MaLoai=S.MaLoai
GROUP BY L.MaLoai,L.TenLoai;

-- 6.5 Tổng lượt mượn
SELECT COUNT(*) AS TongLuotMuon
FROM PhieuMuon;

-- 6.6 Sách có tiêu đề chứa “SQL”
SELECT *
FROM Sach
WHERE TieuDe LIKE '%SQL%';

-- 6.7 Chi tiết sinh viên mượn sách
SELECT SV.MaSV,SV.TenSV,PM.SoPhieu,
       S.TieuDe,PM.NgayMuon,PM.NgayPhaiTra
FROM PhieuMuon PM
JOIN SinhVien SV ON PM.MaSV=SV.MaSV
JOIN ChiTietPhieuMuon CT ON PM.SoPhieu=CT.SoPhieu
JOIN Sach S ON CT.MaSach=S.MaSach
ORDER BY PM.NgayMuon ASC;

-- 6.8 Sách mượn hơn 20 lần
SELECT S.TieuDe, COUNT(*) AS SoLuotMuon
FROM Sach S
JOIN ChiTietPhieuMuon CT ON S.MaSach=CT.MaSach
GROUP BY S.TieuDe
HAVING COUNT(*)>20;

-- 6.9 Giảm giá 30% sách trước năm 2014
UPDATE Sach
SET GiaTien=GiaTien*0.7
WHERE YEAR(NgayNhapKho)<2014;

-- 6.10 Cập nhật trả sách cho sinh viên PD12301
UPDATE PhieuMuon
SET TrangThai='Đã trả'
WHERE MaSV='PD12301' AND TrangThai='Chưa trả';

-- 6.11 Danh sách phiếu mượn quá hạn
SELECT PM.SoPhieu,SV.TenSV,SV.Email,PM.NgayMuon
FROM PhieuMuon PM
JOIN SinhVien SV ON PM.MaSV=SV.MaSV
WHERE PM.TrangThai='Chưa trả'
AND PM.NgayPhaiTra<CURDATE();

-- 6.12 Tăng 5 bản sao cho sách mượn >10 lần
UPDATE Sach S
JOIN (
   SELECT MaSach
   FROM ChiTietPhieuMuon
   GROUP BY MaSach
   HAVING COUNT(*)>10
) T ON S.MaSach=T.MaSach
SET S.SoLuongBanSao=S.SoLuongBanSao+5;

-- 6.13 Xóa phiếu mượn trước năm 2010
DELETE FROM PhieuMuon
WHERE NgayMuon<'2010-01-01'
AND NgayPhaiTra<'2010-01-01';