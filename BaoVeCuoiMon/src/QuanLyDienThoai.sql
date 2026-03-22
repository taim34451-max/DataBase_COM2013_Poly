CREATE DATABASE IF NOT EXISTS QuanLyDienThoai;
USE QuanLyDienThoai;

#Yêu cầu 2.1: Viết lệnh SQL để tạo 3 bảng trên với các ràng buộc khóa chính, khóa ngoại và kiểu dữ liệu phù hợp.
CREATE TABLE HangSanXuat (
    MaHang INT PRIMARY KEY,
    TenHang VARCHAR(100) NOT NULL,
    QuocGia VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE DienThoai (
    MaDT INT PRIMARY KEY,
    TenDT VARCHAR(100) NOT NULL,
    GiaBan DECIMAL(15,2),
    SoLuongKho INT DEFAULT 0,
    MaHang INT,
    FOREIGN KEY (MaHang) REFERENCES HangSanXuat(MaHang)
);

CREATE TABLE DonHang (
    MaDH INT PRIMARY KEY,
    NgayBan DATE,
    SoLuongMua INT,
    GiaTriDonHang DECIMAL(15,2),
    MaDT INT,
    FOREIGN KEY (MaDT) REFERENCES DienThoai(MaDT)
);

#Yêu cầu 2.2: Dựa vào dữ liệu JSON dưới đây, thực hiện lệnh INSERT dữ liệu vào bảng.
INSERT INTO HangSanXuat VALUES
(1,'Apple','USA','contact@apple.com'),
(2,'Samsung','Korea','support@samsung.com'),
(3,'Xiaomi','China','mi@xiaomi.com');

INSERT INTO DienThoai (MaDT,TenDT,GiaBan,MaHang) VALUES
(1,'iPhone 15 Pro',28000000,1),
(2,'Galaxy S24',22000000,2),
(3,'Redmi Note 13',5000000,3),
(4,'iPhone 13',14000000,1),
(5,'Z Fold 5',35000000,2),
(6,'Mi 14 Ultra',19000000,3),
(7,'iPhone 14',17000000,1),
(8,'Galaxy A54',8000000,2),
(9,'Redmi 12',3000000,3),
(10,'iPad Pro M2',25000000,1);

INSERT INTO DonHang (MaDH, NgayBan, SoLuongMua, GiaTriDonHang, MaDT) VALUES
(1,'2024-01-10',2,56000000,1),
(2,'2024-01-12',1,35000000,5),
(3,'2024-02-15',10,50000000,3),
(4,'2024-02-20',1,22000000,2),
(5,'2024-03-01',3,42000000,4),
(6,'2024-03-05',1,19000000,6),
(7,'2024-03-10',2,56000000,1),
(8,'2024-03-15',5,15000000,9),
(9,'2024-03-20',1,17000000,7),
(10,'2024-03-22',2,50000000,10);

#Phần 3. Truy vấn dữ liệu
#1. Thống kê: Tính tổng doanh thu của từng Hãng sản xuất (Yêu cầu dùng Subquery để lấy tên hãng).
select (select TenHang from HangSanXuat H
where H.MaHang = DT.MaHang) as TenBang, 
sum(DH.SoLuongMua * DT.GiaBan) as TongDoanhThu
from DonHang DH join DienThoai DT on DH.MaDT = DT.MaDT
group by DT.MaHang;


#2. Thống kê: Tìm những điện thoại có giá bán cao hơn giá bán trung bình của tất cả sản phẩm trong cửa hàng (Sử dụng Subquery).
SELECT  MaDT, TenDT, GiaBan, SoLuongKho, MaHang chitietphieumuonloaisachphieumuon
FROM DienThoai
WHERE GiaBan > (
    SELECT AVG(GiaBan)
    FROM DienThoai
);

#3. Thống kê: Đếm số lượng đơn hàng cho mỗi quốc gia của hãng sản xuất.
SELECT 
    HSX.QuocGia,
    COUNT(DH.MaDH) AS SoLuongDonHang
FROM DonHang DH
JOIN DienThoai DT ON DH.MaDT = DT.MaDT
JOIN HangSanXuat HSX ON DT.MaHang = HSX.MaHang
GROUP BY HSX.QuocGia;

#4. Update: Cập nhật giảm giá 5% cho tất cả điện thoại thuộc hãng 'Samsung'.
UPDATE DienThoai
SET GiaBan = GiaBan * 0.95
WHERE MaHang = (
    SELECT MaHang 
    FROM HangSanXuat
    WHERE TenHang = 'Samsung'
);

#5. Delete: Xóa tất cả các đơn hàng có số lượng mua nhỏ hơn 2 và ngày bán trước tháng 02/2024.
DELETE FROM DonHang
WHERE SoLuongMua < 2 AND NgayBan < '2024-02-01';