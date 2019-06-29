USE CJA_UNIVER;

/*1.����� ����., ���., �����. �������-��� ��������� + ��������� � ���.���-��*/
SELECT	min(AUDITORIUM_CAPACITY) [����������� ���������������],
		max(AUDITORIUM_CAPACITY) [������������ ���������������],
		avg(AUDITORIUM_CAPACITY) [������� ���������������],
		count (*)				 [���������� ���������],
		sum(AUDITORIUM_CAPACITY) [���������]
FROM AUDITORIUM;

/*2.����.,���.,�����.,����. � ���.���-�� ��������� �����.����*/
SELECT	AUDITORIUM.AUDITORIUM_TYPE,
		min(AUDITORIUM_CAPACITY) [����������� ���������������],
		max(AUDITORIUM_CAPACITY) [������������ ���������������],
		avg(AUDITORIUM_CAPACITY) [������� ���������������],
		count (*)					[���������� ���������],
		sum(AUDITORIUM_CAPACITY) [���������]
FROM AUDITORIUM Inner Join AUDITORIUM_TYPE
	On AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		GROUP BY AUDITORIUM.AUDITORIUM_TYPE;

/*3.���-� �� ���.����.�������� - ���-�� ���.������� � �����.���-��; ������.�� ����.*/
SELECT *
	FROM(SELECT CASE 
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END [��������],
	COUNT(*) as [����������]
	FROM PROGRESS GROUP BY CASE
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END) AS T
ORDER BY Case [��������]
	WHEN '10' then 4
	WHEN '8-9' then 3
	WHEN '6-7' then 2
	WHEN '4-5' then 1
	ELSE 0
	END;

/*4.������, ���.������.������ ��� ������ ����� ����� �������; ����.��.��.(� ����.�� 2 ������ ����� ,)*/
SELECT	FACULTY.FACULTY_NAME [���������],
		GROUPS.PROFESSION [�������������],
		STUDENT.IDGROUP [����� ������],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ����]
	FROM FACULTY INNER JOIN GROUPS 
	ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
	ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
	ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		GROUP BY	FACULTY.FACULTY_NAME, 
					GROUPS.PROFESSION,
					STUDENT.IDGROUP

/*5.�������.������, � 4 ������� ���, ����� ��� ������ �� �� � ����*/
SELECT	FACULTY.FACULTY [���������],
		GROUPS.PROFESSION [�������������],
		STUDENT.IDGROUP [������],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
	FROM FACULTY INNER JOIN GROUPS
	ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
	ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
	ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
	WHERE (PROGRESS.SUBJECT = '��' or PROGRESS.SUBJECT = '����')
		GROUP BY	FACULTY.FACULTY,
					GROUPS.PROFESSION,
					STUDENT.IDGROUP;

/*6.������, ���.������� �������, ���������� � ������ �� ��� � ���-���� ROLLUP*/
SELECT	GROUPS.FACULTY [���������],
		GROUPS.PROFESSION [�������������],
		PROGRESS.SUBJECT [�������],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� �������]
	FROM GROUPS, STUDENT, PROFESSION, PROGRESS
	WHERE GROUPS.FACULTY in ('���')
	GROUP BY ROLLUP (GROUPS.FACULTY,
			 GROUPS.PROFESSION, 
			 PROGRESS.SUBJECT);

/*7.*/
SELECT	GROUPS.FACULTY [���������],
		GROUPS.PROFESSION [�������������],
		PROGRESS.SUBJECT [�������],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� �������]
	FROM GROUPS, STUDENT, PROFESSION, PROGRESS
	WHERE GROUPS.FACULTY in ('���')
	GROUP BY CUBE (GROUPS.FACULTY,
			 GROUPS.PROFESSION, 
			 PROGRESS.SUBJECT)

/*8.������ � ���-��� ����� ���-��*/
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) as AVG_NOTE
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('���')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	UNION
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) as AVG_NOTE
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('���')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

/*10*/
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
EXCEPT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [������� ������]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='����'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT

/*11.*/
SELECT	PROGRESS.SUBJECT [�������],
		PROGRESS.NOTE [�������], 
		(SELECT COUNT(*) FROM STUDENT, PROGRESS where PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT ) [���������� ���������]
FROM PROGRESS
GROUP BY PROGRESS.NOTE, PROGRESS.SUBJECT
HAVING PROGRESS.NOTE > 6