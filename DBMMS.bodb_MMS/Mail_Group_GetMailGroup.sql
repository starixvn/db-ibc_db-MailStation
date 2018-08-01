
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Group_GetMailGroup    Script Date: 2018-07-30 06:19:41 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Get All Mail Group
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Group_GetMailGroup]
	@MailGroupName as varchar(500) = ''
AS
BEGIN
	SET NOCOUNT ON
	SET @MailGroupName = ISNULL(@MailGroupName, '')
	
	SELECT mg.MailGroupID, mg.MailGroupName, mg.[Description], COUNT(m.MailID) MailRelevantCount
	FROM dbo.MailGroup mg WITH(NOLOCK) LEFT OUTER JOIN dbo.Mail m WITH (NOLOCK) ON mg.MailGroupID = m. MailGroupID
	WHERE MailGroupName LIKE '%' + @MailGroupName + '%'
	GROUP BY mg.MailGroupID, mg.MailGroupName, mg.[Description]
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Group_GetMailGroup] TO [bodbAdminNet]
GO 
