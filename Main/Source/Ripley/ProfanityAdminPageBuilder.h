/******************************************************************************
class:	CProfanityAdminPageBuilder

Builder for the url ~/ProfanityAdmin

The action performed depends on the CGI parameter 'action'
	- showgroups : List profanity groups with members
	- addgroup : Add a profanity group and site list
	- showupdategroup : First step in updating profanity group
	- updategroup : Update profanity group and site list
	- deletegroup : Delete a profanity group and free the site list
	- showgroupfilter : List profanities for a group (or global)
	- (empty / default action) : List profanities for current site
	- addprofanity : Add a profanity to current group or site list
	- showupdateprofanity : First step in editing a profanity
	- updateprofanity : Edit profanity
	- deleteprofanity : Delete profanity from group or site list

In case of errors, SetDNALastError is used with the following possible error codes:
	- INVALIDUSER : Viewing user has insufficient permissions. Can't continue
	- INPUTPARAMS : Parameters have been passed which don't make sense
	- DATABASE : Error inside a stored procedure
	- DUPLICATE : User tried to add a profanity that already exists

Design Decisions:
	- separating input context from underlying CProfanityAdmin object. ie 
	  passing cgi parameters down to the object to deal with instead of passing
	  the entire InputContext. This also means all MultiStep actions are done 
	  here and when we are finished, params are passed to CProfanityAdmin when 
	  an add or an update needs to be done.

Internal workings:
	- There are 3 levels of profanities: global, group and site. There are 
	  many group lists and many sites to one group. A site can't belong to more 
	  than one group.
	- A site can add a word that is not in the global or it's own group list
	- A group can add a word that is not in the global list
	- A new global word will delete conflicting words in all group and site lists
	- A new group word will delete conflicting words in all sites that belong to 
	  that group
******************************************************************************/

#if !defined(AFX_PROFANITYADMINPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
#define AFX_PROFANITYADMINPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "ProfanityAdmin.h"
#include "MultiStep.h"


class CProfanityAdminPageBuilder : public CXMLBuilder
{
public:
	CProfanityAdminPageBuilder(CInputContext& inputContext);
	virtual ~CProfanityAdminPageBuilder();

	virtual bool Build(CWholePage* pPage);

protected:
	CWholePage* m_pPage;

private:

	bool CheckIsSuperUser();

#if 0
	// Profanity Groups:
	//
	bool ShowGroupFilter(CProfanityAdmin& PAdmin);
//	bool AddGroup(CProfanityAdmin& PAdmin);
//	bool ShowUpdateGroupPage(CProfanityAdmin& PAdmin);
//	bool UpdateGroup(CProfanityAdmin& PAdmin);
//	bool DeleteGroup(CProfanityAdmin& PAdmin);
	bool UpdateGroupSiteList(CProfanityAdmin& PAdmin);
	bool CreateAndProcessGroupMultiStep(const bool bIsNew, int& iGroupId, 
		CTDVString& sGroupName, CTDVString& sGroupSites, bool& bReadyToUse);

	// Profanities:
	//
	bool ShowSiteFilter(CProfanityAdmin& PAdmin);
	bool AddGroupOrSiteDetails(CProfanityAdmin& PAdmin);
	bool AddProfanity(CProfanityAdmin& PAdmin);
	bool ShowUpdateProfanityPage(CProfanityAdmin& PAdmin);
	bool UpdateProfanity(CProfanityAdmin& PAdmin);
	bool DeleteProfanity(CProfanityAdmin& PAdmin);
	bool CreateAndProcessProfanityMultiStep(const bool bIsNew, int& iProfanityId, 
			CTDVString& sProfanity, int& iProfanityRating, CTDVString& sProfanityReplacement, bool& bReadyToUse);
	bool GetGroupAndSiteIds(bool& bAddingToGroup, int& iGroupId, int& iSiteId);
	bool CheckProfanityAndPermissions(const int iProfanityId, int& iGroupId, int& iSiteId);
#endif
};

#endif // !defined(AFX_PROFANITYADMINPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
