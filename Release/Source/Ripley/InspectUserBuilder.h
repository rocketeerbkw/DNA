// InspectUserBuilder.h: interface for the CInspectUserBuilder class.
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

#if !defined(AFX_INSPECTUSERBUILDER_H__3C350A85_22B1_11D5_8752_00A024998768__INCLUDED_)
#define AFX_INSPECTUSERBUILDER_H__3C350A85_22B1_11D5_8752_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "User.h"
#include "ArticleList.h"
#include "TDVString.h"

class CInspectUserBuilder : public CXMLBuilder  
{
public:
	CInspectUserBuilder(CInputContext& inputContext);
	virtual ~CInspectUserBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	CStoredProcedure*	m_pSP;
	CTDVString			m_sCommand;
	CTDVString			m_sErrorXML;
	CTDVString			m_sMessageXML;
	CUser*				m_pViewer;
	CUser				m_User;
	int					m_iUserID;

	bool ProcessSubmission();
	bool CreateForm(CTDVString* psFormXML);
};

#endif // !defined(AFX_INSPECTUSERBUILDER_H__3C350A85_22B1_11D5_8752_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
