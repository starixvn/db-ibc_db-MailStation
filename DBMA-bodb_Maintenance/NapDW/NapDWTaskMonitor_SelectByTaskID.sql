
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[NapDWTaskMonitor_SelectByTaskID] 
	@UserName    NVARCHAR(50), 
	@Environment VARCHAR(20), 
	@TaskId      INT
AS

/*	Creator: 20230829@Robert
	Task: NAP DW - Upgrade to docker swarm service [#192373]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20230829@Robert: Initialize		 
		
*/

    BEGIN
	   SET NOCOUNT ON;
	   SELECT 
			[UserName], 
			[Status], 
			[CreatedDate], 
			[UpdatedDate], 
			[Retry], 
			[ExportType], 
			[FileName], 
			[FileLink], 
			[Environment], 
			[ReportName], 
			[Criteria], 
			[Email], 
			[EmailSentDate]
	   FROM dbo.NapDWTaskMonitor n(NOLOCK)
	   WHERE n.Environment = @Environment
		    AND n.UserName = @UserName
		    AND n.TaskId = @TaskId;
    END;
