#include "stdafx.h"
#include ".\emailtemplate.h"

const CTDVString CEmailTemplate::m_EmailNames[]  = {
	"ContentRemovedEmail", 
	"ContentFailedAndEditedEmail",
	"UpholdComplaintEmail",
	"UpholdComplaintEditEntryEmail",
	"RejectComplaintEmail",
	"NicknameResetEmail",
    "UserComplaintEmail",
	/* And empty string so we can terminate the array.
	   Add new entries above this and update the associated
	   enum, EmailType, in the header */
	""
};

CEmailTemplate::CEmailTemplate(CInputContext& inputContext) : 
	CXMLObject(inputContext)
{
	int i = 0;
	while ( m_EmailNames[i].GetLength() != 0) 
	{
		m_ValidNamesSet.insert(m_EmailNames[i]);
		++i;
	}
}

CEmailTemplate::~CEmailTemplate(void)
{
}

/*********************************************************************************

	bool CEmailTemplate::FetchEmailText(int iSiteId, const char* pEmailName, 
		CTDVString& sSubject, CTDVString& sText)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailTemplate::FetchEmailText(const int iSearchID, const CTDVString sEmailName, 
	CTDVString& sSubject, CTDVString& sText, const bool bSearchOnModClassID)
{
	bool bRetVal = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	
	if (bSearchOnModClassID)
	{
		bRetVal = SP.FetchEmailTemplate(0, sEmailName, iSearchID);
	}
	else 
	{
		bRetVal = SP.FetchEmailTemplate(iSearchID, sEmailName, -1);
	}

	if ( !SP.IsEOF() )
	{
		SP.GetField("Subject", sSubject);
		SP.GetField("Body", sText);
	}

	return bRetVal;
}

bool CEmailTemplate::FetchInsertText(const int iSearchID, const CTDVString sInsertName,
	CTDVString& sInsertText)
{
	bool bRetVal = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	bRetVal = SP.GetEmailInsert(iSearchID, sInsertName);

	if (!SP.IsEOF())
	{
		SP.GetField("InsertText", sInsertText);
	}

	return bRetVal;
}

/*********************************************************************************

	bool CEmailTemplate::GetEmail(int iSiteID, const CTDVString& sEmailName, 
		const CEmailVocab& emailVocab, const CSubst& substitutions, CTDVString& sSubject, 
		CTDVString& sText)

		Author:		David Williams
        Created:	02/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailTemplate::GetEmail(const int iSiteID, const CTDVString& sEmailName,
	const CEmailVocab& emailVocab, const CSubst& substitutions, 
	CTDVString& sSubject, CTDVString& sText)
{
	bool bRetVal = true;

	if (!FetchEmailText(iSiteID, sEmailName, sSubject, sText))
	{
		return false;
	}

	/* example usage - but how are the substitution strings handled */
	CTDVString sSubstitution;
	CTDVString sToSub;
	sSubstitution = emailVocab.GetSubstitution(iSiteID, sToSub /*What should go here?*/, sSubstitution);

	//Now do the same as before
	CTDVString sTmpSubject;
	CTDVString sTmpText;
	for (CSubst::const_iterator it = substitutions.begin(); it != substitutions.end(); it++)
	{
		if (it->first.Find("+++**") == 0)
		{
			if (!FetchEmailText(iSiteID, sEmailName, sTmpSubject, sTmpText))
			{
				return false;
			}
			sText.Replace( ((const char*)it->first) + 1, sTmpText);
			sSubject.Replace(it->first, it->second);
		}
	}

	for (CSubst::const_iterator it = substitutions.begin(); it != substitutions.end(); it++)
	{
		sText.Replace(it->first, it->second);
		sSubject.Replace(it->first, it->second);
	}
	return bRetVal;
}

/*********************************************************************************

	bool CEmailTemplate::AddNewEmailTemplate(int iModClassID, const CTDVString& sEmailName,	
		const CTDVString& sSubject, const CTDVString& sText)

		Author:		David Williams
        Created:	02/12/2004
        Inputs:		iModClassID
					sEmailName
					sSubject
					sText
        Outputs:	-
        Returns:	-
        Purpose:	Add a new email template to a particular moderation class

*********************************************************************************/
bool CEmailTemplate::AddNewEmailTemplate(const int iModClassID, const CTDVString& sEmailName, 
	const CTDVString& sSubject, const CTDVString& sText)
{
	if (!ValidateName("AddNewEmailTemplate", "InvalidName", sEmailName))
	{
		return false;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.AddNewEmailTemplate(iModClassID, sEmailName, sSubject, sText);
}

/*********************************************************************************

	bool CEmailTemplate::UpdateEmailTemplate(int iModClassID, const CTDVString& sEmailName,	
		const CTDVString& sSubject, const CTDVString& sText)

		Author:		David Williams
        Created:	02/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailTemplate::UpdateEmailTemplate(const int iModClassID, const CTDVString& sEmailName,	
	const CTDVString& sSubject, const CTDVString& sText)
{
	if (!ValidateName("UpdateEmailTemplate", "InvalidName", sEmailName))
	{
		return false;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.UpdateEmailTemplate(iModClassID, sEmailName, sSubject, sText);
}

/*********************************************************************************

	bool CEmailTemplate::RemoveEmailTemplate(int iModClassID, const CTDVString& sEmailName)

		Author:		David Williams
        Created:	02/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailTemplate::RemoveEmailTemplate(const int iModClassID, const CTDVString& sEmailName)
{
	if (!ValidateName("RemoveEmailTemplate", "InvalidName", sEmailName))
	{
		return false;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.RemoveEmailTemplate(iModClassID, sEmailName);;
}

/*********************************************************************************

	bool CEmailTemplate::IsValidInsertName(const CTDVString& sName)

		Author:		David Williams
        Created:	04/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CEmailTemplate::IsValidInsertName(const CTDVString& sName)
{
	return (m_ValidNamesSet.find(sName) != m_ValidNamesSet.end());
}

bool CEmailTemplate::ValidateName(const CTDVString& sCallee, const CTDVString& sCode, const CTDVString& sName)
{
	if (!IsValidInsertName(sName))
	{
		CTDVString sReason = "Name '$' supplied not in list of valid options";
		sReason.Replace("$", sName);
		SetDNALastError(sCallee, sCode, sReason);
		return false;
	}
	return true;
}

/******************************************************************************
*																			  *
*                                                                             *
*                                                                             *
*                                                                             *
******************************************************************************/


CEmailTemplates::CEmailTemplates(CInputContext& inputContext, int iViewID, CTDVString& sViewObject) :
	CXMLObject(inputContext), m_iViewID(iViewID), m_sViewObject(sViewObject)
{
	
}

CEmailTemplates::~CEmailTemplates()
{
}

bool CEmailTemplates::GetEmailTemplates(std::vector<CEmailTemplate>& emailTemplates)
{
	return true;
}

bool CEmailTemplates::GetAsString(CTDVString& sResult)
{
	CDBXMLBuilder templatesBuilder;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	
	templatesBuilder.Initialise(&sResult, &SP);
	SP.GetEmailTemplates(m_iViewID, m_sViewObject);
	
	templatesBuilder.OpenTag("EMAIL-TEMPLATES");
	while (!SP.IsEOF())
	{
		templatesBuilder.OpenTag("EMAIL-TEMPLATE", true);
		templatesBuilder.DBAddIntAttribute("ModClassID", "ModID", false);
		templatesBuilder.DBAddIntAttribute("AutoFormat");
		templatesBuilder.DBAddIntAttribute("EmailTemplateID", NULL, false, true);
		templatesBuilder.DBAddIntTag("ModClassID");
		templatesBuilder.DBAddTag("Name");
		templatesBuilder.DBAddTag("Subject");
		templatesBuilder.DBAddTag("Body");		
        templatesBuilder.CloseTag("EMAIL-TEMPLATE");
		SP.MoveNext();
	}
	templatesBuilder.CloseTag("EMAIL-TEMPLATES");

	return true;
}


bool CEmailTemplates::CreateEmailTemplateSet()
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.CreateEmailTemplateSet(m_iModClassID);
}

int CEmailTemplates::GetEmailTemplateIDByName(const CTDVString& sTemplateName)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	int iTemplateID = 0;
	SP.GetEmailTemplateIDByName(m_iViewID, m_sViewObject, sTemplateName, iTemplateID);
	return iTemplateID;
}

