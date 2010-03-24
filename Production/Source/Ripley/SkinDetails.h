// SkinDetails.h: interface for the CSkinDetails class.
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


#if !defined(AFX_SKINDETAILS_H__40BE6EF1_D2AD_42AF_8277_BEECB06449E4__INCLUDED_)
#define AFX_SKINDETAILS_H__40BE6EF1_D2AD_42AF_8277_BEECB06449E4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CSkinDetails  
{
public:
	bool GetUseFrames();
	CSkinDetails(const TDVCHAR* pName, const TDVCHAR* pDescription, bool bUseFrames);
	CSkinDetails(const CSkinDetails& other);
	CSkinDetails();
	virtual ~CSkinDetails();
	bool GetDescription(CTDVString* oDescription);
	bool GetName(CTDVString* oName);
   
protected:
	CTDVString	m_SkinName;
	CTDVString	m_Description;
	bool		m_bUseFrames;

};

#endif // !defined(AFX_SKINDETAILS_H__40BE6EF1_D2AD_42AF_8277_BEECB06449E4__INCLUDED_)
