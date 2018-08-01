
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_UpdateCountSent    Script Date: 2018-07-30 06:19:31 AM ******/






CREATE PROCEDURE [dbo].[MailRecorder_UpdateCountSent]		
	@MailID bigint,	
	@Option int = 0,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
	
AS
/*
Created: 09/29/2011@Bobby
Task : Insert new mail configuration
DB: DB06.bodb_Maintenance
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
IF @Option > 0
BEGIN
	UPDATE dbo.Mail_Record
	SET CountSend = CountSend + @Option
	WHERE MailID=@MailID
	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when updating count mail.', @ErrCode = 101			
		RETURN
	END
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_UpdateCountSent] TO [bodbAdminNet]
GO 
