
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Robert.Tran
	Task: mSite - Support to write log for Application Management function - [Redmine:171978]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20220427@Robert: Add the new table [Mail_Config_Log] - [Redmine:171978]
*/

CREATE TABLE [dbo].[Mail_Config_Log]
		   (
	LogID         [INT] IDENTITY(1, 1) NOT NULL, 
	[AppID]       [INT] NOT NULL, 
	[AppName]     [NVARCHAR](100) NOT NULL, 
	[Description] [NCHAR](250) NULL, 
	[SettingID]   [INT] NOT NULL, 
	[MailFrom]    [NVARCHAR](100) NOT NULL, 
	[IsEncrypt]   [BIT] NOT NULL, 
	[LogTime]     [DATETIME] NOT NULL, 
	[UserID]      [BIGINT] NOT NULL, 
	CONSTRAINT [PK_Mail_Config_Log] PRIMARY KEY CLUSTERED([LogID] ASC)
	WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
		   )
ON [PRIMARY];
GO

CREATE INDEX IDX_Mail_Config_LogAppID ON [dbo].[Mail_Config_Log](AppID);
