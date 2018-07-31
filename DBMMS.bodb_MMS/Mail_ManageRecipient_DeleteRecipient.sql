
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_ManageRecipient_DeleteRecipient    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Andy.Nguyen
-- Create date: 2015-03-30
-- Description:	Delete Recipients.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_ManageRecipient_DeleteRecipient]
	@RecipientID int,
	@ErrCode int = 0 OUTPUT,
	@ErrMsg varchar(1000)  = '' OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS(SELECT EmailID FROM Mail_Email WITH (NOLOCK) WHERE EmailID IN (SELECT EmailID FROM Email WITH (NOLOCK) WHERE RecipientID = @RecipientID))
	BEGIN
		SET @ErrCode = 42
		SET @ErrMsg = 'Cannot delete, because there are Mails related to Recipient in auto mail scheduled.'

		RETURN
	END
	
	DELETE FROM Email 
		WITH (ROWLOCK)
	WHERE RecipientID = @RecipientID

	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 40
		SET @ErrMsg = 'Cannot delete Email related to Recipients.<br />' + ERROR_MESSAGE()

		RETURN
	END

	DELETE FROM MailRecipient 
		WITH (ROWLOCK)
	WHERE RecipientID = @RecipientID

	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 41
		SET @ErrMsg = 'Cannot delete MailRecipient.<br />' + ERROR_MESSAGE()

		RETURN
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_ManageRecipient_DeleteRecipient] TO [bodbAdminNet]
GO 
