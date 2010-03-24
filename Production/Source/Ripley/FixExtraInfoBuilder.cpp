// FixExtraInfoBuilder.cpp: implementation of the CFixExtraInfoBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "GuideEntry.h"
#include "Club.h"
#include "FixExtraInfoBuilder.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFixExtraInfoBuilder::CFixExtraInfoBuilder(CInputContext& inputContext)
:
CXMLBuilder(inputContext)
{

}

CFixExtraInfoBuilder::~CFixExtraInfoBuilder()
{

}

/*********************************************************************************

	CWholePage* CFixExtraInfoBuilder::Build()

	Author:		Mark Neves
	Created:	12/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CFixExtraInfoBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	InitPage(m_pPage, "FIXEXTRAINFO",true);
	CUser* pViewer = m_InputContext.GetCurrentUser();
	
	//This builder can only be used by a logged in user
	
	if (pViewer == NULL)
	{
		m_pPage->SetError("NULL viewer in CFixExtraInfoBuilder::Build()");
		return true;
	}

	// Is the user mighty enough?
	if (!pViewer->GetIsSuperuser())
	{
		m_pPage->SetError("User doesn't have the necessary privileges");
		return true;
	}

	int ih2g2id	 = m_InputContext.GetParamInt("h2g2id");
	int iclubid  = m_InputContext.GetParamInt("clubid");
	int iType	 = m_InputContext.GetParamInt("type");
	bool bUpdate = m_InputContext.ParamExists("update");

	if (iclubid > 0)
	{
		CClub Club(m_InputContext);
		if (Club.InitialiseViaClubID(iclubid,true))
		{
			ih2g2id = Club.GetArticleID();
		}
		else
		{
			m_pPage->SetError("failed to initialise club");
			return true;
		}
	}

	// We need a valid h2g2id at this point
	if (ih2g2id <= 0)
	{
		m_pPage->SetError("invalid params");
		return true;
	}


	CGuideEntry Guide(m_InputContext);
	if (!Guide.Initialise(ih2g2id,m_InputContext.GetSiteID(), pViewer, true,true,true))
	{
		m_pPage->SetError("Failed to initialise using h2g2id");
		return true;
	}

	CExtraInfo ExtraInfo;
	Guide.GetExtraInfo(ExtraInfo);
	CTDVString sOriginalExtraInfo;
	ExtraInfo.GetInfoAsXML(sOriginalExtraInfo);

	int iOriginalStatus = Guide.GetStatus();
	int iStatus = iOriginalStatus;

	int iOriginalType = Guide.GetType();

	if (!Guide.IsDeleted())
	{
		// Do we need to change the status of the article?  Yes, if it was written by the right people
		// Scan the EXTRAINFO for group information, and if the "BBCStaff" group is found, it's
		// an official article, so change the status to 1
		CTDVString sExtraInfo;
		ExtraInfo.GetInfoAsXML(sExtraInfo);
		CXMLTree* pTree = CXMLTree::Parse(sExtraInfo);
		if (pTree != NULL)
		{
			CXMLTree* pNode = pTree->FindFirstTagName("GROUP");
			while (pNode != NULL)
			{
				CTDVString sValue;
				pNode->GetAttribute("NAME",sValue);

				if (sValue.CompareText("BBCStaff"))
				{
					iStatus = 1;
				}

				pNode = pNode->FindNextTagNode("GROUP");
			}

			delete pTree;
		}
	}

	// No longer need the <EDITOR> tag in extrainfo
	ExtraInfo.RemoveInfoItem("EDITOR");

	if (!Guide.IsTypeOfClub())
	{
		// If it has a <REASON> tag, get ride of it
		ExtraInfo.RemoveInfoItem("REASON");

		// Regenerate the Autodescription tag
		CTDVString sBodyText;
		Guide.GetBody(sBodyText);
		ExtraInfo.GenerateAutoDescription(sBodyText);
	}
	else
	{
		// It's a club

		CTDVString sReasonXML;
		if (ExtraInfo.GetInfoItem("REASON", sReasonXML))
		{
			// Move <REASON> tag from Extrainfo to inside the <GUIDE> tag of the body

			ExtraInfo.RemoveInfoItem("REASON");

			if (!Guide.AddInside("GUIDE",sReasonXML))
			{
				m_pPage->SetError("unable to add REASON to guide");
				return true;
			}

			CTDVString sBodyText;
			Guide.GetBody(sBodyText);

			if (!Guide.UpdateBody(sBodyText))
			{
				m_pPage->SetError("unable to update body of guide");
				return true;
			}
		}
	}

	if (bUpdate)
	{
		// Update the entry's extrainfo field in the DB
		if (!Guide.UpdateExtraInfoEntry(ExtraInfo))
		{
			m_pPage->SetError("unable to update guide extra info");
			return true;
		}

		// Update the entry's type field in the DB, if necessary
		if (iType > 0)
		{
			if (!Guide.UpdateType(iType))
			{
				m_pPage->SetError("unable to update guide type value");
				return true;
			}
		}

		// Update the entry's status field in the DB
		if (!Guide.UpdateStatus(iStatus))
		{
			m_pPage->SetError("unable to update the status");
			return true;
		}

		m_pPage->AddInside("H2G2","<EXTRAINFOUPDATED/>");
	}
	else
	{
		// Don't update the database, just show the original and new settings

		m_pPage->AddInside("H2G2","<ORIGINALSETTINGS/>");
		m_pPage->AddInside("ORIGINALSETTINGS",sOriginalExtraInfo);

		CTDVString sXML;
		sXML << "<ORIGINALSTATUS>" << iOriginalStatus << "</ORIGINALSTATUS>";
		m_pPage->AddInside("ORIGINALSETTINGS",sXML);

		sXML.Empty();
		sXML << "<ORIGINALTYPE>"   << iOriginalType   << "</ORIGINALTYPE>";
		m_pPage->AddInside("ORIGINALSETTINGS",sXML);

		CTDVString sExtraInfo;
		ExtraInfo.GetInfoAsXML(sExtraInfo);
		m_pPage->AddInside("H2G2","<NEWSETTINGS/>");
		m_pPage->AddInside("NEWSETTINGS",sExtraInfo);

		sXML.Empty();
		sXML << "<NEWSTATUS>" << iStatus << "</NEWSTATUS>";
		m_pPage->AddInside("NEWSETTINGS",sXML);

		sXML.Empty();
		if (iType > 0)
		{
			sXML << "<NEWTYPE>"	  << iType   << "</NEWTYPE>";
		}
		else
		{
			sXML << "<NOTCHANGINGTYPE/>";
		}
		m_pPage->AddInside("NEWSETTINGS",sXML);
	}

	return true;
}
