
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_ManageRecipient_GetRecipientList    Script Date: 2018-07-30 06:19:42 AM ******/
-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-21
-- Description:	Get Recipients List
-- Modified by: Andy.Nguyen
-- Revision:    
--     2015-03-01: Fix bug related to number of relevant mails.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_ManageRecipient_GetRecipientList]
	@RecipientName varchar(50) = '',
	@Email varchar(1000) = '',
	@Status int = -1
AS
BEGIN
	SET NOCOUNT ON
	SET @RecipientName = ISNULL(@RecipientName, '')
	SET @Email = ISNULL(@Email, '')
	SET @Status = ISNULL(@Status, -1)
	DECLARE @MySourceTable TABLE (
		EmailAddress varchar(100)
		,RecipientID  int
		,RecipientName varchar(50)
		,IsNAPUser bit
		,IsActive bit
		,Note varchar(1000)
		,NapUserID bit
		,RowNum int
		,MailRelevant int)

	INSERT INTO @MySourceTable
	SELECT 
		DISTINCT(em.EmailAddress)
		,mr.RecipientID 
		,mr.RecipientName
		,mr.IsNAPUser
		,mr.IsActive
		,mr.Note
		,mr.NapUserID
		,ROW_NUMBER() OVER (PARTITION BY mr.RecipientID ORDER BY mr.RecipientID) RowNum
		,COUNT(DISTINCT(m_em.MailID)) MailRelevant
	FROM (Email em INNER JOIN MailRecipient mr ON em.RecipientID = mr.RecipientID)
		LEFT JOIN Mail_Email m_em ON em.EmailID = m_em.EmailID
	WHERE mr.RecipientName LIKE '%' + @RecipientName + '%'
		AND @Status = -1 OR IsActive = @Status
	GROUP BY EmailAddress, mr.RecipientID, RecipientName, IsNAPUser, IsActive, Note, NapUserID--, em.EmailID

	UPDATE @MySourceTable 
	SET MailRelevant = t2.MailRelevant
	FROM (@MySourceTable t1 INNER JOIN (
		SELECT RecipientID, SUM(MailRelevant) MailRelevant 
		FROM @MySourceTable
		GROUP BY RecipientID) t2 
		ON t1.RecipientID = t2.RecipientID)

	DECLARE @ResultTable TABLE (
		RecipientID int,
		RecipientName varchar(50),
		IsNapUser bit,
		Email1 varchar(100),
		Email2 varchar(100),
		Email3 varchar(100),
		MailRelevant int,
		IsActive bit,
		MarkedDelete bit
	)
	
	INSERT INTO @ResultTable
	SELECT
		RecipientID
		,RecipientName
		,IsNAPUser
		,[1] Email1
		,[2] Email2
		,[3] Email3
		,MailRelevant
		,IsActive
		,0 MarkedDelete
	FROM @MySourceTable as SourceTable
		PIVOT(MAX(EmailAddress) FOR RowNum IN ([1], [2], [3])) PivotTable
	ORDER BY RecipientName
	DECLARE @SemiColonIndex int,
			@MailAddress varchar(100),
			@TextLength varchar(500)
	
	IF LEN(@Email)>0
	BEGIN
		UPDATE @ResultTable SET MarkedDelete = 1
	END
			
	WHILE LEN (@Email) <> 0
	BEGIN
		
		SET @SemiColonIndex = CHARINDEX(',', @Email)
		IF @SemiColonIndex = 0
		BEGIN
			SET @MailAddress = @Email
			SET @Email = ''
		END
		ELSE
		BEGIN
			SET @MailAddress = SUBSTRING(@Email, 1, @SemiColonIndex - 1)
			SET @Email = SUBSTRING(@Email, @SemiColonIndex + 1, LEN(@Email))
		END
		
		UPDATE @ResultTable
		SET MarkedDelete = 0
		WHERE MarkedDelete = 1
			AND( Email1 LIKE '%' + RTRIM(LTRIM(@MailAddress)) + '%'
			OR Email2 LIKE '%' + RTRIM(LTRIM(@MailAddress)) + '%'
			OR Email3 LIKE '%' + RTRIM(LTRIM(@MailAddress)) + '%')
	END
	
	SELECT 
		rs.RecipientID
		,rs.RecipientName
		,rs.IsNAPUser
		,e1.EmailID EmailID1
		,rs.Email1
		,e2.EmailID EmailID2
		,rs.Email2
		,e3.EmailID EmailID3
		,rs.Email3
		,rs.MailRelevant
		,rs.IsActive 
	FROM @ResultTable rs
			LEFT JOIN dbo.Email e1 WITH (NOLOCK)
			ON rs.Email1 = e1.EmailAddress
			LEFT JOIN dbo.Email e2 WITH (NOLOCK)
			ON rs.Email2 = e2.EmailAddress
			LEFT JOIN dbo.Email e3 WITH (NOLOCK)
			ON rs.Email3 = e3.EmailAddress
	WHERE MarkedDelete = 0
	ORDER BY RecipientID
	
END



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_ManageRecipient_GetRecipientList] TO [bodbAdminNet]
GO 
