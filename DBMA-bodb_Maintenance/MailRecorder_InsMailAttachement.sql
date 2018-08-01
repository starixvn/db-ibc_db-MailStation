
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_InsMailAttachement    Script Date: 2018-07-30 06:19:30 AM ******/


CREATE PROCEDURE [dbo].[MailRecorder_InsMailAttachement]
	@MailID bigint,
	@FileName nvarchar(250),	
	@ContentType nvarchar(100),
	@Content image,
	@AttachmentID int =0 output,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
AS
/*
Created: 09/29/2011@Bobby
Task : Insert new mail record
DB: DB06.[dbo].[MailRecorder_InsMailAttachement]
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
IF @MailID > 0
BEGIN
	INSERT INTO [dbo].[Mail_Attachment]([MailID], [FileName],[ContentType], [Content])
	VALUES (@MailID, N''+@FileName+'', @ContentType, @Content)

	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when inserting mail attachment;', @ErrCode = 101			
		RETURN
	END
	SELECT @AttachmentID = @@IDENTITY
END





GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_InsMailAttachement] TO [bodbAdminNet]
GO 
