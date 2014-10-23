#if !defined(AFX_AGENTBLOCKER_H__32283B23_4DE9_474D_9769_9973EE91AD70__INCLUDED_)
#define AFX_AGENTBLOCKER_H__32283B23_4DE9_474D_9769_9973EE91AD70__INCLUDED_

// AGENTBLOCKER.H - Header file for your Internet Server
//    agentblocker Filter

#include "resource.h"

#define MAX_AGENTS 256
#define AGENT_LENGTH 256

class CAgentList
{
public:
	CAgentList();
	virtual ~CAgentList();

	bool IsAgentAllowed(const char* pAgentName);
	void Initialise(DWORD ThrottlePeriod);

protected:
	CRITICAL_SECTION m_criticalsection;
	char m_NameList[MAX_AGENTS][AGENT_LENGTH];
	LONG m_LastAccess[MAX_AGENTS];

	DWORD m_ThrottlePeriod;
};


class CAgentblockerFilter : public CHttpFilter
{
public:
	HKEY m_hkAgents;
	CAgentblockerFilter();
	~CAgentblockerFilter();
protected:
	CAgentList m_AgentList;
	CHttpFilterContext* m_pContext;
// Overrides
	// ClassWizard generated virtual function overrides
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//{{AFX_VIRTUAL(CAgentblockerFilter)
	public:
	virtual BOOL GetFilterVersion(PHTTP_FILTER_VERSION pVer);
	virtual DWORD OnPreprocHeaders(CHttpFilterContext* pCtxt, PHTTP_FILTER_PREPROC_HEADERS pHeaderInfo);
	virtual DWORD OnAuthentication(CHttpFilterContext* pCtxt, PHTTP_FILTER_AUTHENT pAuthent);
	virtual DWORD OnEndOfNetSession(CHttpFilterContext* pCtxt);
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CAgentblockerFilter)
	//}}AFX_MSG
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AGENTBLOCKER_H__32283B23_4DE9_474D_9769_9973EE91AD70__INCLUDED)
