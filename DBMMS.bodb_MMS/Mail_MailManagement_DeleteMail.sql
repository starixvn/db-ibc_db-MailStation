
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_DeleteMail    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-18
-- Description:	Delete Mail
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_DeleteMail]
	@MailID int,
	@ErrCode int output,
	@ErrMsg nvarchar(1000) output
AS
BEGIN
	SET NOCOUNT ON
	-- Delete all Email Reference
	DELETE FROM dbo.Mail_Email WHERE MailID = @MailID
	
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 5
		SET @ErrMsg = 'Cannot delete old Reference Emails.'
		RETURN;
	END
	
	DELETE FROM dbo.MailSchedule WHERE ScheduleID = (SELECT ScheduleID FROM dbo.Mail WHERE MailID = @MailID)
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 30
		SET @ErrMsg = 'Delete Mail Schedule failed.'
		RETURN;
	END
	
	DELETE FROM dbo.Mail WHERE MailID = @MailID
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 6
		SET @ErrMsg = 'Delete Mail failed.'
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
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_DeleteMail] TO [bodbAdminNet]
GO 
