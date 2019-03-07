-- 1.Cho biết họ tên giáo viên và tên bộ môn của giáo viên đó 
select gv.HOTEN,bm.TENBM
from GIAOVIEN gv, BOMON bm
where gv.MABM=bm.MABM
-- 2. Cho biết danh sách đề tài do giáo viên họ ‘Trần’ chủ nhiệm
select dt.TENDT
from GIAOVIEN gv, DETAI dt
where gv.HOTEN like N'%Trần%' and gv.MAGV=dt.GVCNDT
-- 3. Cho biết tên đề tài, tên chủ nhiệm đề tài có kinh phí > 100 tr
select dt.TENDT,gv.HOTEN
from DETAI dt, GIAOVIEN gv
where dt.GVCNDT=gv.MAGV and dt.KINHPHI > 100
-- 4.Cho biết tên công việc chưa có người tham gia
select distinct cv.TENCV
from CONGVIEC cv
where not exists (select cv.TENCV
					 from THAMGIADT tg
					 where tg.MADT=cv.MADT and tg.STT=cv.SOTT)
--5. Cho biết tên người quản lí chuyên môn và tên nhân viên mà người này quản lí
select gv.HOTEN as GVQLCM,gv2.HOTEN as NHANVIEN
from GIAOVIEN gv,GIAOVIEN gv2
where gv.MAGV=gv2.GVQLCM
--6. Cho biết tên đề tài có công việc bắt đầu trong năm 2009
select distinct dt.TENDT
from DETAI dt, CONGVIEC cv
where dt.MADT=cv.MADT and year(cv.NGAYBD) >=2009
--7. Cho biết tên công việc và số người tham gia
select cv.TENCV, (select count(*)
				 from THAMGIADT tg
				 where tg.MADT=cv.MADT and cv.SOTT=tg.STT) SoNguoiThamGia
from CONGVIEC cv
--8. Cho biết tên nhân viên và số đề tài mà họ tham gia
select gv.HOTEN, (select count(*)
				  from THAMGIADT tg
				  where tg.MAGV=gv.MAGV) as SoDetai
from GIAOVIEN gv
--9. Cho biết tên bộ môn, tên trưởng bộ môn và số giáo viên thuộc bộ môn đó
select distinct bm.TENBM,gv.HOTEN as TruongBM, (select count(*)
												from GIAOVIEN gv2
												where gv2.MABM=bm.MABM) as soGiaoVien
from BOMON bm,GIAOVIEN gv
where bm.MABM=gv.MABM and bm.TRUONGBM=gv.MAGV
--10. Cho biết bộ môn có nhiều nhân viên nhất
select bm.TENBM
from GIAOVIEN gv, BOMON bm
where gv.MABM=bm.MABM
group by bm.TENBM
having count(gv.MABM) >=all(select count(gv1.MABM)
					        from GIAOVIEN gv1
					        group by gv1.MABM)
-- 11.Cho biết bộ môn của giáo viên có lương cao nhất 
select distinct bm.TENBM
from BOMON bm, GIAOVIEN gv
where bm.MABM=gv.MABM and gv.LUong >=(select max(LUONG)
										from GIAOVIEN)
--12. Cho biết tên nhân viên chủ nhiệm nhiều đề tài nhất
select gv.HOTEN
from GIAOVIEN gv, DETAI dt
where gv.MAGV=dt.GVCNDT
group by gv.HOTEN
having count(dt.GVCNDT) >=all(select count(dt1.GVCNDT)
					        from DETAI dt1
					        group by dt1.GVCNDT)	
--13.Cho biết tên nhân viên, số công việc đã hoàn thành và số công việc chưa hoàn thành 
select gv.HOTEN, (select count(*) 
				  from THAMGIADT tg 
				  where gv.MAGV=tg.MAGV and tg.KETQUA is not NULL )  CVHT,(select count(*) 
																			 from THAMGIADT tg 
																			 where gv.MAGV=tg.MAGV and tg.KETQUA is NULL )  CVCHT
from GIAOVIEN gv
--15.Cho biết họ tên, số đề tài, số nhân viên mà họ quản lí 
select distinct gv.HOTEN,(select count(*)
						  from DETAI dt
						  where dt.GVCNDT=gv.MAGV)  SODETAI,(select count(*)
																from GIAOVIEN gv2
																where gv.MAGV=gv2.GVQLCM)  SONHANVIENQUANLY
from GIAOVIEN gv
--14. Cho biết đề tài có trên 3 nhân viên tham gia và do “Trần Trà Hương” chủ nhiệm
select dt.TENDT
from  GIAOVIEN gv, DETAI dt, THAMGIADT tg
where dt.GVCNDT=gv.MAGV and gv.HOTEN =N'Trần Trà Hương' and tg.MADT=dt.MADT
group by dt.TENDT
having count(tg.MAGV) >=3 


