#include "stdafx.h"
#include ".\moderationdistressmessages.h"
#include ".\moderationclasses.h"
#include ".\forum.h"

CModerationDistressMessagesBuilder::CModerationDistressMessagesBuilder( CInputContext& InputContext) : CXMLBuilder(InputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

CModerationDistressMessagesBuilder::~CModerationDistressMessagesBuilder(void)
{
}

/*********************************************************************************

	CModerationDistressMessagesBuilder::Build()

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Builds Distress Message Admin Page.
				Distress Messages are predefined messages that a moderator can post to a board in reply
				to a moderated post.
*********************************************************************************/
bool CModerationDistressMessagesBuilder::Build(CWholePage* pPage)
{
	if ( !InitPage(pPage, "DISTRESSMESSAGESADMIN", true) )
		return false;

	if ( !m_InputContext.GetCurrentUser() || !m_InputContext.GetCurrentUser()->GetIsSuperuser() )
	{
		pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessagesBuilder::Build","DistressMessages","User Not Authorised"));
		return true;
	}

	int iModClassId = m_InputContext.GetParamInt("modclassid");
	CModerationDistressMessages distressmsgs(m_InputContext);

	//Process 
	if ( m_InputContext.ParamExists("action") )
	{
		CTDVString sAction;
		m_InputContext.GetParamString("action",sAction);
		int iMessageId = m_InputContext.GetParamInt("messageid");

		if ( sAction == "remove" ) 
		{
			if ( !distressmsgs.RemoveDistressMessage(iMessageId) )
				pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessages","DistressMessages","Unable to remove message"));
		}
		else if ( sAction == "add" )
		{
			CTDVString sSubject, sText;
			if ( iModClassId > 0 && m_InputContext.GetParamString("subject",sSubject) && m_InputContext.GetParamString("text",sText) )
			{
				if ( !distressmsgs.AddDistressMessage(iModClassId, sSubject, sText) )
					pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessages","DistressMessages","Unable to add message"));
			}
			else
				pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessages","DistressMessages","Insufficient Parameters to add message"));
		}
		else if ( sAction = "edit" )
		{
			CTDVString sSubject, sText;
			if ( iMessageId && m_InputContext.GetParamString("subject",sSubject) && m_InputContext.GetParamString("text",sText) )
			{
				if ( !distressmsgs.UpdateDistressMessage(iMessageId, iModClassId, sSubject, sText) )
					pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessages","DistressMessages","Unable to edit message"));
			}
			else
				pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessages","DistressMessages","Insufficient Parameters to edit message"));
		}
		else
			pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModerationDistressMessages","DistressMessages","Unknown action."));
	}

	//Add Moderation Classes
	CModerationClasses modclasses(m_InputContext);
	if ( !modclasses.GetModerationClasses() )
		pPage->AddInside("H2G2",modclasses.GetLastErrorAsXMLString());
	else
		pPage->AddInside("H2G2",&modclasses);

	//Get the Distress Messages for the specified moderation class.
	if ( distressmsgs.GetDistressMessages(iModClassId) )
		pPage->AddInside("H2G2",&distressmsgs);
	else
		pPage->AddInside("H2G2",distressmsgs.GetLastErrorAsXMLString());
	
	return true;
}

CModerationDistressMessages::CModerationDistressMessages(CInputContext& InputContext) : CXMLObject( InputContext )
{}

/*********************************************************************************

	CModerationDistressMessages::GetDistressMessages()

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		iMessageID - Details of message to retrieve.
	Outputs:	sTitle, sBody of predefined distress message
	Returns:	false on error.
	Purpose:	
	*********************************/
bool CModerationDistressMessages::GetDistressMessage( int iMessageID, CTDVString& sSubject, CTDVString& sBody )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	if ( !SP.GetDistressMessage( iMessageID) || SP.IsEOF() )
	{
		SetDNALastError("CModerationDistressMessages::GetDistressMessages","GetDistressMessages","Failed to get distress message.");
		return false;
	}
	
	SP.GetField("subject",sSubject);
	SP.GetField("Text",sBody);
	return true;
}

/*********************************************************************************

	CModerationDistressMessages::GetDistressMessages( int iModclassId )

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		ModClassId filter
	Outputs:	-
	Returns:	NA
	Purpose:	Retrurns distress messages for the provided mod class id or all distress messgaes if no
				filter provided.
*********************************************************************************/
bool CModerationDistressMessages::GetDistressMessages( int iModClassId /* = 0 */ )
{
	CTDVString sXML;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	InitialiseXMLBuilder(&sXML,&SP);

	if ( !SP.GetDistressMessages( iModClassId ) )
	{
		SetDNALastError("CModerationDistressMessages::GetDistressMessages","DistressMessages","Unable to retrieve Distress Messages");
		return false;
	}

	OpenXMLTag("DISTRESSMESSAGES", iModClassId > 0 ? true : false );
	if ( iModClassId > 0 )
		AddXMLIntAttribute("MODCLASSID",iModClassId,true);
	while ( !SP.IsEOF() )
	{
		OpenXMLTag("DISTRESSMESSAGE",true);
		AddDBXMLIntAttribute("MessageID","ID",true,true);
		AddDBXMLIntTag("MODCLASSID");
		AddDBXMLTag("subject");
		AddDBXMLTag("text");
		CloseXMLTag("DISTRESSMESSAGE");
		SP.MoveNext();
	}
	CloseXMLTag("DISTRESSMESSAGES");

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	CModerationDistressMessages::RemoveDistressMessage()

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Removes the distress message.
*********************************************************************************/
bool CModerationDistressMessages::RemoveDistressMessage(int iMessageId)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if ( !SP.RemoveDistressMessage(iMessageId) )
	{
		SetDNALastError("CModerationDistressMessages::RemoveDistressMessage","RemoveDistressMessage","Unable to remove distress message");
		return false;
	}
	return true;
}

/*********************************************************************************

	CModerationDistressMessages::AddDistressMessage( iModClassId, sTitle, sBody )

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		ModClassId, Subject and Body for distress message.
	Outputs:	-
	Returns:	NA
	Purpose:	Adds a predefined distress message for the provided mod class id.
				A distress message is posted top a board in response to a moderated post.
*********************************************************************************/
bool CModerationDistressMessages::AddDistressMessage( int iModClassId, CTDVString sTitle, CTDVString sText)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if ( !SP.AddDistressMessage(iModClassId, sTitle, sText) )
	{
		SetDNALastError("CModerationDistressMessages::AddDistressMessage","AddDistressMessage","Unable to add distress message");
		return false;
	}
	return true;
}

/*********************************************************************************

	CModerationDistressMessages::UpdateDistressMessage()

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		iMessageId, iModClassId, title, body
	Outputs:	-
	Returns:	NA
	Purpose:	Allows a distress message to be updated.
*********************************************************************************/
bool CModerationDistressMessages::UpdateDistressMessage(int iMessageId, int iModClassId, CTDVString sTitle, CTDVString sText)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if ( !SP.UpdateDistressMessage(iMessageId, iModClassId, sTitle, sText) )
	{
		SetDNALastError("CModerationDistressMessages::UpdateDistressMessage","UpdateDistressMessage","Unable to update distress message");
		return false;
	}
	return true;
}

/*********************************************************************************

	CModerationDistressMessages::PostDistressMessage()

	Author:		Martin Robb
	Created:	27/02/2006
	Inputs:		siteid, iforumid, ithreadid, ireplyto, subject, body
	Outputs:	-
	Returns:	NA
	Purpose:	Posts a distress message to the specified site/forum/thread - in reply to a moderated post.
*********************************************************************************/
bool CModerationDistressMessages::PostDistressMessage( CUser* pUser, int iSiteId, int iForumId,int iThreadId, int iReplyTo, const CTDVString& sSubject, const CTDVString& sBody )
{
	if ( pUser == NULL || iForumId == 0 || iThreadId == 0 || iReplyTo == 0 || sBody.IsEmpty() || sSubject.IsEmpty()  )
	{
		CTDVString sErr = "Unable to post distress message - Invalid Post Details. ";
		SetDNALastError("CModerationDistressMessages::PostDistressMessage","PostDistressMessage", sErr << sSubject << "." );
		return false;
	}
	int iNewThreadId, iNewPostId;
	CForum forum(m_InputContext);
	if ( !forum.PostToForum(pUser, iForumId, iReplyTo,
			iThreadId, sSubject, sBody, 2, &iNewThreadId, &iNewPostId, 
			NULL, NULL, NULL, 0, 0, "", false, NULL, true  ) )
	{
		CTDVString sErr = "Unable to post distress message ";
		SetDNALastError("CModerationDistressMessages::PostDistressMessage","PostDistressMessage", sErr << sSubject << "." );
		return false;
	}
	return true;
}
