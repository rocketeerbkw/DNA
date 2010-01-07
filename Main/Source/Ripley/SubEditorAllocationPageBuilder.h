// SubEditorAllocationPageBuilder.h: interface for the CSubEditorAllocationPageBuilder class.
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

#if !defined(AFX_SUBEDITORALLOCATIONPAGEBUILDER_H__F875B523_BB05_11D4_872A_00A024998768__INCLUDED_)
#define AFX_SUBEDITORALLOCATIONPAGEBUILDER_H__F875B523_BB05_11D4_872A_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "TDVString.h"
#include "InputContext.h"
#include "InputContext.h"
#include "User.h"
#include "WholePage.h"
#include "SubAllocationForm.h"

/*
	class CSubEditorAllocationPageBuilder

	Author:		Kim Harries
	Created:	15/11/2000
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the page allowing editors to allocate
				recommended entries to a sub editor.

*/

class CSubEditorAllocationPageBuilder : public CXMLBuilder  
{
public:
	CSubEditorAllocationPageBuilder(CInputContext& inputContext);
	virtual ~CSubEditorAllocationPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	bool ProcessAllocationSubmission(CUser* pViewer, const TDVCHAR* pcCommand, CSubAllocationForm& Form);
	bool SendNotificationEmails(CSubAllocationForm& Form, int* piTotalSent = NULL);
};

#endif // !defined(AFX_SUBEDITORALLOCATIONPAGEBUILDER_H__F875B523_BB05_11D4_872A_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
