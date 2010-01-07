/******************************************************************************
class:	CSite

This class manages the SITE xml element. It will be able to generate: 
	- Itself only, no sub-elements

Example usage:
	CSite site;
	site.SetId(1);
	site.SetName("H2G2");
	AddInside("SOMETAG", site.GetAsXML());

	site.Clear();
	// continue, continue

Design decisions:
	- This class doesn't actually run any stored procedures itself, so it doesn't
	  have a method to pass a reference to one in and let it extract the values 
	  itself. Instead the values are passed in by the object that did run the SP.
	- I've added as few accessor methods as I could to keep it simple, just add 
	  them as you need them
******************************************************************************/

#ifndef _SITE_H_INCLUDED_
#define _SITE_H_INCLUDED_

#include "TDVString.h"

class CSite
{
public:
	CSite();
	~CSite();

	void Clear();

	void SetId(const int iId);
	void SetName(const CTDVString& sName);
	void SetDescription( const CTDVString& sDescription);
	void SetModerationClass(int modclass);
	void SetUrlName(const CTDVString& sUrlName);
	
	int			GetId();
	CTDVString	GetName()				{ return m_sName; } 
	int			GetModerationClassId()	{ return m_iModerationClass; }
	CTDVString  GetUrlName()			{ return m_sUrlName; }


	CTDVString GetAsXML();
//	CSite& operator=(const CSite& site);


private:
	int			m_iId;
	CTDVString	m_sName;
	CTDVString	m_sDescription;
	CTDVString  m_sUrlName;
	int			m_iModerationClass;
};




/*********************************************************************************
inline void CSite::SetId(const int iId)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CSite::SetId(const int iId)
{
	m_iId = iId;
}

/*********************************************************************************
inline void CSite::SetName(const CTDVString& sName)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CSite::SetName(const CTDVString& sName)
{
	m_sName = sName;
}

inline void CSite::SetModerationClass(int iModClass)
{
	m_iModerationClass = iModClass;
}

inline void CSite::SetDescription(const CTDVString& sDescription)
{
	m_sDescription = sDescription;
}

/*********************************************************************************
inline int CSite::GetId()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Get internal value
*********************************************************************************/

inline int CSite::GetId()
{
	return m_iId;
}

inline void CSite::SetUrlName(const CTDVString& sUrlName)
{
	m_sUrlName = sUrlName;
}
#endif
