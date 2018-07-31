
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetListConfig    Script Date: 2018-07-30 06:19:32 AM ******/



CREATE PROCEDURE [dbo].[MailRecorder_GetListConfig]	
	@Ip nvarchar(20) = '',	
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : select mail config
DB: bodb_Maintenance
Original:
	
Revisions:
	- 9/20/2012 Ricky: Updated for new maintenance site
	- 7/29/2013 Ricky: Add Mail From
*/
set @Ip = '%' + @Ip + '%'
SET NOCOUNT ON
BEGIN
	SELECT mc.AppID, mc.AppName, mc.Description, mc.MailFrom, mc.IsEncrypt, ms.SettingID, ms.SettingName, ms.IsAuth, ms.Username, ms.Password, ms.Server, ms.Port
	FROM [dbo].[Mail_Config] as mc
	LEFT JOIN Mail_Setting as ms WITH(NOLOCK)
	ON mc.SettingID = ms.SettingID
	Where ms.Server like @Ip
END

/****** Object:  StoredProcedure [dbo].[MailRecorder_InsConfig]    Script Date: 9/9/2013 2:03:52 PM ******/
SET ANSI_NULLS ON



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetListConfig] TO [bodbAdminNet]
GO 
