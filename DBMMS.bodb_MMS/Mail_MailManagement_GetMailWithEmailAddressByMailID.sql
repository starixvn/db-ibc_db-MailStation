
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_GetMailWithEmailAddressByMailID    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-18
-- Description:	Get Mail By ID with full email address
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_GetMailWithEmailAddressByMailID]
	@MailID int = -1
AS
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
			, CAST(mem.EmailID AS varchar(1000)) EmailID
			, em.EmailAddress
			, ms.CronExpression
			, ms.StartOn
			, ms.EndOn
			, ms.Attempt
			, ms.Interval
			, mem.[Type]
		FROM (((Mail m WITH (NOLOCK) LEFT OUTER JOIN Mail_Email mem WITH (NOLOCK) ON m.MailID = mem.MailID)
			INNER JOIN Email em WITH (NOLOCK) ON mem.EmailID = em.EmailID)
			INNER JOIN MailRecipient mr WITH (NOLOCK) ON mr.RecipientID = em.RecipientID)
			LEFT OUTER JOIN dbo.MailSchedule ms WITH (NOLOCK) ON ms.ScheduleID = m.ScheduleID
		WHERE
			m.MailID = @MailID AND mr.IsActive = 1
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
		, CronExpression
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
		, STUFF(( SELECT  ';' + T2.EmailAddress
				FROM    tbl T2
				WHERE   T1.MailId = T2.MailId AND T1.[Type] = T2.[Type]
			  FOR XML PATH('')
			  ), 1, 1, '') AS EmailAddress
		, T1.CronExpression
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
		, T1.CronExpression
		, T1.StartOn
		, T1.EndOn
		, T1.Attempt
		, T1.Interval
	) as SourceTable
	PIVOT (MAX(EmailAddress) FOR [Type] IN ([0], [1], [2])) PivotTable

END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_GetMailWithEmailAddressByMailID] TO [bodbAdminNet]
GO 
