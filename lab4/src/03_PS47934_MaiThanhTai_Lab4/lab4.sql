-- 1. Tạo cơ sở dữ liệu quanLyBĐS
create database quanLyBĐS;

-- 2. Tạo bản VANPHONG
create table vanphong(
	MaVP int primary key,
    DiaDiem varchar(100) not null,
    TruongPhong int references nhanvien(MaNV)
); 

-- 3. Tạo bảng NHANVIEN 
create table nhanvien(
    MaNV int primary key,
    TenNV varchar(30) not null,
    NgaySinh date not null,
    ChucVu varchar(10),
    SoLuongNguoiThan int,
    MaVP int references vanphong(MaVP),
    NguoiThan int references chitietnguoithan(CMNDNguoiThan)
);
-- 4. Tạo bảng CHITIETNGUOITHAN
create table chitietnguoithan(
     MaNV int references nhanvien(MaNV),
     MaVP int references vanphong(MaVP),
     TenNguoiThan varchar(30) not null,
     NgaySinh date not null,
     MoiLienHe varchar(5),
     CMNDNguoiThan int primary key 
);

-- 5. Tạo bảng SANPHAMBDS
CREATE TABLE sanphambds (
    MaBDS INT PRIMARY KEY,
    DiaChi VARCHAR(100) NOT NULL,
    MaVP INT,
    ChuSoHuu INT
);

-- 6. Tạo bảng CHUSOHUU
create table chusohuu(
    CMNDChuSoHuu int primary key,
    TenChuSoHuu varchar(30) not null,
    SoDienThoai int not null,
    DiaChi varchar(100) not null,
    MaBDS int references samphambds(MaBDS)
);

    
    

   

    