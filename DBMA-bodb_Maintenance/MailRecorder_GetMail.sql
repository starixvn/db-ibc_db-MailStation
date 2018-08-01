
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetMail    Script Date: 2018-07-30 06:19:40 AM ******/

CREATE PROCEDURE [dbo].[MailRecorder_GetMail]		
	@MailID int,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : select mail configuration
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
BEGIN
	with MailDataFunction as (select mp.[MailID], mp.AppID, mp.[MailTo],mp.[Title], mp.[Subject], mp.Body, mp.[MailCc], mp.[MailBcc], mp.[MailDate], mp.[Attachments],mp.[CountSend],mp.[SentSuccess],mp.[SentFail], mp.[MailUpdatedDate],mp.IsEncrypt,mf.[FuncID], mf.FuncName 
		from Mail_Record as mp WITH (NOLOCK)
		LEFT JOIN Mail_Function as mf on mp.FuncID = mf.FuncID
		WHERE mp.MailID = @MailID),

		MailDataFunctionConfig as (select mp.[MailID], mp.AppID, mp.[MailTo],mp.[Title], mp.[Subject],mp.Body, mp.[MailCc], mp.[MailBcc], mp.[MailDate], mp.[Attachments],mp.[CountSend],mp.[SentSuccess],mp.[SentFail], mp.[MailUpdatedDate],mp.IsEncrypt,mp.[FuncID], mp.FuncName, mc.AppName, mc.SettingID
		from MailDataFunction as mp WITH (NOLOCK)
		Left JOIN Mail_Config as mc ON mc.AppID = mp.AppID)
		
		select mp.[MailID], mp.AppID, mp.[MailTo],mp.[Title], mp.[Subject], mp.Body, mp.[MailCc], mp.[MailBcc], mp.[MailDate], mp.[Attachments],mp.[CountSend],mp.[SentSuccess],mp.[SentFail], mp.[MailUpdatedDate],mp.IsEncrypt,mp.[FuncID], mp.FuncName, mp.AppName, mp.SettingID, ms.SettingName, ms.IsAuth, ms.Username, ms.Password, ms.Server, ms.Port
		from MailDataFunctionConfig as mp WITH (NOLOCK)
		Left JOIN Mail_Setting as ms ON ms.SettingID = mp.SettingID
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetMail] TO [bodbAdminNet]
GO 
