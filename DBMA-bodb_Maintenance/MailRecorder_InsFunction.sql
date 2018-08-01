
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_InsFunction    Script Date: 2018-07-30 06:19:38 AM ******/






CREATE PROCEDURE [dbo].[MailRecorder_InsFunction]		
	@AppID int,	
	@FuncName nvarchar(250),	
	@SettingID int,	
	@FuncID int =0 output,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : Insert new mail function
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
IF @FuncID > 0
BEGIN
	IF EXISTS (SELECT * FROM dbo.Mail_Function WHERE AppID=@AppID AND FuncID=@FuncID)
	BEGIN
		UPDATE dbo.Mail_Function
		SET [FuncName]=N''+@FuncName+'',
			[SettingID]=@SettingID
		WHERE AppID=@AppID AND FuncID=@FuncID
		IF @@Error <> 0
		BEGIN			
			SELECT @ErrMsg = 'Error! Error when updating mail function;', @ErrCode = 101;
			RETURN
		END
	END
	ELSE
	BEGIN
		SELECT @ErrMsg = 'Error! This function ' + CONVERT(nvarchar, @FuncID) + ' does not exist;', @ErrCode = 101
		RETURN
	END
END
ELSE 
BEGIN
	INSERT INTO dbo.Mail_Function([AppID], [FuncName], [SettingID])
	VALUES (@AppID, N''+@FuncName+'', @SettingID)

	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when inserting mail function;', @ErrCode = 101			
		RETURN
	END
	SELECT @FuncID = @@IDENTITY
END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_InsFunction] TO [bodbAdminNet]
GO 
