/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" viewers="" isFunction="0" isNested="0"></info>*/

ALTER PROCEDURE ServiceMonitoring_Select
AS
/*	Creator: 20190328@Robert
	Task:  Auto Email Services - Detect hang services
	DB: DBMA/bodb_Maintenance	
	Revisions: 
		 - 20190328@Robert: #110874 - Auto Email Services - Detect hang services
		
*/

BEGIN
    SET NOCOUNT ON;

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
GO