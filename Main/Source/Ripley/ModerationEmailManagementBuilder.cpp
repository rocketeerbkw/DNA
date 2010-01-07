#include "stdafx.h"
#include ".\moderationemailmanagementbuilder.h"
#include ".\storedprocedure.h"
#include ".\emailtemplate.h"
#include ".\emailvocab.h"
#include ".\moderationclasses.h"
#include ".\basicsitelist.h"


CModerationEmailManagementBuilder::CModerationEmailManagementBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext), 
	m_emailInserts(inputContext),
	m_iAccessID(0), 
	m_iViewID(0),
	m_sViewObject("all"), 
	m_sAccessObject(""),
	m_sViewType("default"),
	m_iViewTypeID(0),
	m_iClassID(0),
	m_iSiteID(0),
	m_iSavedClassID(0)
{
}

CModerationEmailManagementBuilder::~CModerationEmailManagementBuilder(void)
{
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::Build(CWholePage* pPage)

		Author:		David Williams
        Created:	11/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Display Moderation Classes
					Display Associated Sites
					Display list of email templates for the mod class.
					The ModerationManagementBuilder class displays the same thing.

*********************************************************************************/
bool CModerationEmailManagementBuilder::Build(CWholePage* pPage)
{
	bool bResult = true;
	m_pPage = pPage;
	InitPage(m_pPage, "MOD-EMAIL-MANAGEMENT", true);

	m_pViewer = m_InputContext.GetCurrentUser();
	
	if (m_pViewer == NULL)
	{
		SetDNALastError("CModerrationEmailManagementBuilder", "MustBeLoggedIn", "The user must be logged in");
		return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// This builder can only be used by a moderator	
	if (!m_pViewer->GetIsSuperuser())
	{
		SetDNALastError("CModerationEmailManagementBuilder", "InsufficientAccessRights", "The active user requires moderator access rights.");
		return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}	

	//this method sets up some member variables indicating the
	//class/site we are looking at, as chosen by the client
	GetModeratorViewParameters();

	// we will also make use of email templates in one way or another
	CEmailTemplates emailTemplates(m_InputContext, m_iViewID, m_sViewObject);
	// and email inserts.
	m_emailInserts.Initialise(m_iViewID, m_sViewObject);

	// there are a number of activities that can be performed on the templates
	CTDVString sNextAction = "default";
	CTDVString sStatus = "";
	
	CTDVString sAction = "";
	CTDVString sTemplateName = "";
	CTDVString sInsertName = "";
	CTDVString sSelectedSite = "0";

	//default values
	m_sViewType = m_sViewObject;
	m_iViewTypeID = m_iViewID;

	CTDVString sSiteXML;
	BuildSitesList(sSiteXML);
	pPage->AddInside("H2G2", sSiteXML);
	
	int iModClassId = m_InputContext.GetParamInt("modclassid");
	if (m_InputContext.ParamExists("action"))
	{
		m_InputContext.GetParamString("action", sAction);
		m_InputContext.GetParamString("emailtemplatename", sTemplateName);
		m_InputContext.GetParamString("insertname", sInsertName);

		CEmailTemplate emailTemplate(m_InputContext);

		sAction.MakeLower();
		if (sAction.CompareText("removeemail"))
		{
			sNextAction = "default";
			m_sViewType = "removeemail";
			m_iViewTypeID = m_InputContext.GetParamInt("emailtemplateid");
			if ( iModClassId == 0 || sTemplateName.IsEmpty() )
				sStatus = sTemplateName + " not removed";
			else if ( emailTemplate.RemoveEmailTemplate(iModClassId, sTemplateName) )
				sStatus = sTemplateName + " has been removed";
		}
		if (sAction.CompareText("editemail"))
		{
			sStatus = sTemplateName + " being edited";
			sNextAction = "editemail";
			m_sViewType = "editemail";
			m_iViewTypeID = m_InputContext.GetParamInt("emailtemplateid"); 
		}
		if (sAction.CompareText("editinsert"))
		{
			sStatus = sInsertName + " being edited";
			sNextAction = "editinsert";
			m_sViewType = "editinsert";
			m_iSiteID = m_iViewID;
			m_iViewTypeID = m_InputContext.GetParamInt("insertid");
			
		}
		if (sAction.CompareText("removeinsert"))
		{
			sStatus = sInsertName + " removed";
			sNextAction = "removeinsert";
			m_sViewType = "removeinsert";
			m_iViewTypeID = m_InputContext.GetParamInt("insertid");
			if (m_sViewObject.CompareText("site"))
			{
				m_emailInserts.RemoveSiteEmailInsert(m_iViewID, sInsertName);
			}
			else
			{
				m_emailInserts.RemoveModClassEmailInsert(m_iViewID, sInsertName);
			}
		}
	}

	if (m_InputContext.ParamExists("createnewemail"))
	{
		sStatus = "Creating new email template";
		sNextAction  = "createnewemail";
		m_sViewType = "createnewemail";
		if (m_sViewObject.CompareText("class")) 
		{
			m_iViewTypeID = m_iViewID;
		}
		else
		{
			m_iViewTypeID = m_iSavedClassID;
		}
		
	}
	if (m_InputContext.ParamExists("saveandreturnhome"))
	{
		sNextAction = "default";
		//save the email and return back
		m_InputContext.GetParamString("action", sAction);
		if (sAction.CompareText("save"))
		{
			bResult = bResult && SaveEmail();		
		}
		else 
		{
			bResult = bResult && SaveEmail(false);
		}
		m_sViewType = "default";
		m_iViewTypeID = 0;
	}
	if (m_InputContext.ParamExists("saveandcreatenew"))
	{
		sNextAction = "createnewemail";
		m_InputContext.GetParamString("action", sAction);
		if (sAction.CompareText("save"))
		{
			bResult = bResult && SaveEmail();		
		}
		else 
		{
			bResult = bResult && SaveEmail(false);
		}
		m_sViewType = "createnewemail";
		m_iViewTypeID = m_iViewID;
	}
	if (m_InputContext.ParamExists("insertsaveandreturnhome"))
	{
		sNextAction = "default";
		bResult = bResult && CreateEmailInsert();
		m_sViewType = "default";
	}
	if (m_InputContext.ParamExists("insertsaveandcreatenew"))
	{
		sNextAction = "createinsert";
		m_sViewType = "createinsert";
		bResult = bResult && CreateEmailInsert();
		if (m_sViewType.CompareText("class"))
		{
			m_iClassID = m_iViewTypeID;
		}
		else
		{
			m_iSiteID = m_iViewTypeID;
		}
	}
	if (m_InputContext.ParamExists("insertcreate"))
	{
		sNextAction = "createinsert";
		if (m_sViewType.CompareText("class"))
		{
			m_iClassID = m_iViewTypeID;
		}
		else
		{
			m_iSiteID = m_iViewTypeID;
		}
		m_sViewType = "createinsert";
	}

	pPage->AddInside("H2G2", "<MOD-EMAIL-PAGE PAGE='" + sNextAction + "'></MOD-EMAIL-PAGE>");
	pPage->AddInside("H2G2/MOD-EMAIL-PAGE", "<SELECTED-TEMPLATE>" + sTemplateName + "</SELECTED-TEMPLATE>");
	pPage->AddInside("H2G2/MOD-EMAIL-PAGE", "<SELECTED-INSERT>" + sInsertName + "</SELECTED-INSERT>");
	pPage->AddInside("H2G2/MOD-EMAIL-PAGE", "<PAGE-STATUS>" + sStatus + "</PAGE-STATUS>");
	CTDVString sModClass = "<SELECTED-MOD-CLASS>";
	sModClass << iModClassId << "</SELECTED-MOD-CLASS>";
	pPage->AddInside("H2G2/MOD-EMAIL-PAGE", sModClass);
	pPage->AddInside("H2G2/MOD-EMAIL-PAGE", "<SELECTED-SITE>" + sSelectedSite + "</SELECTED-SITE>");

	CTDVString sEmailTemplates;	
	emailTemplates.GetAsString(sEmailTemplates);
	pPage->AddInside("H2G2", sEmailTemplates);

	CTDVString sEmailInserts;
	m_emailInserts.GetAsString(sEmailInserts);
	m_emailInserts.GetUpdatedModViewParams(m_sViewType, m_iViewTypeID);
	pPage->AddInside("H2G2", sEmailInserts);

	CTDVString sModView;
	GetModeratorView(sModView);
	pPage->AddInside("H2G2", sModView);

	CTDVString sClassXML;
	BuildModerationClassesList(sClassXML);
	pPage->AddInside("H2G2", sClassXML);

	CTDVString sEmailInsertGroups;
	GetEmailInsertGroups(sEmailInsertGroups);
	pPage->AddInside("H2G2", sEmailInsertGroups);

	CTDVString sInsertTypes;
	sInsertTypes = "<INSERT-TYPES>";
	sInsertTypes += "<TYPE>inserted_text</TYPE>";
	sInsertTypes += "<TYPE>content_type</TYPE>";
	sInsertTypes += "<TYPE>add_content_method</TYPE>";
	sInsertTypes += "<TYPE>content_url</TYPE>";
	sInsertTypes += "<TYPE>content_subject</TYPE>";
	sInsertTypes += "<TYPE>content_text</TYPE>";
	sInsertTypes += "<TYPE>reference_number</TYPE>";
	sInsertTypes += "<TYPE>nickname</TYPE>";
	sInsertTypes += "<TYPE>userid</TYPE>";
	sInsertTypes += "</INSERT-TYPES>";
	pPage->AddInside("H2G2", sInsertTypes);

	if (!bResult)
	{
		CTDVString sErrMsg;
		GetLastErrorAsXMLString(sErrMsg);
		pPage->AddInside("H2G2", sErrMsg);
	}

	return true;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::SaveEmail(void)

		Author:		David Williams
        Created:	11/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CModerationEmailManagementBuilder::SaveEmail(bool bSave)
{
	bool bResult = false;
	CTDVString sName = "";
	CTDVString sSubject = "";
	CTDVString sBody = "";

	m_InputContext.GetParamString("name", sName);
	m_InputContext.GetParamString("subject", sSubject);
	m_InputContext.GetParamString("body", sBody);

	CXMLObject::EscapeAllXML(&sName);
	CXMLObject::EscapeAllXML(&sSubject);
	CXMLObject::EscapeAllXML(&sBody);

	int iModClassID = m_InputContext.GetParamInt("modclassid");

	CEmailTemplate emailTemplate(m_InputContext);
	if (bSave)
	{
		bResult = emailTemplate.AddNewEmailTemplate(iModClassID, sName, sSubject, sBody);
	}
	else 
	{
		bResult = emailTemplate.UpdateEmailTemplate(iModClassID, sName, sSubject, sBody);
	}
	return bResult;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::BuildModerationClassesList(CTDVString& sClassXML)

		Author:		David Williams
        Created:	11/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CModerationEmailManagementBuilder::BuildModerationClassesList(CTDVString& sClassXML)
{
	CModerationClasses modClasses(m_InputContext);
	modClasses.GetModerationClasses();
	modClasses.GetAsString(sClassXML);
	return true;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::BuildSitesList(CTDVString& sSiteXML)

		Author:		David Williams
        Created:	11/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CModerationEmailManagementBuilder::BuildSitesList(CTDVString& sSiteXML)
{
	bool bSaveClassID = false;
	if (m_sViewObject.CompareText("site"))
	{
		bSaveClassID = true;
	}

	CBasicSiteList sitelist(m_InputContext);
	if ( sitelist.PopulateList() )
	{
		if ( bSaveClassID )
		{
			//Get site ModClassId
			CSite* pSite = sitelist.GetSite(m_iViewID);
			if ( pSite )
				m_iSavedClassID = pSite->GetModerationClassId();
		}
		sSiteXML = sitelist.GetAsXML2();
	}
	else
	{
		SetDNALastError("CModerationEmailManagementBuilder::BuildSitesList","BuildSitesList","Unable to get sites list.");
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::GetModeratorView(CTDVString& sModView)

		Author:		David Williams
        Created:	21/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Indicates to the skin the current mode to display

					viewtype			viewid			displayed
					--------			------			-----------
					default				0				default view
					createnewemail		id of class		form for creation of new email template
					createinsert		id of site		form for creation of new insert
					editemail			id of email		form for editing email template
					editinsert			id of insert	form for editing email insert
					removeemail			id of email		confirmation dialog
					removeinsert		id of insert	confirmation dialog

*********************************************************************************/
bool CModerationEmailManagementBuilder::GetModeratorView(CTDVString& sModView)
{
	CDBXMLBuilder xml;
	xml.Initialise(&sModView);
	xml.OpenTag("MODERATOR-VIEW",true);
	xml.AddAttribute("VIEWTYPE", m_sViewType);
	xml.AddIntAttribute("VIEWID", m_iViewTypeID, false);
	xml.AddIntAttribute("SITEID", m_iSiteID, false);
	xml.AddIntAttribute("CLASSID", m_iClassID, true);
	xml.CloseTag("MODERATOR-VIEW");	
	return true;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::GetModeratorViewParameters()

		Author:		David Williams
        Created:	21/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CModerationEmailManagementBuilder::GetModeratorViewParameters()
{
	if (!m_InputContext.GetParamString("view", m_sViewObject))
	{
		m_sViewObject = "all";
	}

	m_iViewID = m_InputContext.GetParamInt("viewid");
	m_InputContext.GetParamString("accessobject", m_sAccessObject);

	m_iAccessID = 0;
	if (m_sAccessObject.FindText("class") == 0)
	{
		m_iAccessID = atoi(m_sAccessObject.Mid(5));
		m_sAccessObject = "class";
	}
	else if (m_sAccessObject.FindText("site") == 0)
	{
		m_iAccessID = atoi(m_sAccessObject.Mid(4));
		m_sAccessObject = "site";
	}
	else
	{
		m_sAccessObject.Empty();
	}
	return true;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::CreateEmailInsert()

		Author:		David Williams
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CModerationEmailManagementBuilder::CreateEmailInsert()
{
	bool bResult = true;
	CTDVString sInsertName;
	CTDVString sInsertGroup;
	CTDVString sNewInsertGroup;
	CTDVString sClassInsertText;
	CTDVString sSiteInsertText;
	CTDVString sInsertText = "";
	CTDVString sDuplicateToClass;
	CTDVString sState;
	CTDVString sSiteID;
	CTDVString sReasonDescription = "";
		
	m_InputContext.GetParamString("InsertName", sInsertName);
	m_InputContext.GetParamString("InsertGroup", sInsertGroup);
	m_InputContext.GetParamString("NewInsertGroup", sNewInsertGroup);
	m_InputContext.GetParamString("ClassInsertText", sClassInsertText);
	m_InputContext.GetParamString("SiteInsertText", sSiteInsertText);
	m_InputContext.GetParamString("DuplicateToClass", sDuplicateToClass);
	m_InputContext.GetParamString("ReasonDescription", sReasonDescription);
	m_InputContext.GetParamString("state", sState);

	CXMLObject::EscapeAllXML(&sInsertName);
	CXMLObject::EscapeAllXML(&sInsertGroup);
	CXMLObject::EscapeAllXML(&sNewInsertGroup);
	CXMLObject::EscapeAllXML(&sClassInsertText);
	CXMLObject::EscapeAllXML(&sSiteInsertText);
	
	CTDVString sGroup = sInsertGroup;
	if (sInsertGroup.GetLength() == 0 && 
		sNewInsertGroup.GetLength() != 0)
	{
		sGroup = sNewInsertGroup;
	}

	if (sDuplicateToClass.CompareText("on"))
	{
		int iModClassID = m_InputContext.GetParamInt("modclassid");
		if (sState.CompareText("create"))
		{
			bResult = m_emailInserts.AddModClassEmailInsert(m_iViewID, sInsertName, sGroup, sClassInsertText, sReasonDescription);
		}
		else
		{
			bResult = m_emailInserts.UpdateModClassEmailInsert(iModClassID, sInsertName, sGroup, sClassInsertText, sReasonDescription);
		}
	}
	else 
	{
		int iSite = m_InputContext.GetParamInt("siteid");
		if (sState.CompareText("create"))
		{
			bResult = m_emailInserts.AddSiteEmailInsert(m_iViewID, sInsertName, sGroup, sSiteInsertText, sReasonDescription);
		}
		else
		{
			bResult = m_emailInserts.UpdateSiteEmailInsert(iSite, sInsertName, sGroup, sSiteInsertText, sReasonDescription);
		}
	}

	if (!bResult)
	{
		CTDVString sErrMsg;
		CTDVString sErrCode;
		m_emailInserts.GetLastErrorMessage(sErrMsg);
		sErrCode = m_emailInserts.GetLastErrorCode();
		SetDNALastError("CreateEmailInsert", sErrCode, sErrMsg);
	}
	
	return bResult;
}

/*********************************************************************************

	bool CModerationEmailManagementBuilder::UpdateEmailInsert()

		Author:		David Williams
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CModerationEmailManagementBuilder::UpdateEmailInsert()
{
	bool bResult = true;
	CTDVString sInsertName;
	CTDVString sInsertGroup;
	CTDVString sNewInsertGroup;
	CTDVString sClassInsertText;
	CTDVString sSiteInsertText;
	CTDVString sInsertText = "";
	CTDVString sDuplicateToClass;
	CTDVString sState;
	CTDVString sReasonDescription = "";

	m_InputContext.GetParamString("InsertName", sInsertName);
	m_InputContext.GetParamString("InsertGroup", sInsertGroup);
	m_InputContext.GetParamString("NewInsertGroup", sNewInsertGroup);
	m_InputContext.GetParamString("ClassInsertText", sClassInsertText);
	m_InputContext.GetParamString("SiteInsertText", sSiteInsertText);
	m_InputContext.GetParamString("DuplicateToClass", sDuplicateToClass);
	m_InputContext.GetParamString("ReasonDescription", sReasonDescription);
	m_InputContext.GetParamString("state", sState);

	if (m_sViewObject.CompareText("class"))
	{
		//bResult = m_emailInserts.UpdateModClassEmailInsert(sInsertName, sInsertGroup, sInsertText);
	}
	else if (m_sViewObject.CompareText("site"))
	{
		bResult = m_emailInserts.UpdateSiteEmailInsert(m_iViewID, sInsertName, sInsertGroup, sInsertText, sReasonDescription);
	}
	else
	{
		bResult = SetDNALastError("UpdateEmailInsert", "InvalidOption", "Option other than class or site for view type specified.");
	}
	return bResult;
}

bool CModerationEmailManagementBuilder::GetEmailInsertGroups(CTDVString& sEmailInsertGroupsXML)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	SP.GetEmailInsertGroups();

	CDBXMLBuilder xml;
	xml.Initialise(&sEmailInsertGroupsXML, &SP);

	xml.OpenTag("EMAIL-INSERT-GROUPS");

	while (!SP.IsEOF())
	{
		xml.DBAddTag("InsertGroup", "GROUP");
		SP.MoveNext();
	}

	xml.CloseTag("EMAIL-INSERT-GROUPS");
	return true;
}






	
	


