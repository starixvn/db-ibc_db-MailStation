/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[MailRecorder_InsRecord]	
	@AppID			INT,
	@FuncID			INT,
	@MailTo			NVARCHAR(MAX),	
	@Title			NVARCHAR(250)	= '',
	@Subject		NVARCHAR(250),
	@Body			NTEXT,
	@MailCc			NVARCHAR(MAX)	= '',
	@MailBcc		NVARCHAR(MAX)	= '',
	@MailDate		DATETIME,	
	@Attachments	NVARCHAR(250),
	@IsEncrypt		BIT				= 0,
	@MailID			INT				= 0		OUTPUT,
	@ErrCode		INT				= 0		OUTPUT,
	@ErrMsg			NVARCHAR(200)	= ''	OUTPUT
	
AS
/*
	Created: 09/29/2011@Bobby
	Task : Insert new mail record
	DB: DB06.bodb_Maintenance
	Revision:
		- 20130904@Edward : Add parameter @IsEncrypt, and refacter code	
		- 20210308@Larry: Modify max length of MailCc & MailBcc [Redmine: 151318]
		- 20230228@Robert: Modify max length of Mail TO, MailCc & MailBcc [Redmine: 184390]
	Param's Explanation:

*/
SET NOCOUNT ON
IF @AppID > 0

BEGIN
	DECLARE @tempIsEncrypt BIT
	SET @tempIsEncrypt = 0
	
	SELECT @tempIsEncrypt = IsEncrypt 
	FROM dbo.Mail_Config WITH (NOLOCK)
	WHERE AppID = @AppID
	
	SELECT @IsEncrypt = CASE WHEN @tempIsEncrypt = 1 THEN 1 ELSE @IsEncrypt END					

	INSERT INTO dbo.Mail_Record(
		AppID
		,FuncID
		,MailTo
		,Title
		,Subject
		,Body
		,MailCc
		,MailBcc
		,MailDate
		,Attachments
		,IsEncrypt)
	VALUES (
		@AppID
		,@FuncID
		,@MailTo
		,N'' + @Title + ''
		,N'' + @Subject + ''
		,@Body
		,N'' + @MailCc + ''
		,N'' + @MailBcc + ''
		,@MailDate
		,N'' + @Attachments + ''
		,@IsEncrypt)

	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when inserting mail record ;', @ErrCode = 101			
		RETURN
	END
	
	SELECT @MailID = @@IDENTITY
END

GO
