/*<info serverAlias="DBMMS-bodb_MMS" executers="wsv_nap" viewers="" isFunction="0" isNested="0"></info>*/
CREATE PROCEDURE [dbo].[Mail_Report_GetAllSchedule]
	@MailName VARCHAR(500) = '',
	@SiteID INT = -1,
	@TransformJson VARBINARY(MAX)
AS
/*
	Creator: Phillip.Truong
	Task:  Get Mail List
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20180925@Helen: DB052.bodb_NAP Migration to DBCust - [Redmine:100493]
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
		INNER JOIN #tmpNAP_Sites s WITH (NOLOCK) ON m.SiteId = s.SiteId)
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

    DROP TABLE #tmpNAP_Sites
END
GO 


GRANT EXECUTE ON [dbo].[Mail_Report_GetAllSchedule] TO [wsv_nap]
GO 
