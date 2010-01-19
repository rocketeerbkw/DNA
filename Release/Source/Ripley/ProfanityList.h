/******************************************************************************
class: CProfanityList

This class manages the PROFANITYLIST xml element. It will be able to generate: 
	- A list of profanities for a site or group (PROFANITY)
	  See class CProfanity

Example Usage:
	CProfanityList profanityList(inputContext);
	profanityList.PopulateListForSite(1);
	CTDVString sXML;
	profanityList.GetAsXML(sXML);

Implementation details:
	- Contains a vector of CProfanity objects which are created when one of the 
	  GenerateList... methods are called. When GetAsXML is called then GetAsXML 
	  is called on each of these and added to the result string.
******************************************************************************/

#ifndef _PROFANITYLIST_H_INCLUDED_
#define _PROFANITYLIST_H_INCLUDED_

#include <vector>
#include "TDVString.h"
#include "XMLObject.h"
#include "Profanity.h"

class CProfanityList : public CXMLObject
{
public:
	CProfanityList(CInputContext& inputContext);
	~CProfanityList();

	/*
	bool PopulateListForSite(const int iSiteId);
	bool PopulateListForGroup(const int iGroupId);
	
	CTDVString GetAsXML();
	*/
	bool GetProfanities(void);

	bool UpdateProfanity(const int iProfanityId, const CTDVString& sProfanity, 
		const int iModClassId, const int iRefer);
	bool DeleteProfanity(const int iProfanityID);
	bool AddProfanity(const CTDVString& sProfanity, const int iModClassID, 
		const int iRefer);

	void CleanUpProfanity(CTDVString& sProfanity);

private:

	/*
	typedef std::vector<CProfanity> PROFANITYLIST;
	bool IntPopulateListForSiteOrGroup(const int iId, const bool bIsSite);
	PROFANITYLIST m_vProfanities;
	*/
};

#endif
