use CJA_UNIVER;
--1
DECLARE @c char ='a',
		@v varchar(4)='����',
		@d datetime,
		@t time,
		@i int,			--��� ����
		@s smallint,
		@ti tinyint,
		@n numeric(12,5);
SET @d=GETDATE();
SELECT @t='12:59:34.21';
SELECT @c c, @v v, @d d, @t t;
SELECT @s=345, @ti=1, @n=1234567.12345;
print 's='+cast(@s as varchar(10));
print 'ti='+cast(@ti as varchar(10));
print 'n='+cast(@n as varchar(13));

--2. ���.����������� ���������
-- ���� >200, ����� ���-�� +��.��. +���-�� ��� � ��<AVR +�� %
-- ���� <200, ����� ��������� �� ���.��.
DECLARE @var1 int 
DECLARE @var2 int 
DECLARE @var3 int 
DECLARE @var4 int 
SELECT @var1 = SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM 
if @var1 > 200 
begin 
	select	@var2 = (select COUNT(*) as [����������] from AUDITORIUM), 
			@var3 = (select AVG(AUDITORIUM_CAPACITY) as [�������] FROM AUDITORIUM) 
	set		@var4 = (select COUNT(*) as [����������] from AUDITORIUM 
					where AUDITORIUM_CAPACITY < @var3) 
	select @var2 '���-�� ���.', @var3 '������� �����',
			@var4 '���-�� ���.< AVR',			
			100*(cast(@var4 as float)/cast(@var2 as float)) '% ���.< AVR'			
end 
else select @var1;


--3. �� ������ ����.���-���
select	@@ROWCOUNT '����� �����. �����',
		@@VERSION '������ SQL Server',
		@@SPID '��������� ����. ��������',
		@@ERROR '��� ��������� ������',
		@@SERVERNAME '��� �������',
		@@TRANCOUNT '������� ����������� ����������',
		@@FETCH_STATUS '�������� ���-�� ����. ����� ���.������',
		@@NESTLEVEL '��. ����-��� ���. ���������';
		

--4.
declare @tt int=3, @x float=4, @z float;
if (@tt>@x) set @z=power(SIN(@tt),2);
if (@tt<@x) set @z=4*(@tt+@x);
if (@tt=@x) set @z=1-exp(@x-2);
print 'z='+cast(@z as varchar(10));

declare @ss varchar(100)=(select top 1 NAME from STUDENT)
select substring(@ss, 1, charindex(' ', @ss))
		+substring(@ss, charindex(' ', @ss)+1,1)+'.'
		+substring(@ss, charindex(' ', @ss, charindex(' ', @ss)+1)+1,1)+'.'

select NAME as '���', 2019-YEAR(BDAY) as '�������'		--� ���� �� � ����.������
	from STUDENT
	where MONTH(BDAY)=MONTH(getdate())+1;
	

--6.
select student.NAME as '���', student.IDGROUP as '������',
	case
	when progress.NOTE between 0 and 3 then '�����'
	when progress.NOTE between 4 and 6 then '���������'
	when progress.NOTE between 7 and 8 then '�������'
	else '��������'
	end ������, COUNT(*)[����������]
	from student, PROGRESS where student.IDGROUP=17
group by student.NAME, student.IDGROUP,
	case
	when progress.NOTE between 0 and 3 then '�����'
	when progress.NOTE between 4 and 6 then '���������'
	when progress.NOTE between 7 and 8 then '�������'
	else '��������'
	end
	

--7. ����. ����. ����. 3�10, ������ � �����, WHILE
CREATE table #CHILDREN
(	age int,
	name varchar(50),
	relatives int
);
SET nocount on;	--�� ����� ��������� � ����� �����
declare @ii int=0;
while @ii<10
	begin
	insert #CHILDREN(age, name, relatives)
			values (floor(24*RAND()), replicate('���',2), floor(26*RAND()));
	set @ii=@ii+1;
	end;
select * from #CHILDREN;
drop table #CHILDREN;


--9.
print '������� 9'
begin TRY
	update PROGRESS set NOTE='5'	--'���'
			where NOTE='6'
end TRY
begin CATCH
	print ERROR_NUMBER()	--��� ��������� ������
	print ERROR_MESSAGE()	--��������� �� ������
	print ERROR_LINE()		--��� ��������� ������
	print ERROR_PROCEDURE()	--��� ��������� ��� NULL
	print ERROR_SEVERITY()	--������� ����������� ������
	print ERROR_STATE()		--����� ������
end CATCH


--8. ���. ��������� RETURN
declare @xx int=1;
print @xx+1
print @xx+2
RETURN
print @xx+3
