#pragma once
#include "xmlobject.h"
#include "storedprocedure.h"
#include "emailvocab.h"
#include "subst.h"
#include <set>

class CEmailTemplate :
	public CXMLObject
{
public:
	CEmailTemplate(CInputContext& inputContext);
	virtual ~CEmailTemplate(void);

	bool GetEmail(const int iSiteID, const CTDVString& sEmailName,
		const CEmailVocab& emailVocab, const CSubst& substitutions, 
		CTDVString& sSubject, CTDVString& sText);

	bool AddNewEmailTemplate(const int iModClassID, const CTDVString& sEmailName,
		const CTDVString& sSubject, const CTDVString& sText);

	bool UpdateEmailTemplate(const int iModClassID, const CTDVString& sEmailName,
		const CTDVString& sSubject, const CTDVString& sText);

	bool RemoveEmailTemplate(const int iModClassID, const CTDVString& sEmailName);

	bool FetchEmailText(const int iSearchID, const CTDVString sEmailName, 
		CTDVString& sSubject, CTDVString& sText, const bool bSearchOnModClassID = false);

	bool FetchInsertText(const int iSearchID, const CTDVString sInsertName, 
		CTDVString& sInsertText);

	enum EmailType
	{
		ContentRemovedEmail = 0, 
		ContentFailedAndEditedEmail = 1,
		UpholdComplaintEmail = 2,
		UpholdComplaintEditEntryEmail = 3,
		RejectComplaintEmail = 4
	};

protected:

private:
	bool IsValidInsertName(const CTDVString& sName);
	bool ValidateName(const CTDVString& sCallee, const CTDVString& sCode, const CTDVString& sName);
		
	static const CTDVString m_EmailNames[];
	std::set<CTDVString> m_ValidNamesSet;
};

class CEmailTemplates :
	public CXMLObject
{
public:
	CEmailTemplates(CInputContext& inputContext, int iViewID, CTDVString& sViewObject);
	virtual ~CEmailTemplates(void);
	virtual bool GetAsString(CTDVString& sResult);

	bool CreateEmailTemplateSet();
	int GetEmailTemplateIDByName(const CTDVString& sTemplateName);

protected:
	bool GetEmailTemplates(std::vector<CEmailTemplate>& emailTemplates);

private:
	CStoredProcedure m_SP;
	int m_iModClassID;
	int m_iViewID;
	CTDVString m_sViewObject;
};
