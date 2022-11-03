--1. Mỗi tựa sách có một tên tựa(tựa sách) duy nhất.
create trigger trg_KiemTraTuaSach_DuyNhat
on TuaSach
instead of INSERT, UPDATE
as 
begin
	if exists ( select * from TuaSach where TuaSach in (select TuaSach from inserted))
		begin
			raiserror ('Tua sach phai la duy nhat', 16, 1)
			rollback tran
			return
		end
end

insert into TuaSach(ma_tuasach,TuaSach) values (53, N'Nguoi me')
--2. Ngày hết hạn phải sau ngày mượn.
alter trigger trg_KiemTraNgay
on Muon
instead of insert,update
as 
	declare @NgayHetHan smalldatetime,@ErrMsg varchar(20)
	begin
		--Tính ra ngày hết hạn
		select @NgayHetHan = m.ngay_hethan
		from Muon m, inserted i
		where m.isbn = i.isbn
			--Kiểm tra ngày hết hạn sau ngày mượn
			if @NgayHetHan < (select ngayGio_muon from inserted)
			begin
				Rollback tran
				set @ErrMsg = N'Ngày hết hạn phải sau ngày mượn' +CONVERT(char(10), @NgayHetHan,103)
				RaisError (@ErrMsg,16,1)
			end
	end

insert into Muon
values(1,4,2,'2002-07-20','2002-07-19')
--3.. Sửa độc giả: cấm sửa mã đọc giả. Nếu sửa họ, tên và ngày sinh thì phải bảo khác 
--với họ, tên và ngày sinh hiện tại
create trigger trg_SuaDocGia
on DocGia
after update
as 
begin
	declare @old_ho nvarchar(15),
			@old_tenlot nvarchar(1), @old_ten nvarchar(15), @old_NgaySinh smalldatetime
	declare @new_ma_docgia int, @new_ho nvarchar(15),
			@new_tenlot nvarchar(1), @new_ten nvarchar(15), @new_NgaySinh smalldatetime

	select @old_ho = ho, @old_tenlot = tenlot, @old_ten = ten, @old_NgaySinh = NgaySinh
	from deleted

	select @new_ho = ho, @new_tenlot = tenlot, @new_ten = ten, @new_NgaySinh = NgaySinh
	from inserted

	if (update(ma_docgia))
	begin
		rollback tran
		raiserror ('Khong duoc sua ma doc gia', 16,1)
		return 
	end
	if(update(ho) and @old_ho = @new_ho)
	begin
		rollback tran
		raiserror ('Ho moi phai khac ho cu ', 16,1)
		return 
	end
	if(update(tenlot) and @old_tenlot = @new_tenlot)
	begin
		rollback tran
		raiserror ('Ten lot moi phai khac ten lot cu',16,1) 
		return
	end
	if(update(ten) and @old_ten = @new_ten)
	begin
		rollback tran
		raiserror ('Ten moi phai khac ten cu', 16,1)
	end
	if(update(NgaySinh) and @old_NgaySinh = @new_NgaySinh)
	begin
		rollback tran
		raiserror ('Ngay sinh moi phai khac ngay sinh cu',16,1)
		return
	end
end

update DocGia
set ho = N'Pham'
where ma_docgia =1 

--4.Mỗi độc giả người lớn chỉ có thể bảo lãnh tối đa cho 2 trẻ em.
alter trigger trg_BaoLanh 
on TreEm
after insert, update
as 
begin 
	declare @count int
	set @count = (select count(ma_docgia) as N'Số trẻ em bảo lãnh'
					from TreEm
					where ma_docgia_nguoilon = (select top 1 ma_docgia_nguoilon from inserted)
					group by ma_docgia_nguoilon
					)
				if (@count > 2)
				begin
					rollback tran
					raiserror ('Số trẻ em bảo lãnh > 2',16,1)
					return
					
				end
end

select count(ma_docgia) as N'Số trẻ em bảo lãnh'
from TreEm
where ma_docgia_nguoilon = 3
insert into TreEm
values(101,3)
insert into TreEm
values(102,3)
insert into TreEm
values(103,3)
--5.Một độc giả người lớn cùng 1 lúc chỉ mượn được tối đa 5 quyển sách thuộc 5 đầu sách khác nhau
create trigger trg_KiemTraSoSachMuonNguoiLon 
on Muon
after insert, update
as
begin
	declare @count int 
	set @count = (select count(isbn) as N'Số đầu sách đã mượn'
				from Muon
				where ma_docgia in (select ma_docgia from NguoiLon)
				and ma_docgia = (select top 1 ma_docgia from inserted)
				and ngayGio_muon = (Select top 1 ngayGio_muon from inserted))
	if (@count > 5)
	begin
		rollback tran
		raiserror ('Số sách đã mượn > 5',16,1)
		return
	end
end

select count(isbn) as N'Số đầu sách đã mượn'
from Muon
where ma_docgia=25
and ngayGio_muon= '2002-06-16'

insert into Muon
values(5,1,25,'2002/06/16', '2002/06/30')
insert into Muon
values(6,1,25,'2002/06/16', '2002/06/30')

insert into Muon
values(7,1,25,'2002/06/16', '2002/06/30')
insert into Muon
values(9,1,25,'2002/06/16', '2002/06/30')
insert into Muon
values(10,1,25,'2002/06/16', '2002/06/30')

--6.Một độc giả trẻ em cùng lúc chỉ được mượn 1 quyển sách. 
create trigger trg_TreEmMuonSach 
on Muon
after insert, update
as
begin 
	declare @count int
	set @count = (select count(isbn) as N'Số đọc giả trẻ em'
					from Muon
					where ma_docgia in( select ma_docgia from TreEm)
					and ma_docgia = (select top 1 ma_docgia from inserted)
					and ngayGio_muon = (Select top 1 ngayGio_muon from inserted)
					)
	if (@count > 1)
	begin
		rollback tran
		raiserror ('Số sách độc giả trẻ em mượn lớn hơn 1',16,1)
		return
	end
end

select count(isbn) as N'Số sách trẻ em mượn'
from Muon
where ma_docgia=24
and ngayGio_muon = '2002-06-16'

insert into Muon
values(4,1,24,'2002-06-16', '2002-06-30')

select *
from Muon
where ma_docgia =24

--7.Nếu độc giả người lớn có bảo lãnh trẻ em thì số sách của trẻ em đang mượn sẽ
--được tính vào số lượng sách đang mượn của độc giả người lớn này. 
create trigger trg_KiemTraSoSachTreEmMuon
on Muon
after insert, update
as
begin 
	declare @count_TreEm int 
	set @count_TreEm = 0
	if exists (select * from TreEm where ma_docgia_nguoilon in (select ma_docgia from inserted))
		begin
			set @count_TreEm = (select count(isbn) as 'Số đầu sách trẻ em (thuộc người lớn đang chỉnh sửa) đang mượn'
								from Muon
								where ma_docgia in (select ma_docgia from TreEm
													where ma_docgia_nguoilon in (select top 1 ma_docgia from inserted))
									and ngayGio_muon = (select top 1 ngayGio_muon from inserted))

		end
		declare @count_NguoiLon int
		set @count_NguoiLon = (select count(isbn) as 'Số đầu sách người lớn đã mượn'
								from Muon
								where ma_docgia in (select ma_docgia from NguoiLon)
								and ma_docgia = (select top 1 ma_docgia from inserted)
								and ngayGio_muon = (select top 1 ngayGio_muon from inserted)
								)
			if(@count_TreEm + @count_NguoiLon) >5
			begin
				rollback tran
				raiserror ('Số sách đã mượn >5',16,1)
				return
			end
end
select count(isbn) as 'Số đầu sách trẻ em (thuộc người lớn đang chỉnh sửa) đang mượn'
from Muon
where ma_docgia = 12
and ngayGio_muon = '06-15-2002'

select count(isbn) as 'Số đầu sách người lớn đã mượn'
from Muon
where ma_docgia = 11
and ngayGio_muon = '06-15-2002'

insert into Muon values (1,2,11,'06-15-2002','06-29-2002')

insert into Muon values (1,4,11,'06-15-2002','06-29-2002')

insert into Muon values (1,6,11,'06-15-2002','06-29-2002')


--8.Nếu độc giả trả sách thì thông tin mượn sẽ chuyển sang quá trình mượn.
create trigger trg_ChuyenThongTin_Muon_SangQuaTrinhMuon
on Muon
after delete
as
begin
	declare @isbn int, @ma_cuonsach int, @ma_docgia int, @ngayGio_muon smalldatetime, @ngay_hethan smalldatetime, @songaytrehan int
	declare @tienphat int
	select @isbn = isbn, @ma_cuonsach = ma_cuonsach, @ma_docgia = ma_docgia, @ngayGio_muon = ngayGio_muon, @ngay_hethan = ngay_hethan,
					@songaytrehan = datediff(dd, ngay_hethan,getdate())
	from deleted
	insert into QuaTrinhMuon
	values (@isbn, @ma_cuonsach,@ngayGio_muon,@ma_docgia, @ngay_hethan, GETDATE(), null,@songaytrehan * 3000, null, null)
end

delete from muon
where isbn =1 
and ma_cuonsach = 3
and ma_docgia = 2
--9. Khi xóa đọc giả, nếu đọc giả đang mượn sách thì không xóa, ngược lại thì tự động
--xóa thông tin liên quan của đọc giả
alter trigger trg_XoaDocGia_Khong_Muon
on DocGia
instead of delete
as
begin
		declare @ma_docgia smallint 
		select @ma_docgia = ma_docgia from deleted
		if  not exists ( select  ma_docgia from DocGia where ma_docgia in (select ma_docgia from Muon) and ma_docgia = @ma_docgia)
			begin
				if exists(select ma_docgia from NguoiLon where ma_docgia = @ma_docgia)
				begin
					delete from NguoiLon where ma_docgia = @ma_docgia
				end
				else
				begin	
					delete from TreEm where ma_docgia = @ma_docgia
				end
					delete from DocGia where ma_docgia = @ma_docgia
			end
			else
			begin
				rollback tran
				raiserror ('Đọc giả đang mượn sách',16,1)
				return
			end
end

delete from DocGia
where ma_docgia = 92
