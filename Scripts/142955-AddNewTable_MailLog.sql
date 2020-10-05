/*<info serverAlias="DBMMS-bodb_MMS"></info>*/
/*
	Creator: Larry.Tran
	Task: Write log for the active status of a mail - [Redmine:142955]
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 20201005@Larry: Add the new table MailLog - [Redmine:142955]
*/
USE [bodb_MMS]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MailLog](
	[MailLogId] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](2000) NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MailID] [int] NOT NULL,
 CONSTRAINT [PK_MailLog] PRIMARY KEY CLUSTERED 
(
	[MailLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO