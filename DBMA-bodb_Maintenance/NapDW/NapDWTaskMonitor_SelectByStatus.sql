
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[NapDWTaskMonitor_SelectByStatus] 
	@ReportName  VARCHAR(50)  = '', 
	@Status      VARCHAR(20)  = '', 
	@UserName    NVARCHAR(50) = '', 
	@Environment VARCHAR(20), 
	@FromDate    DATETIME, 
	@ToDate      DATETIME
AS

/*	Creator: 20230829@Robert
	Task: NAP DW - Upgrade to docker swarm service [#192373]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20230829@Robert: Excel Archive	 
		
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
	   WHERE n.UserName = CASE
						 WHEN @UserName <> ''
						 THEN @UserName
						 ELSE n.UserName
					  END
		    AND n.STATUS = CASE
						   WHEN @Status <> ''
						   THEN @Status
						   ELSE n.STATUS
					    END
		    AND n.ReportName LIKE '%' + @ReportName + '%'
		    AND n.Environment = @Environment
		    AND n.CreatedDate BETWEEN @FromDate AND @ToDate
	   ORDER BY 
			  n.TaskId DESC;
    END;
