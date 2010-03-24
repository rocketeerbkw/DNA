#include "stdafx.h"
#include "Profanity.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

// Mechanism for proving number-independent ratings to XML
//
const CTDVString CProfanity::ratingToString[] = {"", "premod", "postmod", "replace", "reedit"};
const int CProfanity::iMaxRating = 4;

/*********************************************************************************
CProfanity::CProfanity()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CProfanity::CProfanity(CInputContext& inputContext) :
	m_InputContext(inputContext),
	m_iId(0),
	m_iRating(0),
	m_iSiteId(0),
	m_iGroupId(0),
	m_bGroupAndSiteSet(false)
{
	Clear();
}


/*********************************************************************************
CProfanity::~CProfanity()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CProfanity::~CProfanity()
{
}


/*********************************************************************************
void CProfanity::Clear()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	-
Purpose:	Clears or zeros all internal variables
*********************************************************************************/

void CProfanity::Clear()
{
	m_iId = 0;
	m_iRating = 0;
	m_sName.Empty();
	m_sReplacement.Empty();
}


/*********************************************************************************
bool CProfanity::Populate(const int iProfanityId)
Author:		David van Zijl
Created:	24/08/2004
Inputs:		iProfanityId - ID of profanity
Outputs:	-
Returns:	true on success
Purpose:	Populates internal fields from DB for a given ID
*********************************************************************************/

bool CProfanity::Populate(const int iProfanityId)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetProfanityInfo(iProfanityId))
	{
		SetDNALastError("CProfanity","Database","An Error Occurred while accessing the database");
		return false;
	}

	m_iId	   = SP.GetIntField("ProfanityId");
	m_iRating  = SP.GetIntField("Rating");
	m_bGroupAndSiteSet = true;
	m_iGroupId = SP.GetIntField("GroupId");
	m_iSiteId  = SP.GetIntField("SiteId");

	bool bOk = true;
	if (m_iId == 0 || m_iRating == 0)
	{
		// An error must have occurred
		//
		bOk = false;
	}

	bOk = bOk && SP.GetField("Profanity", m_sName);
	bOk = bOk && SP.GetField("ProfanityReplacement", m_sReplacement);

	return bOk;
}


/*********************************************************************************
CTDVString CProfanity::GetAsXML()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	XML string of entire object
Purpose:	Builds the entire XML structure for this object and returns it as a string
*********************************************************************************/

CTDVString CProfanity::GetAsXML()
{
	CTDVString sProfanityRating;
	if (!GetRatingAsString(m_iRating, sProfanityRating))
	{
		TDVASSERT(false, "CProfanity::Build - Bad or unknown numeric profanity rating");
		return false;
	}

	CTDVString sXML;
	sXML << "<PROFANITY ACTION=\"" << sProfanityRating << "\">";
	sXML << "<ID>" << m_iId << "</ID>";
	sXML << "<NAME>" << m_sName << "</NAME>";

	if (!m_sReplacement.IsEmpty())
	{
		sXML << "<REPLACEMENT>" << m_sReplacement << "</REPLACEMENT>";
	}

	if (m_bGroupAndSiteSet) // Some instances might not have this info
	{
		if (m_iSiteId != 0)
		{
			sXML << "<IMPOSED_BY_SITE>" << m_iSiteId << "</IMPOSED_BY_SITE>";
		}
		else if (m_iGroupId != 0)
		{
			sXML << "<IMPOSED_BY_GROUP>" << m_iGroupId << "</IMPSOED_BY_GROUP>";
		}
		else
		{
			// Global
			//
			sXML << "<IMPOSED_BY_GLOBAL>0</IMPOSED_BY_GLOBAL>";
		}
	}

	sXML << "</PROFANITY>";

	return sXML;
}


/*********************************************************************************
bool CProfanity::GetRatingAsString(const int iRating, CTDVString& sRating)
Author:		David van Zijl
Created:	23/08/2004
Inputs:		iRating - Rating from 1 to iMaxRating
Outputs:	sRating - String version of the numeric profanity rating
Returns:	true on success
Purpose:	Returns the human-readable version of the numeric profanity rating
*********************************************************************************/

bool CProfanity::GetRatingAsString(const int iRating, CTDVString& sRating)
{
	if (iRating > iMaxRating || iRating <= 0)
	{
		TDVASSERT(false, "CProfanity::GetRatingAsString - numeric rating out of range");
		return false;
	}
	sRating = ratingToString[iRating];
	return true;
}


/*********************************************************************************
bool CProfanity::GetRatingAsInt(const TDVCHAR* sRating, int& iRating)
Author:		David van Zijl
Created:	23/08/2004
Inputs:		sRating - String version of the numeric profanity rating
Outputs:	iRating - Rating from 1 to iMaxRating
Returns:	true on success
Purpose:	Returns the human-readable version of the numeric profanity rating
*********************************************************************************/

bool CProfanity::GetRatingAsInt(const TDVCHAR* sRating, int& iRating)
{
	for (int i = 1; i <= iMaxRating; i++)
	{
		if (!strcmp(sRating, ratingToString[i]))
		{
			iRating = i;
			return true;
		}
	}
	TDVASSERT(false, "CProfanity::GetRatingAsInt - unrecognised string rating");
	return false;
}

CProfanity& CProfanity::operator=(const CProfanity& profanity)
{
	m_iId = profanity.m_iId;
	m_iRating = profanity.m_iRating;
	m_iGroupId = profanity.m_iGroupId;
	m_iSiteId = profanity.m_iSiteId;
	m_sName = profanity.m_sName;
	m_sReplacement = profanity.m_sReplacement;
	m_bGroupAndSiteSet = profanity.m_bGroupAndSiteSet;

	return *this;
}
