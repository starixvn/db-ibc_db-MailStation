
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_GetListSetting    Script Date: 2018-07-30 06:19:38 AM ******/



CREATE PROCEDURE [dbo].[MailRecorder_GetListSetting]		
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
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_GetListSetting] TO [bodbAdminNet]
GO 
