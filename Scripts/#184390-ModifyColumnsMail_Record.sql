
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/

/*
	Creator: Larry.Tran
	Task: Mail service | Wrong email of user - [Redmine:184390]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20230228@Robert: Modify columns MailTo, MailCc , MailBcc - [Redmine:184390]
*/

ALTER TABLE dbo.Mail_Record ALTER COLUMN MailTo VARCHAR(MAX);
ALTER TABLE dbo.Mail_Record ALTER COLUMN MailCc VARCHAR(MAX);
ALTER TABLE dbo.Mail_Record ALTER COLUMN MailBcc VARCHAR(MAX);
GO
