USE Chist_UNIVER;

CREATE Table RESULTS
(   ID int   primary key   identity(1, 1),
    ���_�������� nvarchar(50),
    ����_����� int,
    ����_���� int,
    �������_���� as (����_�����+����_����)/2
)

INSERT into RESULTS(���_��������, ����_�����, ����_����)
	values	('����', 10, 8),
			('����', 5, 6),
			('������', 8, 4)

SELECT *From RESULTS;