
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Report_GetMailTaskList    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Get Mail's Tasks List.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Report_GetMailTaskList]
	@MailName varchar(500) = '',
	@SiteID int = -1,
	@FromDate date = null,
	@ToDate date = null,
	@Status int = -1
AS
BEGIN
	SET NOCOUNT ON
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
		INNER JOIN DBNAP.bodb_NAP.dbo.Sites s on m.SiteID = s.SiteID
	WHERE m.MailName LIKE '%' + @MailName + '%'
		AND CAST(mt.ScheduledTime AS DATETIME) BETWEEN CAST(@FromDate AS DATETIME) AND DATEADD(second, -1, (DATEADD(day, 1, CAST(@ToDate AS DATETIME))))
		AND (@Status = -1 OR mt.[Status] = @Status)
		AND (@SiteID = -1 OR m.SiteID = @SiteID)
	ORDER BY mt.ScheduledTime DESC
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Report_GetMailTaskList] TO [bodbAdminNet]
GO 
