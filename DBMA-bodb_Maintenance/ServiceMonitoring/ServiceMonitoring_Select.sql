/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE ServiceMonitoring_Select
	@IsTest    BIT = 0
AS
/*	Creator: 20190328@Robert
	Task:  Auto Email Services - Detect hang services
	DB: DBMA/bodb_Maintenance	
	Revisions: 
		 - 20190328@Robert: #110874 - Auto Email Services - Detect hang services
		 - 20190410@Robert: #110874 - Auto Email Services - Detect hang services - Enhancement sp for testing
		
*/

BEGIN
    SET NOCOUNT ON;

    IF @IsTest = 0
	   BEGIN
		  SELECT ServiceId
			  , ServiceName
			  , Interval
			  , IsActive
			  , OrderBy
			  , IPServer
			  , LastUpdate
			  , DATEDIFF(SECOND, ISNULL(LastUpdate, GETDATE()), GETDATE()) AS DIFF
		  FROM ServiceMonitoring WITH (NOLOCK)
		  WHERE IsActive = 1
			   AND DATEDIFF(SECOND, ISNULL(LastUpdate, GETDATE()), GETDATE()) > Interval
		  ORDER BY OrderBy ASC;
	   END;
	   ELSE
	   BEGIN
		  SELECT ServiceId
			  , ServiceName
			  , Interval
			  , IsActive
			  , OrderBy
			  , IPServer
			  , LastUpdate
			  , DATEDIFF(SECOND, ISNULL(LastUpdate, GETDATE()), GETDATE()) AS DIFF
		  FROM ServiceMonitoring WITH (NOLOCK)
		  ORDER BY OrderBy ASC;
	   END;
END;
GO