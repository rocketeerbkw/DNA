// InterestList.h: interface for the CInterestList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_INTERESTLIST_H__FF8D7244_0424_48B9_9583_B04CF73D2303__INCLUDED_)
#define AFX_INTERESTLIST_H__FF8D7244_0424_48B9_9583_B04CF73D2303__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CInterestList : public CXMLObject  
{
public:
	bool Initialise(int iUserID);
	CInterestList(CInputContext& inputContext);
	virtual ~CInterestList();

};

#endif // !defined(AFX_INTERESTLIST_H__FF8D7244_0424_48B9_9583_B04CF73D2303__INCLUDED_)
