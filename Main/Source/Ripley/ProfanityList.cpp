#include "stdafx.h"
#include "ProfanityList.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "dbxmlbuilder.h"
#include "profanityfilter.h"

/*********************************************************************************
CProfanityList::CProfanityList(CInputContext& inputContext)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CProfanityList::CProfanityList(CInputContext& inputContext) :
	CXMLObject(inputContext)
{

}


/*********************************************************************************
CProfanityList::~CProfanityList()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CProfanityList::~CProfanityList()
{
	//m_vProfanities.clear();
}


/*********************************************************************************
bool CProfanityList::PopulateListForSite(const int iSiteId)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		iSiteId - Site to fetch profanities for
Outputs:	-
Returns:	true on success
Purpose:	Populates list of profanities relevant to this site. This will include
			global profanities as well as the ones for the group this site
			belongs to
*********************************************************************************/
/*
bool CProfanityList::PopulateListForSite(const int iSiteId)
{
	return IntPopulateListForSiteOrGroup(iSiteId, true);
}
*/


/*********************************************************************************
bool CProfanityList::PopulateListForGroup(const int iGroupId)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		iGroupId - Group to fetch profanities for
Outputs:	-
Returns:	true on success
Purpose:	Populates list of profanities for this group only
*********************************************************************************/

/*
bool CProfanityList::PopulateListForGroup(const int iGroupId)
{
	return IntPopulateListForSiteOrGroup(iGroupId, false);
}
*/


/*********************************************************************************
bool CProfanityList::IntPopulateListForSiteOrGroup(const int iId, const bool bIsSite)
Author:		David van Zijl
Created:	29/07/2004
Visibility:	private
Inputs:		iId - numeric ID of group or site
			bIsSite - true if you iId refers to a SiteId, false if iGroupId
Outputs:	-
Returns:	true on success
Purpose:	Fetches a list of profanities for either a site or group. They are 
			stored internally (extract with GetAsXML)
*********************************************************************************/
/*
bool CProfanityList::IntPopulateListForSiteOrGroup(const int iId, const bool bIsSite)
{
	// Get profanity list from DB
	//
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (bIsSite)
	{
		// Fetching profanities for site
		//
		if (!SP.GetProfanityListForSite(iId))
		{
			SetDNALastError("ProfanityAdmin","Database","An Error Occurred while accessing the database");
			return false;
		}
	}
	else
	{
		// Fetching profanities for group
		//
		if (!SP.GetProfanityListForGroup(iId))
		{
			SetDNALastError("ProfanityAdmin","Database","An Error Occurred while accessing the database");
			return false;
		}
	}

	// For each row, create a Profanity object and add it to the list
	//
	while(!SP.IsEOF())
	{
		CTDVString sProfanity, sProfanityReplacement;
		SP.GetField("Profanity", sProfanity);
		SP.GetField("ProfanityReplacement", sProfanityReplacement);

		CProfanity newProfanity(m_InputContext);
		newProfanity.SetId( SP.GetIntField("ProfanityID") );
		newProfanity.SetName( sProfanity );
		newProfanity.SetRating( SP.GetIntField("Rating") );
		newProfanity.SetReplacement( sProfanityReplacement );
		newProfanity.SetGroupId( SP.GetIntField("GroupID") );
		newProfanity.SetSiteId( SP.GetIntField("SiteID") );
		m_vProfanities.push_back( newProfanity );

		SP.MoveNext();
	}

	return true;
}
*/


/*********************************************************************************
CTDVString CProfanityList::GetAsXML()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	XML string of entire object
Purpose:	Builds the entire XML structure for this object and returns it as a string
*********************************************************************************/
/*
CTDVString CProfanityList::GetAsXML()
{
	CTDVString sXML;

	sXML << "<PROFANITYLIST> COUNT=\"" << int(m_vProfanities.size()) << "\">";

	// Loop through profanities and add each to the XML string in turn
	//
	for (PROFANITYLIST::iterator current = m_vProfanities.begin(); current != m_vProfanities.end(); current++)
	{
		sXML << current->GetAsXML();
	}

	sXML << "</PROFANITYLIST>";

	return sXML;
}
*/

bool CProfanityList::GetProfanities(void)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	SP.GetAllProfanities();
	CTDVString sProfanityXML;
	CDBXMLBuilder profanitiesBuilder;
	profanitiesBuilder.Initialise(&sProfanityXML, &SP);
	profanitiesBuilder.OpenTag("PROFANITY-LISTS");

	int iCurrentModClassID = 1;
	int iModClassID = 1;
	int iCurrentRefer = 0;
	int iRefer = 0;
	CTDVString sProfanityTag;
	CTDVString sProfanity;

	while (!SP.IsEOF())
	{
		profanitiesBuilder.OpenTag("PROFANITY-LIST", true);
		iCurrentModClassID = iModClassID = SP.GetIntField("ModClassID");
		profanitiesBuilder.AddIntAttribute("MODCLASSID", iModClassID, true);
		while (!SP.IsEOF())
		{
			SP.GetField("Profanity", sProfanity);
			EscapeAllXML(&sProfanity);
			sProfanityTag = "<PROFANITY ID='" + CTDVString(SP.GetIntField("ProfanityID")) + "' REFER='" +
				CTDVString(SP.GetIntField("Refer")) + "'>" + sProfanity + "</PROFANITY>";
			sProfanityXML << sProfanityTag;
			SP.MoveNext();
			if (SP.IsEOF())
			{
				break;
			}
			iModClassID = SP.GetIntField("ModClassID");
			if (iModClassID != iCurrentModClassID)
			{
				break;
			}
			
			
		}
		profanitiesBuilder.CloseTag("PROFANITY-LIST");
		//iCurrentModClassID = iModClassID;		
	}
	profanitiesBuilder.CloseTag("PROFANITY-LISTS");

	return CreateFromXMLText(sProfanityXML);
}

bool CProfanityList::UpdateProfanity(const int iProfanityId, const CTDVString& sProfanity, 
									 const int iModClassId, const int iRefer)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sCleanProfanity(sProfanity);
	CleanUpProfanity(sCleanProfanity);

	if (sCleanProfanity.GetLength() > 0)
	{
		return SP.UpdateProfanity(iProfanityId, sCleanProfanity, iModClassId, iRefer);
	}
	else
	{
		return false;
	}
}

bool CProfanityList::DeleteProfanity(const int iProfanityID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	return SP.DeleteProfanity(iProfanityID);
}

bool CProfanityList::AddProfanity(const CTDVString& sProfanity, const int iModClassID, 	const int iRefer)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sCleanProfanity(sProfanity);
	CleanUpProfanity(sCleanProfanity);

	if (sCleanProfanity.GetLength() > 0)
	{
		return SP.AddNewProfanity(sCleanProfanity, iModClassID, iRefer);
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	void CProfanityList::CleanUpProfanity(CTDVString& sProfanity)

		Author:		Mark Neves
		Created:	04/07/2008
		Inputs:		sProfanity = the profanity to clean up
		Outputs:	sProfanity is potentially stripped dodgy characters
		Returns:	-
		Purpose:	Cleans up the profanity string by removing certain characters
					and stripping off leading and trailing spaces

*********************************************************************************/

void CProfanityList::CleanUpProfanity(CTDVString& sProfanity)
{
    sProfanity.MakeLower();

    //Left Trim
    int ltrim = 0;
	for (int i=0;i<sProfanity.GetLength();i++)
	{
		if ( !isspace(sProfanity[i]) && isprint(sProfanity[i]) )
		{
           break;
		}
        ++ltrim;
	}

    sProfanity.RemoveLeftChars(ltrim);

    //Right Trim
    int rtrim = 0;
    for (int i=sProfanity.GetLength()-1; i>=0; i--)
	{
		if ( !isspace(sProfanity[i]) && isprint(sProfanity[i]) )
		{
           break;
		}
        ++rtrim;
	}
    sProfanity = sProfanity.TruncateRight(rtrim);

    
    sProfanity.Replace("\t","");
	sProfanity.Replace("\n","");
    sProfanity.Replace("\r","");
}
