// NoticeBoardBuilder.cpp: implementation of the CNoticeBoardBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "NoticeBoardBuilder.h"
#include "Notice.h"
#include "TDVAssert.h"
#include "MultiStep.h"
#include "PostCoder.h"
#include ".\Category.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNoticeBoardBuilder::CNoticeBoardBuilder(CInputContext& inputContext):
										 CXMLBuilder(inputContext),m_pPage(NULL),m_iSiteID(0),
										 m_iUserID(0),m_iNodeID(0),m_sUserName(""),m_pViewingUser(NULL),
										 m_bCachePage(true)
{
}

CNoticeBoardBuilder::~CNoticeBoardBuilder()
{
}

/*********************************************************************************

	CWholePage* CNoticeBoardBuilder::Build()

	Author:		Mark Howitt
	Created:	5/10/2003
	Returns:	A new page for the noticeboard
	Purpose:	Creates the Noticeboard page.
				To view current users location use "noticeboard".
				To view a specific location use "noticeboard?postcode=###"
					where ### = the postcode of the location.
				To create a new notice use "noticeboard?acreate=acreate".
				To preview a notice use "noticeboard?apreview=apreview".
				To View a single notice use "noticeboard?aviewevnt=###"
					where ### = threadid for the notice.

*********************************************************************************/

bool CNoticeBoardBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	// Create and initialize the page
	if (!InitPage(m_pPage, "NOTICEBOARD", true))
	{
		TDVASSERT(false, "FailedToBuildNoticeBoard");
		return false;
	}

	// Setup the local variables
	CTDVString sTitle;
	bool bOk = true;
	CTDVString sXML;
	CTDVString sError;
	CTDVString sPostCode;
	CTDVString sPostCodeToFind;
	CTDVString sPostcodeXML;
	CTDVString sCacheXML;

	// Setup a CNotice Object so we can get the relative info
	CNotice Notice(m_InputContext);

	// Get the current site id
	m_iSiteID = m_InputContext.GetSiteID();

	// Check to make sure the user has permission to do any actions.
	m_pViewingUser = m_InputContext.GetCurrentUser();

	// Check to see if we've been given a postcode to search for
	bool bUsingUsersPostCode = true;

	if (!m_InputContext.ParamExists("postcode"))
	{
		// Use the users postcode instead
		if (m_pViewingUser != NULL && m_pViewingUser->GetUserID() > 0)
		{
			bOk = m_pViewingUser->GetPostcode(sPostCodeToFind);
		}
	}
	else
	{
		// Get the given post code
		bOk = m_InputContext.GetParamString("postcode",sPostCodeToFind);
		bUsingUsersPostCode = false;
	}

	// Check to make sure we got a valid postcode to find
	if (!bOk || sPostCodeToFind.IsEmpty())
	{
		sError = "NoPostCodeGiven";
		bOk = false;
	}

	// Now try and get the details
	if (bOk)
	{
		// Now get the notices for the post code.
		int iRes = Notice.GetDetailsForPostCodeArea(sPostCodeToFind,m_iSiteID,m_iNodeID,sPostCode,sPostcodeXML);

		// Check to see if we've failed
		if (iRes == CNotice::PR_POSTCODENOTFOUND)
		{
			sError = "FailedToFindPostcodeMatch";
		}
		else if (iRes == CNotice::PR_REQUESTTIMEOUT)
		{
			sError = "PostCodeRequestTimedOut";
		}

		// Check to see if we got post code info back
		if ( (iRes == CNotice::PR_REQUESTOK) && sPostcodeXML.IsEmpty())
		{
			TDVASSERT(false,"Failed getting postcode from postcoder!!!");
			sError = "PostCoderFailedToReturnPostCode";
			bOk = false;
		}
	}

	// Put the first line of XML In
	sXML << "<NOTICEBOARD NODEID='" << m_iNodeID << "' ISUSERSPOSTCODE='" << bUsingUsersPostCode << "'>";

	// Get the action from the input.
	bool bDoCreate = m_InputContext.ParamExists("acreate");
	bool bDoPreview = m_InputContext.ParamExists("apreview");
	bool bDoEditPreview = m_InputContext.ParamExists("aeditpreview");
	bool bDoView = m_InputContext.ParamExists("aview");
	bool bDoEdit = m_InputContext.ParamExists("aedit");

	// Check to see if we're trying to do an action when the user is not logged in!
	if (bOk && (bDoCreate || bDoPreview) && m_pViewingUser == NULL)
	{
		sError = "UserMustBeLoggedInToDoActions";
		bOk = false;
		if (bDoCreate)
		{
			sXML << "<ACTION>ADD</ACTION>";
		}
		else
		{
			sXML << "<ACTION>PREVIEW</ACTION>";
		}

		CTDVString sType;
		m_InputContext.GetParamString("type",sType);
		sXML << "<NOTICETYPE>" << sType << "</NOTICETYPE>";
	}

	// If we got all the details, get all the notices and events for the node.
	if (bOk)
	{
		int iForumID = 0;
		bOk = Notice.GetForumDetailsForNodeID(m_iNodeID,m_iSiteID,iForumID,&sTitle);

		if (!bOk || iForumID == 0)
		{
			sError = "FailedToGetForumDetails";
		}
		else if (m_iNodeID == 0)
		{
			sError = "NoNodeIDFoundForPostcode";
			bOk = false;
		}

		// Check to see if the site is closed. Only editors can post on closed sites
		bool bSiteClosed = true;
		if (!m_InputContext.IsSiteClosed(m_iSiteID,bSiteClosed))
		{
			sError = "FailedToGetStieStatus";
			bOk = false;
		}
		else if (bSiteClosed && !m_pViewingUser->GetIsEditor())
		{
			sError = "SiteClosed";
			bOk = false;
		}

		if (bOk)
		{
			// Check to see if we can use the cache!
			if (!bDoCreate && !bDoEdit && !bDoPreview && !bDoEditPreview && !bDoView && Notice.CheckAndCreateFromCachedPage(m_iNodeID,iForumID,m_iSiteID,sCacheXML))
			{
				// Empty what we've already done and use the cache XML
				m_pPage->AddInside("H2G2",sCacheXML);
				m_pPage->AddInside("H2G2",sPostcodeXML);
				return true;
			}

			// Put the common info in about this noticeboard
			CXMLObject::EscapeXMLText(&sTitle);
			sXML << "<LOCALAREAINFO>";
			sXML << "<NODEID>" << m_iNodeID << "</NODEID>";
			sXML << "<TITLE>" << sTitle << "</TITLE>";
			sXML << "<SITEID>" << m_iSiteID << "</SITEID>";
			sXML << "<FORUMID>" << iForumID << "</FORUMID>";
			sXML << "</LOCALAREAINFO>";

			// Check to see what type of action we're trying to do
			bool bDisplayNotices = false;
			if (bDoCreate)
			{
				sXML << "<ACTION>ADD</ACTION>";
				CTDVString sType;
				m_InputContext.GetParamString("type",sType);
				bOk = CreateNewNotice(sType,sXML,sError);
				bDisplayNotices = bOk;

				// Only cahce the page if we're ok.
				if (m_bCachePage && !bOk)
					m_bCachePage = false;
			}
			else if ( bDoEdit )
			{
				sXML << "<ACTION>EDIT</ACTION>";
				if ( !EditNotice( m_InputContext.GetParamInt("threadId"),iForumID,sXML ) )
				{
					 bOk = false;
					 pPage->AddInside("H2G2",GetLastErrorAsXMLString());
					 sError = "Failed to edit notice";
				}
				bDisplayNotices = bOk;

				// Only cahce the page if we're ok.
				if (m_bCachePage && !bOk)
					m_bCachePage = false;

			}
			else if (bDoPreview || bDoEditPreview )
			{
				// Get the type of notice we're trying to add/create
				sXML << "<ACTION>PREVIEW</ACTION>";
				CTDVString sType;
				m_InputContext.GetParamString("type",sType);
				if ( !PreviewNotice(sType,bDoEditPreview, sXML) )
				{
					bOk = false;
					pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				}
				m_bCachePage = false;
			}
			else if (bDoView)
			{
				// Get the type of notice we're trying to add/create
				int iID = m_InputContext.GetParamInt("aview");
				if (iID > 0)
				{
					sXML << "<ACTION>VIEW</ACTION>";
					bOk = Notice.GetNoticeFromThreadID(iID,iForumID,sXML);
					if (!bOk)
					{
						TDVASSERT(false,"CNotice::Failed to get Notice from threadid!");
						sError = "FailedToFindNotice";
					}
					else
					{
						CTDVString sType;
						Notice.GetNoticeType(sType);
						sXML << "<MODE>" << sType << "</MODE>";
					}
				}
				else
				{
					bOk = false;
					sError = "InvalidEventIDGiven";
				}
				m_bCachePage = false;
			}
			else
			{
				bDisplayNotices = true;
				sXML << "<MODE>ALL</MODE>";
			}

			// Insert the notices if requested
			if (bOk && bDisplayNotices)
			{
				// GEt all the notices for the noticeboard
				bOk = Notice.GetNoticeBoardPosts( iForumID,m_iSiteID,sXML);
				if (!bOk)
				{
					TDVASSERT(false,"CNotice::Failed to get all notices for node!");
					sError = "FailedToFindAllNoticesForNode";
				}

				if (bOk)
				{
					// Now get all the future events for the noticeboard.
					bOk = Notice.GetFutureEventsForNode(m_iNodeID,iForumID,m_iSiteID,sXML);
					if (!bOk)
					{
						TDVASSERT(bOk,"CNotice::Failed to get all future events for node!");
						sError = "FailedToFindAllFutureEventsForNode";
					}
				}
			}
		}
	}

	// Check to see if we've got a valid postcoder
	if (!sPostcodeXML.IsEmpty())
	{
		// Finally put the postcoder stuff in.
		m_pPage->AddInside("H2G2",sPostcodeXML);
	}

	// Close and return the page
	if (!bOk)
	{
		if (sError.IsEmpty())
		{
			sError = "ProblemsFindingNotices";
		}

		TDVASSERT(false, sError);
		sXML << "<ERROR>" << sError << "</ERROR>";
	}

	sXML << "</NOTICEBOARD>";

	// Check to see if we're required to cache the results!
	if (bOk && m_bCachePage)
	{
		Notice.CreateNewCachePage(m_iNodeID,m_iSiteID,sXML);
	}

	m_pPage->AddInside("H2G2",sXML);

	return true;
}


/*********************************************************************************

	bool CNoticeBoardBuilder::CreateNewNotice(CTDVString &sType, CTDVString &sXML, CTDVString &sError)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		sType - A string defining the type of notice to create.
						Types can be one of the following...
						'Notice','Event','Alert','Offer' or 'Wanted'
						The body text is treated as GuideXML.
				sXML - A string to take the generated XML
				sError - A string which is used to report any errors.
	Returns:	True if everything ok, false if not
	Purpose:	This creates the XML for the create a notice page.

*********************************************************************************/

bool CNoticeBoardBuilder::CreateNewNotice(CTDVString &sType, CTDVString &sXML, CTDVString &sError)
{
	// Check to see if we can find a match in the type string
	bool bNeedsEventDate = false;
	bool bOk = true;
	CMultiStep Multi(m_InputContext, "");
	if (_stricmp(sType,"notice") == 0)
	{
		Multi.SetType("ADD-NBNOTICE");
	}
	else if (_stricmp(sType,"event") == 0)
	{
		Multi.SetType("ADD-NBEVENT");
		bNeedsEventDate = true;
	}
	else if (_stricmp(sType,"alert") == 0)
	{
		Multi.SetType("ADD-NBALERT");
		bNeedsEventDate = true;
	}
	else if (_stricmp(sType,"wanted") == 0)
	{
		Multi.SetType("ADD-NBWANTED");
	}
	else if (_stricmp(sType,"offer") == 0)
	{
		Multi.SetType("ADD-NBOFFER");
	}
	else
	{
		sError = "Unknown Type of notice given!";
		bOk = false;
	}

	if (bOk)
	{
		// Add the required params
		Multi.AddRequiredParam("title");
		Multi.AddRequiredParam("body");

		// Now process the multi
		bOk = Multi.ProcessInput();
		if (!bOk)
		{
			sError = "Failed to create new notice";
		}
		else
		{
			CNotice NewNotice(m_InputContext);

			// Check to see if we're ready to use the multi stage info
			if (Multi.ReadyToUse())
			{
				bool bEventDateValid = true;
				CTDVString sTitle;
				CTDVString sBody;
				CTDVString sTempBody;
				CTDVString sEventDate;
				Multi.GetRequiredValue("title",sTitle);
				CXMLObject::EscapeXMLText(&sTitle);

				Multi.GetRequiredValue("body",sTempBody);

				// Check to make sure the user has actually given us something to read!
				if (sTitle.IsEmpty() || sTempBody.IsEmpty())
				{
					sError << "NoTextOrBodyGiven";
					bOk = false;
				}

				CTDVString sNewBodyXML;
				if (bOk)
				{
					//dump in the body text even though it may be empty
					sNewBodyXML = "<GUIDE><BODY>" + sTempBody + "</BODY></GUIDE>";

					// Replace the returns with breaks
					CXMLObject::ReplaceReturnsWithBreaks(sNewBodyXML);

					//check to see that we have ended up with valid xml
					CTDVString sParseErrors = CXMLObject::ParseXMLForErrors(sNewBodyXML);
					if (!sParseErrors.IsEmpty())
					{
						sError << "ErrorWithBodyHTMLInput<PARSEERRORS>" << sParseErrors << "</PARSEERRORS><TYPE>" << sType << "</TYPE>";
						bOk = false;
					}
				}
				
				if (bOk)
				{
					CXMLTree * pTree = CXMLTree::Parse(sNewBodyXML);
					if (pTree)
					{
						pTree->OutputXMLTree(sBody);
						delete pTree;
					}
					else
					{
						TDVASSERT(false,"Failed to parse the body text. NULL Tree pointer!");
						sError = "FailedToParseBodyText";
					}
				}

				if (bOk)
				{
					// Check to see if we need date info
					if (bNeedsEventDate)
					{
						CTDVString sYear,sMonth,sDay;
						Multi.GetElementValue("year",sYear);
						Multi.GetElementValue("month",sMonth);
						Multi.GetElementValue("day",sDay);
						if (!sDay.IsEmpty() && !sMonth.IsEmpty() && !sYear.IsEmpty())
						{
							CTDVDateTime tDate;
							tDate.SetDateTime(atoi(sYear),atoi(sMonth),atoi(sDay),23,59,00);

							//Check to make sure the closing date is either today or somewhere in the future
							bEventDateValid = (tDate.GetStatus() == true && tDate >= tDate.GetCurrentTime()) ? true : false;
							if (bEventDateValid)
							{
								// Get the datetime as a database datetime compatible string
								tDate.GetAsString(sEventDate);
							}
							else
							{
								bOk = false;
								sError = "ClosingDateInvalid";
							}
						}
					}

					// Ensure the closing date is valid!
					if (bOk && (bEventDateValid || !bNeedsEventDate))
					{
						// Check to see if we've got at least one node id. Just return if we don't
						CDNAIntArray TagNodeArray;
						if (m_InputContext.ParamExists("tagnode"))
						{
							// Get the list of nodes from the Input
							int iNodeID = 0;
							for (int i = 0; i < m_InputContext.GetParamCount("tagnode"); i++)
							{
								iNodeID = m_InputContext.GetParamInt("tagnode",i);
								if (iNodeID > 0)
								{
									// Add the node to the array
									TagNodeArray.Add(iNodeID);
								}
							}

							// Get the tagitem object to get the node details and add them to the XML
							CCategory Cat(m_InputContext);
							Cat.GetDetailsForNodes(TagNodeArray,"TAGGINGNODES");
							Cat.GetAsString(sXML);
						}

						// Now create the new notice
						int iThreadID = 0;
						bool bProfanityFound = false;
						bool bNonAllowedURLsFound = false;
						bool bEmailAddressFound = false;

						if (!NewNotice.CreateNewNotice(m_iNodeID,m_iSiteID,m_pViewingUser,sType,sTitle,sBody,sEventDate,TagNodeArray,iThreadID, &bProfanityFound, &bNonAllowedURLsFound, &bEmailAddressFound ))
						{
							if (bProfanityFound)
							{
								if ( !PreviewNotice(sType,false, sXML) )
									return false;
							}
							else if (bNonAllowedURLsFound)
							{
								sError = "Failed to create new notice - A Non Alllowed URL was found.";
								bOk = false;
							}
							else if ( bEmailAddressFound )
							{
								sError = "Failed to crate new notice - Possible Email Address Found.";
								bOk = false;
							}
							else
							{
								sError = "Failed to create new notice";
								bOk = false;
							}
						}

						if (bOk)
						{
							NewNotice.GetAsString(sXML);
							m_bCachePage = true;
							HandleRedirect( iThreadID );
							return true;
						}
					}
				}

				// Cancel the op!
				Multi.SetToCancelled();
			}
			
			// Add the multistage to the xml tree
			CTDVString sMultiStep;
			Multi.GetAsXML(sMultiStep);
			sXML << sMultiStep;
		}
	}

	m_bCachePage = false;
	return bOk;
}

/*********************************************************************************

	bool CNoticeBoardBuilder::EditNotice(CTDVString &sType, CTDVString &sXML, CTDVString &sError)

	Author:		Martin Robb
	Created:	05/06/2005
	Inputs:		sType - A string defining the type of notice to create.
						Types can be one of the following...
						'Notice','Event','Alert','Offer' or 'Wanted'
						The body text is treated as GuideXML.
				sXML - A string to take the generated XML
				sError - A string which is used to report any errors.
	Returns:	True if everything ok, false if not
	Purpose:	This creates the XML for the create a notice page.

*********************************************************************************/

bool CNoticeBoardBuilder::EditNotice( int iThreadId, int iForumId, CTDVString &sXML )
{

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if (!SP.ForumGetNoticeInfo(iForumId,iThreadId))
	{
		TDVASSERT(false,"Failed to get the thread details : CNotice::CreateNoticeFromThreadID");
		return false;
	}

	CNotice notice(m_InputContext);
	notice.Initialise(SP,sXML);

	CTDVString sType;
	notice.GetNoticeType(sType);

	// Check to see if we can find a match in the type string
	bool bNeedsEventDate = false;
	bool bOk = true;
	CMultiStep Multi(m_InputContext, "");
	if (_stricmp(sType,"notice") == 0)
	{
		Multi.SetType("EDIT-NBNOTICE");
	}
	else if (_stricmp(sType,"event") == 0)
	{
		Multi.SetType("EDIT-NBEVENT");
		bNeedsEventDate = true;
	}
	else if (_stricmp(sType,"alert") == 0)
	{
		Multi.SetType("EDIT-NBALERT");
		bNeedsEventDate = true;
	}
	else if (_stricmp(sType,"wanted") == 0)
	{
		Multi.SetType("EDIT-NBWANTED");
	}
	else if (_stricmp(sType,"offer") == 0)
	{
		Multi.SetType("EDIT-NBOFFER");
	}
	else
	{
		SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Unknown Type of notice given/Edit functionality not available for this notice type. ");
		return false;
	}

	// Add the required params
	CTDVString sTitle;
	notice.GetNoticeTitle(sTitle);
	Multi.AddRequiredParam("title",sTitle);

	//Body text may be contained in <GUIDE><BODY> tags - get text.
	CTDVString sBody;
	notice.GetNoticeBodyText(sBody);
	CXMLObject::GuideMLToPlainText(&sBody);

	Multi.AddRequiredParam("body",sBody);
	
	Multi.AddRequiredParam("threadid",CTDVString(iThreadId) );
	Multi.AddRequiredParam("forumid",CTDVString(iForumId) );

	// Now process the multi
	if ( !Multi.ProcessInput() )
	{
		SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Failed to process parameters.");
		return false;
	}
	
	CNotice NewNotice(m_InputContext);

	// Check to see if we're ready to use the multi stage info
	if (Multi.ReadyToUse())
	{
		bool bEventDateValid = true;
		CTDVString sTitle;
		CTDVString sBody;
		CTDVString sTempBody;
		CTDVString sEventDate;

		Multi.GetRequiredValue("title",sTitle);
		CXMLObject::EscapeXMLText(&sTitle);
		Multi.GetRequiredValue("body",sTempBody);
		CXMLObject::EscapeXMLText(&sTempBody);

		// Check to make sure the user has actually given us something to read!
		if (sTitle.IsEmpty() || sTempBody.IsEmpty())
		{
			SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice"," No title or body text");
			return false;
		}

		CTDVString sNewBodyXML;
		
		//dump in the body text even though it may be empty
		sNewBodyXML = "<GUIDE><BODY>" + sTempBody + "</BODY></GUIDE>";

		// Replace the returns with breaks
		CXMLObject::ReplaceReturnsWithBreaks(sNewBodyXML);

		//check to see that we have ended up with valid xml
		CTDVString sParseErrors = CXMLObject::ParseXMLForErrors(sNewBodyXML);
		if (!sParseErrors.IsEmpty())
		{
			SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice",sParseErrors);
			return false;
		}
		
		
		CXMLTree * pTree = CXMLTree::Parse(sNewBodyXML);
		if (pTree)
		{
			pTree->OutputXMLTree(sBody);
			delete pTree;
		}
		else
		{
			SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Unable to parse Body");
			return false;
		}
			
		// Check to see if we need date info
		if (bNeedsEventDate)
		{
			CTDVString sYear,sMonth,sDay;
			Multi.GetElementValue("year",sYear);
			Multi.GetElementValue("month",sMonth);
			Multi.GetElementValue("day",sDay);
			if (!sDay.IsEmpty() && !sMonth.IsEmpty() && !sYear.IsEmpty())
			{
				CTDVDateTime tDate;
				tDate.SetDateTime(atoi(sYear),atoi(sMonth),atoi(sDay),23,59,00);

				//Check to make sure the closing date is either today or somewhere in the future
				bEventDateValid = (tDate.GetStatus() == true && tDate >= tDate.GetCurrentTime()) ? true : false;
				if (bEventDateValid)
				{
					// Get the datetime as a database datetime compatible string
					tDate.GetAsString(sEventDate);
				}
				else
				{
					SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Closing date invalid");
					return false;
				}
			}
		}

					
		// Check to see if we've got at least one node id. Just return if we don't
		CDNAIntArray TagNodeArray;
		if (m_InputContext.ParamExists("tagnode"))
		{
			// Get the list of nodes from the Input
			int iNodeID = 0;
			for (int i = 0; i < m_InputContext.GetParamCount("tagnode"); i++)
			{
				iNodeID = m_InputContext.GetParamInt("tagnode",i);
				if (iNodeID > 0)
				{
					// Add the node to the array
					TagNodeArray.Add(iNodeID);
				}
			}

			// Get the tagitem object to get the node details and add them to the XML
			CCategory Cat(m_InputContext);
			Cat.GetDetailsForNodes(TagNodeArray,"TAGGINGNODES");
			Cat.GetAsString(sXML);
		}

		// Now create the new notice
		bool bProfanityFound = false;
		bool bNonAllowedURLsFound = false;
		bool bEmailAddressFound = false;

		int iPostID;
		notice.GetNoticePostID(iPostID);
		if (!NewNotice.EditNotice(iPostID,iThreadId, iForumId, sType, m_pViewingUser,sTitle,sBody,sEventDate, bProfanityFound, bNonAllowedURLsFound, bEmailAddressFound ))
		{
			if (bProfanityFound)
			{
				SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","profanity found");
				PreviewNotice(sType,true, sXML);
			}
			else if (bNonAllowedURLsFound)
			{
				SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Non-allowed URL found");
				return false;
			}
			else if ( bEmailAddressFound )
			{
				SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Email Address Found.");
				return false;
			}
			else
			{
				CopyDNALastError("CNoticeBoardBuilder::EditNotice",NewNotice);
				return false;
			}
		}

						
		NewNotice.GetAsString(sXML);
		m_bCachePage = true;
		HandleRedirect(iThreadId);
		return true;
	}
					
			
	// Add the multistage to the xml tree
	CTDVString sMultiStep;
	Multi.GetAsXML(sMultiStep);
	sXML << sMultiStep;
	m_bCachePage = false;
	return true;
}

/*********************************************************************************

	bool CNoticeBoardBuilder::PreviewNotice(CTDVString &sType, CTDVString &sXML, CTDVString &sError)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		sType - A string defining the type of notice to create.
						Types can be one of the following...
						'Notice','Event','Alert','Offer' or 'Wanted'
						The body text is treated as GuideXML.
				sXML - A string to take the generated XML
				sError - A string which is used to report any errors.
	Returns:	True if everything ok, false if not
	Purpose:	This creates the XML for the preview a notice page.

*********************************************************************************/

bool CNoticeBoardBuilder::PreviewNotice(CTDVString &sType, bool bEditMode, CTDVString &sXML)
{
	// Setup a CNotice Object so we can get the relative info
	CNotice Notice(m_InputContext);

	// Check to make sure the user has permission to do any actions.
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	int iUserID = 0;
	CTDVString sUserName;
	if (pViewingUser)
	{
		// Get the id of the current viewing user
		iUserID = pViewingUser->GetUserID();
		pViewingUser->GetUsername(sUserName);
	}

	// Check to see if we can find a match in the type string
	bool bNeedsEventDate = false;
	CMultiStep Multi(m_InputContext, "");
	if (_stricmp(sType,"notice") == 0)
	{
		if ( bEditMode )
			Multi.SetType("EDIT-NBNOTICEPREVIEW");
		else
			Multi.SetType("ADD-NBNOTICEPREVIEW");
	}
	else if (_stricmp(sType,"event") == 0)
	{
		if ( bEditMode )
			Multi.SetType("EDIT-NBEVENTPREVIEW");
		else
			Multi.SetType("ADD-NBEVENTPREVIEW");
		bNeedsEventDate = true;
	}
	else if (_stricmp(sType,"alert") == 0)
	{
		if ( bEditMode )
			Multi.SetType("EDIT-NBALERTPREVIEW");
		else
			Multi.SetType("ADD-NBALERTPREVIEW");
		bNeedsEventDate = true;
	}
	else if (_stricmp(sType,"wanted") == 0)
	{
		if ( bEditMode )
			Multi.SetType("EDIT-NBWANTEDPREVIEW");
		else
			Multi.SetType("ADD-NBWANTEDPREVIEW");
	}
	else if (_stricmp(sType,"offer") == 0)
	{
		if ( bEditMode )
			Multi.SetType("EDIT-NBWANTEDPREVIEW");
		else
			Multi.SetType("ADD-NBOFFERPREVIEW");
	}
	else
	{
		SetDNALastError("CNoticeBoardBuilder::EditNotice","EditNotice","Invalid notice type.");
		return false;
	}

	// Things we require for notices!
	Multi.AddRequiredParam("title");
	Multi.AddRequiredParam("body");
	
	if (!Multi.ProcessInput())
	{
		SetDNALastError("CNoticeBoardBuilder::PreviewNotice","PreviewNotice","No body or title.");
		return false;
	}
	
	if (Multi.ReadyToUse())
	{
		CTDVString sResult = "<NOTICES>";
		sResult << "<NOTICE TYPE='" << sType << "'>";
		sResult << "<USER>";
		sResult << "<USERID>" << iUserID << "</USERID>";
		sResult << "<USERNAME>" << sUserName << "</USERNAME>";
		sResult << "</USER>";
		CTDVDateTime tPostedDate;
		tPostedDate = tPostedDate.GetCurrentTime();
		CTDVString sDate;
		tPostedDate.GetAsXML(sDate,true);

		CTDVString sBodyText;
		CTDVString sTitle;
		CTDVString sEventDate;
		Multi.GetRequiredValue("title",sTitle);
		CXMLObject::EscapeXMLText(&sTitle);
		sResult << "<TITLE>" << sTitle << "</TITLE>";

		Multi.GetRequiredValue("body",sBodyText);

		//dump in the body text even though it may be empty
		CTDVString sNewBodyXML = "<GUIDE><BODY>" + sBodyText + "</BODY></GUIDE>";

		// Replace the returns with breaks
		CXMLObject::ReplaceReturnsWithBreaks(sNewBodyXML);

		//check to see that we have ended up with valid xml
		CTDVString sParseErrors = CXMLObject::ParseXMLForErrors(sNewBodyXML);
		if (!sParseErrors.IsEmpty())
		{
			SetDNALastError("CNoticeBoardBuilder::PreviewNotice","PreviewNotice",sParseErrors);
			return false;
		}
		
		CXMLTree * pTree = CXMLTree::Parse(sNewBodyXML);
		if (pTree == NULL)
		{
			TDVASSERT(false,"Failed to parse the body text. NULL Tree pointer!");
			SetDNALastError("CNoticeBoardBuilder::PreviewNotice","PreviewNotice","Failed to parse body");
			return false;
		}
		else
		{
			CTDVString sBodyXML;
			pTree->OutputXMLTree(sBodyXML);
			sResult << sBodyXML;
			
			sResult << "<DATEPOSTED>" << sDate << "</DATEPOSTED>";
			sResult << "<DATECLOSING>";

			if (bNeedsEventDate)
			{
				CTDVString sYear,sMonth,sDay;
				Multi.GetElementValue("year",sYear);
				Multi.GetElementValue("month",sMonth);
				Multi.GetElementValue("day",sDay);
				if (!sDay.IsEmpty() && !sMonth.IsEmpty() && !sYear.IsEmpty())
				{
					CTDVDateTime tDate;
					tDate.SetDateTime(atoi(sYear),atoi(sMonth),atoi(sDay),23,59,0);

					//Check to make sure the closing date is either today or somewhere in the future
					if (tDate.GetStatus() == true && tDate >= tDate.GetCurrentTime())
					{
						tDate.GetAsXML(sEventDate);
						sResult << sEventDate;
					}
					else
					{
						SetDNALastError("CNoticeBoardBuilder::PreviewNotice","PreviewNotice","Closing date Invalid");
						return false;
					}
				}
			}
		}
		delete pTree;

		sResult << "</DATECLOSING></NOTICE></NOTICES>";
		sXML << sResult;
	}

	Multi.SetToCancelled();

	CTDVString sMultiStep;
	Multi.GetAsXML(sMultiStep);
	sXML << sMultiStep;

	return true;
}

bool CNoticeBoardBuilder::HandleRedirect( int iThreadID )
{
	//Handle s_returnto param.
	if ( CheckAndUseRedirectIfGiven( m_pPage ) )
		return true;

	// Redirect to the given threadId 
	if ( iThreadID > 0 && m_InputContext.ParamExists("redirect"))
	{
		// Get the redirect
		CTDVString sRedirect;
		m_InputContext.GetParamString("redirect",sRedirect);

		// Make sure we unescape it!
		sRedirect.Replace("%26","&");
		sRedirect.Replace("%3F","?");

		// Check to see if we're trying to go to the tagitem page, if so add the threadid info
		int iTagItem = sRedirect.FindText("tagitem");
		if (iTagItem > -1)
		{
			// Now add the new threadid on the end of the redirect, so the page knows!
			// check for the question mark. If it has then use the '&' before adding the params
			((sRedirect.GetLength() - iTagItem) > 7 && sRedirect[iTagItem + 7] == '?') ? sRedirect << "&" : sRedirect << "?";
			sRedirect << "threadid=" << iThreadID << "&s_threadid=" << iThreadID;
		}
		
		// Add it to the page
		return m_pPage->Redirect(sRedirect);
	}

	return false;
}
