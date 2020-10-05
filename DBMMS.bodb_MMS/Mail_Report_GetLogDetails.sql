/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Mail_Report_GetLogDetails]
	@TaskID int
AS
/*
	Creator: Phillip.Truong
	Task:  Get Mail Log Details
	DB: DBMMS/bodb_MMS
	
	Revision:		
		- 20200515@Larry: Order by LogTime - [Redmine:126527]
		- 20201005@Larry: Order by LogID - [Redmine:142955]
*/
BEGIN
	SET NOCOUNT ON

	SELECT 
		LogID,
		TaskID,
		ExceptionMessage,
		InnerMessage,
		StackTrace,
		[Status],
		LogTime
	FROM
		dbo.MailTaskLog
	WHERE
		TaskID = @TaskID
	ORDER BY LogTime,
		LogID
END
GO