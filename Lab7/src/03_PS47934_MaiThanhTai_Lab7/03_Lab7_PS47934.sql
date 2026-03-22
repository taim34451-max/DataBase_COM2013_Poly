/*
====================================================
LAB 7 - NGÔN NGỮ THAO TÁC DỮ LIỆU (DML)
Họ và tên: Mai Thanh Tài
MSSV: PS47934
====================================================
*/

USE QuanLyBanHang;

-- ==================================================
-- PHẦN I
-- Bài 1 (4 điểm): Viết các câu DML để thực hiện
-- ==================================================

-- a. Sử dụng câu lệnh INSERT để thêm dữ liệu vào các bảng

-- Thêm dữ liệu bảng KhachHang
INSERT INTO KhachHang (maKhachHang, hoVaTenLot, Ten, diaChi, email, dienThoai) VALUES
('KH001', 'Nguyễn Thị', 'Nga', '15 Quang Trung TP Đà Nẵng', 'ngant@gmail.com', '0912345670'),
('KH002', 'Trần Công', 'Thành', '234 Lê Lợi Quảng Nam', 'thanhtc@gmail.com', '16109423443'),
('KH003', 'Lê Hoàng', 'Nam', '23 Trần Phú TP Huế', 'namlt@yahoo.com', '0989354556'),
('KH004', 'Vũ Ngọc', 'Hiền', '37 Nguyễn Thị Thập TP Đà Nẵng', 'hienvn@gmail.com', '0894545435');

-- Thêm dữ liệu bảng SanPham
INSERT INTO SanPham (maSanPham, tenSanPham, moTa, soLuong, donGia) VALUES
(1, 'Samsung Galaxy J7 Pro', 'Smartphone pin tốt, hệ điều hành mới.', 800, 6600000),
(2, 'iPhone 6 32GB', 'iPhone 6 bản 32GB chính hãng.', 500, 8990000),
(3, 'Laptop Dell Inspiron 3467', 'Dell Inspiron i3, RAM 4GB, HDD 1TB.', 507, 11290000),
(4, 'Pin sạc dự phòng', 'Pin sạc Polymer 5000mAh.', 600, 200000),
(5, 'Nokia 3100', 'Điện thoại phù hợp cho sinh viên.', 100, 700000);

-- Thêm dữ liệu bảng HoaDon
INSERT INTO HoaDon (maHoaDon, maKhachHang, ngayMuaHang, trangThai) VALUES
(120954, 'KH001', '2016-03-23', 'Đã thanh toán'),
(120955, 'KH002', '2016-04-02', 'Đã thanh toán'),
(120956, 'KH001', '2016-07-12', 'Chưa thanh toán'),
(125957, 'KH004', '2016-12-04', 'Chưa thanh toán');

-- Thêm dữ liệu bảng HoaDonChiTiet
INSERT INTO HoaDonChiTiet (maHoaDonChiTiet, maHoaDon, maSanPham, soLuong) VALUES
(1, 120954, 3, 40),
(2, 120954, 1, 20),
(3, 120955, 2, 100),
(4, 120956, 4, 6),
(5, 120956, 2, 60),
(6, 120956, 1, 10),
(7, 125957, 2, 50);

-- b. Tạo bảng KhachHang_daNang chứa thông tin đầy đủ các khách hàng đến từ Đà Nẵng

DROP TABLE IF EXISTS KhachHang_daNang;

CREATE TABLE KhachHang_daNang AS
SELECT *
FROM KhachHang
WHERE diaChi LIKE '%Đà Nẵng%';


-- ==================================================
-- PHẦN II
-- Bài 2 (4 điểm): Viết các câu lệnh để cập nhật lại dữ liệu cho các bảng
-- ==================================================

-- a. Cập nhật lại thông tin số điện thoại của khách hàng có mã ‘KH002’ 
--    có giá trị mới là ‘16267788989’

UPDATE KhachHang
SET dienThoai = '16267788989'
WHERE maKhachHang = 'KH002';


-- b. Tăng số lượng mặt hàng có mã ‘3’ lên thêm ‘200’ đơn vị

UPDATE SanPham
SET soLuong = soLuong + 200
WHERE maSanPham = 3;


-- c. Giảm giá cho tất cả sản phẩm giảm 5%

UPDATE SanPham
SET donGia = donGia * 0.95;


-- d. Tăng số lượng của mặt hàng bán chạy nhất trong tháng 12/2016 lên 100 đơn vị

UPDATE SanPham
SET soLuong = soLuong + 100
WHERE maSanPham = (
    SELECT maSanPham FROM (
        SELECT CT.maSanPham
        FROM HoaDonChiTiet CT
        JOIN HoaDon HD ON CT.maHoaDon = HD.maHoaDon
        WHERE MONTH(HD.ngayMuaHang) = 12
          AND YEAR(HD.ngayMuaHang) = 2016
        GROUP BY CT.maSanPham
        ORDER BY SUM(CT.soLuong) DESC
        LIMIT 1
    ) AS T
);


-- e. Giảm giá 10% cho 2 sản phẩm bán ít nhất trong năm 2016

UPDATE SanPham
SET donGia = donGia * 0.9
WHERE maSanPham IN (
    SELECT maSanPham FROM (
        SELECT CT.maSanPham
        FROM HoaDonChiTiet CT
        JOIN HoaDon HD ON CT.maHoaDon = HD.maHoaDon
        WHERE YEAR(HD.ngayMuaHang) = 2016
        GROUP BY CT.maSanPham
        ORDER BY SUM(CT.soLuong) ASC
        LIMIT 2
    ) AS T2
);


-- f. Cập nhật lại trạng thái “đã thanh toán” cho hoá đơn có mã 120956

UPDATE HoaDon
SET trangThai = 'Đã thanh toán'
WHERE maHoaDon = 120956;


-- g. Xoá mặt hàng có mã sản phẩm là ‘2’ ra khỏi hoá đơn ‘120956’
--    và trạng thái là chưa thanh toán

DELETE CT
FROM HoaDonChiTiet CT
JOIN HoaDon HD ON CT.maHoaDon = HD.maHoaDon
WHERE CT.maSanPham = 2
  AND HD.maHoaDon = 120956
  AND HD.trangThai = 'Chưa thanh toán';


-- h. Xoá khách hàng chưa từng mua hàng kể từ ngày “1-1-2016”

DELETE KH
FROM KhachHang KH
WHERE NOT EXISTS (
    SELECT 1
    FROM HoaDon HD
    WHERE HD.maKhachHang = KH.maKhachHang
      AND HD.ngayMuaHang >= '2016-01-01'
);