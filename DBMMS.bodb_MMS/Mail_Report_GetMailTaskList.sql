/*<info serverAlias="DBMMS-bodb_MMS" executers="wsv_nap" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Mail_Report_GetMailTaskList]
	@MailName varchar(500) = '',
	@SiteID int = -1,
	@FromDate date = null,
	@ToDate date = null,
	@Status int = -1,
	@TriggerType INT = -1
AS
/*
	Creator: Phillip.Truong
	Task:  Get Mail List
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20180925@Helen: DB052.bodb_NAP Migration to DBCust - [Redmine:100493]
		- 20200424@Larry: Add more filter @TriggerType - [Redmine:126527]
		- 20240722@Robert: Remove link server DBPOL.NAP_UserControl [Redmine:208259]
*/
BEGIN
	SET NOCOUNT ON	
	SET @MailName = ISNULL(@MailName, '')
	SELECT 
		mt.TaskId as MailTaskID,
		m.MailID, 
		m.MailName AS MailName, 
		m.TriggerType,
		m.SiteId,
		'' AS SiteName, 
		mt.ScheduledTime AS ScheduledTime, 
		mt.LastSent AS LastSent, 
		mt.[Status] AS [Status],
		mt.Attempt,
		mt.MSiteMailID,
		mt.IsUnableToRetry
	FROM (dbo.Mail m WITH (NOLOCK) INNER JOIN dbo.MailTask mt WITH (NOLOCK) ON m.MailID = mt.MailID)		
	WHERE m.MailName LIKE '%' + @MailName + '%'
		AND CAST(mt.ScheduledTime AS DATETIME) BETWEEN CAST(@FromDate AS DATETIME) AND DATEADD(second, -1, (DATEADD(day, 1, CAST(@ToDate AS DATETIME))))
		AND (@Status = -1 OR mt.[Status] = @Status)
		AND (@SiteID = -1 OR m.SiteID = @SiteID)
		AND (@TriggerType = -1 OR m.TriggerType = @TriggerType)
	ORDER BY mt.ScheduledTime DESC	
END
GO

GRANT EXECUTE ON [dbo].[Mail_Report_GetMailTaskList] TO [wsv_nap]
GO 