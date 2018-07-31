
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetConfig    Script Date: 2018-07-30 06:19:34 AM ******/

CREATE PROCEDURE [dbo].[MailRecorder_GetConfig]		
	@AppID int,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : select mail configuration
DB: bodb_Maintenance

Revisions:
	- 9/20/2012 Ricky: Updated for new maintenance site
	- 7/29/2013 Ricky: Get Mail from
	- 09/09/2013 Edward : Updated for select column IsEncrypt
*/
SET NOCOUNT ON
BEGIN
	SELECT mc.AppID
		,mc.AppName
		,mc.Description
		,mc.MailFrom
		,mc.IsEncrypt
		,ms.SettingID
		,ms.SettingName
		,ms.IsAuth
		,ms.Username
		,ms.Password
		,ms.Server
		,ms.Port
	FROM dbo.Mail_Config as mc WITH(NOLOCK)
		LEFT JOIN Mail_Setting as ms WITH(NOLOCK)
			ON mc.SettingID = ms.SettingID
	WHERE mc.AppID = @AppID 
END

/****** Object:  StoredProcedure [dbo].[MailRecorder_InsRecord]    Script Date: 9/9/2013 1:38:26 PM ******/
SET ANSI_NULLS ON



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetConfig] TO [bodbAdminNet]
GO 
