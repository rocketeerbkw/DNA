// MorePostsBuilder.h: interface for the CMorePostsBuilder class.
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


#if !defined(AFX_MOREPOSTSBUILDER_H__68045A41_00CD_11D4_8A39_00104BF83D2F__INCLUDED_)
#define AFX_MOREPOSTSBUILDER_H__68045A41_00CD_11D4_8A39_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CMorePostsBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CMorePostsBuilder(CInputContext& inputContext);
	virtual ~CMorePostsBuilder();

};

#endif // !defined(AFX_MOREPOSTSBUILDER_H__68045A41_00CD_11D4_8A39_00104BF83D2F__INCLUDED_)
