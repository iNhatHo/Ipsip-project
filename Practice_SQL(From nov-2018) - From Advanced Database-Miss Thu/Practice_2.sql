--1.
go
alter proc tenN
	@ten nvarchar(50)
	as
	begin
		print N'Xin chào ' + @ten
	end 
go
exec tenN N'Nhat'
--2.
go
alter proc tongN1
	@a int, @b int
	as
	begin
		print @a+@b
	end 
go
exec tongN1 3,8
--3.
go
alter proc tongN2
	@a int, @b int, @tong int out
	as
	begin
		set @tong=@a+@b
		print @tong
	end 
go
declare @tong int 
exec tongN2 14,6, @tong output
--4.
go
alter proc tongN3
	@a int, @b int
	as
	begin
		return @a+@b
	end
go
declare @kq int
exec @kq=tongN3 2,3
print @kq
--5.
go 
alter proc tongN4
	@a int, @b int, @kq int out
	as
	begin
		set @kq=0
		if @a>@b
		begin
			declare @i int
			set @i = @b
			while @i <= @a
			begin 
				set @kq=@kq+@i
				set @i=@i+1
			end
		end
		else if @a = @b
		begin
			set @kq = 0;
		end
		else if @a < @b
		begin
			set @kq = -1;
		end
		print @kq
	end
go
declare @kq int
exec tongN4 9,8, @kq output
--6.
go 
alter proc tongN5
	@a int, @b int
	as
	begin
		declare @kq int
		set @kq=0
		if @a>@b
		begin
			declare @i int
			set @i = @b
			while @i <= @a
			begin 
				set @kq=@kq+@i
				set @i=@i+1
			end
		end
		else if @a = @b
		begin
			set @kq = 0;
		end
		else if @a < @b
		begin
			set @kq = -1;
		end
		return @kq
	end
go
declare @kq int
exec @kq=tongN5 8,3
print @kq
--7.
go
create proc nguyento
	@a int
	as
	begin
		declare @i int;
		declare @y int;
		declare @mod int;
		set @i = 0;
		set @mod = 1;
		while @mod <= @a
		begin
			set @y = @a % @mod;
			if @y = 0
				begin
					set @i = @i + 1;
				end;
			set @mod = @mod + 1;
		end;
		if @i = 2
		begin
			return 1;
		end
		else
		begin
			return -1;
		end;
	end
go 
declare @a int
exec @a=nguyento 10
print @a
--8.
go
alter proc demngto
	@a int, @b int 
	as
	begin
		declare @i int
		set @i = 0
		while @a <= @b
		begin
			declare @kq int
			exec @kq=ktngto @a
			if @kq = 1
			begin
				set @i = @i + 1
			end
			set @a = @a + 1
		end
		print @i
	end

go 
exec demngto 1,3
--9
go
alter proc chanhayle
	@n int
as
begin
	declare @i int
	set @i=@n % 2
	if @i = 0
	begin
	  return 1
	end
	else
	begin
		return -1
	end
	end
go
declare @a int
exec @a=chanhayle 5
print @a
--10
go
alter proc ngtole
	@a int, @b int
	as
	begin
		declare @i int
		set @i = 0
		while @a <= @b
		begin
			declare @kq int
			declare @kgl int
			exec @kq=ktngto @a
			if @kq = 1
			begin
				exec @kgl=chanhayle @a
				if @kgl = -1
				begin
				set @i = @i + 1
			end
			end
			set @a = @a + 1
		end
		print @i
	end
go 

exec ngtole 1,7
