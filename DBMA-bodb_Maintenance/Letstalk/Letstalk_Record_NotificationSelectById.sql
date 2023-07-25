
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[Letstalk_Record_NotificationSelectById] 
	@Id BIGINT
AS

/*	Creator: 20170329@Robert
	Task: mSite - Support Letstalk log and resend message function [#73400]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20170329@Robert: Initialize
		 - 20230724@Robert: Email/Letstalk Reports - Apply Bot API and change HTML UI for letstalk report #31, 32, 33, 34, 35 [#191481]		
		
*/

    BEGIN
	   SET NOCOUNT ON;
	   SELECT 
			Id, 
			TargetName, 
			[Subject], 
			[Content],
			[Group], 
			Attachments, 
			InlineImages, 
			CreatedDate, 
			LastSentDate, 
			SendSuccess, 
			SendFail, 
			IsMessage
	   FROM Letstalk_Record(NOLOCK) l
	   WHERE Id = @id;
    END;
