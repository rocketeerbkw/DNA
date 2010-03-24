// UserEditPageBuilder.h: interface for the CUserEditPageBuilder class.
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


#if !defined(AFX_USEREDITPAGEBUILDER_H__291BC13C_FA6F_11D3_86FD_00A024998768__INCLUDED_)
#define AFX_USEREDITPAGEBUILDER_H__291BC13C_FA6F_11D3_86FD_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "InputContext.h"
#include "OutputContext.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "ArticleEditForm.h"
#include "WholePage.h"
#include "StoredProcedure.h"

#include <vector>
#include "poll.h"

/*
	class CUserEditPageBuilder : public CXMLBuilder  

	Author:		Kim Harries
	Created:	16/03/2000
	Modified:	20/03/2000
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for a user edit page based on the request info from
				the CGI request, accessed through the given input context. To do
				this it will most likely require access to the database via a
				database context, but in some cases this may not be necessary.

*/

class CUserEditPageBuilder : public CXMLBuilder  
{
public:
	CUserEditPageBuilder(CInputContext& inputContext);
	virtual ~CUserEditPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	CTDVString			m_Command;
	CTDVString			m_Subject;
	CTDVString			m_Body;
	int					m_NewFormat;
	int					m_OldFormat;
	int					m_h2g2ID;
	bool				m_IsMasthead;
	bool				m_DoRedirect;
	bool				m_MakeHidden;
	CTDVString			m_RedirectURL;
	CTDVString			m_ParseErrorXML;
	CWholePage*			m_pPage;
	CUser*				m_pViewer;
	CArticleEditForm*	m_pForm;
	bool				m_IsUberEditor;	// if viewer has superuser (editor or moderator) edit permissions
	int					m_SiteID;
	int					m_Submittable;
	bool				m_CanMakeSubmittable;
	int					m_MoveToSiteID;
	int					m_iEditor;
	int					m_iStatus;
	bool				m_bGotAction;
	CTDVString			m_sAction;
	bool				m_bArchive;
	bool				m_bUpdateDateCreated;
	int					m_iPreProcessed;
	
	std::vector<POLLDATA>	m_vecPollTypes;	// Poll types to create for this page

	void ProcessParameters();
	bool ProcessDeleteRequest(bool bCheckReviewForum);
	bool ProcessUndeleteRequest();
	bool ProcessUpdate();
	bool ProcessResearchersChange();
	bool ProcessStatusChange(bool bConsider);
	bool CreateArticleEditForm();
	bool CreateFormInPage(bool bDoPreview);
	bool ReformatArticle();
	bool InitialisePage();
	bool CreateArticleIsInReviewForumPage(int iReviewForumID);
	bool RemoveArticleFromReviewForum(int iReviewForumID);
	bool ProcessRemoveSelfFromResearchers();
	bool RedirectToEdit();
	bool HandleRedirect(CWholePage* pPageXML,CGuideEntry& GuideEntry);

	bool IsPreProcessedParamPresent() { return m_iPreProcessed >= 0; }
	bool GetPreProcessedParamState()  { return m_iPreProcessed > 0;  }
};

#endif // !defined(AFX_USEREDITPAGEBUILDER_H__291BC13C_FA6F_11D3_86FD_00A024998768__INCLUDED_)
