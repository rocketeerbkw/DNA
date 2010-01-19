// SITEOPTION.h: interface for the CSiteOption class.
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

#if !defined(AFX_SITEOPTION_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
#define AFX_SITEOPTION_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "TDVString.h"

class CSiteOption : public CXMLObject  
{
public:
	CSiteOption();
	virtual ~CSiteOption();

	void Set(int iSiteID, CTDVString& sSection,CTDVString& sName, CTDVString& sValue,int iType, CTDVString& sDescription);

	void		 SetNext(CSiteOption* pNext) { m_pNext = pNext; }
	CSiteOption* GetNext()					 { return m_pNext; }

	void AppendXML(CTDVString& sXML);

	int GetSiteID()				{ return m_iSiteID; }
	CTDVString GetSection()		{ return m_sSection; } 
	CTDVString GetName()		{ return m_sName; }
	CTDVString GetDescription()	{ return m_sDescription; }

	CTDVString GetValue();
	int GetValueInt();
	bool GetValueBool();

	bool IsTypeInt()		{ return m_iType == 0; }
	bool IsTypeBool()		{ return m_iType == 1; }
	bool IsTypeString()		{ return m_iType == 2; }

	void ParseValue(CTDVString& sValue);

private:
	int			m_iSiteID;
	CTDVString	m_sSection;
	CTDVString	m_sName;
	CTDVString	m_sValue;
	int			m_iType;
	CTDVString	m_sDescription;

	CSiteOption* m_pNext;
};

#endif // !defined(AFX_SITEOPTION_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
