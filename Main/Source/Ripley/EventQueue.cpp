// EventQueue.cpp: implementation of the CEventQueue class.
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


#include "stdafx.h"
#include "InputContext.h"
#include "InputContext.h"
#include "EventQueue.h"
#include "tdvassert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CEventQueue::CEventQueue(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CEventQueue::~CEventQueue()
{
}

/*********************************************************************************

	bool CEventQueue::AddToEventQueue(EventType eET,int ItemID, int ItemType)

		Author:		Mark Neves
        Created:	18/08/2004
        Inputs:		eET = the event type
					ItemID = the ID of the item the event relates to (e.g. a h2g2id)
					ItemType = the type of id ItemID is (e.g. h2g2id)
        Outputs:	-
        Returns:	true if successful, false otherwise
        Purpose:	Adds an event to the event queue

*********************************************************************************/

bool CEventQueue::AddToEventQueue(	EventType eET, int iUserID,
									int iItemID, CEmailAlertList::eItemType iItemType,
									int iItemID2 /*= 0*/, CEmailAlertList::eItemType iItemType2/*=CEmailAlertList::IT_H2G2*/)
{
	bool bOK = true;

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	bOK = SP.AddToEventQueue(eET,iUserID,iItemID,iItemType,iItemID2,iItemType2);
	if (!bOK)
	{
		SetDNALastError("EventQueue","ADDFAILED","Failed to add to the event queue");
	}

	return bOK;
}

/*********************************************************************************

	bool CEventQueue::DeleteAllFromEventQueue()

		Author:		Mark Neves
        Created:	25/08/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if OK
        Purpose:	Deletes all the events from the event queue 

*********************************************************************************/

bool CEventQueue::DeleteAllFromEventQueue()
{
	bool bOK = true;

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	bOK = SP.DeleteAllFromEventQueue();
	if (!bOK)
	{
		SetDNALastError("EventQueue","DELETEALLFAILED","Failed to delete all events from event queue");
	}

	return bOK;
}


/*********************************************************************************

	bool CEventQueue::DeleteByDateFromEventQueue(CTDVDateTime* p_dDate)

		Author:		Nick Stevenson
        Created:	14/09/2004
        Inputs:		p_dDate: pointer to a CTDVDateTime instance
        Outputs:	-
        Returns:	true/false
        Purpose:	Calls a storedprocedure to delete rows from the event queue based on 
					their date.

*********************************************************************************/

bool CEventQueue::DeleteByDateFromEventQueue(CTDVDateTime* p_dDate)
{
	bool bOK = true;
	if(p_dDate == NULL)
	{
		SetDNALastError("EventQueue","NOVALIDDATEPASSED","NULL Date object passed");
		bOK = false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	bOK = bOK && SP.DeleteByDateFromEventQueue(p_dDate);
	if (!bOK)
	{
		SetDNALastError("EventQueue","DELETEBYDATEFAILED","Failed to delete events by date from event queue");
	}

	return bOK;
}

/*********************************************************************************

	bool CEventQueue::IsArticleUpdated(CStoredProcedure* p_SP)

		Author:		Nick Stevenson
        Created:	14/09/2004
        Inputs:		p_SP: pointer to an instance of CStoredProcedure
        Outputs:	-
        Returns:	true/false
        Purpose:	This function is used to determine whether the correct guide entry values
					have been updated that would require adding an event to the event queue.
					Currently these would be updates to article subject and body fields.
					A bitwise comparison is used to determine this and a true/false value 
					is returned accordingly.

*********************************************************************************/

bool CEventQueue::IsArticleUpdated(CStoredProcedure* p_SP)
{
	bool bOK = false;
	if(p_SP == NULL)
	{
		SetDNALastError("EventQueue","NULL StoredProcedure Object","SP object is NULL");
		bOK = false;
	}

	int iUpdateBits = (CStoredProcedure::ARTICLEUPDATESUBJECT | CStoredProcedure::ARTICLEUPDATEBODY);
	if((iUpdateBits & p_SP->GetUpdateBits()) > 0)
	{
		bOK = true;
	}
	return bOK;
}