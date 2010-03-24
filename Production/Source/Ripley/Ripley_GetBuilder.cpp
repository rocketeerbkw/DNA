
// Implementation of the GetBuilder member function of CRipley
////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"

#include "RipleyServer.h"
#include "CGI.h"
#include "XMLObject.h"
#include "Ripley.h"
#include "StatusBuilder.h"
#include "ArticlePageBuilder.h"
#include "UserPageBuilder.h"
#include "NewUserDetailsPageBuilder.h"
#include "UserEditPageBuilder.h"
#include "FrontPageBuilder.h"
#include "ForumPageBuilder.h"
#include "IndexBuilder.h"
#include "SearchBuilder.h"
#include "BlobBuilder.h"
#include "WhosOnlineBuilder.h"
#include "InfoBuilder.h"
#include "LogoutBuilder.h"
#include "TransmissionBuilder.h"
#include "AddThreadBuilder.h"
#include "MoreJournalBuilder.h"
#include "MorePagesBuilder.h"
#include "MorePostsBuilder.h"
#include "PostJournalBuilder.h"
#include "NewEmailBuilder.h"
#include "RegisterBuilder.h"
#include "NewRegisterBuilder.h"
#include "ArticleDiagnosticBuilder.h"
#include "CategoryBuilder.h"
#include "NewUsersPageBuilder.h"
#include "ShareAndEnjoyBuilder.h"
#include "UserComplaintPageBuilder.h"
#include "GeneralModerationPageBuilder.h"
#include "NickNameModerationPageBuilder.h"
//#include "ActiveSearchesPageBuilder.h"
#include "RecommendEntryPageBuilder.h"
#include "SubmitSubbedEntryPageBuilder.h"
#include "MonthSummaryPageBuilder.h"
#include "SubArticleStatusBuilder.h"
#include "EditCategoryBuilder.h"
#include "ComingUpBuilder.h"
#include "SubmitReviewForumBuilder.h"
#include "FrontPageEditor.h"
#include "ReviewForumBuilder.h"
#include "KeyArticleEditBuilder.h"
#include "TopFiveEditor.h"
#include "SiteAdminBuilder.h"
#include "SiteOptionsBuilder.h"
#include "SiteConfigBuilder.h"
#include "EditReviewForumBuilder.h"
#include "SignalBuilder.h"
#include "NotFoundBuilder.h"
#include "UserStatisticsPageBuilder.h"
#include "ModBillingBuilder.h"
#include "ModeratorListBuilder.h"
#include "FriendsBuilder.h"
#include "ClubPageBuilder.h"
#include "TeamListPageBuilder.h"
#include "TypedArticleBuilder.h"
#include "ManageLinksBuilder.h"
#include "CurrentClubsBuilder.h" 
#include "SSOBuilder.h"

#include "UploadPageBuilder.h" 
#include "VotePageBuilder.h"
#include "ClubListPageBuilder.h" 
#include "TagItemBuilder.h"
#include "PostcodeBuilder.h" 
#include "HierarchyTreeBuilder.h"
#include "HierarchyNodeTyperBuilder.h"
#include "ReservedArticlesBuilder.h"
#include "NoticeBoardBuilder.h"
#include "FrontPageLayoutBuilder.h"
#include "MessageBoardAdminBuilder.h"
#include "PollBuilder.h"

//#include "ActiveSearchNotificationBuilder.h"
#include "ImageModerationBuilder.h"
#include "TestXMLBuilder.h"
#include "NoticeBoardListBuilder.h"
#include "FastCategoryListBuilder.h"
#include "CategoryListBuilder.h"
#include "FixDBBuilder.h"
#include "IDifDocBuilder.h"
#include ".\emailalertbuilder.h"
#include "UnauthorisedBuilder.h"
#include ".\TextBoxElementBuilder.h"
#include "FrontPageTopicElementBuilder.h"
#include "ImageLibraryBuilder.h"
#include "EditRecentPostBuilder.h"
#include ".\MessageBoardPromoBuilder.h"
#include ".\TopicBuilder.h"
#include ".\ModeratorManagementBuilder.h"
#include ".\moderationemailmanagementbuilder.h"
#include ".\SiteConfigPreviewBuilder.h"
#include "MessageBoardTransferBuilder.h"
#include "ContentSignifBuilder.h"
#include "ThreadSearchPhraseBuilder.h"
#include "MediaAssetSearchPhraseBuilder.h"
#include ".\EMailAlertGroupBuilder.h"
#include "ModeratePosts.h"
#include "ModerateMediaAssetsBuilder.h"

#include "MediaAssetBuilder.h"
#include "ArticleSearchPhraseBuilder.h"
#include "UserPrivacyBuilder.h"
#include "URLFilterAdminBuilder.h"
#include "SystemMessageMailboxBuilder.h"
#include "StatsBuilder.h"
#include "MessageboardStatsBuilder.h"

#if defined(_ADMIN_VERSION)
//	#include "MailshotBuilder.h"
//	#include "SubscribeBuilder.h"
	#include "ForumModerationPageBuilder.h"
	#include "ModerateArticlePageBuilder.h"
	#include "ModerateHomePageBuilder.h"
	#include "EditPostPageBuilder.h"
	#include "ModerationStatusPageBuilder.h"
	#include "ModerationHistoryBuilder.h"
	#include "SubEditorAllocationPageBuilder.h"
	#include "ScoutRecommendationsPageBuilder.h"
	#include "ProcessRecommendationPageBuilder.h"
	#include "MoveThreadPageBuilder.h"
	#include "InspectUserBuilder.h"
	#include "GroupManagementBuilder.h"
	#include "ProfanityAdminPageBuilder.h"
	#include "MessageBoardSchedulePageBuilder.h"
	#include "FailMessageBuilder.h"
	#include "ContentSignifAdminBuilder.h"
	#include "ModManageFastModBuilder.h"
	#include "ModAlertsCheckerBuilder.h"	
	#include "MembersHomePageBuilder.h"
	#include "MemberDetailsPageBuilder.h"
	#include "ModerationDistressMessages.h" 
#endif

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#define GET_BUILDER(name,class) 		else if (CommandQuery.CompareText(name)) \
		{\
			pBuilder = new class(inputContext);\
		}




/*********************************************************************************

	CXMLBuilder* CRipley::GetBuilder(CGI* pCGI)
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	12/03/2000
	Inputs:		pCGI - ptr to the CGI request object
	Outputs:	-
	Returns:	ptr to a CXMLBuilder object for this request
	Purpose:	Looks at the request and decides which subclass of CXMLBuilder
				to return. Creates an instance of that class and returns it,
				having initialised it with the ptr to the CGI request object.

*********************************************************************************/

CXMLBuilder* CRipley::GetBuilder(CGI* pCGI)
{
	CInputContext& inputContext = pCGI->GetInputContext();
	CXMLBuilder* pBuilder = NULL;

	try
	{	
		// First, see if this site is passworded, and if so, use the unauthorised builder
		if (pCGI->IsSitePassworded(pCGI->GetSiteID()))
		{
			if (!pCGI->IsUserAllowedInPasswordedSite())
			{
				return new CUnauthorisedBuilder(inputContext);
				return pBuilder;
			}
		}


		CTDVString CommandQuery;
		// attempt to find out what sort of page the user expects to get
		bool bCommandQuerySuccess = inputContext.GetCommand(CommandQuery);

		// if the query was unsuccessful... 
		//indicating that the dll was not given a command parameter
		if (bCommandQuerySuccess == false) 
		{
			// this is a request for the front page so create a 
			//frontpage builder object and return it - Kim
			pBuilder = new CFrontPageBuilder(inputContext);
			return pBuilder;
		}


		// following added by Kim 28/02/2000
		if (CommandQuery.CompareText("STATUS"))
		{
			pBuilder = new CStatusBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("-KEYARTICLE"))
		{
			CTDVString sName;
			inputContext.GetParamString("name", sName);
			int iForumID;
			if (inputContext.DoesKeyArticleExist(inputContext.GetSiteID(), sName))
			{
				pBuilder = new CArticlePageBuilder(inputContext);
			}
			else if ((iForumID = inputContext.GetReviewForumID(inputContext.GetSiteID(), sName)) > 0)
			{
				CTDVString sNewParams = "id=";
				sNewParams << iForumID;
				pCGI->ReplaceQueryString(sNewParams);
				pBuilder = new CReviewForumBuilder(inputContext);
			}
			else
			{
				pBuilder = new CNotFoundBuilder(inputContext);
			}
		}
		else if (CommandQuery.CompareText("FRONTPAGE") || CommandQuery.CompareText("")) // test for case-insensitive equality
		{
			pBuilder = new CFrontPageBuilder(inputContext);
		}
		GET_BUILDER("MODERATEIMAGES",CImageModerationBuilder)
		GET_BUILDER("FORUM",CForumPageBuilder)
		GET_BUILDER("IMAGELIBRARY",CImageLibraryBuilder)
		GET_BUILDER("NOTFOUND",CNotFoundBuilder)
		GET_BUILDER("USEREDIT",CUserEditPageBuilder)
		GET_BUILDER("USERDETAILS",CNewUserDetailsPageBuilder)
		GET_BUILDER("USERPAGE",CUserPageBuilder)
		GET_BUILDER("ARTICLE",CArticlePageBuilder)
		GET_BUILDER("ADDTHREAD",CAddThreadBuilder)
		GET_BUILDER("TRANSMIT",CTransmissionBuilder)
		GET_BUILDER("LOGOUT",CLogoutBuilder)
		GET_BUILDER("INFO",CInfoBuilder)
		GET_BUILDER("ONLINE",CWhosOnlineBuilder)
		GET_BUILDER("BLOB",CBlobBuilder)
		GET_BUILDER("SEARCH",CSearchBuilder)
		GET_BUILDER("INDEX",CIndexBuilder)
		GET_BUILDER("NEWREGISTER",CNewRegisterBuilder)
		GET_BUILDER("SHAREANDENJOY",CShareAndEnjoyBuilder)
		GET_BUILDER("NEWUSERS",CNewUsersPageBuilder)
		GET_BUILDER("REVIEWFORUM",CReviewForumBuilder)
		GET_BUILDER("SUBMITREVIEWFORUM",CSubmitReviewForumBuilder)
		GET_BUILDER("EDITCATEGORY",CEditCategoryBuilder)
		GET_BUILDER("MONTH",CMonthSummaryPageBuilder)
		GET_BUILDER("CATEGORY",CCategoryBuilder)
		GET_BUILDER("DIAG",CArticleDiagnosticBuilder)
		GET_BUILDER("REGISTER",CRegisterBuilder)
		GET_BUILDER("NEWEMAIL",CNewEmailBuilder)
		GET_BUILDER("POSTJOURNAL",CPostJournalBuilder)
		GET_BUILDER("MOREPOSTS",CMorePostsBuilder)
		GET_BUILDER("MOREPAGES",CMorePagesBuilder)
		GET_BUILDER("JOURNAL",CMoreJournalBuilder)
		GET_BUILDER("USERCOMPLAINT",CUserComplaintPageBuilder)
		GET_BUILDER("SITEADMIN",CSiteAdminBuilder)		
		GET_BUILDER("SITEOPTIONS",CSiteOptionsBuilder)		
		GET_BUILDER("SITECONFIG",CSiteConfigBuilder)
		GET_BUILDER("PREVIEWSITECONFIG", CSiteConfigPreviewBuilder)
		GET_BUILDER("EDITREVIEW",CEditReviewForumBuilder)
		GET_BUILDER("SIGNAL",CSignalBuilder)
		GET_BUILDER("USERSTATISTICS",CUserStatisticsPageBuilder)
		GET_BUILDER("MODERATIONBILLING",CModBillingBuilder)
		GET_BUILDER("MODERATORLIST",CModeratorListBuilder)
		GET_BUILDER("WATCH",CFriendsBuilder)
		GET_BUILDER("CLUB",CClubPageBuilder)
		GET_BUILDER("TEAMLIST",CTeamListPageBuilder)

		GET_BUILDER("TYPEDARTICLE",CTypedArticleBuilder)
		GET_BUILDER("MANAGELINKS", CManageLinksBuilder)
		GET_BUILDER("USERMYCLUBS",CCurrentClubsBuilder)
		GET_BUILDER("UPLOAD",CUploadPageBuilder)

		GET_BUILDER("SSO",CSSOBuilder)
			
		GET_BUILDER("VOTE",CVotePageBuilder)
		GET_BUILDER("POLL",CPollBuilder)
		GET_BUILDER("TAGITEM",CTagItemBuilder)
		GET_BUILDER("POSTCODE", CPostcodeBuilder)
		GET_BUILDER("HIERARCHYTREE", CHierarchyTreeBuilder)
		GET_BUILDER("HIERARCHYNODETYPER", CHierarchyNodeTyperBuilder)
		GET_BUILDER("RESERVED", CReservedArticlesBuilder)
		GET_BUILDER("NOTICEBOARD", CNoticeBoardBuilder)
		GET_BUILDER("CLUBLIST", CClubListPageBuilder)
		GET_BUILDER("NOTICEBOARDLIST", CNoticeBoardListBuilder)
		GET_BUILDER("PROFANITYADMIN", CProfanityAdminPageBuilder)
		GET_BUILDER("MESSAGEBOARDADMIN", CMessageBoardAdminBuilder)
		GET_BUILDER("MESSAGEBOARDSCHEDULE", CMessageBoardSchedulePageBuilder)
		GET_BUILDER("FAILMESSAGE", CFailMessageBuilder)
		GET_BUILDER("CONTENTSIGNIFADMINBUILDER", CContentSignifAdminBuilder)
		GET_BUILDER("CONTENTSIGNIFBUILDER", CContentSignifBuilder)
		GET_BUILDER("THREADSEARCHPHRASE", CThreadSearchPhraseBuilder)
		GET_BUILDER("MEDIAASSETSEARCHPHRASE", CMediaAssetSearchPhraseBuilder)


		// Category List builders. Use the same builder but in different modes
		// When in FAST Mode, no user info is used!
		GET_BUILDER("CATEGORYLISTBUILDER",CCategoryListBuilder)
		
		GET_BUILDER("FAST_CATEGORYLISTBUILDER",CFastCategoryListBuilder)
		GET_BUILDER("FIXDB",CFixDBBuilder)
		GET_BUILDER("IDIFDOCBUILDER", CIDifDocBuilder)
		GET_BUILDER("EMAILALERTBUILDER", CEmailAlertBuilder)
		GET_BUILDER("TEXTBOXELEMENTBUILDER", CTextBoxElementBuilder)
		GET_BUILDER("FRONTPAGETOPICELEMENTBUILDER", CFrontPageTopicElementBuilder)
		GET_BUILDER("MESSAGEBOARDPROMOBUILDER", CMessageBoardPromoBuilder)
		GET_BUILDER("TOPICBUILDER", CTopicBuilder)
		GET_BUILDER("MODERATORMANAGEMENT", CModeratorManagementBuilder)
		GET_BUILDER("MODERATIONEMAILMANAGEMENT", CModerationEmailManagementBuilder)
		GET_BUILDER("MBTRANSFER", CMessageBoardTransferBuilder)
		GET_BUILDER("ALERTGROUPS", CEMailAlertGroupBuilder)
		GET_BUILDER("RECOMMENDENTRY",CRecommendEntryPageBuilder)
		GET_BUILDER("MODERATEPOSTS", CModeratePostsBuilder)
		GET_BUILDER("MODERATEMEDIAASSETS", CModerateMediaAssetsBuilder)
		GET_BUILDER("STATISTICSREPORT", CStatsBuilder)

		/*
		else if (CommandQuery.CompareText("ACTIVESEARCHES")) 
		{
			pBuilder = new CActiveSearchesPageBuilder(inputContext);
		}
		*/
		
		/*
		else if (CommandQuery.CompareText("SEARCHNOTIFICATION")) 
		{
			pBuilder = new CActiveSearchNotificationBuilder(inputContext);
		}
		*/
		else if (CommandQuery.CompareText("SUBMITSUBBEDENTRY")) 
		{
			pBuilder = new CSubmitSubbedEntryPageBuilder(inputContext);
		}
		GET_BUILDER("COMINGUP",CComingUpBuilder)
		GET_BUILDER("FRONTPAGEEDITOR",CFrontPageEditor)
		GET_BUILDER("FRONTPAGELAYOUT",CFrontPageLayoutBuilder)
		GET_BUILDER("NAMEDARTICLES",CKeyArticleEditBuilder)
		GET_BUILDER("TOPFIVEEDITOR",CTopFiveEditor)
		GET_BUILDER("EDITRECENTPOST",CEditRecentPostBuilder)
		else if (CommandQuery.CompareText("SUBARTICLESTATUS")) 
		{
			pBuilder = new CSubArticleStatusBuilder(inputContext);
		}
		// DO *NOT* REMOVE THIS UNDER ANY CIRCUMSTANCES - Jim.
		else if (CommandQuery.CompareText("TEST"))
		{
			pBuilder = new CTestXMLBuilder(inputContext);
		}
#if defined(_ADMIN_VERSION)
		else if (CommandQuery.CompareText("PROCESSRECOMMENDATION")) 
		{
			pBuilder = new CProcessRecommendationPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("SCOUTRECOMMENDATIONS")) 
		{
			pBuilder = new CScoutRecommendationsPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("SUBALLOCATION")) 
		{
			pBuilder = new CSubEditorAllocationPageBuilder(inputContext);
		}
/*
		else if (CommandQuery.CompareText("MAILSHOT")) 
		{
			pBuilder = new CMailshotBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("SUBSCRIBE")) 
		{
			pBuilder = new CSubscribeBuilder(inputContext);
		}
*/
		else if (CommandQuery.CompareText("MODERATEFORUMS")) 
		{
			pBuilder = new CForumModerationPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MODERATEARTICLE")) 
		{
			pBuilder = new CModerateArticlePageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MODERATEHOME")) 
		{
			pBuilder = new CModerateHomePageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("EDITPOST")) 
		{
			pBuilder = new CEditPostPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MODERATEGENERAL")) 
		{
			pBuilder = new CGeneralModerationPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MODERATENICKNAMES")) 
		{
			pBuilder = new CNickNameModerationPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MODERATESTATUS")) 
		{
			pBuilder = new CModerationStatusPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MODERATIONHISTORY")) 
		{
			pBuilder = new CModerationHistoryBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MOVETHREAD")) 
		{
			pBuilder = new CMoveThreadPageBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("INSPECTUSER")) 
		{
			pBuilder = new CInspectUserBuilder(inputContext);
		}
		else if (CommandQuery.CompareText("MANAGEGROUPS")) 
		{
			pBuilder = new CGroupManagementBuilder(inputContext);
		}
		GET_BUILDER("MODMANAGEFASTMOD", CModManageFastModBuilder)
		GET_BUILDER("MODALERTSCHECKER", CModAlertsCheckerBuilder)
		GET_BUILDER("MEMBERS", CMembersHomePageBuilder)
		GET_BUILDER("MEMBERDETAILS", CMemberDetailsPageBuilder)
		GET_BUILDER("MEDIAASSET", CMediaAssetBuilder)
		GET_BUILDER("ARTICLESEARCHPHRASE", CArticleSearchPhraseBuilder)
		GET_BUILDER("DISTRESSMESSAGES", CModerationDistressMessagesBuilder)
		GET_BUILDER("USERPRIVACY", CUserPrivacyBuilder)
		GET_BUILDER("URLFILTERADMIN", CURLFilterAdminBuilder)
		GET_BUILDER("SYSTEMMESSAGEMAILBOX", CSystemMessageMailboxBuilder)
		GET_BUILDER("MBSTATS", CMessageboardStatsBuilder)

#endif
		else // default command handler at the minute
		{	
			// if none of the above asked for then use base class builder currently
			pBuilder = new CXMLBuilder(inputContext);
		}
	}
	catch (...)
	{
		TDVASSERT(false, "Exception caught while creating builder");
		return NULL;
	}

	return pBuilder;
}

