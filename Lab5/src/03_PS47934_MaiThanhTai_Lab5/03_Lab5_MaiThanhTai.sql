/*
   BÀI LAB 5 - CƠ SỞ DỮ LIỆU (CHUẨN T-SQL)
   Họ và tên: Mai Thanh Tài
   MSSV: PS47934
*/

USE QuanLyBanHang;

-- a Hiển thị tất cả thông tin có trong bảng khách hàng bao gồm tất cả các cột
SELECT maKhachHang, hoVaTenLot, Ten, diaChi, email, dienThoai
FROM KhachHang;

-- b Hiển thị 10 khách hàng đầu tiên trong bảng khách hàng bao gồm các cột: mã khách hàng, họ và tên, email, số điện thoại
SELECT maKhachHang, hoVaTenLot, Ten, email, dienThoai
FROM KhachHang
LIMIT 10;

-- c Hiển thị thông tin từ bảng Sản phẩm gồm các cột: mã sản phẩm, tên sản phẩm, tổng tiền tồn kho. 
-- Với tổng tiền tồn kho = đơn giá* số lượng
SELECT maSanPham, tenSanPham, (donGia * soLuong) AS tongTienTonKho
FROM SanPham;

-- d Hiển thị danh sách khách hàng có tên bắt đầu bởi kí tự ‘H’ gồm các cột:
-- maKhachHang, hoVaTen, diaChi. Trong đó cột hoVaTen ghép từ 2 cột hoVaTenLot và Ten
SELECT maKhachHang,
       CONCAT(hoVaTenLot, ' ', Ten) AS hoVaTen,
       diaChi
FROM KhachHang
WHERE Ten LIKE 'H%';

-- e Hiển thị tất cả thông tin các cột của khách hàng có địa chỉ chứa chuỗi ‘Đà Nẵng’
SELECT maKhachHang, hoVaTenLot, Ten, diaChi, email, dienThoai
FROM KhachHang
WHERE diaChi LIKE '%Đà Nẵng%';

-- f Hiển thị các sản phẩm có số lượng nằm trong khoảng từ 100 đến 500.
SELECT maSanPham, tenSanPham, soLuong, donGia, moTa
FROM SanPham
WHERE soLuong BETWEEN 100 AND 500;

-- g Hiển thị danh sách các hoá hơn có trạng thái là chưa thanh toán và ngày mua hàng trong năm 2016
SELECT maHoaDon, ngayMuaHang, maKhachHang, trangThai
FROM HoaDon
WHERE trangThai = 'Chưa thanh toán'
  AND YEAR(ngayMuaHang) = 2016;

-- h Hiển thị các hoá đơn có mã Khách hàng thuộc 1 trong 3 mã sau: KH001, KH003, KH006
SELECT maHoaDon, ngayMuaHang, maKhachHang, trangThai
FROM HoaDon
WHERE maKhachHang IN ('KH001', 'KH003', 'KH006');

-- ================= PHẦN II =================

-- a Hiển thị số lượng khách hàng có trong bảng khách hàng
SELECT COUNT(*) AS soLuongKhachHang
FROM KhachHang;

-- b Hiển thị đơn giá lớn nhất trong bảng SanPham
SELECT MAX(donGia) AS donGiaCaoNhat
FROM SanPham;

-- c Hiển thị số lượng sản phẩm thấp nhất trong bảng sản phẩm

SELECT MIN(soLuong) AS soLuongThapNhat
FROM SanPham;

-- d Hiển thị tổng tất cả số lượng sản phẩm có trong bảng sản phẩm
SELECT SUM(soLuong) AS tongSoLuongSanPham
FROM SanPham;

-- e Hiển thị số hoá đơn đã xuất trong tháng 12/2016 mà có trạng thái chưa thanh toán
SELECT COUNT(*) AS soHoaDonThang12
FROM HoaDon
WHERE MONTH(ngayMuaHang) = 12
  AND YEAR(ngayMuaHang) = 2016
  AND trangThai = 'Chưa thanh toán';

-- f Hiển thị mã hoá đơn và số loại sản phẩm được mua trong từng hoá đơn.
SELECT maHoaDon,
       COUNT(maSanPham) AS soLoaiSanPham
FROM HoaDonChiTiet
GROUP BY maHoaDon;

-- g Hiển thị mã hoá đơn và số loại sản phẩm được mua trong từng hoá đơn. 
-- Yêu cầu chỉ hiển thị hàng nào có số loại sản phẩm được mua >=5.
SELECT maHoaDon,
       COUNT(maSanPham) AS soLoaiSanPham
FROM HoaDonChiTiet
GROUP BY maHoaDon
HAVING COUNT(maSanPham) >= 5;

-- h Hiển thị thông tin bảng HoaDon gồm các cột maHoaDon, ngayMuaHang, maKhachHang. 
-- Sắp xếp theo thứ tự giảm dần của ngayMuaHang
SELECT maHoaDon, ngayMuaHang, maKhachHang
FROM HoaDon
ORDER BY ngayMuaHang DESC;