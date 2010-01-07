// ExtraInfo.h: interface for the CExtraInfo class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_EXTRAINFO_H__0E3B5FA2_D48A_4A4C_822F_3F534105B182__INCLUDED_)
#define AFX_EXTRAINFO_H__0E3B5FA2_D48A_4A4C_822F_3F534105B182__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLTree.h"

class CExtraInfo
{
public:
	CExtraInfo();
	CExtraInfo(int iType);
	virtual ~CExtraInfo();

public:
	bool Create(int iType, const TDVCHAR* sExtraInfoXML);
	bool Create(int iType);
	bool SetType(int iType);
	int GetType() const {return m_iType;};
	bool AddInfoItems(const TDVCHAR* sInfoItem);
	bool AddUniqueInfoItem(const TDVCHAR* pTagName, const CTDVString& sXML);
	bool GetInfoItem(const TDVCHAR* sInfoItemName, CTDVString& sXML);
	bool RemoveInfoItem(const TDVCHAR* sInfoItemName);
	int RemoveAllInfoItems(const TDVCHAR* sInfoItemName);
	bool ExistsInfoItem(const TDVCHAR* sInfoItemName);
	bool GetInfoAsXML(CTDVString& sExtraInfoXML,bool bHiddenVersion = false) const;
	bool IsCreated() const;
	const CExtraInfo& operator=(const CExtraInfo& ExtraInfo);
	bool GetElementFromIndex(int iIndex, CTDVString& sName, CTDVString& sXML) const;
	void ReplaceMatchingItems(const CExtraInfo& OtherExtraInfo);
	void GenerateAutoDescription(const CTDVString& sText);

	static enum {AUTODESCRIPTIONSIZE = 120};

protected:
	CXMLTree* GetRoot() const;
	CXMLTree* GetFirstInfoItem() const;
	void BuildTypeTag(int iType, CTDVString& sTypeTag) const;
	void Clear();

	CXMLTree * m_pXMLTree;
	int m_iType;
};

#endif // !defined(AFX_EXTRAINFO_H__0E3B5FA2_D48A_4A4C_822F_3F534105B182__INCLUDED_)
