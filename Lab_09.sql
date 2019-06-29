use CJA_UNIVER;

--1. представление Преподаватель на осн. SELECT
exec('CREATE VIEW [Преподаватель]
	as select	TEACHER	[Код],
				TEACHER_NAME [Имя препода],
				GENDER [Пол],
				PULPIT [Код кафедры]
				from TEACHER ')
select * from [Преподаватель];
drop view [Преподаватель];


--2. представление Количество кафедр на осн. SELECT
exec('CREATE view [Количество кафедр]
	as select	distinct(FACULTY.FACULTY_NAME)	[Факультет],
				count(PULPIT.FACULTY)	[Количество кафедр]
				
				from dbo.FACULTY inner join dbo.PULPIT
				on PULPIT.FACULTY=FACULTY.FACULTY
				group by FACULTY.FACULTY_NAME ')
select * from [Количество кафедр];
--нет group by, distinct, top, union...
--в from 1 табл, нет вычисл.


--3. представление Аудитории, только ЛК, допуск insert update delete
exec('CREATE VIEW Аудиторыи (Код, Наименование)
	as select	AUDITORIUM,
				AUDITORIUM_NAME
				from AUDITORIUM
					where AUDITORIUM_TYPE like ''ЛК%''
					')
INSERT Аудиторыи values('201', '200-3а');
select * from Аудиторыи;
select * from AUDITORIUM;
delete from AUDITORIUM where AUDITORIUM='201';
drop view Аудиторыи;


--4. представление Лекц_аудитории на осн. SELECT, тип с "лк"
--insert,update только с with check update (insert <-where)
exec('CREATE VIEW [Лекционные_аудитории]
	as select	AUDITORIUM		[Код],
				AUDITORIUM_TYPE	[Тип],
				AUDITORIUM_NAME	[Наименование]
				from AUDITORIUM
					where AUDITORIUM_TYPE like ''ЛК%''
					WITH CHECK OPTION
					')
INSERT Лекционные_аудитории values('201','ЛК','200-3а');
select * from Лекционные_аудитории;
delete from AUDITORIUM where AUDITORIUM='201';
drop view Лекционные_аудитории;


--5. представление Дисциплины, на осн. SELECT, алф. порядок
exec('CREATE VIEW [Дисциплины]
	as select TOP 150	SUBJECT			[Код],
						SUBJECT_NAME	[Наименование],
						PULPIT			[Код кафедры]
						from SUBJECT
						order by Наименование')
select * from [Дисциплины];
drop view [Дисциплины];


--6. Изменить Кол.кафедр, чтоб привязано к баз.таблицам
exec('ALTER view [Количество кафедр] WITH SCHEMABINDING
	as select	distinct(FACULTY.FACULTY_NAME)	[Факультет],
				count(PULPIT.FACULTY)	[Количество кафедр]
				
				from dbo.FACULTY inner join dbo.PULPIT
				on PULPIT.FACULTY=FACULTY.FACULTY
				group by FACULTY.FACULTY_NAME ')
select * from [Количество кафедр];
drop view [Количество кафедр];