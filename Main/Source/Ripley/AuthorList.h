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

/******************************************************************************
class:	CAuthorList

This class manages a list of editors and researchers for a specific article.
The problem is that the list is slightly different in CArticleEditForm (everything 
in 1 list) and normal articles (split into researcher list and editor) but are 
otherwise very similar. Also it's a frankensteinian mix of methods from assorted 
objects drawn together here because it seemed like the right thing to do.
That is why this module can be a bit messy at times.

Example Usage:
	CAuthorList authorList(m_InputContext);
	authorList.SetArticleType(CAuthorList::ARTICLE);
	authorList.Seth2g2ID(5);
	authorList.SetEditorID(101);
	if ( authorList.GenerateList() )
	{
		CTDVString sResearcherXML;
		authorList.GetListAsString(sResearcherXML);					
		sArticle << "<PAGEAUTHOR>" << sResearcherXML << "</PAGEAUTHOR>";
	}
******************************************************************************/

#if !defined(AFX_AUTHORLIST_H__837F50F9_7D96_11D4_8718_00A024998768__INCLUDED_)
#define AFX_AUTHORLIST_H__837F50F9_7D96_11D4_8718_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "UserList.h"

#define TAGNAME_EDITFORM_RESEARCHER_LIST "USER-LIST"
#define TAGNAME_ARTICLE_RESEARCHER_LIST "RESEARCHERS"

class CAuthorList : public CUserList
{
public:

	enum EnumArticleType
	{
		ARTICLE,
		ARTICLE_EDITFORM
	};

	// Constructor, destructor and initialisation function
	//
	CAuthorList(CInputContext& inputContext);
	virtual ~CAuthorList();

	// Set basic parameters
	//
	void SetArticleType(EnumArticleType articleType);
	void Seth2g2ID(int ih2g2ID);
	void SetEditorID(int iEditorID);

	// Methods to create new lists
	//
	bool GenerateList();
	bool GenerateListForEditForm();
	bool GenerateListForArticle();
	void GetListAsString(CTDVString& listAsString);

	// Methods to update user lists
	//
	bool AddResearcher(int iUserID);
	bool ClearResearcherList();
	bool SetNewResearcherList(const TDVCHAR *pList);
	bool CommitChanges();

private:
	bool GenerateSingleResearcher(CTDVString& sNewUserXML, int iResearcherID);

	int m_ih2g2ID, m_iEditorID;
	CTDVString m_sEditorXML; // Not used for ArticleEditForm
	EnumArticleType m_ArticleType;
};



/*********************************************************************************
inline void CAuthorList::SetArticleType(EnumArticleType articleType)
Author:		David van Zijl
Created:	25/05/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CAuthorList::SetArticleType(EnumArticleType articleType)
{
	m_ArticleType = articleType;
}

/*********************************************************************************
inline void CAuthorList::Seth2g2ID(int ih2g2ID)
Author:		David van Zijl
Created:	25/05/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CAuthorList::Seth2g2ID(int ih2g2ID)
{
	m_ih2g2ID = ih2g2ID;
}

/*********************************************************************************
inline void CAuthorList::SetEditorID(int iEditorID)
Author:		David van Zijl
Created:	25/05/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CAuthorList::SetEditorID(int iEditorID)
{
	m_iEditorID = iEditorID;
}

#endif
