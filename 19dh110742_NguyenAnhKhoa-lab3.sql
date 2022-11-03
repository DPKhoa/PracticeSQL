drop proc sp_themcuonsach
create proc sp_themcuonsach
	@isbn int
as 
begin
	declare @count int
	set @count = 1
	if not exists (select ds.isbn from dausach ds where ds.isbn = @isbn)
	begin
	raiserror ('Xem lại, thông tin này không đúng',16,1)
	return
	end
	else
	begin
		while (exists (select cs.ma_cuonsach from CuonSach cs where cs.Ma_CuonSach = @count and  cs.isbn = @isbn))
			set @count = @count + 1
		insert into CuonSach(isbn,Ma_CuonSach, TinhTrang)
		values(@isbn,@count,'Y')
		update DauSach set trangthai = 'Y' where isbn = @isbn
		end
	end
---- Trasach
create proc sp_trasach @isbn int, @ma_cuonsach int
as
begin
declare @so_ngay_qua_han int,
		@tienphat int,
		@ngaygio_muon smalldatetime,
		@ngay_hethan smalldatetime,
		@ma_docgia int
if not exists(select * from muon
				where @isbn = isbn and @ma_cuonsach = ma_cuonsach)
				raiserror('Xem lại, thông tin này không đúng',16,1)
			else
			begin
				set @so_ngay_qua_han = datediff("d",(select ngay_hethan
														from Muon
														where @isbn	= isbn and @ma_cuonsach = ma_cuonsach),getdate())
				set @tienphat = 0
				if @so_ngay_qua_han > 0
				set @tienphat = 3000 * @so_ngay_qua_han
							select @ngaygio_muon = ngaygio_muon,
									@ngay_hethan = ngay_hethan,
									@ma_docgia = ma_docgia
									from Muon
									where @isbn = isbn and @ma_cuonsach = ma_cuonsach
								insert into quatrinhmuon(isbn, ma_cuonsach, 
								ngaygio_muon,ma_docgia,ngay_hethan,ngayGio_tra, 
								tien_muon,tien_datra, tien_datcoc,ghichu) 
								values(@isbn,@ma_cuonsach,@ngaygio_muon,@ma_docgia, 
								@ngay_hethan, getdate(),null,@tienphat,null,null)

								delete from Muon
								where isbn = @isbn and ma_cuonsach = @ma_cuonsach
								end 
							end
----Tra cứu độc giả đang mượn sách
create proc sp_tracuu_docgia_dangmuonsach
	@madg int
as	
select isbn,ma_cuonsach, ngaygio_muon, ngay_hethan
from Muon
where ma_docgia = @madg

--Xóa độc giả
drop proc sp_XoaDocGia
create proc sp_XoaDocGia
@ma_docgia smallint
as
begin 
	begin
	if exists (Select * from DangKy where  ma_docgia = @ma_docgia)
	delete from DangKy where  ma_docgia = @ma_docgia
	end
	begin
		if exists (select * from QuaTrinhMuon where  ma_docgia = @ma_docgia)
		begin
		delete from QuaTrinhMuon where  ma_docgia = @ma_docgia
		end
	end 
	begin 
	if exists ( select * from DocGia where  ma_docgia = @ma_docgia )
		begin 
			if exists (select * from NguoiLon where  ma_docgia = @ma_docgia )
			--là người lớn
				select * 
				from DocGia dg, NguoiLon nl
				where dg.ma_docgia = nl.ma_docgia
				and dg.ma_docgia = @ma_docgia
			begin 
				select * 
				from NguoiLon nl, TreEm te
				where nl.ma_docgia = te.ma_docgia_nguoilon
				and nl.ma_docgia = @ma_docgia
			end
				begin 
					delete from TreEm where ma_docgia_nguoilon = @ma_docgia 
				end 
			begin 
				if exists ( select ma_docgia from Muon where  ma_docgia = @ma_docgia)
						raiserror('Doc gia dang muon sach',16,1)
						
			
			end
			end
				else
					
						begin 
						delete from NguoiLon where  ma_docgia = @ma_docgia
						
						
						delete from DocGia where  ma_docgia = @ma_docgia
						end
					
			
		
			end
			
		end

exec sp_XoaDocGia 1

---Mượn sách
drop proc sp_MuonSach
create proc sp_MuonSach 
@ma_cuonsach smallint,
@maDg smallint,
@isbn int
as
begin 
	begin
	if exists (select M.ma_docgia from Muon M where M.ma_docgia = @maDg and ma_cuonsach = @ma_cuonsach and M.isbn= @isbn )
	begin
		raiserror ('Quyển sách này đã được mượn',16,1)
	end
	else
	begin
		if  exists (select CS.Ma_CuonSach from CuonSach CS where CS.Ma_CuonSach = @ma_cuonsach and cs.isbn = @isbn and CS.TinhTrang = 'N' )
		begin 
			print 'Sách đã hết'
			insert into DangKy(isbn, ma_docgia, ngaygio_dk)
			values (@isbn,@maDg,getdate())
		end
		begin 
			if exists (select NL.ma_docgia from NguoiLon NL where NL.ma_docgia = @maDg)
			begin
				if (select count(M.ma_docgia) from Muon M where M.ma_docgia = @maDg)<5
				begin
					print('Muon thanh cong')
					insert into Muon (isbn, ma_cuonsach, ma_docgia, ngayGio_muon)
					values (@isbn, @ma_cuonsach, @madg, GETDATE())

				end
				else
				begin
					print('Muon sach khong duoc chap nhan do vi pham QD-4, 6')
				end
			end
			else
			begin
				if(select count(M.ma_docgia) from Muon M where M.ma_docgia = @maDg) <1
				begin
					print('Muon thanh cong')
					insert into Muon (isbn, ma_cuonsach, ma_docgia, ngayGio_muon)
					values (@isbn, @ma_cuonsach, @madg, GETDATE())
				end
				else
				begin
					print('Muon sach khong duoc chap nhan do vi pham QD5., 6')
				end
			end
		end
		
	end
end
end

exec sp_MuonSach 3,2,1