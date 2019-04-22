/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE ServiceMonitoring_UpdateStatus
	@ServiceName    VARCHAR(50)
   , @IPServer       VARCHAR(50)
   , @IsActive       BIT
AS
/*	Creator: 20190328@Robert
	Task:  Auto Email Services - Detect hang services
	DB: DBMA/bodb_Maintenance	
	Revisions: 
		 - 20190328@Robert: #110874 - Auto Email Services - Detect hang services
		
*/
BEGIN
    SET NOCOUNT ON;

    UPDATE s
		 SET
			LastUpdate = GETDATE()
		   , IsActive = @IsActive
    FROM ServiceMonitoring s WITH (ROWLOCK, UPDLOCK)
    WHERE ServiceName = @ServiceName
		AND IPServer = @IPServer;
END;
GO