
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_InsertMailLogs    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Insert Mail Log
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_InsertMailLogs]
	@TaskID int,
	@ExceptionMessage varchar(500) = '',
	@InnerMessage varchar(500) = '',
	@StackTrace varchar(1000) = '',
	@Status int = 0,
	@LogTime varchar(50) = '',
	@ErrCode int = 0 output,
	@ErrMsg nvarchar(1000) = '' output
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO MailTaskLog VALUES(
		@TaskID,
		@ExceptionMessage,
		@InnerMessage,
		@StackTrace,
		@Status,
		@LogTime
	)
	
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 24
		SET @ErrMsg = 'Insert to Mail Task Log failed.'
		RETURN;
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Core_InsertMailLogs] TO [bodbAdminNet]
GO 
