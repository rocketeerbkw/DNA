// XMLTree.h: interface for the CXMLTree class.
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



#if !defined(AFX_XMLTREE_H__58FA5F87_12F4_11D3_A913_00104BF83D2F__INCLUDED_)
#define AFX_XMLTREE_H__58FA5F87_12F4_11D3_A913_00104BF83D2F__INCLUDED_

#include "TDVString.h"	// Added by ClassView
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000



class CXMLTagNode;
/*
	Base class for XML tree scanning
	Handles all the list handling
*/

class CXMLTree  
{
public:
	bool _TEST_CreateTestFile(const TDVCHAR* pXMLFile);
	virtual void SetAttribute(const TDVCHAR* pName, int iValue);
	virtual int GetIntAttribute(const TDVCHAR* pName);
	virtual bool DoesAttributeExist(const TDVCHAR* pName);
	bool GetTextContents(CTDVString& sResult);
	bool GetTextContentsRaw(CTDVString& sResult);

	virtual void DebugDumpErrors();

	void debugchecktree();
	void dumptree();
	void DumpNodes(int nLevel = 0);

	virtual void SetAttribute(const TDVCHAR* pAttrName, const TDVCHAR* pValue);
	CXMLTree* DetachNodeTree();

	enum e_nodetype {T_NONE, T_TEXT, T_NODE, T_CDATA, T_ERROR, T_COMMENT, T_ATTRIBUTE} m_NodeType;

	e_nodetype GetNodeType()
	{
		return m_NodeType;
	}
	CXMLTree(e_nodetype NodeType = T_NONE, long TagPos = 0);

	virtual CXMLTree* GetFirstChild()
	{
		return m_FirstChild;
	}
	virtual CXMLTree* GetFirstChild(e_nodetype NodeType);
	virtual CXMLTree* GetPrevSibling()
	{
		return m_PrevSibling;
	}
	virtual CXMLTree* GetNextSibling()
	{
		return m_NextSibling;
	}
	CXMLTree* CXMLTree::GetNextSibling(e_nodetype NodeType);
	virtual CXMLTree* GetParent()
	{
		return m_Parent;
	}
	virtual void OutputXMLTree(CTDVString& sOutput);
	void OutputChildrenXMLTree(CTDVString &sOutput);
	CXMLTree* GetDocumentRoot();
	CTDVString DisplayErrors(const TDVCHAR* pText);
//	virtual CTDVString GetCloseTag();
//	virtual CTDVString GetOpenTag();
	virtual bool GetAttribute(const TDVCHAR* pAttrName, CTDVString& sValue);
	CXMLTree* IsNodeWithin(const TDVCHAR* pNames);
	virtual CTDVString GetText();
	virtual bool SetText(const TDVCHAR* pText);
	CXMLTree* FindNextTagNode(const TDVCHAR* pTagName, CXMLTree* pParent = NULL);
	CXMLTree* FindFirstTagName(const TDVCHAR* pTagName, CXMLTree* pParent = NULL, bool bAssertOnNULLNode = true);
	CXMLTree* FindNextTagNodeNoChild(const TDVCHAR* pTagName, CXMLTree* pParent = NULL);
	CXMLTree* FindFirstTagNameNoChild(const TDVCHAR* pTagName, CXMLTree* pParent = NULL);
	virtual void DebugDumpTree(CTDVString& sOutput);
//	virtual void DebugDump(CTDVString& sOutput);
	virtual CTDVString GetName();
	void AddChild(CXMLTree* pNode);
	void AddSibling(CXMLTree* pNewSibling);
	CXMLTree* FindNext(CXMLTree* pParent = NULL);
	CXMLTree* FindNextNoChild(CXMLTree* pParent = NULL);

	CXMLTree* FindFirstNodeXP(const TDVCHAR* pNodeSpec, CXMLTree* pParent);

	virtual ~CXMLTree();

	static CXMLTree* Parse(const TDVCHAR* pText, bool bShowErrors = false, long* pNumErrors = NULL);
	static CXMLTree* ParseForInsert(const TDVCHAR* pText);
	static void FlagAmpersandErrors(const TDVCHAR* pText, bool bShowErrors, long *NumErrors, CXMLTree* pCurParent, long stringstart, CTDVString* pFixedOutput = NULL);
	static CXMLTree* _TEST_CreateFromFile(const char* filename);
protected:
	virtual bool CompareNodeName(const TDVCHAR* pName);
	long m_Pos;
	CXMLTree* m_PrevSibling;
	CXMLTree* m_NextSibling;
	CXMLTree* m_FirstChild;
	CXMLTree* m_Parent;
	CXMLTree* m_LastChild;

	bool CheckXPath(const TDVCHAR* psXPath);

public:
	CTDVString GetXPath(  CTDVString sNode );
};

class CXMLTextNode : public CXMLTree
{
public:
	virtual void OutputXMLTree(CTDVString& sOutput);
//	virtual CTDVString GetCloseTag();
//	virtual CTDVString GetOpenTag();
	virtual CTDVString GetText();
	virtual void DebugDumpTree(CTDVString& sOutput);
//	virtual void DebugDump(CTDVString& sOutput);
	CXMLTextNode( const TDVCHAR* pText = NULL, long TagPos = 0);
	virtual ~CXMLTextNode();
	virtual CTDVString GetName();
	virtual bool SetText(const TDVCHAR* pText);

protected:
	CTDVString m_Text;
};

class CXMLCDATANode : public CXMLTree
{
public:
	virtual void OutputXMLTree(CTDVString& sOutput);
//	virtual CTDVString GetCloseTag();
//	virtual CTDVString GetOpenTag();
	virtual CTDVString GetText();
	virtual bool SetText(const TDVCHAR* pText);
	virtual void DebugDumpTree(CTDVString& sOutput);
//	virtual void DebugDump(CTDVString& sOutput);
	CXMLCDATANode( const TDVCHAR* pText = NULL, long TagPos = 0);
	virtual ~CXMLCDATANode();
	virtual CTDVString GetName();

protected:
	CTDVString m_CDATA;
};

class CXMLCommentNode : public CXMLTree
{
public:
	virtual void OutputXMLTree(CTDVString& sOutput);
//	virtual CTDVString GetCloseTag();
//	virtual CTDVString GetOpenTag();
	virtual CTDVString GetText();
	virtual bool SetText(const TDVCHAR* pText);
	virtual void DebugDumpTree(CTDVString& sOutput);
//	virtual void DebugDump(CTDVString& sOutput);
	CXMLCommentNode( const TDVCHAR* pText = NULL, long TagPos = 0);
	virtual ~CXMLCommentNode();
	virtual CTDVString GetName();

protected:
	CTDVString m_CDATA;
};

class CXMLAttribute : public CXMLTree
{
public:
	CTDVString GetName();
	CTDVString GetValue();
	virtual void OutputXMLAttribute(CTDVString& sOutput);
	CXMLAttribute(const TDVCHAR* pName = NULL, const TDVCHAR* pValue = NULL);
	~CXMLAttribute();
	CTDVString m_Name;
	CTDVString m_Value;
	void SetValue(const TDVCHAR* pValue);
};

class CXMLTagNode : public CXMLTree
{
public:
	virtual int GetIntAttribute(const TDVCHAR* pName);
	virtual bool DoesAttributeExist(const TDVCHAR* pName);
	virtual void SetAttribute(const TDVCHAR* pName, const TDVCHAR* pValue);
	virtual void SetAttribute(const TDVCHAR* pName, int iValue);
//	virtual CTDVString GetCloseTag();
//	virtual CTDVString GetOpenTag();
	virtual bool GetAttribute(const TDVCHAR* pAttrName, CTDVString& sValue);
	virtual CTDVString GetText();
	virtual void DebugDumpTree(CTDVString& sOutput);
	virtual void OutputXMLTree(CTDVString& sOutput);
//	virtual void DebugDump(CTDVString& sOutput);
	CXMLTagNode(const TDVCHAR* pName = NULL, const TDVCHAR* pParams = NULL, long TagPos = 0);
	virtual ~CXMLTagNode();
	virtual CTDVString GetName();
	CTDVString m_Name;
	CTDVString m_RawParams;
	bool ParseAttributes(bool bShowErrors = true, long StartPos = 0, long* pNumErrs = NULL);

//	CXMLAttribute* m_pAttributes;
//	long m_NumAttributes;
protected:
	virtual bool CompareNodeName(const TDVCHAR* pName);
	CXMLAttribute* FindAttribute(const TDVCHAR* pName);
};

class CXMLErrorNode : public CXMLTree
{
public:
	CXMLErrorNode(const TDVCHAR* pText = NULL, long tpos = 0);
	virtual ~CXMLErrorNode();
	virtual CTDVString GetName();
	virtual bool SetText(const TDVCHAR* pText);
	virtual void DebugDumpTree(CTDVString& sOutput);
	virtual CTDVString GetText();

protected:
	CTDVString m_Text;
};

#endif // !defined(AFX_XMLTREE_H__58FA5F87_12F4_11D3_A913_00104BF83D2F__INCLUDED_)
