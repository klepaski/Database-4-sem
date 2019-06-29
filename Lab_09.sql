use CJA_UNIVER;

--1. ������������� ������������� �� ���. SELECT
exec('CREATE VIEW [�������������]
	as select	TEACHER	[���],
				TEACHER_NAME [��� �������],
				GENDER [���],
				PULPIT [��� �������]
				from TEACHER ')
select * from [�������������];
drop view [�������������];


--2. ������������� ���������� ������ �� ���. SELECT
exec('CREATE view [���������� ������]
	as select	distinct(FACULTY.FACULTY_NAME)	[���������],
				count(PULPIT.FACULTY)	[���������� ������]
				
				from dbo.FACULTY inner join dbo.PULPIT
				on PULPIT.FACULTY=FACULTY.FACULTY
				group by FACULTY.FACULTY_NAME ')
select * from [���������� ������];
--��� group by, distinct, top, union...
--� from 1 ����, ��� ������.


--3. ������������� ���������, ������ ��, ������ insert update delete
exec('CREATE VIEW ��������� (���, ������������)
	as select	AUDITORIUM,
				AUDITORIUM_NAME
				from AUDITORIUM
					where AUDITORIUM_TYPE like ''��%''
					')
INSERT ��������� values('201', '200-3�');
select * from ���������;
select * from AUDITORIUM;
delete from AUDITORIUM where AUDITORIUM='201';
drop view ���������;


--4. ������������� ����_��������� �� ���. SELECT, ��� � "��"
--insert,update ������ � with check update (insert <-where)
exec('CREATE VIEW [����������_���������]
	as select	AUDITORIUM		[���],
				AUDITORIUM_TYPE	[���],
				AUDITORIUM_NAME	[������������]
				from AUDITORIUM
					where AUDITORIUM_TYPE like ''��%''
					WITH CHECK OPTION
					')
INSERT ����������_��������� values('201','��','200-3�');
select * from ����������_���������;
delete from AUDITORIUM where AUDITORIUM='201';
drop view ����������_���������;


--5. ������������� ����������, �� ���. SELECT, ���. �������
exec('CREATE VIEW [����������]
	as select TOP 150	SUBJECT			[���],
						SUBJECT_NAME	[������������],
						PULPIT			[��� �������]
						from SUBJECT
						order by ������������')
select * from [����������];
drop view [����������];


--6. �������� ���.������, ���� ��������� � ���.��������
exec('ALTER view [���������� ������] WITH SCHEMABINDING
	as select	distinct(FACULTY.FACULTY_NAME)	[���������],
				count(PULPIT.FACULTY)	[���������� ������]
				
				from dbo.FACULTY inner join dbo.PULPIT
				on PULPIT.FACULTY=FACULTY.FACULTY
				group by FACULTY.FACULTY_NAME ')
select * from [���������� ������];
drop view [���������� ������];