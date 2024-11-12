--QLGV--
-- 26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT MAHV, HO, TEN 
FROM HOCVIEN 
ORDER BY (SELECT COUNT(*) 
          FROM KETQUATHI 
          WHERE MAHV = HOCVIEN.MAHV AND DIEM >= 9) DESC 

-- 27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT MALOP, MAHV, HO, TEN 
FROM HOCVIEN 
ORDER BY (SELECT COUNT(*) 
          FROM KETQUATHI 
          WHERE MAHV = HOCVIEN.MAHV AND DIEM >= 9) DESC;

-- 28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT HOCKY, NAM, MAGV, COUNT(DISTINCT MAMH) AS SoMon, COUNT(DISTINCT MALOP) AS SoLop 
FROM GIANGDAY 
GROUP BY HOCKY, NAM, MAGV;

-- 29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT gd.HOCKY, gd.NAM, gv.MAGV, gv.HOTEN 
FROM GIAOVIEN gv 
JOIN GIANGDAY gd ON gv.MAGV = gd.MAGV 
GROUP BY gd.HOCKY, gd.NAM, gv.MAGV, gv.HOTEN 
ORDER BY COUNT(DISTINCT gd.MAMH) DESC 

-- 30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT MAMH, TENMH 
FROM MONHOC 
WHERE MAMH = (
    SELECT TOP 1 MAMH 
    FROM KETQUATHI 
    WHERE LANTHI = 1 AND KQUA = 'Khong dat' 
    GROUP BY MAMH 
    ORDER BY COUNT(MAHV) DESC
);


-- 31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT MAHV, HO, TEN 
FROM HOCVIEN 
WHERE MAHV NOT IN (SELECT MAHV 
                   FROM KETQUATHI 
                   WHERE LANTHI = 1 AND KQUA = 'Khong dat');

-- 32. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT MAHV, HO, TEN 
FROM HOCVIEN 
WHERE MAHV NOT IN (SELECT MAHV 
                   FROM KETQUATHI 
                   WHERE LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV = HOCVIEN.MAHV) 
                   AND KQUA = 'Khong dat');

-- 33. Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
SELECT MAHV, HO, TEN 
FROM HOCVIEN 
WHERE NOT EXISTS (SELECT 1 
                  FROM MONHOC 
                  WHERE MAMH NOT IN (SELECT MAMH 
                                     FROM KETQUATHI 
                                     WHERE MAHV = HOCVIEN.MAHV AND LANTHI = 1 AND KQUA = 'Dat'));

-- 34. Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi sau cùng).
SELECT MAHV, HO, TEN 
FROM HOCVIEN 
WHERE NOT EXISTS (SELECT 1 
                  FROM MONHOC 
                  WHERE MAMH NOT IN (SELECT MAMH 
                                     FROM KETQUATHI 
                                     WHERE MAHV = HOCVIEN.MAHV AND LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV = HOCVIEN.MAHV) AND KQUA = 'Dat'));

-- 35. Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT hv.MAHV, hv.HO, hv.TEN 
FROM HOCVIEN hv 
JOIN KETQUATHI kq ON hv.MAHV = kq.MAHV 
WHERE kq.DIEM = (SELECT MAX(kq2.DIEM) 
                 FROM KETQUATHI kq2 
                 WHERE kq2.MAMH = kq.MAMH AND kq2.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV = kq.MAHV));