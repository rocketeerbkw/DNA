// TestArticleXML.h: interface for the CTestArticleXML class.
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


#if !defined(AFX_TESTARTICLEXML_H__AC815DB6_E93D_11D3_86F8_00A024998768__INCLUDED_)
#define AFX_TESTARTICLEXML_H__AC815DB6_E93D_11D3_86F8_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

/*
	class CTestArticleXML

	Author:		Kim Harries
	Created:	22/02/2000
	Inherits:	CXMLObject
	Purpose:	A representation of the XML associated with an article.
				The initialise method should query the database or cache as
				appropriate to get the data for the specific article ID.

*/

class CTestArticleXML : public CXMLObject  
{
public:
	CTestArticleXML(CInputContext& inputContext);
	virtual ~CTestArticleXML();
	bool Initialise(int h2g2ID);
};

#endif // !defined(AFX_TESTARTICLEXML_H__AC815DB6_E93D_11D3_86F8_00A024998768__INCLUDED_)
