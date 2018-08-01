
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetError    Script Date: 2018-07-30 06:19:39 AM ******/


CREATE PROCEDURE [dbo].[MailRecorder_GetError]		
	@MailID int
AS
/*
Created: 07/10/2013@Bobby
Task : select mail eror
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
BEGIN
	SELECT [ErrorID],[MailID],[AppID],[Message],[StackTrace],[SettingName],[ErrorTime]
	FROM [dbo].[Mail_Error] WITH (NOLOCK)
	WHERE MailID = @MailID
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetError] TO [bodbAdminNet]
GO 
