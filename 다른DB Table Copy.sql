-- 다른DB Table Copy

-- invoice 
Insert Into [ECSTracking].[dbo].[h_invoice_info](INVOICE_ID, WT_CHECK_FLAG, MNL_PACKING_COMPULSION_FLAG, ORDER_CANCEL, WEIGHT_SUM, CREATED_AT, OUT_TIME) 
select INVOICE_ID, WT_CHECK_FLAG, MNL_PACKING_COMPULSION_FLAG, ORDER_CANCEL, WEIGHT_SUM, CREATED_AT, OUT_TIME From [ECS].[dbo].[invoice] 

-- h_invoice_info
Insert Into [ECSTracking].[dbo].[h_invoice_info](INVOICE_ID, WH_ID, CST_CD, WAVE_NO, WAVE_LINE_NO, ORD_NO, ORD_LINE_NO, BOX_NO, STORE_LOC_CD, BOX_TYPE_CD, EQP_ID, CST_ORD_NO, MNL_PACKING_FLAG, INVOICE_ZPL_300DPI) 
select INVOICE_ID, WH_ID, CST_CD, WAVE_NO, WAVE_LINE_NO, ORD_NO, ORD_LINE_NO, BOX_NO, STORE_LOC_CD, BOX_TYPE_CD, EQP_ID, CST_ORD_NO, MNL_PACKING_FLAG, INVOICE_ZPL_300DPI  From [ECS].[dbo].[h_invoice_info] 

-- box
set identity_insert [ECSTracking].[dbo].[box] on
Insert Into [ECSTracking].[dbo].[box]([INDEX], BOX_ID, INVOICE_ID, PRINT_COUNT, VERIFIED, CREATED_AT) 
select [INDEX], BOX_ID, INVOICE_ID, PRINT_COUNT, VERIFIED, CREATED_AT From [ECS].[dbo].[box] 
set identity_insert [ECSTracking].[dbo].[box] off

-- h_weight_check
set identity_insert [ECSTracking].[dbo].[h_weight_check] on
Insert Into [ECSTracking].[dbo].[h_weight_check]([INDEX], BOX_ID, ERECTOR_TYPE, CASE_ERECTED_AT, STANDARD_WHT, MEASURE_WHT, VERIFICATION, CREATED_AT) 
select [INDEX], BOX_ID, ERECTOR_TYPE, CASE_ERECTED_AT, STANDARD_WHT, MEASURE_WHT, VERIFICATION, CREATED_AT From [ECS].[dbo].[h_weight_check] 
set identity_insert [ECSTracking].[dbo].[h_weight_check] off

-- h_invoice_bcr
set identity_insert [ECSTracking].[dbo].[h_invoice_bcr] on
Insert Into [ECSTracking].[dbo].[h_invoice_bcr]([INDEX], BOX_ID, INVOICE_ID, BCR_TYPE, LINE, RESULT, CREATED_AT) 
select [INDEX], BOX_ID, INVOICE_ID, BCR_TYPE, LINE, RESULT, CREATED_AT From [ECS].[dbo].[h_invoice_bcr] 
set identity_insert [ECSTracking].[dbo].[h_invoice_bcr] off

-- h_top_verification
Insert Into [ECSTracking].[dbo].[h_top_verification](BCR_INDEX, VERIFICATION) 
select BCR_INDEX, VERIFICATION From [ECS].[dbo].[h_top_verification] 

-- h_smart_packing
set identity_insert [ECSTracking].[dbo].[h_smart_packing] on
Insert Into [ECSTracking].[dbo].[h_smart_packing]([INDEX], BOX_ID, INSERT_TIME, RESULT, VOLUME, HEIGHT, IS_MANUAL, PACKING_AMOUNT, OUT_TIME) 
select [INDEX], BOX_ID, INSERT_TIME, RESULT, VOLUME, HEIGHT, IS_MANUAL, PACKING_AMOUNT, OUT_TIME From [ECS].[dbo].[h_smart_packing] 
set identity_insert [ECSTracking].[dbo].[h_smart_packing] off

-- h_hourly_count
Insert Into [ECSTracking].[dbo].[h_hourly_count](DATE, HOUR, ORDER_COUNT, CASE_ERECT1_COUNT, CASE_ERECT2_COUNT, CASE_ERECT3_COUNT,CASE_ERECT_REJECT_COUNT, WEIGHT1_COUNT, WEIGHT2_COUNT, WEIGHT_REJECT_COUNT, SMART_PRINT_COUNT, NORMAL_PRINT_COUNT, TOP_COUNT, TOP_REJECT_COUNT, OUT_COUNT, REAL_OUT_COUNT, PACKING_COUNT, PACKING_REJECT_COUNT, ORDER_CANCEL_COUNT) 
select DATE, HOUR, ORDER_COUNT, CASE_ERECT1_COUNT, CASE_ERECT2_COUNT, CASE_ERECT3_COUNT,CASE_ERECT_REJECT_COUNT, WEIGHT1_COUNT, WEIGHT2_COUNT, WEIGHT_REJECT_COUNT, SMART_PRINT_COUNT, NORMAL_PRINT_COUNT, TOP_COUNT, TOP_REJECT_COUNT, OUT_COUNT, REAL_OUT_COUNT, PACKING_COUNT, PACKING_REJECT_COUNT, ORDER_CANCEL_COUNT From [ECS].[dbo].[h_hourly_count] 

-- h_daily_count
Insert Into [ECSTracking].[dbo].[h_daily_count](DATE, ORDER_COUNT, CASE_ERECT_COUNT, CASE_ERECT_REJECT_COUNT, WEIGHT_COUNT, WEIGHT_REJECT_COUNT, SMART_PRINT_COUNT, NORMAL_PRINT_COUNT, TOP_COUNT, TOP_REJECT_COUNT, OUT_COUNT, REAL_OUT_COUNT, NON_OUT_COUNT, PACKING_COUNT, PACKING_REJECT_COUNT, ORDER_CANCEL_COUNT) 
select DATE, ORDER_COUNT, CASE_ERECT_COUNT, CASE_ERECT_REJECT_COUNT, WEIGHT_COUNT, WEIGHT_REJECT_COUNT, SMART_PRINT_COUNT, NORMAL_PRINT_COUNT, TOP_COUNT, TOP_REJECT_COUNT, OUT_COUNT, REAL_OUT_COUNT, NON_OUT_COUNT, PACKING_COUNT, PACKING_REJECT_COUNT, ORDER_CANCEL_COUNT From [ECS].[dbo].[h_daily_count] 

-- h_tracking_copy
Select * Into [ECSTracking].[dbo].[h_tracking] From [ECS].[dbo].[h_tracking]  - 테이블이 없을때

------- 테이블이 있을때
set identity_insert [ECSTracking].[dbo].[h_tracking_copy1] on
Insert Into [ECSTracking].[dbo].[h_tracking_copy1]([INDEX], BOX_ID, INVOICE_ID, CST_ORD_NO, STATUS, TASK_ID, ORDER_TIME, TASK_TIME) select [INDEX], BOX_ID, INVOICE_ID, CST_ORD_NO, STATUS, TASK_ID, ORDER_TIME, TASK_TIME From [ECS].[dbo].[h_tracking_copy] 
set identity_insert [ECSTracking].[dbo].[h_tracking_copy1] off


-- 뷰어에 사용한 프로시저 Create
 -- SELECT_DAILY_COUNTS
 -- SELECT_HOURLY_COUNTS
 -- SELECT_SMART_PACKING_REJECT_QUERY
 -- SELECT_TRACKING_QUERY
 -- SELECT_VIEWER_INVOICE_REJECT_QUERY
 -- SELECT_VIEWER_ORDER_QUERY
 -- SELECT_VIEWER_OUT_MANAGE_QUERY
 -- SELECT_VIEWER_TRACKING_QUERY
 -- SELECT_VIEWER_WEIGHT_CHECK_REJECT_QUERY

-- 뷰어에 사용한 함수 Create
 -- 스칼라 반환 함수
   -- CONVERT_DATE


-- 트리거 
USE [ECS]
GO
/****** Object:  Trigger [dbo].[tracking_copy_trigger]    Script Date: 2023-01-16 오후 6:58:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[tracking_copy_trigger]
	ON [dbo].[h_tracking]
	AFTER INSERT
AS
BEGIN
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_tracking_copy1]
	SELECT
		BOX.BOX_ID,
		TR.INVOICE_ID,
		INFO.CST_ORD_NO,
		TR.STATUS,
		TR.TASK_ID,
		ORDER_TIME = INV.CREATED_AT,
		TASK_TIME = TR.CREATED_AT
	from inserted AS TR
	INNER JOIN invoice AS INV
		ON INV.INVOICE_ID = TR.INVOICE_ID
	INNER JOIN h_invoice_info AS INFO
		ON INFO.INVOICE_ID = INV.INVOICE_ID
	LEFT OUTER JOIN BOX
		ON BOX.INVOICE_ID = INV.INVOICE_ID
END

--트리거
box_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[box_trigger]    Script Date: 2023-01-19 오전 10:53:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[box_trigger]
	ON [dbo].[box]
	AFTER INSERT
AS
BEGIN
	set identity_insert [ECSTracking].[dbo].[box] on
	INSERT INTO [URCIS].[ECSTracking].[dbo].[box]([INDEX],BOX_ID, INVOICE_ID, PRINT_COUNT, VERIFIED, CREATED_AT)
	SELECT
		TR.[INDEX],
		TR.BOX_ID,
		TR.INVOICE_ID,
		TR.PRINT_COUNT,
		TR.VERIFIED,
		TR.CREATED_AT
	from inserted AS TR
	set identity_insert [ECSTracking].[dbo].[box] off

END


ALTER TABLE [dbo].[box] ENABLE TRIGGER [box_trigger]
GO

box_update_trigger(update)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[box_update_trigger]    Script Date: 2023-01-19 오후 2:48:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER [dbo].[box_update_trigger]
	ON [dbo].[box]
	for UPDATE
AS

declare @invoiceid varchar(40)
declare @boxid varchar(40)

select @invoiceid = INVOICE_ID, @boxid = BOX_ID from inserted
UPDATE [ECSTracking].[dbo].[box] set INVOICE_ID = @invoiceid
where BOX_ID = @boxid
GO

ALTER TABLE [dbo].[box] ENABLE TRIGGER [box_update_trigger]
GO

box_delete_trigger(delete)


invoice_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[invoice_trigger]    Script Date: 2023-01-19 오후 3:28:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE TRIGGER [dbo].[invoice_trigger]
	ON [dbo].[invoice]
	AFTER INSERT
AS
BEGIN
	INSERT INTO [URCIS].[ECSTracking].[dbo].[invoice](INVOICE_ID, WT_CHECK_FLAG, MNL_PACKING_COMPULSION_FLAG, ORDER_CANCEL, WEIGHT_SUM, CREATED_AT, OUT_TIME)
	SELECT
		TR.INVOICE_ID,
		TR.WT_CHECK_FLAG,
		TR.MNL_PACKING_COMPULSION_FLAG,
		TR.ORDER_CANCEL,
		TR.WEIGHT_SUM,
		TR.CREATED_AT,
		TR.OUT_TIME
	from inserted AS TR

END


ALTER TABLE [dbo].[invoice] ENABLE TRIGGER [invoice_trigger]
GO

invoice_update_trigger(update)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[invoice_update_trigger]    Script Date: 2023-01-19 오후 3:28:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE TRIGGER [dbo].[invoice_update_trigger]
	ON [dbo].[invoice]
	for UPDATE
AS

declare @invoiceid varchar(40)
declare @outTime dateTime

select @invoiceid = INVOICE_ID, @outTime = OUT_TIME from inserted
UPDATE [ECSTracking].[dbo].[invoice] set OUT_TIME = @outTime
where INVOICE_ID = @invoiceid
GO

ALTER TABLE [dbo].[invoice] ENABLE TRIGGER [invoice_update_trigger]
GO


h_weight_check_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_weight_check_trigger]    Script Date: 2023-01-19 오후 4:29:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE TRIGGER [dbo].[h_weight_check_trigger]
	ON [dbo].[h_weight_check]
	AFTER INSERT
AS
BEGIN
	set identity_insert [ECSTracking].[dbo].[h_weight_check] on
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_weight_check]([INDEX],BOX_ID, ERECTOR_TYPE, CASE_ERECTED_AT, STANDARD_WHT, MEASURE_WHT, VERIFICATION, CREATED_AT)
	SELECT
		TR.[INDEX],
		TR.BOX_ID,
		TR.ERECTOR_TYPE,
		TR.CASE_ERECTED_AT,
		TR.STANDARD_WHT,
		TR.MEASURE_WHT,
		TR.VERIFICATION,
		TR.CREATED_AT
	from inserted AS TR
	set identity_insert [ECSTracking].[dbo].[h_weight_check] off

END


ALTER TABLE [dbo].[h_weight_check] ENABLE TRIGGER [h_weight_check_trigger]
GO



h_invoice_bcr_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_invoice_bcr_trigger]    Script Date: 2023-01-19 오후 4:41:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE TRIGGER [dbo].[h_invoice_bcr_trigger]
	ON [dbo].[h_invoice_bcr]
	AFTER INSERT
AS
BEGIN
	set identity_insert [ECSTracking].[dbo].[h_invoice_bcr] on
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_invoice_bcr]([INDEX],BOX_ID, INVOICE_ID, BCR_TYPE, LINE, RESULT, CREATED_AT)
	SELECT
		TR.[INDEX],
		TR.BOX_ID,
		TR.INVOICE_ID,
		TR.BCR_TYPE,
		TR.LINE,
		TR.RESULT,
		TR.CREATED_AT
	from inserted AS TR
	set identity_insert [ECSTracking].[dbo].[h_invoice_bcr] off

END


ALTER TABLE [dbo].[h_invoice_bcr] ENABLE TRIGGER [h_invoice_bcr_trigger]
GO


h_smart_packing_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_weight_check_trigger]    Script Date: 2023-01-19 오후 4:45:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE TRIGGER [dbo].[h_smart_packing_trigger]
	ON [dbo].[h_smart_packing]
	AFTER INSERT
AS
BEGIN
	set identity_insert [ECSTracking].[dbo].[h_smart_packing] on
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_smart_packing]([INDEX],BOX_ID, INSERT_TIME, RESULT, VOLUME, HEIGHT, IS_MANUAL, PACKING_AMOUNT, OUT_TIME)
	SELECT
		TR.[INDEX],
		TR.BOX_ID,
		TR.INSERT_TIME,
		TR.RESULT,
		TR.VOLUME,
		TR.HEIGHT,
		TR.IS_MANUAL,
		TR.PACKING_AMOUNT,
		TR.OUT_TIME
	from inserted AS TR
	set identity_insert [ECSTracking].[dbo].[h_smart_packing] off

END


ALTER TABLE [dbo].[h_smart_packing] ENABLE TRIGGER [h_smart_packing_trigger]
GO

h_smart_packing_trigger(update)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[box_update_trigger]    Script Date: 2023-01-19 오후 5:03:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER [dbo].[h_smart_packing_update_trigger]
	ON [dbo].[h_smart_packing]
	for UPDATE
AS

declare @boxid varchar(40)
declare @ismanual BIT
declare @packing_amount INT
declare @outTime datetime

select @boxid = BOX_ID, @ismanual = IS_MANUAL, @packing_amount = PACKING_AMOUNT, @outTime = OUT_TIME from inserted
UPDATE [ECSTracking].[dbo].[h_smart_packing] set IS_MANUAL = @ismanual, PACKING_AMOUNT = @packing_amount, OUT_TIME = @outTime
where BOX_ID = @boxid
select * from inserted




GO

ALTER TABLE [dbo].[h_smart_packing] ENABLE TRIGGER [h_smart_packing_update_trigger]
GO



h_top_verification_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_top_verification_trigger]    Script Date: 2023-01-19 오후 5:24:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




h_top_verification_trigger(insert)
CREATE TRIGGER [dbo].[h_top_verification_trigger]
	ON [dbo].[h_top_verification]
	AFTER INSERT
AS
BEGIN
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_top_verification](BCR_INDEX, VERIFICATION)
	SELECT
		TR.BCR_INDEX,
		TR.VERIFICATION
	from inserted AS TR

END


ALTER TABLE [dbo].[h_top_verification] ENABLE TRIGGER [h_top_verification_trigger]
GO



h_daily_count_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_adily_count_trigger]    Script Date: 2023-01-20 오전 10:15:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[h_daily_count_trigger]
	ON [dbo].[h_daily_count]
	AFTER INSERT
AS
BEGIN
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_daily_count](DATE, ORDER_COUNT, CASE_ERECT_COUNT, CASE_ERECT_REJECT_COUNT, 
						WEIGHT_COUNT, WEIGHT_REJECT_COUNT, SMART_PRINT_COUNT, NORMAL_PRINT_COUNT, TOP_COUNT, TOP_REJECT_COUNT,
						OUT_COUNT, REAL_OUT_COUNT, NON_OUT_COUNT, PACKING_COUNT, PACKING_REJECT_COUNT, ORDER_CANCEL_COUNT)
	SELECT
		TR.DATE,
		TR.ORDER_COUNT,
		TR.CASE_ERECT_COUNT,
		TR.CASE_ERECT_REJECT_COUNT,
		TR.WEIGHT_COUNT,
		TR.WEIGHT_REJECT_COUNT,
		TR.SMART_PRINT_COUNT,
		TR.NORMAL_PRINT_COUNT,
		TR.TOP_COUNT,
		TR.TOP_REJECT_COUNT,
		TR.OUT_COUNT,
		TR.REAL_OUT_COUNT,
		TR.NON_OUT_COUNT,
		TR.PACKING_COUNT,
		TR.PACKING_REJECT_COUNT,
		TR.ORDER_CANCEL_COUNT
	from inserted AS TR
END


ALTER TABLE [dbo].[h_daily_count] ENABLE TRIGGER [h_adily_count_trigger]
GO

h_daily_count_update_trigger(update)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_daily_count_update_trigger]    Script Date: 2023-01-20 오전 10:16:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE TRIGGER [dbo].[h_daily_count_update_trigger]
	ON [dbo].[h_daily_count]
	for UPDATE
AS

declare @date datetime
declare @order_count int
declare @case_erect_count int
declare @case_erect_reject_count int
declare @weight_count int
declare @weight_reject_count int
declare @smart_print_count int
declare @normal_print_count int
declare @top_count int
declare @top_reject_count int
declare @out_count int
declare @real_out_count int
declare @non_out_count int
declare @packing_count int
declare @packing_reject_count int
declare @order_cancel_count int

select @date = DATE, @order_count = ORDER_COUNT, @case_erect_count = CASE_ERECT_COUNT, @case_erect_reject_count = CASE_ERECT_REJECT_COUNT,
       @weight_count = WEIGHT_COUNT, @weight_reject_count = WEIGHT_REJECT_COUNT, @smart_print_count = SMART_PRINT_COUNT, @normal_print_count = NORMAL_PRINT_COUNT,
	   @top_count = TOP_COUNT, @top_reject_count = TOP_REJECT_COUNT, @out_count = OUT_COUNT, @real_out_count = REAL_OUT_COUNT, @non_out_count = NON_OUT_COUNT,
	   @packing_count = PACKING_COUNT, @packing_reject_count = PACKING_REJECT_COUNT, @order_cancel_count = ORDER_CANCEL_COUNT  from inserted
UPDATE [ECSTracking].[dbo].[h_daily_count] set ORDER_COUNT = @order_count, CASE_ERECT_COUNT = @case_erect_count, CASE_ERECT_REJECT_COUNT = @case_erect_reject_count,
									WEIGHT_COUNT = 	@weight_count, 	WEIGHT_REJECT_COUNT = @weight_reject_count, SMART_PRINT_COUNT = @smart_print_count, NORMAL_PRINT_COUNT = @normal_print_count,
									TOP_COUNT = @top_count, TOP_REJECT_COUNT = @top_reject_count, OUT_COUNT = @out_count, REAL_OUT_COUNT = @real_out_count, NON_OUT_COUNT = @non_out_count,
									PACKING_COUNT = @packing_count, PACKING_REJECT_COUNT = @packing_reject_count, ORDER_CANCEL_COUNT = @order_cancel_count
where DATE = @date
GO

ALTER TABLE [dbo].[h_daily_count] ENABLE TRIGGER [h_daily_count_update_trigger]
GO


h_hourly_count_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_hourly_count_trigger]    Script Date: 2023-01-20 오전 11:47:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE TRIGGER [dbo].[h_hourly_count_trigger]
	ON [dbo].[h_hourly_count]
	AFTER INSERT
AS
BEGIN
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_hourly_count](DATE, HOUR, ORDER_COUNT, CASE_ERECT1_COUNT, CASE_ERECT2_COUNT, CASE_ERECT3_COUNT, CASE_ERECT_REJECT_COUNT, 
						WEIGHT1_COUNT, WEIGHT2_COUNT, WEIGHT_REJECT_COUNT, SMART_PRINT_COUNT, NORMAL_PRINT_COUNT, TOP_COUNT, TOP_REJECT_COUNT, OUT_COUNT, REAL_OUT_COUNT, 
						PACKING_COUNT, PACKING_REJECT_COUNT, ORDER_CANCEL_COUNT)
	SELECT
		TR.DATE,
		TR.HOUR,
		TR.ORDER_COUNT,
		TR.CASE_ERECT1_COUNT,
		TR.CASE_ERECT2_COUNT,
		TR.CASE_ERECT3_COUNT,
		TR.CASE_ERECT_REJECT_COUNT,
		TR.WEIGHT1_COUNT,
		TR.WEIGHT2_COUNT,
		TR.WEIGHT_REJECT_COUNT,
		TR.SMART_PRINT_COUNT,
		TR.NORMAL_PRINT_COUNT,
		TR.TOP_COUNT,
		TR.TOP_REJECT_COUNT,
		TR.OUT_COUNT,
		TR.REAL_OUT_COUNT,
		TR.PACKING_COUNT,
		TR.PACKING_REJECT_COUNT,
		TR.ORDER_CANCEL_COUNT
	from inserted AS TR
END


ALTER TABLE [dbo].[h_hourly_count] ENABLE TRIGGER [h_hourly_count_trigger]
GO


h_hourly_count_update_trigger(update)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_hourly_count_update_trigger]    Script Date: 2023-01-20 오전 11:48:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE TRIGGER [dbo].[h_hourly_count_update_trigger]
	ON [dbo].[h_hourly_count]
	for UPDATE
AS

declare @date datetime
declare @hour int
declare @order_count int
declare @case_erect1_count int
declare @case_erect2_count int
declare @case_erect3_count int
declare @case_erect_reject_count int
declare @weight1_count int
declare @weight2_count int
declare @weight_reject_count int
declare @smart_print_count int
declare @normal_print_count int
declare @top_count int
declare @top_reject_count int
declare @out_count int
declare @real_out_count int
declare @packing_count int
declare @packing_reject_count int
declare @order_cancel_count int

select @date = DATE, @hour = HOUR, @order_count = ORDER_COUNT, @case_erect1_count = CASE_ERECT1_COUNT, @case_erect2_count = CASE_ERECT2_COUNT, @case_erect3_count = CASE_ERECT3_COUNT,  
					 @case_erect_reject_count = CASE_ERECT_REJECT_COUNT, @weight1_count = WEIGHT1_COUNT, @weight2_count = WEIGHT2_COUNT, @weight_reject_count = WEIGHT_REJECT_COUNT,
			         @smart_print_count = SMART_PRINT_COUNT, @normal_print_count = NORMAL_PRINT_COUNT, @top_count = TOP_COUNT, @top_reject_count = TOP_REJECT_COUNT, @out_count = OUT_COUNT, 
					 @real_out_count = REAL_OUT_COUNT, @packing_count = PACKING_COUNT, @packing_reject_count = PACKING_REJECT_COUNT, @order_cancel_count = ORDER_CANCEL_COUNT  from inserted
UPDATE [ECSTracking].[dbo].[h_hourly_count] set ORDER_COUNT = @order_count, CASE_ERECT1_COUNT = @case_erect1_count, CASE_ERECT2_COUNT = @case_erect2_count, CASE_ERECT3_COUNT = @case_erect3_count, 
												CASE_ERECT_REJECT_COUNT = @case_erect_reject_count, WEIGHT1_COUNT = @weight1_count, WEIGHT2_COUNT = @weight2_count,	WEIGHT_REJECT_COUNT = @weight_reject_count, 
												SMART_PRINT_COUNT = @smart_print_count, NORMAL_PRINT_COUNT = @normal_print_count, TOP_COUNT = @top_count, TOP_REJECT_COUNT = @top_reject_count, OUT_COUNT = @out_count, 
												REAL_OUT_COUNT = @real_out_count, PACKING_COUNT = @packing_count, PACKING_REJECT_COUNT = @packing_reject_count, ORDER_CANCEL_COUNT = @order_cancel_count
where DATE = @date and HOUR = @hour
GO

ALTER TABLE [dbo].[h_hourly_count] ENABLE TRIGGER [h_hourly_count_update_trigger]
GO



h_invoice_info_trigger(insert)
USE [ECS]
GO

/****** Object:  Trigger [dbo].[h_invoice_info_trigger]    Script Date: 2023-01-20 오후 12:49:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE TRIGGER [dbo].[h_invoice_info_trigger]
	ON [dbo].[h_invoice_info]
	AFTER INSERT
AS
BEGIN
	INSERT INTO [URCIS].[ECSTracking].[dbo].[h_invoice_info](INVOICE_ID, WH_ID, CST_CD, WAVE_NO, WAVE_LINE_NO, ORD_NO, ORD_LINE_NO, BOX_NO, STORE_LOC_CD, 
												BOX_TYPE_CD, EQP_ID, CST_ORD_NO, MNL_PACKING_FLAG)
	SELECT
		TR.INVOICE_ID,
		TR.WH_ID,
		TR.CST_CD,
		TR.WAVE_NO,
		TR.WAVE_LINE_NO,
		TR.ORD_NO,
		TR.ORD_LINE_NO,
		TR.BOX_NO,
		TR.STORE_LOC_CD,
		TR.BOX_TYPE_CD,
		TR.EQP_ID,
		TR.CST_ORD_NO,
		TR.MNL_PACKING_FLAG
	from inserted AS TR

END



GO

ALTER TABLE [dbo].[h_invoice_info] ENABLE TRIGGER [h_invoice_info_trigger]
GO



-----------------------
차등 백업 전에 먼저 전체 백업을 해줘야 된다.
그다음 차등 백업을해야 먹힌다.
차등 백업
BACKUP DATABASE <데이터베이스>
TO DISK = <파일경로>
WITH DIFFERENTIAL, <추가옵션>
GO

예)
BACKUP DATABASE [test] 
TO  DISK = N'D:\Backup\test_1.bak' 
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'test-전체 데이터베이스 백업', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

자동백업 확인 방법
https://www.codingfactory.net/11985 






