// UserComplaintPageBuilder.h: interface for the CUserComplaintPageBuilder class.
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


#if !defined(AFX_USERCOMPLAINTPAGEBUILDER_H__AC62090F_FCE3_11D4_873B_00A024998768__INCLUDED_)
#define AFX_USERCOMPLAINTPAGEBUILDER_H__AC62090F_FCE3_11D4_873B_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "TDVString.h"
#include "InputContext.h"
#include "OutputContext.h"
#include "InputContext.h"
#include "WholePage.h"
#include "StoredProcedure.h"
#include "User.h"

/*
	class CUserComplaintPageBuilder : public CXMLBuilder  

	Author:		Kim Harries
	Created:	07/02/2001
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the user complaint popup page.

*/

class CUserComplaintPageBuilder : public CXMLBuilder  
{
public:
	CUserComplaintPageBuilder(CInputContext& inputContext);
	virtual ~CUserComplaintPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	CStoredProcedure*	m_pSP;
	CTDVString			m_sCommand;
	CTDVString			m_sType;
	CTDVString			m_sURL;
	CTDVString			m_sModerationReference;
	int					m_ih2g2ID;
	int					m_iUserID;
	int					m_iPostID;
	int					m_iModID;
	int					m_iMediaAssetID;

	bool ProcessSubmission(CUser* pViewer, CTDVString& p_sXML);
	bool CreateForm(CUser* pViewer, CTDVString* psFormXML);
	bool IsEMailBannedFromComplaining(CTDVString& sEmail);
	void CreateBannedComplaintsXML(CTDVString& sXML);
	CTDVString CreateErrorXML(CTDVString errtype, CTDVString err);
};

#endif // !defined(AFX_USERCOMPLAINTPAGEBUILDER_H__AC62090F_FCE3_11D4_873B_00A024998768__INCLUDED_)
