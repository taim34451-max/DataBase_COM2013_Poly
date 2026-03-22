/*
========================================================
LAB 8 - CHỈ MỤC INDEX – CÁC THAO TÁC SAO LƯU DỰ PHÒNG
Họ và tên : Mai Thanh Tài
MSSV      : PS47934
========================================================
*/

USE QuanLyBanHang;

-- ===============================
-- PHẦN I
-- Bài 1 (4 điểm)
-- ===============================

-- a. Tạo chỉ mục UNIQUE trên cột điện thoại
CREATE UNIQUE INDEX idx_KhachHang_dienThoai
ON KhachHang(dienThoai);

-- b. Tạo chỉ mục UNIQUE trên cột email
CREATE UNIQUE INDEX idx_KhachHang_email
ON KhachHang(email);

-- Kiểm tra index
SHOW INDEX FROM KhachHang;


-- ===============================
-- PHẦN II
-- Bài 2 (4 điểm)
-- ===============================

-- Sao lưu database ra file .sql (chạy trong CMD)
-- mysqldump -u root -p QuanLyBanHang > QuanLyBanHang_backup.sql

-- Import phục hồi database
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- mysql -u root -p QuanLyBanHang < QuanLyBanHang_backup.sql

-- Kiểm tra dữ liệu sau khi import
SHOW TABLES;
SELECT * FROM KhachHang;
SELECT * FROM SanPham;
SELECT * FROM HoaDon;
SELECT * FROM HoaDonChiTiet;