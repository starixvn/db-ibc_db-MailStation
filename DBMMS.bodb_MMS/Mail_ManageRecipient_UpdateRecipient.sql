
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_ManageRecipient_UpdateRecipient    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-21
-- Description:	Check Existed Recipient
-- Modified by: Andy.Nguyen
-- Revision:	Change process to update Email table to fix bug #32930.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_ManageRecipient_UpdateRecipient]
	@RecipientID int,
	@RecipientName varchar(50) = '',
	@EmailID1 int = 0,
	@EmailID2 int = 0,
	@EmailID3 int = 0,
	@Email1 varchar(100) = '',
	@Email2 varchar(100) = '',
	@Email3 varchar(100) = '',
	@Note varchar(100) = '',
	@IsActive bit = 0,
	@ErrCode int = 0 output,
	@ErrMsg varchar(100) = '' output
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @OldRecipient varchar(50)

	IF @Email1 = ''
	BEGIN
		SET @ErrCode = 33	
		SET @ErrMsg = 'Field email1 is required.'
		RETURN
	END

	IF @Email1 = @Email2 AND @Email1 <> '' AND @Email2 <> ''
	BEGIN
		SET @ErrCode = 34
		SET @ErrMsg = 'Email1 and email2 is duplicated.'
		RETURN
	END
	
	IF @Email1 = @Email3 AND @Email1 <> '' AND @Email3 <> ''
	BEGIN
		SET @ErrCode = 35
		SET @ErrMsg = 'Email1 and email3 is duplicated.'
		RETURN
	END

	IF @Email2 = @Email3 AND @Email2 <> '' AND @Email3 <> ''
	BEGIN
		SET @ErrCode = 36
		SET @ErrMsg = 'Email2 and email3 is duplicated.'
		RETURN
	END

	SELECT @OldRecipient = RecipientName FROM MailRecipient WITH(NOLOCK) WHERE RecipientID = @RecipientID

	IF NOT EXISTS (SELECT 1 FROM MailRecipient WHERE RecipientID = @RecipientID)
	BEGIN
		SET @ErrCode = 17
		SET @ErrMsg = 'RecipientID is not existed.'

		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM Email WHERE EmailAddress = @Email1 AND RecipientID <> @RecipientID)
	BEGIN
		SET @ErrCode = 18
		SET @ErrMsg = 'Email1 is in use by another Recipient.'

		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM Email WHERE EmailAddress = @Email2 AND RecipientID <> @RecipientID)
	BEGIN
		SET @ErrCode = 19
		SET @ErrMsg = 'Email2 is in use by another Recipient.'

		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM Email WHERE EmailAddress = @Email3 AND RecipientID <> @RecipientID)
	BEGIN
		SET @ErrCode = 20
		SET @ErrMsg = 'Email3 is in use by another Recipient.'

		RETURN
	END
	
	IF @Email1 = '' AND @Email2 = '' AND @Email3 = ''
	BEGIN
		SET @ErrCode = 32	
		SET @ErrMsg = 'Please input at least 1 valid email.'

		RETURN
	END
	
	IF @OldRecipient <> @RecipientName
	BEGIN
		IF EXISTS (SELECT 1 FROM MailRecipient WITH (NOLOCK) WHERE RecipientName = @RecipientName AND @RecipientName <> '')
		BEGIN
			SET @ErrCode = 31
			SET @ErrMsg = 'This Recipient is existed, please input another name.'

			RETURN
		END
	END

	UPDATE MailRecipient 
	SET Note = @Note,
		IsActive = @IsActive,
		RecipientName = @RecipientName
	WHERE RecipientID = @RecipientID
	
	IF @@ERROR <> 0 
	BEGIN
		SET @ErrCode = 21
		SET @ErrMsg = 'Update Recipient failed.'

		RETURN
	END
	
	-- Email1 is input
	IF @Email1 <> ''
	BEGIN
		IF @EmailID1 <> 0 -- Email1 need to update
		BEGIN
			UPDATE Email WITH(ROWLOCK)
			SET EmailAddress = @Email1
			WHERE EmailID = @EmailID1

			IF @@ERROR <> 0 
			BEGIN				
				SET @ErrCode = 22
				SET @ErrMsg = 'Update Email1 into table Email failed.'

				RETURN
			END
		END
		ELSE -- Email1 need to insert
		BEGIN
			INSERT INTO Email(EmailAddress, RecipientID)
			VALUES(@Email1, @RecipientID)

			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 23
				SET @ErrMsg = 'Insert Email1 into table Email failed.'
				
				RETURN
			END
		END
	END
	ELSE -- Email1 is removed or not input
	BEGIN
		IF @EmailID1 <> 0 -- Email1 is removed
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Mail_Email WHERE EmailID = @EmailID1)			
			BEGIN
				DELETE FROM Email WITH(ROWLOCK)
				WHERE EmailID = @EmailID1

				IF @@ERROR <> 0
				BEGIN
					SET @ErrCode = 24
					SET @ErrMsg = 'Remove Email1 out of table Email failed.'

					RETURN
				END
			END
			ELSE
			BEGIN
				SET @ErrCode = 241
				SET @ErrMsg = 'Cannot remove email1, because this email related to auto mail scheduled.'

				RETURN
			END
		END
	END

	-- Email2 is input
	IF @Email2 <> ''
	BEGIN
		IF @EmailID2 <> 0 -- Email2 need to update
		BEGIN
			UPDATE Email WITH(ROWLOCK)
			SET EmailAddress = @Email2
			WHERE EmailID = @EmailID2

			IF @@ERROR <> 0 
			BEGIN				
				SET @ErrCode = 25
				SET @ErrMsg = 'Update Email2 into table Email failed.'

				RETURN
			END
		END
		ELSE -- Email2 need to insert
		BEGIN
			INSERT INTO Email(EmailAddress, RecipientID)
			VALUES(@Email2, @RecipientID)

			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 26
				SET @ErrMsg = 'Insert Email2 into table Email failed.'
				
				RETURN
			END
		END
	END
	ELSE -- Email2 is removed or not input
	BEGIN
		IF @EmailID2 <> 0 -- Email2 is removed
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Mail_Email WHERE EmailID = @EmailID2)			
			BEGIN
				DELETE FROM Email WITH(ROWLOCK)
				WHERE EmailID = @EmailID2

				IF @@ERROR <> 0
				BEGIN
					SET @ErrCode = 27
					SET @ErrMsg = 'Remove Email2 out of table Email failed.'

					RETURN
				END
			END
			ELSE
			BEGIN
				SET @ErrCode = 271
				SET @ErrMsg = 'Cannot remove Email2, because this email related to auto mail scheduled.'

				RETURN
			END
		END
	END

	-- Email3 is input
	IF @Email3 <> ''
	BEGIN
		IF @EmailID3 <> 0 -- Email3 need to update
		BEGIN
			UPDATE Email WITH(ROWLOCK)
			SET EmailAddress = @Email3
			WHERE EmailID = @EmailID3

			IF @@ERROR <> 0 
			BEGIN				
				SET @ErrCode = 28
				SET @ErrMsg = 'Update Email3 into table Email failed.'

				RETURN
			END
		END
		ELSE -- Email3 need to insert
		BEGIN
			INSERT INTO Email(EmailAddress, RecipientID)
			VALUES(@Email3, @RecipientID)

			IF @@ERROR <> 0
			BEGIN
				SET @ErrCode = 29
				SET @ErrMsg = 'Insert Email3 into table Email failed.'
				
				RETURN
			END
		END
	END
	ELSE -- Email3 is removed or not input
	BEGIN
		IF @EmailID3 <> 0 -- Email3 is removed
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Mail_Email WHERE EmailID = @EmailID3)			
			BEGIN
				DELETE FROM Email WITH(ROWLOCK)
				WHERE EmailID = @EmailID3

				IF @@ERROR <> 0
				BEGIN
					SET @ErrCode = 30
					SET @ErrMsg = 'Remove Email3 out of table Email failed.'

					RETURN
				END
			END
			ELSE
			BEGIN
				SET @ErrCode = 301
				SET @ErrMsg = 'Cannot remove email3, because this email related to auto mail scheduled.'

				RETURN
			END
		END
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_ManageRecipient_UpdateRecipient] TO [bodbAdminNet]
GO 
