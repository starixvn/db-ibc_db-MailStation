
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_InsSetting    Script Date: 2018-07-30 06:19:31 AM ******/



CREATE PROCEDURE [dbo].[MailRecorder_InsSetting]		
	@SettingName nvarchar(100),	
	@IsAuth bit,
	@Password nvarchar(100),
	@Username nvarchar(100),
	@Server nvarchar(100),
	@Port int,	
	@SettingID int =0 output,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : Insert new mail setting
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
IF EXISTS (SELECT * FROM dbo.Mail_Setting WHERE SettingID=@SettingID)
BEGIN
	UPDATE dbo.Mail_Setting
	SET SettingName=N''+@SettingName+'',
		[IsAuth]=@IsAuth,
		[Password]=N''+@Password+'',
		[Username]=N''+@Username+'',
		[Server]=N''+@Server+'',
		[Port]=@Port	
	WHERE SettingID=@SettingID
	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when updating mail setting;', @ErrCode = 101			
		RETURN
	END
END
ELSE 
BEGIN
	INSERT INTO dbo.Mail_Setting([SettingName], [IsAuth], [Password], [Username], [Server], [Port])
	VALUES (N''+@SettingName+'', @IsAuth, N''+@Password+'', N''+@Username+'', N''+@Server+'', @Port)

	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when inserting mail setting;', @ErrCode = 101			
		RETURN
	END
	SELECT @SettingID = @@IDENTITY
END






GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_InsSetting] TO [bodbAdminNet]
GO 
