// TopFiveEditor.cpp: implementation of the CTopFiveEditor class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "TopFiveEditor.h"
#include "TopFives.h"
#include "GuideEntry.h"
#include "Forum.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTopFiveEditor::CTopFiveEditor(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CTopFiveEditor::~CTopFiveEditor()
{

}

bool CTopFiveEditor::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "TOPFIVE-EDITOR", true);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	// do an error page if not an editor
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pPageXML->SetPageType("ERROR");
		pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit Top Fives unless you are logged in as an Editor.</ERROR>");
		return true;
	}
	
	
	int iSiteID = m_InputContext.GetSiteID();
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sXML;
	
	CTDVString sGroupName;
	if (m_InputContext.GetParamString("editgroup", sGroupName))
	{
		CTDVString sType;
		m_InputContext.GetParamString("type", sType);
		if (m_InputContext.ParamExists("fetch"))
		{
			if (SP.GetSiteTopFives(iSiteID, sGroupName))
			{
                CXMLObject::EscapeAllXML(&sGroupName);
				sXML = "<TOP-FIVE-EDIT NAME='";
				sXML << sGroupName << "' TYPE='";
				bool bArticle = SP.IsNULL("ForumID");
				if (bArticle)
				{
					sXML << "ARTICLE'>";
				}
				else
				{
					sXML << "FORUM'>";
				}
				CTDVString sDescription;
				CTDVString sTitle;
				SP.GetField("GroupDescription", sDescription);
                CXMLObject::EscapeAllXML(&sDescription);
				sXML << "<DESCRIPTION>" << sDescription << "</DESCRIPTION>";
				while (!SP.IsEOF())
				{
					if (bArticle)
					{
						sXML << "<H2G2 H2G2ID='A" << SP.GetIntField("h2g2ID") << "'>";
						SP.GetField("Subject", sTitle);
 
						CXMLObject::EscapeAllXML(&sTitle);
						sXML << sTitle << "</H2G2>";
					}
					else
					{
						sXML << "<FORUM";
						int iTid = SP.GetIntField("ThreadID");
						if (iTid > 0)
						{
							sXML << " THREAD='"<< SP.GetIntField("ThreadID") << "'";
						}
						sXML << " FORUMID='F" << SP.GetIntField("ForumID") << "'>";
						
						SP.GetField("Title", sTitle);
						CXMLObject::EscapeXMLText(&sTitle);
						sXML << sTitle << "</FORUM>";
					}
					SP.MoveNext();
				}
				sXML << "</TOP-FIVE-EDIT>";
				pPageXML->AddInside("H2G2", sXML);
				sXML.Empty();
			}

		}
        else if ( m_InputContext.ParamExists("delete"))
        {
            if ( !SP.DeleteTopFive(iSiteID, sGroupName) )
            {
                pPageXML->AddInside("H2G2",CreateErrorXMLString("CTopFiveEditor","DeleteTopFive","Unable to delete group"));
            }
        }
		else if (m_InputContext.ParamExists("update"))
		{
			bool bIsArticle = true;

			// Have to update the list
			CTDVString sDescription;
			m_InputContext.GetParamString("description", sDescription);
			if (sType.CompareText("article"))
			{
				bIsArticle = true;
				SP.StartSetTopFiveArticleList(iSiteID, sGroupName, sDescription);
			}
			else
			{
				bIsArticle = false;
				// forums
				SP.StartSetTopFiveForumList(iSiteID, sGroupName, sDescription);
			}
			sXML = "<TOP-FIVE-EDIT NAME='";
            CXMLObject::EscapeAllXML(&sGroupName);
			sXML << sGroupName << "' TYPE='";
			if (bIsArticle)
			{
				sXML << "ARTICLE'>";
			}
			else
			{
				sXML << "FORUM'>";
			}
            CXMLObject::EscapeAllXML(&sDescription);
			sXML << "<DESCRIPTION>" << sDescription << "</DESCRIPTION>";
			int iCount = m_InputContext.GetParamCount("id");
			for (int i=0; i<iCount; i++)
			{
				//have to be able to deal with F's or A's before the id

				int id = 0;
				int iThreadID = 0;

				CTDVString sID;
				if (m_InputContext.GetParamString("id",sID,i))
				{
					if (bIsArticle)
					{
						CGuideEntry::GetH2G2IDFromString(sID,&id);
					}
					else
					{
						CForum::GetForumIDFromString(sID,&id);
					}
				}

				if (!bIsArticle)
				{
					iThreadID = m_InputContext.GetParamInt("thread", i);
				}
				
				//id = m_InputContext.GetParamInt("id", i);
				if (id > 0)
				{
                    if ( bIsArticle )
                        SP.AddArticleTopFiveID(id);
                    else
					    SP.AddTopFiveID(id, iThreadID);

					if (bIsArticle)
					{
						sXML << "<H2G2 H2G2ID='A" << id << "'></H2G2>";
					}
					else
					{
						sXML << "<FORUM FORUMID='F" << id << "'";
						if (iThreadID > 0)
						{
							sXML << " THREAD='" << iThreadID << "'";
						}
						sXML << "></FORUM>";
					}
				}
			}
			sXML << "</TOP-FIVE-EDIT>";
			SP.DoSetTopFive();
			pPageXML->AddInside("H2G2", sXML);
			sXML.Empty();

			CTopFives TopFive(m_InputContext);
			TopFive.Initialise(iSiteID, true);
			pPageXML->AddInside("H2G2",&TopFive);
		}
	}

	SP.GetSiteListOfLists(iSiteID, &sXML);
	pPageXML->AddInside("H2G2", sXML);
	sXML.Empty();

	return true;
}
