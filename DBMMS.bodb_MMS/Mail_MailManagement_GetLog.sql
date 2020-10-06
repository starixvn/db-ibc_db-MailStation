/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" isFunction="0"></info>*/
CREATE PROCEDURE Mail_MailManagement_GetLog
	@MailID int
AS
/*
	Creator: Larry.Tran
	Task: Get Log
	DB: DBMMS/bodb_MMS
	
	Revision:		
		- 20201005@Larry: Get the top 15 log items - [Redmine:142955]
*/
BEGIN	
	SET NOCOUNT ON;

    SELECT TOP 15
		ml.MailLogId, 
		ml.[Message], 
		ml.LogTime, 
		ml.MailID
	FROM dbo.MailLog AS ml WITH(NOLOCK)
	WHERE ml.MailID = @MailID
	ORDER BY ml.LogTime DESC
END
GO
