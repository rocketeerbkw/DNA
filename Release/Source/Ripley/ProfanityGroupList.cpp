#include "stdafx.h"
#include "ProfanityGroupList.h"
#include "tdvassert.h"
#include "StoredProcedure.h"

/*********************************************************************************
CProfanityGroupList::CProfanityGroupList(CInputContext& inputContext)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CProfanityGroupList::CProfanityGroupList(CInputContext& inputContext) :
	CXMLError(),
	m_InputContext(inputContext)
{
	Clear();
}


/*********************************************************************************
CProfanityGroupList::~CProfanityGroupList()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CProfanityGroupList::~CProfanityGroupList()
{
	m_vProfanityGroups.clear();
}


/*********************************************************************************
void CProfanityGroupList::Clear()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	-
Purpose:	Clears or zeros all internal variables
*********************************************************************************/

void CProfanityGroupList::Clear()
{
	m_vProfanityGroups.clear();
}


/*********************************************************************************
bool CProfanityGroupList::PopulateList()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	true on success
Purpose:	Fetches profanity groups from DB and stores them internally
*********************************************************************************/

bool CProfanityGroupList::PopulateList()
{
	// Get site list and group info from DB
	//
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetProfanityGroupList(0)) //TODO - put proper storedproc in here
	{
		SetDNALastError("ProfanityAdmin","Database","An Error Occurred while accessing the database");
		return false;
	}

	//
	// Create groups list
	// Keep track of current groupID and when it changes, close off old group
	//  and create new one
	//
	CTDVString sGroupName;
	int iCurrentGroupId = SP.GetIntField("GroupID"); // From first row
	int iLastGroupId = iCurrentGroupId;

	CProfanityGroup* pNewProfanityGroup = NULL;

	// For each row, create a Profanity object and add it to the list
	//

	while(!SP.IsEOF())
	{
		if (pNewProfanityGroup == NULL) // Start new group
		{
			SP.GetField("GroupName", sGroupName);

			pNewProfanityGroup = new CProfanityGroup(m_InputContext);
			pNewProfanityGroup->SetId( iCurrentGroupId );
			pNewProfanityGroup->SetName( sGroupName );
		}

		// Pass site details down to CProfanityGroup
		//
		int iSiteId = 0;
		CTDVString sSiteName;
		iSiteId = SP.GetIntField("SiteID");
		SP.GetField("ShortName", sSiteName);
		if (iSiteId) // 0 if this profanity group has no sites
		{
			pNewProfanityGroup->AddSite(iSiteId, sSiteName);
		}

		// Fetch next row and compare group id
		//
		SP.MoveNext();
		iCurrentGroupId = SP.GetIntField("GroupID");

		// Check to see if we need to close the current group
		//
		if (iCurrentGroupId != iLastGroupId || SP.IsEOF())
		{
			// Close off group and add it to the list
			//
			m_vProfanityGroups.push_back( *pNewProfanityGroup );
			pNewProfanityGroup = NULL;

			iLastGroupId = iCurrentGroupId;
		}
	}

	return true;
}


/*********************************************************************************
CTDVString CProfanityGroupList::GetAsXML()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	XML string of entire object
Purpose:	Builds the entire XML structure for this object and returns it as a string
*********************************************************************************/

CTDVString CProfanityGroupList::GetAsXML()
{
	CTDVString sXML;

	sXML << "<PROFANITYGROUPLIST>";

	// Loop through profanitygroups and add each to the XML string in turn
	//
	for (std::vector<CProfanityGroup>::iterator current = m_vProfanityGroups.begin(); current != m_vProfanityGroups.end(); current++)
	{
		sXML << current->GetAsXML();
	}

	sXML << "</PROFANITYGROUPLIST>";

	return sXML;
}
