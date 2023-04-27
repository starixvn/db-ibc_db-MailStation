
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE MailRecorder_SelMailFail 
	@FromDate DATETIME, 
	@ToDate   DATETIME
AS

/*	Creator: 20230427@Robert
	Task:  Notify via letstalk for sending email failed
	DB: DBMA/bodb_Maintenance	
	Revisions: 
		 - 20190328@Robert: #187582 - Notify via letstalk for sending email failed		
*/

    BEGIN
	   SET NOCOUNT ON;

	   SELECT 
			c.AppName, 
			m.Subject
	   FROM [dbo].[Mail_Record] m WITH(NOLOCK)
		   INNER JOIN [dbo].[Mail_Config] c WITH(NOLOCK) ON m.AppID = c.AppID
	   WHERE m.sentFail > 0
		    AND m.SentSuccess = 0
		    AND m.MailDate BETWEEN @FromDate AND @ToDate
	   ORDER BY 
			  c.AppName, 
			  m.Subject;
    END;
GO