--Tao proc thay the proc SP_adduseraccount--
create procedure SP_adduseraccount
@iduser nvarchar(50) output,
@password nvarchar(50),
@username nvarchar(50),
@role tinyint,
@status tinyint
as
begin select*from role
	declare @no int,@roleid nvarchar(10)
	select @roleid=idrole from role where @role=idrole
	if(not exists (select*from useraccount where iduser like @roleid))
	begin
		set @no=1
	end
	else
	begin
		select @no=count(*) from useraccount,role where @role=idrole and iduser like roleid
		set @no=@no+1
	end
	select @iduser=(roleid + replicate('0',3-len(cast(@no as nvarchar(3)))) + cast(@no as nvarchar(3))) from role where idrole=@role
	insert into useraccount(iduser,password,username,role,status) values(@iduser,@password,@username,@role,@status)
end

--Tao proc SP_addcategory--
create procedure SP_addcategory
@idcategory nvarchar(50),
@namecategory nvarchar(50)
as
begin
	insert into category(idcategory,namecategory) values(@idcategory,@namecategory)
end

--Tao proc SP_additem--
create alter procedure SP_additem
@iditem nvarchar(50) output,
@idcategory nvarchar(50),
@nameitem nvarchar(50),
@quantity int,
@importprice float,
@exportprice float
as
begin
	declare @no int
	if(not exists (select*from item))
	begin
		set @no=1
	end
	else
	begin
		select @no=count(*) from item
		set @no=@no+1
	end
	set @iditem=('SP' + replicate('0',4-len(cast(@no as nvarchar(4)))) + cast(@no as nvarchar(3)))
	insert into item(iditem,idcategory,nameitem,quantity,importprice,exportprice) values(@iditem,@idcategory,@nameitem,@quantity,@importprice,@exportprice)
end

--Tao proc thay the Sp_addreceipt--
create procedure SP_addreceipt
@idreceipt nvarchar(50) OUTPUT,
@iduser nvarchar(50),
@date DateTime,
@idtype int,
@total float
as
begin 
	declare @no int
	if(not exists (select*from receipt))
	begin
		set @no=1
	end
	else
	begin 
		set @no=(select count(*) from receipt) + 1
	end
	set @idreceipt=('R'+(replicate('0',7-len(cast(@no as nvarchar(50)))))+cast(@no as nvarchar(50)))
	if(@idtype=2)
	begin
		set @total=@total*-1 
	end
	insert into receipt(idreceipt,iduser,date,idtype,total,status) values(@idreceipt,@iduser,@date,@idtype,@total,1)
end

--Tao proc thay the SP_addreceiptdetail--
create procedure SP_addreceiptdetail
@idreceipt nvarchar(50),
@idreceiptdetail nvarchar(50),
@iditem nvarchar(50),
@quantity int,
@subtotal float
as
begin
	set @idreceiptdetail=(@idreceipt+('CT'+(replicate('0',3-len(cast(@idreceiptdetail as nvarchar(50)))))+cast(@idreceiptdetail as nvarchar(50))))
	declare @idtype int
	select @idtype=idtype from receipt where idreceipt=@idreceipt
	if(@idtype=2)
	begin
		set @subtotal=@subtotal*-1 
	end
	declare @itemquantity int
	set @itemquantity=(select quantity from item where iditem=@iditem)
	set @itemquantity=@itemquantity-@quantity
	update item set quantity=@itemquantity where iditem=@iditem
	insert into receiptdetail(idreceipt,idreceiptdetail,iditem,quantity,subtotal) values(@idreceipt,@idreceiptdetail,@iditem,@quantity,@subtotal)
end

--Tao proc SP_sendmail--
create procedure SP_sendmail
@sender nvarchar(50),
@receiver nvarchar(50),
@subject nvarchar(50),
@content nvarchar(1000)
as
begin
	declare @idmail nvarchar(50)
	declare @no int
	set @no=(select count(*) from mail) 
	if(@no=0)
	begin
		set @idmail='M000001' 
	end
	else
	begin
		set @no=@no+1 
		set @idmail=('M'+(replicate('0',6-len(cast(@no as nvarchar(50)))))+cast(@no as nvarchar(50)))
	end
	insert into mail(idmail,sender,receiver,subject,content,status) values(@idmail,@sender,@receiver,@subject,@content,N'Chưa đọc')
end