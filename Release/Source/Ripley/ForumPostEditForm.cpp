#include "stdafx.h"
#include "User.h"
#include "ForumPostEditForm.h"
#include "StoredProcedure.h"
#include "ProfanityFilter.h"
#include "tdvassert.h"
#include "URLFilter.h"
#include "EmailAddressFilter.h"
#include "forum.h"

/*********************************************************************************

	CForumPostEditForm::CForumPostEditForm(CDatabaseContext* pDatabaseContext)

	Author:		David van Zijl
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Constructor

*********************************************************************************/

CForumPostEditForm::CForumPostEditForm(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_iPostID(0),
	m_bHavePostDetails(false),
	m_nActive(0),
	m_nJournal(0),
	m_nTaxonomyNode(0),
	m_nStatus(0),
	m_bIncUserPostDetailsViaBBCUID(false),
	m_iForumID(0),
	m_iHidden(0),
	m_IPAddress(0),
	m_iPostIndex(0),
	m_iThreadID(0),
	m_iUserID(0),
	m_bPreview(false)
{
}


/*********************************************************************************

	bool CForumPostEditForm::Build()

	Author:		David van Zijl
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor

*********************************************************************************/

CForumPostEditForm::~CForumPostEditForm()
{
}


/*********************************************************************************

	bool CForumPostEditForm::Build()

	Author:		David van Zijl, mostly ripped off from CEditPostPageBuilder/Kim Harries. 
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Constructs the XML for the current form

*********************************************************************************/

bool CForumPostEditForm::Build()
{
	bool bSuccess = LoadPostDetails();

	CTDVString sXML = "";
	CTDVString sPreview = m_bPreview ? " PREVIEW='1'" : ""; 

	sXML << "<POST-EDIT-FORM" << sPreview << ">";
	sXML << m_sMessageXML;
	if (m_iPostID > 0)
	{
		// if okay then get the data
		if (bSuccess)
		{
			sXML << "<POST-ID>" << m_iPostID << "</POST-ID>";
			sXML << "<THREAD-ID>" << m_iThreadID << "</THREAD-ID>";
			sXML << "<FORUM-ID>" << m_iForumID << "</FORUM-ID>";
			sXML << "<AUTHOR>";
			sXML << "<USER>";
			sXML << "<USERID>" << m_iUserID << "</USERID>";
			sXML << "<USERNAME>" << m_sUserName << "</USERNAME>";
			sXML << "<TITLE>" << m_sTitle << "</TITLE>";
			sXML << "<AREA>" << m_sArea << "</AREA>";
			sXML << "<SITESUFFIX>" << m_sSiteSuffix << "</SITESUFFIX>";
			sXML << "<FIRSTNAMES>" << m_sFirstNames << "</FIRSTNAMES>";
			sXML << "<LASTNAME>" << m_sLastName << "</LASTNAME>";
			sXML << "<ACTIVE>" << m_nActive << "</ACTIVE>";
			sXML << "<JOURNAL>" << m_nJournal << "</JOURNAL>";
			sXML << "<TAXONOMYNODE>" << m_nTaxonomyNode << "</TAXONOMYNODE>";
			sXML << "<STATUS>" << m_nStatus << "</STATUS>";
			sXML << m_sGroups;

			sXML << "</USER>";
			sXML << "</AUTHOR>";

			CTDVString sDateCreated;
			m_DateCreated.GetAsXML(sDateCreated);
			sXML << "<DATE-POSTED>" << sDateCreated << "</DATE-POSTED>";

			CUser* pViewingUser = m_InputContext.GetCurrentUser();
			if (pViewingUser != NULL && pViewingUser->GetIsSuperuser())
			{
				sXML << "<IPADDRESS>" << m_IPAddress << "</IPADDRESS>";
				sXML << "<BBCUID>" << m_BBCUID << "</BBCUID>";
			}

			sXML << "<SUBJECT>" << m_sSubject << "</SUBJECT>";
			sXML << "<TEXT>" << m_sText << "</TEXT>";
			sXML << "<HIDDEN>" << m_iHidden << "</HIDDEN>";
		}
	}
	sXML << "</POST-EDIT-FORM>";

	// Finally, create tree so we can be AddInside'ed
	//
	CreateFromXMLText(sXML);

	if (m_bIncUserPostDetailsViaBBCUID)
	{
		AddUserPostDetailsViaBBCUIDXML();
	}

	return bSuccess;
}


/*********************************************************************************

	bool CForumPostEditForm::ProcessForumPostUpdate(CUser* pUser,const TDVCHAR* pSubject, const TDVCHAR* pText, bool bSetLastUpdated,
									   bool bForceModerateAndHide, bool bIgnoreModeration)
	Author:		David van Zijl
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Updates DB with new subject and text for current post

*********************************************************************************/

bool CForumPostEditForm::ProcessForumPostUpdate(CUser* pUser,const TDVCHAR* pSubject, const TDVCHAR* pText, const TDVCHAR *pEventDate, bool bSetLastUpdated, bool bForceModerateAndHide, bool bIgnoreModeration )
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		SetDNALastError("ForumPostEditForm", "DATABASE", "Internal database error - cannot initialise SP");
		return false;
	}


	if (m_iPostID > 0)
	{
		//Need to refresh due to update.
		m_bHavePostDetails = false;
		return SP.UpdatePostDetails(pUser,m_iPostID, pSubject, pText, pEventDate, bSetLastUpdated, bForceModerateAndHide, bIgnoreModeration);
	}
	else
	{
		return false;
	}
}


/*********************************************************************************

	bool CForumPostEditForm::HidePost()

	Author:		David van Zijl
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Hides the current post
				If post being hidden is first post the thread will automatically be closed - 12/11/2007 .

*********************************************************************************/

bool CForumPostEditForm::HidePost( int iHiddenStatus )
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		SetDNALastError("ForumPostEditForm", "DATABASE", "Internal database error - cannot initialise SP");
		return false;
	}

	if (m_iPostID == 0)
	{
		SetDNALastError("CForumPostEditForm::HidePost","UnhidePost", "Unable to hide post. Invalid postId");
		return false;
	}

	if ( !m_InputContext.GetCurrentUser() ) 
	{
		SetDNALastError("CForumPostEditForm::HidePost","UnhidePost", "Not Logged In.");
		return false;
	}

	//Load Details.
	if ( !m_bHavePostDetails )
	{
		if ( !LoadPostDetails() )
		{
			SetDNALastError("CForumPostEditForm::HidePost","HidePost","Load Post Details failed");
			return false;
		}
	}

	if ( !m_InputContext.GetCurrentUser()->GetIsEditor() ) 
	{
		//Check post has not been moderated.
		if ( m_iHidden > 0 && m_iHidden != CStoredProcedure::HIDDENSTATUSUSERHIDDEN )
		{
			SetDNALastError("CForumPostEditForm::HidePost", "HidePost", "Cannot Hide post due to moderation.");
			return false;
		}

		//A normal user can only user-hide a post.
		if ( iHiddenStatus != CStoredProcedure::HIDDENSTATUSUSERHIDDEN )
		{
			SetDNALastError("CForumPostEditForm::HidePost", "HidePost", "Invalid Hidden Status");
			return false;
		}
	}


	if ( iHiddenStatus != m_iHidden )
	{
		if (!SP.HidePost( m_iPostID, iHiddenStatus ) )
		{
			m_bHavePostDetails = false;
			SetDNALastError("CForumPostEditForm::HidePost", "HidePost", "Unable to hide post.");
			return false;
		}
		m_iHidden = iHiddenStatus;

		//Automatically close the thread if this is the first post and site option set.
		if ( m_iPostIndex == 0 && m_InputContext.GetCurrentSiteOptionInt("Moderation","CloseThreadOnHideFirstPost") != 0 )
		{
			if ( !SP.CloseThread(m_iThreadID,false) )
			{
				SetDNALastError("CForumPostEditForm::HidePost", "HidePost", "Unable to close thread.");
				return false;
			}
			m_sMessageXML << "<MESSAGE TYPE='THREADCLOSED'>Thread automatically closed.</MESSAGE>\n";
		}
	}
	return true;
}

/*********************************************************************************

	bool CForumPostEditForm::UnhidePost()

	Author:		David van Zijl
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Unhides/Restores the current post.
				Normal useres can only unhide a post that has been user-hidden ( hidden status = 7 )
				If Post being unhidden is first post the thread will automatically be reopened - 12/11/2007

*********************************************************************************/

bool CForumPostEditForm::UnhidePost( )
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		SetDNALastError("ForumPostEditForm:UnhidePost", "DATABASE", "Internal database error - cannot initialise SP");
		return false;
	}

	if (m_iPostID == 0)
	{
		SetDNALastError("CForumPostEditForm::UnhidePost","UnhidePost", "Unable to unhide post. Invalid postId");
		return false;
	}

	if ( !m_InputContext.GetCurrentUser() )
	{
		SetDNALastError("CForumPostEditForm::UnhidePost","UnhidePost", "Not Logged In.");
		return false;
	}
	
	//Might need to load details.
	if ( !m_bHavePostDetails )
	{
		if ( !LoadPostDetails() )
		{
			SetDNALastError("CForumPostEditForm::UnhidePost","UnhidePost", "Could not load post details.");
			return false;
		}
	}

	//Dont allow a non-editor to unhide a moderated post.
	if ( !m_InputContext.GetCurrentUser()->GetIsEditor() )
	{
		if ( m_iHidden > 0 && m_iHidden !=  CStoredProcedure::HIDDENSTATUSUSERHIDDEN )
		{
			SetDNALastError("CForumPostEditForm::UnhidePost","UnhidePost", "Post cannot be restored due to moderation. ");
			return false;
		}
	}

	if ( m_iHidden > 0 )
	{

		if ( !SP.UnhidePost(m_iPostID ) )
		{
			//Hide and invalidate data.
			m_bHavePostDetails = false;
			SetDNALastError("CForumPostEditForm::UnhidePost","UnhidePost", "Unable to unhide post.");
			return false;
		}
		m_iHidden = 0;

		//Automatically reinstate the thread if this is the first post.
		if ( m_iPostIndex == 0 && m_InputContext.GetCurrentSiteOptionInt("Moderation","CloseThreadOnHideFirstPost") != 0  )
		{
			CForum forum(m_InputContext);
			if ( !forum.UnHideThreadFromUsers(m_iThreadID, m_iForumID) )
			{
				SetDNALastError("CForumPostEditForm::UnHidePost", "HidePost", "Unable to reopen thread.");
				return false;
			}
			m_sMessageXML << "<MESSAGE TYPE='THREADOPENED'>Thread automatically opened.</MESSAGE>\n";
		}
	}
	
	return true;
}


/*********************************************************************************

	bool CForumPostEditForm::Cancel()

	Author:		David van Zijl
	Created:	10/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Cancels the form, the output from Build() will be an empty 
				<POST-EDIT-FORM> tag

*********************************************************************************/

bool CForumPostEditForm::Cancel()
{
	// set post ID to zero to clear the form
	m_iPostID = 0;

	return true;
}

/*********************************************************************************

	bool CForumPostEditForm::LoadPostDetails(bool bForceFetch)

	Author:		David van Zijl
	Created:	16/11/2004
	Inputs:		bForceFetch - true to force the DB query to fetch latest info
	Outputs:	-
	Returns:	true on success
	Purpose:	Loads post details ONCE only. Call this to set internal post values 
				and then when called again it will not re-run the DB query unless 
				bForceFetch is set.

*********************************************************************************/

bool CForumPostEditForm::LoadPostDetails(bool bForceFetch)
{
	if (bForceFetch || !m_bHavePostDetails)
	{
		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			SetDNALastError("ForumPostEditForm", "DATABASE", "Internal database error - cannot initialise SP");
			return false;
		}

		if (!SP.FetchPostDetails(m_iPostID))
		{
			SetDNALastError("ForumPostEditForm", "DATABASE", "Error in FetchPostDetails");
			return false;
		}

		m_bPreview = false;
		m_iThreadID = SP.GetIntField("ThreadID");
		m_iForumID  = SP.GetIntField("ForumID");
		m_iUserID   = SP.GetIntField("UserID");
		m_iHidden   = SP.GetIntField("Hidden");
		m_iPostIndex = SP.GetIntField("PostIndex");
		m_iSiteID   = SP.GetIntField("SiteID");

		m_DateCreated = SP.GetDateField("DatePosted");

		SP.GetField("UserName", m_sUserName);
		SP.GetField("Subject", m_sSubject);
		CXMLObject::EscapeXMLText(&m_sSubject);
		SP.GetField("Text", m_sText);
		CXMLObject::EscapeXMLText(&m_sText);

		SP.GetField("Title", m_sTitle);
		CXMLObject::EscapeXMLText(&m_sTitle);

		SP.GetField("Area", m_sArea);
		CXMLObject::EscapeXMLText(&m_sArea);

		SP.GetField("SiteSuffix", m_sSiteSuffix);
		CXMLObject::EscapeXMLText(&m_sSiteSuffix);

		SP.GetField("FirstNames", m_sFirstNames);
		CXMLObject::EscapeXMLText(&m_sFirstNames);

		SP.GetField("LastName", m_sLastName);
		CXMLObject::EscapeXMLText(&m_sLastName);

		m_nActive		= SP.GetIntField("Active");
		m_nJournal		= SP.GetIntField("Journal");
		m_nTaxonomyNode	= SP.GetIntField("TaxonomyNode");
		m_nStatus		= SP.GetIntField("Status");

		SP.GetField("IPAddress",m_IPAddress);
		SP.GetField("BBCUID",m_BBCUID);

		if(!m_InputContext.GetUserGroups(m_sGroups, m_iUserID))
		{
			TDVASSERT(false, "Failed to get user groups");
		}
		
		m_bHavePostDetails = true;
	}

	return true;
}

/*********************************************************************************

	bool CForumPostEditForm::CheckUserCanEditRecentPost()

	Author:		David van Zijl
	Created:	16/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	true if viewing user can edit this post
	Purpose:	Checks if the user is the owner of the post and that it's editing
				time window is still open. Doesn't necessarily allow editors in, 
				they should use EditPostPageBuilder which does the checking itself.

*********************************************************************************/

bool CForumPostEditForm::CheckUserCanEditRecentPost()
{
	if (m_iPostID <= 0)
	{
		SetDNALastError("CForumPostEditForm", "INTERNAL", "PostID has not been set!");
		return false;
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		return false;
	}

	// Get post info
	if (!LoadPostDetails())
	{
		return false;
	}

	// Conditions for allowing editing
	// 1. This site must allow it (timelimit > 0)
	// 2. Viewing user must be the post author
	// 3. Post must be within time limit
	//
	int iThreadEditTimeLimit = m_InputContext.GetThreadEditTimeLimit();
	bool bSiteAllowsRecentEdits = (iThreadEditTimeLimit > 0);

	// How long ago was this created? Round up to give the benefit of the doubt
	COleDateTime currTime = COleDateTime::GetCurrentTime();
	COleDateTimeSpan Difference = currTime - (COleDateTime)m_DateCreated;
	long liMinutesLeft = iThreadEditTimeLimit - (long)Difference.GetTotalMinutes();

	if (bSiteAllowsRecentEdits
		&& m_iUserID == pViewingUser->GetUserID()
		&& liMinutesLeft > 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}


/*********************************************************************************

	bool CForumPostEditForm::ValidatePostDetails(CTDVString& sSubject, CTDVString& sBody,
												PostUpdateError& errorType)

	Author:		David van Zijl
	Created:	19/11/2004
	Inputs:		pSubject - post subject
				pBody - post body
	Outputs:	errorType - errors will go here
	Returns:	true if content can be updated
	Purpose:	Checks post for various problems like too long, too many smilies, 
				requires moderation. Will pass various errors in XML format to sErrors.

*********************************************************************************/

bool CForumPostEditForm::ValidatePostDetails(CTDVString sSubject, CTDVString sBody, PostUpdateError& errorType)
{
	errorType = NONE;

	if (sBody.GetLength() > 200*1024)
	{
		errorType = TOOLONG;
		m_sMessageXML << "<MESSAGE TYPE='TOOLONG'>Posting is too long.</MESSAGE>\n";
		SetDNALastError("CForumPostEditForm::ValidatePostDetails","ValidatePostDetails","Posting is too long.");
		return false;
	}

	if (!m_InputContext.ConvertPlainText(&sBody, 200))
	{
		errorType = TOOMANYSMILIES;
		m_sMessageXML << "<MESSAGE TYPE='TOOMANYSMILEYS'>Your posting contained too many smileys.</MESSAGE>\n";
		SetDNALastError("CForumPostEditForm::ValidatePostDetails","ValidatePostDetails","Your posting contained too many smileys.");
		return false;
	}

	if(m_InputContext.IsCurrentSiteURLFiltered() && !(m_InputContext.GetCurrentUser()->GetIsEditor() || m_InputContext.GetCurrentUser()->GetIsNotable()))
	{
		CURLFilter oURLFilter(m_InputContext);
		CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sSubject + " " + sBody);
		if (URLFilterState == CURLFilter::Fail)
		{
			errorType = CONTAINSNONALLOWEDURLS;
			m_sMessageXML << "<MESSAGE TYPE='CONTAINSNONALLOWEDURLS'>Your posting contained a non allowed url.</MESSAGE>\n";
			SetDNALastError("CForumPostEditForm::ValidatePostDetails","ValidatePostDetails","Your posting contained a non allowed url.");
			//return immediately - these don't get submitted
			return false;
		}
	}

	// For the following errors, continue with update but produce warning

	// Check for profanities
	//
	CProfanityFilter ProfanityFilter(m_InputContext);
	CTDVString sCheck = sSubject;
	sCheck << " " << sBody;
	bool bProfanitiesFound = false;
	CProfanityFilter::FilterState filterState = ProfanityFilter.CheckForProfanities(sCheck);
	if (filterState == CProfanityFilter::FailBlock)
	{
		errorType = CONTAINSPROFANITIES;
		m_sMessageXML << "<MESSAGE TYPE='CONTAINSPROFANITIES'>Your posting is hidden pending moderation.</MESSAGE>\n";
		SetDNALastError("CForumPostEditForm::ValidatePostDetails","ValidatePostDetails","Your posting is hidden pending moderation.");
		return false;
	}

	//Filter for email addresses.
	CEmailAddressFilter emailfilter;
	if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(m_InputContext.GetCurrentUser()->GetIsEditor() || m_InputContext.GetCurrentUser()->GetIsNotable()) && emailfilter.CheckForEmailAddresses(sCheck) )
	{
		errorType = CONTAINSEMAILADDRESS;
		m_sMessageXML << "<MESSAGE TYPE='CONTAINSEMAILADDRESS'>Your posting appears to contain an email address.</MESSAGE>\n";
		SetDNALastError("CForumPostEditForm::ValidatePostDetails","ValidatePostDetails","Your posting appears to contain an email address.");
		return false;
	}

	//Dont allow editing of hidden posts. Afterall whats the point.
	if ( m_iHidden > 0 )
	{
		errorType = HIDDEN;
		m_sMessageXML << "<MESSAGE TYPE='HIDDEN'>Attempting to edit hidden post.</MESSAGE>\n";
		SetDNALastError("CForumPostEditForm::ValidatePostDetails","ValidatePostDetails","Attempting to edit hidden post.");
		return false;
	}

	return errorType == CForumPostEditForm::NONE;
}

/*********************************************************************************

	bool CForumPostEditForm::AddUserPostDetailsViaBBCUIDXML()

		Author:		Mark Neves
		Created:	19/06/2006
		Inputs:		-
		Outputs:	-
		Returns:	true if ok, false otherwise
		Purpose:	Creates a XML block detailing all the posts that have the same BBCUID as the current post,
					then adds the XML to the page.

*********************************************************************************/

bool CForumPostEditForm::AddUserPostDetailsViaBBCUIDXML()
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumPostEditForm", "AddUserPostDetailsViaBBCUIDXML", "Cannot initialise SP");
	}
	
	if (!SP.GetUserPostDetailsViaBBCUID(m_BBCUID))
	{
		return SetDNALastError("ForumPostEditForm", "AddUserPostDetailsViaBBCUIDXML", "Call to GetUserPostDetailsViaBBCUID failed");
	}

	CDBXMLBuilder cXML;
	cXML.Initialise(NULL,&SP);

	cXML.OpenTag("POSTSWITHSAMEBBCUID");
	while (!SP.IsEOF())
	{
		cXML.OpenTag("POST");
		cXML.DBAddIntTag("userid");
		cXML.DBAddTag("username");
		cXML.DBAddIntTag("forumid");
		cXML.DBAddIntTag("threadid");
		cXML.DBAddIntTag("entryid");
		cXML.DBAddIntTag("postindex");
		cXML.DBAddDateTag("dateposted");
		cXML.CloseTag("POST");

		SP.MoveNext();
	}

	cXML.CloseTag("POSTSWITHSAMEBBCUID");

	AddInside("POST-EDIT-FORM",cXML.GetXML());

	return true;
}

