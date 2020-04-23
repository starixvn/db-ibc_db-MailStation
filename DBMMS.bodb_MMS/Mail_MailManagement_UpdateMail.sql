/*<info serverAlias="DBMMS-bodb_MMS" executers="bodbAdminNet" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Mail_MailManagement_UpdateMail]
	@MailID int = -1,
	@MailName nvarchar(500) = '',
	@MailGroupID int = -1,
	@SiteID int = -1,
	@TriggerType int = -1,
	@RepeatType int = -1,
	@CronExpression nvarchar(30) = '',
	@MailFrom nvarchar(100) = '',
	@MailTo nvarchar(1000) = '',
	@MailCc nvarchar(1000) = '',
	@MailBcc nvarchar(1000) = '',
	@StartOn date = NULL,
	@EndOn date = NULL,
	@Attempt int = 0,
	@Interval int = 0,
	@IsActive bit = 0,
	@Description nvarchar(500) = '',
	@Owners VARCHAR(200) = '',
	@ErrCode int = 0 output,
	@ErrMsg nvarchar(1000) = '' output
AS
/*
	Creator: Phillip.Truong
	Task:  Insert Mail
	DB: DBMMS/bodb_MMS
	
	Revision:
		- 2015-08-04 - Phillip - #39680-Add new features to the Mail Station: Clear all Task history when update Mail.
		- 20200423@Larry: Update mail owners - [Redmine:126527]
*/
BEGIN
	SET NOCOUNT ON
	IF (NOT EXISTS (SELECT 1 FROM dbo.Mail WHERE MailID = @MailID))
	BEGIN
		SET @ErrCode = 29
		SET @ErrMsg = 'Mail is not existed.'
		RETURN;
	END
	
	IF (EXISTS (SELECT 1 FROM dbo.Mail WHERE MailName = @MailName AND MailID <> @MailID))
	BEGIN
		SET @ErrCode = 27
		SET @ErrMsg = 'The Mail name already exists, please enter other Mail name!'
		RETURN;
	END
	
	-- Update Mail Schedule first
	DECLARE @ScheduleID int
	SELECT @ScheduleID =  ScheduleID
	FROM dbo.Mail
	WHERE MailID = @MailID
	
	IF (@ScheduleID IS NULL)
	BEGIN
		-- Is Function Mail already
		IF( @CronExpression <> '')
		BEGIN
			-- Update to Schedule Mail
			-- Insert new Schedule
			INSERT INTO dbo.MailSchedule VALUES(
				@RepeatType,
				@CronExpression,
				@StartOn,
				@EndOn,
				@Attempt,
				@Interval
			)
			
			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 1
				SET @ErrMsg = 'Insert to Mail Schedule failed.'
				RETURN;
			END
			SET @ScheduleID = SCOPE_IDENTITY()
		END
		-- ELSE
			-- Still is Function Mail, there is nothing to do here.
	END
	ELSE
	BEGIN
		-- Schedule Mail
		IF( @CronExpression = '')
		BEGIN
			-- Update to Function Mail
			-- So, delete the old schedule
			DELETE FROM dbo.MailSchedule WHERE ScheduleID = @ScheduleID
		END
		ELSE
		BEGIN
			-- Update to Schedule Mail
			-- Update the old Schedule
			UPDATE dbo.MailSchedule
			SET
				RepeatType = @RepeatType,
				CronExpression = @CronExpression,
				StartOn = @StartOn,
				EndOn = @EndOn,
				Attempt = @Attempt,
				Interval = @Interval
			WHERE
				ScheduleID = @ScheduleID
			
			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 28
				SET @ErrMsg = 'Update Mail Schedule failed.'
				RETURN;
			END
		END
	END
		
	-- Update Mail
	UPDATE Mail
		SET MailName = @MailName,
			MailGroupID = @MailGroupID,
			SiteID = @SiteID,
			TriggerType = @TriggerType,
			ScheduleID = @ScheduleID,
			MailFrom = @MailFrom,
			IsActive = @IsActive,
			[Description] = @Description,
			Owners = @Owners
	WHERE MailID = @MailID
		
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 4
		SET @ErrMsg = 'Update Mail failed.'
		RETURN;
	END
	
	DECLARE @MailType int,
			@EmailID int,
			@CommaIndex int
	
	-- Update Mail_Email
	-- MailType = 0: MailTo
	-- Delete all existed MailTo
	SET @MailType = 0
	DELETE FROM Mail_Email WHERE MailID = @MailID AND [Type] = @MailType
	IF LEN(@MailTo) <>0
	BEGIN
		
		
		-- Insert MailTo
		WHILE LEN (@MailTo) <> 0
		BEGIN
			
			SET @CommaIndex = CHARINDEX(',', @MailTo)
			IF @CommaIndex = 0
			BEGIN
				SET @EmailID = CAST(@MailTo AS INT)
				SET @MailTo = ''
			END
			ELSE
			BEGIN
				SET @EmailID = CAST(SUBSTRING(@MailTo, 1, @CommaIndex-1) AS INT)
				SET @MailTo = SUBSTRING(@MailTo, @CommaIndex+1, LEN(@MailTo))
			END
			
			INSERT INTO Mail_Email VALUES(
				@MailID,
				@EmailID,
				@MailType
			)
			
			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 3
				SET @ErrMsg = 'Insert to Mail_Email failed.'
				DELETE FROM Mail_Email WHERE MailID = @MailID AND EmailID = @EmailID
				RETURN;
			END
		END
	END
	
	-- MailType = 1: MailCc
	-- Delete all existed MailTo
	SET @MailType = 1
	DELETE FROM Mail_Email WHERE MailID = @MailID AND [Type] = @MailType
	IF LEN(@MailCc) <>0
	BEGIN
		
		
		WHILE LEN (@MailCc) <> 0
		BEGIN
			
			SET @CommaIndex = CHARINDEX(',', @MailCc)
			IF @CommaIndex = 0
			BEGIN
				SET @EmailID = CAST(@MailCc AS INT)
				SET @MailCc = ''
			END
			ELSE
			BEGIN
				SET @EmailID = CAST(SUBSTRING(@MailCc, 1, @CommaIndex-1) AS INT)
				SET @MailCc = SUBSTRING(@MailCc, @CommaIndex+1, LEN(@MailCc))
			END
			
			INSERT INTO Mail_Email VALUES(
				@MailID,
				@EmailID,
				@MailType
			)
			
			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 3
				SET @ErrMsg = 'Insert to Mail_Email failed.'
				DELETE FROM Mail_Email WHERE MailID = @MailID AND EmailID = @EmailID
				RETURN;
			END
		END
	END
	
	-- MailType = 2: MailBcc
	-- Delete all existed MailTo
	SET @MailType = 2
	DELETE FROM Mail_Email WHERE MailID = @MailID AND [Type] = @MailType
	IF LEN(@MailBcc) <>0
	BEGIN
		
		WHILE LEN (@MailBcc) <> 0
		BEGIN
			
			SET @CommaIndex = CHARINDEX(',', @MailBcc)
			IF @CommaIndex = 0
			BEGIN
				SET @EmailID = CAST(@MailBcc AS INT)
				SET @MailBcc = ''
			END
			ELSE
			BEGIN
				SET @EmailID = CAST(SUBSTRING(@MailBcc, 1, @CommaIndex-1) AS INT)
				SET @MailBcc = SUBSTRING(@MailBcc, @CommaIndex+1, LEN(@MailBcc))
			END
			
			INSERT INTO Mail_Email VALUES(
				@MailID,
				@EmailID,
				@MailType
			)
			
			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 3
				SET @ErrMsg = 'Insert to Mail_Email failed.'
				DELETE FROM Mail_Email WHERE MailID = @MailID AND EmailID = @EmailID
				RETURN;
			END
		END
	END
	
	UPDATE dbo.MailTask
	SET IsUnableToRetry = 1
	WHERE MailID = @MailID
		AND Status <> 1 -- Do Not clear Running Task because this record is in use by Job.
	
	SET @ErrCode = 0
	SET @ErrMsg = ''
END

GO