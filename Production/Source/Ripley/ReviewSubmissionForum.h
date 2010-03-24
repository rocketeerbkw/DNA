// ReviewSubmissionForum.h: interface for the CReviewSubmissionForum class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_REVIEWSUBMISSIONFORUM_H__262E1134_90B5_11D5_87AB_00A024998768__INCLUDED_)
#define AFX_REVIEWSUBMISSIONFORUM_H__262E1134_90B5_11D5_87AB_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
class CUser;

class CReviewSubmissionForum  : public CXMLObject
{
public:
	CReviewSubmissionForum(CInputContext& inputContext);
	virtual ~CReviewSubmissionForum();
	bool RequestSubmitArticle(int iH2G2ID, int iSiteID, const CTDVString& sSubmitterComments,int iSelectedReviewForumID = 0); 
	bool SubmitArticle(CUser* pSubmitter,int iH2G2ID, int iReviewForumID,int iSiteID,const CTDVString& sComments);
	bool SubmittedWithEmptyComments(int iH2G2ID, int iSiteID, const CTDVString& sSubmitterComments,int iSelectedReviewForumID);
	bool RemoveThreadFromForum(CUser& mViewer,int iReviewForumID,int iH2G2ID, int *iThreadID, int *iForumID,bool *pbSuccessful, bool bHasPermission = false );
	const CTDVString& GetError();

private:

	bool NotifyAuthorOnPersonalSpace(int iSubmitterID,int iEditorID,const CTDVString& sUserName,int iH2G2ID,int iSiteID,int iReviewForumID,int iForumID,int iThreadID,int iPostID,const CTDVString &sSubject,const CTDVString &sComments);

	bool GracefulError(const TDVCHAR* pOuterTag,const TDVCHAR* pErrorType,const TDVCHAR* pErrorText = NULL,
										   const TDVCHAR* pLinkHref = NULL,const TDVCHAR* pLinkBody = NULL);
	void SetError(const TDVCHAR* pErrorText);

private:
	CTDVString m_sErrorText;
};

#endif // !defined(AFX_REVIEWSUBMISSIONFORUM_H__262E1134_90B5_11D5_87AB_00A024998768__INCLUDED_)
