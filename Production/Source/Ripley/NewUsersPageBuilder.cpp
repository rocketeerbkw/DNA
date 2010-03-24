// NewUsersPageBuilder.cpp: implementation of the CNewUsersPageBuilder class.
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
#include "TDVAssert.h"
#include "TDVString.h"
#include "WholePage.h"
#include "PageUI.h"
#include "UserList.h"
#include "User.h"
#include "NewUsersPageBuilder.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNewUsersPageBuilder::CNewUsersPageBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
	// nothing to see here
}

CNewUsersPageBuilder::~CNewUsersPageBuilder()
{
	// please move on
}

bool CNewUsersPageBuilder::Build(CWholePage* pPage)
{
	const TDVCHAR*	pDefaultUnitType = "week";
	const int		iDefaultUnits = 1;
	CTDVString		sUnitType = pDefaultUnitType;
	int				iTimeUnitsSinceRegistration = iDefaultUnits;
	int				iSkip = 0;
	int				iShow = 20;
	int				iSiteID = 0;
	int				iShowUpdatingUsers	= 0;
	bool			bFilterUsers = false;
	bool			bSuccess = true;
	bool			bSetSite = true;	// Always set the site - don't allow cross-site checking
	
	InitPage(pPage, "NEWUSERS", true);

	CUserList userList(m_InputContext);
	
	// get the number of time units since registration parameter
	if (m_InputContext.ParamExists("TimeUnits"))
	{
		iTimeUnitsSinceRegistration = m_InputContext.GetParamInt("TimeUnits");
	}
	else
	{
		// this can only occur when user comes from another page
		bSetSite = true;
	}

	// get the unit type if any
	if (m_InputContext.ParamExists("UnitType"))
	{
		m_InputContext.GetParamString("UnitType", sUnitType);
		// if not one of this unit type specified then default to showing new users
		// in the last week
		if (!sUnitType.CompareText("minute") &&
			!sUnitType.CompareText("hour") &&
			!sUnitType.CompareText("day") &&
			!sUnitType.CompareText("week") &&
			!sUnitType.CompareText("month"))
		{
			sUnitType = pDefaultUnitType;
			iTimeUnitsSinceRegistration = iDefaultUnits;
		}
	}
	// Now we always search per-site
	iSiteID = m_InputContext.GetSiteID();

	// get the skip and show parameters if any
	if (m_InputContext.ParamExists("Skip"))
	{
		iSkip = m_InputContext.GetParamInt("Skip");
		if (iSkip < 0)
		{
			iSkip = 0;
		}
	}
	if (m_InputContext.ParamExists("Show"))
	{
		iShow = m_InputContext.GetParamInt("Show");
		if (iShow <= 0)
		{
			iShow = 20;
		}
	}

	// create some base XML for the page
	CTDVString sXML = "<NEWUSERS-LISTING";
	sXML << " UNITTYPE='" << sUnitType << "' TIMEUNITS='" << iTimeUnitsSinceRegistration << "'";
	sXML << " SITEID='" << iSiteID << "'";

	// NOTE!!! Please close the XML in any if else statements you add!!!

	// Now check to see which type of list we require
	if (m_InputContext.ParamExists("JoinedUserList"))
	{
		// Close the XML and add it into the page
		sXML << "></NEWUSERS-LISTING>";
		if (!pPage->AddInside("H2G2",sXML))
		{
			TDVASSERT(false,"Failed to create the UserList Page");
			return false;
		}

		// Now get the new user for the site
		if (userList.CreateNewUsersForSite(iSiteID,sUnitType,iTimeUnitsSinceRegistration,iShow,iSkip))
		{
			// Add the object to the page
			bSuccess = pPage->AddInside("NEWUSERS-LISTING",&userList);
		}
		else
		{
			// Add the error to the page
			bSuccess = pPage->AddInside("H2G2",userList.GetLastErrorAsXMLString());
		}
	}
	else
	{
		// Do the default list!
		// check if filter is activated
		CTDVString sFilterType;
		if (m_InputContext.GetParamString("Filter", sFilterType) &&
			!sFilterType.CompareText("off"))
		{
			bFilterUsers = true;
		}

		if (m_InputContext.ParamExists("whoupdatedpersonalspace"))
		{
			iShowUpdatingUsers = m_InputContext.GetParamInt("whoupdatedpersonalspace");
		}

		if (bFilterUsers)
		{
			sXML << " FILTER-USERS='" << bFilterUsers << "'";
			sXML << " FILTER-TYPE='" << sFilterType << "'";
		}

		if(iShowUpdatingUsers != 0)
		{
			sXML << " UPDATINGUSERS='" << iShowUpdatingUsers << "'";
		}
		sXML << "></NEWUSERS-LISTING>";
		// insert this in page
		bSuccess = bSuccess && pPage->AddInside("H2G2", sXML);	
		// now initialise the user list object and create a list of the new users
		bSuccess = bSuccess && userList.CreateNewUsersList(iTimeUnitsSinceRegistration, 
			iShow, iSkip, sUnitType, bFilterUsers, sFilterType, iSiteID, iShowUpdatingUsers);
		// insert our list into the page
		bSuccess = bSuccess && pPage->AddInside("NEWUSERS-LISTING", &userList);

		TDVASSERT(bSuccess, "CNewUsersPageBuilder::Build() failed");
	}
	return bSuccess;
}
