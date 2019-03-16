

--1
alter proc Question1
	@hHoTen nvarchar (25) out
as 
begin
	select gv.HOTEN
	from GIAOVIEN gv , DETAI dt
	where dt.MADT = 001 and dt.GVCNDT = gv.MAGV
end
go
declare @KQ nvarchar (25)
exec Question1 @KQ output
print @KQ

--2
alter proc Question2
	@a int, @luong int out
as
begin
	set @luong = ( 
	select g.LUONG
	from GIAOVIEN g
	where @a= g.MAGV)
end
go
declare @KQ int
exec Question2 5 , @KQ output
print @KQ

--3
create proc Question3
	@a int , @b int out
as
begin
	set @b = (	select count (*)
				from GIAOVIEN gv
				where gv.GVQLCM = @a)


end
go
declare @KQ int
exec Question3 7, @KQ output
print @KQ
		
--4
go
alter proc Question4
	@a int , @b int out
as
begin
	set @b =  ( select count (distinct t.MADT)
				from THAMGIADT t
				where @a = t.MAGV)
end
go
declare @KQ int
exec Question4 5, @KQ output
print @KQ

--5
go
alter proc Question5
	@a int , @b int , @c int out
as
begin
	set @c = (	select count( t.MAGV)
				from THAMGIADT t
				where @a=t.MADT and @b=t.STT)
end
go
declare @KQ int
exec Question5 2, 3, @kq output
print @kq

--6
go
alter proc Question6
	@MaGV int, @Hoten nvarchar(30), @Phai nvarchar(10), @NgaySinh date, @DiaChi nvarchar(50), @GVQLCM nvarchar(21), @MaBM nvarchar(10)
as
begin
	if exists ( select *
				from GIAOVIEN gv
				where gv.MAGV=@MaGV)
	begin
		print 'GV ton tai'
		return 1;
	end
	if not exists ( select *
					from BOMON bm
					where bm.MABM=@MaBM)
	begin
		print 'BM chua ton tai'
		return 1;
	end
	if not exists ( select *
					from GIAOVIEN gv
					where gv.GVQLCM=@GVQLCM)
	begin
		print 'GVQLCM chua ton tai'
		return 1;
	end
	if @Hoten is null
	begin
		print 'Ho Ten Rong'
		return 1;
	end
	insert GIAOVIEN
	values (@MaGV,@Hoten,null,@Phai,@NgaySinh,@DiaChi,@GVQLCM,@MaBM)
	if @@ROWCOUNT =0
	begin
		print 'Them Khong Thanh Cong'
		return 1;
	end
	return 0; 
end
go
exec Question6 023,N'Le Vinh Khang','nam','12/20/1990','abc','002', 'HPT'
select * from GIAOVIEN
--7
go
alter proc Question7
	@MaDT int,@SoTT nvarchar(5),@TenCV nvarchar(50),@NgayBD date,@NgayKT date
as
begin
	if not exists ( select *
					from DETAI dt
					where dt.MADT=@MaDT)
	begin
		print 'MaDT Khong Ton Tai'
		return 1;
	end
	if exists ( select *
				from CONGVIEC cv
				where cv.SOTT=@SoTT)
	begin
		print 'SoTT da ton tai '
		return 1;
	end
	if @TenCV is null
	begin
		print 'TenCV rong'
		return 1;
	end
	if exists ( select *
				from CONGVIEC cv
				where cv.TENCV=@TenCV)
	begin
		print 'TenCV bi trung'
		return 1;
	end
	if datediff(DAY,@NgayBD,@NgayKT) < 0
	begin
		print 'NgayBD phai nho hon NgayKT'
		return 1;
	end
	insert CONGVIEC
	values (@MaDT,@SoTT,@TenCV,@NgayBD,@NgayKT)
	if @@ROWCOUNT =0
	begin
		print 'Them Khong Thanh Cong'
		return 1;
	end
	return 0; 
end
go
exec Question7 001,8,'Choi Game','2017-03-12','2017-05-15'
select * from CONGVIEC

--8
go
alter proc Question8
	@MaGV char(5), @MaDT char(3), @STT int, @PhuCap float
as
begin
	if not exists ( select *
					from GIAOVIEN gv
					where gv.MAGV=@MaGV)
	begin
		print 'MaGV khong ton tai'
		return 1;
	end
	if not exists ( select * 
					from CONGVIEC cv 
					where cv.MADT = @madt and cv.SOTT = @stt) 
	begin
		print 'Cong viec da co nguoi tham gia'
		return 1
	end
	if exists ( Select *
				from THAMGIADT tg
				where tg.MADT=@MaDT and tg.STT=@STT and tg.MAGV=@MaGV)
	begin
		print 'Giao Vien da tham gia cong viec nay'
		return 1;
	end
	if @PhuCap < 0
	begin
		print 'Phu Cap phai tren 0.0'
		return 1;
	end
	insert THAMGIADT
	values (@MaGV,@MaDT,@STT,@PhuCap,null)
	if @@ROWCOUNT=0
	begin
		print 'Them Khong Thanh Cong'
		return 1;
	end
	return 0;
end
go
exec Question8 '003','002',3,3.5
select * from THAMGIADT

--9
go
alter proc Question9
	@MaGV char(5), @HoTen nvarchar(50), @Luong int, @Phai nvarchar(5),@DiaChi nvarchar(50), @GVQLCM char(5), @MaBM char(5), @TinhTrang nvarchar(15)
as
begin
	if not exists ( Select *
					from GIAOVIEN gv
					where gv.MAGV=@Magv)
	begin
		print 'MaGV khong ton tai'
		return 1;
	end
	if not exists ( Select *
					from BOMON bm
					where bm.MABM=@MaBM)
	begin
		print 'MaBM khong ton tai'
		return 1;
	end
	if not exists ( Select *
					From GIAOVIEN gv
					Where gv.MAGV=@GVQLCM)
	begin
		print 'GVQLCM khong ton tai'
		return 1;
	end
	if @HoTen is null
	begin
		print 'Ho Ten khong duoc trong'
		return 1;
	end
	if @Luong <100
	begin
		print 'Luong khong duoc nho hon 100'
		return 1;
	end
	update GIAOVIEN 
	set HOTEN =@HoTen, LUONG=@Luong, PHAI=@Phai, DIACHI=@DiaChi, GVQLCM=@GVQLCM, MABM=@MaBM 
	where MAGV=@MaGV
	if @@ROWCOUNT=0
	begin
		print 'Them Khong Thanh Cong'
		return 1;
	end
	return 0;
end
go
exec Question9 '002','Ho Minh Nhat',3000,'Nam','158/24 XVNT','003','CNTT','Dat'
select * from GIAOVIEN

--10
go
alter proc Question10
	@MAGV char(5), @MADT char(3), @STT int
as
begin
	if not exists ( select *
					from THAMGIADT tg
					where tg.MAGV=@MAGV)
	begin
		print 'MAGV khong ton tai'
		return 1
	end
	if not exists ( select *
					from THAMGIADT tg
					where tg.MADT=@MADT and STT=@STT)
	begin
		print 'Cong Viec Khong ton tai trong bang THAMGIADT'
		return 1
	end
	if  exists( select *
				from THAMGIADT tg
				where tg.MADT=@MADT and STT=@STT and tg.KETQUA is NOT NULL)
	begin
		print 'Cong Viec da co ket qua'
		return 1
	end
	delete THAMGIADT
	where MAGV=@MAGV and MADT=@MADT and STT=@STT and KETQUA is NULL
	if @@ROWCOUNT =0
	begin
		print 'Xoa Khong Thanh Cong'
		return 1;
	end
	return 0; 
end
go
exec Question10 '002','001',4
select * from THAMGIADT

--11
go
alter proc Question11
	@MAGV char(5)
as
begin
	if not exists ( select *
					from GIAOVIEN gv
					where gv.MAGV=@MAGV)
	begin
		print 'MAGV khong ton tai'
		return 1
	end
	if exists ( select *
				from KHOA kh
				where kh.TRUONGKHOA=@MAGV)
	begin
		print 'Giao Vien la Truong khoa'
		return 1
	end
	if exists ( select *
				from BOMON bm
				where bm.TRUONGBM=@MAGV)
	begin
		print 'Giao vien la Truong Bo Mon'
		return 1
	end
	if exists ( select *
				from DETAI dt
				where dt.GVCNDT=@MAGV)
	begin
		print 'Giao Vien co chu nhiem de tai'
		return 1
	end
	if exists ( select *
				from THAMGIADT tg
				where tg.MAGV=@MAGV)
	begin
		print 'Giao Vien co tham gia de tai'
		return 1
	end
	delete THAMGIADT 
	where MAGV=@MAGV
	if @@ROWCOUNT =0
	begin
		print 'Them Khong Thanh Cong'
		return 1;
	end
	return 0; 
end
go
exec Question11 '002'
select * from THAMGIADT