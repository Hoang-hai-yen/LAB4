--QLBH--

--19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT DISTINCT CTHD.SOHD
FROM CTHD
JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD 
WHERE SANPHAM.NUOCSX = 'Singapore' AND YEAR (HOADON.NGHD) = 2006
--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(DISTINCT CTHD.SOHD) AS KO_PHAI_KHACH_HANG_THANH_VIEN
FROM CTHD
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD 
WHERE HOADON.MAKH IS NULL
--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT CTHD.MASP) AS SO_SP_BAN_RA
FROM CTHD
JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE YEAR(HOADON.NGHD) = 2006
--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) AS MAXGIAHD, MIN(TRIGIA) AS MINGIAHD
FROM HOADON
--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TBGIAHD
FROM HOADON
WHERE YEAR(NGHD) = 2006
--24. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = 2006
--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT MAX(TRIGIA) AS MAXGIAHD2006
FROM HOADON
WHERE YEAR(NGHD) = 2006
--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT KHACHHANG.HOTEN
FROM KHACHHANG
JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH
WHERE HOADON.TRIGIA = (
    SELECT MAX(TRIGIA)
    FROM HOADON
    WHERE YEAR(NGHD) = 2006
)
--27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC
--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
)
--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
)
--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất)
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
)