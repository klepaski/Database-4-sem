USE Chist_UNIVER
ALTER Table STUDENT ADD POL nchar(1) default '�' check (POL in ('�', '�')); 
SELECT *From Student;