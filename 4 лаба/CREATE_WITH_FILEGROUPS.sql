use master 
create database CJA_UNIVER 

on primary --�������.����.������, ���.����.
	( name = N'CJA_UNIVER_mdf', filename = N'C:\CJA_UNIVER\CJA_UNIVER_mdf.mdf', 
		size = 5120Kb, maxsize = 10240Kb, filegrowth = 1024Kb), 
	( name = N'CJA_UNIVER_ndf', filename = N'C:\CJA_UNIVER\CJA_UNIVER_ndf.ndf', 
		size = 5120Kb, maxsize = 10240Kb, filegrowth = 10%), 
		
filegroup G1 
	( name = N'CJA_UNIVER_fg1_1', filename = N'C:\CJA_UNIVER\CJA_UNIVER_g1_1.ndf', 
		size = 10240Kb, maxsize = 15360Kb, filegrowth = 1024Kb), 
	( name = N'CJA_UNIVER_fg1_2', filename = N'C:\CJA_UNIVER\CJA_UNIVER_g1_2.ndf', 
		size = 2048Kb, maxsize = 5120Kb, filegrowth = 1024Kb), 
		
filegroup G2 
	( name = N'CJA_UNIVER_fg2_1', filename = N'C:\CJA_UNIVER\CJA_UNIVER_g2_1.ndf', 
		size = 5120Kb, maxsize = 10240Kb, filegrowth = 1024Kb), 
	( name = N'CJA_UNIVER_fg2_2', filename = N'C:\CJA_UNIVER\CJA_UNIVER_g2_2.ndf', 
		size = 2048Kb, maxsize = 5120Kb, filegrowth = 1024Kb) 
		
log on --������ ����������
	( name = N'CJA_UNIVER_log', filename=N'C:\CJA_UNIVER\CJA_UNIVER_log.ldf', 
		size=5120Kb, maxsize=UNLIMITED, filegrowth=1024Kb) 


--.mdf 1, .ndf 2, log �.�.��. (������ �)
--����.������ - ������������� ����� ������ ��
--�����. �����. ��
--���� ��-�� (�����, ����� ��), �����. ����.������ ��� ������ �����
-- � ���. �������� ����� ��� ���� ����.������