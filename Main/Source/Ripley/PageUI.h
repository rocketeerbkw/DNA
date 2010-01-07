// PageUI.h: interface for the CPageUI class.
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


#if !defined(AFX_PAGEUI_H__FF840103_EEAA_11D3_8A01_00104BF83D2F__INCLUDED_)
#define AFX_PAGEUI_H__FF840103_EEAA_11D3_8A01_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "User.h"
#include "XMLObject.h"

class CPageUI : public CXMLObject  
{
public:
	bool Initialise(CUser* pUser = NULL);
	CPageUI(CInputContext& inputContext);
	virtual ~CPageUI();
	bool SetHomeVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetDontPanicVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetSearchVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetMyHomeVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetRegisterVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetMyDetailsVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetLogoutVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetEditPageVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetRecommendEntryVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetDiscussVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);
	bool SetEntrySubbedVisibility(bool bState, const TDVCHAR* pLinkHint = NULL);

protected:
	bool SetVisibility(const TDVCHAR* pNodeName, bool bState, const TDVCHAR* pLinkHint);
};

#endif // !defined(AFX_PAGEUI_H__FF840103_EEAA_11D3_8A01_00104BF83D2F__INCLUDED_)
