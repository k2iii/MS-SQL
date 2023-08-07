-- 스캐줄러, 러너블 큐, 워크 리퀘스트 큐, I/O 리퀘스트 리스트
SELECT * FROM sys.dm_os_schedulers

-- 작업자 관련 정보
SELECT * FROM sys.dm_os_workers

-- 작업자와 링크된 윈도우가 관리하는 스레드 관련 정보
SELECT * FROM sys.dm_os_threads

-- 퍼포먼스 모니터
/*
Avg.Disk sec/Read 카운터
 - 1회의 읽기에 드는 시간의 평균값을 나타낸다. 20ms 이상의 값을 나타낸다면 디스크의 액세스 속도에 문제가 
   있다고 볼 수 있다.
Avg.Disk sec/Write 카운터
 - 1회의 기록에 드는 시간의 평균값을 나타낸다. 20ms 이상의 값을 나타낸다면 디스크의 엑세스 속도에 문제가 있다고 볼 수 있다.
 wait_time_ms 열의 상위 행으로 출력되는 데이터의 wait_type열의 값이 
 ASYNC_IO_COMPLETION, IO_COMPLETION, LOGMGR, WRITELOG, PAGEIOLATCH_SH, PAGEIOLATCH_UP, PAGEIOLATCH_EX, PAGEIOLATCH_DT, PAGEIOLATCH_NL, PAGEIOLATCH_KP
 중 어느 하나이면 디스크의 액세스 속도에 문제가 있을 가능성이 있다.
*/
SELECT * FROM sys.dm_os_wait_stats WHERE wait_type = 'IO_COMPLETION' ORDER BY wait_time_ms DESC

-- 물리 메모리 사이즈와 SQL 서버의 메모리 사용량
EXEC sp_configure 'max server memory', 1024 -- 최대값을 MB단위로 지정
GO
RECONFIGURE
GO

-- 4개의 CPU(또는 코어)가 탑재된 컴퓨터에서 각각의 CPU에 대해 NUMA 노드를 할당
-- 1) 쿼리 툴에서 다음의 쿼리를 실행한다.
ALTER SERVER CONFIGURATION
SET PROCESS AFFINITY CPU = 0 TO 3
GO

-- 2) 레지스트리 에디터(regedit.exe)를 실행해서 아래에 나타내는 키를 추가한다.
--    이에 의해서 모든 CPU에 대해 소프트 NUMA노드가 할당된다.
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node0	DWORD	CPUMask	0x01
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node1	DWORD	CPUMask	0x02
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node2	DWORD	CPUMask	0x04
-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\150\NodeConfiguration\Node3	DWORD	CPUMask	0x08

-- SQL 서버가 사용한 메모리 상태의 스냅 숏이 출력
DBCC MEMORYSTATUS
GO

-- SQL 서버가 사용한 메모리 상태의 스냅 숏이 출력
SELECT * FROM sys.dm_os_memory_clerks
