// SubNotificationEmail.h: interface for the CSubNotificationEmail class.
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

#if !defined(AFX_SUBNOTIFICATIONEMAIL_H__651CF7E6_C454_11D4_872C_00A024998768__INCLUDED_)
#define AFX_SUBNOTIFICATIONEMAIL_H__651CF7E6_C454_11D4_872C_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "TDVString.h"
#include "InputContext.h"

/*
	class CSubNotificationEmail

	Author:		Kim Harries
	Created:	28/11/2000
	Inherits:	CXMLObject
	Purpose:	Object for extracting the relevant details to create the
				notification of new allocations email for a particular sub
				editor.

*/

class CSubNotificationEmail : public CXMLObject
{
public:
	CSubNotificationEmail(CInputContext& inputContext);
	virtual ~CSubNotificationEmail();
	bool CreateNotificationEmail(int iSubID, bool* bToSend, CTDVString* sEmailAddress, CTDVString* sEmailSubject, CTDVString* sEmailText);
};

#endif // !defined(AFX_SUBNOTIFICATIONEMAIL_H__651CF7E6_C454_11D4_872C_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
