// SmileyTranslator.h: interface for the CSmileyTranslator class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SMILEYTRANSLATOR_H__9CD4E4A4_C833_4835_97D4_4FA73DF78CA9__INCLUDED_)
#define AFX_SMILEYTRANSLATOR_H__9CD4E4A4_C833_4835_97D4_4FA73DF78CA9__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <vector>

class CSmileyTranslator;

class CSmileyUnit
{
public:
	CSmileyUnit(const TDVCHAR* pValue, const TDVCHAR* pReplace, bool bCountAsSmiley = true);
	virtual ~CSmileyUnit();

	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* CurrentSmileyCount);

	CSmileyUnit* GetNext()
	{
		return m_pNext;
	}

	void SetNext(CSmileyUnit* pUnit)
	{
		m_pNext = pUnit;
	}

	virtual bool IsBigger(CSmileyUnit* pOther);

	void Dump()
	{
		OutputDebugString("Dumping Unit: ");
		OutputDebugString(m_sUnit);
		OutputDebugString(" : ");
		OutputDebugString(m_sReplace);
		OutputDebugString("\r\n");
	}

	int GetOpenTagCount(void) { return m_iOpenTags; }

protected:
	CTDVString m_sUnit;
	CTDVString m_sReplace;
	CSmileyUnit* m_pNext;
	bool m_bCountAsSmiley;
	int m_iOpenTags;
};

class CHttpUnit : public CSmileyUnit
{
public:
	CHttpUnit();
	virtual ~CHttpUnit();
	virtual bool IsBigger(CSmileyUnit* pOther);
	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* CurrentSmileyCount);
};

class CRelativeURLUnit : public CSmileyUnit
{
public:
	CRelativeURLUnit();
	virtual ~CRelativeURLUnit();
	virtual bool IsBigger(CSmileyUnit* pOther);
	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* CurrentSmileyCount);
};

class CArticleUnit : public CSmileyUnit
{
public:
	enum ARTICLETYPE {T_ARTICLE, T_FORUM, T_USER, T_CATEGORY, T_CLUB};
	CArticleUnit(ARTICLETYPE atype);
	virtual ~CArticleUnit();
	virtual bool IsBigger(CSmileyUnit* pOther);
	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* CurrentSmileyCount);
	void		AddFilterExpression(const CTDVString& sFilter);
protected:
	ARTICLETYPE m_Type;
private:
	std::vector<CTDVString> m_Exclusions;
};

class CSmileyTranslator  
{
public:
	CSmileyTranslator();
	virtual ~CSmileyTranslator();
	bool Translate(CTDVString* pString, int MaxSmileyCount = 0);
	bool SingleTranslate(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int *CurrentSmileyCount);
	bool AddUnit(const TDVCHAR* pString, const TDVCHAR* pReplace, bool bCountAsSmiley = true);
	bool AddUnit(CSmileyUnit* pUnit, int ArrayPos);
	void Dump();

protected:
	CSmileyUnit* m_aList[256];
};

class CBracketUnit : public CSmileyUnit
{
public:
	CBracketUnit();
	virtual ~CBracketUnit();
	virtual bool IsBigger(CSmileyUnit* pOther);
	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount);
	bool AddUnit(const TDVCHAR* pString, const TDVCHAR* pReplace);
protected:
	CSmileyTranslator m_Translator;
};

class CQuoteUnit : public CSmileyUnit
{
public:
	CQuoteUnit();
	virtual ~CQuoteUnit();
	virtual bool IsBigger(CSmileyUnit* pOther);
	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount);
};

// Note - Not currently user - email address filtering is conducted by CEmailAddress Filter as a validation step.
/*class CEmailUnit : public CSmileyUnit
{
public:
	virtual bool IsBigger( CSmileyUnit* pEmailUnit ) { return true; }
	virtual bool DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount);
};*/

#endif // !defined(AFX_SMILEYTRANSLATOR_H__9CD4E4A4_C833_4835_97D4_4FA73DF78CA9__INCLUDED_)
