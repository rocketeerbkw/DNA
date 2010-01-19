
#include "stdafx.h"
#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "IDIFDocBuilder.h"
#include "TDVString.h"
#include "XMLBuilder.h"
#include "GuideEntry.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


CIDifDocBuilder::CIDifDocBuilder(CInputContext& inputContext) 
: CXMLBuilder(inputContext),
m_pPage(NULL)
{
}

CIDifDocBuilder::~CIDifDocBuilder()
{
}

bool CIDifDocBuilder::Build(CWholePage* pPage)
{
	// example query strings:
	// IDifDocBuilder?FirstInBatch=55&GetSince=20040505000000&skin=purexml
	// IDifDocBuilder?FirstInBatch=55&skin=purexml
	// xml/IDifDocBuilder?FirstInBatch=55&GetSince=20040505000000 --for the xsl parse version
	m_pPage = pPage;
	if (!InitPage(m_pPage, "IDIFDOCBUILDER", true))
	{
		return false;
	}
	m_pPage->AddInside("H2G2", "<IDIFDOCBUILDER></IDIFDOCBUILDER>");

	bool bSuccess = false;

	//check that the user is a super user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if(pViewingUser == NULL || !pViewingUser->GetIsSuperuser())
	{
		return ErrorMessage("User validation", "Please log in with a valid super-user account");
	}
		
	int iFirstInBatch = 0;
	// get the number of the first entry in the required batch
	if(m_InputContext.ParamExists("FirstInBatch"))
	{
		iFirstInBatch = m_InputContext.GetParamInt("FirstInBatch");
	}

	CDNAIntArray EntryIDList;
	EntryIDList.SetSize(0, 1);

	int iBatchStatus;
	CGuideEntry Entry(m_InputContext);

	CTDVString sDate;
	CTDVDateTime dMoreRecentThan;
	CTDVDateTime* p_dMoreRecentThan = NULL;
	if(m_InputContext.ParamExists("GetSince"))
	{
		m_InputContext.GetParamString("GetSince", sDate);
		dMoreRecentThan.SetFromString(sDate);
		if(!dMoreRecentThan.GetStatus())
		{
			return ErrorMessage("GetSince param validation", "please submit a valid date");
		}
		p_dMoreRecentThan = &dMoreRecentThan;
	}

	bSuccess = Entry.GetCurrentGuideEntryBatchIDs(EntryIDList, iFirstInBatch, iBatchStatus, p_dMoreRecentThan);
	
	
	if(!bSuccess)
	{
		return ErrorMessage("Get batch items", "Failed to retrieve batched entries from DB");
	}

	// ---------------------------------------------
	// add the batch data to XML
	CTDVString sXML;
	sXML << "<BATCH>";
	if (iBatchStatus < 0){ sXML << "<STATUS>NULL</STATUS>"; }
	else
	{
		sXML << "<STATUS>" << iBatchStatus << "</STATUS>";
	}
	
	if (iFirstInBatch < 0){ sXML << "<FIRST>NULL</FIRST>"; }
	else
	{
		sXML << "<FIRST>" << iFirstInBatch << "</FIRST>";
	}
	
	sXML << "</BATCH>";
	m_pPage->AddInside("IDIFDOCBUILDER", sXML);

	int i = 0;
	while (EntryIDList.GetSize() > i)
	{
		bSuccess = bSuccess && DisplayEntryData(EntryIDList.GetAt(i));
		if (!bSuccess)
		{
			return ErrorMessage("Entry Data", "Failed to build entry data");
		}
		i++;
	}
	return true;

}



bool CIDifDocBuilder::DisplayEntryData(int iEntryH2G2ID)
{
	CGuideEntry Entry(m_InputContext);
	bool bSuccess = Entry.Initialise(iEntryH2G2ID, m_InputContext.GetSiteID(), NULL, true, false, false, false);
	if(!bSuccess){
		return bSuccess;
	}


	CTDVString sSiteName;
	m_InputContext.GetNameOfSite(Entry.GetSiteID(), &sSiteName);
	CTDVString sSiteNameXML;
	sSiteNameXML << "<NAME>" << sSiteName << "</NAME>";
	bSuccess = bSuccess && Entry.AddInside("SITE", sSiteNameXML);

	m_pPage->AddInside("IDIFDOCBUILDER", &Entry);
	
	// DEBUG --
	//CTDVString sResult;
	//sResult.EnsureAvailable(50000);
	//m_pPage->GetAsString(sResult);

	// DEBUG

	return bSuccess;
}


bool CIDifDocBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{
	InitPage(m_pPage, "IDIFDOCBUILDER", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	return true;
}