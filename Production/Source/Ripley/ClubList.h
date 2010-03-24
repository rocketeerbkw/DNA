// ClubList.h: interface for the CClubList class.
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

#if !defined(AFX_CLUBLIST_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_)
#define AFX_CLUBLIST_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

//#include "User.h"
#include "XMLObject.h"
class CInputContext;


class CClubList : public CXMLObject  
{
public:
	CClubList(CInputContext& inputContext);
	virtual ~CClubList();

public:
	bool ListClubs(int iSiteID, bool bOrderByLastUpdated, int iSkip=0, int iShow=20);
};

	
#endif // !defined(AFX_CLUBLIST_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_)
