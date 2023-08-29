
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Robert.Tran
	Task: NAP DW - Upgrade to docker swarm service - [Redmine:192373]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20230829@Robert: Upgrade to docker swarm service - [Redmine:192373] 
*/

USE bodb_Maintenance;
GO

-----------------------------
-- Step 1: Create New Table

IF OBJECT_ID(N'dbo.NapDWTaskMonitor', N'U') IS NOT NULL
    BEGIN
	   DROP TABLE dbo.NapDWTaskMonitor;
    END;

CREATE TABLE [dbo].[NapDWTaskMonitor]
		   (
	[TaskId]        [BIGINT] IDENTITY(1, 1) NOT NULL, 
	[UserName]      [NVARCHAR](50) NULL, 
	[Status]        [NVARCHAR](20) NULL, 
	[CreatedDate]   [DATETIME] NULL, 
	[UpdatedDate]   [DATETIME] NULL, 
	[Retry]         [SMALLINT] NULL, 
	[ExportType]    [VARCHAR](10) NULL, 
	[FileName]      [VARCHAR](100) NULL, 
	[FileLink]      [VARCHAR](MAX) NULL, 
	[Environment]   [VARCHAR](20) NULL, 
	[ReportName]    [VARCHAR](50) NULL, 
	[Criteria]      [VARCHAR](MAX) NULL, 
	[Email]         [VARCHAR](50) NULL, 
	[EmailSentDate] [DATETIME] NULL,
		   )
ON [UserLogData] WITH(DATA_COMPRESSION = PAGE);              
GO

-- Step 2: Create Index

CREATE CLUSTERED INDEX [CIX_NapDWTaskMonitor_TaskId] ON [dbo].[NapDWTaskMonitor]
	  (TaskId ASC
	  ) 
	WITH(DATA_COMPRESSION = PAGE) ON [UserLogData];                        
GO                        
                      
CREATE NONCLUSTERED INDEX IDX_NapDWTaskMonitor_UserName_Environment_CreatedDate ON dbo.NapDWTaskMonitor(UserName ASC, Environment ASC, CreatedDate DESC); 
CREATE NONCLUSTERED INDEX IDX_NapDWTaskMonitor_Environment_Email_EmailSentDate ON dbo.NapDWTaskMonitor(Email ASC, EmailSentDate DESC); 
