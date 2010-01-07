// XMLTransformer.cpp: implementation of the CXMLTransformer class.
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
#include "RipleyServer.h"
#include "XMLTransformer.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CXMLTransformer::CXMLTransformer(CInputContext& inputContext, COutputContext* pOutputContext) 
	: 
	m_InputContext(inputContext), 
	m_pOutputContext(pOutputContext)
{
	// No further construction
}

CXMLTransformer::~CXMLTransformer()
{

}

/*********************************************************************************

	bool CXMLTransformer::Output(CXMLObject* pXMLObject, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
																			 ,	
	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	01/03/2000
	Inputs:		pWholePage - ptr to the result of the XML builder
	Outputs:	-
	Returns:	true if out is sucessful, false otherwise.
	Purpose:	Takes the result of the XMLBuilder object and outputs it via
				the member variable CGI object.
				
*********************************************************************************/

bool CXMLTransformer::Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
{
	CTDVString StringFromObject;

	TDVASSERT(pWholePage != NULL, "Thou shalt NOT give me some puny NULL CWholePage pointer!");

	pWholePage->AddInside("H2G2","<ERROR>Don't know how to display this page... using base class feedthrough.</ERROR>");

	if (pWholePage->GetAsString(StringFromObject))
	{
		StringFromObject = "<?xml version=\"1.0\"?>" + StringFromObject;
		m_pOutputContext->SendOutput(StringFromObject);
		return true;
	}
	else
	{
		m_pOutputContext->SendOutput("<HTML><HEAD><TITLE>ERROR!!!</TITLE></HEAD><BODY>GetAsString failed on CWholePage inside CXMLTransformer::Output(...)</BODY></HTML>");
		return false;
	}
}