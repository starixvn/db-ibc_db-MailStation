/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/
CREATE PROCEDURE [dbo].[Mail_MailManagement_GetMailByID]
	@MailID int = -1
AS
/*	
	Creator: Phillip.Truong
	Task:  Get Mail By ID
	DB: DBMMS/bodb_MMS
	
	Revisions: 		
		 - 20200423@Larry: Get mail owners - [Redmine:126527]
*/
BEGIN
	SET NOCOUNT ON;
	WITH tbl as (
		SELECT m.MailID
			, m.MailName
			, m.MailGroupID
			, m.SiteId
			, m.MailFrom
			, m.TriggerType
			, m.LastSent
			, m.IsActive
			, m.[Description]
			, m.Owners
			, CAST(mem.EmailID AS varchar(1000)) EmailID
			, em.EmailAddress
			, ms.RepeatType
			, ms.CronExpression
			, ms.StartOn
			, ms.EndOn
			, ms.Attempt
			, ms.Interval
			, mem.[Type]
		FROM ((Mail m WITH (NOLOCK) LEFT OUTER JOIN Mail_Email mem WITH (NOLOCK) ON m.MailID = mem.MailID)
			LEFT OUTER JOIN Email em WITH (NOLOCK) ON mem.EmailID = em.EmailID)
			LEFT OUTER JOIN dbo.MailSchedule ms WITH (NOLOCK) ON ms.ScheduleID = m.ScheduleID
		WHERE
			m.MailID = @MailID
	)
	
	SELECT 
		MailId
		, MailName
		, MailGroupID
		, SiteId
		, MailFrom
		, TriggerType
		, [0] MailTo
		, [1] MailCc
		, [2] MailBcc
		, LastSent
		, IsActive
		, [Description]
		, Owners
		, CronExpression
		, RepeatType
		, StartOn
		, EndOn
		, Attempt
		, Interval
	FROM (
	SELECT  
		T1.MailId
		, T1.MailName
		, T1.[Type]
		, T1.MailGroupID
		, T1.SiteId
		, T1.MailFrom
		, T1.TriggerType
		, T1.LastSent
		, T1.IsActive
		, T1.[Description]
		, T1.Owners
		, STUFF(( SELECT  ',' + T2.EmailID
				FROM    tbl T2
				WHERE   T1.MailId = T2.MailId AND T1.[Type] = T2.[Type]
			  FOR XML PATH('')
			  ), 1, 1, '') AS EmailID
		, T1.CronExpression
		, T1.RepeatType
		, T1.StartOn
		, T1.EndOn
		, T1.Attempt
		, T1.Interval
	FROM    tbl T1
	GROUP BY 
		T1.MailId 
		, T1.MailName
		, T1.[Type]
		, T1.MailGroupID
		, T1.SiteId
		, T1.MailFrom
		, T1.TriggerType
		, T1.LastSent
		, T1.IsActive
		, T1.[Description]
		, T1.Owners
		, T1.CronExpression
		, T1.RepeatType
		, T1.StartOn
		, T1.EndOn
		, T1.Attempt
		, T1.Interval
	) as SourceTable
	PIVOT (MAX(EmailID) FOR [Type] IN ([0], [1], [2])) PivotTable

END
GO