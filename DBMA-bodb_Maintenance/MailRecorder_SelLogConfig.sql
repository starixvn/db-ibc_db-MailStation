
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Robert.Tran
	Task: mSite - Support to write log for Application Management function - [Redmine:171978]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20220427@Robert: select log from table [Mail_Config_Log] - [Redmine:171978]
*/


CREATE PROCEDURE [dbo].[MailRecorder_SelLogConfig] 
	@AppID INT = 0
AS
	SET NOCOUNT ON;
    BEGIN

	   CREATE TABLE #tplUser
				 (
		   UserId   INT, 
		   Username VARCHAR(50)
				 );
	   CREATE INDEX IDX_tplUser_UserId ON #tplUser(UserId);
	   INSERT INTO #tplUser
		 (
			UserId
		 )
			SELECT DISTINCT 
				  m.UserID
			FROM [dbo].[Mail_Config_Log] m(NOLOCK)
			WHERE m.AppID = @AppID;

	   UPDATE u
		SET 
		    u.Username = c.username
	   FROM #tplUser u
		   INNER JOIN bodb02.dbo.custInfo c(NOLOCK) ON u.UserId = c.custid;

	   SELECT 
			m.LogID, 
			m.AppID, 
			m.AppName, 
			m.Description, 
			s.SettingName, 
			m.MailFrom, 
			m.IsEncrypt, 
			m.LogTime, 
			ISNULL(u.Username, 'UNKNOWN') Username
	   FROM [dbo].[Mail_Config_Log] m(NOLOCK)
		   INNER JOIN [dbo].[Mail_Setting] s(NOLOCK) ON m.SettingID = s.SettingID
		   LEFT JOIN #tplUser u ON m.UserID = u.UserId
	   WHERE m.AppID = @AppID
	   ORDER BY 
			  m.LogTime DESC;

	   DROP TABLE #tplUser;
    END;
GO



