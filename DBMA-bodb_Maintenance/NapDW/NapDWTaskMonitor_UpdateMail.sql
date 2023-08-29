
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[NapDWTaskMonitor_UpdateMail] 
	@TaskId        BIGINT, 
	@Email         VARCHAR(50) = NULL, 
	@EmailSentDate DATETIME    = NULL
AS

/*	Creator: 20230829@Robert
	Task: NAP DW - Upgrade to docker swarm service [#192373]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20230829@Robert: Initialize		 		
*/

    BEGIN
	   SET NOCOUNT ON;
	   UPDATE n
		SET 
		    n.Email = CASE
					   WHEN @Email = NULL
					   THEN n.Email
					   ELSE @Email
				    END, 
		    n.EmailSentDate = CASE
							 WHEN @EmailSentDate = NULL
							 THEN n.EmailSentDate
							 ELSE @EmailSentDate
						  END
	   FROM dbo.NapDWTaskMonitor n WITH (ROWLOCK, UPDLOCK)
	   WHERE 
		    n.TaskId = @TaskId;
    END;
