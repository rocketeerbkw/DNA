// RefereeList.h: interface for the CRefereeList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_REFEREELIST_H__6A245816_9C69_49BA_B8CB_0E78BBB34B69__INCLUDED_)
#define AFX_REFEREELIST_H__6A245816_9C69_49BA_B8CB_0E78BBB34B69__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CRefereeList : public CXMLObject  
{
public:
	CRefereeList(CInputContext& inputContext);
	virtual ~CRefereeList();
	bool FetchTheList();

};

#endif // !defined(AFX_REFEREELIST_H__6A245816_9C69_49BA_B8CB_0E78BBB34B69__INCLUDED_)
