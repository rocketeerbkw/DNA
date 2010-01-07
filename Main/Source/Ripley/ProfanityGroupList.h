/******************************************************************************
class:	CProfanityGroupList

This class manages the PROFANITYGROUPLIST xml element. It will be able to generate: 
	- A list of all profanity groups (PROFANITYGROUP)
	  See class CProfanityGroup

Example Usage:
	CProfanityGroupList profanityGroupList(inputContext);
	profanityGroupList.GenerateList;
	CTDVString sXML;
	profanityGroupList.GetAsXML(sXML);

Implementation details:
	- Contains a vector of CProfanityGroup objects which are created when one of the 
	  GenerateList... methods are called. When GetAsXML is called then GetAsXML 
	  is called on each of these and added to the result string.
******************************************************************************/

#ifndef _PROFANITYGROUPLIST_H_INCLUDED_
#define _PROFANITYGROUPLIST_H_INCLUDED_

#include <vector>
#include "TDVString.h"
#include "XMLError.h"
#include "ProfanityGroup.h"

class CProfanityGroupList : public CXMLError
{
public:
	CProfanityGroupList(CInputContext& inputContext);
	~CProfanityGroupList();

	void Clear();
	bool PopulateList();

	CTDVString GetAsXML();

private:
	CInputContext& m_InputContext;
	std::vector<CProfanityGroup> m_vProfanityGroups;
};

#endif
