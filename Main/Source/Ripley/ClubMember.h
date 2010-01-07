// ClubMember.h: interface for the CClubMember class.
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


#ifndef _CLUBMEMBER_H_INCLUDED_
#define _CLUBMEMBER_H_INCLUDED_

#include "XMLObject.h"
#include "TDVString.h"
#include "TDVDateTime.h"
#include "ExtraInfo.h"
#include "category.h"

class CClubMember : public CXMLObject
{
public:
	CClubMember(CInputContext& inputContext);
	~CClubMember();

	void Clear();

	//
	// Accessor functions:
	//
	void SetClubId(const int iClubId);	
	void SetName(const CTDVString& sName);
	void SetIncludeStrippedName(bool bIncludeStrippedName);
	void SetExtraInfo(const int iType);
	void SetExtraInfo(const CTDVString& sExtraInfo);
	void SetExtraInfo(const CTDVString& sExtraInfo, const int iType);
	void SetDateCreated(const CTDVDateTime& dateCreated);
	void SetLastUpdated(const CTDVDateTime& lastUpdated);
	bool SetCrumbTrail( );
	void SetLocal();

	bool GetAsXML(CStoredProcedure& SP, CTDVString& sXML, bool& bMovedToNextRec);

private:
	int m_iClubId;	

	CTDVString m_sName, m_sExtraInfo;
	CTDVDateTime m_dateCreated, m_lastUpdated;
	bool m_bIncludeStrippedName;
	CTDVString m_sCrumbTrail;
	bool m_bClubIsLocal;

	CExtraInfo m_cExtraInfo;
};




/*********************************************************************************
	inline void CClubMember::SetClubId(const int iClubId)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetClubId(const int iClubId)
{
	m_iClubId = iClubId;
}

/*********************************************************************************
	inline void CClubMember::SetName(const CTDVString& sName)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetName(const CTDVString& sName)
{
	m_sName = sName;
}


/*********************************************************************************
	inline void CClubMember::SetIncludeStrippedName(bool bIncludeStrippedName)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetIncludeStrippedName(bool bIncludeStrippedName)
{
	m_bIncludeStrippedName = bIncludeStrippedName;
}


/*********************************************************************************
	inline void CClubMember::SetExtraInfo(const int iType)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetExtraInfo(const int iType)
{
	m_cExtraInfo.Create(iType);
	m_cExtraInfo.GetInfoAsXML(m_sExtraInfo);
}


/*********************************************************************************
	inline void CClubMember::SetExtraInfo(const CTDVString& sExtraInfo)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetExtraInfo(const CTDVString& sExtraInfo)
{
	m_sExtraInfo = sExtraInfo;
}

/*********************************************************************************
	inline void CClubMember::SetExtraInfo(const CTDVString& sExtraInfo, const int iType)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetExtraInfo(const CTDVString& sExtraInfo, const int iType)
{
	m_cExtraInfo.Create(iType, sExtraInfo);
	m_cExtraInfo.GetInfoAsXML(m_sExtraInfo);
}


/*********************************************************************************
	inline void CClubMember::SetDateCreated(const CTDVDateTime& dateCreated)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetDateCreated(const CTDVDateTime& dateCreated)
{
	m_dateCreated = dateCreated;
}


/*********************************************************************************
	inline void CClubMember::SetLastUpdated(const CTDVDateTime& lastUpdated)
	Author:		David van Zijl
	Created:	20/07/2004
	Purpose:	Set internal object value
*********************************************************************************/

inline void CClubMember::SetLastUpdated(const CTDVDateTime& lastUpdated)
{
	m_lastUpdated = lastUpdated;
}

#endif
