/*
	Creator: Larry.Tran
	Task: MailStation improvement - [Redmine:126527]
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20200309@Larry: Modify columns ExceptionMessage, InnerMessage - [Redmine:126527]
*/
ALTER TABLE dbo.MailTaskLog
ALTER COLUMN ExceptionMessage varchar(1000)
GO
ALTER TABLE dbo.MailTaskLog
ALTER COLUMN InnerMessage varchar(1000)
GO