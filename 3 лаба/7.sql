USE Chist_UNIVER
ALTER Table STUDENT ADD POL nchar(1) default 'ì' check (POL in ('ì', 'æ')); 
SELECT *From Student;