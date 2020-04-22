/*
	Creator: Larry.Tran
	Task: MailStation improvement - [Redmine:126527]
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20200309@Larry: Modify columns ExceptionMessage - [Redmine:126527]
*/
ALTER TABLE dbo.MailTaskLog
ALTER COLUMN ExceptionMessage varchar(2000)
GO