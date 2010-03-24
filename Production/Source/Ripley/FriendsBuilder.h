// FriendsBuilder.h: interface for the CFriendsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_FRIENDSBUILDER_H__CF933F00_27BF_4A93_8DEE_5FB235299BA6__INCLUDED_)
#define AFX_FRIENDSBUILDER_H__CF933F00_27BF_4A93_8DEE_5FB235299BA6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CFriendsBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CFriendsBuilder(CInputContext& inputContext);
	virtual ~CFriendsBuilder();

};

#endif // !defined(AFX_FRIENDSBUILDER_H__CF933F00_27BF_4A93_8DEE_5FB235299BA6__INCLUDED_)
