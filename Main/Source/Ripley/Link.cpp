// Link.cpp: implementation of the CLink class.
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
#include "Link.h"
#include "Club.h"
#include "StoredProcedure.h"
#include "Team.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CLink::CLink(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CLink::~CLink()
{

}

/*********************************************************************************

	bool CLink::ClipPageToUserPage(const TDVCHAR *pPageType, int iObjectID, const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, int iUserID)

	Author:		Jim Lynn
	Created:	18/08/2003
	Inputs:		pPageType - textual type of page we're clipping
				iObjectID - ID of page we're clipping
				pLinkDesciption - Textual description (link text)
				pLinkGroup - textual (optional) group containing link (user defined)
				iUserID - UserID of the user who's clipping
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CLink::ClipPageToUserPage(const TDVCHAR *pPageType, int iObjectID, const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, CUser* pViewingUser, bool bPrivate)
{
	if (pViewingUser == NULL)
	{
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.ClipPageToUserPage(pPageType, iObjectID, pLinkDescription, pLinkGroup, "Bookmark", pViewingUser, m_InputContext.GetSiteID(), bPrivate );
	CTDVString sResult = "success";
	if (!SP.IsEOF())
	{
		SP.GetField("result", sResult);
	}
	CTDVString sXML = "<CLIP ACTION='clippage'";
	sXML << "RESULT='" << sResult << "'/>";
	CreateFromXMLText(sXML);
	return true;
}


bool CLink::ClipPageToClub(int iClubID, const TDVCHAR *pPageType, 
	int iPageID, const TDVCHAR* pTitle,	const TDVCHAR *pLinkDescription, 
	const TDVCHAR *pLinkGroup, int iTeamID, const TDVCHAR *pRelationship, 
	const TDVCHAR* pUrl, int iSubmitterID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.ClipPageToClub(iClubID,pPageType,iPageID, pTitle, pLinkDescription,
		pLinkGroup,iTeamID,pRelationship, pUrl, iSubmitterID, m_InputContext.GetSiteID());
	CTDVString sResult = "success";
	if (!SP.IsEOF())
	{
		SP.GetField("result", sResult);
	}
	CTDVString sXML = "<CLIP ACTION='clippagetoclub'";
	sXML << " RESULT='" << sResult << "'/>";
	CreateFromXMLText(sXML);
	return true;
}

bool CLink::GetUserLinks(int iUserID, const TDVCHAR* pGroup, bool bShowPrivate, int iSkip, int iShow)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (iShow <= 0)
	{
		iShow = 1000;
	}
	if (iShow > 5000)
	{
		iShow = 5000;
	}

	SP.GetUserLinks(iUserID, pGroup, bShowPrivate);
	
	int iLinkCount = 0;
	if (!SP.IsEOF())
	{
		iLinkCount = SP.GetIntField("LinkCount");
	}
	
	if (iSkip > 0)
	{
		SP.MoveNext(iSkip);
	}

	CTDVString sXML  = "<LINKS";
	sXML << " TOTALLINKS='" << iLinkCount << "' SKIPTO='" << iSkip << "' COUNT='" << iShow << "'>";

	bool bOK = GetGroupedLinks(SP,iShow,sXML);
		
	sXML << "</LINKS>\n";
	CreateFromXMLText(sXML);

	return bOK;
}

bool CLink::GetClubLinks(int iClubID, const TDVCHAR* pGroup, bool bShowPrivate, int iSkip, int iShow)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (iShow <= 0)
	{
		iShow = 1000;
	}
	if (iShow > 5000)
	{
		iShow = 5000;
	}

	SP.GetClubLinks(iClubID, pGroup, bShowPrivate);
	
	int iLinkCount = 0;
	CTDVString sClubName;
	if (!SP.IsEOF())
	{
		iLinkCount = SP.GetIntField("LinkCount");
		SP.GetField("ClubName", sClubName);
		EscapeXMLText(&sClubName);
	}
	
	if (iSkip > 0)
	{
		SP.MoveNext(iSkip);
	}

	CTDVString sXML  = "<CLUBLINKS";
	sXML << " CLUBID='" << iClubID << "' TOTALLINKS='" << iLinkCount << "' SKIPTO='" << iSkip << "' COUNT='" << iShow << "'>";
	sXML << "<CLUBNAME>" << sClubName << "</CLUBNAME>";
	
	bool bOK = GetGroupedLinks(SP,iShow,sXML);

	sXML << "</CLUBLINKS>\n";
	CreateFromXMLText(sXML);

	return bOK;
}

bool CLink::GetGroupedLinks(CStoredProcedure& SP,int iShow,CTDVString& sXML)
{
	CTDVString sCurrentGroup;
	bool bGroupOpen = false;
	int iCount = iShow;
	while (!SP.IsEOF() && iCount > 0) 
	{
		if (!bGroupOpen) 
		{
			bGroupOpen = true;
			SP.GetField("Type", sCurrentGroup);
			sXML << "<GROUP CURRENT='" << SP.GetIntField("selected") << "'>";
			EscapeXMLText(&sCurrentGroup);
			sXML << "<NAME>" << sCurrentGroup << "</NAME>";
		}

		CTDVString sType;
		SP.GetField("DestinationType", sType);
		int iObjectID = SP.GetIntField("DestinationID");
		CTDVString sTitle;
		SP.GetField("Title", sTitle);
		//CTDVDateTime dDate = SP.GetDateField("DateLinked");	// removed 01/06/05 - variable not in use
		EscapeXMLText(&sTitle);
		sXML << "<LINK TYPE='" << sType << "'";
		int iLinkID = SP.GetIntField("LinkID");
		sXML << " LINKID='" << iLinkID << "'";

		int iTeamID = SP.GetIntField("TeamID");
		CTDVString sRelationship;
		SP.GetField("Relationship",sRelationship);
		EscapeXMLText(&sRelationship);
		sXML << " TEAMID='" << iTeamID<< "'";
		sXML << " RELATIONSHIP='" << sRelationship << "'";

		if (sType.CompareText("article"))
		{
			sXML << " DNAID='A" << iObjectID << "'";
		}
		else if (sType.CompareText("userpage")) 
		{
			sXML << " BIO='U" << iObjectID << "'";
		}
		else if (sType.CompareText("category")) 
		{
			sXML << " DNAID='C" << iObjectID << "'";
		}
		else if (sType.CompareText("forum")) 
		{
			sXML << " DNAID='F" << iObjectID << "'";
		}
		else if (sType.CompareText("thread")) 
		{
			sXML << " DNAID='T" << iObjectID << "'";
		}
		else if (sType.CompareText("posting")) 
		{
			sXML << " DNAID='TP" << iObjectID << "'";
		}
		else if (sType.CompareText("club"))
		{
			sXML << " DNAID='G" << iObjectID << "'";
		}
		else if (sType.CompareText("external")) 
		{
			CTDVString sURL;
			SP.GetField("URL",sURL);
			EscapeEverything(&sURL);
			sXML << " HREF='" << sURL << "'";
		}
			sXML << " PRIVATE='" << SP.GetIntField("Private") << "'";

		sXML << "><TITLE>" << sTitle << "</TITLE>";

		CTDVString sDescription;
		SP.GetField("LinkDescription", sDescription);
		EscapeAllXML(&sDescription);
		sXML << "<DESCRIPTION>" << sDescription << "</DESCRIPTION>";

		// Submitter, if we have one
		if(!SP.IsNULL("SubmitterID"))
		{
			CTDVString sSubmitterXML;
			if(!CreateUserBlock(SP, sSubmitterXML, "SUBMITTER"))
			{
				TDVASSERT(false, "CLink::GetGroupedLinks() CreateUserBlock failed");
			}
			else
			{
				sXML += sSubmitterXML;
			}
		}
			
		//add information about a team which added the link:
		CTeam team(m_InputContext);
		if (team.GetAllTeamMembers(iTeamID))
		{
			CTDVString sTeam;
			team.GetAsString(sTeam);
			sXML << sTeam;
		}

		// Add author block if we have one
		if(!SP.IsNULL("AuthorID"))
		{
			CTDVString sAuthorXML;
			if(!CreateUserBlock(SP, sAuthorXML, "AUTHOR"))
			{
				TDVASSERT(false, "CLink::GetGroupedLinks() CreateUserBlock failed");
			}
			else
			{
				sXML += sAuthorXML;
			}
		}

		// Add LastUpdated
		if(!SP.IsNULL("LastUpdated"))
		{
			CTDVDateTime dtLastUpdated = SP.GetDateField("LastUpdated");
			CTDVString sLastUpdatedXML;
			if(!CreateDateXML("LASTUPDATED", dtLastUpdated, sLastUpdatedXML))
			{
				TDVASSERT(false, "CLink::GetGroupedLinks() CreateDateXML failed");
			}
			else
			{
				sXML += sLastUpdatedXML;
			}
		}

		sXML << "</LINK>\n";
		SP.MoveNext();
		iCount--;
		if (SP.IsEOF())
		{
			bGroupOpen = false;
			sXML << "</GROUP>";
		}
		else 
		{
			CTDVString sNewGroup;
			SP.GetField("Type", sNewGroup);
			EscapeXMLText(&sNewGroup);
			if (!sNewGroup.CompareText(sCurrentGroup)) 
			{
				bGroupOpen = false;
				sXML << "</GROUP>";
			}
		}
	}
	return true;
}

/*********************************************************************************

	bool CLink::CreateUserBlock(CStoredProcedure& SP, CTDVString & sXML, CTDVString sUserType)

		Author:		James Pullicino
        Created:	01/06/2005

        Inputs:		sUserType can be one of (case insensitive): 
					"AUTHOR"

					sXML must be empty string

					SP must be valid

        Outputs:	On success, sXML will contain user block xml
        Returns:	true on success 
        Purpose:	Creates user block xml inside element for author

*********************************************************************************/

bool CLink::CreateUserBlock(CStoredProcedure& SP, CTDVString & sXML, CTDVString sUserType)
{
	// This is for safety
	if(!sXML.IsEmpty())
	{
		TDVASSERT(false, "CLink::CreateUserBlock() sXML parameter must be empty string");
		return false;
	}

	// Field names
	CTDVString fldUserID, fldUserName, fldFirstNames, fldLastName, fldArea, fldStatus, fldTaxonomyNode, fldJournal, fldActive, fldSitesuffix, fldTitle;

	// Figure out field names
	sUserType.MakeUpper();
	if(sUserType.CompareText("AUTHOR"))			// AUTHOR
	{
		fldUserID = "AuthorID";
		fldUserName = "AuthorName";
		fldFirstNames = "AuthorFirstNames";
		fldLastName = "AuthorLastName";
		fldArea = "AuthorArea";
		fldStatus = "AuthorStatus";
		fldTaxonomyNode = "AuthorTaxonomyNode";
		fldJournal = "AuthorJournal";
		fldActive = "AuthorActive";
		fldSitesuffix = "AuthorSiteSuffix";
		fldTitle = "AuthorTitle";
	} 
	else if(sUserType.CompareText("SUBMITTER"))			// SUBMITTER
	{
		fldUserID = "SubmitterID";
		fldUserName = "SubmitterName";
		fldFirstNames = "SubmitterFirstNames";
		fldLastName = "SubmitterLastName";
		fldArea = "SubmitterArea";
		fldStatus = "SubmitterStatus";
		fldTaxonomyNode = "SubmitterTaxonomyNode";
		fldJournal = "SubmitterJournal";
		fldActive = "SubmitterActive";
		fldSitesuffix = "SubmitterSiteSuffix";
		fldTitle = "SubmitterTitle";
	}
	else										// UKNOWN
	{
		TDVASSERT(false, "CLink::CreateUserBlock() Uknown user type parameter passed");
		return false;
	}

	// Build user block xml
	sXML << "<" << sUserType << "><USER>";		// Open <USERTYPE><USER>

	// <USERID>
	int iUserID = 0;
	if (SP.FieldExists(fldUserID))
	{
		iUserID = SP.GetIntField(fldUserID);
		sXML << "<USERID>" << iUserID << "</USERID>";
	}

	// <USERNAME>
	if (SP.FieldExists(fldUserName))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldUserName, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<USERNAME>" << sFieldVal << "</USERNAME>";
		}
	}
	
	// <FIRSTNAMES>
	if (SP.FieldExists(fldFirstNames))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldFirstNames, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<FIRSTNAMES>" << sFieldVal << "</FIRSTNAMES>";
		}
	}

	// <LASTNAME>
	if (SP.FieldExists(fldLastName))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldLastName, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<LASTNAME>" << sFieldVal << "</LASTNAME>";
		}
	}

	// <AREA>
	if (SP.FieldExists(fldArea))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldArea, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<AREA>" << sFieldVal << "</AREA>";
		}
	}

	// <STATUS>
	if (SP.FieldExists(fldStatus))
	{
		sXML << "<STATUS>" << SP.GetIntField(fldStatus) << "</STATUS>";
	}

	// <TAXONOMYNODE>
	if (SP.FieldExists(fldTaxonomyNode))
	{
		sXML << "<TAXONOMYNODE>" << SP.GetIntField(fldTaxonomyNode) << "</TAXONOMYNODE>";
	}

	// <JOURNAL>
	if (SP.FieldExists(fldJournal))
	{
		sXML << "<JOURNAL>" << SP.GetIntField(fldJournal) << "</JOURNAL>";
	}

	// <ACTIVE>
	if (SP.FieldExists(fldActive))
	{
		sXML << "<ACTIVE>" << SP.GetIntField(fldActive) << "</ACTIVE>";
	}

	// <SITESUFFIX>
	if (SP.FieldExists(fldSitesuffix))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldSitesuffix, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<SITESUFFIX>" << sFieldVal << "</SITESUFFIX>";
		}
	}

	// <TITLE>
	if (SP.FieldExists(fldTitle))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldTitle, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<TITLE>" << sFieldVal << "</TITLE>";
		}
	}

	// <GROUPS>
	CTDVString sGroupsXML;
	if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
	{
		TDVASSERT(false, "CArticleList::CreateUserBlock() m_InputContext.GetUserGroups failed");
		// Don't fail. User tag will simply have no groups tag.
	}
	else
	{
		// Append
		sXML += sGroupsXML;
	}

	sXML << "</USER></" << sUserType << ">";	// Close </USER></USERTYPE>

	return true;
}

bool CLink::GetUserLinkGroups(int iUserID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetLinkGroups("userpage", iUserID);
	CTDVString sXML = "<LINKGROUPS USERID='";
	sXML << iUserID << "'>\n";
	while (!SP.IsEOF())
	{
		CTDVString sGroup;
		SP.GetField("Type", sGroup);
		CTDVString sURLGroup = sGroup;
		CTDVString sEscapedString = sGroup;
		EscapeAllXML(&sEscapedString);
		EscapeTextForURL(&sURLGroup);
		EscapeXMLText(&sGroup);
		sXML << "<GROUP";
		int iCount = SP.GetIntField("TotalLinks");
		sXML << " COUNT='" << iCount << "'>";
		sXML << sGroup << "</GROUP>";

		SP.MoveNext();
	}
	sXML << "</LINKGROUPS>\n";
	CreateFromXMLText(sXML);
	return true;
}

bool CLink::StartDeleteLink()
{
	CreateFromXMLText("<DELETEDLINKS/>");
	return true;
}

bool CLink::DeleteLink(int iLinkID, int iUserID, int iSiteID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	bool bDeleted = false;
	SP.DeleteLink(iLinkID,iUserID,iSiteID,bDeleted);
	CTDVString sXML;
	sXML << "<LINK ID='" << iLinkID << "' DELETED='" << bDeleted << "'/>";
	AddInside("DELETEDLINKS", sXML);
	return true;
}

bool CLink::EndDeleteLinks()
{
	return true;
}

bool CLink::StartMoveLink()
{
	CreateFromXMLText("<MOVEDLINKS/>");
	return true;
}

bool CLink::MoveLink(int iLinkID, const TDVCHAR* pNewLocation)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.MoveLink(iLinkID, pNewLocation);
	CTDVString sXML;
	sXML << "<LINK ID='" << iLinkID << "'/>";
	AddInside("MOVEDLINKS", sXML);
	SetAttribute("MOVEDLINKS","NEWGROUP",pNewLocation);
	return true;
}

bool CLink::EndMoveLinks()
{
	return true;
}

bool CLink::StartChangeLinkPrivacy()
{
	CreateFromXMLText("<CHANGEDLINKPRIVACY/>");
	return true;
}

bool CLink::ChangeLinkPrivacy(int iLinkID, bool bPrivate)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.ChangeLinkPrivacy(iLinkID, bPrivate);
	CTDVString sXML;
	sXML << "<LINK ID='" << iLinkID << "'";
	if (bPrivate)
	{
		sXML << " PRIVATE='1'";
	}
	else
	{
		sXML << " PRIVATE='0'";
	}
	sXML << "/>";
	AddInside("CHANGEDLINKPRIVACY", sXML);
	return true;
}

bool CLink::EndChangeLinkPrivacy()
{
	return true;
}

bool CLink::CopyLinksToClub(int iUserID, int iClubID, const TDVCHAR* pLinkGroup)
{
	CClub Club(m_InputContext);
	if (Club.CanUserEditClub(iUserID, iClubID))
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		SP.CopyLinksToClub(iUserID, iClubID, pLinkGroup);
		CTDVString sResult;
		SP.GetField("result", sResult);
		CTDVString sXML = "<CLIP ACTION='copytoclub'";
		if (sResult.CompareText("success")) 
		{
			int iNumCopied = SP.GetIntField("totalcopied");
			sXML << " TOTALCOPIED='" << iNumCopied << "'";
		}
		sXML << " RESULT='" << sResult << "'/>";
		CreateFromXMLText(sXML);
	}
	else
	{
		CTDVString sXML = "<CLIP ACTION='copytoclub'";
		sXML << "RESULT='cannoteditclub'/>";
		CreateFromXMLText(sXML);
	}
	return true;
}

bool CLink::StartCopyLinkToClub()
{
	CreateFromXMLText("<COPIEDLINKS/>");
	return true;
}

bool CLink::CopyLinkToClub(int iLinkID, int iClubID, const TDVCHAR* pClubLinkGroup)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.CopySingleLinkToClub(iLinkID, iClubID,  pClubLinkGroup);
	int iResult = SP.GetIntField("result");
	if (iResult == 0)
	{
		CTDVString sXML;
		sXML << "<LINK RESULT='success' LINKID='" << iLinkID << "'/>";
		AddInside("COPIEDLINKS", sXML);
	}
	else if (iResult == 1) 
	{
		CTDVString sXML;
		sXML << "<COPIEDLINK RESULT='failed' REASON='duplicate' LINKID='" << iLinkID << "'>";
		CTDVString sGroup;
		SP.GetField("type", sGroup);
		EscapeXMLText(&sGroup);
		sXML << "<GROUP>" << sGroup << "</GROUP></COPIEDLINK>";
		AddInside("COPIEDLINKS", sXML);
	}
	else
	{
		CTDVString sXML;
		CTDVString sReason;
		SP.GetField("reason", sReason);

		sXML << "<LINK RESULT='failed' REASON='" << sReason << "'/>";
		AddInside("COPIEDLINKS", sXML);
	}
	return true;
}

bool CLink::EndCopyLinkToClub()
{
	return true;
}


/*********************************************************************************

	bool CLink::GetClubsArticleLinksTo(int iArticleID)

		Author:		James Pullicino
        Created:	03/06/2005
        Inputs:		iArticleID - ID of article to get linked clubs for
        Outputs:	-
        Returns:	-
        Purpose:	Creates XML with all clubs that iArticleID links to

*********************************************************************************/

bool CLink::GetClubsArticleLinksTo(int iArticleID)
{
	// Run stored proc
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if(!SP.GetClubsArticleLinksTo(iArticleID))
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() SP.GetClubsArticleLinksTo() failed");
		return false;
	}

	// Build XML
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, &SP);			// <LINKS>
	if(!OpenXMLTag("LINKS"))
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() OpenXMLTag failed");
		return false;
	}

	if(!OpenXMLTag("CLUBS-ARTICLE-LINKS-TO"))	// <CLUBS-ARTICLE-LINKS-TO>
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() OpenXMLTag failed");
		return false;
	}

	if(!OpenXMLTag("GROUP"))					// <GROUP>
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() OpenXMLTag failed");
		return false;
	}

	// Add links
	while(!SP.IsEOF())
	{
		if(!OpenXMLTag("LINK", true))			// <LINK ...>
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() OpenXMLTag failed");
			return false;
		}

		// LinkID= attribute
		if(!AddDBXMLIntAttribute("linkid"))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() AddDBXMLIntAttribute failed");
			return false;
		}

		// Type= attribute
		// Has got to be club. Might as well hard-code it
		if(!AddXMLAttribute("type", "club", false))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() AddXMLAttribute failed");
			return false;
		}

		// Relationship= attribute
		if(!AddDBXMLAttribute("relationship"))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() AddDBXMLAttribute failed");
			return false;
		}

		// dnaid= attribute
		// We have to construct this ourselves since we must append
		// G before the ID. AddDBXMLAttribute does not support this
		int iObjectID = SP.GetIntField("clubid");
		CTDVString sDNAID;
		sDNAID << "G" << iObjectID;
		if(!AddXMLAttribute("dnaid", sDNAID))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() AddXMLAttribute failed");
			return false;
		}

		// articleid= attribute
		if(!AddDBXMLAttribute("articleid", 0, true, false, true))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() AddDBXMLAttribute failed");
			return false;
		}

		// <TITLE>
		if(!AddDBXMLTag("title"))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() AddDBXMLTag");
		}
        
		// <AUTHOR>
		CTDVString sAuthorXML;
		if(!CreateUserBlock(SP, sAuthorXML, "AUTHOR"))
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() CreateUserBlock() failed");
		}
		else
		{
			sXML += sAuthorXML;
		}
	
		if(!CloseXMLTag("LINK"))	// </LINK>
		{
			TDVASSERT(false, "CLink::GetClubsArticleLinksTo() CloseXMLTag failed");
			return false;
		}
        
		SP.MoveNext();
	}

	if(!CloseXMLTag("GROUP"))					// </GROUP>
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() CloseXMLTag failed");
		return false;
	}

	if(!CloseXMLTag("CLUBS-ARTICLE-LINKS-TO"))	// </CLUBS-ARTICLE-LINKS-TO>
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() CloseXMLTag failed");
		return false;
	}

	if(!CloseXMLTag("LINKS"))					// </LINKS>
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() CloseXMLTag failed");
		return false;
	}

	if(!CreateFromXMLText(sXML))
	{
		TDVASSERT(false, "CLink::GetClubsArticleLinksTo() CreateFromXMLText failed");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CLink::GetClubLinkDetails(int iLinkID)

		Author:		DE
        Created:	03/08/2005
        Inputs:		iLinkID - The id of the link 
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Fetches details about the given link

*********************************************************************************/
bool CLink::GetClubLinkDetails(int iLinkID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CLink::GetClubLinkDetails","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetClubLinkDetails(iLinkID))
	{
		return SetDNALastError("CLink::GetClubLinkDetails","FailedToGetClubLinkDetails","Failed to get Link details");
	}

	// Now insert the results into the XML
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	
		// Check to see if we've got any members!
	if (SP.IsEOF())
	{
		return SetDNALastError("CLink::GetClubLinkDetails","LinkRecordDoesNotExists","Link Record Does No tExists");
	}

	bool bOk = true;
	
	// Now create the container tag
	OpenXMLTag("LINK");	
		bOk = bOk && AddDBXMLTag("SourceType","SourceType",true);
		bOk = bOk && AddDBXMLIntTag("SourceID", "ClubID", false);
		bOk = bOk && AddDBXMLTag("ClubName", "ClubName", false);
		bOk = bOk && AddDBXMLTag("DestinationType","DestinationType",true);
		bOk = bOk && AddDBXMLIntTag("DestinationID","DestinationID",false);
		bOk = bOk && AddDBXMLTag("LinkDescription","LinkDescription",false);
		bOk = bOk && AddDBXMLDateTag("DateLinked","DateLinked",false);
		bOk = bOk && AddDBXMLIntTag("Explicit","Explicit",false);
		bOk = bOk && AddDBXMLIntTag("LinkID","LinkID",true);	
		bOk = bOk && AddDBXMLIntTag("Hidden","Hidden",true);	
		bOk = bOk && AddDBXMLTag("Type","Type",true);	
		bOk = bOk && AddDBXMLIntTag("Private","Private",true);	
		bOk = bOk && AddDBXMLIntTag("TeamID","TeamID",false);	
		bOk = bOk && AddDBXMLTag("Relationship","Relationship",false);	
		bOk = bOk && AddDBXMLTag("Title","Title",false);	
		bOk = bOk && AddDBXMLTag("URL","URL",true);
		
		OpenXMLTag("SUBMITTEDBY");	
			int iSubmittedBy = SP.GetIntField("SubmitterID");
			if ( iSubmittedBy > 0 )
			{				
				CUser user(m_InputContext);
				if ( user.CreateFromID(iSubmittedBy) ==true)
				{
					CTDVString sUserXML;
					if (user.GetAsString(sUserXML) == true)
					{
						sXML << sUserXML;
					}
				}
			}
		CloseXMLTag("SUBMITTEDBY");				

		bOk = bOk && AddDBXMLDateTag("LastUpdated","LastUpdated",false);
		
		OpenXMLTag("EDITEDBY");	
			int iEditedBy = SP.GetIntField("EditedBy");
			if ( iEditedBy > 0 )
			{				
				CUser user(m_InputContext);
				if ( user.CreateFromID(iEditedBy) ==true)
				{
					CTDVString sUserXML;
					if (user.GetAsString(sUserXML) == true)
					{
						sXML << sUserXML;
					}
				}
			}
		CloseXMLTag("EDITEDBY");	

	bOk = bOk && CloseXMLTag("LINK");

	// Now create the tree
	bOk = bOk && CreateFromXMLText(sXML,NULL,true);

	// Check to see if everything went ok?
	if (!bOk)
	{
		return SetDNALastError("CLink::GetClubLinkDetails","FailedtoParseLinkRecord","Failed to parse link record");
	}

	return true;
}


/*********************************************************************************

	bool CLink::EditClubLinkDetails(int iLinkID, CTDVString sTitle, CTDVString sURL, CTDVString sDescription )

		Author:		DE
        Created:	03/08/2005
        Inputs:		CUser* pUser - the editor
						iLinkID - The id of the link 
						CTDVString sTitle  - Title of link
						CTDVString sURL  - URL of link
						CTDVString sDescription - Description of link
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Updates the given CLUB link - specific to club links

*********************************************************************************/
bool CLink::EditClubLinkDetails(CUser* pUser, int iLinkID, CTDVString sTitle, CTDVString sURL, CTDVString sDescription )
{	
	if ( IsLinkEditableByUser(iLinkID, pUser) == false)
	{
		return SetDNALastError("CLink::EditClubLinkDetails","UserisNotPermittedToMakeChangesToLink","Only a user who is an editor, an owner of the link or a member of the club's team is allowed to make changes to this link");
	}		

	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CLink::EditClubLinkDetails","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.EditClubLinkDetails(iLinkID, sTitle, sURL, sDescription, pUser->GetUserID( )))
	{
		return SetDNALastError("CLink::EditClubLinkDetails","FailedToEditClubLinkDetails","Failed to edit Link details");
	}
	
	return GetClubLinkDetails(iLinkID);
}

/*********************************************************************************

	bool CLink::IsLinkEditableByUser(int iLinkID, int iUserID)

		Author:		DE
        Created:	04/08/2005
        Inputs:		pUser - the wanabe editor
						iLinkID - The id of the link 						
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	determines if a user can make updates to a link

*********************************************************************************/
bool CLink::IsLinkEditableByUser(int iLinkID, CUser* pUser)
{
	//Check to make sure there is a user
	if (pUser == NULL)
	{
		// this operation requires a logged on user
		return false;		
	}

	//Check to make sure there is a logged in user
	if (pUser->IsUserLoggedIn() == false)
	{		
		return false;		
	}

	//Check to whether user is an editor	
	if (pUser->GetIsEditor())
	{
		return true;
	}

	//check to make sure whether user is part of the link owner team
	int iTeamID = 0;
	bool bIsMember;

	GetTeamID(iLinkID, iTeamID);

	CTeam Team (m_InputContext);
	Team.IsUserAMemberOfThisTeam(iTeamID, pUser->GetUserID(), bIsMember);

	return bIsMember;
}

/*********************************************************************************

	bool CLink::GetLinkTeamID(int iTeamID, int iUserID)

		Author:		DE
        Created:	03/08/2005
        Inputs:		iTeamID - The id of the Team
						iLinkID - The id of the link
        Outputs:	
        Returns:	true if ok, false if not
        Purpose:	returns teamid  attribute of a link

*********************************************************************************/
bool CLink::GetTeamID(int iLinkID, int& iTeamID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CLink::GetTeamID","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetLinkTeamID(iLinkID, iTeamID))
	{
		return SetDNALastError("CLink::GetTeamID","FailedToGetTeamID","Failed to get Link Team ID");
	}

	return true;
}