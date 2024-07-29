/*<info serverAlias="DBPOL-NAP_UserControl" executers="wsv_nap" viewers="" isFunction="0" isNested="0"></info>*/

CREATE PROCEDURE [dbo].[Mail_NapSite_Select]
	@TransformJson VARBINARY(MAX)  OUTPUT 
AS

/*	Creator: 20240722@Robert
	Task: WEB - DBA - Remove linked-server on DBPOL
	DB: DBPOL/NAP_UserControl
	
	Revisions: 
		 - 20240722@Robert: Initialize
		 
     Param:
*/

BEGIN
	SET NOCOUNT ON
	SELECT @TransformJson = COMPRESS(( SELECT 
										s.SiteId,
										s.SiteName,
										s.Description,
										s.URL,
										s.TestURL,
										s.IsActive,
										s.Environment,
										s.SecretAccessKey,
										s.SiteKey
								FROM [dbo].[NAP_Sites] s WITH(NOLOCK)	
								where s.SiteId>0
								ORDER BY s.SiteId
								FOR JSON PATH
								,INCLUDE_NULL_VALUES
							))
END

GO

GRANT EXECUTE ON [dbo].[Mail_NapSite_Select] TO [wsv_nap]
GO 
