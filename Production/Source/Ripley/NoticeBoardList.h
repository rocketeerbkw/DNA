// NoticeBoardList.h: interface for the CNoticeBoardList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NOTICEBOARDLIST_H__A6693A70_F56B_4383_8D4C_CADEDBD411D6__INCLUDED_)
#define AFX_NOTICEBOARDLIST_H__A6693A70_F56B_4383_8D4C_CADEDBD411D6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
class CWholePage;

class CNoticeBoardList : public CXMLObject  
{
public:
	CNoticeBoardList(CInputContext& inputContext);
	virtual ~CNoticeBoardList();

public:
	bool GetNoticeBoardsForNodeID(const int iNodeID, const int iSiteID, int iSkip = 0, int iShow = 20);
	bool GetAllNoticeBoards(CWholePage* pPage, const int iSiteID, int iSkip = 0, int iShow = 20);

protected:
	
};

#endif // !defined(AFX_NOTICEBOARDLIST_H__A6693A70_F56B_4383_8D4C_CADEDBD411D6__INCLUDED_)
