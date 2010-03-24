#include "stdafx.h"
#include ".\moderationemail.h"
#include "InputContext.h"

CModerationEmail::CModerationEmail(CInputContext& inputContext)
{
	inputContext.InitialiseStoredProcedureObject(m_SP);
}

CModerationEmail::~CModerationEmail(void)
{
}

bool CModerationEmail::FetchEmailText(int iSiteId, const char* pEmailName, 
  CTDVString& sSubject, CTDVString& sText)
{
	m_SP.StartStoredProcedure("fetchemailtext");
	m_SP.AddParam("SiteID", iSiteId);
	m_SP.AddParam("emailname", pEmailName ? pEmailName : "");
	m_SP.ExecuteStoredProcedure();
	if (m_SP.IsEOF())
	{
		return false;
	}

	m_SP.GetField("text", sText);
	m_SP.GetField("Subject", sSubject);
	return !m_SP.HandleError("CModerationEmail::FetchEmailText");
}

bool CModerationEmail::GetEmail(const char* pEmailName, int iSiteId,
	CSubst* pSubst,
	CTDVString& sEmailSubject, CTDVString& sEmailText)
{
	if (!FetchEmailText(iSiteId, pEmailName, sEmailSubject, sEmailText))
	{
		return false;
	}

	if (!pSubst)
	{
		return true;
	}


	// pass 1 - find patters starting with +++** and substitute with articles with
	// given name

	CTDVString sTmpSubject;
	CTDVString sTmpText;
	for(CSubst::iterator it = pSubst->begin(); it != pSubst->end(); it++)
	{
		if (it->first.Find("+++**") == 0)	//found
		{
			if (!FetchEmailText(iSiteId, it->second, sTmpSubject, sTmpText))
			{
				return false;
			}
			sEmailText.Replace(((const char*)it->first) + 1, sTmpText);
			sEmailSubject.Replace(it->first, it->second);
		}
	}


	//pass 2 - regular substitution

	for(CSubst::iterator it = pSubst->begin(); it != pSubst->end(); it++)
	{
		sEmailText.Replace(it->first, it->second);
		sEmailSubject.Replace(it->first, it->second);
	}

	return true;
}
