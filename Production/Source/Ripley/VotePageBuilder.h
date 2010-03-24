// VotePageBuilder.h: interface for the CVotePageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_VOTEPAGEBUILDER_H__6A02C679_36A5_4B10_83C3_ED06D8CC3031__INCLUDED_)
#define AFX_VOTEPAGEBUILDER_H__6A02C679_36A5_4B10_83C3_ED06D8CC3031__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "Vote.h"

class CInputContext;

class CVotePageBuilder : public CXMLBuilder  
{
public:
	CVotePageBuilder(CInputContext& inputContext);
	virtual ~CVotePageBuilder();

public:
	virtual bool Build(CWholePage* pPage);
	static enum
	{
		VOTETYPE_CLUB = 1,
		VOTETYPE_NOTICE = 2
	};

protected:
	bool ViewVote();
	bool CreateVotePage();
	bool GetCommonInfo(bool bGetVoteInfo, bool bNeedResponseInfo = true);
	bool CreateNewVote();
	bool FinishPage();
	bool AddResponce();
	bool AddLinkToVote();
	bool RemoveUserVote();
	bool SubmitUrl();
	bool AddPollXml();
	bool AddClubLinksXml();

	CWholePage* m_pPage;
	CVote m_CurrentVote;

private:
	CTDVString m_sVoteName;
	CTDVString m_sUserName;
	CTDVString m_sBBCUID;
	CTDVDateTime m_tDateCreated;
	CTDVDateTime m_tClosingDate;
	int	m_iVoteID;
	int m_iObjectID;
	int m_iResponse;
	int m_iType;
	int m_iUserID;
	int m_iOwnerID;
	bool m_bShowUser;
	bool m_bSimpleYesNo;
	bool m_bVoteClosed;
	int m_iThreadID;
};

#endif // !defined(AFX_VOTEPAGEBUILDER_H__6A02C679_36A5_4B10_83C3_ED06D8CC3031__INCLUDED_)
