use CJA_UNIVER;

--1
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

--2
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 
AND AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%���������%'

--3
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM, AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM, AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
AND AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%���������%'

--4
select FACULTY.FACULTY_NAME as '���������',
	PULPIT.PULPIT_NAME as '�������', 
	PROFESSION.PROFESSION_NAME as '�������������',
	SUBJECT.SUBJECT_NAME as '����������',
	STUDENT.NAME as '�������', 
Case
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end ������
from FACULTY 
inner join PULPIT
	on FACULTY.FACULTY = PULPIT.FACULTY
inner join PROFESSION
	on PULPIT.FACULTY = PROFESSION.FACULTY
inner join SUBJECT
	on SUBJECT.PULPIT = PULPIT.PULPIT
inner join PROGRESS
	on PROGRESS.SUBJECT = SUBJECT.SUBJECT
inner join STUDENT
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 and 8
ORDER BY PROGRESS.NOTE DESC

--5
select FACULTY.FACULTY_NAME as '���������', PULPIT.PULPIT_NAME as '�������', PROFESSION.PROFESSION_NAME as '�������������',
SUBJECT.SUBJECT_NAME as '����������',STUDENT.NAME as '�������', 
Case
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end ������
from FACULTY 
inner join PULPIT
	on FACULTY.FACULTY = PULPIT.FACULTY
inner join PROFESSION
	on PULPIT.FACULTY = PROFESSION.FACULTY
inner join SUBJECT
	on SUBJECT.PULPIT = PULPIT.PULPIT
inner join PROGRESS
	on PROGRESS.SUBJECT = SUBJECT.SUBJECT
inner join STUDENT
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT AND PROGRESS.NOTE BETWEEN 6 and 8
ORDER BY 
Case
	when(PROGRESS.NOTE = 7) then 1
	when(PROGRESS.NOTE = 8) then 2
	else 3
end

--6
SELECT isnull(TEACHER.TEACHER_NAME, '***') as '�������������', 
	PULPIT.PULPIT_NAME as '�������'
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

--7
SELECT isnull(TEACHER.TEACHER_NAME, '***') as '�������������', PULPIT.PULPIT_NAME as '�������'
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT

--8
SELECT * FROM AUDITORIUM FULL OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

SELECT * FROM AUDITORIUM left OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

SELECT * FROM AUDITORIUM right OUTER JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

SELECT * FROM AUDITORIUM inner JOIN AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

--9
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM cross JOIN AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE