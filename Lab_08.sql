USE CJA_UNIVER;

/*1.найти макс., мин., средн. вместит-сть аудиторий + суммарная и общ.кол-во*/
SELECT	min(AUDITORIUM_CAPACITY) [минимальная вместительность],
		max(AUDITORIUM_CAPACITY) [максимальная вместительность],
		avg(AUDITORIUM_CAPACITY) [средняя вместительность],
		count (*)				 [количество аудиторий],
		sum(AUDITORIUM_CAPACITY) [суммарное]
FROM AUDITORIUM;

/*2.макс.,мин.,средн.,сумм. и общ.кол-во аудиторий опред.типа*/
SELECT	AUDITORIUM.AUDITORIUM_TYPE,
		min(AUDITORIUM_CAPACITY) [минимальная вместительность],
		max(AUDITORIUM_CAPACITY) [максимальная вместительность],
		avg(AUDITORIUM_CAPACITY) [средняя вместительность],
		count (*)					[количество аудиторий],
		sum(AUDITORIUM_CAPACITY) [суммарное]
FROM AUDITORIUM Inner Join AUDITORIUM_TYPE
	On AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
		GROUP BY AUDITORIUM.AUDITORIUM_TYPE;

/*3.рез-т на осн.табл.прогресс - кол-во экз.отметов в опред.инт-ле; сортир.по убыв.*/
SELECT *
	FROM(SELECT CASE 
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END [диапазон],
	COUNT(*) as [количество]
	FROM PROGRESS GROUP BY CASE
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END) AS T
ORDER BY Case [диапазон]
	WHEN '10' then 4
	WHEN '8-9' then 3
	WHEN '6-7' then 2
	WHEN '4-5' then 1
	ELSE 0
	END;

/*4.запрос, кот.содерж.оценку для кажого курса кажой спецухи; сорт.ср.оц.(с точн.до 2 знаков после ,)*/
SELECT	FACULTY.FACULTY_NAME [факультет],
		GROUPS.PROFESSION [специальность],
		STUDENT.IDGROUP [номер группы],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [средний балл]
	FROM FACULTY INNER JOIN GROUPS 
	ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
	ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
	ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		GROUP BY	FACULTY.FACULTY_NAME, 
					GROUPS.PROFESSION,
					STUDENT.IDGROUP

/*5.перепис.запрос, в 4 задании так, чтобы исп оценки по БД и ОАиП*/
SELECT	FACULTY.FACULTY [факультет],
		GROUPS.PROFESSION [специальность],
		STUDENT.IDGROUP [группа],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [средняя оценка]
	FROM FACULTY INNER JOIN GROUPS
	ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
	ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
	ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
	WHERE (PROGRESS.SUBJECT = 'БД' or PROGRESS.SUBJECT = 'ОАиП')
		GROUP BY	FACULTY.FACULTY,
					GROUPS.PROFESSION,
					STUDENT.IDGROUP;

/*6.запрос, кот.выводит спецуху, дисциплины и оценки на ТОВ с исп-нием ROLLUP*/
SELECT	GROUPS.FACULTY [факультет],
		GROUPS.PROFESSION [специальность],
		PROGRESS.SUBJECT [предмет],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [средняя отметка]
	FROM GROUPS, STUDENT, PROFESSION, PROGRESS
	WHERE GROUPS.FACULTY in ('ТОВ')
	GROUP BY ROLLUP (GROUPS.FACULTY,
			 GROUPS.PROFESSION, 
			 PROGRESS.SUBJECT);

/*7.*/
SELECT	GROUPS.FACULTY [факультет],
		GROUPS.PROFESSION [специальность],
		PROGRESS.SUBJECT [предмет],
		round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [средняя отметка]
	FROM GROUPS, STUDENT, PROFESSION, PROGRESS
	WHERE GROUPS.FACULTY in ('ТОВ')
	GROUP BY CUBE (GROUPS.FACULTY,
			 GROUPS.PROFESSION, 
			 PROGRESS.SUBJECT)

/*8.запрос с рез-том сдачи экз-ов*/
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
WHERE FACULTY.FACULTY in ('ТОВ')
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
WHERE FACULTY.FACULTY in ('ЛХФ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

/*10*/
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ИДиП'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT
EXCEPT
SELECT g.PROFESSION, p.SUBJECT, round(avg(cast(p.NOTE as float(4))),2) [средння оценка]
From FACULTY f inner join GROUPS g 
            on f.FACULTY = g.FACULTY
            inner join STUDENT s  
            on g.IDGROUP = s.IDGROUP
			inner join PROGRESS p
			on s.IDSTUDENT = p.IDSTUDENT
WHERE g.FACULTY='ХТиТ'                  
GROUP BY  g.PROFESSION, f.FACULTY, p.SUBJECT

/*11.*/
SELECT	PROGRESS.SUBJECT [предмет],
		PROGRESS.NOTE [отметка], 
		(SELECT COUNT(*) FROM STUDENT, PROGRESS where PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT ) [количество студентов]
FROM PROGRESS
GROUP BY PROGRESS.NOTE, PROGRESS.SUBJECT
HAVING PROGRESS.NOTE > 6