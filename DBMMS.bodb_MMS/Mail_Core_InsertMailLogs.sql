/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Mail_Core_InsertMailLogs]
	@TaskID int,
	@ExceptionMessage varchar(2000) = '',
	@InnerMessage varchar(1000) = '',
	@StackTrace varchar(1000) = '',
	@Status int = 0,
	@LogTime varchar(50) = '',
	@ErrCode int = 0 output,
	@ErrMsg nvarchar(1000) = '' output
AS
/*
	Creator: Phillip.Truong
	Task:  Insert Mail Log
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20200309@Larry: MailStation improvement (modify parameter @ExceptionMessage, @InnerMessage) - [Redmine:126527]		
*/
BEGIN
	SET NOCOUNT ON
	INSERT INTO MailTaskLog VALUES(
		@TaskID,
		@ExceptionMessage,
		@InnerMessage,
		@StackTrace,
		@Status,
		@LogTime
	)
	
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 24
		SET @ErrMsg = 'Insert to Mail Task Log failed.'
		RETURN;
	END
END