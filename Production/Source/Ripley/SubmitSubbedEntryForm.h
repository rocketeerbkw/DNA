// SubmitSubbedEntryForm.h: interface for the CSubmitSubbedEntryForm class.
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


#if !defined(AFX_SUBMITSUBBEDENTRYFORM_H__68ED83C0_D26E_11D4_8730_00A024998768__INCLUDED_)
#define AFX_SUBMITSUBBEDENTRYFORM_H__68ED83C0_D26E_11D4_8730_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "InputContext.h"
#include "User.h"

/*
	class CSubmitSubbedEntryForm

	Author:		Kim Harries
	Created:	15/12/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation of the form
				for subs to submitted their subbed entries.

*/

class CSubmitSubbedEntryForm : public CXMLObject  
{
public:
	CSubmitSubbedEntryForm(CInputContext& inputContext);
	virtual ~CSubmitSubbedEntryForm();
	bool CreateBlankForm(CUser* pUser);
	bool CreateFromh2g2ID(CUser* pUser, int ih2g2ID);
	bool SubmitSubbedEntry(CUser* pViewer, int ih2g2ID, const TDVCHAR* pcComments = NULL);

protected:
	bool	m_bIsValidEntry;
};

#endif // !defined(AFX_SUBMITSUBBEDENTRYFORM_H__68ED83C0_D26E_11D4_8730_00A024998768__INCLUDED_)
