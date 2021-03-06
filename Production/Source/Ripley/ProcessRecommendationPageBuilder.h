// ProcessRecommendationPageBuilder.h: interface for the CProcessRecommendationPageBuilder class.
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

#if !defined(AFX_PROCESSRECOMMENDATIONPAGEBUILDER_H__D9710BE6_BF27_11D4_872B_00A024998768__INCLUDED_)
#define AFX_PROCESSRECOMMENDATIONPAGEBUILDER_H__D9710BE6_BF27_11D4_872B_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "ProcessRecommendationForm.h"
#include "TDVString.h"
#include "InputContext.h"
#include "InputContext.h"
#include "WholePage.h"

/*
	class CProcessRecommendationPageBuilder

	Author:		Kim Harries
	Created:	24/11/2000
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the page allowing editors to decide
				whether to accept or reject a particular scout recommendation.

*/

class CProcessRecommendationPageBuilder : public CXMLBuilder  
{
public:
	CProcessRecommendationPageBuilder(CInputContext& inputContext);
	virtual ~CProcessRecommendationPageBuilder();
	virtual bool Build(CWholePage* pPage);
};

#endif // !defined(AFX_PROCESSRECOMMENDATIONPAGEBUILDER_H__D9710BE6_BF27_11D4_872B_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
