
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_ManageRecipient_InsertRecipient    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-21
-- Description:	Insert Recipients
-- =============================================
CREATE PROCEDURE [dbo].[Mail_ManageRecipient_InsertRecipient]
	@RecipientName varchar(50) = '',
	@Email1 varchar(100) = '',
	@Email2 varchar(100) = '',
	@Email3 varchar(100) = '',
	@Note varchar(100) = '',
	@IsActive bit = 0,
	@IsNAPUser bit = 0,
	@NAPUserID int = 0,
	@ErrCode int = 0 output,
	@ErrMsg varchar(100) = '' output
AS
BEGIN
	SET NOCOUNT ON
	SET @RecipientName = ISNULL(@RecipientName, '')
	SET @Email1 = ISNULL(@Email1, '')
	SET @Email2 = ISNULL(@Email2, '')
	SET @Email3 = ISNULL(@Email3, '')

	IF @Email1 = ''
	BEGIN
		SET @ErrCode = 32	
		SET @ErrMsg = 'Field email1 is required.'
		RETURN
	END

	IF @Email1 = @Email2 AND @Email1 <> '' AND @Email2 <> ''
	BEGIN
		SET @ErrCode = 17
		SET @ErrMsg = 'Email1 and email2 is duplicated.'
		RETURN
	END
	
	IF @Email1 = @Email3 AND @Email1 <> '' AND @Email3 <> ''
	BEGIN
		SET @ErrCode = 18
		SET @ErrMsg = 'Email1 and email3 is duplicated.'
		RETURN
	END

	IF @Email2 = @Email3 AND @Email2 <> '' AND @Email3 <> ''
	BEGIN
		SET @ErrCode = 19
		SET @ErrMsg = 'Email2 and email3 is duplicated.'
		RETURN
	END

	IF @RecipientName <> '' AND EXISTS (SELECT 1 FROM MailRecipient WHERE RecipientName = @RecipientName)
	BEGIN
		SET @ErrCode = 9
		SET @ErrMsg = 'Recipient is existed.'
		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM Email WHERE EmailAddress = @Email1)
	BEGIN
		SET @ErrCode = 10
		SET @ErrMsg = 'Email1 is existed.'
		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM Email WHERE EmailAddress = @Email2)
	BEGIN
		SET @ErrCode = 11
		SET @ErrMsg = 'Email2 is existed.'
		RETURN
	END
	
	IF EXISTS (SELECT 1 FROM Email WHERE EmailAddress = @Email3)
	BEGIN
		SET @ErrCode = 12
		SET @ErrMsg = 'Email3 is existed.'
		RETURN
	END
	
	
	
	INSERT INTO MailRecipient VALUES(
		@RecipientName,
		@IsNapUser,
		@IsActive,
		@Note,
		@NAPUserID
	)
	
	IF @@ERROR <> 0 
	BEGIN
		SET @ErrCode = 13
		SET @ErrMsg = 'Insert to Mail Recipient failed.'
		RETURN
	END
	
	DECLARE @RecipientID int
	SET @RecipientID = SCOPE_IDENTITY()
	
	IF @Email1 <> ''
	BEGIN
		INSERT INTO Email Values (
			@Email1,
			@RecipientID
		)
		
		IF @@ERROR <> 0 
		BEGIN
			SET @ErrCode = 14
			SET @ErrMsg = 'Insert Email1 to Email failed.'
			RETURN
		END
	END
	
	IF @Email2 <> ''
	BEGIN
		INSERT INTO Email Values (
			@Email2,
			@RecipientID
		)
		
		IF @@ERROR <> 0 
		BEGIN
			SET @ErrCode = 15
			SET @ErrMsg = 'Insert Email2 to Email failed.'
			RETURN
		END
	END
	
	IF @Email3 <> ''
	BEGIN
		INSERT INTO Email Values (
			@Email3,
			@RecipientID
		)
		
		IF @@ERROR <> 0 
		BEGIN
			SET @ErrCode = 16
			SET @ErrMsg = 'Insert Email3 to Email failed.'
			RETURN
		END
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_ManageRecipient_InsertRecipient] TO [bodbAdminNet]
GO 
