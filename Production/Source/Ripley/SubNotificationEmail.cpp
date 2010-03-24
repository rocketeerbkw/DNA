// SubNotificationEmail.cpp: implementation of the CSubNotificationEmail class.
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
#include "SubNotificationEmail.h"
#include "InputContext.h"
#include "TDVString.h"
#include "TDVDateTime.h"
#include "StoredProcedure.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSubNotificationEmail::CSubNotificationEmail(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
	// none
}

CSubNotificationEmail::~CSubNotificationEmail()
{
	// none
}

/*********************************************************************************

	bool CSubNotificationEmail::CreateNotificationEmail(int iSubID, bool* pbToSend, CTDVString* psEmailAddress, CTDVString* psEmailSubject, CTDVString* psEmailText)

	Author:		Kim Harries
	Created:	28/11/2000
	Inputs:		iSubID - user id of the sub to create the notification for
	Outputs:	pbToSend - whether or not an email to send was created
				psEmailAddress - the subs email address
				psEmailSubject - the subject line for the email
				psEmailText - the text of the email
	Returns:	true for success or false for failure
	Purpose:	Checks to see if this sub editor has any allocations that they have
				not yet been notified about, and if so builds the email to send
				in order to notify them.

*********************************************************************************/

bool CSubNotificationEmail::CreateNotificationEmail(int iSubID, bool* pbToSend, CTDVString* psEmailAddress, CTDVString* psEmailSubject, CTDVString* psEmailText)
{
	TDVASSERT(pbToSend != NULL, "NULL pbToSend in CSubNotificationEmail::CreateNotificationEmail(...)");
	TDVASSERT(psEmailAddress != NULL, "NULL psEmailAddress in CSubNotificationEmail::CreateNotificationEmail(...)");
	TDVASSERT(psEmailText != NULL, "NULL psEmailText in CSubNotificationEmail::CreateNotificationEmail(...)");

	CStoredProcedure	SP;
	CTDVString			sEmailSubject;
	CTDVString			sEmailText;
	CTDVString			sSubName;
	CTDVString			sAuthorName;
	CTDVString			sSubject;
	int							iAuthorID = 0;
	int							ih2g2ID = 0;
	bool						bSuccess = true;
	
	CTDVString			sFirstNames;
	CTDVString			sLastName;
	CTDVString			sArea;		
	CTDVString			sSiteSuffix;
	CTDVString			sTitle;
	int							iStatus=0;
	int							iTaxonomyNode=0;
	int							iJournal = 0;
	int							iActive = 0;
		
	bool bGotSP = m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	// if failed to create SP or output variables not supplied then return failure
	if (!bGotSP || pbToSend == NULL || psEmailAddress == NULL || psEmailText == NULL)
	{
		return false;
	}
	
	// otherwise call the SP to fetch all the allocations that the sub has
	// not yet been notified of
	// this also updates these allocations status and the subs last notified date
	bSuccess = bSuccess && SP.FetchAndUpdateSubsUnnotifiedAllocations(iSubID);
	
	// see if we have any fields returned
	if (SP.IsEOF())
	{
		// if nothing returned then no email to send
		*pbToSend = false;
	}
	else
	{
		// otherwise need to build the email
		*pbToSend = true;
		
		// set the email address and subject
		bSuccess = bSuccess && SP.GetField("SubEmail", *psEmailAddress);
		bSuccess = bSuccess && SP.GetField("SubName", sSubName);
		
		bSuccess = bSuccess && SP.GetField("FirstNames", sFirstNames);
		bSuccess = bSuccess && SP.GetField("LastName", sLastName);
		bSuccess = bSuccess && SP.GetField("Area", sArea);
		bSuccess = bSuccess && SP.GetField("SiteSuffix", sSiteSuffix);
		bSuccess = bSuccess && SP.GetField("Title", sTitle);

		iStatus = SP.GetIntField("Status");
		iTaxonomyNode = SP.GetIntField("TaxonomyNode");
		iJournal = SP.GetIntField("Journal");
		iActive = SP.GetIntField("Active");

		EscapeAllXML(&sFirstNames);
		EscapeAllXML(&sLastName);
		EscapeAllXML(&sArea);
		EscapeAllXML(&sSiteSuffix);
		EscapeAllXML(&sTitle);

		// build up a string containing the details of the subs allocated batch
		CTDVString	sBatchDetails = "";
		while (bSuccess && !SP.IsEOF())
		{
			bSuccess = bSuccess && SP.GetField("AuthorName", sAuthorName);
			bSuccess = bSuccess && SP.GetField("Subject", sSubject);
			iAuthorID = SP.GetIntField("AuthorID");
			ih2g2ID = SP.GetIntField("h2g2ID");
			sBatchDetails << "A" << ih2g2ID << " '" << sSubject << "' by " << sAuthorName << " (U" << iAuthorID << ")\r\n";
			SP.MoveNext();
		}

		// fetch the template for the email
		bSuccess = bSuccess && SP.FetchEmailText(m_InputContext.GetSiteID(), 	"SubAllocationsEmail", &sEmailText, &sEmailSubject);
		
		// do any appropriate substitutions
		sEmailSubject.Replace("++**sub_name**++", sSubName);
		sEmailText.Replace("++**sub_name**++", sSubName);
		sEmailText.Replace("++**batch_details**++", sBatchDetails);
		
		// set the output variables if they are present
		if (psEmailSubject != NULL)
		{
			*psEmailSubject = sEmailSubject;
		}
		if (psEmailText != NULL)
		{
			*psEmailText = sEmailText;
		}
	}
	
	// now create an XML marked up representation of this email for the XML object
	CTDVString	sXML = "";
	if (*pbToSend)
	{
		CTDVString	sEmailAddress = *psEmailAddress;

		// must escape any XML in these before outputting them
		CXMLObject::EscapeXMLText(&sEmailAddress);
		CXMLObject::EscapeXMLText(&sEmailSubject);
		CXMLObject::EscapeXMLText(&sEmailText);

		// if there is an email to send then represent it in XML		
		sXML << "<EMAIL TYPE='SUB-NOTIFICATION'>";
		sXML << "<EMAIL-ADDRESS>" << sEmailAddress << "</EMAIL-ADDRESS>";

		//get the groups to which this user belongs to 		
		CTDVString sGroupXML;		
		m_InputContext.GetUserGroups(sGroupXML, iSubID);		

		sXML << "<USER>";
			sXML << "<USERID>" << iSubID << "</USERID>";
			sXML << "<USERNAME>" << sSubName << "</USERNAME>";
			sXML << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
			sXML << "<LASTNAME>" << sLastName << "</LASTNAME>";
			sXML << "<AREA>" << sArea << "</AREA>";
			sXML << "<STATUS>" << iStatus << "</STATUS>";
			sXML << "<TAXONOMYNODE>" << iTaxonomyNode << "</TAXONOMYNODE>";
			sXML << "<JOURNAL>" << iJournal << "</JOURNAL>";
			sXML << "<ACTIVE>" << iActive << "</ACTIVE>";
			sXML << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
			sXML << "<TITLE>" << sTitle << "</TITLE>";
			sXML << sGroupXML;
		sXML << "</USER>";

		sXML << "<SUBJECT>" << sEmailSubject << "</SUBJECT>";
		sXML << "<TEXT>" << sEmailText << "</TEXT>";
		sXML << "</EMAIL>";
	}
	else
	{
		// if no data then just have an empty tag
		sXML << "<EMAIL TYPE='SUB-NOTIFICATION'/>";
	}
	// first destroy any existing tree
	delete m_pTree;
	m_pTree = NULL;
	// then create the new internal tree
	bSuccess = bSuccess && CreateFromXMLText(sXML);
	return bSuccess;
}

#endif // _ADMIN_VERSION
