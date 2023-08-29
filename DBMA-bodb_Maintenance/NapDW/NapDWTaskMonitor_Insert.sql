
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[NapDWTaskMonitor_Insert] 
	@UserName    NVARCHAR(50), 
	@Status      NVARCHAR(20), 
	@Environment VARCHAR(20), 
	@ReportName  VARCHAR(50), 
	@Criteria    VARCHAR(MAX), 
	@TaskId      BIGINT       = 0 OUTPUT
AS

/*	Creator: 20230829@Robert
	Task: NAP DW - Upgrade to docker swarm service [#192373]
	DB: DBMA/bodb_Maintenance
	
	Revisions: 
		 - 20230829@Robert: Initialize			
*/

    BEGIN
	   SET NOCOUNT ON;
	   INSERT INTO [dbo].[NapDWTaskMonitor]
		 (
			UserName, 
			STATUS, 
			Retry, 
			CreatedDate, 
			Environment, 
			ReportName, 
			Criteria
		 )
			SELECT 
				  @UserName, 
				  @Status, 
				  0 Retry, 
				  GETDATE() CreatedDate, 
				  @Environment, 
				  @ReportName, 
				  @Criteria;
	   SELECT 
			@TaskId = @@IDENTITY;
    END;
