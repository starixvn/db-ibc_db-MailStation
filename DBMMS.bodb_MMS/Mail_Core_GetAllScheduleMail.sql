
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_GetAllScheduleMail    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2015-08-25
-- Description:	Get All Schedule Mail.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_GetAllScheduleMail]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	m.MailID,
			m.MailName,
			ms.CronExpression,
			m.LastActive
	FROM	dbo.Mail m
			INNER JOIN dbo.MailSchedule ms
			ON m.ScheduleID = ms.ScheduleID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Core_GetAllScheduleMail] TO [bodbAdminNet]
GO 
