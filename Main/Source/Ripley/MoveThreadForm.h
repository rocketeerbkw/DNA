// MoveThreadForm.h: interface for the CMoveThreadForm class.
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

#if !defined(AFX_MOVETHREADFORM_H__68ED83C2_D26E_11D4_8730_00A024998768__INCLUDED_)
#define AFX_MOVETHREADFORM_H__68ED83C2_D26E_11D4_8730_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "InputContext.h"
#include "User.h"
#include "StoredProcedure.h"
#include "InputContext.h"

/*
	class CMoveThreadForm

	Author:		Kim Harries
	Created:	20/12/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of the form
				for editors to move a thread from one forum to another.

*/

class CMoveThreadForm : public CXMLObject  
{
public:
	CMoveThreadForm(CInputContext& inputContext);
	virtual ~CMoveThreadForm();
	bool CreateBlankForm(CUser* pViewer, bool bMoveButton = true, bool bCancelButton = true, bool bFetchButton = true, bool bUndoButton = false);
	bool CreateFromThreadAndForumIDs(CUser* pViewer, int iThreadID, const TDVCHAR* pcDestinationID, const TDVCHAR* pcPostContent = NULL, bool bMoveButton = true, bool bCancelButton = true, bool bFetchButton = true, bool bUndoButton = false);
	bool CreateFromThreadAndForumIDs(CUser* pViewer, int iThreadID, int iForumID, const TDVCHAR* pcPostContent = NULL, bool bMoveButton = true, bool bCancelButton = true, bool bFetchButton = true, bool bUndoButton = false);
	bool MoveThread(CUser* pViewer, int iThreadID, const TDVCHAR* pcDestinationID, const TDVCHAR* pcPostContent = NULL, bool* pbUpdateOK = NULL, bool bMoveButton = true, bool bCancelButton = true, bool bFetchButton = true, bool bUndoButton = true);
	bool MoveThread(CUser* pViewer, int iThreadID, int iForumID, const TDVCHAR* pcPostContent = NULL, bool* pbUpdateOK = NULL, bool bMoveButton = true, bool bCancelButton = true, bool bFetchButton = true, bool bUndoButton = true);
	bool UndoThreadMove(CUser* pViewer, int iThreadID, int iPostID, bool* pbUpdateOK);

protected:
	CStoredProcedure*	m_pSP;
	CInputContext& m_InputContext;

	bool ExtractForumID(const TDVCHAR* pcDestinationID, int* piForumID);
	bool DoesMoveInvolveReviewForum(CUser& mViewer,int iThreadID,int iDestinationForumID, CStoredProcedure& mSP);
};

#endif // !defined(AFX_MOVETHREADFORM_H__68ED83C2_D26E_11D4_8730_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
