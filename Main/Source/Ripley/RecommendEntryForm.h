// RecommendEntryForm.h: interface for the CRecommendEntryForm class.
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


#if !defined(AFX_RECOMMENDENTRYFORM_H__B550E140_B4C2_11D4_8726_00A024998768__INCLUDED_)
#define AFX_RECOMMENDENTRYFORM_H__B550E140_B4C2_11D4_8726_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "InputContext.h"
#include "User.h"

/*
	class CRecommendEntryForm

	Author:		Kim Harries
	Created:	31/10/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of the form
				for scouts to recommend entries.

*/

class CRecommendEntryForm : public CXMLObject  
{
public:
	CRecommendEntryForm(CInputContext& inputContext);
	virtual ~CRecommendEntryForm();
	bool CreateBlankForm(CUser* pUser);
	bool CreateFromh2g2ID(CUser* pUser, int ih2g2ID, const TDVCHAR* pcComments = NULL);
	bool SubmitRecommendation(CUser* pViewer, int ih2g2ID, const TDVCHAR* pcComments = NULL);

protected:
	bool	m_bIsValidRecommendation;
};

#endif // !defined(AFX_RECOMMENDENTRYFORM_H__B550E140_B4C2_11D4_8726_00A024998768__INCLUDED_)
