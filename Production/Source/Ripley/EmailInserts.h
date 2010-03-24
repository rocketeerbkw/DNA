#pragma once
#include "xmlobject.h"
#include <set>

class CEmailInserts :
	public CXMLObject
{
public:
	CEmailInserts(CInputContext& inputContext, const int iViewID, const CTDVString& sViewObject);
	CEmailInserts(CInputContext& inputContext);
	
	void Initialise(const int iViewID, const CTDVString& sViewObject);

	virtual ~CEmailInserts(void);

	bool AddSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sReasonDescription);
	bool AddModClassEmailInsert(const int iModClassID, const CTDVString& sName, const CTDVString sGroup, const CTDVString& sText, const CTDVString& sReasonDescription);

	bool UpdateSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sReasonDescription);
	bool UpdateModClassEmailInsert(int iModClassID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sReasonDescription);

	bool RemoveSiteEmailInsert(const int iSiteID, const CTDVString& sName);
	bool RemoveModClassEmailInsert(const int iModClassID, const CTDVString& sName);

	virtual bool GetAsString(CTDVString& sResult);

	bool GetUpdatedModViewParams(CTDVString& sViewObject, int& iViewID);
	
	enum EmailInsertType
	{
		None = 0,
		OffensiveInsert = 1,
		LibelInsert = 2,
		URLInsert = 3,
		PersonalInsert = 4,
		AdvertInsert = 5,
		CopyrightInsert = 6,
		PoliticalInsert = 7,
		IllegalInsert = 8,
		SpamInsert = 9,
		CustomInsert = 10,
		ForeignLanguage = 11
	};
private:
	bool IsValidInsertName(const CTDVString& sName);
	bool ValidateName(const CTDVString& sCallee, const CTDVString& sCode, const CTDVString& sName);
	void PopulateValidNamesSet();
	
	//static const CTDVString m_InsertNames[];
	int m_iViewID;
	CTDVString m_sViewObject;
	std::vector<CTDVString> m_vecValidNames;

	int iSiteID;
	int iRequestedSiteID;
	int iModClassID;
	bool bNullSiteID;
	bool bGetModClassID;
};
