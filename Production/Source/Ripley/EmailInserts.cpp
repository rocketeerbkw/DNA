#include "stdafx.h"
#include ".\emailinserts.h"
#include ".\modreasons.h"
#include <algorithm>

/*
const CTDVString CEmailInserts::m_InsertNames[] = 
{
	"None",
	"OffensiveInsert",
	"LibelInsert",
	"URLInsert",
	"PersonalInsert",
	"AdvertInsert",
	"CopyrightInsert",
	"PoliticalInsert",
	"IllegalInsert",
	"SpamInsert",
	"CustomInsert",
	"ForeignLanguage",
	""
};
*/

CEmailInserts::CEmailInserts(CInputContext& inputContext, const int iViewID, const CTDVString& sViewObject) :
	CXMLObject(inputContext), m_iViewID(iViewID), m_sViewObject(sViewObject)
{
	Initialise(iViewID, sViewObject);
}

CEmailInserts::CEmailInserts(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
}

void CEmailInserts::Initialise(const int iViewID, const CTDVString& sViewObject)
{
	m_iViewID = iViewID;
	m_sViewObject = sViewObject;
	//PopulateValidNamesSet();
}

void CEmailInserts::PopulateValidNamesSet()
{
	/*int i = 0;
	while ( m_InsertNames[i].GetLength() != 0) 
	{
		m_ValidNamesSet.insert(m_InsertNames[i]);
		++i;
	}
	*/

	CModReasons modReasons(m_InputContext);
	modReasons.GetModReasons(m_vecValidNames,0);

}

CEmailInserts::~CEmailInserts(void)
{
}

/*********************************************************************************

	bool AddSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText)

		Author:		David Williams
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::AddSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sReasonDescription)
{
	/*
	if (!ValidateName("AddSiteEmailInsert", "InvalidName", sName))
	{
		return false;
	}
	*/
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.AddSiteEmailInsert(iSiteID, sName, sGroup, sText, sReasonDescription);
}

/*********************************************************************************

	bool AddModClassEmailInsert(const int iModClassID, const CTDVString& sName, const CTDVString sGroup, const CTDVString& sText)

		Author:		David Williams
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::AddModClassEmailInsert(const int iModClassID, const CTDVString& sName, const CTDVString sGroup, const CTDVString& sText, const CTDVString& sReasonDescription)
{
	/*
	if (!ValidateName("AddModClassEmailInsert", "InvalidName", sName))
	{
		return false;
	}
	*/
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.AddModClassEmailInsert(iModClassID, sName, sGroup, sText, sReasonDescription);
}

/*********************************************************************************

	bool UpdateSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText)

		Author:		David Williams
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::UpdateSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sReasonDescription)
{
	/*
	if (!ValidateName("UpdateSiteEmailInsert", "InvalidName", sName))
	{
		return false;
	}
	*/

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.UpdateSiteEmailInsert(iSiteID, sName, sGroup, sText, sReasonDescription);
}

/*********************************************************************************

	bool UpdateModClassEmailInsert(const int iModClassID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText)

		Author:		David Williams
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::UpdateModClassEmailInsert(int iModClassID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sReasonDescription)
{
	/*
	if (!ValidateName("UpdateModClassEmailInsert", "InvalidName", sName))
	{
		return false;
	}
	*/

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	
	return SP.UpdateModClassEmailInsert(iModClassID, "class", sName, sGroup, sText, sReasonDescription);
}

/*********************************************************************************

	bool RemoveSiteEmailInsert(const int iSiteID, const CTDVString& sName)

		Author:		David Williams
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::RemoveSiteEmailInsert(const int iSiteID, const CTDVString& sName)
{
	/*
	if (!ValidateName("RemoveSiteEmailInsert", "InvalidName", sName))
	{
		return false;
	}
	*/
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.RemoveSiteEmailInsert(iSiteID, sName);
}

/*********************************************************************************

	bool RemoveModClassEmailInsert(const int iModClassID, const CTDVString& sName)

		Author:		David Williams
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::RemoveModClassEmailInsert(const int iModClassID, const CTDVString& sName)
{
	/*
	if (!ValidateName("RemoveModClassEmailInsert", "InvalidName", sName))
	{
		return false;
	}
	*/
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.RemoveModClassEmailInsert(iModClassID, sName);
}


/*********************************************************************************

	bool GetAsString(CTDVString& sResult)

		Author:		David Williams
		Created:	20/01/2005
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-
		
*********************************************************************************/
/* virtual */
bool CEmailInserts::GetAsString(CTDVString& sResult)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CDBXMLBuilder emailInsertsBuilder;
	emailInsertsBuilder.Initialise(&sResult, &SP);

	SP.GetEmailInserts(m_iViewID, m_sViewObject);
	
	CTDVString sInsertName = "";
	CTDVString sPrevInsertName = "";
	CTDVString sInsertGroup = "";
	CTDVString sPrevDefaultText = "";

	emailInsertsBuilder.OpenTag("EMAIL-INSERTS", false);
	iSiteID = 0;
	iModClassID = 0;
	bNullSiteID = false;
	bGetModClassID = true;
	iRequestedSiteID = 0;

	while (!SP.IsEOF())
	{
		if (bGetModClassID)
		{
			iModClassID = SP.GetIntField("ModClassID");
			bGetModClassID = false;
			iRequestedSiteID = SP.GetIntField("RequestedSiteID");
		}
		SP.GetField("InsertName", sInsertName);

		emailInsertsBuilder.OpenTag("EMAIL-INSERT", true);
		emailInsertsBuilder.DBAddIntAttribute("EmailInsertID", "ID", false);

		bNullSiteID = SP.IsNULL("SiteID");
		iSiteID = 0;
		if (!bNullSiteID)
		{
			iSiteID = SP.GetIntField("SiteID");
		}
		
		emailInsertsBuilder.DBAddIntAttribute("SiteID", "SiteID", false, true);		
				
		emailInsertsBuilder.DBAddTag("InsertName", "Name");
		emailInsertsBuilder.DBAddTag("DisplayName", "DisplayName");
		SP.GetField("InsertGroup", sInsertGroup);
		if (sInsertGroup.GetLength() != 0)
		{
			emailInsertsBuilder.DBAddTag("InsertGroup", "Group");
		}
		emailInsertsBuilder.DBAddTag("InsertText", "Text");
		
		SP.GetField("DefaultText", sPrevDefaultText);

		sPrevInsertName = sInsertName;
        SP.MoveNext();
		SP.GetField("InsertName", sInsertName);
		if (sPrevInsertName.CompareText(sInsertName))
		{
			emailInsertsBuilder.DBAddIntTag("ClassID");
			emailInsertsBuilder.DBAddTag("DefaultText");
			if (sInsertGroup.GetLength() == 0)
			{
				emailInsertsBuilder.DBAddTag("InsertGroup", "Group");
			}
			emailInsertsBuilder.CloseTag("EMAIL-INSERT");
			SP.MoveNext();
		}
		else
		{
			if (iSiteID == 0)
			{
				emailInsertsBuilder.AddIntTag("ClassID", iModClassID);
				emailInsertsBuilder.AddTag("DefaultText", sPrevDefaultText);
				if (sInsertGroup.GetLength() == 0)
				{
					emailInsertsBuilder.AddTag("Group", sInsertGroup);
				}
			}
			else
			{
				emailInsertsBuilder.AddTag("DefaultText", "");
			}
			emailInsertsBuilder.CloseTag("EMAIL-INSERT");
		}
	}
	emailInsertsBuilder.CloseTag("EMAIL-INSERTS");

	return true;
}

/*********************************************************************************

	bool CEmailInserts::IsValidInsertName(const CTDVString& sName)

		Author:		David Williams
        Created:	04/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailInserts::IsValidInsertName(const CTDVString& sName)
{
	std::vector<CTDVString>::iterator it = std::find(m_vecValidNames.begin(), m_vecValidNames.end(), sName);
	return (it != m_vecValidNames.end());
}


bool CEmailInserts::ValidateName(const CTDVString& sCallee, const CTDVString& sCode, const CTDVString& sName)
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

bool CEmailInserts::GetUpdatedModViewParams(CTDVString& sViewObject, int& iViewID)
{

	if (sViewObject.CompareText("all") || sViewObject.CompareText("default"))
	{
		sViewObject = "site";
		iViewID = iRequestedSiteID;
	}
	return true;
}