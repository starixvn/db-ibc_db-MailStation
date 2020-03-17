/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" isFunction="0"></info>*/
CREATE PROCEDURE Mail_Core_UpdateFailedForLongRunningTasks
AS
/*
	Creator: Larry.Tran
	Task:  MailStation Improvement
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20200317@Larry: Update failed for long running mail tasks over 2 hours - [Redmine:126527]		
*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @FailedStatus INT = 3
	DECLARE @RunningStatus INT = 1
	
	DECLARE @RunningTask TABLE(
		TaskID INT PRIMARY KEY
	)

	INSERT INTO @RunningTask
	(
	    TaskID
	)	
	SELECT 
		mt.TaskID
	FROM dbo.MailTask AS mt
	WHERE mt.STATUS = @RunningStatus 
		AND DATEDIFF(hour, mt.ScheduledTime, GETDATE()) > 2

	INSERT INTO dbo.MailTaskLog
	(	 
	    TaskID,
	    ExceptionMessage,
	    InnerMessage,
	    StackTrace,
	    Status,
	    LogTime
	)
	SELECT
		rt.TaskID,
		'Failed for the long running task over 2 hours',
		'',
		'',
		@FailedStatus,
		GETDATE()
	FROM @RunningTask AS rt

	UPDATE mt WITH(ROWLOCK,UPDLOCK)
	SET
		mt.STATUS = @FailedStatus	
	FROM dbo.MailTask AS mt
		INNER JOIN @RunningTask AS rt ON mt.TaskID = rt.TaskID
END