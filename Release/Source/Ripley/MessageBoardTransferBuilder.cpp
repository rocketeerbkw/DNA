#include "stdafx.h"
#include ".\MessageBoardTransferBuilder.h"
#include ".\MessageBoardTransfer.h"
#include ".\User.h"
#include ".\tdvassert.h"
#include ".\groups.h"

CMessageBoardTransferBuilder::CMessageBoardTransferBuilder(CInputContext& InputContext) : CXMLBuilder(InputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CMessageBoardTransferBuilder::~CMessageBoardTransferBuilder(void)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CMessageBoardTransferBuilder::~CMessageBoardTransferBuilder(void)
{
}

/*********************************************************************************

	bool CMessageBoardTransferBuilder::Build(CWholePage* pPage)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pPage = ptr to the page to build in
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	This builder provides facilities to backup messageboard
					data from one server, and restore the data on another server.

					It is intended that you would run the "backup" option on the
					source server to create the XML data.  Then you would log into
					the destination server and run the "restore" option, supplying
					the XML data as input.

*********************************************************************************/

bool CMessageBoardTransferBuilder::Build(CWholePage* pPage)
{
	// Create and init the page
	if (!InitPage(pPage,"MESSAGEBOARDTRANSFER",false,true))
	{
		TDVASSERT(false,"CMessageBoardTransferBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Get the status for the current user. Only editors are allowed to use this page.
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL || !pUser->GetIsSuperuser())
	{
		SetDNALastError("CMessageBoardTransferBuilder::Build","UserNotLoggedInOrNotAuthorised","User Not Logged In Or Authorised");
		pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		return false;
	}

	// Set up the page root node
	if (!pPage->AddInside("H2G2","<MESSAGEBOARDTRANSFER/>"))
	{
		TDVASSERT(false,"CMessageBoardTransferBuilder - Failed to add MESSAGEBOARDTRANSFER node");
		return false;
	}

	// Add site info at the top level
	pPage->AddInside("MESSAGEBOARDTRANSFER",m_InputContext.GetSiteAsXML(m_InputContext.GetSiteID()));

	// Get the site info
	int iSiteID = m_InputContext.GetSiteID();

	// Now check to see if we're backing up or restoring!
	if (m_InputContext.ParamExists("backup"))
	{
		// We're backing up!
		BackupToXML(pPage,iSiteID);
	}
	else if (m_InputContext.ParamExists("restore"))
	{
		RestoreFromXML(pPage);
	}
	else
	{
		// We're choosing what options we want!
		// Put the mode into the page.
		pPage->SetAttribute("H2G2","PAGE","OPTIONS");
	}

	if (ErrorReported())
	{
		pPage->AddInside("MESSAGEBOARDTRANSFER",GetLastErrorAsXMLString());
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransferBuilder::BackupToXML(CWholePage* pPage, int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pPage = ptr to the page
					iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Creates a "backup" XML string that represents all the active
					messageboard items for the given site.

					The backup XML is supplied in a BACKUPTEXT tag in the page

*********************************************************************************/

bool CMessageBoardTransferBuilder::BackupToXML(CWholePage* pPage, int iSiteID)
{
	// Check the page pointer
	if (pPage == NULL)
	{
		return SetDNALastError("CMessageBoardTransferBuilder","NULLPAGE","Called with a NULL Page pointer!!!");
	}

	if (m_InputContext.ParamExists("createbackupxml"))
	{
		pPage->SetAttribute("H2G2","PAGE","BACKUPRESULT");

		CMessageBoardTransfer MBTransfer(m_InputContext);
		MBTransfer.CreateBackupXML(iSiteID);

		if (MBTransfer.ErrorReported())
		{
			CopyDNALastError("CMessageBoardTransferBuilder",MBTransfer);
		}

		// Get the XML for the object, and insert it into the page
		CTDVString sXML;
		MBTransfer.GetAsString(sXML);
		pPage->AddInside("MESSAGEBOARDTRANSFER",sXML);

		// Insert an escaped version of the XML too, so it can be displayed in
		// a text area field on the page
		CTDVString sEscapedXML = sXML;
		CXMLObject::EscapeAllXML(&sEscapedXML);
		sEscapedXML= CXMLObject::MakeTag("BACKUPTEXT",sEscapedXML);

		pPage->AddInside("MESSAGEBOARDTRANSFER",sEscapedXML);
	}
	else
	{
		pPage->SetAttribute("H2G2","PAGE","BACKUPOPTIONS");
	}

	return true;
}


/*********************************************************************************

	bool CMessageBoardTransferBuilder::RestoreFromXML(CWholePage* pPage)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pPage = the page
        Outputs:	-
        Returns:	true if OK, false otherwise
        Purpose:	Takes a backup XML string, and restores the items in the site
					specified in the XML.

*********************************************************************************/

bool CMessageBoardTransferBuilder::RestoreFromXML(CWholePage* pPage)
{
	// Check the page pointer
	if (pPage == NULL)
	{
		return SetDNALastError("CMessageBoardTransferBuilder","NULLPAGE","Called with a NULL Page pointer!!!");
	}

	if (m_InputContext.ParamExists("restorebackupxml"))
	{
		pPage->SetAttribute("H2G2","PAGE","RESTORERESULT");

		CTDVString sRestoreXML;
		m_InputContext.GetParamString("restoreXML",sRestoreXML);

		CMessageBoardTransfer MBTransfer(m_InputContext);
		MBTransfer.RestoreFromBackupXML(sRestoreXML);

		if (MBTransfer.ErrorReported())
		{
			CopyDNALastError("CMessageBoardTransferBuilder",MBTransfer);
		}

		pPage->AddInside("MESSAGEBOARDTRANSFER",&MBTransfer);
	}
	else
	{
		pPage->SetAttribute("H2G2","PAGE","RESTOREOPTIONS");
	}

	// Always add the list of editors for this site
	int iSiteID = m_InputContext.GetSiteID();
	CGroups Groups(m_InputContext);
	Groups.GetGroupMembers("Editor",iSiteID,false);

	pPage->AddInside("MESSAGEBOARDTRANSFER",&Groups);

	return true;
}
