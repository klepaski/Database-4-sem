use CJA_UNIVER;

SELECT * FROM FACULTY;
SELECT TEACHER, PULPIT from TEACHER;
SELECT TEACHER_NAME FROM TEACHER where PULPIT='����';
SELECT TEACHER_NAME FROM TEACHER where PULPIT='����' or PULPIT='������';
SELECT TEACHER_NAME FROM TEACHER where GENDER='�' and PULPIT='����';
SELECT TEACHER_NAME FROM TEACHER where GENDER!='�' and PULPIT='����';
SELECT Distinct PULPIT from TEACHER;

SELECT Distinct AUDITORIUM, AUDITORIUM_CAPACITY from AUDITORIUM Order by AUDITORIUM_CAPACITY ASC;
SELECT Distinct Top(2) AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM Order by AUDITORIUM_CAPACITY ASC;

SELECT Distinct SUBJECT from PROGRESS where NOTE between 8 and 1;

SELECT Distinct SUBJECT from SUBJECT where PULPIT in ('�����','������','��');

SELECT PROFESSION_NAME, QUALIFICATION from PROFESSION where QUALIFICATION Like '%�����%';

--DROP table #H;	
--CREATE table #H
--(	FIO nvarchar(100),
--	DR date
--)
--SELECT NAME, BDAY INTO #H(FIO, DR) from STUDENT;
--SELECT * FROM #H;
--DROP table #H;
