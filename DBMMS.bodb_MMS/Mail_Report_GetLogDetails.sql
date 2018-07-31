
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Report_GetLogDetails    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-14
-- Description:	Get Mail Log Details
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Report_GetLogDetails]
	@TaskID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT 
		LogID,
		TaskID,
		ExceptionMessage,
		InnerMessage,
		StackTrace,
		[Status],
		LogTime
	FROM
		dbo.MailTaskLog
	WHERE
		TaskID = @TaskID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Report_GetLogDetails] TO [bodbAdminNet]
GO 
