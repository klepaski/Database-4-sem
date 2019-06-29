USE CJA_UNIVER;

/*1.�� ���.������ ������� ����.������, ���.���-�� �� ����������, ���.�������.
���������� �� �������������, ���. �������� "����������" ��� "����������"*/
SELECT PULPIT.PULPIT_NAME as '�������', FACULTY_NAME as '���������'
FROM FACULTY, PULPIT
WHERE PULPIT.FACULTY = FACULTY.FACULTY
and PULPIT.FACULTY In (SELECT PROFESSION.FACULTY FROM PROFESSION
							  WHERE PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%' )

/*2.���������� 1 ���, ����� ���-�� INNER JOIN*/
SELECT PULPIT.PULPIT_NAME as '�������', FACULTY_NAME as '���������'
from PULPIT inner join FACULTY 
	on PULPIT.FACULTY = FACULTY.FACULTY 
	and 
	PULPIT.FACULTY In (SELECT PROFESSION.FACULTY FROM PROFESSION
							  WHERE PROFESSION_NAME like '%����������%' or PROFESSION_NAME like '%����������%' )

/*3.���������� 1 ��� ���-��� �����������*/
SELECT distinct PULPIT.PULPIT_NAME as '�������', FACULTY_NAME as '���������'
	FROM PULPIT
	inner join PROFESSION 
		on  (PROFESSION.PROFESSION_NAME like '%����������%' or PROFESSION.PROFESSION_NAME like '%����������%')
	inner join FACULTY
		on PROFESSION.FACULTY = FACULTY.FACULTY and PROFESSION.FACULTY = PULPIT.FACULTY 

/*4.�� ������ ������� AUDITORIUM ������������ ������ ��������� ����� ������� ������������ 
(������� AUDITORIUM_CAPACITY) + TOP � ORDER BY. */
SELECT * FROM AUDITORIUM, AUDITORIUM_TYPE
	WHERE AUDITORIUM_CAPACITY = (SELECT TOP(1) AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM
										ORDER BY AUDITORIUM_CAPACITY DESC) 
	AND
	AUDITORIUM.AUDITORIUM_TYPE  = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	ORDER BY AUDITORIUM.AUDITORIUM_TYPE;

/*5.������������ �����������, �� ���. ��� ������ � ���. �������� EXISTS � ��������������� ���������. */
SELECT FACULTY.FACULTY_NAME as '���������'
FROM FACULTY
	WHERE  EXISTS (SELECT * FROM PULPIT
						WHERE PULPIT.FACULTY = FACULTY.FACULTY);

/*6.�� ���. ����.PROGRESS �������.������, ���-��� �����.����.������ �� ���� � ����
���. 2 ��������.������� � ������� + ���������� �-��� avg*/
SELECT TOP 1
	(SELECT AVG(NOTE) FROM PROGRESS  WHERE PROGRESS.SUBJECT LIKE '����') as '����',
	(SELECT AVG(NOTE) FROM PROGRESS WHERE PROGRESS.SUBJECT LIKE '����') as '����'
FROM PROGRESS

/*7.������ � ����������� ALL*/
SELECT * FROM AUDITORIUM, AUDITORIUM_TYPE
	WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
										WHERE AUDITORIUM_TYPE LIKE '%�%');

/*8.������ � ����������� ANY*/
SELECT * FROM AUDITORIUM
	WHERE AUDITORIUM_CAPACITY >= ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
											WHERE AUDITORIUM_TYPE LIKE '%�%');