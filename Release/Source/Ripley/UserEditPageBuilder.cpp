// UserEditPageBuilder.cpp: implementation of the CUserEditPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

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
#include "ripleyserver.h"
#include "UserEditPageBuilder.h"
#include "PageUI.h"
#include "GuideEntry.h"
#include "PageBody.h"
#include "Forum.h"
#include "TDVAssert.h"
#include "ReviewForum.h"
#include "ReviewSubmissionForum.h"
#include "Club.h"
#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CUserEditPageBuilder::CUserEditPageBuilder(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	16/03/2000
	Modified:	24/07/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CUserEditPageBuilder object.

*********************************************************************************/

CUserEditPageBuilder::CUserEditPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pPage(NULL),
	m_pViewer(NULL),
	m_pForm(NULL),
	m_h2g2ID(0),
	m_IsMasthead(false),
	m_MakeHidden(false),
	m_DoRedirect(false),
	m_OldFormat(0),
	m_NewFormat(0),
	m_IsUberEditor(false),
	m_SiteID(0),
	m_Submittable(0),
	m_CanMakeSubmittable(false),
	m_MoveToSiteID(-1),
	m_iEditor(0),
	m_iStatus(0),
	m_bGotAction(false),
	m_sAction(NULL),
	m_bArchive(false),
	m_bUpdateDateCreated(false),
	m_iPreProcessed(-1)
{
	// no further initialisation
}

/*********************************************************************************

	CUserEditPageBuilder::~CUserEditPageBuilder()
																			 ,
	Author:		Kim Harries
	Created:	16/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CUserEditPageBuilder::~CUserEditPageBuilder()
{
	// delete form object just in case
	delete m_pForm;
	m_pForm = NULL;

}

/*********************************************************************************

	CWholePage* CUserEditPageBuilder::Build()
																			 ,
	Author:		Kim Harries
	Created:	16/03/2000
	Modified:	24/07/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML representation of
				the user edit page.
	Purpose:	Construct a user page from its various constituent parts based
				on the request info available from the input context supplied during
				construction.

	Notes:		It is important to be careful when using the CreateSimplePage method
				that you are not assigning to a pointer that is non-NULL.

				Also note that the m_pArticleFromDB and m_pArticleFromRequest member
				pointers can possibly point to the same object, so it is important
				to be aware of this when deleting or changing them.

*********************************************************************************/

bool CUserEditPageBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	bool bSuccess = true;

	// first get the viewing user
	m_pViewer = m_InputContext.GetCurrentUser();
	// if there is no viewing user (i.e. they are not logged-in) they should not
	// be going to this page so some error has occurred
	if (m_pViewer == NULL)
	{
		// pointer should be NULL, but delete it just in case anyhow
		bSuccess = InitPage(m_pPage, "ERROR",true);
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='UNREGISTERED-USEREDIT'>You cannot add or edit Guide Entries unless you are registered as a researcher and currently logged on.</ERROR>");
		// if not successful make sure page is deleted
		return bSuccess;
	}

	if (bSuccess)
	{
		// process the URL parameters and set the associated member variables
		ProcessParameters();
	}
	// if we have been given an ID we are editing an existing article
	// if ID is zero then we are editing a new entry, so we only need the data
	// from the submission
	// create an object representing the existing article as appropriate
	if (!m_Command.CompareText("RemoveSelf"))
	{
		bSuccess = bSuccess && CreateArticleEditForm();

		//if you are looking at an existing article, check to see if you have edit status
		if (bSuccess && m_h2g2ID > 0)
		{
			// check that the viewer has edit permission for the article they are attempting
			// to edit. This also checks that it is a valid h2g2ID
			int ViewerStatus = 0;
			m_pViewer->GetStatus(&ViewerStatus);
			if (!bSuccess || m_pForm == NULL || !(m_pForm->HasEditPermission(m_pViewer)/* || (ViewerStatus > 1)*/))
			{
				// TODO: more information?
				return CreateSimplePage(m_pPage, "Permission Denied", "<USERACTION TYPE='EDITENTRY' RESULT='0' REASON='nopermission'/>");
			}
		}

		// only have UberEditor rights in admin version
#if defined (_ADMIN_VERSION)
		// find out if the viewer has special edit permission due to being
		// an editor or a moderator
		m_IsUberEditor = m_pViewer->HasSpecialEditPermissions(m_pForm->GetH2G2ID());
		// UberEditors can hide and unhide things, aren't they lucky?
		//they can also change submittable

		if (m_IsUberEditor)
		{
			m_pForm->SetHasChangeSubmittableFunction(true);
			m_pForm->SetHasHideFunction(true);
		}
#endif
	}
	
	InitialisePage();
	
	CTDVString sURL;
	sURL << "UserEdit" << m_h2g2ID;
	
	// Try switching sites unless the page is a masthead
	if (	(m_pForm != NULL) 
		&&	(m_pForm->GetSiteID() > 0) 
		&&	(!m_pForm->IsMasthead())
		&&	(DoSwitchSites(m_pPage, sURL, m_InputContext.GetSiteID(), m_pForm->GetSiteID(), &m_pViewer)))
	{
		return true;
	}
	
	// we need to check again that the user is logged in
	if (m_pViewer == NULL)
	{
		bSuccess = InitPage(m_pPage, "ERROR",true);
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='UNREGISTERED-USEREDIT'>You cannot add or edit Guide Entries unless you are registered as a researcher and currently logged on.</ERROR>");
		return bSuccess;
	}

	// Check to see if the site is closed, if so then only editors can do anything at this point!
	bool bSiteClosed = false;
	if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
	{
		// Report back to the user
		bSuccess = InitPage(m_pPage, "ERROR",true);
		return bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='GETSITEDETAILS'>Failed to get the sites open / close status.</ERROR>");
	}
	if (bSiteClosed && !m_pViewer->GetIsEditor())
	{
		// Report back to the user
		bSuccess = InitPage(m_pPage, "ERROR",true);
		return bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='SITECLOSED'>You cannot add or edit Guide Entries while the site is closed.</ERROR>");
	}

	// Now see if the user is banned.
	// If the page isn't a masthead, or the sites match just call GetIsBanned...
	// If it *is* a masthead *and* the sites don't match, create a CUser object from the 
	// site in question, and call GetIsBanned on that one
	bool bIsBanned = false;
	if (m_pForm == NULL || !m_pForm->IsMasthead() || (m_InputContext.GetSiteID() == m_pForm->GetSiteID()))
	{
		bIsBanned = m_pViewer->GetIsBannedFromPosting();
	}
	else
	{
		CUser user(m_InputContext);
		user.SetSiteID(m_pForm->GetSiteID());
		user.CreateFromID(m_pViewer->GetUserID());
		bIsBanned = user.GetIsBannedFromPosting();
	}

	if (bIsBanned)
	{
		// pointer should be NULL, but delete it just in case anyhow
		bSuccess = InitPage(m_pPage, "ERROR",true);
		
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='RESTRICTED-USEREDIT'>You are restricted from adding or editing Guide Entries.</ERROR>");
		
		return bSuccess;
	}
	
	
	// now find out what kind of request we have and process it accordingly

	if (bSuccess)
	{
		if (m_Command.CompareText("RemoveSelf"))
		{
			bSuccess = (m_pViewer != NULL) && ProcessRemoveSelfFromResearchers();
			int iUserID = 0;
			if (m_pViewer != NULL)
			{
				iUserID = m_pViewer->GetUserID();
			}
			CGuideEntry entry(m_InputContext);
			entry.Initialise(m_h2g2ID,m_InputContext.GetSiteID(), NULL, true,true,true,true,false);
			CTDVString sArticleSubject;
			entry.GetSubject(sArticleSubject);
			CForum::MakeSubjectSafe(&sArticleSubject);
			CTDVString msg;
			if (bSuccess)
			{
				msg << "<USERACTION RESULT='1' TYPE='REMOVESELFFROMRESEARCHERLIST'><USERID>" << iUserID 
					<< "</USERID><H2G2ID>" << m_h2g2ID << "</H2G2ID>"
					<< "<SUBJECT>" << sArticleSubject << "</SUBJECT></USERACTION>";
				 CreateSimplePage(m_pPage, "Processed successfully", msg);
			}
			else
			{
				msg << "<USERACTION RESULT='0'";
				if (m_pViewer == NULL)
				{
					msg << " REASON='unregistered'";
				}
				else if (entry.GetEditorID() == iUserID)
				{
					msg << " REASON='iseditor'";
				}
				else
				{
					msg << " REASON='notresearcher'";
				}
				msg << " TYPE='REMOVESELFFROMRESEARCHERLIST'><USERID>" << iUserID
					<< "</USERID><H2G2ID>" << m_h2g2ID << "</H2G2ID>"
					<< "<SUBJECT>" << sArticleSubject << "</SUBJECT></USERACTION>";
				CreateSimplePage(m_pPage, "Error", msg);
			}
		}
		else
		if (m_Command.CompareText("delete"))
		{
			// delete requests do not display the edit form afterwards, since
			// you cannot edit a deleted entry
			bSuccess = ProcessDeleteRequest(true);
		}
		else if(m_Command.CompareText("deletereview"))
		{
			bSuccess = ProcessDeleteRequest(false);
		}
		else if (m_Command.CompareText("undelete"))
		{
			// undelete requests do not come from within the edit page, but from
			// outside pages, e.g. MorePages
			bSuccess = ProcessUndeleteRequest();
		}
		else if (m_Command.CompareText("view"))
		{
			// this is a first visit to the edit page, so create the edit form
			// *without* a preview
			bSuccess = CreateFormInPage(false);
		}
		else if (m_Command.CompareText("preview"))
		{
			// create the edit form with a preview of how the current edit version
			// of the article will look
			bSuccess = CreateFormInPage(true);
		}
		else if (m_Command.CompareText("reformat"))
		{
			// process reformatting the article
			bSuccess = ReformatArticle();
			// create the edit form with a preview of how the current edit version
			// of the article will look
			bSuccess = bSuccess && CreateFormInPage(true);
		}
		else if (m_Command.CompareText("addentry"))
		{
			// this will perform the update and produce a page that redirects to
			// the newly created entry
			bSuccess = ProcessUpdate();
		}
		else if (m_Command.CompareText("update"))
		{
			// this will perform the update and produce a page that redirects to
			// the updated entry
			bSuccess = ProcessUpdate();
		}
		else if (m_Command.CompareText("consider"))
		{
			// process the request to change the status of the Guide Entry
			// then show the form again
			bSuccess = ProcessStatusChange(true);
			// TODO: include preview?
			bSuccess = bSuccess && CreateFormInPage(false);
		}
		else if (m_Command.CompareText("unconsider"))
		{
			// process the request to change the status of the Guide Entry
			// then show the form again
			bSuccess = ProcessStatusChange(false);
			// TODO: include preview?
			bSuccess = bSuccess && CreateFormInPage(false);
		}
		else if (m_Command.CompareText("removeresearchers") || m_Command.CompareText("addresearchers") || m_Command.CompareText("setresearchers"))
		{
			// process the change to the researcher list
			bSuccess = ProcessResearchersChange();
			// create the form inside the page
			bSuccess = bSuccess && CreateFormInPage(false);
		}
		else if (m_Command.CompareText("MoveToSite"))
		{
			//check if current user is allowed to move article
			if (m_pForm->HasMoveToSiteFunction())
			{
				// this will move article and it's forums to specified site
				bSuccess = m_pForm->MoveToSite(m_MoveToSiteID);
				CTDVString sTemp;
				sTemp << "Moved to the site ID=" << m_MoveToSiteID;
				bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 4, sTemp);
				bSuccess = bSuccess && RedirectToEdit();
			}
		}
		else
		{
			CTDVString msg;
			msg << "<USERACTION RESULT='1' TYPE='UNRECOGNISEDCOMMAND'>The request did not contain a valid command.</USERACTION>";
			// Unrecognised action command, so give an error page
			CreateSimplePage(m_pPage, "Unrecognised Command", msg);
			//bSuccess = false;
		}
	}
	// if something went wrong and we haven't produced any page yet then try to
	// ceate an error page
//	if (!bSuccess && m_pPage == NULL)
//	{
//		CTDVString msg;
//		msg << "<USERACTION RESULT='1' TYPE='UNSPECIFIEDERROR'>An unknown error occured whilst processing your request.</USERACTION>";
//		// TODO: can we inprove this error?
//		m_pPage = CreateSimplePage("Unspecified Error", msg);
//	}
	// delete the temporary xml objects and return whatever page we created
	delete m_pForm;
	m_pForm = NULL;
	return true;
}

/*********************************************************************************

	void CUserEditPageBuilder::ProcessParameters()
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Extracts the parameters from the URL and processes them if necessary
				then puts them in the appropriate member variables. Always provides
				some sensible values for the variables so never fails.

*********************************************************************************/

void CUserEditPageBuilder::ProcessParameters()
{
	// get all the parameters that have been passed in the URL
	m_h2g2ID = m_InputContext.GetParamInt("id");
	m_SiteID = m_InputContext.GetSiteID();
	m_OldFormat = m_InputContext.GetParamInt("format");
	if (m_OldFormat == 0)
	{
		m_OldFormat = 2;
	}
	m_NewFormat = m_InputContext.GetParamInt("newformat");
	if (m_NewFormat == 0)
	{
		m_NewFormat = 2;
	}
	m_InputContext.GetParamString("subject", m_Subject);
	m_InputContext.GetParamString("body", m_Body);
	m_iEditor = m_InputContext.GetParamInt("editor");
	m_iStatus = m_InputContext.GetParamInt("status");
	// get value of the 'Hide' button if any
	if (m_InputContext.ParamExists("Hide"))
	{
		m_MakeHidden = (m_InputContext.GetParamInt("Hide") == 1);
	}
	//get the value of the submittable button if any
	if (m_InputContext.ParamExists("NotForReview"))
	{
		m_Submittable = !(m_InputContext.GetParamInt("NotForReview") == 1);
	}
	else
	{
		m_Submittable = 1;
	}

	m_CanMakeSubmittable = m_InputContext.ParamExists("CanSubmit");
	
	if (m_InputContext.ParamExists("preprocessed"))
	{
		m_iPreProcessed = m_InputContext.GetParamInt("preprocessed");
	}

	//On update - it may be desirable to reset the date created.
	if ( m_InputContext.ParamExists("updatedatecreated") && m_pViewer && (m_pViewer->GetIsEditor() || m_pViewer->GetIsSuperuser()) )
	{
		m_bUpdateDateCreated = (m_InputContext.GetParamInt("updatedatecreated") != 0);
	}

	if (m_InputContext.ParamExists("cmd"))
	{
		// if there is a cmd parameter then this says what action to do
		m_InputContext.GetParamString("cmd", m_Command);
		// if this is a submit request then find out exactly which type and set
		// the command variable appropriately
		if (m_Command.CompareText("Submit"))
		{
			if (m_InputContext.ParamExists("Preview"))
			{
				m_Command = "Preview";
			}
			else if (m_InputContext.ParamExists("Reformat"))
			{
				m_Command = "Reformat";
			}
			else if (m_InputContext.ParamExists("Update"))
			{
				m_Command = "Update";
			}
			else if (m_InputContext.ParamExists("AddEntry"))
			{
				m_Command = "AddEntry";
			}
			else if (m_InputContext.ParamExists("RemoveResearchers"))
			{
				m_Command = "RemoveResearchers";
			}
			else if (m_InputContext.ParamExists("RemoveSelf"))
			{
				m_Command = "RemoveSelf";
			}
			else if (m_InputContext.ParamExists("AddResearchers"))
			{
				m_Command = "AddResearchers";
			}
			else if (m_InputContext.ParamExists("SetResearchers"))
			{
				m_Command = "SetResearchers";
			}
			else
			{
				// if we have an invalid submit request then make it a view request
				// instead and log an error
				TDVASSERT(false, "Invalid submit type in CUserEditPageBuilder::ProcessParameters()");
				m_Command = "View";
			}
		}
		else 
		if (m_Command.CompareText("MoveToSite"))
		{
			m_MoveToSiteID = m_InputContext.GetParamInt("SitesList");
			m_h2g2ID = m_InputContext.GetParamInt("moveObjectID");
		}
	}
	else
	{
		// if there is no cmd parameter then assume we are coming to editor for first time
		m_Command = "View";
	}

	// if there is a masthead param and its value is 1, we are editing a masthead
	// or if the ID is non-zero and the same as the viewers masthead ID, we are
	// editing a masthead. Otherwise we are not.
	if (m_InputContext.GetParamInt("Masthead") == 1 ||
		m_h2g2ID != 0 && m_h2g2ID == m_pViewer->GetMasthead())
	{
		m_IsMasthead = true;
		m_h2g2ID = m_pViewer->GetMasthead();
	}
	else
	{
		m_IsMasthead = false;
	}
	m_bGotAction = m_InputContext.GetParamString("action",m_sAction);

	// Read poll types wanted for this page and store in a vector
	m_vecPollTypes.clear();
	int nPollParamIndex = 0;
	int nPollParamVal = 0;

	while((nPollParamVal = m_InputContext.GetParamInt("polltype", nPollParamIndex)) 
		&& nPollParamIndex < 100) // limit to 100 per page for safety
	{
		POLLDATA polldata;
		polldata.m_Type = static_cast<CPoll::PollType>(nPollParamVal);
			
		//Retrieve corresponding minimum response value for this poll type. 
		if ( m_InputContext.ParamExists("pollminresponse",nPollParamIndex) )
			polldata.m_ResponseMin = m_InputContext.GetParamInt("pollminresponse",nPollParamIndex);
		
		//Retrieve corresponding maximum response value for this poll type.
		if ( m_InputContext.ParamExists("pollmaxresponse",nPollParamIndex) )
			polldata.m_ResponseMax = m_InputContext.GetParamInt("pollmaxresponse",nPollParamIndex);


		polldata.m_AllowAnonymousRating = false;
		//Retrieve allow anonymous rating value for this poll type.
		if ( m_InputContext.ParamExists("allowanonymousrating", nPollParamIndex) )
		{
			CTDVString sAllowAnonymousRating; 
				
			m_InputContext.GetParamString("allowanonymousrating", sAllowAnonymousRating, nPollParamIndex);

			if (sAllowAnonymousRating == "1" || sAllowAnonymousRating == "true")
			{
				polldata.m_AllowAnonymousRating = true;
			}
		}

		m_vecPollTypes.push_back(polldata);
		
		++nPollParamIndex;
	}
	
}

/*********************************************************************************

	bool CUserEditPageBuilder::ProcessDeleteRequest(bCheckReviewForum)
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Modified:	24/07/2000
	Inputs:		bCheckReviewForum - true if you want to check if it is in a review forum
				and you want to warn the user, false and it will remove from review forum then delete
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Processes a delete request and produces and appropriate page depending
				on if it succeeds or fails. Hence even if the delete operation is
				unsuccessfull a page should still be produced.

*********************************************************************************/

bool CUserEditPageBuilder::ProcessDeleteRequest(bool bCheckReviewForum)
{
	TDVASSERT(m_pViewer != NULL, "CUserEditPageBuilder::ProcessDeleteRequest() called with NULL m_pViewer");
	TDVASSERT(m_pForm != NULL, "CUserEditPageBuilder::ProcessDeleteRequest() called with NULL m_pArticleFromDB");

	bool bSuccess = true;

	// check if the viewer is allowed to delete this entry
	if (m_pForm == NULL || !m_pForm->HasEditPermission(m_pViewer))
	{
		// if they do not have edit permission then display an appropriate error page
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='DELETEGUIDEENTRY' REASON='nopermission'/>";
		CreateSimplePage(m_pPage, "Entry could not be deleted", msg);
		bSuccess = false;
	}
	else
	{

		//check that if the article is in a reviewforum is it is then let the user know.
		int iReviewForumID = 0;

		if (m_pForm->IsArticleInReviewForum(iReviewForumID))
		{
			if (bCheckReviewForum)
			{
				CreateArticleIsInReviewForumPage(iReviewForumID);	
				return false;
			}
			else
			{
				
				if (!RemoveArticleFromReviewForum(iReviewForumID))
				{
					return false;
				}
			}
		}

		// TODO: there is duplicate checking of permission here which is unnecessary
		// the form object knows how to delete articles
		bSuccess = bSuccess && m_pForm->DeleteArticle(m_pViewer);
		bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 5, "Cancelled by user");
	// only UberEditors can hide or unhide entries, and only in the admin version
#if defined (_ADMIN_VERSION)
		if (m_IsUberEditor)
		{
			// also hide or unhide the entry if required
			if (m_MakeHidden)
			{
				bSuccess = bSuccess && m_pForm->MakeHidden(0, 0);
			}
			else
			{
				bSuccess = bSuccess && m_pForm->MakeUnhidden(0, 0);
			}
		}
#endif
		if (bSuccess)
		{
			// the Entry was successfully deleted, so give them a link to the
			// MorePages page which displays their deleted entries
			CTDVString msg;
			msg << "<USERACTION RESULT='1' TYPE='DELETEGUIDEENTRY'><USERID>";
			msg << m_pViewer->GetUserID() << "</USERID></USERACTION>";
			CreateSimplePage(m_pPage, "Deletion Successful", msg);
		}
		else
		{
			// something went wrong accessing the DB
			CreateSimplePage(m_pPage, "Deletion Failed", "<USERACTION TYPE='DELETEGUIDEENTRY' REASON='dberror' RESULT='0'/>");
		}
	}
	// false if something went wrong, but should still have produced an appropriate page
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::ProcessUndeleteRequest()
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Modified:	24/07/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Processes a undelete request and produces and appropriate page depending
				on if it succeeds or fails. Hence even if the undelete operation is
				unsuccessfull a page should still be produced.

*********************************************************************************/

bool CUserEditPageBuilder::ProcessUndeleteRequest()
{
	TDVASSERT(m_pViewer != NULL, "CUserEditPageBuilder::ProcessUndeleteRequest() called with NULL m_pViewer");
	TDVASSERT(m_pForm != NULL, "CUserEditPageBuilder::ProcessUndeleteRequest() called with NULL m_pForm");

	CTDVString	sTemp = "";
	bool bSuccess = true;

	// UndeleteArticle method checks for edit permission so no need to here
	bSuccess = m_pForm->UndeleteArticle(m_pViewer);
	sTemp << "Undeleted by user U" << m_pViewer->GetUserID();
	bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 5, sTemp);
	// only UberEditors can hide or unhide entries, and only in the admin version
#if defined (_ADMIN_VERSION)
	if (m_IsUberEditor)
	{
		// also hide or unhide the entry if required
		if (m_MakeHidden)
		{
			bSuccess = bSuccess && m_pForm->MakeHidden(0, 0);
		}
		else
		{
			bSuccess = bSuccess && m_pForm->MakeUnhidden(0, 0);
		}
	}
#endif
	// allocate the entry for requiring moderation
	// - on an admin site don't queue anything edited by editors or moderators
#if defined (_ADMIN_VERSION)
	if (!m_IsUberEditor)
	{
#endif
	sTemp = "";
	sTemp << "Undeleted by user U" << m_pViewer->GetUserID();
	bool bSiteModerated = !(m_InputContext.IsSiteUnmoderated(m_pForm->GetSiteID()));
	bool bUserModerated  = m_pViewer->GetIsPreModerated() || m_pViewer->GetIsPostModerated();
	bool bArticleModerated = m_pForm->IsArticleModerated();
	bool bArticleInModeration = m_pForm->IsArticleInModeration();
	bool bIsAutoSinBin = m_pViewer->GetIsAutoSinBin();
	if (bSiteModerated || bUserModerated || bArticleModerated || bArticleInModeration || bIsAutoSinBin)
	{
		bSuccess = bSuccess && CGuideEntry::QueueForModeration(m_InputContext,
			m_pForm->GetH2G2ID(), CStoredProcedure::MOD_TRIGGER_AUTO,
			sTemp, NULL);
	}
#if defined (_ADMIN_VERSION)
	}
#endif
	if (bSuccess)
	{
		// all went well so give them a link to the Guide Entries on MorePages
		CTDVString sMessage = "";
		
		sMessage << "<USERACTION TYPE='GUIDEENTRYRESTORED' RESULT='1'>"
				<< "<USERID>" << m_pViewer->GetUserID() << "</USERID>";
		int ih2g2ID = m_pForm->GetH2G2ID();
		CTDVString sSubject;
		m_pForm->GetSubject(&sSubject);
		CForum::MakeSubjectSafe(&sSubject);
		sMessage << "<H2G2ID>" << ih2g2ID << "</H2G2ID>"
			<< "<SUBJECT>" << sSubject << "</SUBJECT></USERACTION>";
		CreateSimplePage(m_pPage, "Guide Entry Restored", sMessage);
	}
	else
	{
		// there was a problem accessing the DB
		CreateSimplePage(m_pPage, "Undelete Failed", "<USERACTION TYPE='GUIDEENTRYRESTORED' RESULT='0' REASON='dberror'/>");
	}
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::ProcessUpdate()
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Modified:	24/07/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Processes a update or add entry request and produces and appropriate
				page depending on if it succeeds or fails. Hence even if the
				operation is unsuccessfull a page should still be produced. On a
				successfull update what is produced is a page with a redirect to
				the actual article or userpage that has been updated.

*********************************************************************************/

bool CUserEditPageBuilder::ProcessUpdate()
{
	TDVASSERT(m_pForm != NULL, "CUserEditPageBuilder::ProcessUpdate() called with NULL m_pForm");

	bool bSuccess = true;
	// if we have no article we can't update it now can we children?
	if (m_pForm == NULL)
	{
		bSuccess = false;
	}
	// must check that a GuideML entry does not have parse error before updating it
	if (bSuccess)
	{
		if (m_NewFormat == 1)
		{
			m_ParseErrorXML.Empty();
			m_ParseErrorXML = CXMLObject::ParseXMLForErrors(m_Body);
			// if there are errors then go back to the edit form with a preview
			// this will go through the parse process again, but what the hell
			if (m_ParseErrorXML.IsEmpty())
			{
				CTDVString sSubject = "<SUBJECT>";
				sSubject << m_Subject << "</SUBJECT>";
				m_ParseErrorXML = CXMLObject::ParseXMLForErrors(sSubject);
			}
			if (!m_ParseErrorXML.IsEmpty())
			{
				CreateFormInPage(true);
				// set this to false to prevent the update occurring
				bSuccess = false;
			}
		}
	}

	// we have an article which will have the latest data from the submission
	// so simply call the update method on it
	if (bSuccess)
	{
		// if we are adding a new entry then calling update entry on
		// this object (which has an ID of zero) will create the new entry
		bool bProfanityFound = false;
		bool bNonAllowedURLsFound = false;
		bool bEmailAddressFound = false;

		

		bSuccess = m_pForm->UpdateEntry(m_pViewer, bProfanityFound, bNonAllowedURLsFound, bEmailAddressFound, m_bUpdateDateCreated);
		if (bSuccess)
		{
			// might as well set the ID to the correct one for the new entry
			m_h2g2ID = m_pForm->GetH2G2ID();

			if (m_InputContext.ParamExists("LocationXML"))
			{
				m_pForm->SetEntryLocations(m_pViewer, m_h2g2ID);
			}
			TDVASSERT(m_h2g2ID > 0, "Non-positive h2g2ID after creating new entry in CUserEditPageBuilder::ProcessUpdate()");
		}
		else if (bProfanityFound)
		{
			return m_pPage->AddInside("H2G2", m_pForm);	
		}
		else if (bNonAllowedURLsFound)
		{
			return m_pPage->AddInside("H2G2", m_pForm);	
		}
		else if ( bEmailAddressFound )
		{
			return m_pPage->AddInside("H2G2", m_pForm);
		}

		//Report Error.
		if ( m_pForm->ErrorReported() )
		{
			m_pPage->AddInside("H2G2", m_pForm);
		}

		// if this is a new masthead then make sure the users records
		// are updated appropriately
		/* Removed - UserEdit should not be able to create a masthead in this way any more
		if (bSuccess && m_IsMasthead)
		{
			// set the masthead of the user and then update their details
			bSuccess = m_pViewer->SetMasthead(m_h2g2ID);
			bSuccess = bSuccess && m_pViewer->UpdateDetails();
		}
		*/
		CTDVString	sTemp = "";
		sTemp << "Modified by user U" << m_pViewer->GetUserID();
		// update the edit history
		bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 3, sTemp);
		// allocate the entry for requiring moderation
		// - on an admin site don't queue anything edited by editors or moderators
#if defined (_ADMIN_VERSION)
		if (!m_IsUberEditor)
		{
#endif
		sTemp = "";
		sTemp << "Created/Edited by user U" << m_pViewer->GetUserID();

		bool bSiteModerated = !(m_InputContext.IsSiteUnmoderated(m_pForm->GetSiteID()));
		bool bUserModerated  = m_pViewer->GetIsPreModerated() || m_pViewer->GetIsPostModerated();
		bool bArticleModerated = m_pForm->IsArticleModerated();
		bool bIsArticleInModeration = m_pForm->IsArticleInModeration();
		bool bAutoSinBin = m_pViewer->GetIsAutoSinBin();
		if (bSiteModerated || bUserModerated || bArticleModerated || bIsArticleInModeration || bAutoSinBin )
		{
			bSuccess = bSuccess && CGuideEntry::QueueForModeration(m_InputContext,
				m_pForm->GetH2G2ID(), CStoredProcedure::MOD_TRIGGER_AUTO, sTemp,
				NULL);
		}
#if defined (_ADMIN_VERSION)
		}
#endif
	}
	// only UberEditors can hide or unhide entries, and only in the admin version
#if defined (_ADMIN_VERSION)
	if (m_IsUberEditor)
	{
		// also hide or unhide the entry if required
		if (m_MakeHidden)
		{
			bSuccess = bSuccess && m_pForm->MakeHidden(0, 0);
		}
		else
		{
			bSuccess = bSuccess && m_pForm->MakeUnhidden(0, 0);
		}
	}
#endif
	// if successfull then create a page that redirects to the appropriate
	// article page or user page
	if (bSuccess)
	{
		CTDVString sRedirect;

		if (m_bGotAction)
		{
			m_sAction.Replace("&","&amp;");
			m_sAction.Replace("<","&lt;");
			m_sAction.Replace(">","&gt;");
			sRedirect << m_sAction;
		}
		else if (m_IsMasthead)
		{
			sRedirect << "U" << m_pViewer->GetUserID() << "?s_fromedit=1";
		}
		else
		{
			sRedirect << "A" << m_h2g2ID << "?s_fromedit=1";
		}
		// create a very simple page since it should redirect immediately anyhow
		bSuccess = m_pPage->Redirect(sRedirect);
		// Add some helper XML so we can parse the result safely
		CTDVString sExtra;
		if (m_IsMasthead)
		{
			sExtra << "<MASTHEAD USERID='" << m_pViewer->GetUserID() << "' H2G2ID='" << m_h2g2ID << "'/>";
		}
		else
		{
			sExtra << "<ARTICLE H2G2ID='" << m_h2g2ID << "'/>";
		}
		m_pPage->AddInside("H2G2",sExtra);
	}	
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::ProcessStatusChange(bool bConsider)
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Modified:	24/07/2000
	Inputs:		bConsider - true if article is being submitted for approval, false
					if it is being unsubmitted
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Processes a consider or unconsider request and produces and appropriate
				page depending on if it succeeds or fails. Hence even if the
				operation is unsuccessfull a page should still be produced.

*********************************************************************************/

bool CUserEditPageBuilder::ProcessStatusChange(bool bConsider)
{
	bool bSuccess = true;

	// not allowed to submit masthead for consideration
	if (m_IsMasthead)
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='STATUSCHANGE' REASON='homepage'>You cannot submit your homepage for consideration as an Approved Guide Entry.</USERACTION>";
		CreateSimplePage(m_pPage, "Invalid Request", msg);
		bSuccess = false;
	}
	// trying to submit an article for approval whilst it has not yet been added to
	// the database is also an error
	if (bSuccess && m_h2g2ID == 0)
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='STATUSCHANGE' REASON='notentry'>You cannot submit your article for consideration as an Approved Guide Entry until you have first added it as an ordinary Guide Entry.</USERACTION>";
		CreateSimplePage(m_pPage, "Invalid Request", msg);
		bSuccess = false;
	}
	// otherwise simply update the article in the DB
	if (bSuccess)
	{
		// change the status as required
		if (bConsider)
		{
			bSuccess = bSuccess && m_pForm->MakeToBeConsidered();
			bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 5, "Submitted for consideration");
		}
		else
		{
			// TODO: will this always be the correct status?
			bSuccess = bSuccess && m_pForm->MakePublicUserEntry();
			bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 5, "Removed from submission");
		}
		bool bProfanityFound = false;
		bool bURLFound = false;
		bool bEmailFound = false;
		bSuccess = bSuccess && m_pForm->UpdateEntry(m_pViewer, bProfanityFound, bURLFound, bEmailFound, m_bUpdateDateCreated );
	}
	// only UberEditors can hide or unhide entries, and only in the admin version
#if defined (_ADMIN_VERSION)
	if (m_IsUberEditor)
	{
		// also hide or unhide the entry if required
		if (m_MakeHidden)
		{
			bSuccess = bSuccess && m_pForm->MakeHidden(0, 0);
		}
		else
		{
			bSuccess = bSuccess && m_pForm->MakeUnhidden(0, 0);
		}
	}
#endif
	// if something wrong then try to give an error page
	if (!bSuccess)
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='STATUSCHANGE' REASON='general'>An error occurred whilst accessing the database and your request may not have been successfully processed.</USERACTION>";
		CreateSimplePage(m_pPage, "Error Processing Request",msg);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::ProcessResearchersChange()
																			 ,
	Author:		Kim Harries
	Created:	05/01/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Processes a change to the list of researchers - both adding new ones
				and deleting existing ones.

*********************************************************************************/

bool CUserEditPageBuilder::ProcessResearchersChange()
{
	bool bSuccess = true;
	// trying to add or remove researchers to an article which does not yet
	// exist in the database is an error
	if (bSuccess && m_h2g2ID == 0)
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='RESEARCHERCHANGE' REASON='noarticle'>You cannot add or remove researchers to an article until it has been created.</USERACTION>";
		CreateSimplePage(m_pPage, "Invalid Request", msg);
		bSuccess = false;
	}
	// make the changes to the existing form object then call its update
	// method to confirm the changes in the DB
	if (bSuccess)
	{
		// check if this is an add or remove request
		if (m_Command.CompareText("AddResearchers"))
		{
			CTDVString	sNote = "Added Researchers:";
			int			iNewResearcherID = 0;
			int			iTotal = m_InputContext.GetParamCount("NewResearcherID");
			int			i = 0;

			// do nothing if no IDs given
			if (iTotal > 0)
			{
				// read each ID parameter one at a time and then add
				// it to the forms internal list
				for (i = 0; i < iTotal; i++)
				{
					iNewResearcherID = m_InputContext.GetParamInt("NewResearcherID", i);
					if (iNewResearcherID > 0)
					{
						sNote << " U" << iNewResearcherID;
						bSuccess = bSuccess && m_pForm->AddResearcher(iNewResearcherID);
					}
				}
				// update the edit history
				bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 18, sNote);
			}
		}
		else if (m_Command.CompareText("SetResearchers"))
		{
			CTDVString	sNote = "Set Researchers:";
			CTDVString sList;
			bool bGotList = m_InputContext.GetParamString("ResearcherList", sList);
			// do nothing if no IDs given
			if (bGotList)
			{
				bSuccess = bSuccess && m_pForm->SetNewResearcherList(sList);

				sNote << sList;
				// update the edit history
				bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 18, sNote);
			}
		}
		else if (m_Command.CompareText("RemoveResearchers"))
		{
			CTDVString	sNote = "Removed Researchers:";
			int			iResearcherID = 0;
			int			iTotal = m_InputContext.GetParamCount("ResearcherID");
			int			i = 0;

			// do nothing if no IDs given
			if (iTotal > 0)
			{
				// read each ID parameter one at a time and then remove
				// it from the forms internal list
				for (i = 0; i < iTotal; i++)
				{
					iResearcherID = m_InputContext.GetParamInt("ResearcherID", i);
					if (iResearcherID > 0)
					{
						sNote << " U" << iResearcherID;
						bSuccess = bSuccess && m_pForm->RemoveResearcher(iResearcherID);
					}
				}
				// update the edit history
				bSuccess = bSuccess && m_pForm->AddEditHistory(m_pViewer, 18, sNote);
			}
		}
		else
		{
			TDVASSERT(false, "Invalid command type in CUserEditPageBuilder::ProcessResearchersChange()");
			bSuccess = false;
		}

		// call the update method to finalise the changes
		bool bProfanityFound = false;
		bool bEmailFound = false;
		bool bURLFound = false;
		bSuccess = bSuccess && m_pForm->UpdateEntry(m_pViewer, bProfanityFound, bURLFound, bEmailFound, m_bUpdateDateCreated );
	}
	// if something wrong then try to give an error page
	if (!bSuccess)
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='RESEARCHERCHANGE' REASON='general'>An error occurred whilst accessing the database and your request may not have been successfully processed.</USERACTION>";
		CreateSimplePage(m_pPage, "Error Processing Request", msg);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::ProcessRemoveSelfFromResearchers()
																			 ,
	Author:		Igor Loboda
	Created:	5/3/2002
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	removes currently logged user from the researchers list for the
				specified article

*********************************************************************************/
bool CUserEditPageBuilder::ProcessRemoveSelfFromResearchers()
{
	//check the article is specified
	if (m_h2g2ID < 1)
	{
		return false;
	}

	CStoredProcedure SP;
	if (m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SP.RemoveFromResearcherList(m_h2g2ID, m_pViewer->GetUserID());
	}
	else
	{
		return false;
	}

}

/*********************************************************************************

	bool CUserEditPageBuilder::CreateArticleEditForm()
																			 ,
	Author:		Kim Harries
	Created:	24/07/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Creates an object representing the current version of the article
				being edited, within a CArticleEditForm object. This of course may
				differ from the version stored in the database.

*********************************************************************************/

bool CUserEditPageBuilder::CreateArticleEditForm()
{
	TDVASSERT(m_pForm == NULL, "CUserEditPageBuilder::CreateArticleEditForm() called with non-NULL m_pForm");

	bool bSuccess = true;

	// we should never already have an object when calling this method
	if (m_pForm != NULL)
	{
		bSuccess = false;
	}
	// first allocate the memory for the new object
	if (bSuccess)
	{
		try
		{
			m_pForm = new CArticleEditForm(m_InputContext);
		}
		catch (...)
		{
			TDVASSERT(false, "Failed to allocate new CArticleEditForm object in CUserEditPageBuilder::CreateArticleEditForm::CreateArticleFromRequest()");
			bSuccess = false;
		}
	}
	// now create an edit form from the data in the request
	if (bSuccess)
	{
		// if this is a view request then it is the first visit to the edit page
		// and hence there is no data being submitted so create the edit form from
		// the article in the DB
		// TODO: is this the right set of alternatives?
		if (m_Command.CompareText("consider") ||
			m_Command.CompareText("unconsider") ||
			m_Command.CompareText("delete") ||
			m_Command.CompareText("deletereview") ||
			m_Command.CompareText("undelete") ||
			m_Command.CompareText("removeresearchers") ||
			m_Command.CompareText("addresearchers") ||
			m_Command.CompareText("MoveToSite") ||
			(m_Command.CompareText("view") && m_h2g2ID > 0))
		{
			bSuccess = m_pForm->CreateFromArticle(m_h2g2ID, m_pViewer);
		}
		else
		{
			// cannot get the status or editor from the request as this would be a security risk
			// but only need to get current status from the DB if we are editing an
			// existing entry. Otherwise use default of 3 for User Entry (Public)
			// - same applies to editor ID
			int iStatus = 3;
			int	iEditorID = m_pViewer->GetUserID();
			int iSiteID = m_SiteID;
			bool bPreProcessed = true;
			CTDVString locationsXML;
			if (IsPreProcessedParamPresent())
			{
				// If a preprocessed param was passed in, use it's state
				bPreProcessed = GetPreProcessedParamState();
			}

			//an existing entry
			if (m_h2g2ID != 0)
			{
				// if an existing entry get status and editor from DB by creating an article
				// TODO: there must be a better way than this
				CGuideEntry Article(m_InputContext);
				bSuccess = bSuccess && Article.Initialise(m_h2g2ID, m_InputContext.GetSiteID(), NULL, true, true);
				if (bSuccess)
				{
					iStatus   = Article.GetStatus();
					iEditorID = Article.GetEditorID();
					iSiteID   = Article.GetSiteID();
					locationsXML = Article.GetLocationsXML();

					if (!IsPreProcessedParamPresent())
					{
						// if no preprocessed param, set the flag to the article's state
						bPreProcessed = Article.GetIsPreProcessed();
					}
				}
			}
			
			// If the user is able to, let them change the status
			if (m_pViewer->GetIsEditor() || m_pViewer->GetIsSuperuser())
			{
				if (m_iEditor > 0)
				{
					iEditorID = m_iEditor;
				}
				if (m_iStatus > 0)
				{
					iStatus = m_iStatus;
				}
			}
			
			// set appropriate values depending on which functions should be present
			bool bPreview = true;
			bool bAddEntry = (m_h2g2ID == 0);
			bool bUpdate = !bAddEntry;
			bool bReformat = true;
			bool bDelete = (m_h2g2ID != 0 && iStatus != 7 && !m_IsMasthead);
			bool bConsider = false;
			bool bUnconsider = (iStatus > 3 && iStatus < 14 && iStatus != 7 && iStatus != 9 && iStatus != 10);
			bool bHide = false;
			bool bChangeSubmittable = false;
			bool bCanMoveToSite = !bAddEntry && m_pViewer->GetIsSuperuser();

			bool bArchive = false;
			bool bChangeArchive = false;
			if (m_InputContext.ParamExists("changearchive"))
			{
				bChangeArchive = true;
				bArchive = (m_InputContext.GetParamInt("archive") == 1);
			}
			
			//if submittable hasn't been set then use a default
			if (!m_CanMakeSubmittable)
			{
				m_Submittable = bChangeSubmittable = (iStatus == 3 && !m_IsMasthead);
			}
			else
			{
				bChangeSubmittable = !m_IsMasthead;
			}

			bool bRemoveResearchers = !bAddEntry && !m_IsMasthead;
			bool bAddResearchers = !bAddEntry && !m_IsMasthead;
			// create an ArticleEditForm object without accessing the DB
			bSuccess = bSuccess && m_pForm->CreateFromData(m_h2g2ID, m_OldFormat, iStatus, 
				iEditorID, m_IsMasthead, m_Subject, m_Body, m_MakeHidden, iSiteID, 
				m_Submittable, bArchive, bChangeArchive, bPreview, bAddEntry, bUpdate, bReformat, bDelete, 
				bConsider, bUnconsider, bHide, bRemoveResearchers, bAddResearchers,
				bChangeSubmittable, bCanMoveToSite, bPreProcessed, &m_vecPollTypes, locationsXML);

		}
		bSuccess = bSuccess && m_pForm->SetAction(m_sAction);
	}
	// should not fail in normal course of events
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::CreateFormInPage(bool bDoPreview)

	Author:		Kim Harries
	Created:	10/04/2000
	Modified:	24/07/2000
	Inputs:		bDoPreview - true if we want a preview of the current edit version
					of the article, false if not
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Creates the XML for the actual editing form and places it on the
				page. There is nothing likely to fail here so if something does go
				wrong it is left for the Build() method to produce its default error
				page rather than trying to do one here.

*********************************************************************************/

bool CUserEditPageBuilder::CreateFormInPage(bool bDoPreview)
{
	CTDVString sFormXML = "";
	bool bSuccess = true;

	if (m_pPage->IsEmpty())
	{
		InitialisePage();
	}

	// if this is the first visit to the page then either intialise the form data
	// to default values if this is a new entry, or get the form data from the
	// article from the database if this is an existing entry
	// View, Consider, and Unconsider all require the form data to be got from the database
	if (bSuccess)
	{
		// if we have a DB article then fill in any data not provided in the request from it
		if (m_pForm != NULL)
		{
			// don't fail if we can't get the data, just log an error
			bool bTest = true;
		
			// if data was missing from the request then get it from the article
			// in the database
			if (!m_InputContext.ParamExists("subject"))
			{
				bTest = m_pForm->GetSubject(&m_Subject) && bTest;
			}
			if (!m_InputContext.ParamExists("body"))
			{
				bTest = m_pForm->GetContent(&m_Body) && bTest;
			}
			if (!m_InputContext.ParamExists("format"))
			{
				m_OldFormat = m_pForm->GetFormat();
			}
			if (!m_InputContext.ParamExists("newformat"))
			{
				// if no new format provided it is the same as the old one
				m_NewFormat = m_OldFormat;
			}
			TDVASSERT(bTest, "Error getting entry data in CUserEditPageBuilder::CreateEditForm(...)");
		}
		// must check for parsing errors *before* escaping the XML for the form
		if (m_NewFormat == 1)
		{
			// first run it through our parser, then if this finds no errors
			// run it through the MS XML parser - this is all done inside ParseXMLForErrors now
			m_ParseErrorXML.Empty();
			m_ParseErrorXML = CXMLObject::ParseXMLForErrors(m_Body);
			if (!m_ParseErrorXML.IsEmpty())
			{
				// wrap the error xml up in article tags and give it a subject
				// TODO: why doesn't it already have GUIDE and BODY tags?
				m_ParseErrorXML = "<ARTICLE><SUBJECT>Error in GuideML</SUBJECT><GUIDE><BODY><BR/>" + m_ParseErrorXML + "</BODY></GUIDE></ARTICLE>";
			}
			else
			{
				CTDVString sSubject = "<SUBJECT>";
				sSubject << m_Subject << "</SUBJECT>";
				m_ParseErrorXML = CXMLObject::ParseXMLForErrors(sSubject);
				if (!m_ParseErrorXML.IsEmpty())
				{
					m_ParseErrorXML = "<ARTICLE><SUBJECT>Error in GuideML for subject</SUBJECT><GUIDE><BODY><BR/>" + m_ParseErrorXML + "</BODY></GUIDE></ARTICLE>";
				}
			}
		}
		// must escape all XML sequences in the subject and body before it goes in the form
		// TODO: do we need to do this in all cases like this?
//		CXMLObject::EscapeAllXML(&m_Subject);
//		CXMLObject::EscapeAllXML(&m_Body);
		bSuccess = bSuccess && m_pForm->SetSubject(m_Subject);
		bSuccess = bSuccess && m_pForm->SetContent(m_Body);
	}
	// now create the XML for the edit form
	if (bSuccess)
	{
		bSuccess = m_pPage->AddInside("H2G2", m_pForm);
	}
	// also add the XML for a preview of the article if need be
	if (bSuccess && bDoPreview)
	{
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ARTICLE-PREVIEW></ARTICLE-PREVIEW>");
		// check if there were any parse errors and display them if there are
		if (m_ParseErrorXML.IsEmpty())
		{
			// there were no parse errors
			// create a temporary Guide Entry object from the current data and then
			// insert it within the ARTICLE-PREVIEW tags
			CGuideEntry TempEntry(m_InputContext);

			CExtraInfo Extra;
			Extra.Create(CGuideEntry::TYPEARTICLE);
			
			bool bPreProcessed = true;
			if (IsPreProcessedParamPresent())
			{
				// If a preprocessed param was passed in, use it's state
				bPreProcessed = GetPreProcessedParamState();
			}
			else
			{
				bPreProcessed = m_pForm->GetPreProcessed();
			}

			//ExtraInfo Todo
			bSuccess = bSuccess && TempEntry.CreateFromData(m_pViewer, m_h2g2ID, m_Subject, m_Body, Extra, m_NewFormat, m_SiteID, m_Submittable,false,false,false,bPreProcessed);
			bSuccess = bSuccess && m_pPage->AddInside("ARTICLE-PREVIEW", &TempEntry);
		}
		else
		{
			// there were parse errors, so display these instead
			bSuccess = bSuccess && m_pPage->AddInside("ARTICLE-PREVIEW", m_ParseErrorXML);
		}
	}
	// now add a tag for the appropriate type of help text required
	if (bSuccess)
	{
		CTDVString sHelp;
		if (m_NewFormat == 1)
		{
			sHelp = "<HELP TOPIC='GuideML'/>";
		}
		else if (m_NewFormat == 2)
		{
			sHelp = "<HELP TOPIC='PlainText'/>";
		}
		else
		{
			// invalid format so set no help tag
			TDVASSERT(false, "Invalid format for guide entry in CUserEditPageBuilder::CreateEditForm(...)");
			sHelp = "<HELP/>";
		}
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", sHelp);
	}
	if (bSuccess)
	{
		bSuccess = m_pPage->SetPageType("USEREDIT");
	}
	// if an error occurred it is pretty fundamental so simply delete any page
	// that has been created and allow the calling method to show an error
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::ReformatArticle()
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Modified:	24/07/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Performs a transfomrations required when reformatting an article
				in a different style.

*********************************************************************************/

bool CUserEditPageBuilder::ReformatArticle()
{
	TDVASSERT(m_OldFormat > 0 && m_OldFormat < 3, "Invalid Old Format in CUserEditPageBuilder::ReformatArticle()");
	TDVASSERT(m_NewFormat > 0 && m_NewFormat < 3, "Invalid New Format in CUserEditPageBuilder::ReformatArticle()");

	bool bSuccess = true;
	// if new format is invalid then fail
	if (m_NewFormat < 1 || m_NewFormat > 2)
	{
		return false;
	}
	// if format the same no processing needed
	if (m_OldFormat == m_NewFormat)
	{
		return true;
	}

	// do any special translations here which take place *in addition* to the
	// transformations done by the various translation methods
	if (m_OldFormat == 2 && m_NewFormat == 1)
	{
		// Plain Text to GuideML
		// check if there is a GUIDE tag already
		// TODO: a better check might be necessary
		if (m_Body.Find("<GUIDE>") < 0)
		{
			m_Body = "<GUIDE>\n<BODY>\n" + m_Body + "\n</BODY>\n</GUIDE>";
		}
		// if we want to change the fish ><> sequence to be valid
		// in GuideML this is the place to do it, as a special case
		m_Body.Replace("><>", "&gt;&lt;&gt;");
	}
	else if (m_OldFormat == 1 && m_NewFormat == 2)
	{
		// GuideML to Plain Text
		// TODO: could try to remove the GUIDE and BODY tags?
		// again a special case handler for the fish, so that when converting
		// back from GuideML it will come back as the ><> sequence
		m_Body.Replace("&gt;&lt;&gt;", "><>");
	}
	// only change the data that needs to be changed
	bSuccess = bSuccess && m_pForm->SetContent(m_Body);
	bSuccess = bSuccess && m_pForm->SetFormat(m_NewFormat);
	return bSuccess;
}

/*********************************************************************************

	bool CUserEditPageBuilder::InitialisePage()
																			 ,
	Author:		Kim Harries
	Created:	10/04/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successfull, false if not
	Purpose:	Simply initialises the CWholePage object and puts the viewing user
				XML and UI XML in to it.

*********************************************************************************/

bool CUserEditPageBuilder::InitialisePage()
{
	bool bSuccess = true;
	bSuccess = InitPage(m_pPage, "USEREDIT",true);

	CTDVString sSiteXML;
	bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 1);
	bSuccess = bSuccess && m_pPage->AddInside("H2G2", sSiteXML);

	return bSuccess;
}


/*********************************************************************************

	CWholePage* CUserEditPageBuilder::CreateIsInReviewForumPage(int iReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	10/25/01
	Inputs:		iReviewforumID - Id of the the reviewforum the article is in
	Outputs:	-
	Returns:	A valid wholepage if successful, null otherwise, responsibility for the 
				object lies with the caller
	Purpose:	Produces a wholepage that provides the USEREDIT XML that tells the user
				that they are trying to delete an article that is in a review forum and do 
				they want to continue
*********************************************************************************/

bool CUserEditPageBuilder::CreateArticleIsInReviewForumPage(int iReviewForumID)
{
	TDVASSERT(iReviewForumID > 0,"Bad ReviewForum in CUserEditPageBuilder::CreateIsInReviewForum");
	TDVASSERT(m_h2g2ID > 0, "Bad Article in CUserEditPageBuilder::CreateIsInReviewForum");

	CReviewForum mReviewForum(m_InputContext);

	if (!InitPage(m_pPage, "USEREDIT", true))
	{
		return false;
	}

	if (!mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='ARTICLEINREVIEW' REASON='initialise'>There was a problem initialising the review forum.</USERACTION>";
		return CreateSimplePage(m_pPage, "Entry is in a review forum",msg);
	}

	CTDVString sReviewForumXML;

	if (!mReviewForum.GetAsXMLString(sReviewForumXML))
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='ARTICLEINREVIEW' REASON='initialise'>There was a problem initialising the review forum.</USERACTION>";
		return CreateSimplePage(m_pPage, "Entry is in a review forum",msg);
	}

	CTDVString sXML = "";

	sXML << "<INREVIEW>" 
		 << "<ARTICLE H2G2ID='" << m_h2g2ID << "'/>" 
		 << "<MASTHEAD>" << m_IsMasthead << "</MASTHEAD>"
		 << "<HIDDEN>" << m_MakeHidden << "</HIDDEN>"
		 << "<SITEID>" << m_SiteID << "</SITEID>"
		 << sReviewForumXML << "</INREVIEW>";

	if (!m_pPage->AddInside("H2G2",sXML))
	{
		CTDVString msg;
		msg << "<USERACTION RESULT='0' TYPE='ARTICLEINREVIEW' REASON='initialise'>There was a problem initialising the review forum.</USERACTION>";
		return CreateSimplePage(m_pPage, "Entry is in a review forum",msg);
	}

	return true;

}

/*********************************************************************************

	bool CUserEditPageBuilder::RemoveArticleFromReviewForum(int iReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	10/26/01
	Inputs:		iReviewForumID - the review forum that the article is being removed from
	Outputs:	-
	Returns:	true if article removed from the review forum, false if not as well as setting
				the wholepage member to some sensible error report
	Purpose:	Removes the current article from the given review forum
*********************************************************************************/


bool CUserEditPageBuilder::RemoveArticleFromReviewForum(int iReviewForumID)
{
	if (m_pPage->IsEmpty())
	{
		if (!InitPage(m_pPage, "USEREDIT",true))
		{
			return false;
		}
	}

	CReviewSubmissionForum mSubmitForum(m_InputContext);

	int iThreadID = 0;
	int iForumID = 0;
	bool bSuccess = false;

	if (!mSubmitForum.RemoveThreadFromForum(*m_pViewer,iReviewForumID,m_h2g2ID,&iThreadID,&iForumID,&bSuccess))
	{
		//get the error message from object and wrap it ut before handing it over.
		CTDVString sXML = "<NODELEREVIEW></NODELREVIEW>";
		m_pPage->AddInside("H2G2",sXML);
		//pass through the error message
		m_pPage->AddInside("NODELREVIEW",&mSubmitForum);
		//just set the page type just in case
		m_pPage->SetPageType("USEREDIT");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CUserEditPageBuilder::RedirectToEdit()

	Author:		Igor Loboda
	Created:	2/4/02
	Inputs:		-
	Outputs:	-
	Returns:	true if redirected successfuly.
	Purpose:	redirects to article edit page, substituting URL with the proper one
				and avoiding repeat of lust operation on page refresh.
*********************************************************************************/
bool CUserEditPageBuilder::RedirectToEdit()
{
	CTDVString sRedirect;
	sRedirect << "UserEdit" << m_h2g2ID;
	return m_pPage->Redirect(sRedirect);
}

/*********************************************************************************

	bool CUserEditPageBuilder::HandleRedirect(CWholePage* pPageXML)

	Author:		Mark Neves
	Created:	23/09/2003
	Inputs:		pPageXML
	Outputs:	pPageXML is updated with redirect XML if necessary
	Returns:	-
	Purpose:	Tests to see if this article should be redirected to its high-level owner
				e.g. Club, review forum, etc.

*********************************************************************************/

bool CUserEditPageBuilder::HandleRedirect(CWholePage* pPageXML,CGuideEntry& GuideEntry)
{
	if (pPageXML == NULL)
	{
		return false;
	}

	bool bRedirected = false;

	CTDVString sRedirectTo;
	if (GuideEntry.IsTypeOfClub())
	{
		CClub Club(m_InputContext);
		if (Club.InitialiseViaH2G2ID(GuideEntry.GetH2G2ID()))
		{
			sRedirectTo << "Club" << Club.GetClubID();
			sRedirectTo << "?action=edit";
		}
	}

	if (!sRedirectTo.IsEmpty())
	{
		pPageXML->SetPageType("REDIRECT");
		CTDVString sRedirect = "<REDIRECT-TO>";
		sRedirect << sRedirectTo;
		sRedirect << "</REDIRECT-TO>";
		pPageXML->AddInside("H2G2",sRedirect);
		bRedirected = true;
	}

	return bRedirected;
}
