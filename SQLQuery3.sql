Create database MyLibrarydb
use MyLibrarydb
drop table Authors

create table Books
(Id int identity Primary key,
Name nvarchar(100) Not Null  Check(Len(Name)>=2 AND  Len(Name)<=100) ,
PageCount int not null	Check(PageCount>=10) 
) 
create table Authors
(Id int identity Primary key,
Name nvarchar(25) Not Null ,
SurName nvarchar(25) Not Null
) 


Alter Table Books
Add AuthorId int Not Null Foreign Key References Authors(Id)
Insert into Authors(Name,SurName)
Values
('Huseyn','Khalidi'),
('Mikayil','Musfiq'),
('Celil',' Memmedquluzade'),
('Jostein','Gaarder')

Select * FROM Books
Insert into Books
Values
('Min mohtesem gunes',234,1),
('Cerpeleng ucuran',123,1),
('Secilmis eserler',451,2),
('Secilmis eserler',101,3),
('Sofianin Dunyasi',654,4)
Select * FROM Authors
Select * FROM Books
Create View usv_GetBooksAuthorInfo
as
Select
b.Name as BookName,
b.PageCount as PageCount,
(a.Name+' '+ a.SurName) as AuthorFullName
From Books b 
Join Authors a
On b.AuthorId=a.Id

Select * FROM  usv_GetBooksAuthorInfo


Create Table ArchiveAuthors
(
	Id int,
	Name nvarchar(10),
	Surname nvarchar(25),
	Date DateTime2,
	StatementType nvarchar(25)
)

Create Trigger AuthorChanges
on Authors
after insert
as
Begin
	declare @id int
	declare @name nvarchar(10)
	declare @surname nvarchar(25)
	declare @date DateTime2
	declare @statementType nvarchar(25)

	Select @id = a.Id From inserted a
	Select @name = a.Name From inserted a
	Select @surname=a.Surname From inserted a
	Select @date = GETUTCDATE() From inserted a
	Select @statementType = 'Inserted' From inserted a

	Insert Into ArchiveAuthors(Id, Name,Surname, Date, StatementType)
	Values
	(@id,@name,@surname,@date,@statementType)
End


Create Trigger AuthorUpdateChanges
on Authors
after update
as
Begin
	declare @id int
	declare @name nvarchar(10)
	declare @surname nvarchar(25)
	declare @date DateTime2
	declare @statementType nvarchar(25)

	Select @id = a.Id From inserted a
	Select @name = a.Name From inserted a
	Select @surname=a.Surname From inserted a
	Select @date = GETUTCDATE() From inserted a
	Select @statementType = 'Updated' From inserted a

	Insert Into  AuthorUpdateChanges(Id, Name,Surname, Date, StatementType)
	Values
	(@id,@name,@surname,@date,@statementType)
End


Create Trigger AuthorDeleteChanges
on Authors
after Delete
as
Begin
	declare @id int
	declare @name nvarchar(10)
	declare @surname nvarchar(25)
	declare @date DateTime2
	declare @statementType nvarchar(25)

	Select @id = a.Id From deleted a
	Select @name = a.Name From deleted a
	Select @surname=a.Surname From deleted a
	Select @date = GETUTCDATE() From deleted a
	Select @statementType = 'deleted' From deleted a

	Insert Into AuthorDeleteChanges(Id, Name,Surname, Date, StatementType)
	Values
	(@id,@name,@surname,@date,@statementType)
End

Insert into Authors
Values
('AuthorName','AuthorSurName')
Insert into Books
Values
('Books',214,5)

Create View usv_GetBooksStatistic
as
Select 
a.Id as [AuthorId],
a.Name as [AuthorName],
COUNT(*) as [BookCount],
MAX(b.PageCount) as [MaxPage count]
From Books b 
Join Authors a
On b.AuthorId=a.Id
Group By a.Id,a.Name

Select * From usv_GetBooksStatistic














