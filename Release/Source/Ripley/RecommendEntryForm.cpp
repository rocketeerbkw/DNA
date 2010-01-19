// RecommendEntryForm.cpp: implementation of the CRecommendEntryForm class.
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
#include "RecommendEntryForm.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CRecommendEntryForm::CRecommendEntryForm(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_bIsValidRecommendation(false)
{
	// no further construction required
}

CRecommendEntryForm::~CRecommendEntryForm()
{
	// no further destruction required
}

/*********************************************************************************

	bool CRecommendEntryForm::CreateBlankForm(CUser* pUser)

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a blank entry recommendation form.

*********************************************************************************/

bool CRecommendEntryForm::CreateBlankForm(CUser* pUser)
{
	TDVASSERT(m_pTree == NULL, "CRecommendEntryForm::CreateBlankForm() called with non-NULL m_pTree");
	TDVASSERT(pUser != NULL, "CRecommendEntryForm::CreateBlankForm() called with NULL pUser");

	// fail is no user object provided
	if (pUser == NULL)
	{
		return false;
	}
	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}

	// variables we will need
	CTDVString	sFormXML = "<RECOMMEND-ENTRY-FORM>";

	sFormXML << "<H2G2ID>0</H2G2ID>";
	sFormXML << "<SUBJECT></SUBJECT>";
	sFormXML << "<COMMENTS></COMMENTS>";
	sFormXML << "<FUNCTIONS><FETCH-ENTRY/></FUNCTIONS>";
	sFormXML << "</RECOMMEND-ENTRY-FORM>";

	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CRecommendEntryForm::CreateFromh2g2ID(CUser* pUser, int iEntryID, const TDVCHAR* pcComments)

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a recommendation form for the entry with
				this entry ID.

*********************************************************************************/

bool CRecommendEntryForm::CreateFromh2g2ID(CUser* pUser, int ih2g2ID, const TDVCHAR* pcComments)
{
	TDVASSERT(m_pTree == NULL, "CRecommendEntryForm::CreateBlankForm(...) called with non-NULL m_pTree");
	TDVASSERT(pUser != NULL, "CRecommendEntryForm::CreateBlankForm(...) called with NULL pUser");
	TDVASSERT(ih2g2ID > 0, "CRecommendEntryForm::CreateBlankForm(...) called with non-positive ih2g2ID");

	// if daft ih2g2ID value given or a NULL user object then fail
	if (ih2g2ID <= 0 || pUser == NULL)
	{
		return false;
	}
	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}

	// variables we will need
	CStoredProcedure	SP;
	CTDVString			sFormXML;
	CTDVString			sComments = pcComments;
	CTDVString			sSubject;
	CTDVString			sEditorName;
	int					iUserID = pUser->GetUserID();
	int					iEntryID = 0;
	int					iEditorID = 0;
	int					iStatus = 0;
	int					iSubCopyID = 0;
	int					iRecommendedByScoutID = 0;
	CTDVString			sRecommendedByUserName;
	bool				bIsSubCopy = false;
	bool				bHasSubCopy = false;
	bool				bSuccess = true;
	bool				bSuitable = true;
	bool				bInvalidID = false;

	// start the form element
	sFormXML = "<RECOMMEND-ENTRY-FORM>";
	// check that we got the SP okay
	bSuccess = bSuccess && (m_InputContext.InitialiseStoredProcedureObject(&SP));
	// now check that the h2g2ID is valid and if so get the entry ID from it
	if (CGuideEntry::IsValidChecksum(ih2g2ID))
	{
		iEntryID = ih2g2ID / 10;
	}
	else
	{
		// if ID is invalid then set the flag and put an error message in the XML
		// set bSuccess false for time being so that other stuff is not attempted
		TDVASSERT(false, "Invalid h2g2ID in CRecommendEntryForm::CreateFromh2g2ID(...)");
		bInvalidID = true;
		bSuccess = false;
		m_bIsValidRecommendation = false;
		sFormXML << "<ERROR TYPE='INVALID-H2G2ID'>" << ih2g2ID << "</ERROR>";
	}
	// get the entry details to go in the form
	bSuccess = bSuccess && SP.FetchArticleSummary(iEntryID, &ih2g2ID, &sSubject, &sEditorName, &iEditorID, &iStatus, &bIsSubCopy, NULL, &bHasSubCopy, &iSubCopyID, NULL, &iRecommendedByScoutID, &sRecommendedByUserName, NULL);
	if (bSuccess)
	{
		// check that this entry is appropriate for recommendation and if not then
		// assume it is valid then set to invalid if any problems found
		m_bIsValidRecommendation = true;
		// give the reason why
		// Entry not suitable reasons are:
		//	- entry is already in edited guide
		//	- entry is a key article
		//	- entry is already recommended
		//	- entry is deleted
		//	- entry was written by the scout trying to recommend it
		// only status value 3 (user entry, public) is actually suitable for recommendations
		if (iRecommendedByScoutID > 0)
		{
			sFormXML << "<ERROR TYPE='ALREADY-RECOMMENDED'>";
			sFormXML << "Entry has already been recommended by <LINK BIO='U" << iRecommendedByScoutID << "'>" << sRecommendedByUserName << "</LINK>";
			sFormXML << "</ERROR>";
			m_bIsValidRecommendation = false;
		}
		else if (iStatus != 3)
		{
			bSuitable = false;
			m_bIsValidRecommendation = false;
			switch (iStatus)
			{
				case 0:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>No Status</ERROR>"; break;
				case 1:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Edited</ERROR>"; break;
				case 2:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Private Entry</ERROR>"; break;
				case 4:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				case 5:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				case 6:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				case 7:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Deleted</ERROR>"; break;
				case 8:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				case 9:		sFormXML << "<ERROR TYPE='WRONG-STATUS'>Key Article</ERROR>"; break;
				case 10:	sFormXML << "<ERROR TYPE='WRONG-STATUS'>Key Article</ERROR>"; break;
				case 11:	sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				case 12:	sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				case 13:	sFormXML << "<ERROR TYPE='WRONG-STATUS'>Already Recommended</ERROR>"; break;
				default:	sFormXML << "<ERROR TYPE='WRONG-STATUS'>Invalid Status</ERROR>"; break;
			}
		}
		else if (bIsSubCopy)
		{
			bSuitable = false;
			m_bIsValidRecommendation = false;
			sFormXML << "<ERROR TYPE='WRONG-STATUS'>Sub-editors draft copy for Edited Entry</ERROR>";
		}
/*		else if (bHasSubCopy)
		{
			// currently dissallow recommendation of an entry that has previously been an
			// accepted recommendation
			// TODO: could allow re-recommendation with a warning when an entry has gone
			// all through the submission system?
			bSuitable = false;
			m_bIsValidRecommendation = false;
			sFormXML << "<ERROR TYPE='ALREADY-RECOMMENDED'>Already recommended</ERROR>";
		}
*/
		// check that scout is not the author, but allow editors to recommend
		// their own entries should they ever wish to
		if (iUserID == iEditorID && !pUser->GetIsEditor())
		{
			bSuitable = false;
			m_bIsValidRecommendation = false;
			sFormXML << "<ERROR TYPE='OWN-ENTRY'>Recommender is author</ERROR>";
		}

		//if the user is not an editor then check that the entry is recommendable
		CGuideEntry mGuideEntry(m_InputContext);
		if (!pUser->GetIsEditor() && !mGuideEntry.RecommendEntry(ih2g2ID))
		{
			bSuitable = false;
			m_bIsValidRecommendation = false;
			sFormXML << "<ERROR TYPE='NOT-IN-REVIEW'>Not in appropriate review forum</ERROR>";
		}
	}

	// if all okay then put the data into the form
	if (bSuccess)
	{
		sFormXML << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";
		// only add this data if the entry was suitable for recommending, since it might be
		// from e.g. a deleted entry and hence should not be accessible
		if (bSuitable)
		{
			sFormXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
			sFormXML << "<EDITOR>";
			sFormXML << "<USER><USERID>" << iEditorID << "</USERID>";
			sFormXML << "<USERNAME>" << sEditorName << "</USERNAME></USER>";
			sFormXML << "</EDITOR>";
		}
		sFormXML << "<COMMENTS>" << sComments << "</COMMENTS>";
	}
	// now put in XML saying which functions the form should provide
	sFormXML << "<FUNCTIONS>";
	sFormXML << "<FETCH-ENTRY/>";
	if (m_bIsValidRecommendation)
	{
		sFormXML << "<RECOMMEND-ENTRY/>";
	}
	sFormXML << "</FUNCTIONS>";
	sFormXML << "</RECOMMEND-ENTRY-FORM>";
	// if only reason we failed was because of invalid ID then try to succeed
	// with just the error message included, that way the stylesheet can decide
	// how best to process it
	if (bInvalidID)
	{
		bSuccess = true;
	}
	// now parse this XML into our tree
	bSuccess = bSuccess && CXMLObject::CreateFromXMLText(sFormXML);
	// log an error if object not created okay
	TDVASSERT(bSuccess, "CRecommendEntryForm::CreateFromEntryID(...) failed");
	// also log if an attempt to recommend an inappropriate entry
	TDVASSERT(bSuitable, "Attempt to recommend unsuitable entry in CRecommendEntryForm::CreateFromEntryID(...)");
	// return the success value
	return bSuccess;
}

/*********************************************************************************

	bool CRecommendEntryForm::SubmitRecommendation(CUser* pViewer, int ih2g2ID, const TDVCHAR* pcComments)

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		pViewer - the user (scout) doing the recommendation
				ih2g2ID - the ID of the entry they want to recommend
				pcComments - any comments they have made as to why they are
					recommending it
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Submits the recommendatoin if it is a valid one. Creates appropriate
				XML to report whether or not the submission was successful.

*********************************************************************************/

bool CRecommendEntryForm::SubmitRecommendation(CUser* pViewer, int ih2g2ID, const TDVCHAR* pcComments)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CRecommendEntryForm::SubmitRecommendation(...)");
	
	bool		bAlreadyRecommended = false;	// variables to store response from submit request
	bool		bWrongStatus = false;
	bool		bOkay = false;
	int			iUserID = 0;
	CTDVString	sUsername = "";
	bool		bSuccess = true;

	CStoredProcedure	SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// if couldn't create SP then log error and fail
		TDVASSERT(false, "Failed to create SP in CRecommendEntryForm::SubmitRecommendation(...)");
		bSuccess = false;
	}

	// try creating the form for this data
	bSuccess = bSuccess && CreateFromh2g2ID(pViewer, ih2g2ID, pcComments);
	// then check that this was successful and the recommendation was a valid
	// one before proceeding
	if (bSuccess && m_bIsValidRecommendation)
	{
		// call the SP method to send the scouts submission, then fetch any fields returned
		bSuccess = bSuccess && SP.SubmitScoutRecommendation(pViewer->GetUserID(), ih2g2ID / 10, pcComments);
		if (bSuccess)
		{
			bAlreadyRecommended = SP.GetBoolField("AlreadyRecommended");
			bWrongStatus = SP.GetBoolField("WrongStatus");
			bOkay = SP.GetBoolField("Success");
			iUserID = SP.GetIntField("UserID");
			SP.GetField("Username", sUsername);
		}

	}
	// check how things went and give a report
	if (bSuccess)
	{
		// recommendation found invalid even before calling the SP
		if (!m_bIsValidRecommendation)
		{
			// add some extra error info inside the existing XML
			bSuccess = bSuccess && AddInside("RECOMMEND-ENTRY-FORM", "<ERROR TYPE='INVALID-RECOMMENDATION'>Invalid Recommendation</ERROR>");
		}
		// status of entry was wrong
		else if (bWrongStatus)
		{
			// add some extra error info inside the existing XML
			bSuccess = bSuccess && AddInside("RECOMMEND-ENTRY-FORM", "<ERROR TYPE='WRONG-STATUS'>Entry is not a public user entry</ERROR>");
		}
		// entry already recommended
		else if (bAlreadyRecommended)
		{
			// add an error message saying who recommnded it
			CTDVString sMessage = "<ERROR TYPE='ALREADY-RECOMMENDED'>";
			sMessage << "Entry has already been recommended by <LINK BIO='U" << iUserID << "'>" << sUsername << "</LINK>";
			sMessage << "</ERROR>";
			bSuccess = bSuccess && AddInside("RECOMMEND-ENTRY-FORM", sMessage);
		}
		// something unspecified went wrong
		else if (!bOkay)
		{
			bSuccess = bSuccess && AddInside("RECOMMEND-ENTRY-FORM", "<ERROR TYPE='UNKNOWN'>An unspecified error occurred whilst processing the request.</ERROR>");
		}
		// otherwise all okay!
		else
		{
			
			//also set the guidentry to unsubmittable - upto user to manually change it back
			SP.BeginUpdateArticle(ih2g2ID);
			SP.ArticleUpdateSubmittable(false);
			SP.DoUpdateArticle();
			// if submission successful then want to return a blank form so
			// that they can submit more if they wish, so destroy current contents
			// and create some more
			Destroy();
			bSuccess = bSuccess && CreateBlankForm(pViewer);
			// also want to put some XML in to indicate that recommendation was successful though
			// stylesheet can then put whatever message is appropriate in
			CTDVString	sMessage = "<SUBMITTED H2G2ID='";
			sMessage << ih2g2ID << "'/>";
			bSuccess = bSuccess && AddInside("RECOMMEND-ENTRY-FORM", sMessage);

		}
	}
	// return success value
	return bSuccess;
}
