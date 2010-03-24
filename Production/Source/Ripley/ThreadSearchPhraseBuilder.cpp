#include "stdafx.h"
#include "ThreadSearchPhraseBuilder.h"
#include "ThreadSearchPhrase.h"
#include ".\User.h"
#include ".\tdvassert.h"
#include ".\groups.h"
#include "MessageBoardPromo.h"
#include "TextBoxElement.h"

#include "ArticleEditForm.h"
#include "GuideEntry.h"
#include ".\SiteOptions.h"

#include <algorithm> // find algorithm.

CThreadSearchPhraseBuilder::CThreadSearchPhraseBuilder(CInputContext& InputContext) : CXMLBuilder(InputContext)
{
}

/*********************************************************************************

	CSearchPhraseBuilder::~CSearchPhraseBuilder(void)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
CThreadSearchPhraseBuilder::~CThreadSearchPhraseBuilder(void)
{
}

/*********************************************************************************

	bool CSearchPhraseBuilder::Build(CWholePage* pPage)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pPage = ptr to the page to build in
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	This Builder performs the followign tasks.
					1. If a keyphrase has been provided performs a search for discussion tagged to the relevant phrases.
					2. Creates a hot - list of popular key phrases.
					3. Scores any site key phrases that have been defined in the sites <SITECONFIG> XML.
					4. Fetches Board Promos and Text Box Elements for the current phrase search.

*********************************************************************************/
bool CThreadSearchPhraseBuilder::Build(CWholePage* pPage)
{
	// Get the status for the current user
	CUser* pUser = m_InputContext.GetCurrentUser();

	//Set up Search Page XML
	if (!InitPage(pPage,"THREADSEARCHPHRASE",false,true))
	{
		TDVASSERT(false,"CSearchPhraseBuilder - Failed to create Whole Page object!");
		return false;
	}

	//Expecting keyphrases to be space seperated.
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase SearchPhrase(m_InputContext, delimit);
	CTDVString sAction;
	bool bredirectaddphrasepage = false;
	if ( m_InputContext.ParamExists("addphrase") && m_InputContext.ParamExists("thread") )
	{
		if (CanUserCanPreformAction(pPage,pUser))
		{
			int ithreadid = m_InputContext.GetParamInt("thread");
			if ( ithreadid > 0 )
			{
				//Build up a string of keyphrases.
				for ( int i=0; i < m_InputContext.GetParamCount("addphrase"); ++i )
				{
					CTDVString sParam;
					m_InputContext.GetParamString("addphrase",sParam,i);
					SearchPhrase.ParsePhrases(sParam,true);
				}
				bool bOk = SearchPhrase.AddKeyPhrases(ithreadid);

				//Handle rediect.
				if ( bOk && CheckAndUseRedirectIfGiven(pPage) )
				{
					return true;
				}
				else
				{
					pPage->AddInside("H2G2", SearchPhrase.GetLastErrorAsXMLString());
					bredirectaddphrasepage = true;
				}
			}
			else
			{
				SetDNALastError("CThreadSearchPhraseBuilder::Build","AddPhrase","Invlalid threadid");
				pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				bredirectaddphrasepage = true;
			}
		}
		else
		{
			SetDNALastError("CThreadSearchPhraseBuilder::Build","AddPhrase","Unable to add key phrase(s) - User not logged in.");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			bredirectaddphrasepage = true;
		}
	}
	else if ( m_InputContext.ParamExists("addthread") )
	{
		//Start a new discussion 
		int iforumid = 0;
		if ( m_InputContext.ParamExists("forumid") )
		{
			iforumid = m_InputContext.GetParamInt("forumid");
		}
		else
		{
			iforumid = GetForumFromSite();
		}

		if ( iforumid > 0 )
		{
			CTDVString sredirect = "AddThread?";
			sredirect << "forum=" << iforumid;
			pPage->Redirect(sredirect);
			return true;
		}

		TDVASSERT(false,"CSearchPhraseBuilder - Failed to find valid forum");
		return false;
	}
	else if ( m_InputContext.ParamExists("removephrases") && 
		m_InputContext.ParamExists("thread") &&
		m_InputContext.ParamExists("phrase") )
	{
		if (CanUserCanPreformAction(pPage,pUser,true))
		{
			CTDVString sPhraseIDs;
			int iThreadID = m_InputContext.GetParamInt("thread");
			if (iThreadID > 0)
			{
				for (int i = 0; i < m_InputContext.GetParamCount("phrase"); i++)
				{
					CTDVString sPhrase;
					m_InputContext.GetParamString("phrase", sPhrase, i);
					SearchPhrase.ParsePhrases(sPhrase,true);
				}
				bool bOk = SearchPhrase.RemoveKeyPhrases(iThreadID);
				if (!bOk)
				{
					pPage->AddInside("H2G2", SearchPhrase.GetLastErrorAsXMLString());
					bredirectaddphrasepage = true;
				}
				else
				{
					//we're ok - check if we need to redirect.
					if (CheckAndUseRedirectIfGiven(pPage))
					{
						return true;
					}
				}
			}
			else
			{
				SetDNALastError("CThreadSearchPhraseBuilder::Build","AddPhrase","Invlalid threadid");
				pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				bredirectaddphrasepage = true;
			}
		}
	}

	//Generate XML for current keyphrase search.
	CTDVString sPhrases;
	if ( m_InputContext.ParamExists("phrase") )
	{
		CTDVString sPhraseParam;
		for (int i=0;m_InputContext.GetParamString("phrase",sPhraseParam,i);i++)
		{
			sPhrases << (sPhrases.IsEmpty() ? "":" ") << sPhraseParam;
		}
		SearchPhrase.ParsePhrases(sPhrases);
	}

	if ( (bredirectaddphrasepage || m_InputContext.ParamExists("addpage")) && m_InputContext.ParamExists("thread") )
	{
		int iThreadId = m_InputContext.GetParamInt("thread");
		int iforumId = m_InputContext.GetParamInt("forum");

		if (!pPage->AddInside("H2G2","<ADDTHREADSEARCHPHRASE/>"))
		{
			TDVASSERT(false,"CSearchPhraseBuilder - Failed to add THREADADDSEARCHPHRASE node");
			return false;
		}

		if ( iforumId <= 0 || iThreadId <= 0 )
		{
			TDVASSERT(false,"CSearchPhraseBuilder - Failed to find valid forumId/ThreadId");
			SetDNALastError("CThreadSearchPhraseBuilder::AddSearchPhrasePage","AddSearchPhrasePage", "Invalid ForumID/ThreadID");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		else
		{
			CTDVString sXML;
			//sXML << "<FORUMID>" << iforumId << "</FORUMID>";
			//pPage->AddInside("H2G2/ADDTHREADSEARCHPHRASE",sXML);
			pPage->AddInside("H2G2/ADDTHREADSEARCHPHRASE",SearchPhrase.GeneratePhraseListXML());

			//Get Existing phrases for discussion / thread
			if ( SearchPhrase.GetKeyPhrasesFromThread(iforumId,iThreadId) )
				pPage->AddInside("H2G2/ADDTHREADSEARCHPHRASE",&SearchPhrase);
			else
				pPage->AddInside("H2G2",SearchPhrase.GetLastErrorAsXMLString());
		}

		//Add Site Key Phrases
		if ( SearchPhrase.GetSiteKeyPhrasesXML() )
			pPage->AddInside("H2G2/ADDTHREADSEARCHPHRASE",&SearchPhrase);
		else
			pPage->AddInside("H2G2",SearchPhrase.GetLastErrorAsXMLString());
		return true;
	}

	// Set up the page root node
	if (!pPage->AddInside("H2G2","<THREADSEARCHPHRASE/>"))
	{
		TDVASSERT(false,"CSearchPhraseBuilder - Failed to add SEARCHPHRASE node");
		return false;
	}
	pPage->AddInside("H2G2/THREADSEARCHPHRASE",SearchPhrase.GeneratePhraseListXML());

	//Add a default forumid 
	int idefaultforumid = GetForumFromSite();
	if ( idefaultforumid )
	{
		CTDVString sdefaultforumxml;
		sdefaultforumxml << "<DEFAULTFORUMID>" << idefaultforumid << "</DEFAULTFORUMID>";
		pPage->AddInside("H2G2/THREADSEARCHPHRASE",sdefaultforumxml );
	}
	else
		TDVASSERT(false,"CSearchPhraseBuilder - Failed to find a default forum");

	//Get Promos associated with current search - ( if no search will fetch promos tagged to empty keyphrase )
	CMessageBoardPromo BoardPromos(m_InputContext);
	BoardPromos.GetBoardPromosForPhrase(m_InputContext.GetSiteID(),
										SearchPhrase.GetPhraseList(),
										m_InputContext.GetIsInPreviewMode() ? CFrontPageElement::ES_PREVIEW : CFrontPageElement::ES_LIVE);
	pPage->AddInside("H2G2/THREADSEARCHPHRASE",&BoardPromos);

	//Get Text Box Elements associated with current search - ( if no search will fetch textboxes tagged to empty keyphrase )
	CTextBoxElement TextBoxes(m_InputContext);
	TextBoxes.GetTextBoxesForPhrase(m_InputContext.GetSiteID(),
									SearchPhrase.GetPhraseList(),
									m_InputContext.GetIsInPreviewMode() ? CFrontPageElement::ES_PREVIEW : CFrontPageElement::ES_LIVE);
	pPage->AddInside("H2G2/THREADSEARCHPHRASE",&TextBoxes);

	//Process Site Key Phrases - score the predefined key phrase searches.
	CThreadSearchPhrase sitekeyphrases(m_InputContext,delimit);
	if ( !sitekeyphrases.GetSiteKeyPhraseScores(sPhrases) )
	{
		pPage->AddInside("H2G2",sitekeyphrases.GetLastErrorAsXMLString());
	}
	else
	{
		pPage->AddInside("H2G2/THREADSEARCHPHRASE",&sitekeyphrases);
	}

	if ( !sAction.IsEmpty() )
	{
		//Add results of AddPhrase Action.
		pPage->AddInside("H2G2/THREADSEARCHPHRASE",sAction);
	}

	// ********************************** Hot Phrases *********************************************
	// If a phrase search has been applied - see if it matches one of the site key phrases.
	CThreadSearchPhrase tsphotphrases(m_InputContext,delimit);
	CTDVString sHotPhraseFilter;
	SEARCHPHRASELIST sitephrases = sitekeyphrases.GetPhraseList();
	SEARCHPHRASELIST phrases = SearchPhrase.GetPhraseList();
	SEARCHPHRASELIST hotphraselist;
	for ( SEARCHPHRASELIST::const_iterator site_phrase_iter = sitephrases.begin(); site_phrase_iter != sitephrases.end(); ++site_phrase_iter )
	{
		SEARCHPHRASELIST::iterator hot_phrase_iter = std::find(phrases.begin(),phrases.end(), *site_phrase_iter);
		if ( hot_phrase_iter != phrases.end() )
		{
			hotphraselist.push_back(*hot_phrase_iter);
		}
	}
	tsphotphrases.SetPhraseList(hotphraselist);

	int iSkipPhrases = m_InputContext.GetParamInt("skipphrases");
	int iShowPhrases = m_InputContext.GetParamInt("showphrases");
	CTDVString sSortBy;
	m_InputContext.GetParamString("sortby",sSortBy);
	if ( !tsphotphrases.GetKeyPhraseHotList(iSkipPhrases, iShowPhrases == 0 ? 100 : iShowPhrases, sSortBy ) )
	{
		pPage->AddInside("H2G2",tsphotphrases.GetLastErrorAsXMLString());
		return true;
	}
	pPage->AddInside("H2G2",&tsphotphrases);
		

	// Get the threads associated with the current key phrase search
	int iNumResults = 0;
	int iSkip = m_InputContext.GetParamInt("skip");
	int iShow = m_InputContext.GetParamInt("show");
	SearchPhrase.GetThreadsFromKeyPhrases(iSkip, iShow == 0 ? 20 : iShow, iNumResults);

	if (SearchPhrase.ErrorReported())
	{
		CopyDNALastError("CSearchPhraseBuilder",SearchPhrase);
	}

	pPage->AddInside("H2G2/THREADSEARCHPHRASE",&SearchPhrase);

	if (ErrorReported())
	{
		pPage->AddInside("THREADSEARCHPHRASE",GetLastErrorAsXMLString());
	}

	return true;
}

int CThreadSearchPhraseBuilder::GetForumFromSite()
{
	//Try to get a forum from key article.
	if ( m_InputContext.DoesKeyArticleExist(m_InputContext.GetSiteID(),"THREADSEARCHPHRASE") )
	{
		CGuideEntry GuideEntry(m_InputContext);
		if ( GuideEntry.Initialise("THREADSEARCHPHRASE",m_InputContext.GetSiteID()) )
		{
			return GuideEntry.GetForumID();
		}
	}

	//  Return 0 to signify failure
	return 0;
}

/*********************************************************************************

	bool CThreadSearchPhraseBuilder::CanUserCanPreformAction(CWholePage* pPage, CUser* pUser, bool bEditorAction = false)

		Author:		Mark Howitt
		Created:	24/07/2006
		Inputs:		pPage - the page object into which this function can report errors
					pUser - The current user to test against.
					bEditorAction - A flag to state that the user is required to be an editor for this action.
									Default to false!
		Outputs:	-
		Returns:	true if the current user is logged in or and editor and site is open
		Purpose:	Checks the user permissions for a given action.

*********************************************************************************/
bool CThreadSearchPhraseBuilder::CanUserCanPreformAction(CWholePage* pPage, CUser* pUser, bool bEditorAction)
{
	// Start by checking if the user is logged in!
	bool bOk = pUser != NULL && pUser->IsUserLoggedIn();
	if (bEditorAction)
	{
		// See if they are an editor
		bOk = bOk && pUser->GetIsEditor();
	}
	else
	{
		// Check to see if the site is closed. Set the flag to default true, so if there's an error the
		// normal user is still unable to perform the action.
		bool bSiteClosed = true;
		if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
		{
			if (pPage == NULL)
			{
				TDVASSERT(false,"Page object has not been initialised!!!");
				return false;
			}
			SetDNALastError("CThreadSearchPhraseBuilder::CanUserCanPreformAction","FailedToGetSiteClosedStatus","Failed to get site closed status!!!");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		bOk = !bSiteClosed;
	}

	// Return the verdict
	return bOk;
}