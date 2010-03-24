// SubbedArticlesPageBuilder.cpp: implementation of the CSubbedArticlesPageBuilder class.
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


#include "stdafx.h"
#include "SubbedArticlesPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "ArticleList.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

/*********************************************************************************

	CSubbedArticlesPageBuilder::CSubbedArticlesPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	04/12/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CSubbedArticlesPageBuilder object.

*********************************************************************************/

CSubbedArticlesPageBuilder::CSubbedArticlesPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	// no further construction required
}

/*********************************************************************************

	CSubbedArticlesPageBuilder::~CSubbedArticlesPageBuilder()

	Author:		Kim Harries
	Created:	04/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CSubbedArticlesPageBuilder::~CSubbedArticlesPageBuilder()
{
	// none
}

/*********************************************************************************

	CWholePage* CSubbedArticlesPageBuilder::Build()

	Author:		Kim Harries
	Created:	04/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the subbed articles page, allowing articles
				which have been subbed and returned to be viewed and selected by
				an editor.

*********************************************************************************/

bool CSubbedArticlesPageBuilder::Build(CWholePage* pPage)
{
	return false;
}

#endif // _ADMIN_VERSION
