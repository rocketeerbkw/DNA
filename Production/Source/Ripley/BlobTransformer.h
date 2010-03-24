// BlobTransformer.h: interface for the CBlobTransformer class.
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


#if !defined(AFX_BLOBTRANSFORMER_H__56808DB1_FA66_11D3_BD70_00A02480D5F4__INCLUDED_)
#define AFX_BLOBTRANSFORMER_H__56808DB1_FA66_11D3_BD70_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLTransformer.h"

/*
	class CBlobTransformer

	Author:		Oscar Gillespie
	Created:	15/03/2000
	Inherits:	CXMLTransformer
	Purpose:	Subclass of CXMLTransformer which takes the blob information
				and draws the corresponding picture on the clients screen
				(actually squirts the picture information to the http context)
*/

class CBlobTransformer : public CXMLTransformer  
{
public:
	CBlobTransformer(CInputContext& inputContext, COutputContext* pOutputContext);
	virtual ~CBlobTransformer();

	virtual bool Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName);
};

#endif // !defined(AFX_BLOBTRANSFORMER_H__56808DB1_FA66_11D3_BD70_00A02480D5F4__INCLUDED_)
