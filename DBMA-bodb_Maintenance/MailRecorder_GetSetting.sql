
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetSetting    Script Date: 2018-07-30 06:19:37 AM ******/



CREATE PROCEDURE [dbo].[MailRecorder_GetSetting]		
	@SettingID int,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : select mail setting
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
BEGIN
	SELECT * FROM [dbo].[Mail_Setting] WITH (NOLOCK)
	WHERE SettingID=@SettingID
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetSetting] TO [bodbAdminNet]
GO 
