
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_UpdateMailTaskMSiteMailID    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Update Mail Task's MSiteMailRecordID
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_UpdateMailTaskMSiteMailID]
	@TaskID int,
	@MSiteMailID bigint,
	@ErrCode int output,
	@ErrMsg nvarchar(1000) output
AS
BEGIN
	SET NOCOUNT ON
	UPDATE dbo.MailTask
	SET MSiteMailID = @MsiteMailID
	WHERE TaskID = @TaskID
	
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 35
		SET @ErrMsg = 'Update MSiteMailID failed.'
		RETURN;
	END
END


SELECT CONVERT (DATETIME, NULL)

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Core_UpdateMailTaskMSiteMailID] TO [bodbAdminNet]
GO 
