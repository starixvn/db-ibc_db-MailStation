
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_InsConfig    Script Date: 2018-07-30 06:19:34 AM ******/







CREATE PROCEDURE [dbo].[MailRecorder_InsConfig]		
	@AppName nvarchar(100),	
	@Description nvarchar(250) = '',
	@MailFrom nvarchar(100) = '',
	@SettingID int,	
	@IsEncrypt bit = 0,
	@AppID int =0 output,	
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : Insert new mail configuration
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

Revisions:
	- 7/29/2013 Ricky: Add Mail from
*/
SET NOCOUNT ON
IF EXISTS (SELECT * FROM dbo.Mail_Config WHERE AppID=@AppID)
BEGIN
	UPDATE dbo.Mail_Config
	SET AppName=N''+@AppName+'',
		[Description]=N''+@Description+'',
		[SettingID]=@SettingID,
		[MailFrom]=@MailFrom,
		[IsEncrypt]=@IsEncrypt
	WHERE AppID=@AppID
	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when updating mail configuration;', @ErrCode = 101			
		RETURN
	END
END
ELSE 
BEGIN
	INSERT INTO dbo.Mail_Config([AppName], [Description], [SettingID], [MailFrom],IsEncrypt)
	VALUES (N''+@AppName+'', N''+@Description+'', @SettingID, N''+@MailFrom+'',@IsEncrypt)

	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when inserting mail configuration;', @ErrCode = 101			
		RETURN
	END
	SELECT @AppID = @@IDENTITY
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_InsConfig] TO [bodbAdminNet]
GO 
