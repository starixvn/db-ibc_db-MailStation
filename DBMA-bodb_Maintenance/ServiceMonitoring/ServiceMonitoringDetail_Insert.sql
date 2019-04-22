/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE ServiceMonitoringDetail_Insert
	@ServiceId    INT
AS
/*	Creator: 20190328@Robert
	Task:  Auto Email Services - Detect hang services
	DB: DBMA/bodb_Maintenance	
	Revisions: 
		 - 20190328@Robert: #110874 - Auto Email Services - Detect hang services
		
*/
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ServiceMonitoringDetail(ServiceId
							   , RestartTime)
		 (
			SELECT @ServiceId AS ServiceId
				, GETDATE() AS RestartTime
		 );

    UPDATE s
		 SET
			LastUpdate = GETDATE()
    FROM ServiceMonitoring s WITH (ROWLOCK, UPDLOCK)
    WHERE ServiceId = @ServiceId;
END;
GO