
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[Letstalk_Record_GroupByTargetSelect] 
	@TargetName NVARCHAR(50) = 'ALL', 
	@FromDate   DATETIME, 
	@ToDate     DATETIME
AS

/*	Creator: 20171129@Robert
	Task: mSite - Support Letstalk log and resend message function [#73400]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20171129@Robert: Initialize
		 - 20230724@Robert: Email/Letstalk Reports - Apply Bot API and change HTML UI for letstalk report #31, 32, 33, 34, 35 [#191481]		
*/

    BEGIN
	   SET NOCOUNT ON;
	   SELECT DISTINCT 
			CASE
			    WHEN l.Subject = 'Bot Api'
			    THEN l.LetstalkGroup
			    ELSE [Group]
			END [Group]
	   FROM Letstalk_Record(NOLOCK) l
	   WHERE TargetName = CASE
						 WHEN @TargetName = 'All'
						 THEN TargetName
						 ELSE @TargetName
					  END
		    AND CreatedDate BETWEEN @FromDate AND @ToDate
	   ORDER BY 
			  CASE
				 WHEN l.Subject = 'Bot Api'
				 THEN l.LetstalkGroup
				 ELSE [Group]
			  END;
    END;

