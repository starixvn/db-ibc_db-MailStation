
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Robert.Tran
	Task: Email/Letstalk Reports - Apply Bot API and change HTML UI for letstalk report #31, 32, 33, 34, 35 - [Redmine:191481]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20230724@Robert: Add new column LetstalkGroup - [Redmine:191481]
*/

ALTER TABLE dbo.Letstalk_Record
ADD 
		  LetstalkGroup NVARCHAR(200);
GO

ALTER TABLE dbo.Letstalk_Record ALTER COLUMN [Group] NVARCHAR(200);
GO
