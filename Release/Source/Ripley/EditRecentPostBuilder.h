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


#ifndef _EDITRECENTPOSTBUILDER_H_
#define _EDITRECENTPOSTBUILDER_H_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "InputContext.h"
//#include "DatabaseContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "User.h"
#include "TDVString.h"
#include "ForumPostEditForm.h"

class CEditRecentPostBuilder : public CXMLBuilder  
{
public:
	CEditRecentPostBuilder(CInputContext& inputContext);
	~CEditRecentPostBuilder();
	bool Build(CWholePage* pPage);

private:
	CForumPostEditForm m_ForumPostEditForm;
};

#endif
