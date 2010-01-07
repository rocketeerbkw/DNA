// ModerationHistoryBuilder.h: interface for the CModerationHistoryBuilder class.
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


#if defined (_ADMIN_VERSION)

#if !defined(AFX_MODERATIONHISTORYBUILDER_H__D2576EB2_1949_11D5_874E_00A024998768__INCLUDED_)
#define AFX_MODERATIONHISTORYBUILDER_H__D2576EB2_1949_11D5_874E_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "User.h"
#include "TDVString.h"

/*
	class CModerationHistoryBuilder

	Author:		Kim Harries
	Created:	15/03/2001
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the article moderation history page.
*/

class CModerationHistoryBuilder : public CXMLBuilder  
{
public:
	CModerationHistoryBuilder(CInputContext& inputContext);
	virtual ~CModerationHistoryBuilder();
	virtual bool Build(CWholePage* pPage);
	

protected:
	CStoredProcedure*	m_pSP;
	int					m_ih2g2ID;
	int					m_iPostID;
	bool				m_bValidID;

	bool CreateHistoryXML(CTDVString* psXML);
	bool ProcessReferenceNumber(const CTDVString& sReference);
};

#endif // !defined(AFX_MODERATIONHISTORYBUILDER_H__D2576EB2_1949_11D5_874E_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
