--Câu 1. Dùng con trỏ hiển thị thông tin như sau:
declare c_DocThongTin CURSOR
SCROLL
FOR 
	select DG.ma_docgia, ho+ ' '+tenlot+ ' '+ten AS HoTen, DK.isbn, TS.TuaSach, DK.ngaygio_dk
	from DocGia DG, DangKy DK, DauSach DS, TuaSach TS
	where DG.ma_docgia = DK.ma_docgia
	and DS.isbn = DK.isbn
	and DS.ma_tuasach = TS.ma_tuasach

	--Mở con trỏ
	OPEN c_DocThongTin
	declare @ma_docgia int, @hoten nvarchar(31), @isbn int,
				@TuaSach nvarchar(63), @ngaygio_dk smalldatetime
	declare @i int
	set @i = 1
	--truy xuất từng dòng trong con trỏ
	fetch next from c_DocThongTin
	into @ma_docgia, @hoten, @isbn, @TuaSach, @ngaygio_dk

	while @@FETCH_STATUS = 0 
	begin
		fetch next from c_DocThongTIn
		into @ma_docgia, @hoten, @isbn, @TuaSach, @ngaygio_dk

		print cast(@i as nvarchar(10))+': Ma doc gia: '+cast(@ma_docgia as nvarchar(10))+
				'		Ho ten: '+@hoten+ '		isbn: '+cast(@isbn as nvarchar(15))+
				'		Tua sach: '+@TuaSach+'		ngay dang ky:	'+cast(@ngaygio_dk as nvarchar(15))
		set @i = @i + 1
	END
	--Đóng con trỏ và xóa khỏi bộ nhớ 
	close c_DocThongTin
	deallocate c_DocThongTin

--Câu 2. Giả sử thêm vào bảng DocGia thuộc tính LoaiDG. Nếu độc giả là người lớn 
--thì cập nhật giá trị ‘người lớn’ vào thuộc tính LoaiDG và ngược lại.
alter table DocGia
add LoaiDG nvarchar(10)
drop  c_updateDocGiaNguoiLon cursor
declare c_updateDocGiaNguoiLon CURSOR
scroll
for 
	select ma_docgia
	from  NguoiLon 

	open c_updateDocGiaNguoiLon

	declare @madocgia int
	fetch next from c_updateDocGiaNguoiLon
	into @madocgia

	while @@FETCH_STATUS = 0
		begin 
			fetch next from c_updateDocGiaNguoiLon
			into @madocgia

			update DocGia
			set LoaiDG = N'Người lớn'
			where ma_docgia = @madocgia
		end

	close c_updateDocGiaNguoiLon
	deallocate c_updateDocGiaNguoiLon


----------------FUNCTION
--Câu 1.Nhập vào tháng năm cho biết có bao nhiêu sách mượn
create function f_SoSachMuon(@thang int, @nam int)
returns int as 
begin
	declare @soSachMuon int 
	set @soSachMuon = (select count(isbn)
						from Muon
						where MONTH(ngayGio_muon)=@thang
						and YEAR(ngayGio_muon)=@nam)
	return @soSachMuon
end
select dbo.f_SoSachMuon(7,2002) as 'Số sách mượn'

--Câu 2.Nhập vào năm cho biết có bao nhiêu độc giả mượn ít nhất một cuốn sách
drop function f_SoDocGia
create function f_SoDocGia(@nam int)
returns int as
begin 
	declare @soDocGia int
	set @soDocGia = (select distinct count(ma_cuonsach)
						from Muon
						where YEAR(ngayGio_muon)=@nam
						having count(ma_cuonsach)>=1)
	return @soDocGia
end
select dbo.f_SoDocGia (2002) as 'Số độc giả'

--Câu 3.Nhập vào isbn cho biết thời gian trung bình mượn sách là bao lâu
alter function f_TGTBMuonSach(@isbn int)
returns int as
begin
	declare @ThoiGian int
	set @ThoiGian = (select avg(day(ngayGio_tra)- day(ngayGio_muon))
					from QuaTrinhMuon
					where isbn = @isbn)
	return @ThoiGian
end
select dbo.f_TGTBMuonSach(2)

--Câu 4.Nhập vào mã đọc giả cho biết đọc giả đó có mượn sách quá hạn bao nhiêu lần
alter function f_SachQuaHan(@ma_docgia smallint)
returns int as
begin
	declare @SoLanQuaHan int, @SoNgayQuaHan int
	set @SoLanQuaHan =(select count(datediff(day,ngay_hethan,ngayGio_tra))
						from QuaTrinhMuon
						where ma_docgia = @ma_docgia
						and datediff(day, ngayGio_muon,ngayGio_tra) > 14)
	return @SoLanQuaHan
end

select dbo.f_SachQuaHan(23)
--Câu 5. Nhập vào đầu sách cho biết đầu sách có hiện đang còn bao nhiêu cuốn.
create function f_SachCon(@ma_tuasach int)
returns int as 
begin 
	declare @soCuon int
	set @soCuon = (select count(ma_tuasach)
					from DauSach
					where trangthai = 'Y'
					and ma_tuasach = @ma_tuasach) 
	return @soCuon
end
select dbo.f_SachCon(2)
--Câu 6.Nhập vào mã đọc giả cho biết thông tin những sách mà đọc giả đó đã từng mượn
create function f_SachTungMuon (@ma_docgia int)
returns table
as
	return ( select M.isbn, t.ma_tuasach, ngonngu,bia, trangthai, Tuasach, tacgia, tomtat
			from Muon M, DauSach D, Tuasach T
			where t.ma_tuasach = d.ma_tuasach
			and M.isbn = D.isbn
			and m.ma_docgia = @ma_docgia
		union
			select M.isbn, t.ma_tuasach, ngonngu, bia, trangthai, TuaSach, tacgia, tomtat
			from QuaTrinhMuon M, DauSach D, TuaSach T
			where t.ma_tuasach = d.ma_tuasach
			and m.isbn = d.isbn
			and m.ma_docgia = @ma_docgia)
select * from dbo.f_SachTungMuon (5)

---Câu 7.Nhập vào đầu sách cho biết thông tin về đầu sách đó.
create function f_ThongTinDauSach(@ma_tuasach int)
returns @BangDauSach Table (isbn int, ma_tuasach int, ngonngu nvarchar(15),bia nvarchar(15), trangthai nvarchar(1))
as
begin
	insert into @BangDauSach
		select isbn, ma_tuasach, ngonngu, bia, trangthai
		from DauSach
		where ma_tuasach = @ma_tuasach
		return
end
select * from dbo.f_ThongTinDauSach(1)

--Câu 8.Nhập vào đầu sách cho biết đầu sách đó đã có bao nhiêu người lớn và bao nhiêu trẻ em mượn.
drop function f_NguoiLonTreEm
create function f_NguoiLonTreEm(@ma_tuasach int)
returns @SL_Muon table (sl_NL int, sl_TE int)
as
begin
	insert into @SL_Muon
		SELECT      
			sum(count1.[COUNT]),
            sum(count2.[COUNT2])
			FROM
			(
				select NL.ma_docgia as nl2 ,count(m.ma_docgia) as COUNT
				from NguoiLon nl, DauSach ds,TuaSach ts,Muon m
				where m.ma_docgia = nl.ma_docgia and ds.isbn = m.isbn and ts.ma_tuasach = ds.ma_tuasach
				and ds.ma_tuasach = @ma_tuasach
				group by NL.ma_docgia
    
			) count1
			FULL OUTER JOIN
			(
				select te.ma_docgia as te2,count(m.ma_docgia) as COUNT2
				from TreEm te, DauSach ds,TuaSach ts,Muon m 
				where m.ma_docgia = te.ma_docgia and ds.isbn = m.isbn and ts.ma_tuasach = ds.ma_tuasach
				and ds.ma_tuasach = @ma_tuasach
				group by te.ma_docgia

			) count2 ON count2.te2 = count1.nl2

	return
end
				

select * from dbo.f_NguoiLonTreEm(3)
--Câu 9. Viết hàm thực hiện chức năng mã hóa tiếng việt.
create function f_MaHoaChuoi(@input nvarchar(20))
returns VARBINARY(8000)
as
begin
	declare @Default varchar(32)
	declare @output varbinary(8000)
	set @Default = '9CE08BE9AB824EEF8ABDF4EBCC8ADB19'
	set @output = HASHBYTES('SHA2_256', (@input + @default))
	return @output
	end

select dbo.f_MaHoaChuoi('Toi di hoc')