// NoticeBoardBuilder.h: interface for the CNoticeBoardBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NOTICEBOARDBUILDER_H__18EF9171_DA88_4169_B445_92FD98CEA738__INCLUDED_)
#define AFX_NOTICEBOARDBUILDER_H__18EF9171_DA88_4169_B445_92FD98CEA738__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "User.h"

class CNoticeBoardBuilder : public CXMLBuilder  
{
public:
	CNoticeBoardBuilder(CInputContext& inputContext);
	virtual ~CNoticeBoardBuilder();

public:
	virtual bool Build(CWholePage* pPage);

protected:
	bool CreateNewNotice(CTDVString& sType, CTDVString& sXML, CTDVString& sError);
	bool EditNotice( int iThreadID, int iForumID, CTDVString &sXML);
	bool PreviewNotice(CTDVString &sType, bool bEditMode, CTDVString &sXML );

	bool HandleRedirect( int iThreadId );

protected:
	CWholePage* m_pPage;
	int m_iSiteID;
	int m_iUserID;
	int m_iNodeID;
	CTDVString m_sUserName;
	CUser* m_pViewingUser;
	bool m_bCachePage;
};

#endif // !defined(AFX_NOTICEBOARDBUILDER_H__18EF9171_DA88_4169_B445_92FD98CEA738__INCLUDED_)
