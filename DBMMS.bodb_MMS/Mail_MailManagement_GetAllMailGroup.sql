
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_GetAllMailGroup    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Get All Mail Group
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_GetAllMailGroup]
AS
BEGIN
	SET NOCOUNT ON
	SELECT MailGroupID, MailGroupName
	FROM dbo.MailGroup
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_GetAllMailGroup] TO [bodbAdminNet]
GO 
