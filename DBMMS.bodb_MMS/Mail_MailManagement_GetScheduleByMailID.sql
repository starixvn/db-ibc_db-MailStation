
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_GetScheduleByMailID    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-20
-- Description:	Get Schedule By Mail ID
-- Revision:
--    - 2015-05-21 - Phillip : Add Trigger Type on result table.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_GetScheduleByMailID]
	@MailId int
AS
BEGIN
	SET NOCOUNT ON
	SELECT m.MailID, ms.ScheduleID, m.SiteId, m.MailName, m.TriggerType, ms.CronExpression, ms.StartOn, ms.EndOn, m.IsActive, ms.Attempt, ms.Interval
	FROM dbo.Mail m WITH(NOLOCK) LEFT OUTER JOIN dbo.MailSchedule ms WITH (NOLOCK) ON ms.ScheduleID = m.ScheduleID
	WHERE m.MailID = @MailId
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_GetScheduleByMailID] TO [bodbAdminNet]
GO 
