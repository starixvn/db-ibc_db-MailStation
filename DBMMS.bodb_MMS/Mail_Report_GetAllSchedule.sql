/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/
CREATE PROCEDURE [dbo].[Mail_Report_GetAllSchedule]
	@MailName VARCHAR(500) = '',
	@SiteID INT = -1
AS
/*
	Creator: Phillip.Truong
	Task:  Get Mail List
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20180925@Helen: DB052.bodb_NAP Migration to DBCust - [Redmine:100493]
*/
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
		INNER JOIN DBPOL.NAP_UserControl.dbo.NAP_Sites s WITH (NOLOCK) ON m.SiteId = s.SiteId)
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
GRANT EXECUTE ON [dbo].[Mail_Report_GetAllSchedule] TO [bodbAdminNet]
GO 
