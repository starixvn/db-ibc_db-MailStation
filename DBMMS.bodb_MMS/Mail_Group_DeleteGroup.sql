
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Group_DeleteGroup    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Delete Group
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Group_DeleteGroup]
	@MailGroupID int,
	@ErrCode int output,
	@ErrMsg nvarchar(1000) output
AS
BEGIN
	SET NOCOUNT ON
	IF(@MailGroupID = 1)
	BEGIN
		SET @ErrCode = 39
		SET @ErrMsg = 'Cannot delete default group.'
		RETURN;
	END
	
	IF EXISTS (SELECT 1 FROM MailGroup WITH (NOLOCK) WHERE MailGroupID = @MailGroupID)
	BEGIN
		-- Move all relevant Mails to [Others] Group
		UPDATE dbo.Mail
		SET MailGroupID = 1
		WHERE MailID IN (SELECT MailID FROM dbo.Mail WITH (NOLOCK) WHERE MailGroupID = @MailGroupID)
	
		DELETE MailGroup
		WHERE MailGroupID = @MailGroupID
		IF @@ERROR <> 0
		BEGIN
			SET @ErrCode = 38
			SET @ErrMsg = 'Delete Mail Group failed.'
			RETURN;
		END
	END
	ELSE
	BEGIN
		SET @ErrCode = 37
		SET @ErrMsg = 'Mail Group is not existed.'
		RETURN;
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Group_DeleteGroup] TO [bodbAdminNet]
GO 
