
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[Letstalk_Record_NotificationSelect] 
	@FromDate   DATETIME, 
	@ToDate     DATETIME, 
	@TargetName NVARCHAR(50) = 'All', 
	@Group      NVARCHAR(50) = 'All', 
	@Status     INT          = 2
AS

/*	Creator: 20170329@Robert
	Task: mSite - Support Letstalk log and resend message function [#73400]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20170329@Robert: Initialize
		 - 20171129@Robert: Select log by filter Targetname or Group
		 - 20230724@Robert: Email/Letstalk Reports - Apply Bot API and change HTML UI for letstalk report #31, 32, 33, 34, 35 [#191481]		
		 - 20231128@Robert: Select log by filter status
     Param:
	   - @Status: 
		  . All = 2
		  . FAILED = 0
		  . SUCCEEDED = 1


*/

    BEGIN

	   SET NOCOUNT ON;
	   SELECT 
			Id, 
			TargetName, 
			Subject, 
			Content,
			CASE
			    WHEN l.Subject = 'Bot Api'
			    THEN l.LetstalkGroup
			    ELSE [Group]
			END [Group], 
			Attachments, 
			InlineImages, 
			CreatedDate, 
			LastSentDate, 
			SendSuccess, 
			SendFail, 
			IsMessage
	   FROM Letstalk_Record(NOLOCK) l
	   WHERE CreatedDate BETWEEN @FromDate AND @ToDate
		    AND TargetName = CASE
							WHEN @TargetName = 'All'
							THEN TargetName
							ELSE @TargetName
						 END
		    AND [Group] = CASE
						  WHEN @Group = 'All'
						  THEN [Group]
						  ELSE @Group
					   END
		    AND CASE
				  WHEN @Status = 2
				  THEN @Status
				  WHEN @Status = 1
				  THEN SendSuccess
				  WHEN @Status = 0
				  THEN SendFail
			   END > 0
	   ORDER BY 
			  id DESC;
    END;
