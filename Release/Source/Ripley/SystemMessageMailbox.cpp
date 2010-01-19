#include "stdafx.h"
#include ".\systemmessagemailbox.h"
#include ".\storedprocedure.h"

CSystemMessageMailbox::CSystemMessageMailbox(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CSystemMessageMailbox::~CSystemMessageMailbox(void)
{
}

/*********************************************************************************

	bool CSystemMessageMailbox::GetUsersSystemMessageMailbox

		Author:		James Conway
        Created:	08/05/2006
        Inputs:		iUserID - The ID of the user you want to get messages for
					iSiteID - The site the user's messages are associated with.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the users system messages

*********************************************************************************/
bool CSystemMessageMailbox::GetUsersSystemMessageMailbox(int iUserID, int iSiteID, int iSkip, int iShow)
{
	// Get and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::GetUsersSystemMessageMailbox","FailedToInitialiseStoredProcedure","Failed to Initialise Stored Procedure!!!");
	}

	// Now call the procedure and check to make sure we got something
	if (!SP.GetUserSystemMessageMailbox(iUserID, iSiteID, iSkip, iShow))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::GetUsersSystemMessageMailbox","FailedToGetUserDetails","Failed to get the user details!!!");
	}

	// Now create the XML
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("SYSTEMMESSAGEMAILBOX",true);
	bOk = bOk && XML.AddIntAttribute("USERID",iUserID,false);
	bOk = bOk && XML.AddIntAttribute("TOTALCOUNT", SP.GetIntField("TotalCount"), false); 
	bOk = bOk && XML.AddIntAttribute("SKIP", iSkip, false); 
	bOk = bOk && XML.AddIntAttribute("SHOW", iShow, true); 

	// Go through the results adding the data to the XML
	while (bOk && !SP.IsEOF())
	{
		bOk = bOk && XML.OpenTag("MESSAGE",true);
		bOk = bOk && XML.DBAddIntAttribute("MsgID", "MsgID", false, false);
		bOk = bOk && XML.DBAddIntAttribute("SiteID", "SiteID", false, true);
		bOk = bOk && XML.DBAddTag("MessageBody", "Body", false, true);
		bOk = bOk && XML.DBAddDateTag("DatePosted", "DatePosted", true, false);
		bOk = bOk && XML.CloseTag("MESSAGE");

		// Get the next result
		SP.MoveNext();
	}

	bOk = bOk && XML.CloseTag("SYSTEMMESSAGEMAILBOX");

	// Now create the XML tree from the String
	if (!bOk || !CreateFromXMLText(sXML,NULL,true))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::GetUsersSystemMessageMailbox","FailedToCreateXML","Failed to create XML!!!");
	}

	// Return ok
	return true;
}
/*********************************************************************************

	bool CSystemMessageMailbox::ProcessParams

		Author:		James Conway
        Created:	08/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	void
        Purpose:	Process cmd param

*********************************************************************************/
bool CSystemMessageMailbox::ProcessParams()
{
	CTDVString cmd;
	m_InputContext.GetParamString("cmd", cmd);

	if (cmd.CompareText("delete"))
	{
		return DeleteDNASystemMessage(m_InputContext.GetParamInt("msgid"));
	}

	CTDVString sXML;
	sXML << "<CMD ACTION='NONE' RESULT='1'/>";

	// Now create the XML tree from the String
	if (!CreateFromXMLText(sXML,NULL,true))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::DeleteMessage","FailedToCreateXML","Failed to create XML!!!");
	}

	return true; 
}
/*********************************************************************************

	bool CSystemMessageMailbox::DeleteDNASystemMessage

		Author:		James Conway
        Created:	08/05/2006
        Inputs:		iMsgID - unique id of msg to be deleted
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Deletes a message and returns XML detailing which record has been deleted.

*********************************************************************************/
bool CSystemMessageMailbox::DeleteDNASystemMessage(int iMsgID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::DeleteMessage","FailedToInitialiseStoredProcedure","Failed to Initialise Stored Procedure!!!");
	}

	// Now call the procedure and check to make sure we got something
	if (!SP.DeleteDNASystemMessage(iMsgID))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::DeleteMessage","FailedToDeleteDNASystemMessage","Failed to delete DNA system message!!!");
	}

	// Now create the XML
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("CMD",true);
	bOk = bOk && XML.AddAttribute("ACTION", "DELETE", false); 
	bOk = bOk && XML.AddIntAttribute("RESULT", 1, true); 

	// Go through the results adding the data to the XML
	while (bOk && !SP.IsEOF())
	{
		bOk = bOk && XML.OpenTag("MESSAGE",true);
		bOk = bOk && XML.DBAddIntAttribute("MsgID", "MsgID", false, false);
		bOk = bOk && XML.DBAddIntAttribute("SiteID", "SiteID", false, true);
		bOk = bOk && XML.DBAddTag("MessageBody", "Body", false, true);
		bOk = bOk && XML.DBAddDateTag("DatePosted", "DatePosted", true, false);
		bOk = bOk && XML.CloseTag("MESSAGE");

		// Get the next result
		SP.MoveNext();
	}

	bOk = bOk && XML.CloseTag("CMD");

	// Now create the XML tree from the String
	if (!bOk || !CreateFromXMLText(sXML,NULL,true))
	{
		// Report the error!
		return SetDNALastError("CSystemMessageMailbox::DeleteMessage","FailedToCreateXML","Failed to create XML!!!");
	}

	// Return ok
	return true; 
}