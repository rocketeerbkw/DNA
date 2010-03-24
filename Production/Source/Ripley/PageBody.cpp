// PageBody.cpp: implementation of the CPageBody class.
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


#include "stdafx.h"
#include "PageBody.h"
#include "tdvassert.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CPageBody::CPageBody(CInputContext& inputContext)

	Author:		Oscar Gillesquie
	Created:	28/02/2000
	Inputs:		inputContext - input context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class with all data members
				correctly initialised. Note that any initialisation that
				could possibly fail is put in a seperate initialise method.

*********************************************************************************/

CPageBody::CPageBody(CInputContext& inputContext) :
	CXMLObject(inputContext), m_bIsInitialised(false)
{
// no other construction code required here (he says)
}

/*********************************************************************************

	CPageBody::~CPageBody()

	Author:		Oscar Gillesquie
	Created:	29/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated.
				We don't use any memory in CPageBody yet so the destructor does
				sod all. The base class will zap the memory it used.

*********************************************************************************/

CPageBody::~CPageBody()
{

}

/*********************************************************************************

	CPageBody::Initialise(int h2g2ID)

	Author:		Oscar Gillesquie
	Created:	29/02/2000
	Inputs:		h2g2ID - the ID of the article from which to initialise this object
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds an internal representation of the XML associated with a
				particular article by querying the database or accessing cache as
				appropriate.

*********************************************************************************/

bool CPageBody::Initialise(int ih2g2ID)
{
	// reset the initialised flag
	m_bIsInitialised = false;

	TDVASSERT(ih2g2ID > 0, "Negative h2g2ID in CPageBody::Initialise(...)");
	TDVASSERT(this->IsEmpty(), "CPageBody::Initialise(...) called on non-empty XML object");

	CTDVString cachename = "A";
	cachename << ih2g2ID << ".txt";
	
	CTDVString xmlText;				// string to store the xml text returned by the stored procedure
	CStoredProcedure StoredProcedure;	// a stored procedure

	// get a stored procedure object via the database context
	if (!m_InputContext.InitialiseStoredProcedureObject(&StoredProcedure))
	{
		// fail if stored procedure object can't be created
		return false;
	}
	else
	{
		CTDVDateTime dExpires;
		StoredProcedure.CacheGetArticleDate(ih2g2ID, &dExpires);
		CTDVString sXML;
		if (CacheGetItem("pagebody", cachename, &dExpires, &sXML))
		{
			// this should only fail if e.g. cache is garbled
			if (CreateFromCacheText(sXML))
			{
				UpdateRelativeDates();
				return true;
			}
		}
		// now use stored procedure object to fetch the relevent XML for the article ID
		if (StoredProcedure.FetchSimpleArticle(ih2g2ID, xmlText))
		{
			// if text fetched successfully attempt to create the current objects
			// tree from this and return its success or failure
			StoredProcedure.Release();
			bool bSuccess = CXMLObject::CreateFromXMLText(xmlText);
			if (bSuccess)
			{
				// TODO: should we call CreateCacheText?
				// CreateCacheText is not necessary here since we have just created the
				// object from this XML text, but may be better for consistency
				//CreateCacheText(&xmlText);
				CachePutItem("pagebody", cachename, xmlText);
			}
			return bSuccess;
		}
		else
		{
			// return failure if couldn't fetch text for some reason
			// current objects state is left unchanged
			return false;
		}
	}
}


/*********************************************************************************

	CPageBody::Initialise(const TDVCHAR* pArticleName)

	Author:		Oscar Gillespie, Jim Lynn
	Created:	29/02/2000
	Inputs:		pArticleName: a pointer to a string that holds the name
				of an article, which will be a way of uniquely indentifying an article.
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds an internal representation of the XML associated with a
				particular article by querying the database or accessing cache as
				appropriate.

*********************************************************************************/
bool CPageBody::Initialise(const TDVCHAR* pArticleName, int iSiteID)
{
	// reset the initialised flag
	m_bIsInitialised = false;

	TDVASSERT(pArticleName != NULL, "The ArticleName had better be a real String!");
	
	CTDVString cachename = "A-";
	cachename << pArticleName << "-" << iSiteID << ".txt";
	
	CTDVString xmlText;				// string to store the xml text returned by the stored procedure
	
	CStoredProcedure StoredProcedure;	// pointer to a stored procedure

	// get a stored procedure object via the database context
	if (!m_InputContext.InitialiseStoredProcedureObject(&StoredProcedure))
	{
		// fail if stored procedure object can't be created
		return false;
	}
	else
	{
		CTDVDateTime dExpires;
		StoredProcedure.CacheGetKeyArticleDate(pArticleName, iSiteID, &dExpires);
		CTDVString sXML;
		if (CacheGetItem("pagebodykey", cachename, &dExpires, &sXML))
		{
			//CreateFromXMLText(sXML);
			CreateFromCacheText(sXML);
			UpdateRelativeDates();
			UpdateSubjectAndBody();
			return true;
		}
		// now use stored procedure object to fetch the relevent XML for the article ID
		if (StoredProcedure.FetchSimpleArticle(pArticleName, iSiteID, xmlText))
		{
			// if text fetched successfully attempt to create the current objects
			// tree from this and return its success or failure
			bool bSuccess = CreateFromXMLText(xmlText);
			UpdateSubjectAndBody();
			if (bSuccess)
			{
				// TODO: should we call CreateCacheText?
				// CreateCacheText is not necessary here since we have just created the
				// object from this XML text, but may be better for consistency
				//CreateCacheText(&xmlText);
				CachePutItem("pagebodykey", cachename, xmlText);
			}
			return bSuccess;
		}
		else
		{
			// return failure if couldn't fetch text for some reason
			// current objects state is left unchanged
			return false;
		}
	}
}

/*********************************************************************************

	bool CXMLObject::CreateFromXMLText(const TDVCHAR* pXMLText, CTDVString* pErrorReport, bool bDestroyTreeFirst)

	Author:		Mark Howitt
	Created:	06/07/2005
	Inputs:		xmlText - well-formed XML inside a CTDVString, used to build
				the initial contents of the XML tree.
	Outputs:	pErrorReport - a string in which to put a copy of the XML text
					with the parse errors marked-up, or NULL if not required
	Returns:	true if successful, false if it failed.
	Purpose:	Virtual override so we can setup the extra info correctly at the same time

*********************************************************************************/
bool CPageBody::CreateFromXMLText(const TDVCHAR* pXMLText, CTDVString* pErrorReport, bool bDestroyTreeFirst)
{
	// First create the tree as normal.
	bool bSuccess = CXMLObject::CreateFromXMLText(pXMLText,pErrorReport,bDestroyTreeFirst);

	// Check to see if we managed to create the tree!
	TDVASSERT(bSuccess,"CPageBody::CreateFromXMLText - Failed To create Tree from XML Text!!!");

	// Now get the Extra Info for the article and create the new extrainfo object
	if (bSuccess)
	{
		// Make sure we get the extrainfo for the article and NOT Related articles!!!
		CXMLTree* pExtra = m_pTree->FindFirstTagName("EXTRAINFO", 0, false);

		// If we managed to find the Node, Extract the ExtraInfo
		if (pExtra != NULL)
		{
			// Set ExtraInfo for the Tree.
			CTDVString sExtraInfo;
			pExtra->OutputXMLTree(sExtraInfo);
			m_ExtraInfo.Create(1,sExtraInfo);
		}
		else
		{
			// We didn't find any extra info so create it!
			m_ExtraInfo.Create(1);
		}
	}

	// Set the is initialised flag!
	m_bIsInitialised = bSuccess;

	// return the verdict
	return bSuccess;
}

/*********************************************************************************

	bool CPageBody::CreatePageFromXMLText(const TDVCHAR* pSubject, const TDVCHAR* pBody, CExtraInfo* pExtraInfo)

	Author:		Oscar Gillespie, Kim Harries
	Created:	29/02/2000
	Modified:	20/03/2000
	Inputs:		pSubject - the subject if any
				pBody - a pointer to an entire piece of body XML for some article
					page or somesuch.
				pExtraInfo - The new ExtraInfo for the article
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds an internal representation of the XML that just uses the String
				information given to it as an initialiser.

*********************************************************************************/
bool CPageBody::CreatePageFromXMLText(const TDVCHAR* pSubject, const TDVCHAR* pBody, CExtraInfo* pExtraInfo)
{
	m_sSubject = pSubject;
	m_sBodyText = pBody;

	// Check to see if the extrainfo given is not NULL!
	if (pExtraInfo != NULL)
	{
		// Set the current extra info to the one passsed in
		m_ExtraInfo = *pExtraInfo;
	}

	// converting to strings means NULL pointers are not a problem
	CTDVString sWholePage("<ARTICLE>");
	CTDVString sSubject(pSubject);

	// subject is plain text, so escape any special xml characters in it
	CXMLObject::EscapeXMLText(&sSubject);
	sWholePage << "<SUBJECT>" << sSubject << "</SUBJECT>";
	
	// Insert the Body Text
	sWholePage << m_sBodyText;

	// Now Insert the ExtraInfo
	m_ExtraInfo.GetInfoAsXML(sWholePage);

	// Make sure we close the opening ARTICLE TAG!!!
	sWholePage << "</ARTICLE>";

	if (CXMLObject::CreateFromXMLText(sWholePage)) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CPageBody::CreatePageFromPlainText(const TDVCHAR* pSubject, const TDVCHAR* pBody)

	Author:		Oscar Gillespie, Kim Harries
	Created:	29/02/2000
	Modified:	20/03/2000
	Inputs:		pSubject - the subject, if any
				pBody - a pointer to an entire piece of body text for some article
				page or somesuch.
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds an internal representation of the XML that just uses the String
				information given to it as an initialiser and maps all characters that
				would mess up the XML to appropriate escape/control character.

*********************************************************************************/

bool CPageBody::CreatePageFromPlainText(const TDVCHAR* pSubject, const TDVCHAR* pBody)
{
	m_sSubject = pSubject;
	m_sBodyText = pBody;
	// converting to strings means NULL pointers are not a problem
	CTDVString sWholePage = "<ARTICLE>";
	CTDVString sSubject = pSubject;
	CTDVString sBody = pBody;

	// both subject and body should be plain text, so need to escape all appropriate chars
	CXMLObject::EscapeXMLText(&sSubject);
	// this will also add the GUIDE and BODY tags
	PlainTextToGuideML(&sBody);
//	CXMLObject::EscapeXMLText(&sBody);
//	sBody.Replace("\n", "<BR/>");
	sWholePage << "<SUBJECT>" << sSubject << "</SUBJECT>";
//	sWholePage << "<GUIDE><BODY>" << sBody << "</BODY></GUIDE>";
	sWholePage << sBody;
	sWholePage << "</ARTICLE>";
	if (CXMLObject::CreateFromXMLText(sWholePage)) 
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CPageBody::GetBodyText(CTDVString *oText)
{
	*oText = m_sBodyText;
	return true;
}

bool CPageBody::GetSubject(CTDVString *oSubject)
{
	*oSubject = m_sSubject;
	return true;
}

/*********************************************************************************

	void CPageBody::UpdateSubjectAndBody()

	Author:		Jim Lynn
	Created:	29/10/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Updates the subject and bodytext member variables from the XML tree

*********************************************************************************/
void CPageBody::UpdateSubjectAndBody()
{
	// Make sure we've got a tree to play with!
	if (m_pTree != NULL)
	{
		// Try to get the subject
		CXMLTree* pSubject = m_pTree->FindFirstTagName("SUBJECT");
		if (pSubject != NULL)
		{
			pSubject->GetTextContents(m_sSubject);
		}

		// try to get the body
		CXMLTree* pBody = m_pTree->FindFirstTagName("FRONTPAGE",NULL,false);
		if (pBody != NULL)
		{
			pBody->OutputXMLTree(m_sBodyText);
		}
	}
}

void CPageBody::UpdateBody()
{
	if (m_pTree != NULL)
	{
		CXMLTree* pBody = m_pTree->FindFirstTagName("FRONTPAGE");
		if (pBody != NULL)
		{
			if(!m_sBodyText.IsEmpty())
			{
				m_sBodyText.Empty();
			}
			pBody->OutputXMLTree(m_sBodyText);
		}
	}
}

bool CPageBody::GetTagContentsAsXML(const TDVCHAR* pTag, CTDVString& sText)
{
	TDVASSERT(m_pTree != NULL, "CPageBody::GetTagContents(...) called with NULL tree");

	// an empty tree contains no body, as the saying goes
	if (m_pTree == NULL)
	{
		return false;
	}

	// if pTemp ends up NULL at any point then the tree does not contain
	// a body so something is wrong
	// body of the guide entry is everything inside the GUIDE section, but including
	// the GUIDE tag itself. This is a bit naff but thats how it seems to work
	CXMLTree* pTemp = m_pTree->FindFirstTagName(pTag);
	if (pTemp != NULL)
	{
		// might as well stuff the output straight into our output parameter
		// since we have no idea whether it worked or not anyway
		//pTemp->OutputXMLTree(sText);
		pTemp->OutputChildrenXMLTree(sText);
		
	}
	// I love a function that always returns true, don't you?
	return true;
}

bool CPageBody::SetElementText(const TDVCHAR* pNodeName, CTDVString& sText)
{
	TDVASSERT(m_pTree != NULL, "CPageBody::SetElementText(...) called with NULL tree");

	// an empty tree contains no body, as the saying goes
	if (m_pTree == NULL)
	{
		return false;
	}

	// if pTemp ends up NULL at any point then the tree does not contain
	// a body so something is wrong
	// body of the guide entry is everything inside the GUIDE section, but including
	// the GUIDE tag itself. This is a bit naff but thats how it seems to work
	CXMLTree* pTemp = m_pTree->FindFirstTagName(pNodeName);
	if (pTemp != NULL)
	{
		// might as well stuff the output straight into our output parameter
		// since we have no idea whether it worked or not anyway
		//pTemp->OutputXMLTree(sText);
		CXMLTree* pTemp1 = pTemp->ParseForInsert(sText);
		pTemp->AddChild(pTemp1);
	}
	// I love a function that always returns true, don't you?
	return true;
}

/*********************************************************************************

	bool CPageBody::UpdateExtraInfo(CExtraInfo& ExtraInfo)

		Author:		Mark Howitt
        Created:	05/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Updates the extrainfo member variable from the current xml tree contents

*********************************************************************************/
bool CPageBody::UpdateExtraInfo(CExtraInfo& ExtraInfo)
{
	// Set the extra info from the given one
	if (ExtraInfo.IsCreated())
	{
		m_ExtraInfo = ExtraInfo;
		return true;
	}

	TDVASSERT(false,"CPageBody::UpdateExtraInfo - ExtraInfo param not created!");
	return false;
}

