#include "stdafx.h"
#include "TDVAssert.h"
#include "ProfanityGroup.h"
#include "StoredProcedure.h"

/*********************************************************************************
CProfanityGroup::CProfanityGroup(CInputContext& inputContext)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CProfanityGroup::CProfanityGroup(CInputContext& inputContext) :
	CXMLError(),
	m_InputContext(inputContext),
	m_cBasicSiteList(inputContext, "PROFANITYGROUP"),
	m_iId(0),
	m_bShowList(false)
{
	Clear();
}


/*********************************************************************************
CProfanityGroup::~CProfanityGroup()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CProfanityGroup::~CProfanityGroup()
{
}


/*********************************************************************************
void CProfanityGroup::Clear()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	-
Purpose:	Clears or zeros all internal variables
*********************************************************************************/

void CProfanityGroup::Clear()
{
	m_iId = 0;
	m_sName.Empty();
}


/*********************************************************************************
bool CProfanityGroup::Populate(const int iGroupId)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		iGroupId - ID of group
Outputs:	-
Returns:	false on DB errors, true otherwise
Purpose:	Fetches information from DB to populate object.
*********************************************************************************/

bool CProfanityGroup::Populate(const int iGroupId)
{
	CTDVString sGroupName;

	// iGroupId of 0 is a special case = global filter
	//
	if (iGroupId == 0)
	{
		sGroupName = "Global";
	}
	else
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		if (!SP.GetProfanityGroupInfo(iGroupId))
		{
			SetDNALastError("ProfanityAdmin","DATABASE","Failure inside SP.GetProfanityGroupInfo");
			return false;
		}

		if (!SP.GetIntField("GroupId"))
		{
			SetDNALastError("ProfanityAdmin","INPUTPARAMS","Couldn't find that group in the database");
			return false;
		}
		SP.GetField("GroupName", sGroupName);
	}

	SetId(iGroupId);
	SetName(sGroupName);
	return PopulateList(iGroupId);
}


/*********************************************************************************
bool CProfanityGroup::PopulateList(const int iGroupId)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		iGroupId - numeric ID of group
Outputs:	-
Returns:	true on success
Purpose:	Fetches group info and all relevant sites and stores them internally
*********************************************************************************/

bool CProfanityGroup::PopulateList(const int iGroupId)
{
	m_cBasicSiteList.Clear();

	// Make sure that GetAsXML() will include the BASICSITELIST tag
	//
	m_bShowList = true;

	// Get site list and group info from DB
	//
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetProfanityGroupList(iGroupId))
	{
		SetDNALastError("ProfanityAdmin","DATABASE","An Error Occurred while accessing the database");
		return false;
	}

	// For each row, create a Profanity object and add it to the list
	//
	while(!SP.IsEOF())
	{
		CTDVString sSiteName;
		SP.GetField("ShortName", sSiteName);

		m_cBasicSiteList.AddSite( SP.GetIntField("SiteID"), sSiteName );

		SP.MoveNext();
	}

	return true;
}


/*********************************************************************************
CTDVString CProfanityGroup::GetAsXML()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	XML string of entire object
Purpose:	Builds the entire XML structure for this object and returns it as a string
*********************************************************************************/

CTDVString CProfanityGroup::GetAsXML()
{
	CTDVString sXML;

	sXML << "<PROFANITYGROUP>";
	sXML << "<ID>" << m_iId << "</ID>";
	sXML << "<NAME>" << m_sName << "</NAME>";

	if (m_bShowList)
	{
		sXML << m_cBasicSiteList.GetAsXML();
	}

	sXML << "</PROFANITYGROUP>";

	return sXML;
}

CProfanityGroup& CProfanityGroup::operator=(const CProfanityGroup& group)
{
	m_iId = group.m_iId;
	m_sName = group.m_sName;
	m_bShowList = group.m_bShowList;
	m_cBasicSiteList = group.m_cBasicSiteList;

	return *this;
}
