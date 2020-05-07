/*<info serverAlias="DBMMS-bodb_MMS"></info>*/
/*
	Creator: Larry.Tran
	Task: MailStation improvement - [Redmine:126527]
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20200309@Larry: Modify columns ExceptionMessage, Add Owners - [Redmine:126527]
*/
ALTER TABLE dbo.MailTaskLog
ALTER COLUMN ExceptionMessage varchar(2000)
GO
ALTER TABLE dbo.Mail
ADD Owners VARCHAR(200) NULL
GO