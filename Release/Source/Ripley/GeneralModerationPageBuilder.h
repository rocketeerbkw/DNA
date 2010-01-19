// GeneralModerationPageBuilder.h: interface for the CGeneralModerationPageBuilder class.
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

#if !defined(AFX_GENERALMODERATIONPAGEBUILDER_H__6F32ACA7_0656_11D5_8741_00A024998768__INCLUDED_)
#define AFX_GENERALMODERATIONPAGEBUILDER_H__6F32ACA7_0656_11D5_8741_00A024998768__INCLUDED_

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
#include "RefereeList.h"

/*
	class CGeneralModerationPageBuilder

	Author:		Kim Harries
	Created:	19/02/2001
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the moderation tools home page.
*/

class CGeneralModerationPageBuilder : public CXMLBuilder  
{
public:
	CGeneralModerationPageBuilder(CInputContext& inputContext);
	virtual ~CGeneralModerationPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	CStoredProcedure*	m_pSP;
	CTDVString			m_sCommand;
	CTDVString			m_sURL;
	int					m_iModID;
	CRefereeList m_RefereeList;

	virtual bool BuildTopFrame(CWholePage* pPage);
	virtual bool BuildFormFrame(CWholePage* pPage);
	bool ProcessSubmission(CUser* pViewer);
	bool CreateForm(CUser* pViewer, CTDVString* psFormXML);
};

#endif // !defined(AFX_GENERALMODERATIONPAGEBUILDER_H__6F32ACA7_0656_11D5_8741_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
