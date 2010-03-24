#pragma once
#include "xmlbuilder.h"
#include ".\user.h"
#include ".\emailinserts.h"

class CModerationEmailManagementBuilder :
	public CXMLBuilder
{
public:
	CModerationEmailManagementBuilder(CInputContext& inputContext);
	
	virtual ~CModerationEmailManagementBuilder(void);

	bool Build(CWholePage* pPage);

protected:
	
	typedef bool (CModerationEmailManagementBuilder::*ActionHandler)(void);

	bool SaveEmail(bool bSave = true);
	bool BuildModerationClassesList(CTDVString& sClassXML);
	bool BuildSitesList(CTDVString& sSiteXML);
	bool GetModeratorView(CTDVString& sModView);
	bool GetModeratorViewParameters();
	bool GetEmailInsertGroups(CTDVString& sEmailInsertGroupsXML);

	bool CreateEmailInsert();
	bool UpdateEmailInsert();
	
	CWholePage* m_pPage;
	CUser*		m_pViewer;

	int			m_iViewID;
	int			m_iAccessID;
	CTDVString  m_sViewObject;
	CTDVString  m_sAccessObject;
	CEmailInserts m_emailInserts;

	CTDVString m_sViewType;
	int m_iViewTypeID;

	int m_iSiteID;
	int m_iClassID;
	int m_iSavedClassID;

private:

};




