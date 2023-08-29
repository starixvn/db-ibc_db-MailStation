
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[NapDWTaskMonitor_UpdateStatus] 
	@TaskId     BIGINT, 
	@Status     VARCHAR(20), 
	@Retry      SMALLINT, 
	@ExportType VARCHAR(10)  = NULL, 
	@FileName   VARCHAR(100) = NULL, 
	@FileLink   VARCHAR(MAX) = NULL
AS

/*	Creator: 20230829@Robert
	Task: NAP DW - Upgrade to docker swarm service [#192373]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20230829@Robert: change status	 		
*/

    BEGIN
	   SET NOCOUNT ON;
	   UPDATE n
		SET 
		    n.STATUS = @Status, 
		    n.UpdatedDate = GETDATE(), 
		    n.Retry = @Retry, 
		    n.ExportType = CASE
						   WHEN @ExportType = NULL
						   THEN n.ExportType
						   ELSE @ExportType
					    END, 
		    n.FileName = CASE
						 WHEN @FileName = NULL
						 THEN n.FileName
						 ELSE @FileName
					  END, 
		    n.FileLink = CASE
						 WHEN @FileLink = NULL
						 THEN n.FileLink
						 ELSE @FileLink
					  END
	   FROM dbo.NapDWTaskMonitor n WITH (ROWLOCK, UPDLOCK)
	   WHERE 
		    n.TaskId = @TaskId;
    END;
