// SiteConfig.h: interface for the CSiteConfig class.
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

#if !defined(AFX_SITECONFIG_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
#define AFX_SITECONFIG_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CInputContext;

class CSiteConfig : public CXMLObject  
{
public:
	CSiteConfig(CInputContext& inputContext);
	virtual ~CSiteConfig();

public:
	virtual bool EditConfig(CInputContext& inputContext);
	virtual bool UpdateConfig(CInputContext& inputContext, bool& bMultiStepReady);

	bool CreateEmptyConfig();

	virtual bool GetSiteConfig(int iSiteID,CTDVString& sSiteConfig);
	virtual bool SetSiteConfig(CStoredProcedure* pSP, int iSiteID, const TDVCHAR* psSiteConfig, const TDVCHAR* psEditKey);

protected:
	virtual bool Initialise();
	virtual bool CreateEditConfig();
	CTDVString MakeUrlNameXML(CStoredProcedure* pSP = NULL,int iSiteID = 0);
};

#endif // !defined(AFX_SITECONFIG_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
