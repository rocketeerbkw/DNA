// Link.h: interface for the CLink class.
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

#if !defined(AFX_LINK_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
#define AFX_LINK_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CLink : public CXMLObject  
{
public:
	CLink(CInputContext& inputContext);
	virtual ~CLink();
	bool CopyLinksToClub(int iUserID, int iClubID, const TDVCHAR* pLinkGroup);
	bool StartChangeLinkPrivacy();
	bool ChangeLinkPrivacy(int iLinkID, bool bHidden);
	bool EndChangeLinkPrivacy();
	bool StartCopyLinkToClub();
	bool CopyLinkToClub(int iLinkID, int iClubID, const TDVCHAR* pClubLinkGroup);
	bool EndCopyLinkToClub();
	bool StartMoveLink();
	bool MoveLink(int iLinkID, const TDVCHAR* pNewLocation);
	bool EndMoveLinks();
	bool StartDeleteLink();
	bool DeleteLink(int iLinkID,int iUserID, int iSiteID);
	bool EndDeleteLinks();
	bool ClipPageToUserPage(const TDVCHAR *pPageType, int iObjectID, const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, CUser* pViewingUser, bool bPrivate);
	bool ClipPageToClub(int iClubID, const TDVCHAR *pPageType, int iPageID, 
		const TDVCHAR* pTitle, const TDVCHAR *pLinkDescription, 
		const TDVCHAR *pLinkGroup, int iTeamID, const TDVCHAR *pRelationship, 
		const TDVCHAR* pUrl, int iSubmitterID);
	bool GetUserLinks(int iUserID, const TDVCHAR* pGroup, bool bShowPrivate, int iSkip = 0, int iShow = 0);
	bool GetUserLinkGroups(int iUserID);
	bool GetClubLinks(int iClubID, const TDVCHAR* pGroup, bool bShowPrivate, int iSkip = 0, int iShow = 0);
//	bool GetVoteLinks(int iVoteID, const TDVCHAR* pGroup, bool bShowPrivate, int iSkip = 0, int iShow = 0);
	bool GetGroupedLinks(CStoredProcedure& SP,int iShow,CTDVString& sXML);

	bool GetClubsArticleLinksTo(int iArticleID);


	bool IsLinkEditableByUser(int iLinkID, CUser* pUser);
	bool GetClubLinkDetails(int iLinkID);
	bool EditClubLinkDetails(CUser* pUser, int iLinkID, CTDVString sTitle, CTDVString sURL, CTDVString sDescription );
	bool GetTeamID(int iLinkID, int& iTeamID);

private:
	bool CreateUserBlock(CStoredProcedure& SP, CTDVString & sXML, CTDVString sUserType);
};

#endif // !defined(AFX_LINK_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
