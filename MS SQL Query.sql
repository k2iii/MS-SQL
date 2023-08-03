-- 스캐줄러, 러너블 큐, 워크 리퀘스트 큐, I/O 리퀘스트 리스트
SELECT * FROM sys.dm_os_schedulers

-- 작업자 관련 정보
SELECT * FROM sys.dm_os_workers

-- 작업자와 링크된 윈도우가 관리하는 스레드 관련 정보
SELECT * FROM sys.dm_os_threads