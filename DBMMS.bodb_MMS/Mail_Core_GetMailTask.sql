
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_GetMailTask    Script Date: 2018-07-30 06:19:43 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2015-05-11
-- Description:	Get Mail Task.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_GetMailTask]
	@MailTaskID int
AS
BEGIN
	SET NOCOUNT ON
	SELECT *
	FROM MailTask
	WHERE TaskID = @MailTaskID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Core_GetMailTask] TO [bodbAdminNet]
GO 
