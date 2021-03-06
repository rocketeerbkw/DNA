CREATE PROCEDURE getbannedemailsstartingwithletter @skip int, @show int, @letter varchar(1), @showsigninbanned bit, @showcomplaintbanned bit, @showall bit
AS

EXEC openemailaddresskey;

-- Decrypted all the banned emails is one shotm rather than multiple times in the CTE
SELECT * INTO #BannedEmails FROM dbo.BannedEmails
ALTER TABLE #BannedEmails ADD Email varchar(255)
UPDATE #BannedEmails SET Email = dbo.udf_decryptemailaddress(EncryptedEmail,0);

WITH EMailsCTE AS
(
	SELECT (ROW_NUMBER() OVER (ORDER BY EMail) - 1) AS 'Row', EMail, DateAdded, EditorID, SignInBanned, ComplaintBanned
		FROM #BannedEmails WITH(NOLOCK)
			WHERE EMail LIKE @letter + '%'
			AND
			(
				(
					((SignInBanned | ComplaintBanned = 1) AND (@showsigninbanned = 1 OR @showcomplaintbanned = 1))
					AND (@showsigninbanned = SignInBanned OR @showcomplaintbanned = ComplaintBanned)
				)
				OR
				(
					(SignInBanned | ComplaintBanned = 0) AND (@showsigninbanned | @showcomplaintbanned = 0)
				)
				OR
					@showall = 1
			)
)
SELECT (SELECT COUNT(*) FROM EMailsCTE) 'total', be.Row, be.EMail, be.DateAdded, be.EditorID, 'EditorName' = u.Username, be.SignInBanned, be.ComplaintBanned
	FROM EMailsCTE be WITH(NOLOCK)
	INNER JOIN dbo.Users u WITH(NOLOCK) ON u.UserID = be.EditorID
		WHERE be.Row BETWEEN @skip
			AND (@skip + @show - 1)
	ORDER BY be.Row