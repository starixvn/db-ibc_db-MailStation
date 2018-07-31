
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  Stored Procedure dbo.Mail_ManageRecipient_GetRecipientByID    Script Date: 2018-07-30 06:19:42 AM ******/

-- =============================================
-- Author:		Phillip.Truong
-- Create date: 2014-11-21
-- Description:	Get Recipient By ID
-- Modified by: Andy.Nguyen
-- Revision:	Change process to update Email table to fix bug #32930.
-- =============================================
CREATE PROCEDURE [dbo].[Mail_ManageRecipient_GetRecipientByID]
	@RecipientID int
AS
BEGIN
	SET NOCOUNT ON
	/*
	DECLARE @TableEmailAddress as TABLE
	(
		RecipientID int
		,RecipientName varchar(50)
		,IsNAPUser bit
		,Email1 varchar(100)
		,Email2 varchar(100)
		,Email3 varchar(100)		
		,IsActive bit
		,Note varchar(300)
	)

	INSERT INTO @TableEmailAddress
	SELECT
		RecipientID
		,RecipientName
		,IsNAPUser
		,[1] Email1
		,[2] Email2
		,[3] Email3		
		,IsActive
		, Note
	FROM (
		SELECT 
			em.EmailAddress
			,mr.RecipientID 
			,mr.RecipientName
			,mr.IsNAPUser
			,mr.IsActive
			,mr.Note
			,mr.NapUserID
			,ROW_NUMBER() OVER (PARTITION BY mr.RecipientName ORDER BY mr.RecipientName) RowNum
			--,COUNT(m_em.MailID) MailRelevant
		FROM (Email em INNER JOIN MailRecipient mr ON em.RecipientID = mr.RecipientID)
			LEFT JOIN Mail_Email m_em ON em.EmailID = m_em.EmailID
		WHERE mr.RecipientID = @RecipientID
		GROUP BY em.EmailID, EmailAddress, mr.RecipientID, RecipientName, IsNAPUser, IsActive, Note, NapUserID		
	) as SourceTable
		PIVOT(MAX(EmailAddress) FOR RowNum IN ([1], [2], [3])) PivotTable
	ORDER BY RecipientName

	DECLARE @TableEmailID as TABLE
	(
		RecipientID int
		,EmailID1 int
		,EmailID2 int
		,EmailID3 int
	)

	INSERT INTO @TableEmailID
	SELECT
		RecipientID
		,[1] EmailID1
		,[2] EmailID2
		,[3] EmailID3
	FROM (
		SELECT 
			em.EmailID
			,mr.RecipientID 
			,ROW_NUMBER() OVER (PARTITION BY mr.RecipientID ORDER BY mr.RecipientID) RowNum
			--,COUNT(m_em.MailID) MailRelevant
		FROM (Email em INNER JOIN MailRecipient mr ON em.RecipientID = mr.RecipientID)
			LEFT JOIN Mail_Email m_em ON em.EmailID = m_em.EmailID
		WHERE mr.RecipientID = @RecipientID
		GROUP BY em.EmailID, mr.RecipientID
	) as SourceTable
		PIVOT(MAX(EmailID) FOR RowNum IN ([1], [2], [3])) PivotTable
	ORDER BY EmailID1 DESC, EmailID2 DESC, EmailID3 DESC


	SELECT
		ea.RecipientID
		,ea.RecipientName
		,ea.IsNAPUser
		,ei.EmailID1
		,ei.EmailID2
		,ei.EmailID3
		,ea.Email1
		,ea.Email2
		,ea.Email3		
		,ea.IsActive
		,ea.Note
	FROM
		@TableEmailAddress ea
		,@TableEmailID ei
END */
--[dbo].[Mail_ManageRecipient_GetRecipientByID] 14

--declare @RecipientID int

--set @RecipientID = 1

SELECT mr.RecipientID 
 ,mr.RecipientName
 ,(select EmailAddress from (select EmailAddress, ROW_NUMBER() OVER (PARTITION BY RecipientID ORDER BY EmailAddress) RowNum from email where RecipientID = @RecipientID) A WHERE RowNum = 1) Email1
 ,(select EmailAddress from (select EmailAddress, ROW_NUMBER() OVER (PARTITION BY RecipientID ORDER BY EmailAddress) RowNum from email where RecipientID = @RecipientID) A WHERE RowNum = 2) Email2
 ,(select EmailAddress from (select EmailAddress, ROW_NUMBER() OVER (PARTITION BY RecipientID ORDER BY EmailAddress) RowNum from email where RecipientID = @RecipientID) A WHERE RowNum = 3) Email3
 ,(select EmailID from (select EmailID, ROW_NUMBER() OVER (PARTITION BY RecipientID ORDER BY EmailID) RowNum from email where RecipientID = @RecipientID) A WHERE RowNum = 1) EmailID1
 ,(select EmailID from (select EmailID, ROW_NUMBER() OVER (PARTITION BY RecipientID ORDER BY EmailID) RowNum from email where RecipientID = @RecipientID) A WHERE RowNum = 2) EmailID2
 ,(select EmailID from (select EmailID, ROW_NUMBER() OVER (PARTITION BY RecipientID ORDER BY EmailID) RowNum from email where RecipientID = @RecipientID) A WHERE RowNum = 3) EmailID3
 ,mr.IsNAPUser
 ,mr.IsActive
 ,mr.Note
 ,mr.NapUserID
 ,COUNT(DISTINCT m_em.MailID) MailRelevant
FROM MailRecipient mr with (nolock)
 INNER JOIN Email em with (nolock) on mr.RecipientID = em.RecipientID 
 LEFT JOIN Mail_Email m_em ON em.EmailID = m_em.EmailID
WHERE mr.RecipientID = @RecipientID
GROUP BY mr.RecipientID, RecipientName, IsNAPUser, IsActive, Note, NapUserID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT EXECUTE ON [dbo].[Mail_ManageRecipient_GetRecipientByID] TO [bodbAdminNet]
GO 
