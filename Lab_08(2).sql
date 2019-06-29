use CJA_UNIVER

--1. max,min,avg,sum вместимости + count
Select 
	min(AUDITORIUM_CAPACITY) as 'min',
	max(AUDITORIUM_CAPACITY) as 'max',
	avg(AUDITORIUM_CAPACITY) as 'avg',
	sum(AUDITORIUM_CAPACITY) as 'sum_capacity',
	count(*) as 'count_of_auditoriums'
		from AUDITORIUM

--2. 1 для каждого типа
Select
	AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	min(AUDITORIUM_CAPACITY) as 'min',
	max(AUDITORIUM_CAPACITY) as 'max',
	avg(AUDITORIUM_CAPACITY) as 'avg',
	sum(AUDITORIUM_CAPACITY) as 'sum_capacity',
	count(*) as 'count_of_auditoriums'
		from AUDITORIUM inner join AUDITORIUM_TYPE
		on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

--3. 
Select * From (
	select Case 
				when PROGRESS.NOTE = 10 then '10'
				when PROGRESS.NOTE = 8 or PROGRESS.NOTE = 9 then '8-9'
				when PROGRESS.NOTE = 6 or PROGRESS.NOTE = 7 then '6-7'
				else '4-5' 
				end [оценки], COUNT(*)[количество]
	from PROGRESS group by Case 
								when PROGRESS.NOTE = 10 then '10'
								when PROGRESS.NOTE = 8 or PROGRESS.NOTE = 9 then '8-9'
								when PROGRESS.NOTE = 6 or PROGRESS.NOTE = 7 then '6-7'
								else '4-5' 
								end
				) as T
Order by Case[оценки]
			when '10' then 1
			when '8-9' then 2
			when '6-7' then 3
			when '4-5' then 4
			else 0
			end

--4
select FACULTY.FACULTY, GROUPS.PROFESSION,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from FACULTY inner join GROUPS
on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION

--5
select FACULTY.FACULTY, GROUPS.PROFESSION,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from FACULTY inner join GROUPS
on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where PROGRESS.SUBJECT like 'СУБД' or PROGRESS.SUBJECT = 'ОАиП'
group by FACULTY.FACULTY, GROUPS.PROFESSION

--6
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИДиП'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--8
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИДиП'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
union all
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--9
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИДиП'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
intersect
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--10
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИДиП'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
except
Select GROUPS.PROFESSION, PROGRESS.SUBJECT,GROUPS.FACULTY,
round (avg (cast (PROGRESS.NOTE as float(4))),2) as 'средняя оценка'
from GROUPS inner join FACULTY
on GROUPS.FACULTY = FACULTY.FACULTY
inner join STUDENT
on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPS.FACULTY like 'ИТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--11
select p1.SUBJECT, p1.NOTE,
(
	select COUNT(*) from PROGRESS p2
	where p2.SUBJECT = p1.SUBJECT and p2.NOTE = p1.NOTE
)[количество]
from PROGRESS p1
group by p1.SUBJECT, p1.NOTE
having NOTE = 8 or NOTE = 9 


select NAME, BDAY
from STUDENT
where BDAY in (SELECT  BDAY
FROM STUDENT
group by BDAY
having COUNT(*) > 1)
order by BDAY asc;