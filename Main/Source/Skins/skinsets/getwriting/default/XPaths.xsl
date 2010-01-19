<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!-- All pages -->
	<xsl:variable name="test_fromedit" select="/H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1" />
	<xsl:variable name="test_fromeditselected" select="/H2G2/PARAMS/PARAM[NAME = 's_selected']/VALUE = 'edityes'" />
	<xsl:variable name="test_IsEditor" select="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR"/>
	<xsl:variable name="test_UserIsEditor" select="/H2G2/PAGE-OWNER/USER/GROUPS/EDITOR"/>
	 <xsl:variable name="test_onthefutureSiteID" select="/H2G2/SITE-LIST/SITE/@ID"/> 
	<xsl:variable name="test_lifecafeSiteID" select="/H2G2/SITE-LIST/SITE[NAME='getwriting']/@ID"/>
	<xsl:variable name="test_EditorOrModerator" select="/H2G2/VIEWING-USER/USER/GROUPS[EDITOR or MODERATOR]"/>
	<xsl:variable name="test_ViewingUsername" select="/H2G2/VIEWING-USER/USER/USERNAME"/>
	<xsl:variable name="test_ViewingUserNumber" select="/H2G2/VIEWING-USER/USER/USERID"/>
	<xsl:variable name="test_ViewingUser" select="/H2G2/VIEWING-USER/USER"/>
	<xsl:variable name="test_RegisterVisible" select="/H2G2/PAGEUI/REGISTER[@VISIBLE=1]"/>
	<xsl:variable name="test_MyspaceVisible" select="/H2G2/PAGEUI/MYHOME[@VISIBLE=1]"/>
	<xsl:variable name="test_LogoutVisible" select="/H2G2/PAGEUI/LOGOUT[@VISIBLE=1]"/>
	<xsl:variable name="test_EditPageVisible" select="/H2G2/PAGEUI/EDITPAGE[@VISIBLE=1]"/>
	<!-- Frontpage -->
	<xsl:variable name="test_Frontpage" select="/H2G2[@TYPE='FRONTPAGE']"/>
	<xsl:variable name="test_FrontpageEdit" select="/H2G2[@TYPE='FRONTPAGE-EDITOR']"/>
	<!-- Article page -->
	<xsl:variable name="test_ArticlePage" select="/H2G2[@TYPE='ARTICLE']"/>
	<xsl:variable name="test_ArticleStatus" select="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE"/>
	<xsl:variable name="test_ArticlePreview" select="/H2G2/ARTICLE-PREVIEW"/>
	<xsl:variable name="test_ArticleHasConversation" select="/H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD"/>
	<xsl:variable name="test_ShowEditLink" select="/H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1"/>
	<xsl:variable name="test_Hasreferences" select="/H2G2/ARTICLE/ARTICLEINFO/REFERENCES"/>
	<xsl:variable name="test_HasResearchers" select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/RESEARCHERS/USER"/>
	<xsl:variable name="test_RefHasEntries" select="boolean((/H2G2/ARTICLE/GUIDE//LINK[@H2G2=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES/ENTRYLINK/@H2G2]) or (/H2G2/ARTICLE/GUIDE//LINK[@DNAID=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES/ENTRYLINK/@H2G2]))"/>
	<xsl:variable name="test_RefHasUsers" select="boolean((/H2G2/ARTICLE/GUIDE//LINK[@H2G2=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS/USERLINK/@H2G2]) or (/H2G2/ARTICLE/GUIDE//LINK[@BIO=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS/USERLINK/@H2G2]))"/>
	<xsl:variable name="test_RefHasBBCSites" select="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK[starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')]/@UINDEX])"/>
	<xsl:variable name="test_RefHasNONBBCSites" select="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK[not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))]/@UINDEX])"/>
	<xsl:variable name="test_CrumbtrailAncestor" select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR"/>
	<xsl:variable name="test_TitleImage" select="/H2G2/ARTICLE/GUIDE/FURNITURE/CATTITLE"/>
	<!--xsl:variable name="test_IsMainCat" select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[not(ANCESTOR[3])]"/--> 
	<xsl:variable name="test_IsMainCat" select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[not(ANCESTOR[3])]"/>
	<!-- Main Cat pages will be stored in the categorisation system at level two - this is their flag -->
	<xsl:variable name="test_MainCatName" select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[3]/NAME"/>
	<xsl:variable name="test_MainCatNode" select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[3]/NODEID"/>
	<xsl:variable name="test_MainCatID" select="/H2G2/ARTICLE/GUIDE/@ID"/>
	<xsl:variable name="test_dontshowfurniture" select="/H2G2/ARTICLE/GUIDE/@SIDEBAR='NO'"/>
	<xsl:variable name="test_Promo" select="/H2G2/ARTICLE/GUIDE/FURNITURE/PROMO"/>
	<xsl:variable name="test_ExampleArticles" select="/H2G2/ARTICLE/GUIDE/FURNITURE/EXAMPLEARTICLES"/>
	<xsl:variable name="test_Categorisation" select="/H2G2/ARTICLE/GUIDE/FURNITURE/CATEGORISATION"/>
	<xsl:variable name="test_ArticleBody" select="/H2G2/ARTICLE/GUIDE/BODY"/>
	<xsl:variable name="test_ArticleStatusUserEntry" select="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='3']"/>
	<xsl:variable name="test_ArticleStatusEdited" select="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='1']"/>
	<xsl:variable name="test_Summary" select="/H2G2/ARTICLE/GUIDE/FURNITURE/EXAMPLEARTICLES/SUMMARY"/>
	<xsl:variable name="test_ArticleSubject" select="/H2G2/ARTICLE/SUBJECT"/>
	<xsl:variable name="test_ArticleH2G2ID" select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
	<xsl:variable name="test_ArticleAuthor" select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER"/>
	<xsl:variable name="test_ArticleDate" select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE"/>
	<xsl:variable name="test_ArticleVote" select="/H2G2/ARTICLE/GUIDE/FURNITURE/VOTE"/>
	<xsl:variable name="test_ArticleCopy" select="/H2G2/PARAMS/PARAM[NAME='s_fromedit']"/>
	<xsl:variable name="test_ArticleTotalThreads" select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@TOTALTHREADS"/>
	<xsl:variable name="test_ArticleHideThreads" select="/H2G2/ARTICLE/GUIDE/NOCONVERSATIONS"/>
	<!-- User page -->
	<xsl:variable name="test_UserPage" select="/H2G2[@TYPE='USERPAGE']"/>
	<xsl:variable name="test_MorePagesPage" select="/H2G2[@TYPE='MOREPAGES']"/>
	<xsl:variable name="test_MorePostsPage" select="/H2G2[@TYPE='MOREPOSTS']"/>
	<xsl:variable name="test_PageUserID" select="/H2G2/PAGE-OWNER/USER/USERID"/>
	<xsl:variable name="test_UserHasPosts" select="/H2G2/RECENT-POSTS/POST-LIST/POST"/>
	<xsl:variable name="test_UserHasArticles" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE"/>	
	<xsl:variable name="test_CanEditMasthead" select="$ownerisviewer=1 or ($test_IsEditor and /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
	<xsl:variable name="test_MayShowCancelledEntries" select="number(/H2G2/ARTICLES/@USERID)=number(/H2G2/VIEWING-USER/USER/USERID)"/>
	<xsl:variable name="test_NewerArticlesExist" select="boolean(/H2G2/ARTICLES/ARTICLE-LIST[@SKIPTO &gt; 0])"/>
	<xsl:variable name="test_OlderArticlesExist" select="boolean(/H2G2/ARTICLES/ARTICLE-LIST[@MORE=1])"/>

	<!-- User Edit page -->
	<xsl:variable name="test_UserEditPage" select="/H2G2[@TYPE='USEREDIT']"/>
	<xsl:variable name="test_AddHomePage" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) = 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD != 0"/>
	<xsl:variable name="test_AddGuideEntry" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) = 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 0"/>
	<xsl:variable name="test_EditHomePage" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) != 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD != 0"/>
	<xsl:variable name="test_EditguideEntry" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) != 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 0"/>
	<xsl:variable name="test_UserHomePage" select="$test_AddHomePage or $test_EditHomePage"/>
	<xsl:variable name="test_GuideEntry" select="$test_AddGuideEntry or $test_EditguideEntry"/>
	<xsl:variable name="test_ArticlePreviewExampleArticles" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/FURNITURE/EXAMPLEARTICLES"/>
	<xsl:variable name="test_ArticlePreviewSummary" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/FURNITURE/EXAMPLEARTICLES/SUMMARY"/>
	<xsl:variable name="test_ArticlePreviewPromo" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/FURNITURE/PROMO"/>
	<xsl:variable name="test_ArticlePreviewBody" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/BODY"/>
	<xsl:variable name="test_ArticlePreviewSubject" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/SUBJECT"/>
	<xsl:variable name="test_IsMainCatPreview" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[not(ANCESTOR[3])]"/>
	<xsl:variable name="test_ArticleInReviewForum" select="/H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE[@TYPE='IN']/REVIEWFORUM"/>
	<!-- Multiposts page -->
	<xsl:variable name="test_MultipostsPage" select="/H2G2/@TYPE='MULTIPOSTS'"/>
	<!-- User details page -->
	<xsl:variable name="test_UserDetailsPage" select="/H2G2[@TYPE='USERDETAILS']"/>
	<xsl:variable name="test_ChangeNickname" select="/H2G2/PARAMS/PARAM/NAME[text()='s_nickname']"/>
	<xsl:variable name="test_ChangeEmail" select="/H2G2/PARAMS/PARAM/NAME[text()='s_email']"/>
	<xsl:variable name="test_ChangePassword" select="/H2G2/PARAMS/PARAM/NAME[text()='s_password']"/>

	
	<!-- Add thread page -->
	<xsl:variable name="test_AddThreadPage" select="/H2G2[@TYPE='ADDTHREAD']"/>
	<xsl:variable name="test_IsNotAReply" select="/H2G2/POSTTHREADFORM/@INREPLYTO='0'"/>
	<xsl:variable name="test_IsAReply" select="/H2G2/POSTTHREADFORM/INREPLYTO"/>
	<xsl:variable name="test_PreviewError" select="boolean(/H2G2/POSTTHREADFORM/PREVIEWERROR)"/>
	<xsl:variable name="test_HasPreviewBody" select="boolean(/H2G2/POSTTHREADFORM/PREVIEWBODY)"/>

	<!-- Search page -->
	<xsl:variable name="test_SearchPage" select="/H2G2[@TYPE='SEARCH']"/>
	<xsl:variable name="test_SearchTerm" select="/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM"/>
	<xsl:variable name="test_SearchResPrimarySite" select="/H2G2/SEARCH/SEARCHRESULTS/ARTICLERESULT[PRIMARYSITE=1]"/>
	<xsl:variable name="test_SearchResOtherSites" select="/H2G2/SEARCH/SEARCHRESULTS/ARTICLERESULT[PRIMARYSITE!=1]"/>
	<xsl:variable name="test_SearchType" select="/H2G2/SEARCH/SEARCHRESULTS/@TYPE"/>
	<xsl:variable name="test_SearchCount" select="/H2G2/SEARCH/SEARCHRESULTS/COUNT"/>
	<xsl:variable name="test_SearchSkip" select="/H2G2/SEARCH/SEARCHRESULTS/SKIP"/>
	<xsl:variable name="test_SearchMore" select="/H2G2/SEARCH/SEARCHRESULTS/MORE"/>

	<!-- Category page -->
	<xsl:variable name="test_CategoryPage" select="/H2G2[@TYPE='CATEGORY']"/>
	<xsl:variable name="test_Ancestry" select="/H2G2/HIERARCHYDETAILS/ANCESTRY"/>
	<xsl:variable name="test_EditAncestry" select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/ANCESTRY"/>
	<!-- Logout page -->
	<xsl:variable name="test_LogoutPage" select="/H2G2[@TYPE='LOGOUT']"/>
	<!-- Register page -->
	<xsl:variable name="test_RegisterPage" select="/H2G2[@TYPE='NEWREGISTER']/NEWREGISTER[@COMMAND='normal']"/>
	<xsl:variable name="test_registerstatus" select="/H2G2/NEWREGISTER/@STATUS"/>
	<!-- Used for error messages -->


	<!-- Login page -->
	<xsl:variable name="test_LoginPage" select="/H2G2[@TYPE='NEWREGISTER']/NEWREGISTER[@COMMAND='fasttrack']"/>

	

</xsl:stylesheet>
