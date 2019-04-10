/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE ServiceMonitoring_CheckIn
	@ServiceName    VARCHAR(50)
   , @Interval       INT
   , @OrderBy        TINYINT     = 3
   , @IPServer       VARCHAR(50) = ''
AS
/*	Creator: 20190328@Robert
	Task:  Auto Email Services - Detect hang services
	DB: DBMA/bodb_Maintenance	
	Revisions: 
		 - 20190328@Robert: #110874 - Auto Email Services - Detect hang services
		
*/
BEGIN
    SET NOCOUNT ON;

    IF @ServiceName = ''
	   RETURN;

    IF NOT EXISTS
			   (
				  SELECT 1
				  FROM ServiceMonitoring WITH (NOLOCK)
				  WHERE ServiceName = @ServiceName
					   AND IPServer = @IPServer
			   )
	   BEGIN
		  INSERT INTO ServiceMonitoring(ServiceName
								, Interval
								, IsActive
								, OrderBy
								, IPServer
								, LastUpdate)
			    (
				   SELECT @ServiceName AS ServiceName
					   , @Interval AS Interval
					   , 1 AS IsActive
					   , @OrderBy AS OrderBy
					   , @IPServer AS IPServer
					   , GETDATE() AS LastUpdate
			    );
	   END;
	   ELSE
	   BEGIN
		  UPDATE s
			    SET
				   LastUpdate = GETDATE()
				 , IsActive = 1
				 , Interval = @Interval
				 , OrderBy = @OrderBy
		  FROM ServiceMonitoring s WITH (ROWLOCK, UPDLOCK)
		  WHERE ServiceName = @ServiceName
			   AND IPServer = @IPServer;
	   END;
END;
GO