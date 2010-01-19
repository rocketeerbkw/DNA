// SubAllocationForm.cpp: implementation of the CSubAllocationForm class.
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
#include "SubAllocationForm.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "UserList.h"
#include "ArticleList.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSubAllocationForm::CSubAllocationForm(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
	// no further construction required
}

CSubAllocationForm::~CSubAllocationForm()
{
	// no further destruction required
}

/*********************************************************************************

	bool CSubAllocationForm::Initialise()

	Author:		Kim Harries
	Created:	22/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Initialises the base XML for the form, overwriting any existing
				XML that is currently stored.

*********************************************************************************/

bool CSubAllocationForm::Initialise()
{
	// if there is a tree then delete it and start again
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// create an empty form
	return CreateFromXMLText("<SUB-ALLOCATION-FORM/>");
}

/*********************************************************************************

	bool CSubAllocationForm::SubmitAllocation(int iSubID, int iAllocatorID, const TDVCHAR* pComments, int* piEntryIDs, int iTotalEntries)

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		iSubID - ID of the sub editor whom the entries are to be allocated to
				iAllocatorID - ID of the user doing the allocating
				pComments - set of comments to be applied to all allocations. If NULL
					then comments will be left unchanged
				piEntryIDs - a pointer to an array of integers containing the entry
					IDs of the entries to be allocated
				iTotalEntrys - the total number of entries in the array
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Submits the given allocation for this sub editor, and if appropriate
				creates any XML that is required in the form object, e.g. error
				reports etc.

*********************************************************************************/

bool CSubAllocationForm::SubmitAllocation(int iSubID, int iAllocatorID, const TDVCHAR* pComments, int* piEntryIDs, int iTotalEntries)
{
	TDVASSERT(piEntryIDs != NULL, "NULL entry ID array in CSubAllocationForm::SubmitAllocation(...)");

	// if no array supplied then must fail
	if (piEntryIDs == NULL)
	{
		return false;
	}

	CStoredProcedure	SP;
	bool				bSuccess = true;

	// check that SP was created okay
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		bSuccess = false;
		TDVASSERT(false, "failed to create SP in CSubAllocationForm::SubmitAllocation(...)");
		return false;
	}
	// if this object not yet initialised then do so now
	if (IsEmpty() || !DoesTagExist("SUB-ALLOCATION-FORM"))
	{
		bSuccess = bSuccess && Initialise();
	}
	// now call the appropriate method
	bSuccess = bSuccess && SP.AllocateEntriesToSub(iSubID, iAllocatorID, pComments, piEntryIDs, iTotalEntries);
	// check the results returned
	if (bSuccess)
	{
		int				iTotalSuccessful = 0;
		int				iTotalFailed = 0;
		int				ih2g2ID = 0;
		int				iUserID = 0;
		int				iStatus = 0;
		CTDVDateTime	dtDateAllocated;
		CTDVString		sDateAllocated;
		CTDVString		sUsername;
		CTDVString		sSubject;
		CTDVString		sXML;

		// add the base elements for successful and failed allocations reports
		bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<SUCCESSFUL-ALLOCATIONS/>");
		bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<FAILED-ALLOCATIONS/>");
		// check all the user ids returned - if any aren't the sub we tried
		// to allocate to then the allocation failed, so add some XML to
		// indicate this
		while (!SP.IsEOF() && bSuccess)
		{
			iUserID = SP.GetIntField("SubEditorID");
			// user IDs don't match so add error report
			if (iUserID != iSubID)
			{
				// increment total failed counter
				iTotalFailed++;
				// get the rest of the details about the allocation
				ih2g2ID = SP.GetIntField("h2g2ID");
				dtDateAllocated = SP.GetDateField("DateAllocated");
				dtDateAllocated.GetAsXML(sDateAllocated, true);
				iStatus = SP.GetIntField("Status");
				if (!SP.GetField("Username", sUsername))
				{
					sUsername = "Researcher ";
					sUsername << iUserID;
				}
				SP.GetField("Subject", sSubject);
				// create some XML to go into the form
				sXML = "<ALLOCATION>";
				sXML << "<H2G2-ID>" << ih2g2ID << "</H2G2-ID>";
				sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
				sXML << "<USER>";
				sXML << "<USERID>" << iUserID << "</USERID>";
				sXML << "<USERNAME>" << sUsername << "</USERNAME>";
				sXML << "</USER>";
				sXML << "<STATUS>" << iStatus << "</STATUS>";
				sXML << "<DATE-ALLOCATED>" << sDateAllocated << "</DATE-ALLOCATED>";
				sXML << "</ALLOCATION>";
				// now insert this XML inside the form
				bSuccess = bSuccess && AddInside("FAILED-ALLOCATIONS", sXML);
			}
			else
			{
				// otherwise increment the number of successful allocations
				iTotalSuccessful++;
			}
			SP.MoveNext();
		}
		// add XML for the successful and the failed allocations
		CTDVString sTotal = "";
		sTotal << iTotalSuccessful;
		SetAttribute("SUCCESSFUL-ALLOCATIONS", "TOTAL", sTotal);
		sTotal = "";
		sTotal << iTotalFailed;
		SetAttribute("FAILED-ALLOCATIONS", "TOTAL", sTotal);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::SubmitAutoAllocation(int iSubID, int iNumberToAllocate, int iAllocatorID, const TDVCHAR* pComments = NULL, int* piTotalAllocated = NULL)

	Author:		Kim Harries
	Created:	23/11/2000
	Inputs:		iSubID - ID of the sub editor whom the entries are to be allocated to
				iNumberToAllocate - number of entries to allocate
				iAllocatorID - ID of the user doing the allocating
				pComments - set of comments to be applied to all allocations. If NULL
					then comments will be left unchanged
				piTotalAllocated - optional output parameter that will contain the
					actual number of entries that were successfully allocated
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Submits the automatic allocation of the next iNumberToAllocate entries
				from the accepted recommendations queue to this sub editor.

*********************************************************************************/

bool CSubAllocationForm::SubmitAutoAllocation(int iSubID, int iNumberToAllocate, int iAllocatorID, const TDVCHAR* pComments, int* piTotalAllocated)
{
	CStoredProcedure	SP;
	CTDVString			sXML;
	int					iTotalAllocated = 0;
	bool				bSuccess = true;
	// check that SP was created okay
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		bSuccess = false;
		TDVASSERT(false, "failed to create SP in CSubAllocationForm::SubmitAutoAllocation(...)");
		return false;
	}
	// if this object not yet initialised then do so now
	if (IsEmpty() || !DoesTagExist("SUB-ALLOCATION-FORM"))
	{
		bSuccess = bSuccess && Initialise();
	}
	// now call the appropriate method
	bSuccess = bSuccess && SP.AutoAllocateEntriesToSub(iSubID, iNumberToAllocate, iAllocatorID, pComments, &iTotalAllocated);
	// set the output parameter if one provided
	if (piTotalAllocated != NULL)
	{
		*piTotalAllocated = iTotalAllocated;
	}
	// add some XML for the number of successful allocations
	sXML = "<SUCCESSFUL-ALLOCATIONS TOTAL='";
	sXML << iTotalAllocated << "'/>";
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", sXML);
	// add xML for number of failed allocations
	sXML = "<FAILED-ALLOCATIONS TOTAL='";
	sXML << (iNumberToAllocate - iTotalAllocated) << "'/>";
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", sXML);
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::SubmitDeallocation(int iDeallocatorID, int* piEntryIDs, int iTotalEntries, int* piTotalDeallocated)

	Author:		Kim Harries
	Created:	23/11/2000
	Inputs:		iDeallocatorID - user doing the deallocation
				piEntryIDs - ptr to an array of entry IDs to be deallocated
				iTotalEntries - total number of entries in the array
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Deallocates the specified entries from whichever sub editor they
				happen to be allocated to currently, so long as they have not
				already been returned.

*********************************************************************************/

bool CSubAllocationForm::SubmitDeallocation(int iDeallocatorID, int* piEntryIDs, int iTotalEntries, int* piTotalDeallocated)
{
	TDVASSERT(piEntryIDs != NULL, "NULL entry ID array in CSubAllocationForm::SubmitDeallocation(...)");
	// if no array supplied then must fail
	if (piEntryIDs == NULL)
	{
		return false;
	}

	CStoredProcedure SP;
	bool				bSuccess = true;
	// check that SP was created okay
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		bSuccess = false;
		TDVASSERT(false, "failed to create SP in CSubAllocationForm::SubmitDeallocation(...)");
		return false;
	}
	// if this object not yet initialised then do so now
	if (IsEmpty() || !DoesTagExist("SUB-ALLOCATION-FORM"))
	{
		bSuccess = bSuccess && Initialise();
	}
	// now call the appropriate method
	bSuccess = bSuccess && SP.DeallocateEntriesFromSubs(iDeallocatorID, piEntryIDs, iTotalEntries);
	// check the results returned
	if (bSuccess)
	{
		int				iTotalSuccessful = 0;
		int				iTotalFailed = 0;
		int				ih2g2ID = 0;
		int				iSubEditorID = 0;
		int				iStatus = 0;
		CTDVDateTime	dtDateReturned;
		CTDVString		sDateReturned;
		CTDVString		sUsername;
		CTDVString		sSubject;
		CTDVString		sXML;
						
		CTDVString sFirstNames;
		CTDVString sLastName;
		CTDVString sArea;		
		CTDVString sSiteSuffix;
		CTDVString sTitle;
		int iUserStatus=0;
		int iTaxonomyNode=0;
		int iJournal = 0;
		int iActive = 0;					

		// add the base elements for successful and failed deallocations reports
		bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<SUCCESSFUL-DEALLOCATIONS/>");
		bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<FAILED-DEALLOCATIONS/>");
		// check the stauts of the entries returned to see if any couldn't be deallocated
		// because they had already been returned
		while (!SP.IsEOF() && bSuccess)
		{
			iStatus = SP.GetIntField("Status");
			// stauts should now be 1 = 'Accepted' or something went wrong
			if (iStatus != 1)
			{
				// increment total failed counter
				iTotalFailed++;
				// get the rest of the details about the allocation
				ih2g2ID = SP.GetIntField("h2g2ID");
				dtDateReturned = SP.GetDateField("DateReturned");
				dtDateReturned.GetAsXML(sDateReturned, true);
				iSubEditorID = SP.GetIntField("SubEditorID");
				if (!SP.GetField("Username", sUsername))
				{
					sUsername = "Researcher ";
					sUsername << iSubEditorID;
				}
				
				SP.GetField("Subject", sSubject);
				
				//get the extra user tag fields 
				SP.GetField("FirstNames", sFirstNames);
				SP.GetField("LastName", sLastName);
				SP.GetField("Area", sArea);
				SP.GetField("SiteSuffix", sSiteSuffix);
				SP.GetField("Title", sTitle);
				
				iUserStatus = SP.GetIntField("UserStatus");
				iTaxonomyNode = SP.GetIntField("TaxonomyNode");
				iJournal = SP.GetIntField("Journal");
				iActive = SP.GetIntField("Active");
		
				EscapeAllXML(&sFirstNames);
				EscapeAllXML(&sLastName);
				EscapeAllXML(&sArea);
				EscapeAllXML(&sSiteSuffix);
				EscapeAllXML(&sTitle);

				//get the groups to which this user belongs to 		
				CTDVString sGroupXML;		
				m_InputContext.GetUserGroups(sGroupXML, iSubEditorID);		

				// create some XML to go into the form
				sXML = "<DEALLOCATION>";
				sXML << "<H2G2-ID>" << ih2g2ID << "</H2G2-ID>";
				sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
				
				//build user tag
				sXML << "<USER>";
					sXML << "<USERID>" << iSubEditorID << "</USERID>";
					sXML << "<USERNAME>" << sUsername << "</USERNAME>";
					sXML << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
					sXML << "<LASTNAME>" << sLastName << "</LASTNAME>";
					sXML << "<AREA>" << sArea << "</AREA>";
					sXML << "<STATUS>" << iUserStatus << "</STATUS>";
					sXML << "<TAXONOMYNODE>" << iTaxonomyNode << "</TAXONOMYNODE>";
					sXML << "<ACTIVE>" << iActive << "</ACTIVE>";
					sXML << "<JOURNAL>" << iJournal << "</JOURNAL>";
					sXML << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
					sXML << "<TITLE>" << sTitle << "</TITLE>";
					sXML << sGroupXML;
				sXML << "</USER>";

				sXML << "<STATUS>" << iStatus << "</STATUS>";
				sXML << "<DATE-RETURNED>" << sDateReturned << "</DATE-RETURNED>";
				sXML << "</DEALLOCATION>";
				// now insert this XML inside the form
				bSuccess = bSuccess && AddInside("FAILED-DEALLOCATIONS", sXML);
			}
			else
			{
				// otherwise increment the number of successful allocations
				iTotalSuccessful++;
			}
			SP.MoveNext();
		}
		// add XML for the successful and the failed allocations
		CTDVString sTotal = "";
		sTotal << iTotalSuccessful;
		SetAttribute("SUCCESSFUL-DEALLOCATIONS", "TOTAL", sTotal);
		sTotal = "";
		sTotal << iTotalFailed;
		SetAttribute("FAILED-DEALLOCATIONS", "TOTAL", sTotal);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::AddErrorMessage(const TDVCHAR* pErrorType, const TDVCHAR* pErrorText = NULL)

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		pErrorType - the string value to put in the type attribute of the
					error XML
				pErrorText - optional text to place inside the error tag, giving
					further information on the error
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Adds XML specifying a particular error type to the form object.

*********************************************************************************/

bool CSubAllocationForm::AddErrorMessage(const TDVCHAR* pErrorType, const TDVCHAR* pErrorText)
{
	bool	bSuccess = true;
	// if this object not yet initialised then do so now
	if (IsEmpty() || !DoesTagExist("SUB-ALLOCATION-FORM"))
	{
		bSuccess = bSuccess && Initialise();
	}
	// build the XML for the error tag
	CTDVString	sXML = "<ERROR TYPE='";
	sXML << pErrorType << "'>";
	sXML << pErrorText << "</ERROR>";
	// now add our error message inside the form
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", sXML);
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::InsertSubEditorList()

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Gets the list of sub editors and their details and inserts the
				XML representation into this form object.

*********************************************************************************/

bool CSubAllocationForm::InsertSubEditorList()
{
	CUserList	Subs(m_InputContext);
	bool		bSuccess = true;
	// create the subs list
	bSuccess = bSuccess && Subs.CreateSubEditorsList();
	// create an element to place the subs inside
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<SUB-EDITORS></SUB-EDITORS>");
	// then insert the user list
	bSuccess = bSuccess && AddInside("SUB-EDITORS", &Subs);
	// now delete the temporary object and return success value
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::InsertAcceptedRecommendationsList()

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Gets the list of accepted scout recommendations that have not yet
				been allocated, and inserts its XML representation into this form.

*********************************************************************************/

bool CSubAllocationForm::InsertAcceptedRecommendationsList()
{
	CArticleList	RecommendedArticles(m_InputContext);
	bool			bSuccess = true;
	// create the subs list
	bSuccess = bSuccess && RecommendedArticles.CreateUnallocatedRecommendationsList();
	// create an element inside the form to put the articles inside
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<UNALLOCATED-RECOMMENDATIONS></UNALLOCATED-RECOMMENDATIONS>");
	// insert the article list
	bSuccess = bSuccess && AddInside("UNALLOCATED-RECOMMENDATIONS", &RecommendedArticles);
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::InsertAllocatedRecommendationsList()

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Gets the list of allocated scout recommendations that have not yet
				been returned, and inserts its XML representation into this form.

*********************************************************************************/

bool CSubAllocationForm::InsertAllocatedRecommendationsList(int iShow, int iSkip)
{
	CArticleList	AllocatedArticles(m_InputContext);
	bool			bSuccess = true;
	// create the subs list
	bSuccess = bSuccess && AllocatedArticles.CreateAllocatedRecommendationsList(iShow, iSkip);
	// create an element inside the form to put the articles inside
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", "<ALLOCATED-RECOMMENDATIONS/>");
	// insert the article list
	bSuccess = bSuccess && AddInside("ALLOCATED-RECOMMENDATIONS", &AllocatedArticles);
	
	return bSuccess;
}

/*********************************************************************************

	bool CSubAllocationForm::InsertNotificationStatus()

	Author:		Kim Harries
	Created:	05/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Inserts the total number of subs who have not yet been notified of
				their most recent batch of allocations.

*********************************************************************************/

bool CSubAllocationForm::InsertNotificationStatus()
{
	CStoredProcedure	SP;
	CTDVString			sXML = "";
	int					iNumberUnnotified = 0;
	bool				bSuccess = true;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
	bSuccess = bSuccess && SP.FetchSubNotificationStatus(&iNumberUnnotified);
	sXML << "<UNNOTIFIED-SUBS>" << iNumberUnnotified << "</UNNOTIFIED-SUBS>";
	bSuccess = bSuccess && AddInside("SUB-ALLOCATION-FORM", sXML);
	return bSuccess;
}

#endif // _ADMIN_VERSION
