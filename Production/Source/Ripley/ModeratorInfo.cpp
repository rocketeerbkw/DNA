#include "stdafx.h"
#include ".\moderatorinfo.h"

CModeratorInfo::CModeratorInfo(CInputContext& inputContext):
	CXMLObject(inputContext)
{
}

CModeratorInfo::~CModeratorInfo(void)
{
}

bool CModeratorInfo::GetModeratorInfo(int iUserId)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetModeratorInfo(iUserId);

	CTDVString sModeratorXML;
	CDBXMLBuilder moderatorBuilder;
	moderatorBuilder.Initialise(&sModeratorXML, &SP);

	CTDVString sModeratorAccess;
	moderatorBuilder.OpenTag("MODERATOR", true);
	if (!SP.IsEOF())
	{
		int iIsModerator = SP.GetIntField("IsModerator");
		moderatorBuilder.AddIntAttribute("ISMODERATOR", iIsModerator, true);
		moderatorBuilder.OpenTag("USER");
		int iUserID = 0;
		moderatorBuilder.DBAddIntTag("USERID","USERID",false,&iUserID);
		moderatorBuilder.DBAddTag("UserName", "USERNAME",false);
		moderatorBuilder.DBAddTag("FirstNames","FIRSTNAMES",false);
		moderatorBuilder.DBAddTag("LastName","LASTNAME",false);
		moderatorBuilder.DBAddTag("email","EMAIL",false);
		moderatorBuilder.CloseTag("USER");

		int iCurClassID = 0;
		int iCurSiteID = 0;

		CDBXMLBuilder classBuilder;
		CTDVString sClassXML;
		classBuilder.Initialise(&sClassXML);
		classBuilder.OpenTag("CLASSES");

		CDBXMLBuilder siteBuilder;
		CTDVString sSiteXML;
		siteBuilder.Initialise(&sSiteXML);
		siteBuilder.OpenTag("SITES");		

		while (!SP.IsEOF())
		{
			int iClassID = SP.GetIntField("SiteClassID");
			int iSiteID = SP.GetIntField("SiteID");

			bool bIsNullClassID = SP.IsNULL("SiteClassID");
			bool bIsNullSiteID = SP.IsNULL("SiteID");

			if (!bIsNullClassID && iCurClassID != iClassID)
			{
				classBuilder.AddIntTag("CLASSID", iClassID);
				iCurClassID = iClassID;
				m_vecModeratorClasses.push_back(iClassID);
			}

			if (!bIsNullSiteID && iCurSiteID != iSiteID)
			{
				siteBuilder.OpenTag("SITE", true);
				if (bIsNullClassID)
				{
					siteBuilder.AddIntAttribute("SITEID", iSiteID, true);
				}
				else
				{
					siteBuilder.AddIntAttribute("SITEID", iSiteID);
					siteBuilder.AddIntAttribute("CLASSID",iClassID, true);
				}
				siteBuilder.CloseTag("SITE");
				iCurSiteID = iSiteID;
			}
			SP.MoveNext();
		
		}
		siteBuilder.CloseTag("SITES");
		classBuilder.CloseTag("CLASSES");
		//siteBuilder.CloseTag("SITEID");
		sModeratorAccess << classBuilder << siteBuilder;
	}
	moderatorBuilder.CloseTag("MODERATOR", sModeratorAccess);
	return CreateFromXMLText(sModeratorXML);
}


bool CModeratorInfo::GetModeratorClasses(std::vector<int>& vecModeratorClasses)
{
	vecModeratorClasses = m_vecModeratorClasses;
	return true;
}