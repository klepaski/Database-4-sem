use CJA_UNIVER;


--1-- ����� ������� ����������
-- ���������� ����������, ���� ����������� ���� �� ��������� ����������: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- ������� ���������� ������������ �� ��� ���, ���� �� ����� �������� COMMIT ��� ROLLBACK

set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; -- ���� �->r, ������� �� ����

SET IMPLICIT_TRANSACTIONS ON -- ��� ����� ������� ����������
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print '���-�� ����� � TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- �������� 
		else rollback;     -- �����                           
SET IMPLICIT_TRANSACTIONS OFF -- ��������� ����� ������������


if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print '������� TAB ����';  
else print '������� TAB ���'







--2-- �������� ����������� ����� ����������
USE CJA_UNIVER;
begin try        
	begin tran                 -- ������  ����� ����������
		insert FACULTY values ('��', '��������� ������ ����');
	    insert FACULTY values ('���', '��������� print-����������');
	commit tran;               -- �������� ����������
end try

begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then '������������ '	--������� 1-�� ���������
		else '����������� ������: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ��.����������� ��.>0,  ����� �� ��������� 	  
end catch;
 
DELETE FACULTY WHERE FACULTY = '��';
DELETE FACULTY WHERE FACULTY = '���';

select * from FACULTY;





--3-- �������� SAVETRAN
-- ���� ���������� ���� �� ���� ������� ������ ���������� T-SQL, �� ���.
-- SAVE TRANSACTION, ������ �����.����� ����������

declare @point varchar(32);

begin try
	begin tran                           
		set @point = 'p1'; 
		save tran @point;  -- ����������� ����� p1
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
		                      (20,'���������', '1997-08-02', NULL, NULL),
							  (20,'����������', '1997-08-06', NULL, NULL),
							  (20,'���������', '1997-08-01', NULL, NULL),
							  (20,'�����', '1997-08-03', NULL, NULL);    
		set @point = 'p2'; 
		save tran @point; -- ����������� ����� p2
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
							  (20, '��������� �������', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try

begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then '������������ ��������' 
		else '����������� ������: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- ���� ���������� �� ���������
	begin
	   print '����������� �����: '+ @point;
	   rollback tran @point; -- ����� � ��������� �����.�����
	   commit tran; -- �������� ���������, ������ �� �����.����� 
	end;     
end catch;

select * from STUDENT where IDGROUP=20; 
delete STUDENT where IDGROUP=20; 



--4.
--�������� A - ����� ���������� � ������� ��������������� READ UNCOMMITED,
--���. ������ �����������, ��������. � ��������� ������
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED (�� �����) 

--READ UNCOMMITTED 
--��������� ����� ������ ������, ����������, �� �� ���������� ��.������������

--READ COMMITTED 
--��������� �� ����� ������ ������, ����������, �� �� ����������� ��.������������
-- ��� ������������� ������� ������.

------A---------
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
	select @@SPID, 'insert FACULTY' '���������', *
		from FACULTY WHERE FACULTY = '��';
	select @@SPID, 'update PULPIT' '���������', *
		from PULPIT WHERE FACULTY = '��';
	commit;

-----t2---------
-----B----------

begin transaction
	select @@SPID
	insert FACULTY VALUES
		('��3','�������������� ����������');
	update PULPIT set FACULTY = '��' WHERE PULPIT = '����'

-----t1----------
-----t2----------

ROLLBACK;
SELECT * FROM FACULTY;
SELECT * FROM PULPIT;





--5. ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ����������������� ������, 
--�� ��� ���� ��������  ��������������� � ��������� ������. 

-----A--------
SELECT * from PULPIT;
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = '��'; --��������� ���� ��������, ����� ��������� 0

-----t1-------
-----t2-------

select 'update PULPIT' '���������', count(*) --����� ��������� 1, �.�. ��������� ���������
from PULPIT where FACULTY = '��'; --�������� ��������������� ������
commit;
------B----

begin transaction

------t1-----

update PULPIT set FACULTY = '��' where PULPIT = '����';
commit;

------t2------

-- ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� REPEATABLE READ. 
--���-����� B � ����� ���������� � ������� ��������������� READ COMMITED. 

--------A---------
USE CJA_UNIVER;
set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = '������';

--------t1---------
--------t2---------

-- ��������� ����������
-- ����������, ������������� � ������ ������ ����������, ���������� ���������. 
-- �������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
-- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������; 
-- �������� ROLLBACK ��������� ���������� ��������� �� ���-����� ������� � ���������� ����������, 
-- � ����� ��������� ��� ����������; 
-- ������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT. 

select (select count(*) from dbo.PULPIT where FACULTY = '����') '������� �����', 
(select count(*) from FACULTY where FACULTY.FACULTY = '����') '����'; 

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='������� �����' where PULPIT.FACULTY = '����';
	commit;
if @@TRANCOUNT > 0 rollback;

-- ����� ���������� ���������� ����������� ��������� ����� ��������; 
-- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������. 