// TransmissionBuilder.h: interface for the CTransmissionBuilder class.
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


#if !defined(AFX_TRANSMISSIONBUILDER_H__8ECE4A5B_FBFA_11D3_BD73_00A02480D5F4__INCLUDED_)
#define AFX_TRANSMISSIONBUILDER_H__8ECE4A5B_FBFA_11D3_BD73_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"


class CTransmissionBuilder : public CXMLBuilder  
{
public:
	CTransmissionBuilder(CInputContext& inputContext);
	virtual ~CTransmissionBuilder();

	virtual bool Build(CWholePage* pPage);

};

#endif // !defined(AFX_TRANSMISSIONBUILDER_H__8ECE4A5B_FBFA_11D3_BD73_00A02480D5F4__INCLUDED_)
