SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_InsRecord    Script Date: 2018-07-30 06:19:29 AM ******/



CREATE PROCEDURE [dbo].[MailRecorder_InsRecord]	
	@AppID			INT,
	@FuncID			INT,
	@MailTo			NVARCHAR(250),	
	@Title			NVARCHAR(250)	= '',
	@Subject		NVARCHAR(250),
	@Body			NTEXT,
	@MailCc			NVARCHAR(500)	= '',
	@MailBcc		NVARCHAR(250)	= '',
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
Original:
	20130904@Edward : Add parameter @IsEncrypt, and refacter code	
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_InsRecord] TO [bodbAdminNet]
GO 
