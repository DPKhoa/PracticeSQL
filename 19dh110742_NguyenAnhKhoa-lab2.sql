--CÂU 1
drop proc sp_ThongtinDocGia 
create proc  sp_ThongtinDocGia 
	@MADG int
as
begin
	if exists (select * from DocGia where ma_docgia=@MADG)
	begin
		if exists (select * from NguoiLon where ma_docgia=@MADG)
		begin
			-- la nguoi lon
			select *
			from DocGia dg, NguoiLon nl
			where dg.ma_docgia=nl.ma_docgia
			and dg.ma_docgia=@MADG
		end
		else
		begin
			select *
			from DocGia dg, TreEm te
			where dg.ma_docgia=te.ma_docgia
			and dg.ma_docgia=@MADG
		end
	end
	else
		print 'Ma doc gia khong ton tai'
end
--
exec sp_ThongtinDocGia 3
exec sp_ThongtinDocGia 2
exec sp_ThongtinDocGia 20000


--CÂU 2
drop proc sp_ThongtinDausach 
CREATE PROC sp_ThongtinDausach 
	@isbn int
as
begin 
	if exists ( select * from DauSach where isbn = @isbn)
	begin
	select count(cs.isbn),ds.ngonngu,ds.bia,ts.tuasach, ts.tacgia,ts.tomtat,cs.TinhTrang
	from DauSach ds, CuonSach cs,  TuaSach ts
	where ds.isbn =cs.isbn and ts.ma_tuasach = ds.ma_tuasach
	and cs.TinhTrang = 'y'
	and ds.isbn = @isbn
	group by ds.ngonngu,ds.bia,ts.tuasach, ts.tacgia,ts.tomtat,cs.TinhTrang
	
	end 
	else
		print 'Sach da duoc muon'

end

exec sp_ThongtinDausach 9

--câu 3
DROP PROC sp_ThongtinNguoilonDangmuon
CREATE PROC sp_ThongtinNguoilonDangmuon
as
begin 
	begin
		SELECT DISTINCT DG.HO,TENLOT,DG.TEN,NGAYSINH,NL.sonha,duong,NL.dienthoai
		FROM MUON M, DOCGIA DG, NGUOILON NL
		WHERE M.ma_docgia = DG.ma_docgia AND NL.ma_docgia = M.ma_docgia
		END
	end

exec sp_ThongtinNguoilonDangmuon 

--câu 4
drop proc sp_ThongtinNguoilonQuahan 
CREATE PROC sp_ThongtinNguoilonQuahan 
as 
begin 
		declare @songay int
		select @soNgay = datediff(day, ngayGio_tra, ngay_hethan)
		from QuaTrinhMuon
		if @soNgay > 14
		begin
			select dg.*
			from DocGia dg, QuaTrinhMuon qtm, NguoiLon nl
			where dg.ma_docgia = qtm.ma_docgia and nl.ma_docgia = dg.ma_docgia
		end
		else
			print 'Khong co doc gia nao'
end 
-- 
exec sp_ThongtinNguoilonQuahan 

--câu 5
create proc sp_DocGiaCoTreEmMuon
as
begin 
	begin
	select distinct te.*, nl.*
	from CuonSach cs, NguoiLon nl, TreEm te, QuaTrinhMuon qtm
	where nl.ma_docgia = te.ma_docgia_nguoilon and cs.isbn = qtm.isbn and qtm.ma_docgia = nl.ma_docgia
	end
end
--
exec sp_DocGiaCoTreEmMuon

--câu 6
drop proc sp_CapnhatTrangthaiDausach 
create proc sp_CapnhatTrangthaiDauSach
	@ISBN int
as
begin
	declare @sluongSach int
	if exists (select * from DauSach where isbn=@ISBN)
	begin
		select @sluongSach= COUNT (*)
		from CuonSach
		where isbn=@isbn and TinhTrang='Y'
		if (@sluongSach=0)
		begin
			update DauSach
			set trangthai ='Y'
			where isbn=@ISBN
		end
		if (@sluongSach>=1)
			update DauSach
			set trangthai='N'
			where isbn = @ISBN
	end
	else
		print 'Dau sach khong ton tai'
end


exec sp_CapnhatTrangthaiDauSach 7

-- 
exec sp_CapnhatTrangthaiDausach 30


--câu 9
create proc sp_ThemNguoilon 
	@ho nvarchar(15),
	@tenlot nvarchar(1),
	@ten nvarchar(15),
	@NgaySinh datetime,
	@sonha nvarchar(15),
	@duong nvarchar(63),
	@quan nvarchar(2),
	@dienthoai nvarchar(13)
as
declare @ma int,
@han_sd smalldatetime
begin
	begin try
		if(@ho is null or @ten is null or @NgaySinh is null 
				or @sonha is null or @duong is null or @quan is null)
		begin
			print 'Thong tin nhap rong'
			return
		end
		
		if(DATEDIFF(YY,@NgaySinh,GETDATE())<=18)
		begin
			print 'Khong du tuoi'
			return
		end
		
	end try
	
	begin catch
		--báo lỗi
		print 'Them khong thanh cong'
	end catch
	
	set @ma=1
	while(exists(select * from DocGia where ma_docgia=@ma))
		set @ma=@ma+1
	
	set @han_sd=DATEADD(mm,12,GetDate())
	
	Insert into DocGia values(@ma,@ho,@tenlot,@ten,@NgaySinh)
	insert into NguoiLon values(@ma,@sonha,@duong,@quan,@dienthoai,@han_sd)
	
end

EXEC sp_ThemNguoilon 'nguyen','van','a','5/5/2000','123', 'Su Van Hanh','q10','0356987'
EXEC sp_ThemNguoilon 'tran','van','B','5/5/2000','456', 'Su Van Hanh','q10','0356987'


delete from Nguoilon where ma_docgia=102
delete from DocGia where ma_docgia=102
EXEC sp_ThemNguoilon 'Le','thi','C','5/5/2000','456', 'Su Van Hanh','q10','0356987'

--câu 7
drop proc  sp_ThemTuaSach
create proc sp_ThemTuaSach
@tuasach nvarchar(63),
@tacgia nvarchar(31),
@tomtat varchar(222)
as 
begin
	
		if exists(select * from TuaSach where TuaSach=@tuasach or tacgia = @tacgia or tomtat = @tomtat)
		begin
			print 'Tua sach da ton tai'
			return
	end
	else
		declare @maSach int
		set @maSach=1
		while(exists(select * from TuaSach where ma_tuasach=@maSach))
		set @maSach=@maSach+1
		insert into TuaSach values (@maSach,@tuasach, @tacgia, @tomtat)
		print 'them tua sach thanh cong'
end

exec sp_ThemTuaSach N'last of us',N'Ronadol Bus','jashdjkasdhas'
delete from TuaSach where ma_tuasach = 51
exec sp_ThemTuaSach N'Lemon', N'Motojirou',NULL
delete from TuaSach where ma_tuasach = 54
exec sp_ThemTuaSach N'cuoc doi cua chu cho',N'Nguyen Anh Khoa',null 
delete from TuaSach where ma_tuasach = 51
exec sp_ThemTuaSach N'ai bit gi dau',N'Nguyen Khoa Anh','sasdasd'
delete from TuaSach where ma_tuasach = 52

--câu 8 
create proc sp_ThemCuonSach 
@isbn int
as
begin
	if not exists(select * from DauSach where isbn = @isbn)
	begin 
		print 'Sach khong ton tai '
		return 
	end
	else
	begin 
	declare @maCuonsach int
	set @maCuonsach = 1 
	while exists(select * from CuonSach where Ma_CuonSach = @maCuonsach)
	set @maCuonsach = @maCuonsach + 1
	insert into CuonSach values (@isbn, @maCuonsach, 'Y')
	update DauSach
	set trangthai = 'Y'
	where isbn = @isbn
	end
end

---
exec sp_ThemCuonSach 13
--câu 10
DROP PROC sp_ThemTreEm
create proc sp_ThemTreEm
	@ho nvarchar(15),
	@tenlot nvarchar(1),
	@ten nvarchar(15),
	@NgaySinh datetime, 
	@MaDocgia_nguoilon smallint
as

begin 
	declare @tuoi int
	set @tuoi = YEAR(GETDATE()) - YEAR(@NgaySinh)
	if (@tuoi < 18)
	if (select count(*) from TreEm where ma_docgia_nguoilon = @MaDocgia_nguoilon) < 2
	begin 
	declare @ma int =1
	while (exists(select * from DocGia where ma_docgia = @ma))
		set @ma = @ma + 1
		insert into DocGia values (@ma, @ho, @tenlot, @ten,@NgaySinh)
		insert into TreEm values (@ma,@MaDocgia_nguoilon)
	end
	else
		print 'Vi pham QD-3'
	else
		print ' Khong phai doc gia tre em '

end
--- 
exec sp_ThemTreEm N'Nguyen',N'A',N'Khoa','2006/12/30',1