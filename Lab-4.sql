-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT c.HoTen, COUNT(ck.MaKyNang) AS SoLuongKyNang
FROM ChuyenGia c
JOIN ChuyenGia_KyNang ck ON c.MaChuyenGia = ck.MaChuyenGia
GROUP BY c.HoTen
ORDER BY SoLuongKyNang DESC

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT c1.HoTen AS ChuyenGia1, c2.HoTen AS ChuyenGia2, c1.ChuyenNganh, c1.NamKinhNghiem, c2.NamKinhNghiem
FROM ChuyenGia c1
JOIN ChuyenGia c2 ON c1.ChuyenNganh = c2.ChuyenNganh AND c1.MaChuyenGia < c2.MaChuyenGia
WHERE ABS(c1.NamKinhNghiem - c2.NamKinhNghiem) <= 2;

-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT ct.TenCongTy, COUNT(da.MaDuAn) AS SoLuongDuAn, SUM(c.NamKinhNghiem) AS TongNamKinhNghiem
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia c ON cda.MaChuyenGia = c.MaChuyenGia
GROUP BY ct.TenCongTy;

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT DISTINCT c.HoTen
FROM ChuyenGia c
JOIN ChuyenGia_KyNang ck ON c.MaChuyenGia = ck.MaChuyenGia
GROUP BY c.MaChuyenGia, c.HoTen
HAVING MAX(ck.CapDo) = 5 AND MIN(ck.CapDo) >= 3;

-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT c.HoTen, COUNT(cda.MaDuAn) AS SoLuongDuAn
FROM ChuyenGia c
LEFT JOIN ChuyenGia_DuAn cda ON c.MaChuyenGia = cda.MaChuyenGia
GROUP BY c.HoTen;

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
SELECT k.TenKyNang, c.HoTen, ck.CapDo
FROM ChuyenGia c
JOIN ChuyenGia_KyNang ck ON c.MaChuyenGia = ck.MaChuyenGia
JOIN KyNang k ON ck.MaKyNang = k.MaKyNang
WHERE ck.CapDo = (SELECT MAX(ck2.CapDo) FROM ChuyenGia_KyNang ck2 WHERE ck2.MaKyNang = k.MaKyNang);

-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
SELECT ChuyenNganh, (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ChuyenGia)) AS TiLePhanTram
FROM ChuyenGia
GROUP BY ChuyenNganh;

-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
SELECT k1.TenKyNang AS KyNang1, k2.TenKyNang AS KyNang2, COUNT(*) AS SoLanXuatHien
FROM ChuyenGia_KyNang ck1
JOIN ChuyenGia_KyNang ck2 ON ck1.MaChuyenGia = ck2.MaChuyenGia AND ck1.MaKyNang < ck2.MaKyNang
JOIN KyNang k1 ON ck1.MaKyNang = k1.MaKyNang
JOIN KyNang k2 ON ck2.MaKyNang = k2.MaKyNang
GROUP BY k1.TenKyNang, k2.TenKyNang
ORDER BY SoLanXuatHien DESC;

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT ct.TenCongTy, AVG(DATEDIFF(day, da.NgayBatDau, da.NgayKetThuc)) AS SoNgayTrungBinh
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY ct.TenCongTy;

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
SELECT c.MaChuyenGia, c.HoTen
FROM ChuyenGia c
JOIN ChuyenGia_KyNang ck ON c.MaChuyenGia = ck.MaChuyenGia
GROUP BY c.MaChuyenGia, c.HoTen
HAVING COUNT(ck.MaKyNang) = (
    SELECT COUNT(ck2.MaKyNang)
    FROM ChuyenGia_KyNang ck2
    WHERE ck2.MaChuyenGia = c.MaChuyenGia
    AND NOT EXISTS (
        SELECT 1
        FROM ChuyenGia_KyNang ck3
        WHERE ck3.MaKyNang = ck2.MaKyNang
        AND ck3.MaChuyenGia <> c.MaChuyenGia
    )
);

-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
SELECT c.HoTen, COUNT(cda.MaDuAn) AS SoLuongDuAn, SUM(ck.CapDo) AS TongCapDo, (COUNT(cda.MaDuAn) + SUM(ck.CapDo)) AS DiemXepHang
FROM ChuyenGia c
LEFT JOIN ChuyenGia_DuAn cda ON c.MaChuyenGia = cda.MaChuyenGia
LEFT JOIN ChuyenGia_KyNang ck ON c.MaChuyenGia = ck.MaChuyenGia
GROUP BY c.HoTen
ORDER BY DiemXepHang DESC;

-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT da.TenDuAn
FROM DuAn da
JOIN ChuyenGia_DuAn cda ON da.MaDuAn = cda.MaDuAn
JOIN ChuyenGia c ON cda.MaChuyenGia = c.MaChuyenGia
GROUP BY da.TenDuAn
HAVING COUNT(DISTINCT c.ChuyenNganh) = (SELECT COUNT(DISTINCT ChuyenNganh) FROM ChuyenGia);

-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
SELECT ct.TenCongTy, 
       (COUNT(CASE WHEN da.TrangThai = 'Hoàn thành' THEN 1 END) * 100.0 / COUNT(*)) AS TyLeThanhCong
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY ct.TenCongTy;

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
SELECT c1.HoTen AS ChuyenGia1, c2.HoTen AS ChuyenGia2, k1.TenKyNang AS KyNangA, k2.TenKyNang AS KyNangB
FROM ChuyenGia c1
JOIN ChuyenGia_KyNang ck1 ON c1.MaChuyenGia = ck1.MaChuyenGia
JOIN KyNang k1 ON ck1.MaKyNang = k1.MaKyNang
JOIN ChuyenGia c2 ON c1.MaChuyenGia < c2.MaChuyenGia
JOIN ChuyenGia_KyNang ck2 ON c2.MaChuyenGia = ck2.MaChuyenGia
JOIN KyNang k2 ON ck2.MaKyNang = k2.MaKyNang AND k1.TenKyNang = k2.TenKyNang
WHERE ck1.CapDo >= 4 AND ck2.CapDo <= 2
   OR ck2.CapDo >= 4 AND ck1.CapDo <= 2;
