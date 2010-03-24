// ClubPageBuilder.h: interface for the CClubPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CLUBPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
#define AFX_CLUBPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "Club.h"

class CMultiStep;

class CClubPageBuilder : public CXMLBuilder 
{
public:
	CClubPageBuilder(CInputContext& inputContext);
	virtual ~CClubPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	CWholePage* ProcessParams();
	CWholePage* DisplayClub(int iClubID, CClub& Club, bool bEditing = false);
	CWholePage* DisplayClubPreview(int iClubID, const CTDVString& sTitle, const CTDVString& sGuideML);
	CWholePage* ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);
	bool ClassifyClubInHierarchy(int iClubID);
	bool HandleEditClub(int iClubID, bool& bEditing);
	bool HandleEditClubPreview(int iClubID);

protected:
	bool HasErrorBeenReported();
	bool AddLink(CClub& Club, CUser* pUser);

	CWholePage* m_pPage;
	CUser* m_pViewingUser;
	bool m_bErrorMessageReported;
};

#endif // !defined(AFX_CLUBPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
