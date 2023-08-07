-- ��ĳ�ٷ�, ���ʺ� ť, ��ũ ������Ʈ ť, I/O ������Ʈ ����Ʈ
SELECT * FROM sys.dm_os_schedulers

-- �۾��� ���� ����
SELECT * FROM sys.dm_os_workers

-- �۾��ڿ� ��ũ�� �����찡 �����ϴ� ������ ���� ����
SELECT * FROM sys.dm_os_threads

-- �����ս� �����
/*
Avg.Disk sec/Read ī����
 - 1ȸ�� �б⿡ ��� �ð��� ��հ��� ��Ÿ����. 20ms �̻��� ���� ��Ÿ���ٸ� ��ũ�� �׼��� �ӵ��� ������ 
   �ִٰ� �� �� �ִ�.
Avg.Disk sec/Write ī����
 - 1ȸ�� ��Ͽ� ��� �ð��� ��հ��� ��Ÿ����. 20ms �̻��� ���� ��Ÿ���ٸ� ��ũ�� ������ �ӵ��� ������ �ִٰ� �� �� �ִ�.
 wait_time_ms ���� ���� ������ ��µǴ� �������� wait_type���� ���� 
 ASYNC_IO_COMPLETION, IO_COMPLETION, LOGMGR, WRITELOG, PAGEIOLATCH_SH, PAGEIOLATCH_UP, PAGEIOLATCH_EX, PAGEIOLATCH_DT, PAGEIOLATCH_NL, PAGEIOLATCH_KP
 �� ��� �ϳ��̸� ��ũ�� �׼��� �ӵ��� ������ ���� ���ɼ��� �ִ�.
*/
SELECT * FROM sys.dm_os_wait_stats WHERE wait_type = 'IO_COMPLETION' ORDER BY wait_time_ms DESC

-- ���� �޸� ������� SQL ������ �޸� ��뷮
EXEC sp_configure 'max server memory', 1024 -- �ִ밪�� MB������ ����
GO
RECONFIGURE
GO

-- 4���� CPU(�Ǵ� �ھ�)�� ž��� ��ǻ�Ϳ��� ������ CPU�� ���� NUMA ��带 �Ҵ�
-- 1) ���� ������ ������ ������ �����Ѵ�.
ALTER SERVER CONFIGURATION
SET PROCESS AFFINITY CPU = 0 TO 3
GO

-- 2) ������Ʈ�� ������(regedit.exe)�� �����ؼ� �Ʒ��� ��Ÿ���� Ű�� �߰��Ѵ�.
--    �̿� ���ؼ� ��� CPU�� ���� ����Ʈ NUMA��尡 �Ҵ�ȴ�.
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node0	DWORD	CPUMask	0x01
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node1	DWORD	CPUMask	0x02
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node2	DWORD	CPUMask	0x04
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node3	DWORD	CPUMask	0x08

-- SQL ������ ����� �޸� ������ ���� ���� ���
DBCC MEMORYSTATUS
GO

-- SQL ������ ����� �޸� ������ ���� ���� ���
SELECT * FROM sys.dm_os_memory_clerks

/*
SELECT TOP 10 type, sum(2048) AS 1024
FROM sys.dm_os_memory_clerks
GROUP BY type
GROUP BY sum(1024) DESC*/

-- ȥ�� �ͽ���Ʈ �Ҵ��� ��ȿȭ(����Ʈ ����)
ALTER DATABASE adventureWorks2022
SET MIXED_PAGE_ALLOCATION OFF;
GO

-- ȥ�� �ͽ���Ʈ �Ҵ��� ��ȿȭ
ALTER DATABASE adventureWorks2022
SET MIXED_PAGE_ALLOCATION ON;
GO

-- ������ ���� ��Ȳ�� Ȯ���ϴ� ����
CREATE database db1
GO
USE db1
GO
CREATE TABLE t1 (c1 int NOT NULL, c2 char(10), c3 varchar(10), c4 varchar(10), c5 char(10))
GO
INSERT t1 VALUES (1, 'AAA', 'AAA', 'AAA', 'AAA')
INSERT t1 VALUES (2, 'BBB', 'BBB', 'BBB', 'BBB')
INSERT t1 VALUES (3, 'CCC', 'CCC', 'CCC', 'CCC')
GO

-- ���̺� ���Ǵ� �������� Ȯ��
DBCC TRACEON(3604) -- ���� ����� Ŭ���̾�Ʈ�� ��ȯ�ϴ� �����̴�.
DBCC IND('db1', 't1', -1) -- DBC IND('�����ͺ��̽���', '���̺��', '�ε��� ID')
GO

-- �������� Ȯ��
-- ��� �ɼ�: '-1' �Ǵ� '0'
DBCC PAGE('db1', 1, 80, -1) -- DBCC PAGE('�����ͺ��̽���', ����ID, ������ID, ��� �ɼ�)
DBCC PAGE('db1', 1, 80, 0)
DBCC PAGE('db1', 1, 80, 1) -- �ǵ����ʹ� 16������ ǥ���Ǹ� 16����Ʈ ���� �����Ǿ� �ִ�.
DBCC PAGE('db1', 1, 80, 2) -- �ܼ��ϰ� �������� ������ 16������ ������ ��µȴ�.
DBCC PAGE('db1', 1, 80, 3) -- ��¿ɼ� 1�� ���뿡 �߰��ؼ� �� ���� �̸��� ����Ǿ� �ִ� ���� ������ �ະ�� �����Ǿ� ��µȴ�.

-- ��� ���� ��������� �ۼ�
CREATE STATISTICS ��������� ON ���̺��(����)

-- ���̺� �� 50%�� ���� ���÷� ����Ѵ�.
CREATE STATISTICS ��������� ON ���̺��(����) WITH sample 50 percent

-- ���̺� ���� ��� ���� ���÷� ����Ѵ�.
CREATE STATISTICS ��������� ON ���̺��(����) WITH FULLSCAN

-- ��� ���� �ڵ� �ۼ� ������Ƽ�� ��ȿȭ(����Ʈ �������� ��ȿ)
ALTER DATABASE �����ͺ��̽��� SET AUTO_CREATE_STATISTICS ON

-- ��� ���� �ڵ� �ۼ� ������Ƽ�� ��ȿȭ
ALTER DATABASE �����ͺ��̽��� SET AUTO_CREATE_STATISTICS OFF

-- ��� ������ ����Ǿ� �ִ� ������ Ȯ��
DBCC SHOW_STATISTICS(���̺��, ��� ������)

-- ���� ���̺��� ����
CREATE TABLE [ �ι�] ([ ��] nvarchar(50), [ ��] nvarchar(50), [ �ּ�] nvarchar(50))
GO
-- �������� �μ�Ʈ
INSERT [ �ι�] VALUES(N'��', N'����', N'����')
INSERT [ �ι�] VALUES(N'��', N'����', N'����')
INSERT [ �ι�] VALUES(N'��', N'ö��', N'����')
INSERT [ �ι�] VALUES(N'��', N'��ȣ', N'�λ�')
INSERT [ �ι�] VALUES(N'��', N'����', N'�뱸')
INSERT [ �ι�] VALUES(N'��', N'����', N'����')

-- ���ؽ��� �ۼ�
CREATE INDEX [ ���� ����] ON [ �ι�] ([ ��], [ ��])
GO

DBCC SHOW_STATISTICS([ �ι�], [ ���� ����])

-- ���� ������ ����
-- ����Ʈ ���������� ���� ������(��Ŷ ������)�� 4096����Ʈ�̴�.
EXEC sp_configure network packet size, 8192
GO
RECONFIGURE
GO

-- BACKUP Ŀ�ǵ带 CHECKSUM �ɼǰ� �Բ� �����ϴ� ����
 BACKUP DATABASE N'�����ͺ��̽���' TO DISK = N'��� ������ Ǯ�н�' WITH CHECKSUM

 -- �ļյ� ��� ������ ����
 RESTORE DATABASE �����ͺ��̽���
 FROM DISK = N'��� ������ Ǯ �н�'
 WITH CONTINUE_AFTER_ERROR

 -- ���� ����� ��� ��� Ȯ��

 -- Ȯ�� �̺�Ʈ�� ���� ���ŷ �ؼ�
 -- SQL SERVER �Ŵ�����Ʈ ��Ʃ����� ���� Ʈ���� ����ؼ� �ؼ� ��� SQL ������ �����Ѵ�.
 -- ������ Ŀ�ǵ带 �����Ѵ�. '�� �ð�'���� ���� �����ϴ� �Ӱ谪�� �� ���� �����Ѵ�.
 -- 10�� �̻��� ����� �����ϰ� ���� ���� '10'�̶�� �����Ѵ�.
 EXEC sp_configure 'Blocked Process Threshold', �� �ð�
 GO
 RECONFIGURE
 GO

