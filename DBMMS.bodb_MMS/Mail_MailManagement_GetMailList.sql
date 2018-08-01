
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_GetMailList    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-18
-- Description:	Get Mail List
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_GetMailList]
	@Mailname varchar(500) = '',
	@IsActive int = -1,
	@MailGroupID varchar(500) = '',
	@SiteID int = -1,
	@TriggerType int = -1,
	@Emails varchar(500) = ''
AS
BEGIN
	SET NOCOUNT ON
	SET @MailName = ISNULL(@MailName, '')
	SET @Emails = ISNULL(@Emails, '')
	SET @MailGroupID = ISNULL(@MailGroupID, '')
	DECLARE @MailGroupIDTempTable TABLE (MailGroupID int)
	DECLARE @MailIDTempTable TABLE (MailID int)
	DECLARE @EmailFilter varchar(500),
			@SemiColonIndex int,
			@EmailID int,
			@MailGroupFilter varchar(500),
			@OriginalEmails varchar(500)
			
	SET @OriginalEmails = @Emails
	WHILE LEN (@MailGroupID) <> 0
	BEGIN
		
		SET @SemiColonIndex = CHARINDEX(',', @MailGroupID)
		IF @SemiColonIndex = 0
		BEGIN
			SET @MailGroupFilter = @MailGroupID
			SET @MailGroupID = ''
		END
		ELSE
		BEGIN
			SET @MailGroupFilter = SUBSTRING(@MailGroupID, 1, @SemiColonIndex-1)
			SET @MailGroupID = SUBSTRING(@MailGroupID, @SemiColonIndex+1, LEN(@MailGroupID))
		END
		
		INSERT INTO @MailGroupIDTempTable VALUES(RTRIM(LTRIM(@MailGroupFilter)))
	END
	
	IF @Emails = ''
	BEGIN
		INSERT INTO @MailIDTempTable
		SELECT DISTINCT(MailID)
		FROM Email e INNER JOIN Mail_Email me ON e.EmailID = me.EmailID
	END
	ELSE
	BEGIN
		WHILE LEN (@Emails) <> 0
		BEGIN
			
			SET @SemiColonIndex = CHARINDEX(',', @Emails)
			IF @SemiColonIndex = 0
			BEGIN
				SET @EmailFilter = @Emails
				SET @Emails = ''
			END
			ELSE
			BEGIN
				SET @EmailFilter = SUBSTRING(@Emails, 1, @SemiColonIndex-1)
				SET @Emails = SUBSTRING(@Emails, @SemiColonIndex+1, LEN(@Emails))
			END
			
			INSERT INTO @MailIDTempTable
			SELECT DISTINCT(MailID)
			FROM Email e INNER JOIN Mail_Email me ON e.EmailID = me.EmailID
			WHERE e.EmailAddress LIKE '%' + RTRIM(LTRIM(@EmailFilter)) + '%'
		END
	END;
	
	WITH tbl as (
		SELECT m.MailID
			, m.MailName
			, m.MailGroupID
			, mg.MailGroupName
			, m.SiteId
			, s.SiteName
			, m.TriggerType
			, m.LastSent
			, m.IsActive
			, mem.EmailID
			, em.EmailAddress
			, mem.[Type]
			, m.LastActive
		FROM (((Mail m WITH (NOLOCK) INNER JOIN MailGroup mg WITH (NOLOCK) ON m.MailGroupID = mg.MailGroupID)
			INNER JOIN DBNAP.bodb_NAP.dbo.Sites s WITH (NOLOCK) ON m.SiteId = s.SiteId)
			LEFT OUTER JOIN Mail_Email mem WITH (NOLOCK) ON m.MailID = mem.MailID)
			LEFT OUTER JOIN Email em WITH (NOLOCK) ON mem.EmailID = em.EmailID
		WHERE
			m.MailName LIKE '%' + @MailName + '%'
			AND (@IsActive is null OR @IsActive = -1 OR m.IsActive = @IsActive)
			--AND (@MailGroupID is null OR @MailGroupID = -1 OR m.MailGroupID = @MailGroupID)
			AND (NOT EXISTS(SELECT TOP 1 * FROM @MailGroupIDTempTable) OR m.MailGroupID IN (SELECT MailGroupID FROM @MailGroupIDTempTable))
			AND (@SiteID IS NULL OR @SiteID = -1 OR m.SiteID = @SiteID)
			AND (@TriggerType IS NULL OR @TriggerType = -1 OR m.TriggerType = @TriggerType)
			AND (@OriginalEmails = '' OR m.MailID IN (SELECT MailID FROM @MailIDTempTable))
			--AND ((NOT EXISTS(SELECT TOP 1 * FROM @MailIDTempTable) AND @OriginalEmails = '') OR m.MailID IN (SELECT MailID FROM @MailIDTempTable))
	)
	
	SELECT MailID, 
			MailName, 
			MailGroupID, 
			MailGroupName, 
			SiteId, 
			SiteName, 
			TriggerType, 
			[0] MailTo, 
			[1] MailCc, 
			[2] MailBcc, 
			LastSent, 
			IsActive,
			LastActive
	FROM (
	SELECT  T1.MailID ,
			T1.MailName ,
			T1.[Type],
			T1.MailGroupID,
			T1.MailGroupName,
			T1.SiteId,
			T1.SiteName,
			T1.TriggerType,
			T1.LastSent,
			T1.IsActive,
			T1.LastActive,
			STUFF(( SELECT  '; ' + T2.EmailAddress
					FROM    tbl T2
					WHERE   T1.MailID = T2.MailID AND T1.[Type] = T2.[Type]
				  FOR XML PATH('')
				  ), 1, 2, '') AS EmailAddress
	FROM    tbl T1
	GROUP BY T1.MailID , T1.MailName, T1.[Type],T1.MailGroupID,
			T1.MailGroupName,
			T1.SiteId,
			T1.SiteName,
			T1.TriggerType,
			T1.LastSent,
			T1.IsActive,
			T1.LastActive
	) as SourceTable
	PIVOT (MAX(EmailAddress) FOR [Type] IN ([0], [1], [2])) PivotTable
	
END

-- Sample Test
--SELECT m.MailID Id
--	, m.MailName MailName
--	, m.MailGroupID
--	, mg.MailGroupName
--	, m.SiteId
--	, s.SiteName
--	, m.TriggerType
--	, m.LastSent
--	, m.IsActive
--	, mem.EmailID
--	, em.EmailAddress
--	, mem.[Type]
--FROM (((Mail m WITH (NOLOCK) INNER JOIN MailGroup mg WITH (NOLOCK) ON m.MailGroupID = mg.MailGroupID)
--	INNER JOIN bodb_NAP.dbo.Sites s WITH (NOLOCK) ON m.SiteId = s.SiteId)
--	LEFT OUTER JOIN Mail_Email mem WITH (NOLOCK) ON m.MailID = mem.MailID)
--	LEFT OUTER JOIN Email em WITH (NOLOCK) ON mem.EmailID = em.EmailID
--go


--WITH tbl as (SELECT m.MailID Id
--	, m.MailName MailName
--	, m.MailGroupID
--	, mg.MailGroupName
--	, m.SiteId
--	, s.SiteName
--	, m.TriggerType
--	, m.LastSent
--	, m.IsActive
--	, mem.EmailID
--	, em.EmailAddress
--	, mem.[Type]
--FROM (((Mail m WITH (NOLOCK) INNER JOIN MailGroup mg WITH (NOLOCK) ON m.MailGroupID = mg.MailGroupID)
--	INNER JOIN bodb_NAP.dbo.Sites s WITH (NOLOCK) ON m.SiteId = s.SiteId)
--	LEFT OUTER JOIN Mail_Email mem WITH (NOLOCK) ON m.MailID = mem.MailID)
--	LEFT OUTER JOIN Email em WITH (NOLOCK) ON mem.EmailID = em.EmailID
--)

--SELECT Id, MailName, MailGroupID, MailGroupName, SiteId, SiteName, TriggerType, [0] MailTo, [1] MailCc, [2] MailBcc, LastSent, IsActive
--FROM (
--SELECT  T1.Id ,
--        T1.MailName ,
--        T1.[Type],
--        T1.MailGroupID,
--        T1.MailGroupName,
--        T1.SiteId,
--        T1.SiteName,
--        T1.TriggerType,
--        T1.LastSent,
--        T1.IsActive,
--        STUFF(( SELECT  '; ' + T2.EmailAddress
--                FROM    tbl T2
--                WHERE   T1.Id = T2.Id AND T1.[Type] = T2.[Type]
--              FOR XML PATH('')
--              ), 1, 2, '') AS EmailAddress
--FROM    tbl T1
--GROUP BY T1.Id , T1.MailName, T1.[Type],T1.MailGroupID,
--        T1.MailGroupName,
--        T1.SiteId,
--        T1.SiteName,
--        T1.TriggerType,
--        T1.LastSent,
--        T1.IsActive
--) as SourceTable
--PIVOT (MAX(EmailAddress) FOR [Type] IN ([0], [1], [2])) PivotTable

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_GetMailList] TO [bodbAdminNet]
GO 
