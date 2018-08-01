
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_MailManagement_GetSuggesionEmailList    Script Date: 2018-07-30 06:19:41 AM ******/
-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-19
-- Description:	Get Suggesion Emails List
-- Revision: 2015-03-27 @Andy: Get more field IsActive
-- =============================================
CREATE PROCEDURE [dbo].[Mail_MailManagement_GetSuggesionEmailList]
	@EmailAddress varchar(500) = ''
AS
BEGIN
	SET NOCOUNT ON
	SET @EmailAddress = ISNULL(@EmailAddress, '')
	SELECT 
		m.EmailID, 
		m.EmailAddress, 
		m.RecipientID, 
		mr.IsActive AS Active 
	FROM 
		dbo.Email m WITH (NOLOCK) INNER JOIN
		dbo.MailRecipient mr WITH (NOLOCK) ON
			m.RecipientID = mr.RecipientID
	WHERE m.EmailAddress LIKE '%' + @EmailAddress + '%'
	ORDER BY m.EmailAddress ASC
END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_MailManagement_GetSuggesionEmailList] TO [bodbAdminNet]
GO 
