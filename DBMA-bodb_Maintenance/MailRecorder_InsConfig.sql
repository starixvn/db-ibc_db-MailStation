
/*<info serverAlias="DBMA-bodb_Maintenance" executers="bodbAdminNet" isFunction="0"></info>*/


/*
	Creator: Robert.Tran
	Task: mSite - Support to write log for Application Management function - [Redmine:171978]
	DB: DBMA/bodb_Maintenance
	
	Revision:
		- 20220427@Robert: write log into table [Mail_Config_Log] - [Redmine:171978]
*/


CREATE PROCEDURE [dbo].[MailRecorder_InsConfig] 
	@AppName     NVARCHAR(100), 
	@Description NVARCHAR(250) = '', 
	@MailFrom    NVARCHAR(100) = '', 
	@SettingID   INT, 
	@IsEncrypt   BIT           = 0, 
	@AppID       INT           = 0 OUTPUT, 
	@UserID      INT           = 0, 
	@ErrCode     INT           = 0 OUTPUT, 
	@ErrMsg      NVARCHAR(200) = '' OUTPUT
AS

/*
Created: 09/29/2011@Bobby
Task : Insert new mail configuration
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

Revisions:
	- 7/29/2013 Ricky: Add Mail from
*/

	SET NOCOUNT ON;
    BEGIN
	   IF EXISTS
			  (
				 SELECT 
					   *
				 FROM dbo.Mail_Config
				 WHERE AppID = @AppID
			   )
		  BEGIN
			 UPDATE dbo.Mail_Config
			   SET 
				  AppName = N'' + @AppName + '', 
				  [Description] = N'' + @Description + '', 
				  [SettingID] = @SettingID, 
				  [MailFrom] = @MailFrom, 
				  [IsEncrypt] = @IsEncrypt
			 WHERE 
				  AppID = @AppID;

			 INSERT INTO dbo.Mail_Config_Log
			    (
				   AppID, 
				   AppName, 
				   Description, 
				   SettingID, 
				   MailFrom, 
				   IsEncrypt, 
				   LogTime, 
				   UserID
			    )
				   SELECT 
						m.AppID, 
						m.AppName, 
						m.Description, 
						m.SettingID, 
						m.MailFrom, 
						m.IsEncrypt, 
						GETDATE() LogTime, 
						@UserID UserID
				   FROM dbo.Mail_Config m(NOLOCK)
				   WHERE m.AppID = @AppID;

			 IF @@Error <> 0
				BEGIN
				    SELECT 
						 @ErrMsg = 'Error! Error when updating mail configuration;', 
						 @ErrCode = 101;
				    RETURN;
				END;
		  END;
		  ELSE
		  BEGIN
			 INSERT INTO dbo.Mail_Config
			    (
				   [AppName], 
				   [Description], 
				   [SettingID], 
				   [MailFrom], 
				   IsEncrypt
			    )
			 VALUES
				  (
				   N'' + @AppName + '', 
				   N'' + @Description + '', 
				   @SettingID, 
				   N'' + @MailFrom + '', 
				   @IsEncrypt
				  );

			 INSERT INTO dbo.Mail_Config_Log
			    (
				   AppID, 
				   AppName, 
				   Description, 
				   SettingID, 
				   MailFrom, 
				   IsEncrypt, 
				   LogTime, 
				   UserID
			    )
				   SELECT 
						@@IDENTITY AppID, 
						@AppName, 
						@Description, 
						@SettingID, 
						@MailFrom, 
						@IsEncrypt, 
						GETDATE() LogTime, 
						@UserID UserID;


			 IF @@Error <> 0
				BEGIN
				    SELECT 
						 @ErrMsg = 'Error! Error when inserting mail configuration;', 
						 @ErrCode = 101;
				    RETURN;
				END;
			 SELECT 
				   @AppID = @@IDENTITY;
		  END;

    END;
GO

