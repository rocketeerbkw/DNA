// XMLObject.h: interface for the CXMLObject class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/



#if !defined(AFX_XMLOBJECT_H__03E3D470_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
#define AFX_XMLOBJECT_H__03E3D470_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_


#include "XMLtree.h"
#include "XMLError.h"
#include "DBXMLBuilder.h"
#include "InputContext.h"

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/*
	class CXMLObject  

	Author:		Jim Lynn, Kim Harries
	Created:	18/02/2000
	Modified:	24/02/2000
	Inherits:	-
	Purpose:	Base class for a generic XML object representing some arbitrary
				data. Since we cannot know in the base class how such an object
				needs to be initialised, there is no virtual function for 
				initialisation. For example, a 'TopFive' object would take the
				name of the topfive as its initialisation param. An Article object
				would take either an h2g2ID or a key name.

				How each subclass represents, fetches and stores its data is also
				an implementation detail. Some will cache their data, others will
				query the database, still others might simply generate their data
				programmatically.

				I anticipate that there will be numerous subclasses inherited from
				this base class, implementing the wrapper around any data which
				must be returned as XML.

				The only helper functions in the base class will be generic, simple
				tree manipulation functions.

*/

class CXMLObject  : public CXMLError
{
public:
	CXMLObject(CInputContext& inputContext);
	virtual ~CXMLObject();

	bool GenerateHash(const TDVCHAR* pString, CTDVString& oResult);
	bool DoesChildTagExist(const TDVCHAR* pTagName);
	bool GetTextContentsOfChild(const TDVCHAR* pTagName, CTDVString* oValue);
	virtual bool NextNode();
	virtual bool FindFirstNode(const TDVCHAR* pNodeName, CXMLTree* pParent = NULL, bool bAssertOnNULLNode = true);
	static CTDVString ParseXMLForErrors(const TDVCHAR* pXMLText);
	static bool FindTagPairs(const TDVCHAR* pXMLText, const TDVCHAR* pTagName, int* pOpenTagPos, int* pCloseTagPos, UINT iStartPos = 0);

	static void MakeSubjectSafe(CTDVString* pString);
	bool GetContentsOfTag(const TDVCHAR* pName, CTDVString* oContents);
	virtual bool GetAsString(CTDVString& sResult);
	virtual bool AddInside(const TDVCHAR* pTagName, CXMLObject* pObject);
	virtual bool AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText);
	virtual bool SetAttribute(const TDVCHAR* pTagName, const TDVCHAR* pAttributeName, const TDVCHAR* pAttributeValue);
	virtual bool RemoveTag(const TDVCHAR* pTagName);
	virtual bool RemoveTagContents(const TDVCHAR* pTagName);
	virtual bool RemoveTagIfItsAChild(const TDVCHAR* pTagName);
	virtual bool IsEmpty();
	virtual bool Destroy();
	virtual bool DoesTagExist(const TDVCHAR* pNodeName);	// Check whether named node exists in the object
	virtual bool CreateDateXML(const TDVCHAR* pTagName,const CTDVDateTime& dDT,CTDVString& sXML);
	static void EscapeEverything(CTDVString *pString);
	static void EscapeXMLText(CTDVString* pString);
	static void EscapeAllXML(CTDVString* pString);
	static void UnEscapeXMLText(CTDVString* pString);
	static void DoPlainTextTranslations(CTDVString* pString);
	static void ReversePlainTextTranslations(CTDVString* pString);
	static void PlainTextToGuideML(CTDVString* pString);
	static void GuideMLToPlainText(CTDVString* pString);
	static void GuideMLToHTML(CTDVString* pString);
//	static void PlainTextToHTML(CTDVString* pString);
//	static void HTMLToPlainText(CTDVString* pString);
	
	static void CreateSimpleTextLineFromXML(const CTDVString& sXML, CTDVString& sText);
	static bool ReplaceLineBreaksWithBreakTags(CXMLTree* pTree);
	static void MakeTag(const TDVCHAR* pTagName, const CTDVString& pTagContent, CTDVString& sResultXML);
	static CTDVString MakeTag(const TDVCHAR* pTagName, const CTDVString& sTagContent);
	static bool ReplaceReturnsWithBreaks(CTDVString &sInput);
	static void FixAmpersand(CTDVString &sXMLToChange);
	static bool MakeGuideMLTextEditable(CXMLTree* pTree, const TDVCHAR* pNodeName, CTDVString& sNodeText, CTDVString& sEditableText);
	static bool GenerateAsGuideML(const TDVCHAR* pName, const TDVCHAR* pValue, CTDVString& sXML, CTDVString& sParseErrors);
	static bool StripTopLevelTagFromParseErrors(const TDVCHAR* pName,CTDVString& sParseErrors);
	
	virtual CXMLTree* _TEST_GetTree() const {return m_pTree;};
	CXMLTree* _TEST_ExtractTree();

	virtual bool AddInsideWhereIntAttributeEquals(const TDVCHAR* psTagName, const TDVCHAR* psAttibuteName, int iAttributeValue, const TDVCHAR* psXML, int iAddToParent = 0, bool bAssertIfErrors = true);

public:
	CStoredProcedure* InitialiseXMLBuilder(CTDVString* psXML, CStoredProcedure* pSP = NULL);

	// Non Database XML Functions
	bool OpenXMLTag(const TDVCHAR *psTagName, bool bHasAttributes = false);
	bool CloseXMLTag(const TDVCHAR *psTagName, const TDVCHAR* psValue = NULL);
	bool AddXMLTag(const TDVCHAR *psTagName, const TDVCHAR *psValue);
	bool AddXMLAttribute(const TDVCHAR *psTagName, const TDVCHAR *psValue, bool bIsLastAttribute = false);
	bool AddXMLIntTag(const TDVCHAR* psTagName, const int iValue);
	bool AddXMLIntAttribute(const TDVCHAR* psTagName, const int iValue, bool bIsLastAttribute = false);
	bool AddXMLDateTag(const TDVCHAR* psTagName, CTDVDateTime& Date, bool bIncludeRelative = false);

	// Database XML Functions
	bool AddDBXMLTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bEscapeText = true, CTDVString* psValue = NULL);
	bool AddDBXMLAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bEscapeText = true, bool bIsLastAttribute = false, CTDVString* psValue = NULL);
	bool AddDBXMLIntTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, int* piValue = NULL);
	bool AddDBXMLIntAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bIsLastAttribute = false, int* piValue = NULL);
	bool AddDBXMLDateTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bIncludeRelative = false, CTDVDateTime* pDate = NULL);	
	bool AddDBXMLDoubleTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, double* pdValue = NULL);
	
	CTDVString GetBuilderXML();

protected:
	CXMLObject();

protected:
	CInputContext& m_InputContext;
	CInputContext  m_DummyInputContext;
	CXMLTree*			m_pTree;
	CXMLTree*			m_pCurNode;
	CXMLTree*			m_pPrevNode;
	CTDVString			m_CurNodeName;

	CDBXMLBuilder		m_XMLBuilder;

	bool CacheGetItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, CTDVDateTime *pdExpires, CTDVString* oXMLText);
	bool CachePutItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, const TDVCHAR* pText);
	virtual bool CreateCacheText(CTDVString* pCacheText);
	virtual bool CreateFromCacheText(const TDVCHAR* pCacheText);
	virtual bool CreateFromXMLText(const TDVCHAR* xmlText, CTDVString* pErrorReport = NULL, bool bDestroyTreeFirst = false);
	virtual CXMLTree* ExtractTree();
	virtual bool UpdateRelativeDates();
	void EscapeTextForURL(CTDVString* pString);
};


#endif // !defined(AFX_XMLOBJECT_H__03E3D470_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
