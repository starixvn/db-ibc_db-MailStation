
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Report_GetAllSchedule    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-14
-- Description:	Get all active schedule.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Report_GetAllSchedule]
	@MailName VARCHAR(500) = '',
	@SiteID INT = -1
AS
BEGIN
	SET NOCOUNT ON
	SET @MailName = ISNULL(@MailName, '')
	SELECT 
		ms.ScheduleID,
		ms.RepeatType,
		ms.CronExpression,
		ms.StartOn,
		ms.EndOn,
		ms.Interval,
		ms.Attempt,
		m.MailID,
		m.MailName,
		s.SiteId,
		s.SiteName,
		m.LastSent,
		MAX(mt.ScheduledTime) LastScheduledTime
	FROM ((dbo.MailSchedule ms WITH (NOLOCK) INNER JOIN dbo.Mail m WITH (NOLOCK) ON ms.ScheduleID = m.ScheduleID)
		INNER JOIN DBNAP.bodb_NAP.dbo.Sites s WITH (NOLOCK) ON m.SiteId = s.SiteId)
		LEFT OUTER JOIN dbo.MailTask mt WITH (NOLOCK) ON m.MailID = mt.MailID
	WHERE m.TriggerType = 1
		AND m.IsActive = 1
		AND m.MailName LIKE '%' + @MailName + '%'
		AND (@SiteID = -1 OR m.SiteId = @SiteID)
	GROUP BY
		ms.ScheduleID,
		ms.RepeatType,
		ms.CronExpression,
		ms.StartOn,
		ms.EndOn,
		ms.Interval,
		ms.Attempt,
		m.MailID,
		m.MailName,
		s.SiteId,
		s.SiteName,
		m.LastSent
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Report_GetAllSchedule] TO [bodbAdminNet]
GO 
