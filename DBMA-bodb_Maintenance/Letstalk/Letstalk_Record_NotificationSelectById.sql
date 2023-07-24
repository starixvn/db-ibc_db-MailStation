/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[Letstalk_Record_NotificationSelectById] @Id BIGINT
AS

/*	Creator: 20170329@Robert
	Task: mSite - Support Letstalk log and resend message function [#73400]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20170329@Robert: Initialize
		
*/

     BEGIN
         SET NOCOUNT ON;
         SELECT Id,
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
         FROM Letstalk_Record(nolock)
         WHERE Id = @id;
     END;
