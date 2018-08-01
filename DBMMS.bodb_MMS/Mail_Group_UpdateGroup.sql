
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Group_UpdateGroup    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Update Group
-- Revision:    Andy.Nguyen -> Donot allow update in case of duplicated with another one.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Group_UpdateGroup]
	@MailGroupID int,
	@MailGroupName varchar(50) = '',
	@Description varchar(500) = '',
	@ErrCode int output,
	@ErrMsg nvarchar(1000) output
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @OldGroup varchar(50)
	DECLARE @OldDesc varchar(500)

	SELECT @OldGroup = MailGroupName, @OldDesc = [Description] FROM MailGroup WITH (NOLOCK) WHERE MailGroupID = @MailGroupID
	SET @MailGroupName = ISNULL(@MailGroupName, '')
	SET @Description = ISNULL(@Description, '')
	IF @MailGroupName = ''
	BEGIN
		SET @ErrCode = 33
		SET @ErrMsg = 'The group name cannot be empty, please try again!'
		RETURN;
	END
	
	IF EXISTS (SELECT 1 FROM MailGroup WITH (NOLOCK) WHERE MailGroupID = @MailGroupID)
	BEGIN
		IF @OldGroup <> @MailGroupName
		BEGIN
			IF EXISTS (SELECT 1 FROM MailGroup WITH (NOLOCK) WHERE MailGroupName = @MailGroupName)
			BEGIN
				SET @ErrCode = 38
				SET @ErrMsg = 'This Group is existed, please input another name.'
				RETURN;
			END
		END

		UPDATE MailGroup 
		SET MailGroupName = @MailGroupName,
			[Description] = @Description
		WHERE MailGroupID = @MailGroupID
				
		IF @@ERROR <> 0
		BEGIN
			SET @ErrCode = 36
			SET @ErrMsg = 'Update Mail Group failed.'
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
 GRANT EXECUTE ON [dbo].[Mail_Group_UpdateGroup] TO [bodbAdminNet]
GO 
