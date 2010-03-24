// ClubListPageBuilder.h: interface for the CClubListPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CLUBLISTPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
#define AFX_CLUBLISTPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
//#include "Club.h"

class CClubListPageBuilder : public CXMLBuilder
{
public:
	CClubListPageBuilder(CInputContext& inputContext);
	virtual ~CClubListPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	//CWholePage* DisplayClubList();
	bool ErrorMessage(CWholePage* pPage, const TDVCHAR* sType, const TDVCHAR* sMsg);
	bool DisplayClubList(CWholePage* pPage);
	
};

#endif // !defined(AFX_CLUBLISTPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)

	