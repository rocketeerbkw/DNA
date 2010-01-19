// MorePagesBuilder.h: interface for the CMorePagesBuilder class.
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


#if !defined(AFX_MOREPAGESBUILDER_H__215FBC74_FFE2_11D3_8A36_00104BF83D2F__INCLUDED_)
#define AFX_MOREPAGESBUILDER_H__215FBC74_FFE2_11D3_8A36_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CMorePagesBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	virtual ~CMorePagesBuilder();

public:
	CMorePagesBuilder(CInputContext& inputContext);

protected:
	bool AddArticlesToPage(int iType,CWholePage* pPage,int iUserID, int iNumShow, int iNumSkipped, int iGuideType);
};

#endif // !defined(AFX_MOREPAGESBUILDER_H__215FBC74_FFE2_11D3_8A36_00104BF83D2F__INCLUDED_)
