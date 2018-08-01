/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE dbo.Mail_Core_GetAllScheduleMail
AS
/*	
	Creator: Phillip.Truong
	Task:  Get Mail List
	DB: DBMMS/bodb_MMS
	
	Revisions: 
		 - 20141118@Phillip: Initialize Get MailSchedule
		 - 20180729@Robert: Tidy up the Mail Station [#99119]
*/

BEGIN
    SET NOCOUNT ON;
    SELECT m.MailID
	    , m.MailName
	    , ms.CronExpression
	    , m.LastActive
    FROM dbo.Mail AS m
	   INNER JOIN dbo.MailSchedule AS ms ON m.ScheduleID = ms.ScheduleID;

    SELECT GETDATE() AS Now;
END;
GO

GRANT EXECUTE ON dbo.Mail_Core_GetAllScheduleMail TO [bodbAdminNet];
GO