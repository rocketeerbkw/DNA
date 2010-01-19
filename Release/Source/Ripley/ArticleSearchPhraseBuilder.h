//////////////////////////////////////////////////////////////////////
// ArticleSearchPhraseBuilder.h: interface for the CArticleSearchPhraseBuilder class.
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

#if !defined(AFX_ARTICLESEARCHPHRASEBUILDER_H__069C7506_72A1_423b_9C8D_CA54EE46809E__INCLUDED_)
#define AFX_ARTICLESEARCHPHRASEBUILDER_H__069C7506_72A1_423b_9C8D_CA54EE46809E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

/*********************************************************************************
class:	CArticleSearchPhraseBuilder

This class handles the builder for searching key phrases attached to articles

		Author:		Steve Francis
        Created:	16/12/2005
        Inputs:		Input Context
*********************************************************************************/
class CArticleSearchPhraseBuilder :	public CXMLBuilder
{
public:
	CArticleSearchPhraseBuilder(CInputContext& InputContext);
	virtual ~CArticleSearchPhraseBuilder(void);

	virtual bool IsRequestHTMLCacheable();
	virtual CTDVString GetRequestHTMLCacheFolderName();
	virtual CTDVString GetRequestHTMLCacheFileName();

	bool Build( CWholePage* pPage);
};
#endif // !defined(AFX_ARTICLESEARCHPHRASEBUILDER_H__069C7506_72A1_423b_9C8D_CA54EE46809E__INCLUDED_)
