// RandomArticle.h: interface for the CRandomArticle class.
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


#if !defined(AFX_RANDOMARTICLE_H__651CF7E7_C454_11D4_872C_00A024998768__INCLUDED_)
#define AFX_RANDOMARTICLE_H__651CF7E7_C454_11D4_872C_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "InputContext.h"
#include "StoredProcedure.h"

/*
	class CRandomArticle

	Author:		Kim Harries
	Created:	29/11/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of a randomly selected
				article.

*/

class CRandomArticle : public CXMLObject  
{
public:
	CRandomArticle(CInputContext& inputContext);
	virtual ~CRandomArticle();
	bool CreateRandomAnyEntry();
	bool CreateRandomNormalEntry();
	bool CreateRandomRecommendedEntry();
	bool CreateRandomEditedEntry();
	bool	SetCurrentSite(int iSiteID);
	int Geth2g2ID();

protected:
	CStoredProcedure*	m_pSP;
	int					m_ih2g2ID;
	int					m_iSiteID;

	bool CreateRandomArticleSelection(int iStatus1, int iStatus2 = -1, int iStatus3 = -1, int iStatus4 = -1, int iStatus5 = -1);
};

#endif // !defined(AFX_RANDOMARTICLE_H__651CF7E7_C454_11D4_872C_00A024998768__INCLUDED_)
