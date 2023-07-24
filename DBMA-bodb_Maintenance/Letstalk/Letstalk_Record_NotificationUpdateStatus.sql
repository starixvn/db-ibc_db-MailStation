/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE [dbo].[Letstalk_Record_NotificationUpdateStatus] @Id           BIGINT,
                                                                 @IsSuccess    BIT,
                                                                 @ErrorCode    INT           = 0 OUTPUT,
                                                                 @ErrorMessage NVARCHAR(200) = '' OUTPUT
AS

/*	Creator: 20170329@Robert
	Task: mSite - Support Letstalk log and resend message function [#73400]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20170329@Robert: Initialize
		
*/

     BEGIN
         SET NOCOUNT ON;
         UPDATE Letstalk_Record WITH(ROWLOCK, UPDLOCK)
           SET
               SendSuccess = CASE
                                 WHEN @IsSuccess = 1
                                 THEN SendSuccess + 1
                                 ELSE SendSuccess
                             END,
               SendFail = CASE
                              WHEN @IsSuccess = 0
                              THEN SendFail + 1
                              ELSE SendFail
                          END,
               LastSentDate = GETDATE()
         WHERE id = @Id;
         IF @@ERROR <> 0
             BEGIN
                 SELECT @ErrorCode = 101,
                        @ErrorMessage = 'Update does not successfully.';
             END;
     END;
