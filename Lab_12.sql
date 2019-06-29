use CJA_UNIVER;

--1. C����� ��������� (������� ����.) �� ����
--�� ������� SUBJECT � ���� ������ ����� ������� (RTRIM)

DECLARE Subs CURSOR
	for SELECT SUBJECT from SUBJECT
	where SUBJECT.PULPIT='����'; 

DECLARE @sub char(4),
		@str char(100)=' '; 
OPEN Subs;  
	fetch  Subs into @sub;    
	print   '���������� �� ������� ����:';   
	while @@fetch_status = 0                                   
	begin 
		set @str = rtrim(@sub)+', '+@str; -- ������� ��� ����������� �������        
		fetch  Subs into @sub; 
	end;   
    print @str;        
CLOSE  Subs;
deallocate Subs; 


--2 ������� ����������� ������� �� ���������� 
DECLARE Puls CURSOR LOCAL
	for SELECT PULPIT, FACULTY from PULPIT;
DECLARE @pul nvarchar(10),
		@fac nvarchar(4);      
OPEN Puls; 	  
	fetch  Puls into @pul, @fac; 	
    print rtrim(@pul)+' (local) �� ����������  '+ @fac;


DECLARE Puls CURSOR GLOBAL
	for SELECT PULPIT, FACULTY from PULPIT;
DECLARE @pul1 nvarchar(10),
		@fac1 nvarchar(4);      
OPEN Puls;	  
	fetch  Puls into @pul1, @fac1; 	
    print rtrim(@pul1)+' (global) �� ����������  '+ @fac1;
 
CLOSE Puls;
deallocate Puls;



--3. ������� ����������� �������� �� ������������
DECLARE Studs CURSOR Local STATIC
	for SELECT NAME from STUDENT
	where IDGROUP = 3;		
		   
OPEN Studs;
print '���-�� ����� : '+cast(@@CURSOR_ROWS as varchar(5)); 

DECLARE @name char(50);  
UPDATE STUDENT set IDGROUP=24 where IDGROUP=3;  
fetch  Studs into @name;     
while @@fetch_status = 0                                    
begin 
   print @name + ' ';      
   fetch Studs into @name; 
end;      
CLOSE  Studs;


UPDATE STUDENT set IDGROUP=3 where IDGROUP=24;
DEALLOCATE Studs 

   

--4 �������� �������� ��������� � ����������-���� ������ ������� � ��������� SCROLL 
DECLARE  @t int, @rn char(50);  

DECLARE ScrollCur CURSOR LOCAL DYNAMIC SCROLL for 
		SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUP = 6 
OPEN ScrollCur;
	fetch FIRST from ScrollCur into  @t, @rn;                 
		print '������ ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);
	fetch NEXT from ScrollCur into  @t, @rn;                 
		print '��������� ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);      
	fetch LAST from  ScrollCur into @t, @rn;       
		print '��������� ������: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn);   
	fetch PRIOR from ScrollCur into  @t, @rn;         --���� �� �������  
		print '������������� ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 2 from ScrollCur into  @t, @rn;    -- �� ������             
		print '������ ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 1 from ScrollCur into  @t, @rn;    -- �� �������          
		print '������ ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);         
CLOSE ScrollCur;



--5 ������� ������, ��������������� ���������� ����������� CURRENT OF 
--� ������ WHERE � ��� UPDATE � DELETE.

INSERT FACULTY(FACULTY,FACULTY_NAME) VALUES (N'FIT',N'��������� IT'); 

DECLARE cur CURSOR LOCAL SCROLL DYNAMIC
	for select f.FACULTY from FACULTY f 
	FOR UPDATE; 

DECLARE @s nvarchar(5); 
OPEN cur 
	fetch FIRST from cur into @s; 
	update FACULTY set FACULTY = N'myFIT' where current of cur; 
	fetch FIRST from cur into @s; 
	delete FACULTY where current of cur; 
GO 



--6. �� PROGRESS ���� ������ � ��������� � ��<4
DECLARE @name3 nvarchar(20), @n int;  

DECLARE Cur1 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT 
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

OPEN Cur1;  
    fetch  Cur1 into @name3, @n;  
	while @@fetch_status = 0
	begin 		
		delete PROGRESS where CURRENT OF Cur1;	
		fetch  Cur1 into @name3, @n;  
	end
CLOSE Cur1;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5
insert into PROGRESS (SUBJECT,IDSTUDENT,PDATE, NOTE)
    values 
           ('����', 1005,  '01.10.2013',4),
           ('����', 1017,  '01.12.2013',4),
		   ('��',   1018,  '06.5.2013',4),
           ('��',   1065,  '01.1.2013',4),
           ('��',   1069,  '01.1.2013',4),
           ('��',   1058,  '01.1.2013',4)

-- ��������� ������ �� �������
DECLARE @name4 char(20), @n3 int;  

DECLARE Cur2 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1000
OPEN Cur2;  
    fetch  Cur2 into @name4, @n3; 
    UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF Cur2;
CLOSE Cur2;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1000