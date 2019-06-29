use CJA_UNIVER;


--1-- РЕЖИМ НЕЯВНОЙ ТРАНЗАКЦИИ
-- транзакция начинается, если выполняется один из следующих операторов: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- неявная транзакция продолжается до тех пор, пока не будет выполнен COMMIT или ROLLBACK

set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; -- если с->r, таблица не сохр

SET IMPLICIT_TRANSACTIONS ON -- вкл режим неявной транзакции
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'кол-во строк в TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- фиксация 
		else rollback;     -- откат                           
SET IMPLICIT_TRANSACTIONS OFF -- действует режим автофиксации


if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблица TAB есть';  
else print 'таблицы TAB нет'







--2-- СВОЙСТВО АТОМАРНОСТИ ЯВНОЙ ТРАНЗАКЦИИ
USE CJA_UNIVER;
begin try        
	begin tran                 -- начало  явной транзакции
		insert FACULTY values ('ДФ', 'Факультет других наук');
	    insert FACULTY values ('ПиМ', 'Факультет print-технологий');
	commit tran;               -- фиксация транзакции
end try

begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then 'дублирование '	--позиция 1-го вхождения
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ур.вложенности тр.>0,  транз не завершена 	  
end catch;
 
DELETE FACULTY WHERE FACULTY = 'ДФ';
DELETE FACULTY WHERE FACULTY = 'ПиМ';

select * from FACULTY;





--3-- ОПЕРАТОР SAVETRAN
-- если транзакция сост из неск независ блоков операторов T-SQL, то исп.
-- SAVE TRANSACTION, формир контр.точку транзакции

declare @point varchar(32);

begin try
	begin tran                           
		set @point = 'p1'; 
		save tran @point;  -- контрольная точка p1
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
		                      (20,'Екатерина', '1997-08-02', NULL, NULL),
							  (20,'Александра', '1997-08-06', NULL, NULL),
							  (20,'Елизавета', '1997-08-01', NULL, NULL),
							  (20,'Ольга', '1997-08-03', NULL, NULL);    
		set @point = 'p2'; 
		save tran @point; -- контрольная точка p2
		insert STUDENT(IDGROUP, NAME, BDAY, INFO, FOTO) values
							  (20, 'Особенный Студент', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try

begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then 'дублирование студента' 
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- если транзакция не завершена
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; -- откат к последней контр.точке
	   commit tran; -- фиксация изменений, выполн до контр.точки 
	end;     
end catch;

select * from STUDENT where IDGROUP=20; 
delete STUDENT where IDGROUP=20; 



--4.
--Сценарий A - явную транзакцию с уровнем изолированности READ UNCOMMITED,
--кот. допуск неподтвержд, неповтор. и фантомное чтение
--сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолч) 

--READ UNCOMMITTED 
--операторы могут читать строки, измененные, но не выполненые др.транзакциями

--READ COMMITTED 
--операторы не могут читать данные, измененные, но не выполненные др.транзакциями
-- Это предотвращает грязные чтения.

------A---------
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
	select @@SPID, 'insert FACULTY' 'результат', *
		from FACULTY WHERE FACULTY = 'ИТ';
	select @@SPID, 'update PULPIT' 'результат', *
		from PULPIT WHERE FACULTY = 'ИТ';
	commit;

-----t2---------
-----B----------

begin transaction
	select @@SPID
	insert FACULTY VALUES
		('ИТ3','Информационных технологий');
	update PULPIT set FACULTY = 'ИТ' WHERE PULPIT = 'ИСиТ'

-----t1----------
-----t2----------

ROLLBACK;
SELECT * FROM FACULTY;
SELECT * FROM PULPIT;





--5. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, 
--но при этом возможно  неповторяющееся и фантомное чтение. 

-----A--------
SELECT * from PULPIT;
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = 'ИТ'; --Указывает одно значение, видим результат 0

-----t1-------
-----t2-------

select 'update PULPIT' 'результат', count(*) --здесь результат 1, т.к. произошло изменение
from PULPIT where FACULTY = 'ИТ'; --работает неповторяющееся чтение
commit;
------B----

begin transaction

------t1-----

update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ИСиТ';
commit;

------t2------

-- Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. 
--Сце-нарий B – явную транзакцию с уровнем изолированности READ COMMITED. 

--------A---------
USE CJA_UNIVER;
set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = 'ПОиСОИ';

--------t1---------
--------t2---------

-- ВЛОЖЕННЫЕ ТРАНЗАКЦИИ
-- Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
-- оператор ROLLBACK вложенной транзакции действует на опе-рации внешней и внутренней транзакции, 
-- а также завершает обе транзакции; 
-- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 

select (select count(*) from dbo.PULPIT where FACULTY = 'ИДиП') 'Кафедры ИДИПа', 
(select count(*) from FACULTY where FACULTY.FACULTY = 'ИДиП') 'ИДИП'; 

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='Кафедра ИДиПа' where PULPIT.FACULTY = 'ИДиП';
	commit;
if @@TRANCOUNT > 0 rollback;

-- Здесь внутренняя транзакция завершается фиксацией своих операций; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции. 