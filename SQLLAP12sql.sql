drop database ex12
create database ex12
go
use ex12
go
create table Employee (
	EmployeeID int not null,
	Name varchar(100),
	Tel char(11),
	Email varchar(30)
)
insert into Employee values (1,'thinh1','09111111','thinh1@gmail.com'),
							(2,'thinh2','09222222','thinh2@gmail.com'),
							(3,'thinh3','09333333','thinh3@gmail.com'),
							(4,'thinh4','09444444','thinh4@gmail.com'),
							(5,'thinh5','09555555','thinh5@gmail.com'),
							(6,'thinh6','09666666','thinh6@gmail.com'),
							(7,'thinh7','09777777','thinh7@gmail.com'),
							(8,'thinh8','09888888','thinh@8gmail.com')
							insert into Employee values (10,'thinh1','09111t','thinh1@gmail.com')
go
create table Groups(
	GroupID int not null,
	GroupName varchar(30),
	LeaderID int,
	ProjectID int
)
insert into Groups values (100,'GroupName1',1,500),
							(101,'GroupName1',3,501),
							(102,'GroupName1',5,500),
							(103,'GroupName1',7,503),
							(104,'GroupName1',1,504),
							(105,'GroupName1',2,505),
							(106,'GroupName1',1,500)
create table Project(
	ProjectID int not null,
	ProjectName varchar(30),
	StartDate datetime,
	EndDate datetime,
	Period int,
	Cost money
)
insert into Project values (500,'ProjectName1','19980906','20200606',22,123),
							(501,'ProjectName2','20110206','20220606',1113,324),
							(502,'ProjectName3','19981126','20210606',444,437),
							(503,'ProjectName4','19981206','20190606',64,45655),
							(504,'ProjectName5','20200907','20220607',32,667),
							(505,'ProjectName6','20220114','20220809',76,544),
							(506,'ProjectName7','20220325','20230405',12,6787),
							(507,'ProjectName8','20170713','20340607',987,547),
							(508,'ProjectName8','20191005','20260809',12,867),
							(509,'ProjectName9','20211207','20280910',57,6577)
create table GroupDetail(
	GroupID int not null,
	EmployeeID int not null ,
	Status char(20)
)
insert into GroupDetail values (100,1,'done'),
								(102,2,'not done'),
								(103,3,'not done'),
								(104,4,'not done'),
								(101,2,'done'),
								(102,3,'done'),
								(103,6,'done')
go
ALTER TABLE Employee
ADD CONSTRAINT Employee_PK PRIMARY KEY (EmployeeID)
go
ALTER TABLE Groups
ADD CONSTRAINT GroupID_PK PRIMARY KEY (GroupID);
go
ALTER TABLE Project
ADD CONSTRAINT Project_PK PRIMARY KEY (ProjectID);
go
ALTER TABLE Groups
ADD CONSTRAINT fk_ProjectID
  FOREIGN KEY (ProjectID)
  REFERENCES Project (ProjectID)
  go
  ALTER TABLE GroupDetail
ADD CONSTRAINT fk_GroupDetail
  FOREIGN KEY (GroupID)
  REFERENCES Groups (GroupID)
  go
   ALTER TABLE GroupDetail
ADD CONSTRAINT fk_GroupDetails
  FOREIGN KEY (EmployeeID)
  REFERENCES Employee (EmployeeID)
  go
     ALTER TABLE Groups
ADD CONSTRAINT fk_G1
  FOREIGN KEY (LeaderID)
  REFERENCES Employee (EmployeeID)
  go

  --------------a. Hiển thị thông tin của tất cả nhân viên
  select * from Employee
  -----------------Liệt kê danh sách nhân viên đang làm dự án “ProjectName2”
  select Employee.EmployeeID,Employee.Name from Project join Groups on Project.ProjectID=Groups.ProjectID join GroupDetail on Groups.GroupID=GroupDetail.GroupID
  join Employee on GroupDetail.EmployeeID=Employee.EmployeeID and ProjectName='ProjectName2'
  go
  -------------------------Thống kê số lượng nhân viên đang làm việc tại mỗi nhóm
  select Groups.GroupID,count(GroupDetail.EmployeeID)as soluong from  GroupDetail join Groups  on GroupDetail.GroupID=Groups.GroupID
  group by Groups.GroupID

  --------------Liệt kê thông tin cá nhân của các trưởng nhóm
  select * from Employee join Groups on Groups.LeaderID=Employee.EmployeeID
---------------Liệt kê thông tin về nhóm và nhân viên đang làm các dự án có ngày bắt đầu làm trước ngày
-----------12/10/2010
select GroupDetail.GroupID,GroupDetail.EmployeeID,GroupDetail.Status ,Employee.Name ,StartDate from  GroupDetail join Groups on Groups.GroupID=GroupDetail.GroupID
join Project on  Project.ProjectID=Groups.ProjectID join Employee on Employee.EmployeeID=GroupDetail.EmployeeID and StartDate<'12/10/2010'
----------------------f. Liệt kê tất cả nhân viên dự kiến sẽ được phân vào các nhóm làm việc

select *  from Employee 
where not exists (select * from Employee join GroupDetail on GroupDetail.EmployeeID=Employee.EmployeeID)
-----c2
SELECT E.Name, E.EmployeeID 
	FROM Employee E
	WHERE E.EmployeeID
	NOT IN (SELECT GD.EmployeeID FROM GroupDetail GD)



select * from Employee
select * from GroupDetail
select * from Groups

-------------Liệt kê tất cả thông tin về nhân viên, nhóm làm việc, dự án của những dự án đã hoàn thành
select  Employee.EmployeeID,Employee.name,Groups.GroupName from GroupDetail join Employee on GroupDetail.EmployeeID=Employee.EmployeeID join  Groups
on Groups.GroupID=GroupDetail.GroupID
and Status='done'
--------------Ngày hoàn thành dự án phải sau ngày bắt đầu dự án
ALTER TABLE Project
ADD check(StartDate < EndDate) 
-------------Trường tên nhân viên không được null
ALTER TABLE Employee
ALTER COLUMN Name varchar(100) not null
----------------Trường trạng thái làm việc chỉ nhận một trong 3 giá trị: inprogress, pending, done
ALTER TABLE GroupDetail
ADD CONSTRAINT pk_check check(Status in('done','not done')) 
-------------Trường giá trị dự án phải lớn hơn 1000
ALTER TABLE Project
ADD CONSTRAINT pk_money check(Cost>10) 
----------------Trường điện thoại của nhân viên chỉ được nhập số và phải bắt đầu bằng số 0

ALTER TABLE Employee
ADD CONSTRAINT pk_tel CHECK (Tel   like  '[0-9]'and Tel LIKE '0%')
ALTER TABLE Employee drop CONSTRAINT pk_tel

go

----------. Tăng giá thêm 10% của các dự án có tổng giá trị nhỏ hơn 2000------
CREATE PROCEDURE tang @so int as
UPDATE Project
SET Cost =Cost+ Cost*@so/100 
WHERE Cost < 2000 
select * from Project
exec tang 10
go
--------------Hiển thị thông tin về dự án sắp được thực hiện
CREATE PROCEDURE duan @duan varchar(30)
as
select Project.ProjectID ,Project.ProjectName ,Project.StartDate ,Project.EndDate ,Project.Period ,Project.Cost
from Project join Groups on Project.ProjectID=Groups.ProjectID
join GroupDetail on GroupDetail.GroupID=Groups.GroupID and GroupDetail.Status=@duan
exec duan 'done'
---------------Hiển thị tất cả các thông tin liên quan về các dự án đã hoàn thành
go
	CREATE PROCEDURE duan2 @duan2 varchar(30)
as
select Project.ProjectID ,Project.ProjectName ,Project.StartDate ,Project.EndDate ,Project.Period ,Project.Cost
from Project join Groups on Project.ProjectID=Groups.ProjectID
join GroupDetail on GroupDetail.GroupID=Groups.GroupID and GroupDetail.Status=@duan2
exec duan2 'not done'
go
--------------------Tạo chỉ mục duy nhất tên là IX_Group trên 2 trường GroupID và EmployeeID của bảng   GroupDetail
CREATE UNIQUE INDEX ten_unique
ON GroupDetail (GroupID,EmployeeID)
-------------. Tạo chỉ mục tên là IX_Project trên trường ProjectName của bảng Project gồm các trường
------------------------------------------------------------------------------------------------------- StartDate và EndDate
go
go
CREATE INDEX IX_Project on Project(ProjectName,StartDate,EndDate)
go
--------. Tạo các khung nhìn để-----Liệt kê thông tin về nhân viên, nhóm làm việc có dự án đang thực hiện
-------. Tạo các khung nhìn để----Tạo khung nhìn chứa các dữ liệu sau: tên Nhân viên, tên Nhóm, tên Dự án và trạng thái làm
-------------việc của Nhân viên
CREATE VIEW view1 AS
SELECT Employee.Name, Groups.GroupName, Project.ProjectName, GroupDetail. STATUS
FROM Employee
INNER JOIN GroupDetail
ON GroupDetail.Employeeid=Employee.Employeeid
INNER JOIN Groups
ON Groups.GroupID=GroupDetail.GroupID
INNER JOIN Project
ON Project.ProjectID= Groups.ProjectID

GO
select * from view1
---------8a
go
create trigger update_period
on Project
for update
as
begin
if update (EndDate)
begin
declare @start_date datetime,@end_date datetime, @id int;
SELECT  @start_date = StartDate, @end_date = EndDate , @id = ProjectID FROM inserted; 
UPDATE Project SET Period = (SELECT DATEDIFF(month, @start_date, @end_date)) where ProjectID = @id;
end
end
update Project set EndDate = CONVERT(datetime, '2022-11-19') where ProjectID = 8;
