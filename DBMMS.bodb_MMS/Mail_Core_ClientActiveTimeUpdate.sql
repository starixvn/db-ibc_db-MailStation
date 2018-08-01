
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_Core_ClientActiveTimeUpdate    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2015-07-30
-- Description:	Update Client's Active Time. Every period of time, client will report that they're alive.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_Core_ClientActiveTimeUpdate]
	@MailIDs varchar(500) = ''
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON
	
	IF @MailIDs <> ''
	BEGIN
		DECLARE @x XML 
		SELECT @x = CAST('<A>'+ REPLACE(@MailIDs,',','</A><A>')+ '</A>' AS XML)
		
		UPDATE dbo.Mail
		SET LastActive = CURRENT_TIMESTAMP
		WHERE MailID IN (
				SELECT t.value('.', 'int') AS MailID
				FROM @x.nodes('/A') AS x(t)
			)
	END
	
END


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_Core_ClientActiveTimeUpdate] TO [bodbAdminNet]
GO 
