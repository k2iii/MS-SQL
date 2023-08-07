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
