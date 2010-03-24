// SubAllocationForm.h: interface for the CSubAllocationForm class.
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

#if !defined(AFX_SUBALLOCATIONFORM_H__D9710BE3_BF27_11D4_872B_00A024998768__INCLUDED_)
#define AFX_SUBALLOCATIONFORM_H__D9710BE3_BF27_11D4_872B_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

/*
	class CSubAllocationForm

	Author:		Kim Harries
	Created:	31/10/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of the form
				for allocating entries to a sub editor

*/

class CSubAllocationForm : public CXMLObject  
{
public:
	CSubAllocationForm(CInputContext& inputContext);
	virtual ~CSubAllocationForm();

	bool Initialise();
	bool SubmitAllocation(int iSubID, int iAllocatorID, const TDVCHAR* pComments, int* piEntryIDs, int iTotalEntries);
	bool SubmitAutoAllocation(int iSubID, int iNumberToAllocate, int iAllocatorID, const TDVCHAR* pComments = NULL, int* piTotalAllocated = NULL);
	bool SubmitDeallocation(int iDeallocatorID, int* piEntryIDs, int iTotalEntries, int* piTotalDeallocated = NULL);
	bool AddErrorMessage(const TDVCHAR* pErrorType, const TDVCHAR* pErrorText = NULL);
	bool InsertSubEditorList();
	bool InsertAcceptedRecommendationsList();
	bool InsertAllocatedRecommendationsList(int iShow, int iSkip);
	bool InsertNotificationStatus();
};

#endif // !defined(AFX_SUBALLOCATIONFORM_H__D9710BE3_BF27_11D4_872B_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
