// ProcessRecommendationForm.cpp: implementation of the CProcessRecommendationForm class.
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
#include "ProcessRecommendationForm.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "User.h"
#include "ReviewSubmissionForum.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProcessRecommendationForm::CProcessRecommendationForm(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_pSP(NULL)
{
	// no further construction required
}

CProcessRecommendationForm::~CProcessRecommendationForm()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	bool CProcessRecommendationForm::CreateBlankForm(CUser* pViewer)

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a blank scout recommendations form.

*********************************************************************************/

bool CProcessRecommendationForm::CreateBlankForm(CUser* pViewer)
{
	TDVASSERT(m_pTree == NULL, "CProcessRecommendationForm::CreateBlankForm() called with non-NULL m_pTree");

	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// build the XML for all the basic elements required
	CTDVString	sFormXML = "<PROCESS-RECOMMENDATION-FORM>";

	sFormXML << "<FUNCTIONS><FETCH/></FUNCTIONS>";
	sFormXML << "</PROCESS-RECOMMENDATION-FORM>";
	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CProcessRecommendationForm::CreateFromRecommendationID(CUser* pViewer, int iRecommendationID, const TDVCHAR* pComments, bool bAcceptButton, bool bRejectButton, bool bCancelButton, bool bFetchButton)

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		bAcceptButton - should the accept button be present?
				bRejectButton - should the reject button be present?
				bCancelButton - should the cancel button be present?
				bFetchButton - should the fetch button be present?
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the decision form for this particular recommendation.

*********************************************************************************/

bool CProcessRecommendationForm::CreateFromRecommendationID(CUser* pViewer, int iRecommendationID, const TDVCHAR* pComments, bool bAcceptButton, bool bRejectButton, bool bCancelButton, bool bFetchButton)
{
	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// if we don't already have an SP then create one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if the ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::CreateFromRecommendationID(...)");
		return false;
	}
	// variables we will need
	CTDVString		sComments;
	CTDVString		sAuthorName, sAuthorEmail, sAuthorFirstNames, sAuthorLastName, sAuthorArea, sAuthorSiteSuffix, sAuthorTitle;
	int				nAuthorStatus(0), nAuthorTaxonomyNode(0), nAuthorJournal(0), nAuthorActive(0);
	CTDVString		sScoutName, sScoutEmail, sScoutFirstNames, sScoutLastName, sScoutArea, sScoutSiteSuffix, sScoutTitle;
	int				nScoutStatus(0), nScoutTaxonomyNode(0), nScoutJournal(0), nScoutActive(0);
	CTDVString		sEntrySubject;
	CTDVString		sScoutEmailSubject;
	CTDVString		sScoutEmailText;
	CTDVString		sAuthorEmailSubject;
	CTDVString		sAuthorEmailText;
	int				ih2g2ID = 0;
	int				iAuthorID = 0;
	int				iScoutID = 0;
	CTDVDateTime	dtDateRecommended;
	CTDVString		sDateRecommended;
	bool			bSuccess = true;
	// first call the SP to get all the data we need
	bSuccess = bSuccess && m_pSP->FetchRecommendationDetails(iRecommendationID);
	// fetch each of the fields for the form
	ih2g2ID = m_pSP->GetIntField("h2g2ID");

	// Get and escape editor/Author fields
	iAuthorID = m_pSP->GetIntField("EditorID");
	nAuthorStatus = m_pSP->GetIntField("EditorStatus");
	nAuthorTaxonomyNode = m_pSP->GetIntField("EditorTaxonomyNode");
	nAuthorJournal = m_pSP->GetIntField("EditorJournal");
	nAuthorActive = m_pSP->GetIntField("EditorActive");
	m_pSP->GetField("EditorName", sAuthorName);
	EscapeAllXML(&sAuthorName);
	m_pSP->GetField("EditorEmail", sAuthorEmail);
	EscapeAllXML(&sAuthorEmail);
	m_pSP->GetField("EditorFirstNames", sAuthorFirstNames);
	EscapeAllXML(&sAuthorFirstNames);
	m_pSP->GetField("EditorLastName", sAuthorLastName);
	EscapeAllXML(&sAuthorLastName);
	m_pSP->GetField("EditorArea", sAuthorArea);
	EscapeAllXML(&sAuthorArea);
	m_pSP->GetField("EditorSiteSuffix", sAuthorSiteSuffix);
	EscapeAllXML(&sAuthorSiteSuffix);
	m_pSP->GetField("EditorTitle", sAuthorTitle);
	EscapeAllXML(&sAuthorTitle);

	// Get and escape Scout fields
	iScoutID = m_pSP->GetIntField("ScoutID");
	nScoutStatus = m_pSP->GetIntField("ScoutStatus");
	nScoutTaxonomyNode = m_pSP->GetIntField("ScoutTaxonomyNode");
	nScoutJournal = m_pSP->GetIntField("ScoutJournal");
	nScoutActive = m_pSP->GetIntField("ScoutActive");
	m_pSP->GetField("ScoutName", sScoutName);
	EscapeAllXML(&sScoutName);
	m_pSP->GetField("ScoutEmail", sScoutEmail);
	EscapeAllXML(&sScoutEmail);
	m_pSP->GetField("ScoutFirstNames", sScoutFirstNames);
	EscapeAllXML(&sScoutFirstNames);
	m_pSP->GetField("ScoutLastName", sScoutLastName);
	EscapeAllXML(&sScoutLastName);
	m_pSP->GetField("ScoutArea", sScoutArea);
	EscapeAllXML(&sScoutArea);
	m_pSP->GetField("ScoutSiteSuffix", sScoutSiteSuffix);
	EscapeAllXML(&sScoutSiteSuffix);
	m_pSP->GetField("ScoutTitle", sScoutTitle);
	EscapeAllXML(&sScoutTitle);

	m_pSP->GetField("Subject", sEntrySubject);
	dtDateRecommended = m_pSP->GetDateField("DateRecommended");
	dtDateRecommended.GetAsXML(sDateRecommended, true);
	m_pSP->GetField("Comments", sComments);
	// if we know what the decision is going to be then create an appropriate
	// default email to send
	if (bAcceptButton && !bRejectButton)
	{
		bSuccess = bSuccess && CreateScoutAcceptanceEmail(sScoutName, sEntrySubject, ih2g2ID, dtDateRecommended, &sScoutEmailSubject, &sScoutEmailText);
		bSuccess = bSuccess && CreateAuthorAcceptanceEmail(sAuthorName, sEntrySubject, ih2g2ID, dtDateRecommended, &sAuthorEmailSubject, &sAuthorEmailText);
	}
	else if (bRejectButton && !bAcceptButton)
	{
		bSuccess = bSuccess && CreateScoutRejectionEmail(sScoutName, sEntrySubject, ih2g2ID, dtDateRecommended, &sScoutEmailSubject, &sScoutEmailText);
	}
	// build the XML for all the basic elements required
	CTDVString	sFormXML = "<PROCESS-RECOMMENDATION-FORM>";

	EscapeAllXML(&sComments);
	EscapeAllXML(&sEntrySubject);
	sFormXML << "<RECOMMENDATION-ID>" << iRecommendationID << "</RECOMMENDATION-ID>";
	sFormXML << "<H2G2-ID>" << ih2g2ID << "</H2G2-ID>";
	sFormXML << "<SUBJECT>" << sEntrySubject << "</SUBJECT>";;
	sFormXML << "<COMMENTS>" << sComments << "</COMMENTS>";;
	
	// Get editor groups
	CTDVString sAuthorGroups;
	if(!m_InputContext.GetUserGroups(sAuthorGroups, iAuthorID))
	{
		TDVASSERT(false, "Failed to get user groups for author");
	}

	// Create Editor xml
	sFormXML << "<EDITOR><USER>"
			 << "<USERID>"			<< iAuthorID			<< "</USERID>"
			 << "<USERNAME>"		<< sAuthorName			<< "</USERNAME>"
			 << "<EMAIL-ADDRESS>"	<< sAuthorEmail			<< "</EMAIL-ADDRESS>"
			 << "<FIRSTNAMES>"		<< sAuthorFirstNames	<< "</FIRSTNAMES>"
			 << "<LASTNAME>"		<< sAuthorLastName		<< "</LASTNAME>"
			 << "<AREA>"			<< sAuthorArea			<< "</AREA>"
			 << "<STATUS>"			<< nAuthorStatus		<< "</STATUS>"
			 << "<TAXONOMYNODE>"	<< nAuthorTaxonomyNode	<< "</TAXONOMYNODE>"
			 << "<JOURNAL>"			<< nAuthorJournal		<< "</JOURNAL>"
			 << "<ACTIVE>"			<< nAuthorActive		<< "</ACTIVE>"
			 << "<SITESUFFIX>"		<< sAuthorSiteSuffix	<< "</SITESUFFIX>"
			 << "<TITLE>"			<< sAuthorTitle			<< "</TITLE>"
			 << sAuthorGroups
			 << "</USER></EDITOR>";

	// Get Scout groups
	CTDVString sScoutGroups;
	if(!m_InputContext.GetUserGroups(sScoutGroups, iScoutID))
	{
		TDVASSERT(false, "Failed to get user groups for scout");
	}

	// Create Scout xml
	sFormXML << "<SCOUT><USER>"
			 << "<USERID>"			<< iScoutID				<< "</USERID>"
			 << "<USERNAME>"		<< sScoutName			<< "</USERNAME>"
			 << "<EMAIL-ADDRESS>"	<< sScoutEmail			<< "</EMAIL-ADDRESS>"
			 << "<FIRSTNAMES>"		<< sScoutFirstNames		<< "</FIRSTNAMES>"
			 << "<LASTNAME>"		<< sScoutLastName		<< "</LASTNAME>"
			 << "<AREA>"			<< sScoutArea			<< "</AREA>"
			 << "<STATUS>"			<< nScoutStatus			<< "</STATUS>"
			 << "<TAXONOMYNODE>"	<< nScoutTaxonomyNode	<< "</TAXONOMYNODE>"
			 << "<JOURNAL>"			<< nScoutJournal		<< "</JOURNAL>"
			 << "<ACTIVE>"			<< nScoutActive			<< "</ACTIVE>"
			 << "<SITESUFFIX>"		<< sScoutSiteSuffix		<< "</SITESUFFIX>"
			 << "<TITLE>"			<< sScoutTitle			<< "</TITLE>"
			 << sScoutGroups
			 << "</USER></SCOUT>";

	sFormXML << "<DATE-RECOMMENDED>";
	sFormXML << sDateRecommended;
	sFormXML << "</DATE-RECOMMENDED>";
	sFormXML << "<SCOUT-EMAIL>";
	sFormXML << "<SUBJECT>" << sScoutEmailSubject << "</SUBJECT>";
	sFormXML << "<TEXT>" << sScoutEmailText << "</TEXT>";
	sFormXML << "</SCOUT-EMAIL>";
	sFormXML << "<AUTHOR-EMAIL>";
	sFormXML << "<SUBJECT>" << sAuthorEmailSubject << "</SUBJECT>";
	sFormXML << "<TEXT>" << sAuthorEmailText << "</TEXT>";
	sFormXML << "</AUTHOR-EMAIL>";
	sFormXML << "<FUNCTIONS>";
	if (bAcceptButton)
	{
		sFormXML << "<ACCEPT/>";
	}
	if (bRejectButton)
	{
		sFormXML << "<REJECT/>";
	}
	if (bCancelButton)
	{
		sFormXML << "<CANCEL/>";
	}
	if (bFetchButton)
	{
		sFormXML << "<FETCH/>";
	}
	sFormXML << "</FUNCTIONS>";
	sFormXML << "</PROCESS-RECOMMENDATION-FORM>";
	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CProcessRecommendationForm::CreateFromEntryID(CUser* pViewer, int iEntryID, const TDVCHAR* pComments, bool bAcceptButton, bool bRejectButton, bool bCancelButton, bool bFetchButton)

	Author:		Kim Harries
	Created:	26/11/2000
	Inputs:		pViewer - user creating the form
				iEntryID - entry to look for a recommendation of
				bAcceptButton - should the accept button be present?
				bRejectButton - should the reject button be present?
				bCancelButton - should the cancel button be present?
				bFetchButton - should the fetch button be present?
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the decision form for the scout recommendation associated
				with this entry, if there is one.

*********************************************************************************/

bool CProcessRecommendationForm::CreateFromEntryID(CUser* pViewer, int iEntryID, const TDVCHAR* pComments, bool bAcceptButton, bool bRejectButton, bool bCancelButton, bool bFetchButton)
{
	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// if we don't already have an SP then create one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if the ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::CreateFromEntryID(...)");
		return false;
	}
	// variables we will need
	CTDVString		sFormXML;
	CTDVString		sSubject;
	CTDVString		sComments;
	CTDVString		sAuthorName, sAuthorFirstNames, sAuthorLastName, sAuthorArea, sAuthorSiteSuffix, sAuthorTitle;
	int				nAuthorStatus(0), nAuthorTaxonomyNode(0), nAuthorJournal(0), nAuthorActive(0);
	CTDVString		sScoutName, sScoutEmail, sScoutFirstNames, sScoutLastName, sScoutArea, sScoutSiteSuffix, sScoutTitle;
	int				nScoutStatus(0), nScoutTaxonomyNode(0), nScoutJournal(0), nScoutActive(0);
	CTDVString		sEntrySubject;
	CTDVString		sEmailSubject;
	CTDVString		sEmailText;
	int				iRecommendationID = 0;
	int				ih2g2ID = 0;
	int				iAuthorID = 0;
	int				iScoutID = 0;
	CTDVDateTime	dtDateRecommended;
	CTDVString		sDateRecommended;
	bool			bFound = true;
	bool			bSuccess = true;
	// first call the SP to get all the data we need
	bSuccess = bSuccess && m_pSP->FetchRecommendationDetailsFromEntryID(iEntryID);
	// first check if recommendation was found
	bFound = m_pSP->GetBoolField("Success");
	if (bFound)
	{
		// fetch each of the fields for the form
		iRecommendationID = m_pSP->GetIntField("RecommendationID");
		ih2g2ID = m_pSP->GetIntField("h2g2ID");
		m_pSP->GetField("Subject", sEntrySubject);
		dtDateRecommended = m_pSP->GetDateField("DateRecommended");
		dtDateRecommended.GetAsXML(sDateRecommended, true);
		m_pSP->GetField("Subject", sSubject);
		m_pSP->GetField("Comments", sComments);

		// Get and escape editor/Author fields
		iAuthorID = m_pSP->GetIntField("EditorID");
		nAuthorStatus = m_pSP->GetIntField("EditorStatus");
		nAuthorTaxonomyNode = m_pSP->GetIntField("EditorTaxonomyNode");
		nAuthorJournal = m_pSP->GetIntField("EditorJournal");
		nAuthorActive = m_pSP->GetIntField("EditorActive");
		m_pSP->GetField("EditorName", sAuthorName);
		EscapeAllXML(&sAuthorName);
		m_pSP->GetField("EditorFirstNames", sAuthorFirstNames);
		EscapeAllXML(&sAuthorFirstNames);
		m_pSP->GetField("EditorLastName", sAuthorLastName);
		EscapeAllXML(&sAuthorLastName);
		m_pSP->GetField("EditorArea", sAuthorArea);
		EscapeAllXML(&sAuthorArea);
		m_pSP->GetField("EditorSiteSuffix", sAuthorSiteSuffix);
		EscapeAllXML(&sAuthorSiteSuffix);
		m_pSP->GetField("EditorTitle", sAuthorTitle);
		EscapeAllXML(&sAuthorTitle);

		// Get and escape Scout fields
		iScoutID = m_pSP->GetIntField("ScoutID");
		nScoutStatus = m_pSP->GetIntField("ScoutStatus");
		nScoutTaxonomyNode = m_pSP->GetIntField("ScoutTaxonomyNode");
		nScoutJournal = m_pSP->GetIntField("ScoutJournal");
		nScoutActive = m_pSP->GetIntField("ScoutActive");
		m_pSP->GetField("ScoutName", sScoutName);
		EscapeAllXML(&sScoutName);
		m_pSP->GetField("ScoutEmail", sScoutEmail);
		EscapeAllXML(&sScoutEmail);
		m_pSP->GetField("ScoutFirstNames", sScoutFirstNames);
		EscapeAllXML(&sScoutFirstNames);
		m_pSP->GetField("ScoutLastName", sScoutLastName);
		EscapeAllXML(&sScoutLastName);
		m_pSP->GetField("ScoutArea", sScoutArea);
		EscapeAllXML(&sScoutArea);
		m_pSP->GetField("ScoutSiteSuffix", sScoutSiteSuffix);
		EscapeAllXML(&sScoutSiteSuffix);
		m_pSP->GetField("ScoutTitle", sScoutTitle);
		EscapeAllXML(&sScoutTitle);

		// if we know what the decision is going to be then create an appropriate
		// default email to send
		if (bAcceptButton && !bRejectButton)
		{
			bSuccess = bSuccess && CreateScoutAcceptanceEmail(sScoutName, sEntrySubject, ih2g2ID, dtDateRecommended, &sEmailSubject, &sEmailText);
		}
		else if (bRejectButton && !bAcceptButton)
		{
			bSuccess = bSuccess && CreateScoutRejectionEmail(sScoutName, sEntrySubject, ih2g2ID, dtDateRecommended, &sEmailSubject, &sEmailText);
		}
		// build the XML for all the basic elements required
		sFormXML = "<PROCESS-RECOMMENDATION-FORM>";

		sFormXML << "<RECOMMENDATION-ID>" << iRecommendationID << "</RECOMMENDATION-ID>";
		sFormXML << "<H2G2-ID>" << ih2g2ID << "</H2G2-ID>";
		sFormXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		sFormXML << "<COMMENTS>" << sComments << "</COMMENTS>";
		
		// Get Author groups
		CTDVString sAuthorGroups;
		if(!m_InputContext.GetUserGroups(sAuthorGroups, iAuthorID))
		{
			TDVASSERT(false, "Failed to get user groups for author");
		}
		
		// Create Editor xml
		sFormXML << "<EDITOR><USER>"
				 << "<USERID>"			<< iAuthorID			<< "</USERID>"
				 << "<USERNAME>"		<< sAuthorName			<< "</USERNAME>"
				 << "<FIRSTNAMES>"		<< sAuthorFirstNames	<< "</FIRSTNAMES>"
				 << "<LASTNAME>"		<< sAuthorLastName		<< "</LASTNAME>"
				 << "<AREA>"			<< sAuthorArea			<< "</AREA>"
				 << "<STATUS>"			<< nAuthorStatus		<< "</STATUS>"
				 << "<TAXONOMYNODE>"	<< nAuthorTaxonomyNode	<< "</TAXONOMYNODE>"
				 << "<JOURNAL>"			<< nAuthorJournal		<< "</JOURNAL>"
				 << "<ACTIVE>"			<< nAuthorActive		<< "</ACTIVE>"
				 << "<SITESUFFIX>"		<< sAuthorSiteSuffix	<< "</SITESUFFIX>"
				 << "<TITLE>"			<< sAuthorTitle			<< "</TITLE>"
				 << sAuthorGroups
				 << "</USER></EDITOR>";

		// Get Scout groups
		CTDVString sScoutGroups;
		if(!m_InputContext.GetUserGroups(sScoutGroups, iScoutID))
		{
			TDVASSERT(false, "Failed to get user groups for scout");
		}

		// Create Scout xml
		sFormXML << "<SCOUT><USER>"
				 << "<USERID>"			<< iScoutID				<< "</USERID>"
				 << "<USERNAME>"		<< sScoutName			<< "</USERNAME>"
				 << "<EMAIL-ADDRESS>"	<< sScoutEmail			<< "</EMAIL-ADDRESS>"
				 << "<FIRSTNAMES>"		<< sScoutFirstNames		<< "</FIRSTNAMES>"
				 << "<LASTNAME>"		<< sScoutLastName		<< "</LASTNAME>"
				 << "<AREA>"			<< sScoutArea			<< "</AREA>"
				 << "<STATUS>"			<< nScoutStatus			<< "</STATUS>"
				 << "<TAXONOMYNODE>"	<< nScoutTaxonomyNode	<< "</TAXONOMYNODE>"
				 << "<JOURNAL>"			<< nScoutJournal		<< "</JOURNAL>"
				 << "<ACTIVE>"			<< nScoutActive			<< "</ACTIVE>"
				 << "<SITESUFFIX>"		<< sScoutSiteSuffix		<< "</SITESUFFIX>"
				 << "<TITLE>"			<< sScoutTitle			<< "</TITLE>"
				 << sScoutGroups
				 << "</USER></SCOUT>";
		
		sFormXML << "<DATE-RECOMMENDED>";
		sFormXML << sDateRecommended;
		sFormXML << "</DATE-RECOMMENDED>";
		sFormXML << "<EMAIL-SUBJECT>" << sEmailSubject << "</EMAIL-SUBJECT>";
		sFormXML << "<EMAIL-TEXT>" << sEmailText << "</EMAIL-TEXT>";
		sFormXML << "<FUNCTIONS>";
		if (bAcceptButton)
		{
			sFormXML << "<ACCEPT/>";
		}
		if (bRejectButton)
		{
			sFormXML << "<REJECT/>";
		}
		if (bCancelButton)
		{
			sFormXML << "<CANCEL/>";
		}
		if (bFetchButton)
		{
			sFormXML << "<FETCH/>";
		}
		sFormXML << "</FUNCTIONS>";
		sFormXML << "</PROCESS-RECOMMENDATION-FORM>";
	}
	else
	{
		// otherwise create a blank form with an error message
		sFormXML = "<PROCESS-RECOMMENDATION-FORM>";
		sFormXML << "<ERROR TYPE='RECOMMENDATION-NOT-FOUND'>No recommendation for this Entry was found</ERROR>";
		sFormXML << "<FUNCTIONS><FETCH/></FUNCTIONS>";
		sFormXML << "</PROCESS-RECOMMENDATION-FORM>";
	}
	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CProcessRecommendationForm::SubmitAccept(CUser* pViewer, int iRecommendationID, const TDVCHAR* pcComments, bool* pbSuccess, CTDVString* psScoutEmail, CTDVString* psAuthorEmail, CTDVString* psScoutEmailSubject, CTDVString* psScoutEmailText, CTDVString* psAuthorEmailSubject, CTDVString* psAuthorEmailText)

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		pViewer - user doing the acceptance
				iRecommendationID - ID of the scout recommendation to accept
				pcComments - any comments to attached to the recommendation
	Outputs:	pbSuccess - whether update was successful or not
				psScoutEmail - email address to send the scouts acceptance email to
				psAuthorEmail - email address to send the authors acceptance email to
				psScoutEmailSubject - subject line for the email to scout
				psScoutEmailText - text of the acceptance email to scout
				psScoutEmailSubject - subject line for the email to author
				psScoutEmailText - text of the acceptance email to author
	Returns:	true for success or false for failure
	Purpose:	Updates the recommendations status in the DB to show that it has
				been accepted by a member of staff. Also returns the details to
				allow an acceptance email to be sent to the scout.

*********************************************************************************/

bool CProcessRecommendationForm::SubmitAccept(CUser* pViewer, int ih2g2ID_Old,int iRecommendationID, const TDVCHAR* pcComments, bool* pbSuccess, CTDVString* psScoutEmail, CTDVString* psAuthorEmail, CTDVString* psScoutEmailSubject, CTDVString* psScoutEmailText, CTDVString* psAuthorEmailSubject, CTDVString* psAuthorEmailText)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(pbSuccess != NULL, "NULL pbSuccess in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(psScoutEmail != NULL, "NULL psScoutEmail in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(psAuthorEmail != NULL, "NULL psAuthorEmail in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(psScoutEmailSubject != NULL, "NULL psScoutEmailSubject in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(psScoutEmailText != NULL, "NULL psScoutEmailText in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(psAuthorEmailSubject != NULL, "NULL psAuthorEmailSubject in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(psAuthorEmailText != NULL, "NULL psAuthorEmailText in CProcessRecommendationForm::SubmitAccept(...)");
	TDVASSERT(ih2g2ID_Old > 0, "h2g2id_old = 0 in CProcessRecommendationForm::SubmitAccept(...)");
	// if viewer is NULL or not an editor then fail
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return false;
	}
	// if the don't already have an SP then create one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::SubmitAccept(...)");
		return false;
	}
	// update the status in the DB and also fetch any details necessary for creating
	// the acceptance email to go out to the scout
	CTDVString		sScoutName;
	CTDVString		sAuthorName;
	CTDVString		sEntrySubject;
	CTDVDateTime	dtDateRecommended;
	int				ih2g2ID_New = 0;
	bool			bSuccess = true;
	
	// update the recommendations status in the DB
	bSuccess = bSuccess && m_pSP->AcceptScoutRecommendation(iRecommendationID, pViewer->GetUserID(), pcComments);
	// create the current object as a blank form
	bSuccess = bSuccess && CreateBlankForm(pViewer);
	// set the output variables if they have been provided
	if (pbSuccess != NULL)
	{
		// add some XML to show successful submission
		bSuccess = bSuccess && AddInside("PROCESS-RECOMMENDATION-FORM", "<SUBMISSION SUCCESS='1'/>");
		// get the success value
		*pbSuccess = m_pSP->GetBoolField("Success");
		// only try to get the other stuff if update was successful
		if (*pbSuccess)
		{
			
			
			// get the email address of the scout that recommended this entry
			if (psScoutEmail != NULL)
			{
				bSuccess = bSuccess && m_pSP->GetField("ScoutEmail", *psScoutEmail);
			}
			// get the authors email address
			if (psAuthorEmail != NULL)
			{
				bSuccess = bSuccess && m_pSP->GetField("AuthorEmail", *psAuthorEmail);
			}
			// also get the scout name, entry subject, h2g2ID and date recommended
			// so that the email can be customised
			bSuccess = bSuccess && m_pSP->GetField("ScoutName", sScoutName);
			bSuccess = bSuccess && m_pSP->GetField("AuthorName", sAuthorName);
			ih2g2ID_New = m_pSP->GetIntField("h2g2ID");
			bSuccess = bSuccess && m_pSP->GetField("Subject", sEntrySubject);
			dtDateRecommended = m_pSP->GetDateField("DateRecommended");
			bSuccess = bSuccess && CreateScoutAcceptanceEmail(sScoutName, sEntrySubject, ih2g2ID_New, dtDateRecommended, psScoutEmailSubject, psScoutEmailText);
			bSuccess = bSuccess && CreateAuthorAcceptanceEmail(sAuthorName, sEntrySubject, ih2g2ID_New, dtDateRecommended, psAuthorEmailSubject, psAuthorEmailText);
			
			//remove the article from the review forum, this also updates the article
			int iReviewForumID = 0;
			if (m_pSP->FetchReviewForumMemberDetails(ih2g2ID_Old))
			{
				iReviewForumID = m_pSP->GetIntField("ReviewForumID");
			}
			
			CReviewSubmissionForum mReviewSubmissionForum(m_InputContext);
			
			bool bThreadRemoved = false;
			int iThreadID = 0;
			int iForumID = 0;
			int iPostID = 0;
		
			mReviewSubmissionForum.RemoveThreadFromForum(*pViewer,iReviewForumID,ih2g2ID_Old,&iThreadID,&iForumID,&bThreadRemoved,true);
			
			//post a message to the end of the thread saying why it was moved 
			
			if (bThreadRemoved)
			{
				CTDVString	sSubject;
				CTDVString	sBody;

				if (!m_pSP->FetchEmailText(m_InputContext.GetSiteID(),"AcceptRecPost",&sBody,&sSubject))	
				{
					//if the text doesn't exist for this site then use this as default.

					TDVASSERT(false,"Failed to find AcceptRecPost namedarticle in ProcessRecommendationForm");
					sSubject = "Congratulations - Your Entry has been Recommended for the Edited Guide!";
					sBody = "Your Guide Entry has just been picked from Peer Review by one of our Scouts,"
							" and is now heading off into the Editorial Process, which ends with publication"
							" in the Edited Guide. We've moved this Review Conversation out of Peer Review"
							" and to the entry itself.\n\n" 
							"If you'd like to know what happens now, check out the page on"
							" 'What Happens after your Entry has been Recommended?' at <./>EditedGuide-Process</.>. "
							"We hope this explains everything.\n\nThanks for contributing to the Edited Guide!";
				}
				
				int iAutoMessageUserID = 294;
				iAutoMessageUserID = m_InputContext.GetAutoMessageUserID(m_InputContext.GetSiteID());
				//do this even if the emails are not sent out
				bool bPostToThread = m_pSP->PostToEndOfThread(iAutoMessageUserID, iThreadID, sSubject, sBody, &iPostID);

				TDVASSERT(bPostToThread,"Failed to add moved thread message in CProcessRecommendationForm:: SubmitAccept");
			}
		}
		else
		{
			// add some XML to show failed submission
			bSuccess = bSuccess && AddInside("PROCESS-RECOMMENDATION-FORM", "<SUBMISSION SUCCESS='0'/>");
		}
	}
	// log error if something went wrong
	TDVASSERT(bSuccess, "AcceptScoutRecommendation failed in CProcessRecommendationForm::SubmitAccept(...)");
	return bSuccess;
}

/*********************************************************************************

	bool CProcessRecommendationForm::SubmitReject(CUser* pViewer, int iRecommendationID, const TDVCHAR* pcComments, bool* pbSuccess, CTDVString* psScoutEmail, CTDVString* psEmailSubject, CTDVString* psEmailText)

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		pViewer - user doing the rejecting
				iRecommendationID - ID of the scout recommendation to reject
				pcComments - any comments to attached to the recommendation
	Outputs:	pbSuccess - whether update was successful or not
				psScoutEmail - email address to send the scouts rejection email to
				psEmailSubject - subject line for the email
				psEmailText - text of the automatic rejection email
	Returns:	true for success or false for failure
	Purpose:	Updates the recommendations status in the DB to show that it has
				been rejected by a member of staff.

*********************************************************************************/

bool CProcessRecommendationForm::SubmitReject(CUser* pViewer, int iRecommendationID, const TDVCHAR* pcComments, bool* pbSuccess, CTDVString* psScoutEmail, CTDVString* psEmailSubject, CTDVString* psEmailText)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CProcessRecommendationForm::SubmitReject(...)");
	TDVASSERT(pbSuccess != NULL, "NULL pbSuccess in CProcessRecommendationForm::SubmitReject(...)");
	TDVASSERT(psScoutEmail != NULL, "NULL psScoutEmail in CProcessRecommendationForm::SubmitReject(...)");
	TDVASSERT(psEmailSubject != NULL, "NULL psEmailSubject in CProcessRecommendationForm::SubmitReject(...)");
	TDVASSERT(psEmailText != NULL, "NULL psEmailText in CProcessRecommendationForm::SubmitReject(...)");

	// if viewer is NULL or not an editor then fail
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return false;
	}
	// if we don't already have an SP then create one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if the ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::SubmitReject(...)");
		return false;
	}
	// update the status in the DB and also fetch any details necessary for creating
	// the acceptance email to go out to the scout
	CTDVString		sScoutName;
	CTDVString		sEntrySubject;
	CTDVDateTime	dtDateRecommended;
	int				ih2g2ID = 0;
	bool			bSuccess = true;

	// do the update in the DB - this will also fetch the relevant fields to the email
	bSuccess = bSuccess && m_pSP->RejectScoutRecommendation(iRecommendationID, pViewer->GetUserID(), pcComments);
	// create the current object as a blank form
	bSuccess = bSuccess && CreateBlankForm(pViewer);
	// set the output variables if they have been provided
	if (pbSuccess != NULL)
	{
		// get the success value
		*pbSuccess = m_pSP->GetBoolField("Success");
		// only try to get the other stuff if update was successful
		if (*pbSuccess)
		{
			// add some XML to show successful submission
			bSuccess = bSuccess && AddInside("PROCESS-RECOMMENDATION-FORM", "<SUBMISSION SUCCESS='1'/>");
			// get the email address of the scout that recommended this entry
			if (psScoutEmail != NULL)
			{
				bSuccess = bSuccess && m_pSP->GetField("ScoutEmail", *psScoutEmail);
			}
			// also get the scout name, entry subject, h2g2ID and date recommended
			// so that the email can be customised
			bSuccess = bSuccess && m_pSP->GetField("ScoutName", sScoutName);
			bSuccess = bSuccess && m_pSP->GetField("Subject", sEntrySubject);
			ih2g2ID = m_pSP->GetIntField("h2g2ID");
			dtDateRecommended = m_pSP->GetDateField("DateRecommended");
			bSuccess = bSuccess && CreateScoutRejectionEmail(sScoutName, sEntrySubject, ih2g2ID, dtDateRecommended, psEmailSubject, psEmailText);
		}
		else
		{
			// add some XML to chosw submission failed
			bSuccess = bSuccess && AddInside("PROCESS-RECOMMENDATION-FORM", "<SUBMISSION SUCCESS='0'/>");
		}
	}
	// log error if something went wrong
	TDVASSERT(bSuccess, "RejectScoutRecommendation failed in CProcessRecommendationForm::SubmitReject(...)");
	return bSuccess;
}

/*********************************************************************************

	bool CProcessRecommendationForm::CreateScoutAcceptanceEmail(const TDVCHAR* pcScoutName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText)

	Author:		Kim Harries
	Created:	27/11/2000
	Inputs:		pcScoutName - scouts username
				pcEntrySubject - subject of the entry recommended
				ih2g2ID - ID of the entry
				dtDateRecommended - date that entry was recommended
	Outputs:	psEmailSubject - the subject line for the email
				psEmailText - the body of the email
	Returns:	true for success or false for failure
	Purpose:	Builds the default personalised email message for this recommendation
				being accepted.

*********************************************************************************/

bool CProcessRecommendationForm::CreateScoutAcceptanceEmail(const TDVCHAR* pcScoutName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText)
{
	TDVASSERT(psEmailSubject != NULL, "NULL psEmailSubject in CProcessRecommendationForm::CreateScoutAcceptanceEmail(...)");
	TDVASSERT(psEmailText != NULL, "NULL psEmailText in CProcessRecommendationForm::CreateScoutAcceptanceEmail(...)");

	CTDVString			sEmailSubject;
	CTDVString			sEmailText;
	CTDVString			sEntrySubject = pcEntrySubject;
	CTDVString			sScoutName = pcScoutName;
	CTDVString			sDateRecommended;
	CTDVString			sh2g2ID = "";
	bool				bSuccess = true;

	CStoredProcedure	SP;
	
	// fail if we have no SP
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::CreateScoutAcceptanceEmail(...)");
		return false;
	}
	// get the date in a simple format
	sDateRecommended = (LPCSTR) dtDateRecommended.Format("%d %b %Y");
	sh2g2ID << ih2g2ID;
	// fetch the text for the email
	bSuccess = bSuccess && SP.FetchEmailText(m_InputContext.GetSiteID(),
		"AcceptRecEmail", &sEmailText, &sEmailSubject);
	// do any transformations necessary
	sEmailSubject.Replace("++**entry_subject**++", sEntrySubject);
	sEmailSubject.Replace("++**scout_name**++", sScoutName);
	sEmailSubject.Replace("++**date_recommended**++", sDateRecommended);
	sEmailSubject.Replace("++**h2g2id**++", sh2g2ID);
	sEmailText.Replace("++**entry_subject**++", sEntrySubject);
	sEmailText.Replace("++**scout_name**++", sScoutName);
	sEmailText.Replace("++**date_recommended**++", sDateRecommended);
	sEmailText.Replace("++**h2g2id**++", sh2g2ID);

	// simply ignore any output variables that are NULL
	if (psEmailSubject != NULL)
	{
		(*psEmailSubject) = sEmailSubject;
	}
	if (psEmailText != NULL)
	{
		(*psEmailText) = sEmailText;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CProcessRecommendationForm::CreateAuthorAcceptanceEmail(const TDVCHAR* pcAuthorName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText)

	Author:		Kim Harries
	Created:	05/03/2001
	Inputs:		pcAuthorName - authors username
				pcEntrySubject - subject of the entry recommended
				ih2g2ID - ID of the entry
				dtDateRecommended - date that entry was recommended
	Outputs:	psEmailSubject - the subject line for the email
				psEmailText - the body of the email
	Returns:	true for success or false for failure
	Purpose:	Builds the default personalised email message to the author
				for this recommendation being accepted.

*********************************************************************************/

bool CProcessRecommendationForm::CreateAuthorAcceptanceEmail(const TDVCHAR* pcAuthorName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText)
{
	TDVASSERT(psEmailSubject != NULL, "NULL psEmailSubject in CProcessRecommendationForm::CreateAuthorAcceptanceEmail(...)");
	TDVASSERT(psEmailText != NULL, "NULL psEmailText in CProcessRecommendationForm::CreateAuthorAcceptanceEmail(...)");

	CTDVString			sEmailSubject;
	CTDVString			sEmailText;
	CTDVString			sEntrySubject = pcEntrySubject;
	CTDVString			sAuthorName = pcAuthorName;
	CTDVString			sDateRecommended;
	CTDVString			sh2g2ID = "";
	bool				bSuccess = true;

	CStoredProcedure	SP;
	
	// fail if we have no SP
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::CreateAuthorAcceptanceEmail(...)");
		return false;
	}
	// get the date in a simple format
	sDateRecommended = (LPCSTR) dtDateRecommended.Format("%d %b %Y");
	sh2g2ID << ih2g2ID;
	// fetch the text for the email
	bSuccess = bSuccess && SP.FetchEmailText(m_InputContext.GetSiteID(),
		"AuthorRecEmail", &sEmailText, &sEmailSubject);
	// do any transformations necessary
	sEmailSubject.Replace("++**entry_subject**++", sEntrySubject);
	sEmailSubject.Replace("++**author_name**++", sAuthorName);
	sEmailSubject.Replace("++**date_recommended**++", sDateRecommended);
	sEmailSubject.Replace("++**h2g2id**++", sh2g2ID);
	sEmailText.Replace("++**entry_subject**++", sEntrySubject);
	sEmailText.Replace("++**author_name**++", sAuthorName);
	sEmailText.Replace("++**date_recommended**++", sDateRecommended);
	sEmailText.Replace("++**h2g2id**++", sh2g2ID);

	// simply ignore any output variables that are NULL
	if (psEmailSubject != NULL)
	{
		(*psEmailSubject) = sEmailSubject;
	}
	if (psEmailText != NULL)
	{
		(*psEmailText) = sEmailText;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CProcessRecommendationForm::CreateScoutRejectionEmail(const TDVCHAR* pcScoutName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText)

	Author:		Kim Harries
	Created:	27/11/2000
	Inputs:		pcScoutName - scouts username
				pcEntrySubject - subject of the entry recommended
				ih2g2ID - ID of the entry
				dtDateRecommended - date that entry was recommended
	Outputs:	psEmailSubject - the subject line for the email
				psEmailText - the body of the email
	Returns:	true for success or false for failure
	Purpose:	Builds the default personalised email message for this recommendation
				being rejected.

*********************************************************************************/

bool CProcessRecommendationForm::CreateScoutRejectionEmail(const TDVCHAR* pcScoutName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText)
{
	TDVASSERT(psEmailSubject != NULL, "NULL psEmailSubject in CProcessRecommendationForm::CreateScoutAcceptanceEmail(...)");
	TDVASSERT(psEmailText != NULL, "NULL psEmailText in CProcessRecommendationForm::CreateScoutAcceptanceEmail(...)");

	CTDVString			sEmailSubject;
	CTDVString			sEmailText;
	CTDVString			sEntrySubject = pcEntrySubject;
	CTDVString			sScoutName = pcScoutName;
	CTDVString			sDateRecommended;
	CTDVString			sh2g2ID = "";
	bool				bSuccess = true;

	CStoredProcedure	SP;
	
	// fail if we have no SP
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CProcessRecommendationForm::CreateScoutAcceptanceEmail(...)");
		return false;
	}
	// get the date in a simple format
	sDateRecommended = (LPCSTR) dtDateRecommended.Format("%d %b %Y");
	sh2g2ID << ih2g2ID;
	// fetch the text for the email
	bSuccess = bSuccess && SP.FetchEmailText(m_InputContext.GetSiteID(),
		"RejectRecEmail", &sEmailText, &sEmailSubject);
	// do any transformations necessary
	sEmailSubject.Replace("++**entry_subject**++", sEntrySubject);
	sEmailSubject.Replace("++**scout_name**++", sScoutName);
	sEmailSubject.Replace("++**date_recommended**++", sDateRecommended);
	sEmailSubject.Replace("++**h2g2id**++", sh2g2ID);
	sEmailText.Replace("++**entry_subject**++", sEntrySubject);
	sEmailText.Replace("++**scout_name**++", sScoutName);
	sEmailText.Replace("++**date_recommended**++", sDateRecommended);
	sEmailText.Replace("++**h2g2id**++", sh2g2ID);

	// simply ignore any output variables that are NULL
	if (psEmailSubject != NULL)
	{
		(*psEmailSubject) = sEmailSubject;
	}
	if (psEmailText != NULL)
	{
		(*psEmailText) = sEmailText;
	}
	return bSuccess;
}

#endif // _ADMIN_VERSION
