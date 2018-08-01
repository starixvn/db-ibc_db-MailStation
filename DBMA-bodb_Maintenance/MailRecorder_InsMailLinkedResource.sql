
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.MailRecorder_InsMailLinkedResource    Script Date: 2018-07-30 06:19:32 AM ******/



CREATE PROCEDURE [dbo].[MailRecorder_InsMailLinkedResource]
	@MailID bigint,
	@FileName nvarchar(250),	
	@ImageType nvarchar(100),
	@ContentCID nvarchar(100),
	@StreamContent image,
	@LinkedID int =0 output,
	@ErrCode int = 0 Output,
	@ErrMsg nvarchar(200) = '' Output
AS
/*
Created: 09/29/2011@Bobby
Task : Insert new mail linked resource
DB: DB06.[dbo].[MailRecorder_MailLinkedResource]
Original:
	
Param's Explanation:

*/
SET NOCOUNT ON
IF @MailID > 0
BEGIN
	INSERT INTO [dbo].[Mail_LinkedResource]([MailID], [FileName], [ImageType], [ContentCID], [StreamContent])
	VALUES (@MailID, N''+@FileName+'', @ImageType, @ContentCID, @StreamContent)

	IF @@Error <> 0
	BEGIN			
		SELECT @ErrMsg = 'Error! Error when inserting mail linked resource', @ErrCode = 101			
		RETURN
	END
	SELECT @LinkedID = @@IDENTITY
END


--SELECT GETDATE() AS CurrentDateTime


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[MailRecorder_InsMailLinkedResource] TO [bodbAdminNet]
GO 
