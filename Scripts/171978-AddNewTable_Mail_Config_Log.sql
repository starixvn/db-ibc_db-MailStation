
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Robert.Tran
	Task: mSite - Support to write log for Application Management function - [Redmine:171978]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20220427@Robert: Add the new table [Mail_Config_Log] - [Redmine:171978] 
*/

USE bodb_Maintenance;
GO

-----------------------------
-- Step 1: Create New Table

CREATE TABLE [dbo].[Mail_Config_Log]
		   (
	LogID         [INT] IDENTITY(1, 1) NOT NULL, 
	[AppID]       [INT] NOT NULL, 
	[AppName]     [NVARCHAR](100) NOT NULL, 
	[Description] [NVARCHAR](250) NULL, 
	[SettingID]   [INT] NOT NULL, 
	[MailFrom]    [NVARCHAR](100) NOT NULL, 
	[IsEncrypt]   [BIT] NOT NULL, 
	[LogTime]     [DATETIME] NOT NULL, 
	[UserID]      [INT] NOT NULL
		   )
ON [UserLogData] WITH(DATA_COMPRESSION = PAGE);              
                        
GO                        
                    
CREATE CLUSTERED INDEX [CIX_Mail_Config_LogAppID] ON [dbo].[Mail_Config_Log]
	  (AppID ASC
	  ) 
	WITH(DATA_COMPRESSION = PAGE) ON [UserLogData];                        
GO                        
                      