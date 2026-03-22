/*
   BÀI LAB 6 - TRUY VẤN DỮ LIỆU TRÊN NHIỀU BẢNG
   Họ và tên: Mai Thành Tài
   MSSV: PS47934
   Lớp: COM2013_SD21303
*/

USE QuanLyBanHang;

-- =============================================
-- PHẦN I
-- =============================================

-- a Hiển thị tất cả thông tin có trong 2 bảng Hoá đơn và Hoá đơn chi tiết gồm các cột sau:
--  maHoaDon, maKhachHang, trangThai, maSanPham, soLuong, ngayMua
SELECT 
    HD.maHoaDon, 
    HD.maKhachHang, 
    HD.trangThai, 
    CT.maSanPham, 
    CT.soLuong, 
    HD.ngayMuaHang
FROM HoaDon HD
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon;

-- b Hiển thị tất cả thông tin có trong 2 bảng Hoá đơn và Hoá đơn chi tiết gồm các cột sau: 
-- maHoaDon, maKhachHang, trangThai, maSanPham, soLuong, ngayMua với điều kiện maKhachHang = ‘KH001’
SELECT 
    HD.maHoaDon, 
    HD.maKhachHang, 
    HD.trangThai, 
    CT.maSanPham, 
    CT.soLuong, 
    HD.ngayMuaHang
FROM HoaDon HD
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon
WHERE HD.maKhachHang = 'KH001';

-- c Hiển thị thông tin từ 3 bảng Hoá đơn, Hoá đơn chi tiết và Sản phẩm gồm các cột sau:
-- maHoaDon, ngayMua, tenSP, donGia, soLuong mua trong hoá đơn, thành tiền. Với thành tiền= donGia* soLuong
SELECT 
    HD.maHoaDon, 
    HD.ngayMuaHang, 
    SP.tenSanPham, 
    SP.donGia, 
    CT.soLuong, 
    (SP.donGia * CT.soLuong) AS thanhTien
FROM HoaDon HD
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon
JOIN SanPham SP 
    ON CT.maSanPham = SP.maSanPham;

-- d Hiển thị thông tin từ bảng khách hàng, bảng hoá đơn, hoá đơn chi tiết gồm các cột:
-- họ và tên khách hàng, email, điện thoại, mã hoá đơn, trạng thái hoá đơn và tổng tiền đã mua trong hoá đơn.
-- Chỉ hiển thị thông tin các hoá đơn chưa thanh toán.
SELECT 
    KH.maKhachHang,
    CONCAT(KH.hoVaTenLot, ' ', KH.Ten) AS hoVaTen,
    KH.email, 
    KH.dienThoai, 
    HD.maHoaDon, 
    HD.trangThai,
    SUM(CT.soLuong * SP.donGia) AS tongTienDaMua
FROM KhachHang KH
JOIN HoaDon HD 
    ON KH.maKhachHang = HD.maKhachHang
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon
JOIN SanPham SP 
    ON CT.maSanPham = SP.maSanPham
WHERE HD.trangThai = 'Chưa thanh toán'
GROUP BY 
    KH.maKhachHang, 
    KH.hoVaTenLot, 
    KH.Ten, 
    KH.email, 
    KH.dienThoai, 
    HD.maHoaDon, 
    HD.trangThai;

-- e Hiển thị maHoaDon, ngàyMuahang, tổng số tiền đã mua trong từng hoá đơn.
-- Chỉ hiển thị những hóa đơn có tổng số tiền >=500.000 và sắp xếp theo thứ tự giảm dần của cột tổng tiền. 
SELECT 
    HD.maHoaDon, 
    HD.ngayMuaHang, 
    SUM(CT.soLuong * SP.donGia) AS tongTien
FROM HoaDon HD
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon
JOIN SanPham SP 
    ON CT.maSanPham = SP.maSanPham
GROUP BY HD.maHoaDon, HD.ngayMuaHang
HAVING SUM(CT.soLuong * SP.donGia) >= 500000
ORDER BY tongTien DESC;


-- =============================================
-- PHẦN II
-- =============================================

-- a Hiển thị danh sách các khách hàng chưa mua hàng lần nào kể từ tháng 1/1/2016
SELECT maKhachHang, hoVaTenLot, Ten, diaChi, email, dienThoai
FROM KhachHang
WHERE NOT EXISTS (
    SELECT 1
    FROM HoaDon HD
    WHERE HD.maKhachHang = KhachHang.maKhachHang
      AND HD.ngayMuaHang >= '2016-01-01'
);

-- b Hiển thị mã sản phẩm, tên sản phẩm có lượt mua nhiều nhất trong tháng 12/2016
SELECT 
    SP.maSanPham, 
    SP.tenSanPham, 
    SUM(CT.soLuong) AS tongLuotMua
FROM SanPham SP
JOIN HoaDonChiTiet CT 
    ON SP.maSanPham = CT.maSanPham
JOIN HoaDon HD 
    ON CT.maHoaDon = HD.maHoaDon
WHERE MONTH(HD.ngayMuaHang) = 12 
  AND YEAR(HD.ngayMuaHang) = 2016
GROUP BY SP.maSanPham, SP.tenSanPham
ORDER BY tongLuotMua DESC
LIMIT 1;

-- c Hiển thị top 5 khách hàng có tổng số tiền mua hàng nhiều nhất trong năm 2016
SELECT 
    KH.maKhachHang, 
    CONCAT(KH.hoVaTenLot, ' ', KH.Ten) AS hoVaTen, 
    SUM(CT.soLuong * SP.donGia) AS tongTienMuaHang
FROM KhachHang KH
JOIN HoaDon HD 
    ON KH.maKhachHang = HD.maKhachHang
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon
JOIN SanPham SP 
    ON CT.maSanPham = SP.maSanPham
WHERE YEAR(HD.ngayMuaHang) = 2016
GROUP BY KH.maKhachHang, KH.hoVaTenLot, KH.Ten
ORDER BY tongTienMuaHang DESC
LIMIT 5;

-- d Hiển thị thông tin các khách hàng sống ở ‘Đà Nẵng’ có mua sản phẩm có tên “Iphone 7 32GB” trong tháng 12/2016
SELECT DISTINCT
    KH.maKhachHang,
    KH.hoVaTenLot,
    KH.Ten,
    KH.diaChi,
    KH.email,
    KH.dienThoai
FROM KhachHang KH
JOIN HoaDon HD 
    ON KH.maKhachHang = HD.maKhachHang
JOIN HoaDonChiTiet CT 
    ON HD.maHoaDon = CT.maHoaDon
JOIN SanPham SP 
    ON CT.maSanPham = SP.maSanPham
WHERE KH.diaChi LIKE '%Đà Nẵng%' 
  AND SP.tenSanPham = 'iPhone 7 32GB'
  AND MONTH(HD.ngayMuaHang) = 12 
  AND YEAR(HD.ngayMuaHang) = 2016;

-- e Hiển thị tên sản phẩm có lượt đặt mua nhỏ hơn lượt mua trung bình các các sản phẩm.
SELECT SP.tenSanPham
FROM SanPham SP
JOIN HoaDonChiTiet CT 
    ON SP.maSanPham = CT.maSanPham
GROUP BY SP.tenSanPham
HAVING SUM(CT.soLuong) < (
    SELECT AVG(tongSoLuong)
    FROM (
        SELECT SUM(soLuong) AS tongSoLuong
        FROM HoaDonChiTiet
        GROUP BY maSanPham
    ) AS T
);