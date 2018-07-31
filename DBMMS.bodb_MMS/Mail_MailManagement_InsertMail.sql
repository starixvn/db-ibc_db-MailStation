
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_InsertMail    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-14
-- Description:	Update Mail
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_InsertMail]
	@MailName nvarchar(500) = '',
	@MailGroupID int = 0,
	@SiteID int = 0,
	@TriggerType int = 0,
	@RepeatType int = 0,
	@CronExpression nvarchar(30) = '',
	@MailFrom nvarchar(1000) = '',
	@MailTo nvarchar(1000) = '',
	@MailCc nvarchar(1000) = '',
	@MailBcc nvarchar(1000) = '',
	@IsActive bit = 0,
	@StartOn date = NULL,
	@EndOn date = NULL,
	@Attempt int = 0,
	@Interval int = 0,
	@Description nvarchar(500) = '',
	@ErrCode int = 0 output,
	@ErrMsg nvarchar(1000) = '' output
AS
BEGIN
	SET NOCOUNT ON
	SET @MailName = ISNULL(@MailName, '')
	SET @MailTo = ISNULL(@MailTo, '')
	IF @MailName = ''
	BEGIN
		SET @ErrCode = 31
		SET @ErrMsg = 'Mail Name cannot be empty.'
		RETURN;
	END
	
	IF @MailTo = ''
	BEGIN
		SET @ErrCode = 34
		SET @ErrMsg = 'Mail To cannot be empty.'
		RETURN;
	END
	
	IF EXISTS (SELECT 1 FROM dbo.Mail WHERE MailName = @MailName)
	BEGIN
		SET @ErrCode = 27
		SET @ErrMsg = 'The Mail name already exists, please enter other Mail name!'
		RETURN;
	END
	
	--If is schedule mail
	IF @TriggerType = 1
	-- Insert Mail Schedule first
	BEGIN
		DECLARE @ScheduleID int
		INSERT INTO MailSchedule VALUES(
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
	ELSE
	BEGIN
		SET @ScheduleID = NULL
	END
	
	-- Insert Mail 
	INSERT INTO Mail VALUES(
		@MailName,
		@MailGroupID,
		@SiteID,
		@TriggerType,
		@ScheduleID,
		@MailFrom,
		NULL,
		@IsActive,
		@Description,
		NULL
		)
		
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 2
		SET @ErrMsg = 'Insert to Mail failed.'
		RETURN;
	END
	
	DECLARE @MailID int,
			@MailType int,
			@EmailID int,
			@CommaIndex int
	SET @MailID = SCOPE_IDENTITY()
	
	-- Insert Email To Mail
	
	-- MailType = 0: MailTo
	IF LEN(@MailTo) <>0
	BEGIN
		SET @MailType = 0
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
			PRINT @EmailID
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
	IF LEN(@MailCc) <>0
	BEGIN
		SET @MailType = 1
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
	IF LEN(@MailBcc) <>0
	BEGIN
		SET @MailType = 2
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
	
	SET @ErrCode = 0
	SET @ErrMsg = ''
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_InsertMail] TO [bodbAdminNet]
GO 
