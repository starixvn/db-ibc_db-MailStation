
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[NapDWTaskMonitor_SelectByUserName] 
	@Environment VARCHAR(20), 
	@UserName    NVARCHAR(50) = '', 
	@Status      NVARCHAR(50) = '', 
	@FromDate    DATETIME, 
	@ToDate      DATETIME
AS

/*	Creator: 20230829@Robert
	Task: NAP DW - Upgrade to docker swarm service [#192373]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20230829@Robert: Task Monitor	 
		
*/

    BEGIN
	   SET NOCOUNT ON;
	   SELECT 
			[TaskId], 
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
	   WHERE CASE
			   WHEN @UserName <> ''
			   THEN n.UserName
			   ELSE @UserName
		    END = @UserName
		    AND n.Environment = @Environment
		    AND CASE
				  WHEN @Status <> ''
				  THEN n.STATUS
				  ELSE @Status
			   END = @Status
		    AND n.CreatedDate BETWEEN @FromDate AND @ToDate
	   ORDER BY 
			  n.TaskId DESC;
    END;
