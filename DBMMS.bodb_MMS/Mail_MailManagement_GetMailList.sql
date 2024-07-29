/*<info serverAlias="DBMMS-bodb_MMS" executers="wsv_nap" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE dbo.Mail_MailManagement_GetMailList
	@Mailname       VARCHAR(500) = ''
   , @IsActive       INT          = -1
   , @MailGroupID    VARCHAR(500) = ''
   , @SiteID         INT          = -1
   , @TriggerType    INT          = -1
   , @Emails         VARCHAR(500) = ''
AS
/*	
	Creator: Phillip.Truong
	Task:  Get Mail List
	DB: DBMMS/bodb_MMS
	
	Revisions: 
		 - 20141118@Phillip: Initialize Get Mail List
		 - 20180729@Robert: Tidy up the Mail Station [#99119]
		 - 20180925@Helen: DB052.bodb_NAP Migration to DBCust - [Redmine:100493]
		 - 20200423@Larry: Get mail owners - [Redmine:126527]
		 - 20240722@Robert: Remove link server DBPOL.NAP_UserControl [Redmine:208259]
*/

BEGIN
    SET NOCOUNT ON;
    SET @MailName = ISNULL(@MailName, '');
    SET @Emails = ISNULL(@Emails, '');
    SET @MailGroupID = ISNULL(@MailGroupID, '');
    DECLARE @MailGroupIDTempTable TABLE(
	    MailGroupID    INT);
    DECLARE @MailIDTempTable TABLE(
	    MailID    INT);
    DECLARE @EmailFilter        VARCHAR(500)
		, @SemiColonIndex     INT
		, @EmailID            INT
		, @MailGroupFilter    VARCHAR(500)
		, @OriginalEmails     VARCHAR(500);

    SET @OriginalEmails = @Emails;
    WHILE LEN(@MailGroupID) <> 0
	   BEGIN

		  SET @SemiColonIndex = CHARINDEX(',', @MailGroupID);
		  IF @SemiColonIndex = 0
			 BEGIN
				SET @MailGroupFilter = @MailGroupID;
				SET @MailGroupID = '';
			 END;
			 ELSE
			 BEGIN
				SET @MailGroupFilter = SUBSTRING(@MailGroupID, 1, @SemiColonIndex-1);
				SET @MailGroupID = SUBSTRING(@MailGroupID, @SemiColonIndex+1, LEN(@MailGroupID));
			 END;

		  INSERT INTO @MailGroupIDTempTable
		  VALUES
			    (RTRIM(LTRIM(@MailGroupFilter)));
	   END;

    IF @Emails = ''
	   BEGIN
		  INSERT INTO @MailIDTempTable
			    SELECT DISTINCT
					 MailID
			    FROM Email AS e
				   INNER JOIN Mail_Email AS me ON e.EmailID = me.EmailID;
	   END;
	   ELSE
	   BEGIN
		  WHILE LEN(@Emails) <> 0
			 BEGIN

				SET @SemiColonIndex = CHARINDEX(',', @Emails);
				IF @SemiColonIndex = 0
				    BEGIN
					   SET @EmailFilter = @Emails;
					   SET @Emails = '';
				    END;
				    ELSE
				    BEGIN
					   SET @EmailFilter = SUBSTRING(@Emails, 1, @SemiColonIndex-1);
					   SET @Emails = SUBSTRING(@Emails, @SemiColonIndex+1, LEN(@Emails));
				    END;

				INSERT INTO @MailIDTempTable
				SELECT DISTINCT
					  MailID
				FROM Email AS e
				    INNER JOIN Mail_Email AS me ON e.EmailID = me.EmailID
				WHERE e.EmailAddress LIKE '%'+RTRIM(LTRIM(@EmailFilter))+'%';
			 END;
	   END;  

    WITH tbl
	    AS (
	    SELECT m.MailID
		    , m.MailName
		    , m.MailGroupID
		    , mg.MailGroupName
		    , m.SiteId
		    , '' SiteName
		    , m.TriggerType
		    , m.LastSent
		    , m.IsActive
		    , mem.EmailID
		    , em.EmailAddress
		    , mem.Type
		    , m.LastActive
			, m.Owners
	    FROM(((Mail AS m WITH (NOLOCK)
		   INNER JOIN MailGroup AS mg WITH (NOLOCK) ON m.MailGroupID = mg.MailGroupID))
		   LEFT OUTER JOIN Mail_Email AS mem WITH (NOLOCK) ON m.MailID = mem.MailID)
		   LEFT OUTER JOIN Email AS em WITH (NOLOCK) ON mem.EmailID = em.EmailID
	    WHERE m.MailName LIKE '%'+@MailName+'%'
			AND
			    (@IsActive IS NULL
				OR @IsActive = -1
				OR m.IsActive = @IsActive)
			AND
			    (NOT EXISTS
						 (
							SELECT TOP 1 *
							FROM @MailGroupIDTempTable
						 )
				OR m.MailGroupID IN
								(
								    SELECT MailGroupID
								    FROM @MailGroupIDTempTable
								))
			AND
			    (@SiteID IS NULL
				OR @SiteID = -1
				OR m.SiteID = @SiteID)
			AND
			    (@TriggerType IS NULL
				OR @TriggerType = -1
				OR m.TriggerType = @TriggerType)
			AND
			    (@OriginalEmails = ''
				OR m.MailID IN
							(
							    SELECT MailID
							    FROM @MailIDTempTable
							)))
	    SELECT MailID
		    , MailName
		    , MailGroupID
		    , MailGroupName
		    , SiteId
		    , SiteName
		    , TriggerType
		    , [0] AS MailTo
		    , [1] AS MailCc
		    , [2] AS MailBcc
		    , LastSent
		    , IsActive
		    , LastActive
			, Owners
	    FROM
		    (
			   SELECT T1.MailID
				   , T1.MailName
				   , T1.Type
				   , T1.MailGroupID
				   , T1.MailGroupName
				   , T1.SiteId
				   , T1.SiteName
				   , T1.TriggerType
				   , T1.LastSent
				   , T1.IsActive
				   , T1.LastActive
				   , T1.Owners
				   , STUFF(
					(
					    SELECT '; '+T2.EmailAddress
					    FROM tbl AS T2
					    WHERE T1.MailID = T2.MailID
							AND T1.Type = T2.Type FOR XML PATH('')
					), 1, 2, '') AS EmailAddress
			   FROM tbl AS T1
			   GROUP BY T1.MailID
					, T1.MailName
					, T1.Type
					, T1.MailGroupID
					, T1.MailGroupName
					, T1.SiteId
					, T1.SiteName
					, T1.TriggerType
					, T1.LastSent
					, T1.IsActive
					, T1.LastActive
					, T1.Owners
		    ) AS SourceTable PIVOT(MAX(EmailAddress) FOR Type IN([0]
													, [1]
													, [2])) PivotTable;

    SELECT GETDATE() AS Now;

    
END;

GO
GRANT EXECUTE ON [dbo].[Mail_MailManagement_GetMailList] TO [wsv_nap]