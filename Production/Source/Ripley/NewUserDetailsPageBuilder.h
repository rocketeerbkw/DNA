// UserDetailsPageBuilder.h: interface for the CNewUserDetailsPageBuilder class.
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


#if !defined(AFX_USERDETAILSPAGEBUILDER_H__CF64E239_F5BA_11D3_86FB_00A024998111__INCLUDED_)
#define AFX_USERDETAILSPAGEBUILDER_H__CF64E239_F5BA_11D3_86FB_00A024998111__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "WholePage.h"
#include "User.h"

/*
	class CNewUserDetailsPageBuilder

	Author:		Kim Harries
	Created:	13/03/2000
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for a user details page based on the request info from
				the CGI request, accessed through the given input context. To do
				this it will most likely require access to the database via a
				database context, but in some cases this may not be necessary.

*/

class CNewUserDetailsPageBuilder : public CXMLBuilder  
{
public:
	CNewUserDetailsPageBuilder(CInputContext& inputContext);
	virtual ~CNewUserDetailsPageBuilder();
	virtual bool Build(CWholePage* pPage);
	virtual bool UpdateUserDetails(CUser* pViewer, CTDVString& sErrorMessage, CTDVString& sErrorType);
};

#endif // !defined(AFX_USERDETAILSPAGEBUILDER_H__CF64E239_F5BA_11D3_86FB_00A024998111__INCLUDED_)
