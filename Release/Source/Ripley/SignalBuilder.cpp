// SignalBuilder.cpp: implementation of the CSignalBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "SignalBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSignalBuilder::CSignalBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{

}

CSignalBuilder::~CSignalBuilder()
{

}

bool CSignalBuilder::Build(CWholePage* pPage)
{
	CTDVString action;
	m_InputContext.GetParamString("action", action);


	if (action.CompareText("recache-site"))
	{
		m_InputContext.SiteDataUpdated();
	}
	else if(action.CompareText("recache-groups"))	// Refresh groups
	{
		int iUserID = m_InputContext.GetParamInt("userid");
		if (iUserID == 0)
		{
			m_InputContext.GroupDataUpdated();
		}
		else
		{
			m_InputContext.UserGroupDataUpdated(iUserID);
		}
	}
	else if(action.CompareText("recache-dynamiclists"))	// Refresh dynamic lists 
	{
		// Refresh DynamicLists. This will recache the list of dynamic lists
		// instances rather than the lists themselves. This signal is sent
		// when a list is added/deleted
        
		m_InputContext.DynamicListsDataUpdated();
	}
	else if (action.CompareText("orother"))
	{
		// or other
	}

	return false;
}
