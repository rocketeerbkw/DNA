// SubmitReviewForumBuilder.cpp: implementation of the CSubmitReviewForumBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "SubmitReviewForumBuilder.h"
#include "ReviewSubmissionForum.h"
#include "WholePage.h"
#include "tdvassert.h"


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSubmitReviewForumBuilder::CSubmitReviewForumBuilder(CInputContext& inputContext)
:CXMLBuilder(inputContext)
{

}

CSubmitReviewForumBuilder::~CSubmitReviewForumBuilder()
{

}

bool CSubmitReviewForumBuilder::Build(CWholePage* pPage)
{
	CReviewSubmissionForum mSubmitReview(m_InputContext);

	if (!InitPage(pPage, "SUBMITREVIEWFORUM", true))
	{
		return false;
	}

	bool bActionExists = m_InputContext.ParamExists("action");
	int iH2G2ID = m_InputContext.GetParamInt("h2g2id");
	
	if (!bActionExists && iH2G2ID == 0)
	{
		return pPage->SetError("The url requires additional parameters");
	}
	
	CTDVString sAction;
	m_InputContext.GetParamString("action",sAction);
	int iSiteID = m_InputContext.GetSiteID();
	
	if(sAction.CompareText("submitrequest"))
	{
		CTDVString sEmpty;
		if(mSubmitReview.RequestSubmitArticle(iH2G2ID,iSiteID,sEmpty))
		{
			pPage->AddInside("H2G2",&mSubmitReview);
		}
		else
		{
			pPage->SetError(mSubmitReview.GetError());
		}
	}
	
	else if(sAction.CompareText("submitarticle"))
	{
		CTDVString sComments;
		m_InputContext.GetParamString("response",sComments);
		int iSelectedReviewForumID = m_InputContext.GetParamInt("reviewforumid");
		
		//There should be comments
		if (!sComments.IsEmpty())
		{
			CUser* pUser = NULL;
			pUser = m_InputContext.GetCurrentUser();

			if (!mSubmitReview.SubmitArticle(pUser,iH2G2ID,iSelectedReviewForumID,iSiteID,sComments))
			{
				return pPage->SetError(mSubmitReview.GetError()); 
			}
			
			pPage->AddInside("H2G2",&mSubmitReview);
		}
		else
		{
			if (!mSubmitReview.SubmittedWithEmptyComments(iH2G2ID,iSiteID,sComments,iSelectedReviewForumID))
			{
				return pPage->SetError(mSubmitReview.GetError());
			}
			
			pPage->AddInside("H2G2",&mSubmitReview);
		}
	}

	else if (sAction.CompareText("removethread"))
	{
		int iReviewForumID =  m_InputContext.GetParamInt("rfid");
		CUser* pUser = m_InputContext.GetCurrentUser();
		int iRemoverID = 0;
		if (pUser != NULL)
		{	
			int iThreadID = 0;
			int iForumID = 0;
			bool bSuccess = false;
			if (!mSubmitReview.RemoveThreadFromForum(*pUser,iReviewForumID,iH2G2ID,&iThreadID,&iForumID,&bSuccess))
			{
				TDVASSERT(false,"Failed to remove thread from review forum - should never call this");
				return pPage->SetError("Remove from review forum error");
			}
			
			pPage->AddInside("H2G2",&mSubmitReview);
		}
		else
		{
			return pPage->SetError("Remove from review forum error");
		}


	}

	else
	{
		return pPage->SetError("Invalid parameters");
	}
	
	return true;
}


