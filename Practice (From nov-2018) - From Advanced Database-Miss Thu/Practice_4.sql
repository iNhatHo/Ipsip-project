



										--Em đặt tên tất cả trigger là utr_rb để lúc em kiểm tra nó không bị dính trigger của câu trc ( vì em có drop if trigger is not null)--




-- R2. Trưởng bộ môn phải sinh trước 1975 
--B2
-- BOMON : I(+) D(-) U(+ Truongbm)
-- GIAOVIEN :I(-) D(-) U(+ NgaySinh)
--B3
if OBJECT_ID('utr_rb') IS NOT NULL
	drop trigger UTR_RB
go
create trigger utr_rb
on BOMON
for insert, update
as
begin
	select * from inserted
	if exists (select * 
			   from GIAOVIEN g, inserted i
			   where g.MAGV=i.TRUONGBM and YEAR(g.NGSINH) > 1975)
	begin
		RAISERROR('RB2 1',16,1)
		ROLLBACK
	end
end
go
--
if object_id('urt_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on giaovien
for update
as
begin
	if update(NGSINH)
	begin
	select * from inserted
	select * from deleted
	if exists (select *
			   from BOMON bm, inserted i
			   where bm.TRUONGBM=i.MAGV and Year(i.NGSINH) > 1975)
	begin
		raiserror('RB2 2',16,1)
		rollback
		end
	end
end	 
--B5
insert BOMON(MABM,TRUONGBM)
values('PHP33','006')
--
update BOMON
set TRUONGBM='006'
where MABM='HTTT'
--

update GIAOVIEN
set NGSINH=('1980-06-06')
where MAGV='004'

-------------------------------

--R3. Một bộ môn có tối thiểu 1 giáo viên nữ 
--B2
-- GIAOVIEN : I(-) D(+) U(+ Phai)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on giaovien
for delete, update
as
begin
	select * from deleted d
	declare @i int
	select @i = count(*) from deleted d, BOMON bm where d.MABM=bm.MABM and d.PHAI=N'Nữ'
	if (@i < 2)
	begin
		raiserror('RB3 1',16,1)
		rollback
	end
end
--B4
delete GIAOVIEN
where magv='006'
--
update GIAOVIEN
set PHAI=N'NAM'
where MAGV='006'

-------------------------------

--R4 Một giáo viên phải có ít nhất 1 số điện thoại
--B2
-- GV_DT I(-) D(+) U(+ MAGV)
--B3
--
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GV_DT
for delete, update
as
begin
	select * from deleted d
	declare @i int
	select @i = count(*) from deleted d, GV_DT gt where d.MAGV=gt.MAGV and gt.DIENTHOAI is not null
	if( @i < 1)
	begin
		raiserror('RB4 1',16,1)
		rollback
		return
	end
end
--B4
delete GV_DT
where MAGV='002'
--
update GV_DT
set MAGV='003'
where MAGV='002'

-------------------------------

--R5 Một giáo viên có tối đa 3 số điện thoại
--B2
-- GV_DT I(+) D(-) U(+ MAGV)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GV_DT
for insert, update
as
begin
	select * from inserted i
	declare @i int
	select @i = count(*) from inserted i, GV_DT gt where i.MAGV=gt.MAGV and gt.DIENTHOAI is not null
	if( @i >3 )
	begin
		raiserror('RB4 1',16,1)
		rollback
		return
	end
end
--
--B5
insert GV_DT(MAGV,DIENTHOAI)
values ('003','0235343')
select * from GV_DT
--
update GV_DT
set MAGV='003'
where MAGV='001'
select * from GV_DT

-------------------------------

--R6 Một bộ môn phải có tối thiểu 4 giáo viên
--B2
-- GIAOVIEN I(-) D(+) U(+ MABM)
-- BOMON I(+) D(-) U(+ MABM)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GIAOVIEN
for delete,update
as
begin
	select * from deleted d
	declare @i int
	select @i = count(*) from deleted d, GIAOVIEN gv where d.MABM=gv.MABM
	if (@i <5 )
	begin
		raiserror('RB6 1',16,1)
		rollback
	end
end
--
if object_id('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on BOMON
for insert,update
as
begin
	select * from inserted i
	declare @i int
	select @i = count(*) from inserted i, GIAOVIEN gv where i.MABM=gv.MABM
	if (@i <5 )
	begin
		raiserror('RB6 2',16,1)
		rollback
	end
end
update GIAOVIEN
set MABM='HTTT'
where MAGV='007'
--
delete GIAOVIEN
where MAGV='006'
--
insert BOMON(MABM)
values ('PHP33')
--
update BOMON
set MABM ='PHP33'
where MABM='SH'

-------------------------------

--RB7 Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn.
--B2
-- GIAOVIEN: I(+) D(-) U(+ NGSINH)
-- BOMON: I(-) D(-) U(+ TRUONGBM)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GIAOVIEN
for insert,update
as
begin
	select * from inserted i
	declare @i date
	select @i = i.NGSINH from inserted i
	if @i > (select MIN(gv.NGSINH)
			   from GIAOVIEN gv, BOMON bm
			   where bm.MABM=gv.MABM)
	begin
		raiserror('RB7 1',16,1)
		rollback
	end
end
--
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on BOMON
for update
as
begin
	if exists (select MIN(gv.NGSINH)
			   from GIAOVIEN gv, BOMON bm
			   where bm.MABM=gv.MABM)
	begin
		raiserror('RB7 2',16,1)
		rollback
	end
end
--B5
select * from GIAOVIEN
update GIAOVIEN
set NGSINH='1980-06-20'
where magv='002'
go
--
--
insert GIAOVIEN(MAGV,NGSINH,MABM)
values('033','1960-06-06','HTTT')
--
update BOMON
set TRUONGBM='003'
where MABM='HTTT'

-------------------------------

--RB8 Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn.
--B2
-- GIAOVIEN I(-) D(-) U(+ QLCM)
-- BOMON I(+) D(-) U(+ TRUONGBM)
--B3
if object_id('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GIAOVIEN
for update
as
begin
	if update(GVQLCM)
	if exists  (select gv.MAGV
				from GIAOVIEN gv, BOMON bm
				where gv.GVQLCM=bm.TRUONGBM)	
	begin
		raiserror('RB8 1',16,1)
		rollback
	end		
end
go
--
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on BOMON
for insert, update
as
begin
	select * from inserted i
	if exists (select *
			   from inserted i, GIAOVIEN gv
			   where gv.GVQLCM=i.TRUONGBM)
		begin
		raiserror('RB8 2',16,1)
		rollback
	end		
end
go
--B5
update GIAOVIEN
set GVQLCM='005'
where MAGV='001'
--
update BOMON
set TRUONGBM='007'
where MABM='CNTT'
--
insert BOMON(MABM,TRUONGBM)
values('PHP30','001')

-------------------------------

--RB9 Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn.
--B2
-- GIAOVIEN I(+) D(-) U(+ MABM)
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GIAOVIEN
for insert,update
as
begin
	select * from inserted i
	if not exists ( select *
				from GIAOVIEN gv, inserted i
				where gv.GVQLCM=i.MAGV and gv.MABM=i.MABM)
	begin
		raiserror('RB9 1',16,1)
		rollback
	end
end
--
insert GIAOVIEN(MAGV,GVQLCM,MABM)
values ('013','005','MMT')
--
update GIAOVIEN
set GVQLCM='004'
where MAGV='005'

-------------------------------

--RB10 Mỗi giáo viên chỉ có tối đa 1 vợ chồng
--RB11 Giáo viên là Nam thì chỉ có vợ chồng là Nữ hoặc ngược lại.
--RB12 Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân.
--RB13 Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài.
--B2
-- DETAI I(+) D(-) U(+ GVCNDT)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on DETAI
for insert,update
as
begin
	select * from inserted i
	declare @i int
	select @i = count(*) from inserted i, GIAOVIEN gv where i.GVCNDT=gv.MAGV
	if (@i < 4)
	begin
		raiserror('RB13 1',16,1)
		rollback
	end
end
--B5
insert DETAI(MADT,GVCNDT)
values ('018','002')
--
update DETAI
set GVCNDT='002'
where MADT='003'

-------------------------------

--RB14 Một đề tài phải có ít nhất một công việc
--B2
--  CONGVIEC: I(-) D(+) U(+ MADT)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on CONGVIEC
for delete,update
as
begin
	select * from deleted d
	declare @i int
	select @i = count(*) from deleted i, DETAI dt, CONGVIEC cv where i.MADT=dt.MADT and i.SOTT=cv.SOTT
	if (@i > 1)
	begin
		raiserror('RB14 1',16,1)
		rollback
	end
end
--B5
-- Xóa rằng buộc để có thể xóa ở bảng công việc
select * from THAMGIADT
delete THAMGIADT
where MADT='001' and STT=1
--
delete CONGVIEC
where MADT='001' and SOTT=1
--
update CONGVIEC
set MADT='002',SOTT=9
where MADT='001' and SOTT=1

-------------------------------

--RB15 Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó.
--B2
-- GIAOVIEN I(+) D(-) U(+)
--B3
if OBJECT_ID('utr_rb') is not null
	drop trigger utr_rb
go
create trigger utr_rb
on GIAOVIEN
for insert,update
as
begin
	select * from inserted i
	if exists (select MAX(gv.LUONG)
			   from GIAOVIEN gv, inserted i
			   where gv.MAGV=i.GVQLCM)
	begin
		raiserror('RB15 1',16,1)
		rollback
	end
end
--B5
update GIAOVIEN
set LUONG =3000
where MAGV='003'
go
--
insert GIAOVIEN(MAGV,LUONG,GVQLCM)
values('033',3000,'002')




