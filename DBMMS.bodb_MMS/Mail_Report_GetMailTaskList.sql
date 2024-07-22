/*<info serverAlias="DBMMS-bodb_MMS" executers="wsv_nap" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[Mail_Report_GetMailTaskList]
	@MailName varchar(500) = '',
	@SiteID int = -1,
	@FromDate date = null,
	@ToDate date = null,
	@Status int = -1,
	@TriggerType INT = -1,
	@TransformJson VARBINARY(MAX)
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

	CREATE TABLE #tmpNAP_Sites
    (
	   [SiteId]          [TINYINT]  NOT NULL, 
	   [SiteName]        [VARCHAR](50) NOT NULL, 
	   [Description]     [VARCHAR](200) NULL, 
	   [URL]             [VARCHAR](200) NULL, 
	   [TestURL]         [VARCHAR](200) NULL, 
	   [IsActive]        [BIT] NOT NULL, 
	   [Environment]     [VARCHAR](10) NULL, 
	   [SecretAccessKey] [VARCHAR](200) NULL, 
	   [SiteKey]         [VARCHAR](50) NULL 
	   PRIMARY KEY CLUSTERED([SiteId] ASC)
    );

   INSERT INTO #tmpNAP_Sites
   (
	  SiteId, 
	  SiteName, 
	  Description, 
	  URL, 
	  TestURL, 
	  IsActive, 
	  Environment, 
	  SecretAccessKey, 
	  SiteKey
   )
	  SELECT 
		    SiteId, 
		    SiteName, 
		    Description, 
		    URL, 
		    TestURL, 
		    IsActive, 
		    Environment, 
		    SecretAccessKey, 
		    SiteKey
	  FROM OPENJSON ( CAST( DECOMPRESS(@TransformJson) AS NVARCHAR(MAX)) ) 
	  WITH (
		 [SiteId] [TINYINT], 
		 [SiteName] [VARCHAR](50), 
		 [Description] [VARCHAR](200), 
		 [URL] [VARCHAR](200), 
		 [TestURL] [VARCHAR](200), 
		 [IsActive] [BIT], 
		 [Environment] [VARCHAR](10), 
		 [SecretAccessKey] [VARCHAR](200), 
		 [SiteKey] [VARCHAR](50)
	  );

	DECLARE @SiteName varchar(50)
	SET @MailName = ISNULL(@MailName, '')
	SELECT 
		mt.TaskId as MailTaskID,
		m.MailID, 
		m.MailName AS MailName, 
		m.TriggerType,
		m.SiteId,
		s.SiteName AS SiteName, 
		mt.ScheduledTime AS ScheduledTime, 
		mt.LastSent AS LastSent, 
		mt.[Status] AS [Status],
		mt.Attempt,
		mt.MSiteMailID,
		mt.IsUnableToRetry
	FROM (dbo.Mail m WITH (NOLOCK) INNER JOIN dbo.MailTask mt WITH (NOLOCK) ON m.MailID = mt.MailID)
		INNER JOIN #tmpNAP_Sites s on m.SiteID = s.SiteID
	WHERE m.MailName LIKE '%' + @MailName + '%'
		AND CAST(mt.ScheduledTime AS DATETIME) BETWEEN CAST(@FromDate AS DATETIME) AND DATEADD(second, -1, (DATEADD(day, 1, CAST(@ToDate AS DATETIME))))
		AND (@Status = -1 OR mt.[Status] = @Status)
		AND (@SiteID = -1 OR m.SiteID = @SiteID)
		AND (@TriggerType = -1 OR m.TriggerType = @TriggerType)
	ORDER BY mt.ScheduledTime DESC

	DROP TABLE #tmpNAP_Sites
END
GO

GRANT EXECUTE ON [dbo].[Mail_Report_GetMailTaskList] TO [wsv_nap]
GO 