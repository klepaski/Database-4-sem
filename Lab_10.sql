use CJA_UNIVER;
--1
DECLARE @c char ='a',
		@v varchar(4)='БГТУ',
		@d datetime,
		@t time,
		@i int,			--без иниц
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

--2. общ.вместимость аудиторий
-- если >200, вывод кол-во +ср.вм. +кол-во ауд с вм<AVR +их %
-- если <200, вывод сообщения об общ.вм.
DECLARE @var1 int 
DECLARE @var2 int 
DECLARE @var3 int 
DECLARE @var4 int 
SELECT @var1 = SUM(AUDITORIUM_CAPACITY) FROM AUDITORIUM 
if @var1 > 200 
begin 
	select	@var2 = (select COUNT(*) as [Количество] from AUDITORIUM), 
			@var3 = (select AVG(AUDITORIUM_CAPACITY) as [Средняя] FROM AUDITORIUM) 
	set		@var4 = (select COUNT(*) as [Количество] from AUDITORIUM 
					where AUDITORIUM_CAPACITY < @var3) 
	select @var2 'Кол-во ауд.', @var3 'Средняя вмест',
			@var4 'Кол-во ауд.< AVR',			
			100*(cast(@var4 as float)/cast(@var2 as float)) '% ауд.< AVR'			
end 
else select @var1;


--3. на печать глоб.пер-ные
select	@@ROWCOUNT 'число обраб. строк',
		@@VERSION 'версия SQL Server',
		@@SPID 'системный иден. процесса',
		@@ERROR 'код последней ошибки',
		@@SERVERNAME 'имя сервера',
		@@TRANCOUNT 'уровень вложенности транзакций',
		@@FETCH_STATUS 'проверка рез-та счит. строк рез.набора',
		@@NESTLEVEL 'ур. влож-сти тек. процедуры';
		

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

select NAME as 'Имя', 2019-YEAR(BDAY) as 'Возраст'		--у кого др в след.месяце
	from STUDENT
	where MONTH(BDAY)=MONTH(getdate())+1;
	

--6.
select student.NAME as 'Имя', student.IDGROUP as 'Группа',
	case
	when progress.NOTE between 0 and 3 then 'низко'
	when progress.NOTE between 4 and 6 then 'нормально'
	when progress.NOTE between 7 and 8 then 'отлично'
	else 'идеально'
	end Оценка, COUNT(*)[Количество]
	from student, PROGRESS where student.IDGROUP=17
group by student.NAME, student.IDGROUP,
	case
	when progress.NOTE between 0 and 3 then 'низко'
	when progress.NOTE between 4 and 6 then 'нормально'
	when progress.NOTE between 7 and 8 then 'отлично'
	else 'идеально'
	end
	

--7. созд. врем. табл. 3х10, заполн и вывод, WHILE
CREATE table #CHILDREN
(	age int,
	name varchar(50),
	relatives int
);
SET nocount on;	--не вывод сообщения о вводе строк
declare @ii int=0;
while @ii<10
	begin
	insert #CHILDREN(age, name, relatives)
			values (floor(24*RAND()), replicate('юля',2), floor(26*RAND()));
	set @ii=@ii+1;
	end;
select * from #CHILDREN;
drop table #CHILDREN;


--9.
print 'задание 9'
begin TRY
	update PROGRESS set NOTE='5'	--'фив'
			where NOTE='6'
end TRY
begin CATCH
	print ERROR_NUMBER()	--код последней ошибки
	print ERROR_MESSAGE()	--сообщение об ошибке
	print ERROR_LINE()		--код последней ошибки
	print ERROR_PROCEDURE()	--имя процедуры или NULL
	print ERROR_SEVERITY()	--уровень серьезности ошибки
	print ERROR_STATE()		--метка ошибки
end CATCH


--8. исп. оператора RETURN
declare @xx int=1;
print @xx+1
print @xx+2
RETURN
print @xx+3
