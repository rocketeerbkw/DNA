// MonthSummary.cpp: implementation of the CMonthSummary class.
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
#include "tdvassert.h"
#include "MonthSummary.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMonthSummary::CMonthSummary(CInputContext& inputContext)
:CXMLObject(inputContext)
{

}

CMonthSummary::~CMonthSummary()
{

}

/*********************************************************************************

	CXMLTree* CMonthSummary::Destroy()

	Author:		Dharmesh Raithatha
	Created:	21/05/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful, null otherwise
	Purpose:	deletes the internal tree from the heap

*********************************************************************************/

bool CMonthSummary::Destroy()
{
	// Call base class functionality
	return CXMLObject::Destroy();
}

/*********************************************************************************

	CXMLTree* CMonthSummary::GetSummaryForMonth()

	Author:		Dharmesh Raithatha
	Created:	21/05/2001
	Inputs:		-
	Outputs:	-
	Returns:	returns true if successful
	Purpose:	Asks the database for the months guide entries.

*********************************************************************************/

bool CMonthSummary::GetSummaryForMonth(int iSiteID)
{

	TDVASSERT(IsEmpty(),"Can't call GetSummaryForMonth if the object isn't empty");
	if (!IsEmpty())
	{
		return false;
	}
	
	CStoredProcedure SP;
	
	
	// cleanup and return null if we can't get the stored procedure object
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to initialise stored procedure in CMonthSummary::GetSummaryForMonth");
		return false;
	}

	CTDVDateTime pDate;
	
	//find out the time of the last posted entry
	if (!SP.CacheGetTimeOfMostRecentGuideEntry(&pDate)) 
	{
		TDVASSERT(false, "CMonthSummary::GetSummaryForMonth found no entries in database");
		return false;
	}
	
	CTDVString cachename="monthSummary-";
	cachename << iSiteID << ".xml";
	CTDVString sXML;
	bool bGotCache = false;
	
	// try to get a cached version and create object from that
	bGotCache = CacheGetItem("monthSummary", cachename, &pDate, &sXML);
	bGotCache = bGotCache && CreateFromCacheText(sXML);
	// if didn't get data from cache then get it from the DB
	// Actually do the fetching of the data
	if (!bGotCache)
	{	
		// Call the stored procedure - returns true if we got results
		if (SP.FetchMonthEntrySummary(iSiteID))
		{
			
			CTDVString xmltext = "";
			xmltext << "<MONTHSUMMARY>";
			
			// Now for each element inside the wrapper
			while (SP.IsEOF() != true)
			{
				
				// Get the subject field value
				CTDVString subject = "";
				SP.GetField("Subject",subject);
				
				//get the date information
				CTDVString sEntryDateAsXML = "";
				CTDVDateTime dtEntryDate = SP.GetDateField("DateCreated");
				dtEntryDate.GetAsXML(sEntryDateAsXML);
				
				// make the XML text safe
				EscapeXMLText(&subject);
				xmltext << "<GUIDEENTRY H2G2ID = \"" << SP.GetIntField("h2g2ID") << "\">";
				xmltext << sEntryDateAsXML;
				xmltext << "<SUBJECT>" << subject << "</SUBJECT></GUIDEENTRY>\n";
				
				SP.MoveNext();
			}
			
			xmltext << "</MONTHSUMMARY>";
			// Now insert this chunk into the monthsummary root
			if (!CreateFromXMLText(xmltext))
			{
				return false;
			}
		}
		
		
		
		CTDVString StringToCache;
		//GetAsString(StringToCache);
		CreateCacheText(&StringToCache);
		CachePutItem("monthSummary", cachename, StringToCache);
	}
	
	return true;
}

