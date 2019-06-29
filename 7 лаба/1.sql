USE CJA_UNIVER;

/*1.на осн.таблиц вывести наим.кафедр, кот.нах-ся на факультете, кот.обеспеч.
подготовку по специальности, кот. содержит "технологии" или "технология"*/
SELECT PULPIT.PULPIT_NAME as 'Кафедра', FACULTY_NAME as 'Факультет'
FROM FACULTY, PULPIT
WHERE PULPIT.FACULTY = FACULTY.FACULTY
and PULPIT.FACULTY In (SELECT PROFESSION.FACULTY FROM PROFESSION
							  WHERE PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%' )

/*2.переписать 1 так, чтобы исп-ся INNER JOIN*/
SELECT PULPIT.PULPIT_NAME as 'Кафедра', FACULTY_NAME as 'Факультет'
from PULPIT inner join FACULTY 
	on PULPIT.FACULTY = FACULTY.FACULTY 
	and 
	PULPIT.FACULTY In (SELECT PROFESSION.FACULTY FROM PROFESSION
							  WHERE PROFESSION_NAME like '%технология%' or PROFESSION_NAME like '%технологии%' )

/*3.переписать 1 без исп-ния подсазпроса*/
SELECT distinct PULPIT.PULPIT_NAME as 'Кафедра', FACULTY_NAME as 'Факультет'
	FROM PULPIT
	inner join PROFESSION 
		on  (PROFESSION.PROFESSION_NAME like '%технология%' or PROFESSION.PROFESSION_NAME like '%технологии%')
	inner join FACULTY
		on PROFESSION.FACULTY = FACULTY.FACULTY and PROFESSION.FACULTY = PULPIT.FACULTY 

/*4.На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей 
(столбец AUDITORIUM_CAPACITY) + TOP и ORDER BY. */
SELECT * FROM AUDITORIUM, AUDITORIUM_TYPE
	WHERE AUDITORIUM_CAPACITY = (SELECT TOP(1) AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM
										ORDER BY AUDITORIUM_CAPACITY DESC) 
	AND
	AUDITORIUM.AUDITORIUM_TYPE  = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	ORDER BY AUDITORIUM.AUDITORIUM_TYPE;

/*5.наименования факультетов, на кот. нет кафедр с пом. предикат EXISTS и коррелированный подзапрос. */
SELECT FACULTY.FACULTY_NAME as 'Факультет'
FROM FACULTY
	WHERE  EXISTS (SELECT * FROM PULPIT
						WHERE PULPIT.FACULTY = FACULTY.FACULTY);

/*6.На осн. табл.PROGRESS сформир.строку, сод-щую средн.знач.оценок по ОАиП и СУБД
исп. 2 некоррел.запроса в селекте + агрегатные ф-ции avg*/
SELECT TOP 1
	(SELECT AVG(NOTE) FROM PROGRESS  WHERE PROGRESS.SUBJECT LIKE 'ОАиП') as 'ОАиП',
	(SELECT AVG(NOTE) FROM PROGRESS WHERE PROGRESS.SUBJECT LIKE 'СУБД') as 'СУБД'
FROM PROGRESS

/*7.запрос и применением ALL*/
SELECT * FROM AUDITORIUM, AUDITORIUM_TYPE
	WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
										WHERE AUDITORIUM_TYPE LIKE '%К%');

/*8.запрос с применением ANY*/
SELECT * FROM AUDITORIUM
	WHERE AUDITORIUM_CAPACITY >= ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
											WHERE AUDITORIUM_TYPE LIKE '%К%');