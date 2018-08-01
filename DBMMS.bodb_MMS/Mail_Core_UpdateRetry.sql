
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_UpdateRetry    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-14
-- Description:	Update Retry count
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_UpdateRetry]
	@TaskID int,
	@RetryCount int,
	@ErrCode int = 0 output,
	@ErrMsg nvarchar(1000) = '' output
AS
BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS (SELECT 1 FROM dbo.MailTask WITH (NOLOCK) WHERE TaskID = @TaskID)
	BEGIN
		SET @ErrCode = 22
		SET @ErrMsg = 'Mail Task is not existed.'
		RETURN;
	END
	
	UPDATE dbo.MailTask
	SET Attempt = @RetryCount
	WHERE TaskID = @TaskID
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 32
		SET @ErrMsg = 'Update Retry count for Mail Task failed.'
		RETURN;
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
 GRANT EXECUTE ON [dbo].[Mail_Core_UpdateRetry] TO [bodbAdminNet]
GO 
