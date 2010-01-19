#include "stdafx.h"
#include "./tdvassert.h"
#include "StoredProcedure.h"
#include "User.h"
#include "DBXMLBuilder.h"
#include ".\moderationclasses.h"
#include ".\moderatormanagementbuilder.h"
#include ".\basicsitelist.h"

CModeratorManagementBuilder::CModeratorManagementBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CModeratorManagementBuilder::~CModeratorManagementBuilder(void)
{
}

/*
	Actions available:
	Add a set of users/moderators to a class or site
	giveaccess=submit (button)
	accessobject=class1 (or site5 or allclasses)
	view=all|class|site
	viewid=ID
	userid=1...
*/

bool CModeratorManagementBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "MODERATOR-MANAGEMENT", true);

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL || !pViewingUser->GetIsSuperuser())
	{
		pPage->AddInside("H2G2","<ERROR TYPE='notsuperuser'>You must be a SuperUser to use this page</ERROR>");
		return true;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sViewObject;
	if (!m_InputContext.GetParamString("view", sViewObject))
	{
		sViewObject = "all";
	}
	int iViewID = m_InputContext.GetParamInt("viewid");

	CTDVString sAccessObject;
	m_InputContext.GetParamString("accessobject", sAccessObject);
	int iAccessID = 0;
	if (sAccessObject.FindText("class") == 0)
	{
		iAccessID = atoi(sAccessObject.Mid(5));
		sAccessObject = "class";
	}
	else if (sAccessObject.FindText("site") == 0)
	{
		iAccessID = atoi(sAccessObject.Mid(4));
		sAccessObject = "site";
	}
	else
	{
		sAccessObject.Empty();
	}

	if (m_InputContext.ParamExists("giveaccess"))
	{

		if (sAccessObject.GetLength() > 0)
		{
			// Collect all the userid parameters
			SP.StartAddUserToTempList();
			int iIndex = 0;
			for (iIndex = 0; m_InputContext.ParamExists("userid", iIndex); iIndex++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("userid", iIndex));
			}

			SP.GiveModeratorsAccess(sAccessObject, iAccessID);
			CTDVString sXML;
			CDBXMLBuilder remove;
			remove.Initialise(&sXML, &SP);
			remove.OpenTag("LASTACTION",true);
			remove.AddAttribute("TYPE", "GIVEACCESS", true);
			remove.OpenTag("USERS",true);
			remove.AddAttribute("ACCESSGIVENTO",sAccessObject, false);
			if (sAccessObject.CompareText("site"))
			{
				remove.AddIntAttribute("SITEID",iAccessID, true);
			}
			else
			{
				remove.AddIntAttribute("CLASSID",iAccessID, true);
			}
			while (!SP.IsEOF())
			{
				remove.OpenTag("USER");
				remove.DBAddIntTag("UserID", "USERID");
				remove.DBAddTag("Username", "USERNAME", false);
				remove.DBAddTag("email", "EMAIL", false);
				remove.CloseTag("USER");
				SP.MoveNext();
			}
			remove.CloseTag("USERS");
			remove.CloseTag("LASTACTION");
			pPage->AddInside("H2G2", sXML);
			SP.Release();
		}
	}
	else if (m_InputContext.ParamExists("removeclassaccess"))
	{
		TDVASSERT(sViewObject.CompareText("class"), "removeclassaccess requires 'class' as viewobject parameter");
		if (sViewObject.CompareText("class"))
		{
			// Collect all the userid parameters
			SP.StartAddUserToTempList();
			int iIndex = 0;
			for (iIndex = 0; m_InputContext.ParamExists("userid", iIndex); iIndex++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("userid", iIndex));
			}

			SP.RemoveModeratorAccess(sViewObject, iViewID);
			CTDVString sXML;
			CDBXMLBuilder remove;
			remove.Initialise(&sXML, &SP);
			remove.OpenTag("LASTACTION",true);
			remove.AddAttribute("TYPE", "REMOVEDUSERS", true);
			remove.OpenTag("REMOVEDUSERS",true);
			remove.AddAttribute("REMOVEDFROM","class", true);
			while (!SP.IsEOF())
			{
				remove.OpenTag("USER");
				remove.DBAddIntTag("UserID", "USERID");
				remove.DBAddTag("Username", "USERNAME", false);
				remove.DBAddTag("email", "EMAIL", false);
				remove.CloseTag("USER");
				SP.MoveNext();
			}
			remove.CloseTag("REMOVEDUSERS");
			remove.CloseTag("LASTACTION");
			pPage->AddInside("H2G2", sXML);
			SP.Release();
		}
	}
	else if (m_InputContext.ParamExists("removesiteaccess"))
	{
		TDVASSERT(sViewObject.CompareText("site"), "removesiteaccess requires 'site' as viewobject parameter");
		if (sViewObject.CompareText("site"))
		{
			// Collect all the userid parameters
			SP.StartAddUserToTempList();
			int iIndex = 0;
			for (iIndex = 0; m_InputContext.ParamExists("userid", iIndex); iIndex++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("userid", iIndex));
			}

			SP.RemoveModeratorAccess(sViewObject, iViewID);
			CTDVString sXML;
			CDBXMLBuilder remove;
			remove.Initialise(&sXML, &SP);
			remove.OpenTag("LASTACTION",true);
			remove.AddAttribute("TYPE", "REMOVEDUSERS", true);
			remove.OpenTag("REMOVEDUSERS",true);
			remove.AddAttribute("REMOVEDFROM","site", true);
			while (!SP.IsEOF())
			{
				remove.OpenTag("USER");
				remove.DBAddIntTag("UserID", "USERID");
				remove.DBAddTag("Username", "USERNAME", false);
				remove.DBAddTag("email", "EMAIL", false);
				remove.CloseTag("USER");
				SP.MoveNext();
			}
			remove.CloseTag("REMOVEDUSERS");
			remove.CloseTag("LASTACTION");
			pPage->AddInside("H2G2", sXML);
			SP.Release();
		}
	}
	else if (m_InputContext.ParamExists("removeallaccess"))
	{
		TDVASSERT(sAccessObject.CompareText("all"), "'removeallaccess' requested with incorrect accessobject");
		if (sViewObject.CompareText("all"))
		{
			// Collect all the userid parameters
			SP.StartAddUserToTempList();
			int iIndex = 0;
			for (iIndex = 0; m_InputContext.ParamExists("userid", iIndex); iIndex++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("userid", iIndex));
			}
			SP.RemoveModeratorAccess(sViewObject, iViewID);
			CTDVString sXML;
			CDBXMLBuilder remove;
			remove.Initialise(&sXML, &SP);
			remove.OpenTag("LASTACTION",true);
			remove.AddAttribute("TYPE", "REMOVEDUSERS", true);
			remove.OpenTag("REMOVEDUSERS",true);
			remove.AddAttribute("REMOVEDFROM","all", true);
			while (!SP.IsEOF())
			{
				remove.OpenTag("USER");
				remove.DBAddIntTag("UserID", "USERID");
				remove.DBAddTag("Username", "USERNAME", false);
				remove.DBAddTag("email", "EMAIL", false);
				remove.CloseTag("USER");
				SP.MoveNext();
			}
			remove.CloseTag("REMOVEDUSERS");
			remove.CloseTag("LASTACTION");
			pPage->AddInside("H2G2", sXML);
			SP.Release();
		}
	}
	else if (m_InputContext.ParamExists("finduser") || (m_InputContext.ParamExists("addmoderator") && (!m_InputContext.ParamExists("userid"))))
	{
		if (sViewObject.CompareText("all") || sViewObject.GetLength() == 0)
		{
			sViewObject="addmoderator";
		}
		// if the email parameter exists, find a user
		CTDVString sFindUserXML;
		CDBXMLBuilder finduserxml;
		finduserxml.Initialise(&sFindUserXML, &SP);
		finduserxml.OpenTag("LASTACTION", true); 
		finduserxml.AddAttribute("TYPE","ADDMODERATOR");
		finduserxml.OpenTag("ADDMODERATOR");
		CTDVString sEmail;
		if (m_InputContext.ParamExists("addmoderator") && !m_InputContext.ParamExists("userid"))
		{
			finduserxml.OpenTag("ERROR", true);
			finduserxml.AddIntAttribute("TYPE",3,true);
			finduserxml.CloseTag("ERROR","You must select a user");
		}
//		else if (m_InputContext.ParamExists("addmoderator") && !m_InputContext.ParamExists("toclass"))
//		{
//			finduserxml.OpenTag("ERROR", true);
//			finduserxml.AddIntAttribute("TYPE",2,true);
//			finduserxml.CloseTag("ERROR","You must select at least one class");
//		}
		
		// Find it again
		if (m_InputContext.GetParamString("email",sEmail))
		{
			finduserxml.AddTag("EMAIL",sEmail);
			// find the email
			if (sEmail.GetLength() > 0)
			{
				if (sEmail.Find("@") < 0 && (atoi(sEmail) > 0 || (sEmail.GetLength() > 1 && atoi(sEmail.Mid(1)) > 0)))
				{
					int iSearchUser = atoi(sEmail);
					if (iSearchUser == 0)
					{
						iSearchUser = atoi(sEmail.Mid(1));
					}
					SP.GetUserFromUserID(iSearchUser);
				}
				else
				{
					SP.FindUserFromEmail(sEmail);
				}
				if (!SP.IsEOF())
				{
					finduserxml.OpenTag("FOUNDUSERS");
					while (!SP.IsEOF())
					{
						finduserxml.OpenTag("USER");
						finduserxml.DBAddIntTag("UserID", "USERID");
						finduserxml.DBAddTag("USERNAME","USERNAME");
						finduserxml.DBAddTag("LoginName","LOGINNAME",false);
						finduserxml.DBAddTag("email","EMAIL");
						finduserxml.CloseTag("USER");
						SP.MoveNext();
					}
					finduserxml.CloseTag("FOUNDUSERS");
				}
				else
				{
					finduserxml.OpenTag("ERROR", true);
					finduserxml.AddIntAttribute("TYPE",1,true);
					finduserxml.CloseTag("ERROR","No matching users found");
				}
			}
		}
		// Add the ticked classes and sites
		finduserxml.OpenTag("ADDTO");
		finduserxml.OpenTag("ADDTOCLASSES");
		for (int i=0; m_InputContext.ParamExists("toclass", i); i++)
		{
			finduserxml.AddIntTag("CLASS", m_InputContext.GetParamInt("toclass", i));
		}
		finduserxml.CloseTag("ADDTOCLASSES");
		finduserxml.OpenTag("ADDTOSITES");
		for (int i=0; m_InputContext.ParamExists("tosite", i); i++)
		{
			finduserxml.AddIntTag("SITE", m_InputContext.GetParamInt("tosite", i));
		}
		finduserxml.CloseTag("ADDTOSITES");
		finduserxml.CloseTag("ADDTO");
		finduserxml.CloseTag("ADDMODERATOR");
		if (m_InputContext.ParamExists("finduser"))
		{
			finduserxml.CloseTag("LASTACTION");
		}
		else
		{
			finduserxml.CloseTag("LASTACTION");
		}
		pPage->AddInside("H2G2",sFindUserXML);

	}
	else if (m_InputContext.ParamExists("addmoderator"))
	{
		if (sViewObject.CompareText("all") || sViewObject.GetLength() == 0)
		{
			sViewObject="addmoderator";
		}
		// if the email parameter exists, find a user
		CTDVString sFindUserXML;
		CDBXMLBuilder finduserxml;
		finduserxml.Initialise(&sFindUserXML, &SP);
		finduserxml.OpenTag("LASTACTION", true); 
		finduserxml.AddAttribute("TYPE","ADDMODERATOR");
		finduserxml.OpenTag("ADDMODERATOR");
		CTDVString sEmail;
		m_InputContext.GetParamString("email", sEmail);
		finduserxml.AddTag("EMAIL",sEmail);
		if (m_InputContext.ParamExists("userid"))
		{
			int iUserID = m_InputContext.GetParamInt("userid");
			// Add the user to all selected classes
			SP.StartAddUserToTempList();
			for (int i=0; m_InputContext.ParamExists("toclass",i); i++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("toclass",i));
			}
			SP.AddNewModeratorToClasses(iUserID);
			finduserxml.OpenTag("MODERATOR-ADDED", true);
			finduserxml.AddIntAttribute("USERID", iUserID);
			finduserxml.AddIntAttribute("RESULT", 0, true);
			finduserxml.CloseTag("MODERATOR-ADDED", "User added successfully");

		}
		// Add the ticked classes and sites
		finduserxml.OpenTag("ADDTO");
		finduserxml.OpenTag("ADDTOCLASSES");
		for (int i=0; m_InputContext.ParamExists("toclass", i); i++)
		{
			finduserxml.AddIntTag("CLASS", m_InputContext.GetParamInt("toclass", i));
		}
		finduserxml.CloseTag("ADDTOCLASSES");
		finduserxml.OpenTag("ADDTOSITES");
		for (int i=0; m_InputContext.ParamExists("tosite", i); i++)
		{
			finduserxml.AddIntTag("SITE", m_InputContext.GetParamInt("tosite", i));
		}
		finduserxml.CloseTag("ADDTOSITES");
		finduserxml.CloseTag("ADDTO");
		finduserxml.CloseTag("ADDMODERATOR");
		finduserxml.CloseTag("LASTACTION");
		pPage->AddInside("H2G2",sFindUserXML);

	}
	else if (m_InputContext.ParamExists("updateuser"))
	{
		if (sViewObject.CompareText("all") || sViewObject.GetLength() == 0)
		{
			sViewObject = "user";
		}
		CTDVString sXML;
		CDBXMLBuilder xml;
		xml.Initialise(&sXML, &SP);
		xml.OpenTag("LASTACTION", true); 
		xml.AddAttribute("TYPE","UPDATEUSER");
		xml.OpenTag("ADDMODERATOR");
		CTDVString sEmail;
		m_InputContext.GetParamString("email", sEmail);
		xml.AddTag("EMAIL",sEmail);
		if (m_InputContext.ParamExists("userid"))
		{
			int iUserID = m_InputContext.GetParamInt("userid");
			// Add the user to all selected sites
			// Doesn't matter if there are no sites to add to - it will remove all currently registered sites
			SP.StartAddUserToTempList();
			for (int i=0; m_InputContext.ParamExists("tosite",i); i++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("tosite",i));
			}
			SP.AddNewModeratorToSites(iUserID);

			SP.StartAddUserToTempList();
			for (int i=0; m_InputContext.ParamExists("toclass",i); i++)
			{
				SP.AddUserToTempList(m_InputContext.GetParamInt("toclass",i));
			}
			SP.AddNewModeratorToClasses(iUserID);
			xml.OpenTag("MODERATOR-ADDED", true);
			xml.AddIntAttribute("USERID", iUserID);
			xml.AddIntAttribute("RESULT", 0, true);
			xml.CloseTag("MODERATOR-ADDED", "User added successfully");
		}
		// Add the ticked classes and sites
		xml.OpenTag("ADDTO");
		xml.OpenTag("ADDTOCLASSES");
		for (int i=0; m_InputContext.ParamExists("toclass", i); i++)
		{
			xml.AddIntTag("CLASS", m_InputContext.GetParamInt("toclass", i));
		}
		xml.CloseTag("ADDTOCLASSES");
		xml.OpenTag("ADDTOSITES");
		for (int i=0; m_InputContext.ParamExists("tosite", i); i++)
		{
			xml.AddIntTag("SITE", m_InputContext.GetParamInt("tosite", i));
		}
		xml.CloseTag("ADDTOSITES");
		xml.CloseTag("ADDTO");
		xml.CloseTag("ADDMODERATOR");
		xml.CloseTag("LASTACTION");
		pPage->AddInside("H2G2",sXML);

	}
	else if (m_InputContext.ParamExists("changesiteclass"))
	{
		// expects:
		//			view='site'
		//			viewid = site ID
		//			classid = new class ID
		int iClassID = m_InputContext.GetParamInt("classid");
		if (iClassID > 0)
		{
			SP.ChangeModerationClassOfSite(iViewID, iClassID);
			if (!SP.IsEOF())
			{
				int iResult = SP.GetIntField("Result");
				CTDVString sReason;
				SP.GetField("Reason",sReason);
				CTDVString sChangeXML = "<LASTACTION TYPE='CHANGESITECLASS'><CHANGESITEMODERATIONCLASS RESULT='";
				sChangeXML << iResult << "'";

				if (iResult > 0)
				{
					sChangeXML << " REASON='" << sReason << "'";
				}
				sChangeXML << "/></LASTACTION>";
				pPage->AddInside("H2G2", sChangeXML);
			}
		}
	}
	else if (m_InputContext.ParamExists("createnewclass"))
	{
		// expects:
		//			view=createnewclass
		//			classname = something
		//			classdescription = something
		//			basedonclass = other class id
		int iBasedOnClass = m_InputContext.GetParamInt("basedonclass");
		if (iBasedOnClass > 0)
		{
			CTDVString sNewClassName;
			CTDVString sDescription;
			m_InputContext.GetParamString("classname", sNewClassName);
			m_InputContext.GetParamString("classdescription", sDescription);
			SP.CreateNewModerationClass(sNewClassName, sDescription, iBasedOnClass);
			CTDVString sCreateXML = "<LASTACTION TYPE='CREATENEWCLASS'><CREATENEWMODERATIONCLASS RESULT='";
			if (SP.IsEOF())
			{
				sCreateXML << "-1' REASON='unknown'/>";
			}
			else
			{
				int iResult = SP.GetIntField("Result");
				CTDVString sReason;
				SP.GetField("Reason", sReason);
				sCreateXML << iResult << "'";
				sCreateXML << " REASON='" << sReason << "'";
				if (!SP.IsNULL("ModClassID"))
				{
					sCreateXML << " CLASSID='" << SP.GetIntField("ModClassID") << "'";
				}
				sCreateXML << "/></LASTACTION>";
				pPage->AddInside("H2G2", sCreateXML);
			}
		}
	}
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString sModList;
	CTDVString sClasses;
	CTDVString sSites;
	CDBXMLBuilder xml;
	xml.Initialise(&sModList, &SP);

	CDBXMLBuilder ClassXML;
	ClassXML.Initialise(&sClasses);
	CDBXMLBuilder SiteXML;
	SiteXML.Initialise(&sSites);

	xml.OpenTag("MODERATOR-VIEW",true);
	xml.AddAttribute("VIEWTYPE", sViewObject);
	xml.AddIntAttribute("VIEWID", iViewID, true);
	xml.CloseTag("MODERATOR-VIEW");	
	pPage->AddInside("H2G2", sModList);
	sModList.Empty();	

	SP.GetFullModeratorList();
	int iCurUserID = 0;
	int iCurClassID = 0;
	int iCurSiteID = 0;
	xml.OpenTag("MODERATOR-LIST");
//	xml.AddAttribute("VIEWTYPE", sViewObject);
//	xml.AddIntAttribute("VIEWID", iViewID, true);
	// open the Moderator element if there's at least one entry in the list
	if (!SP.IsEOF())
	{
		OpenModerator(xml,SP, iCurUserID, iCurClassID, iCurSiteID, ClassXML, SiteXML);
	}

	while (!SP.IsEOF())
	{
		if (SP.GetIntField("UserID") != iCurUserID)
		{
			CloseModerator(xml,SP, ClassXML, SiteXML);
			OpenModerator(xml,SP, iCurUserID, iCurClassID, iCurSiteID, ClassXML, SiteXML);
		}
		
		int classID = SP.GetIntField("ModClassID");
		int SiteID = SP.GetIntField("SiteID");
		bool bNullClassID = SP.IsNULL("ModClassID");
		bool bNullSiteID = SP.IsNULL("SiteID");
		
		if (!bNullClassID && iCurClassID != classID)
		{
			ClassXML.AddIntTag("CLASSID", classID);
			iCurClassID = classID;
		}

		if (!bNullSiteID && iCurSiteID != SiteID)
		{
			SiteXML.OpenTag("SITE", true);
			if (bNullClassID)
			{
				SiteXML.AddIntAttribute("SITEID", SiteID, true);
			}
			else
			{
				SiteXML.AddIntAttribute("SITEID", SiteID);
				SiteXML.AddIntAttribute("CLASSID",classID, true);
			}
			SiteXML.CloseTag("SITE");
			iCurSiteID = SiteID;
		}
		SP.MoveNext();
	}
	CloseModerator(xml,SP, ClassXML, SiteXML);
	SP.Release();
	pPage->AddInside("H2G2", sModList);
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	//Get sites moderation details - ( user is superuser so will get all sites )
	CModerationClasses ModClasses(m_InputContext);
	ModClasses.GetModerationClasses();
	pPage->AddInside("H2G2",&ModClasses);
	CTDVString sSiteXML;
	
	CBasicSiteList sitemoddetails(m_InputContext);
	if ( sitemoddetails.PopulateList() )
		pPage->AddInside("H2G2", sitemoddetails.GetAsXML2() );
	else if ( sitemoddetails.ErrorReported() )
		pPage->AddInside("H2G2",sitemoddetails.GetLastErrorAsXMLString());

	return true;
}

bool CModeratorManagementBuilder::OpenModerator(CDBXMLBuilder& xml, CStoredProcedure& SP, int& iCurUserID, int& iCurClassID, int& iCurSiteID, CDBXMLBuilder& ClassXML, CDBXMLBuilder& SiteXML)
{
	// We Know they are on the list of official moderators, if the ModID field is not null
	int IsModerator = SP.GetIntField("IsModerator");
	xml.OpenTag("MODERATOR",true);
	xml.AddIntAttribute("ISMODERATOR", IsModerator, true);
	// all the username gubbins
	xml.OpenTag("USER");
	xml.DBAddIntTag("UserID","USERID",false, &iCurUserID);
	iCurClassID = 0;
	iCurSiteID = 0;
	xml.DBAddTag("UserName", "USERNAME",false);
	xml.DBAddTag("FirstNames","FIRSTNAMES",false);
	xml.DBAddTag("LastName","LASTNAME",false);
	xml.DBAddTag("email","EMAIL",false);
	xml.CloseTag("USER");

	ClassXML.Clear();
	ClassXML.OpenTag("CLASSES");
	SiteXML.Clear();
	SiteXML.OpenTag("SITES");
	return true;
}

bool CModeratorManagementBuilder::CloseModerator(CDBXMLBuilder& xml, CStoredProcedure& SP, CDBXMLBuilder& ClassXML, CDBXMLBuilder& SiteXML)
{
	// Now dump in the class and site information
	ClassXML.CloseTag("CLASSES");
	SiteXML.CloseTag("SITES");
	CTDVString sXML;
	sXML << ClassXML;
	sXML << SiteXML;
	xml.CloseTag("MODERATOR", sXML);
	return true;
}