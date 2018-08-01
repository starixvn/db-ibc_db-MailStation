
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Group_InsertGroup    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Insert Group
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Group_InsertGroup]
	@MailGroupName varchar(50) = '',
	@Description varchar(500) = '',
	@ErrCode int output,
	@ErrMsg nvarchar(1000) output
AS
BEGIN
	SET NOCOUNT ON
	SET @MailGroupName = ISNULL(@MailGroupName, '')
	
	IF @MailGroupName = ''
	BEGIN
		SET @ErrCode = 33
		SET @ErrMsg = 'The group name cannot be empty, please try again!'
		RETURN;
	END
	
	IF EXISTS (SELECT 1 FROM MailGroup WITH (NOLOCK) WHERE MailGroupName = @MailGroupName)
	BEGIN
		SET @ErrCode = 25
		SET @ErrMsg = 'The group exists, please try again!'
		RETURN;
	END
	ELSE
	BEGIN
		INSERT INTO MailGroup VALUES(@MailGroupName, @Description)
		IF @@ERROR <> 0
		BEGIN
			SET @ErrCode = 7
			SET @ErrMsg = 'Insert to Mail Group failed.'
			RETURN;
		END
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Group_InsertGroup] TO [bodbAdminNet]
GO 
