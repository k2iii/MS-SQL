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

/*
SELECT TOP 10 type, sum(2048) AS 1024
FROM sys.dm_os_memory_clerks
GROUP BY type
GROUP BY sum(1024) DESC*/

-- 혼합 익스텐트 할당을 무효화(디폴트 설정)
ALTER DATABASE adventureWorks2022
SET MIXED_PAGE_ALLOCATION OFF;
GO

-- 혼합 익스텐트 할당을 유효화
ALTER DATABASE adventureWorks2022
SET MIXED_PAGE_ALLOCATION ON;
GO

-- 페이지 내의 상황을 확인하는 샘플
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

-- 테이블에 사용되는 페이지의 확인
DBCC TRACEON(3604) -- 실행 결과를 클라이언트에 반환하는 설정이다.
DBCC IND('db1', 't1', -1) -- DBC IND('데이터베이스명', '테이블명', '인덱스 ID')
GO

-- 페이지의 확인
-- 출력 옵션: '-1' 또는 '0'
DBCC PAGE('db1', 1, 80, -1) -- DBCC PAGE('데이터베이스명', 파일ID, 페이지ID, 출력 옵션)
DBCC PAGE('db1', 1, 80, 0)
DBCC PAGE('db1', 1, 80, 1) -- 실데이터는 16진수로 표현되며 16바이트 별로 성형되어 있다.
DBCC PAGE('db1', 1, 80, 2) -- 단순하게 페이지의 내용은 16진수의 덤프로 출력된다.
DBCC PAGE('db1', 1, 80, 3) -- 출력옵션 1의 내용에 추가해서 각 열의 이름과 저장되어 있는 값이 각각의 행별로 성형되어 출력된다.

-- 통계 정보 명시적으로 작성
CREATE STATISTICS 통계정보명 ON 테이블명(열명)

-- 테이블 내 50%의 행을 샘플로 사용한다.
CREATE STATISTICS 통계정보명 ON 테이블명(열명) WITH sample 50 percent

-- 테이블 내의 모든 행을 샘플로 사용한다.
CREATE STATISTICS 통계정보명 ON 테이블명(열명) WITH FULLSCAN

-- 통계 정보 자동 작성 프로퍼티의 유효화(디폴트 설정에서 유효)
ALTER DATABASE 데이터베이스명 SET AUTO_CREATE_STATISTICS ON

-- 통계 정보 자동 작성 프로퍼티의 무효화
ALTER DATABASE 데이터베이스명 SET AUTO_CREATE_STATISTICS OFF

-- 통계 정보에 저장되어 있는 내용을 확인
DBCC SHOW_STATISTICS(테이블명, 통계 정보명)

-- 샘플 테이블의 정의
CREATE TABLE [ 인물] ([ 성] nvarchar(50), [ 명] nvarchar(50), [ 주소] nvarchar(50))
GO
-- 데이터의 인서트
INSERT [ 인물] VALUES(N'김', N'영희', N'서울')
INSERT [ 인물] VALUES(N'김', N'영희', N'서울')
INSERT [ 인물] VALUES(N'박', N'철수', N'제주')
INSERT [ 인물] VALUES(N'이', N'윤호', N'부산')
INSERT [ 인물] VALUES(N'신', N'민지', N'대구')
INSERT [ 인물] VALUES(N'한', N'수정', N'전주')

-- 인텍스의 작성
CREATE INDEX [ 색인 성명] ON [ 인물] ([ 성], [ 명])
GO

DBCC SHOW_STATISTICS([ 인물], [ 색인 성명])

-- 버퍼 사이즈 변경
-- 디폴트 설정에서는 버퍼 사이즈(패킷 사이즈)는 4096바이트이다.
EXEC sp_configure network packet size, 8192
GO
RECONFIGURE
GO

-- BACKUP 커맨드를 CHECKSUM 옵션과 함께 실행하는 구문
 BACKUP DATABASE N'데이터베이스명' TO DISK = N'백업 파일의 풀패스' WITH CHECKSUM

 -- 파손된 백업 파일의 복원
 RESTORE DATABASE 데이터베이스명
 FROM DISK = N'백업 파일의 풀 패스'
 WITH CONTINUE_AFTER_ERROR

 -- 쿼리 저장소 사용 방법 확인

 -- 확장 이벤트에 의한 블로킹 해석
 -- SQL SERVER 매니지먼트 스튜디오의 쿼리 트리를 사용해서 해석 대상 SQL 서버에 접속한다.
 -- 다음의 커맨드를 실행한다. '락 시간'에는 락을 검출하는 임계값을 초 수로 설정한다.
 -- 10초 이상의 블록을 검출하고 싶을 때는 '10'이라고 지정한다.
 EXEC sp_configure 'Blocked Process Threshold', 락 시간
 GO
 RECONFIGURE
 GO

