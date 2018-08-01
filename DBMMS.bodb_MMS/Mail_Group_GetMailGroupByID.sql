
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Group_GetMailGroupByID    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Get Mail Group By ID
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Group_GetMailGroupByID]
	@MailGroupID as int
AS
BEGIN
	SET NOCOUNT ON
	SELECT MailGroupID, MailGroupName, [Description]
	FROM dbo.MailGroup
	WHERE MailGroupID = @MailGroupID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Group_GetMailGroupByID] TO [bodbAdminNet]
GO 
