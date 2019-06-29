use CJA_UNIVER;

--1. опр. все индексы, какие (не)кластериз., (не)уникал, составные, покрытия, фильтруемые
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'SUBJECT'	--перечень индексов, связ. с д-й таблицей
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'TEACHER'




--2. заполн. врем. лок. таблицу (>1000 строк)
--select план запроса, опр. его стоимость
--создать кластер.индекс, уменьшающий стоимость SELECT-запроса

create table #temp_table
(	some_ind int, 
	some_field varchar(20)
)
SET nocount on;		--не вывод сообщения о вводе строк
DECLARE @i int = 0;
while @i < 100
	begin
		insert #temp_table(some_ind, some_field)
			values(FLOOR(RAND()*10000), REPLICATE('юля ',3));
		SET @i = @i + 1; 
	end

select * from #temp_table where some_ind between 1500 and 5000 order by some_ind 
	checkpoint;				--фиксация БД
	DBCC DROPCLEANBUFFERS;	--очистить буферный кэш
CREATE clustered index #temp_table_cl on #temp_table(some_ind asc)
drop table #temp_table



--3. созд. врем.табл, заполнить
--select-запрос, его план и стоимость
--некластер.неуник.состав.индекс
create table #temp_table_1
(
	some_ind int, 
	some_field varchar(20),
	cc int identity(1,1)	
)
SET nocount on;
DECLARE @j int = 0;
while @j < 100
begin
	insert #temp_table_1(some_ind, some_field)
		values(FLOOR(RAND()*10000), 'str' + cast(@j as nvarchar(1000)) );
	SET @j = @j + 1; 
end

select * from #temp_table_1 where cc >500 and some_ind between 1500 and 5000 

SELECT count(*)[количество строк] from #temp_table_1;
SELECT * from #temp_table_1
CREATE index #temp_table_1_nonclu on #temp_table_1(some_ind, CC)
--drop table #temp_table_1




--4. созд. врем.лок.табл, заполнить
--select-запрос, его план и стоимость
--некластер. индекс покрытия, (уменьш. стоимость)
--позв вкл в индексную строку значения 1/неск. неиндексируемых столбцов
create table #temp_table_2
(
	some_ind int, 
	some_field varchar(20),
	cc int identity(1,1)
)
SET nocount on;
DECLARE @k int = 0;
while @k < 100
begin
	insert #temp_table_2(some_ind, some_field)
		values(FLOOR(RAND()*30000), REPLICATE('julia',3) );
	SET @k = @k + 1; 
end

select * from #temp_table_2 where cc >500 and some_ind between 1500 and 5000 
CREATE index #temp_table_2_nonclu_2 on #temp_table_2(some_ind) INCLUDE(cc)
select CC from #temp_table_2 where some_ind > 500
--drop table #temp_table_2




--5. созд. врем.лок.табл., заполнить
--select-запрос, план и стоимость
--некластер.фильтруемый индекс (уменьш. стоимость)
SELECT some_ind from  #temp_table_2 where some_ind between 5000 and 19999; 
SELECT some_ind from  #temp_table_2 where some_ind>15000 and  some_ind < 20000  
SELECT some_ind from  #temp_table_2 where some_ind=17000

 CREATE  index #temp_table_WHERE on #temp_table_2(some_ind) where (some_ind>15000 and 
 some_ind  < 20000);
 drop index #temp_table_WHERE on #temp_table_2



--6.созд.врем.лок.табл., заполнить
--созд. некластериз.индекс
--оценить фрагментацию индекса
--реорганизация индекса, снова оценка
--перестройка индекса, снова оценка
use tempdb
CREATE index #temp_table_2_ind  on #temp_table_2(some_ind);

SELECT	name [Индекс],
		avg_fragmentation_in_percent [Фрагментация(%)] 
	FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
  OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) ss
  JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
  where name is not null;

INSERT top(10000) #temp_table_2(some_ind, some_field) select some_ind, some_field from #temp_table_2;

ALTER index #temp_table_2_ind on #temp_table_2 reorganize; 
ALTER index #temp_table_2_ind  on #temp_table_2 rebuild with (online = off);

drop index #temp_table_2_ind on #temp_table_2


--7
CREATE index #temp_table_2_ind1  on #temp_table_2(some_ind)with (fillfactor = 65);

INSERT top(50)percent into #temp_table_2(some_ind, some_field) select some_ind, some_field  from #temp_table_2; 
use tempdb
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация(%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), OBJECT_ID(N'#temp_table_2'), NULL, NULL, NULL) ss
       JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
       where name is not null;

drop index #temp_table_2_ind1 on #temp_table_2
