-- The big ones
sp_spaceused 'Users'
-- Users	2197244    	813280 KB	600064 KB	211696 KB	1520 KB
ALTER INDEX PK_Users ON Users REBUILD
-- Users	2197244    	560840 KB	349288 KB	210376 KB	1176 KB
-- Took 2m 58s, recovered 300Mb
GO
sp_spaceused 'ThreadMod'
--ThreadMod	16408745   	6200320 KB	2930616 KB	3142368 KB	127336 KB
ALTER INDEX PK_ThreadMod ON ThreadMod REBUILD
--ThreadMod	16408784   	3821152 KB	1802328 KB	1948856 KB	69968 KB
-- Took 15m 15s, recovered 2.5Gb
GO
sp_spaceused 'ThreadMod'
-- ThreadMod	16408784   	3821152 KB	1802328 KB	1948856 KB	69968 KB
ALTER INDEX IX_ThreadMod ON ThreadMod REBUILD
-- ThreadMod	16408784   	3759272 KB	1802328 KB	1926712 KB	30232 KB
-- Took 8m 49s, recovered 60Mb
GO

-- The small ones
-- Rebuild as many as you have time for...
ALTER INDEX IX_HierarchyNodeAlias_LinkNodeID ON HierarchyNodeAlias REBUILD
GO
ALTER INDEX IX_Groups_Name ON Groups REBUILD
GO
ALTER INDEX IX_Club_ClubForum ON Clubs REBUILD
GO
ALTER INDEX IX_Club_h2g2ID ON Clubs REBUILD
GO
ALTER INDEX UQ__VideoAsset__5AD34B32 ON VideoAsset REBUILD
GO
ALTER INDEX UQ__ContentSignifClu__10AEA248 ON ContentSignifClub REBUILD
GO
ALTER INDEX PK__RecentSearch__0E315CF9 ON RecentSearch REBUILD
GO
ALTER INDEX IX_FrontPageElements_ElementID ON FrontPageElements REBUILD
GO
ALTER INDEX PK_BannedEmails ON BannedEmails REBUILD
GO
ALTER INDEX IX_BannedEmails_DateAdded ON BannedEmails REBUILD
GO
ALTER INDEX PK_ClubVotes ON ClubVotes REBUILD
GO
ALTER INDEX IX_Topics_h2g2ID ON Topics REBUILD
GO
ALTER INDEX PK_ExternalURLs ON ExternalURLs REBUILD
GO
ALTER INDEX IX_ArticleMediaAsset ON ArticleMediaAsset REBUILD
GO
ALTER INDEX IX_MediaAssetArticle ON ArticleMediaAsset REBUILD
GO
ALTER INDEX PK_ThreadVotes ON ThreadVotes REBUILD
GO
ALTER INDEX PK_SiteOptions ON SiteOptions REBUILD
GO
ALTER INDEX PK_AcceptedRecommendations ON AcceptedRecommendations REBUILD
GO
ALTER INDEX PK_ScoutRecommendations ON ScoutRecommendations REBUILD
GO
ALTER INDEX IX_EmailAlertList_ListID ON EMailAlertList REBUILD
GO
ALTER INDEX PK__Nums__2C56BCBD ON Nums REBUILD
GO
ALTER INDEX PK_AlertGroups ON AlertGroups REBUILD
GO
ALTER INDEX IX_AlertGroups_Userid ON AlertGroups REBUILD
GO
ALTER INDEX PK_PostDuplicates ON PostDuplicates REBUILD
GO
ALTER INDEX PK_Profanities ON Profanities REBUILD
GO
ALTER INDEX IX_CommentForums_UID ON CommentForums REBUILD
GO
ALTER INDEX IX_Links_Unique ON Links REBUILD
GO
ALTER INDEX PK_Table1 ON ClubMemberActions REBUILD
GO
ALTER INDEX IX_CommentForums_Url ON CommentForums REBUILD
GO
ALTER INDEX IX_HierarchyClubMembersNodeIDClubID ON HierarchyClubMembers REBUILD
GO
ALTER INDEX IX_CommentForums ON CommentForums REBUILD
GO
ALTER INDEX PK_Clubs ON Clubs REBUILD
GO
ALTER INDEX IX_EmailAlertListMembers_ListID_ItemID_ItemType_NotifyType ON EMailAlertListMembers REBUILD
GO
ALTER INDEX IX_PhraseNameSpaces_PhraseIDNamespaceID ON PhraseNameSpaces REBUILD
GO
ALTER INDEX IX_HierarchyClubMembersClubIDNodeID ON HierarchyClubMembers REBUILD
GO
ALTER INDEX IX_MediaAssetLastUpdated ON MediaAsset REBUILD
GO
ALTER INDEX UniqueTag ON HierarchyThreadMembers REBUILD
GO
ALTER INDEX IX_KeyPhrases_Phrase ON KeyPhrases REBUILD
GO
ALTER INDEX PK_Links ON Links REBUILD
GO
ALTER INDEX IX_ThreadKeyPhrases_PhraseID ON ThreadKeyPhrases REBUILD
GO
ALTER INDEX IX_ArticleModIPAddress_BBCUID ON ArticleModIPAddress REBUILD
GO
ALTER INDEX IX_HierarchyUserMembers ON HierarchyUserMembers REBUILD
GO
ALTER INDEX IX_ArticleModIPAddress_IP ON ArticleModIPAddress REBUILD
GO
ALTER INDEX IX_Hierarchy_ParentID ON Hierarchy REBUILD
GO
ALTER INDEX IX_ThreadKeyPhrases ON ThreadKeyPhrases REBUILD
GO
ALTER INDEX IX_AssetKeyPhrase_PhraseID ON AssetKeyPhrases REBUILD
GO
ALTER INDEX IX_GroupMembers_GroupID ON GroupMembers REBUILD
GO
ALTER INDEX IX_MediaAssetCaption ON MediaAsset REBUILD
GO
ALTER INDEX PK_AssetIDPhraseID ON AssetKeyPhrases REBUILD
GO
ALTER INDEX PK_ContentSignifUser ON ContentSignifUser REBUILD
GO
ALTER INDEX IX_KeyArticles ON KeyArticles REBUILD
GO
ALTER INDEX IX_ThreadModIPAddress_BBCUID ON ThreadModIPAddress REBUILD
GO
ALTER INDEX IX_ForumPostCountAdjust ON ForumPostCountAdjust REBUILD
GO
ALTER INDEX IX_ThreadModIPAddress_IP ON ThreadModIPAddress REBUILD
GO
ALTER INDEX PK_PreModPostings ON PreModPostings REBUILD
GO
ALTER INDEX PK_ReviewFOrumMembers ON ReviewForumMembers REBUILD
GO
ALTER INDEX IX_HierarchyArticleMembers_NodeID ON HierarchyArticleMembers REBUILD
GO
ALTER INDEX IX_HierarchyArticleMembers_EntryID ON HierarchyArticleMembers REBUILD
GO
ALTER INDEX IX_ForumLastUpdated ON ForumLastUpdated REBUILD
GO
ALTER INDEX IX_ArticleKeyPhrasesNonVisible_PhraseNamespaceID ON ArticleKeyPhrasesNonVisible REBUILD
GO
ALTER INDEX IX_ArticleKeyPhrasesNonVisible_EntryID ON ArticleKeyPhrasesNonVisible REBUILD
GO
ALTER INDEX IX_ArticleKeyPhrasesNonVisible ON ArticleKeyPhrasesNonVisible REBUILD
GO
ALTER INDEX PK_NodeID ON Hierarchy REBUILD
GO
ALTER INDEX IX_ArticleMod_h2g2ID ON ArticleMod REBUILD
GO
ALTER INDEX IX_GroupMembers ON GroupMembers REBUILD
GO
ALTER INDEX PK_ArticleIndex_EntryID ON ArticleIndex REBUILD
GO
ALTER INDEX IX_Ancestors_AncestorID ON Ancestors REBUILD
GO
ALTER INDEX ModerationHomePage ON ArticleMod REBUILD
GO
ALTER INDEX IX_Ancestors ON Ancestors REBUILD
GO
ALTER INDEX IX_Researchers_UserID ON Researchers REBUILD
GO
ALTER INDEX PK_ArticleDuplicates_1 ON ArticleDuplicates REBUILD
GO
ALTER INDEX IX_Researchers ON Researchers REBUILD
GO
ALTER INDEX PK_UserLastPosted ON UserLastPosted REBUILD
GO
ALTER INDEX IX_Journal ON Users REBUILD
GO
ALTER INDEX IX_Users_TeamID ON Users REBUILD
GO
ALTER INDEX users0 ON Users REBUILD
GO
ALTER INDEX edithistory0 ON EditHistory REBUILD
GO
ALTER INDEX IX_VoteMembers ON VoteMembers REBUILD
GO
ALTER INDEX IX_ArticleIndex ON ArticleIndex REBUILD
GO
ALTER INDEX IX_ArticleKeyPhrases_PhraseNamespaceID ON ArticleKeyPhrases REBUILD
GO
ALTER INDEX IX_Users_Cookie ON Users REBUILD
GO
ALTER INDEX IX_ArticleKeyPhrases_EntryID ON ArticleKeyPhrases REBUILD
GO
ALTER INDEX IX_TeamMembers ON TeamMembers REBUILD
GO
ALTER INDEX PK_Table_1 ON Mastheads REBUILD
GO
ALTER INDEX IX_ArticleKeyPhrases ON ArticleKeyPhrases REBUILD
-- Space before: 80.55Gb
-- Space after: 79.04Gb
-- Recovered: 1.55Gb
-- Took 30m 19s
GO
