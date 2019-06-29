USE Chist_UNIVER;

CREATE Table RESULTS
(   ID int   primary key   identity(1, 1),
    Имя_студента nvarchar(50),
    Балл_матем int,
    Балл_англ int,
    Средний_балл as (Балл_матем+Балл_англ)/2
)

INSERT into RESULTS(Имя_студента, Балл_матем, Балл_англ)
	values	('Федя', 10, 8),
			('Люба', 5, 6),
			('Глория', 8, 4)

SELECT *From RESULTS;