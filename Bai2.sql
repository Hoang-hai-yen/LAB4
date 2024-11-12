--QLGV--

-- 19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA 
FROM KHOA 
WHERE NGTLAP = (SELECT MIN(NGTLAP) FROM KHOA);

-- 20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(*) AS SoLuongGV 
FROM GIAOVIEN 
WHERE HOCHAM IN ('GS', 'PGS');

-- 21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT MAKHOA, HOCVI, COUNT(*) AS SoLuongGV 
FROM GIAOVIEN 
WHERE HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS') 
GROUP BY MAKHOA, HOCVI;

-- 22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MAMH, KQUA, COUNT(*) AS SoLuongHV 
FROM KETQUATHI 
GROUP BY MAMH, KQUA;

-- 23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM GIAOVIEN gv 
JOIN LOP l ON gv.MAGV = l.MAGVCN 
JOIN GIANGDAY gd ON gv.MAGV = gd.MAGV AND l.MALOP = gd.MALOP;

-- 24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT hv.HO, hv.TEN 
FROM HOCVIEN hv 
JOIN LOP l ON hv.MAHV = l.TRGLOP 
WHERE l.SISO = (SELECT MAX(SISO) FROM LOP);

-- 25. Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT hv.HO, hv.TEN 
FROM HOCVIEN hv 
JOIN LOP l ON hv.MAHV = l.TRGLOP 
WHERE (SELECT COUNT(DISTINCT MAMH) 
       FROM KETQUATHI 
       WHERE MAHV = hv.MAHV AND KQUA = 'Khong dat') > 3;
