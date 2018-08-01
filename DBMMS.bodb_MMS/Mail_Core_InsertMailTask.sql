
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_InsertMailTask    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Insert Mail Task
-- Revision: 
--		- 2015-06-17: Move 'SET @MailTaskID = SCOPE_IDENTITY()' command line immediately after insert statement.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_InsertMailTask]
	@MailID int,
	@SiteID int,
	@ScheduledTime varchar(50) = '',
	@LastSent varchar(50) = '',
	@MSiteMailID bigint,
	@Status int,
	@Attempt int,
	@MailTaskID int output,
	@ErrCode int output,
	@ErrMsg nvarchar(1000) output
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO MailTask VALUES(
		@MailID,
		@SiteID,
		CONVERT(DATETIME, @ScheduledTime),
		CONVERT(DATETIME, @LastSent),
		@Status,
		@Attempt,
		@MSiteMailID,
		0
	)
	
	IF @@ERROR <> 0
	BEGIN
		SET @ErrCode = 22
		SET @ErrMsg = 'Insert to MailTask failed.'
		RETURN;
	END
	
	SET @MailTaskID = SCOPE_IDENTITY()
	DECLARE @TriggerType int
	SELECT @TriggerType = TriggerType
	FROM dbo.Mail
	WHERE MailID = @MailID
	
	IF @TriggerType = 0
	BEGIN
		UPDATE dbo.Mail
		SET LastSent = CONVERT(DATETIME, @LastSent)
		WHERE MailID = @MailID
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
 GRANT EXECUTE ON [dbo].[Mail_Core_InsertMailTask] TO [bodbAdminNet]
GO 
