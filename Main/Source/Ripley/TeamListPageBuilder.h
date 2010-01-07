// TeamListPageBuilder.h: interface for the CTeamListPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TEAMLISTPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
#define AFX_TEAMLISTPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
//#include "Club.h"

class CTeamListPageBuilder : public CXMLBuilder
{
public:
	CTeamListPageBuilder(CInputContext& inputContext);
	virtual ~CTeamListPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	bool DisplayTeamList(int iTeamID);
	bool ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);
	
protected:

	CWholePage* m_pPage;
};

#endif // !defined(AFX_TEAMLISTPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)

	