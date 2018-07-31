
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Report_GetMailTaskByID    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Get Mail's Tasks By ID.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Report_GetMailTaskByID]
	@MailTaskID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT	
		TaskID as MailTaskID
		, MailID
		, SiteID
		, ScheduledTime
		, LastSent
		, [Status]
		, Attempt
		, MSiteMailID
	FROM
		dbo.MailTask WITH (NOLOCK)
	WHERE
		TaskID = @MailTaskID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Report_GetMailTaskByID] TO [bodbAdminNet]
GO 
