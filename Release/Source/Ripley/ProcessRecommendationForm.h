// ProcessRecommendationForm.h: interface for the CProcessRecommendationForm class.
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


#if defined (_ADMIN_VERSION)

#if !defined(AFX_PROCESSRECOMMENDATIONFORM_H__D9710BE7_BF27_11D4_872B_00A024998768__INCLUDED_)
#define AFX_PROCESSRECOMMENDATIONFORM_H__D9710BE7_BF27_11D4_872B_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "InputContext.h"
#include "User.h"
#include "StoredProcedure.h"
#include "InputContext.h"

/*
	class CProcessRecommendationForm

	Author:		Kim Harries
	Created:	31/10/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of the form
				for displaying and processing scouts recommendations.

*/

class CProcessRecommendationForm : public CXMLObject  
{
public:
	CProcessRecommendationForm(CInputContext& inputContext);
	virtual ~CProcessRecommendationForm();
	bool CreateBlankForm(CUser* pViewer);
	bool CreateFromRecommendationID(CUser* pViewer, int iRecommendationID, const TDVCHAR* pComments, bool bAcceptButton = true, bool bRejectButton = true, bool bCancelButton = true, bool bFetchButton = true);
	bool CreateFromEntryID(CUser* pViewer, int iEntryID, const TDVCHAR* pComments, bool bAcceptButton = true, bool bRejectButton = true, bool bCancelButton = true, bool bFetchButton = true);
	bool SubmitAccept(CUser* pViewer, int ih2g2ID_Old,int iRecommendationID, const TDVCHAR* pcComments, bool* pbSuccess, CTDVString* psScoutEmail = NULL, CTDVString* psAuthorEmail = NULL, CTDVString* psScoutEmailSubject = NULL, CTDVString* psScoutEmailText = NULL, CTDVString* psAuthorEmailSubject = NULL, CTDVString* psAuthorEmailText = NULL);
	bool SubmitReject(CUser* pViewer, int iRecommendationID, const TDVCHAR* pcComments, bool* pbSuccess, CTDVString* psScoutEmail = NULL, CTDVString* psEmailSubject = NULL, CTDVString* psEmailText = NULL);

protected:
	CStoredProcedure*	m_pSP;

	bool CreateScoutAcceptanceEmail(const TDVCHAR* pcScoutName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText);
	bool CreateScoutRejectionEmail(const TDVCHAR* pcScoutName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText);
	bool CreateAuthorAcceptanceEmail(const TDVCHAR* pcAuthorName, const TDVCHAR* pcEntrySubject, int ih2g2ID, const CTDVDateTime& dtDateRecommended, CTDVString* psEmailSubject, CTDVString* psEmailText);
};

#endif // !defined(AFX_PROCESSRECOMMENDATIONFORM_H__D9710BE7_BF27_11D4_872B_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
