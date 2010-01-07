// SubmitSubbedEntryForm.cpp: implementation of the CSubmitSubbedEntryForm class.
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
#include "SubmitSubbedEntryForm.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSubmitSubbedEntryForm::CSubmitSubbedEntryForm(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_bIsValidEntry(false)
{
	// no further construction required
}

CSubmitSubbedEntryForm::~CSubmitSubbedEntryForm()
{
	// no further destruction required
}

/*********************************************************************************

	bool CSubmitSubbedEntryForm::CreateBlankForm(CUser* pUser)

	Author:		Kim Harries
	Created:	15/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a blank form.

*********************************************************************************/

bool CSubmitSubbedEntryForm::CreateBlankForm(CUser* pUser)
{
	TDVASSERT(m_pTree == NULL, "CSubmitSubbedEntryForm::CreateBlankForm() called with non-NULL m_pTree");
	TDVASSERT(pUser != NULL, "CSubmitSubbedEntryForm::CreateBlankForm() called with NULL pUser");

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
	CTDVString	sFormXML = "<SUBBED-ENTRY-FORM>";

	sFormXML << "<H2G2ID>0</H2G2ID>";
	sFormXML << "<SUBJECT></SUBJECT>";
	sFormXML << "<COMMENTS></COMMENTS>";
	sFormXML << "<FUNCTIONS><FETCH-ENTRY/></FUNCTIONS>";
	sFormXML << "</SUBBED-ENTRY-FORM>";

	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CSubmitSubbedEntryForm::CreateFromh2g2ID(CUser* pUser, int iEntryID)

	Author:		Kim Harries
	Created:	15/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a subbed entry submission form for the entry with
				this entry ID.

*********************************************************************************/

bool CSubmitSubbedEntryForm::CreateFromh2g2ID(CUser* pUser, int ih2g2ID)
{
	TDVASSERT(m_pTree == NULL, "CSubmitSubbedEntryForm::CreateBlankForm(...) called with non-NULL m_pTree");
	TDVASSERT(pUser != NULL, "CSubmitSubbedEntryForm::CreateBlankForm(...) called with NULL pUser");
	TDVASSERT(ih2g2ID > 0, "CSubmitSubbedEntryForm::CreateBlankForm(...) called with non-positive ih2g2ID");

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
	CTDVString			sComments;
	CTDVString			sSubject;
	CTDVString			sEditorName;
	int					iUserID = pUser->GetUserID();
	int					iEntryID = 0;
	int					iEditorID = 0;
	int					iStatus = 0;
	bool				bIsSubCopy = false;
	bool				bHasSubCopy = false;
	bool				bSuccess = true;
	bool				bInvalidID = false;

	bSuccess = bSuccess && m_InputContext.InitialiseStoredProcedureObject(&SP);
	// start the form element
	sFormXML = "<SUBBED-ENTRY-FORM>";
	// now check that the h2g2ID is valid and if so get the entry ID from it
	if (CGuideEntry::IsValidChecksum(ih2g2ID))
	{
		iEntryID = ih2g2ID / 10;
	}
	else
	{
		// if ID is invalid then set the flag and put an error message in the XML
		// set bSuccess false for time being so that other stuff is not attempted
		TDVASSERT(false, "Invalid h2g2ID in CSubmitSubbedEntryForm::CreateFromh2g2ID(...)");
		bInvalidID = true;
		bSuccess = false;
		m_bIsValidEntry = false;
		sFormXML << "<ERROR TYPE='INVALID-H2G2ID'>" << ih2g2ID << "</ERROR>";
	}
	// get the entry details to go in the form
	bSuccess = bSuccess && SP.FetchArticleSummary(iEntryID, &ih2g2ID, &sSubject, &sEditorName, &iEditorID, &iStatus, &bIsSubCopy, NULL, &bHasSubCopy, NULL, NULL, NULL, NULL, &sComments);
	if (bSuccess)
	{
		// check that this entry is a subs copy of a recommended entry
		m_bIsValidEntry = true;
		if (!bIsSubCopy)
		{
			m_bIsValidEntry = false;
			sFormXML << "<ERROR TYPE='WRONG-STATUS'>Not Sub-editors draft copy for Edited Entry</ERROR>";
		}
	}

	// if all okay then put the data into the form
	if (bSuccess)
	{
		sFormXML << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";
		EscapeAllXML(&sSubject);
		sFormXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		sFormXML << "<EDITOR>";
		sFormXML << "<USER><USERID>" << iEditorID << "</USERID>";
		sFormXML << "<USERNAME>" << sEditorName << "</USERNAME></USER>";
		sFormXML << "</EDITOR>";
		EscapeAllXML(&sComments);
		sFormXML << "<COMMENTS>" << sComments << "</COMMENTS>";
	}
	// now put in XML saying which functions the form should provide
	sFormXML << "<FUNCTIONS>";
	sFormXML << "<FETCH-ENTRY/>";
	if (m_bIsValidEntry)
	{
		sFormXML << "<SUBMIT-ENTRY/>";
	}
	sFormXML << "</FUNCTIONS>";
	sFormXML << "</SUBBED-ENTRY-FORM>";
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
	TDVASSERT(bSuccess, "CSubmitSubbedEntryForm::CreateFromEntryID(...) failed");
	// return the success value
	return bSuccess;
}

/*********************************************************************************

	bool CSubmitSubbedEntryForm::SubmitSubbedEntry(CUser* pViewer, int ih2g2ID, const TDVCHAR* pcComments)

	Author:		Kim Harries
	Created:	15/12/2000
	Inputs:		pViewer - the user (sub editor) returning this entry
				ih2g2ID - the ID of the entry they want to submit as subbed
				pcComments - any comments to be passed on to the editors.
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Submits the entry as finsihed with by the sub editor. Creates appropriate
				XML to report whether or not the submission was successful.

*********************************************************************************/

bool CSubmitSubbedEntryForm::SubmitSubbedEntry(CUser* pViewer, int ih2g2ID, const TDVCHAR* pcComments)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CSubmitSubbedEntryForm::SubmitSubbedEntry(...)");

	bool				bInvalidEntry = false;
	bool				bUserNotSub = false;
	bool				bOkay = false;
	int					iRecommendationStatus = 0;
	CTDVDateTime		dtDateReturned;
	bool				bSuccess = true;

	// try creating the form for this data
	bSuccess = bSuccess && CreateFromh2g2ID(pViewer, ih2g2ID);
	// then check that this was successful and the submission is a valid
	// one before proceeding
	if (bSuccess && m_bIsValidEntry)
	{
		CStoredProcedure	SP;
		

		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			// if couldn't create SP then log error and fail
			TDVASSERT(false, "Failed to create SP in CSubmitSubbedEntryForm::SubmitSubbedEntry(...)");
			bSuccess = false;
		}
		else
		{
			// call the SP method to send the scouts submission, then fetch any fields returned
			bSuccess = bSuccess && SP.SubmitSubbedEntry(pViewer->GetUserID(), ih2g2ID / 10, pcComments);
			if (bSuccess)
			{
				bInvalidEntry = SP.GetBoolField("InvalidEntry");
				bUserNotSub = SP.GetBoolField("UserNotSub");
				bOkay = SP.GetBoolField("Success");
				iRecommendationStatus = SP.GetIntField("RecommendationStatus");
				dtDateReturned = SP.GetDateField("DateReturned");
			}
		}

	}
	// check how things went and give a report
	if (bSuccess)
	{
		// found invalid even before calling the SP
		if (!m_bIsValidEntry)
		{
			// add some extra error info inside the existing XML
			bSuccess = bSuccess && AddInside("SUBBED-ENTRY-FORM", "<ERROR TYPE='INVALID-SUBMISSION'>Invalid Submission</ERROR>");
		}
		// entry is not in the accepted recommendations
		else if (bInvalidEntry)
		{
			// add some extra error info inside the existing XML
			bSuccess = bSuccess && AddInside("SUBBED-ENTRY-FORM", "<ERROR TYPE='INVALID-ENTRY'>Entry is not in the list of accepted scout recommendations</ERROR>");
		}
		// user is not the sub for this entry
		else if (bUserNotSub)
		{
			bSuccess = bSuccess && AddInside("SUBBED-ENTRY-FORM", "<ERROR TYPE='NOT-SUB'>You are not the Sub Editor for this Entry</ERROR>");
		}
		else if (iRecommendationStatus != 2)
		{
			CTDVString	sMessage;
			switch (iRecommendationStatus)
			{
				case 0: sMessage = "<ERROR TYPE='WRONG-STATUS'>Recommendation has no status</ERROR>";
						break;
				case 1: sMessage = "<ERROR TYPE='WRONG-STATUS'>Recommendation has not yet been allocated to a Sub Editor</ERROR>";
						break;
				case 3: sMessage = "<ERROR TYPE='WRONG-STATUS'>Recommendation has already been submitted on ";
						sMessage << (LPCSTR)dtDateReturned.Format("%d-%m-%Y") << "</ERROR>";
						break;
				default: sMessage = "<ERROR TYPE='WRONG-STATUS'>Recommendation has wrong status</ERROR>";
						break;
			}
			bSuccess = bSuccess && AddInside("SUBBED-ENTRY-FORM", sMessage);
		}
		// something unspecified went wrong
		else if (!bOkay)
		{
			bSuccess = bSuccess && AddInside("SUBBED-ENTRY-FORM", "<ERROR TYPE='UNKNOWN'>An unspecified error occurred whilst processing the request.</ERROR>");
		}
		// otherwise all okay!
		else
		{
			// if submission successful then want to return a blank form so
			// that they can submit more if they wish, so destroy current contents
			// and create some more
			Destroy();
			bSuccess = bSuccess && CreateBlankForm(pViewer);
			// also want to put some XML in to indicate that recommendation was successful though
			// stylesheet can then put whatever message is appropriate in
			CTDVString	sMessage = "<SUBMITTED H2G2ID='";
			sMessage << ih2g2ID << "'/>";
			bSuccess = bSuccess && AddInside("SUBBED-ENTRY-FORM", sMessage);
		}
	}
	// return success value
	return bSuccess;
}
