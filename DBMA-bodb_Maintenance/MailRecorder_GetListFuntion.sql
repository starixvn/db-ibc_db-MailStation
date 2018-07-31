
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetListFuntion    Script Date: 2018-07-30 06:19:33 AM ******/

CREATE PROCEDURE [dbo].[MailRecorder_GetListFuntion]		
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/21/2012 @Ricky
Task : select mail function
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
BEGIN
	with MailFunctionTable as( SELECT tt.FuncID, tt.FuncName, tt.AppID, tt.AppName, tt.Description, tt.SettingID, ms.SettingName, ms.IsAuth, ms.Username, ms.Password, ms.Server, ms.Port, tt.AppSettingID
	from
		(SELECT mf.FuncID, mf.FuncName, mf.AppID, mc.AppName, mc.Description, mf.SettingID, mc.SettingID as AppSettingID
		FROM Mail_Function as mf
		LEFT JOIN Mail_Config as mc WITH (NOLOCK)
		ON mf.AppID = mc.AppID) as tt
	left JOIN Mail_Setting as ms WITH (NOLOCK)
	ON tt.SettingID = ms.SettingID )
	
	SELECT mf.FuncID, mf.FuncName, mf.AppID, mf.AppName, mf.Description, mf.SettingID, mf.SettingName, mf.IsAuth, mf.Username, mf.Password, mf.Server, mf.Port, ms.SettingID as AppSettingId, ms.SettingName as AppSettingName, ms.Server as AppSettingServer, ms.Port as AppSettingPort
	from MailFunctionTable as mf with(NOLOCK)
	Left JOIN Mail_Setting as ms on mf.AppSettingID = ms.SettingID
END




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetListFuntion] TO [bodbAdminNet]
GO 
