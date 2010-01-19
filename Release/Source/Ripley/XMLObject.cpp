// XMLObject.cpp: implementation of the CXMLObject class.
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
#include "XSLT.h"
#include "RipleyServer.h"
#include "InputContext.h"
#include "XMLObject.h"
#include "Forum.h"
#include "SmileyList.h"
#include "Smileytranslator.h"
#include "TDVAssert.h"
//#include "..\Crypto\md5.h"	// Jim: Removed because the helper function is never called

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CXMLObject::CXMLObject(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	22/02/2000
	Inputs:		pDatabaseContext, a pointer to a database context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class with all data members
				correctly initialised. For this base class there is no
				meaningful initialisation method, so this is left to be
				implemented by subclasses.

*********************************************************************************/

CXMLObject::CXMLObject(CInputContext& inputContext) :
	CXMLError(),
	m_InputContext(inputContext),
	m_pTree(NULL), m_pCurNode(NULL), m_pPrevNode(NULL)
{
// no further construction required here
}

CXMLObject::CXMLObject() :
	CXMLError(),
	m_InputContext(m_DummyInputContext),
	m_pTree(NULL), m_pCurNode(NULL), m_pPrevNode(NULL)
{
// no further construction required here
}

/*********************************************************************************

	CXMLObject::~CXMLObject()

	Author:		Kim Harries
	Created:	22/02/2000
	Modified:	24/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated. It is
				virtual in order to ensure correct deallocation for subclasses,
				which should override this destructor and do their own release
				of resources.

*********************************************************************************/

CXMLObject::~CXMLObject()
{
	// checks that tree is not null first
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
}

/*********************************************************************************

	bool CXMLObject::CreateFromXMLText(const TDVCHAR* pXMLText, CTDVString* pErrorReport, bool bDestroyTreeFirst)

	Author:		Kim Harries
	Created:	22/02/2000
	Modified:	07/04/2000
	Inputs:		xmlText - well-formed XML inside a CTDVString, used to build
				the initial contents of the XML tree.
	Outputs:	pErrorReport - a string in which to put a copy of the XML text
					with the parse errors marked-up, or NULL if not required
	Returns:	true if successful, false if it failed.
	Purpose:	Takes the well-formed XML represented by xmlText and builds an
				XML tree. Will only fail if it cannot parse the tree at all.
				Many parse errors will just result in a tree with error nodes being
				formed, in which case these will be reported in the error report.

*********************************************************************************/

bool CXMLObject::CreateFromXMLText(const TDVCHAR* pXMLText, CTDVString* pErrorReport, bool bDestroyTreeFirst)
{
	// check to see if we're required to destroy the existsing tree?
	if (m_pTree != NULL && bDestroyTreeFirst)
	{
		if (!Destroy())
		{
			TDVASSERT(false,"Failedto destroy the tree when requested!");
			return false;
		}
	}

	TDVASSERT(pXMLText != NULL, "CXMLObject::CreateFromXMLText(...) called with NULL pointer");
	TDVASSERT(m_pTree == NULL, "CXMLObject::CreateFromXMLText(...) called on non-empty XML object"); // should only initialise an empty object

	// make sure error report is empty if nothing goes wrong
	if (pErrorReport != NULL)
	{
		pErrorReport->Empty();
	}
	if (m_pTree != NULL)
	{
		return false;
	}
	else
	{
		long errors = 0;

		m_pTree = CXMLTree::Parse(pXMLText, true, &errors);
// a NULL tree indicates something went wrong
// possible exception => when passed empty text a NULL tree is returned
// should this be a failure ???
		
		TDVASSERT(m_pTree != NULL, "Parse returned NULL tree in CreateFromXMLText");

		if (m_pTree == NULL)
		{
			return false;
		}
		else
		{  
			TDVASSERT(errors == 0, "Errors found parsing XML text in CreateFromXMLText");

			if (errors > 0)
			{
				// if we have an error report string then put a copy of the xml text
				// in there with the errors marked up
				if (pErrorReport != NULL)
				{
					*pErrorReport = m_pTree->DisplayErrors(pXMLText);
				}
#ifdef _DEBUG
				m_pTree->DebugDumpErrors();
#endif
			}
			return true; // parse was successfull, even if there were some errors
		}
	}
}

/*********************************************************************************

	CTDVString CXMLObject::ParseXMLForErrors(const TDVCHAR* pXMLText)

	Author:		Kim Harries
	Created:	07/04/2000
	Inputs:		pXMLText - the xml text we are parsing for errors
	Outputs:	-
	Returns:	empty string if no errors, otherwise a string containing the XML
				text marked-up to indicate parse errors
	Purpose:	Checks whether a chunk of XML parses okay or not, and if not attempts
				to produce a parse error report

*********************************************************************************/

CTDVString CXMLObject::ParseXMLForErrors(const TDVCHAR* pXMLText)
{
	long lErrors = 0;
	CXMLTree* pTemp = CXMLTree::Parse(pXMLText, true, &lErrors);
	CTDVString sParseErrorReport;

	// make sure the error report is empty first
	sParseErrorReport.Empty();
	if (pTemp == NULL)
	{
		sParseErrorReport = "<XMLERROR>XML could not be parsed</XMLERROR>";
		TDVASSERT(false,"CXMLObject::ParseXMLForErrors - Cannot parse test!!!");
	}
	else if (lErrors > 0)
	{
		sParseErrorReport = pTemp->DisplayErrors(pXMLText);
		TDVASSERT(false,"CXMLObject::ParseXMLForErrors - " + CTDVString(lErrors) + " Parsing error(s) found!!!");
	}
	else
	{
		CXSLT xslt;
		CTDVString sParseError;
		CTDVString sErrorLine;
		int iLineNo = 0;
		int iLinePos = 0;
		bool bParseErrors = xslt.GetParsingErrors(pXMLText, &sParseError, &sErrorLine, &iLineNo, &iLinePos);
		
		if (!bParseErrors)
		{
			// adjust the line no. given to be the right one for our text, not the MS parsers version
			// TODO: seems to be okay, but must check that this works in all cases
			iLineNo -= 268;
			// now find the right line inside pXMLText, and calculate that character position
			// in our string
			CTDVString sTemp = pXMLText;
			int iPos = -1;
			int iLineCount = 1;
			int iLen = sTemp.GetLength();
			while (iPos < iLen && iLineCount < iLineNo)
			{
				iPos++;
				if (iPos < iLen && sTemp[iPos] == '\n')
				{
					iLineCount++;
				}
			}
			iPos += iLinePos;
			// put some marker text in for the start and end of the bits we want to
			// highlight - the error message given by the MS parser
			// this prevents the formatting stuff from being escaped
			if (iPos < iLen)
			{
				int iMessage = sParseError.FindText("XML Parsing error found:");
				if (iMessage >= 0)
				{
					iMessage += 25;
					sParseError = sParseError.Mid(iMessage);
				}
				sTemp = sTemp.Left(iPos + 1) + "!!!START-OF-PARSE-ERROR!!!" + sParseError + "!!!END-OF-PARSE-ERROR!!!" + sTemp.Mid(iPos + 1);
			}
			else
			{
				int iMessage = sParseError.FindText("XML Parsing error found:");
				if (iMessage >= 0)
				{
					iMessage += 25;
					sParseError = sParseError.Mid(iMessage);
				}
				sTemp <<  "!!!START-OF-PARSE-ERROR!!!" << sParseError << "!!!END-OF-PARSE-ERROR!!!";
			}
			CXMLObject::EscapeXMLText(&sTemp);
			// now put BR tags in for newlines and replace the marker text
			// with the formatting tags we want
			sTemp.Replace("\n", "<BR/>");
			sTemp.Replace("!!!START-OF-PARSE-ERROR!!!", "<XMLERROR>");
			sTemp.Replace("!!!END-OF-PARSE-ERROR!!!", "</XMLERROR>");
			// now build up the preview article from the various error messages
//			CXMLObject::EscapeXMLText(&sParseError);
//			CXMLObject::EscapeXMLText(&sErrorLine);
//			sParseErrorReport << "<PARSE-ERROR><DESCRIPTION>" << sParseError << "</DESCRIPTION>";
//			sParseErrorReport << "<LINE>" << sErrorLine << "</LINE>";
//			sParseErrorReport << "<LINENO>" << iLineNo << "</LINENO>";
//			sParseErrorReport << "<LINEPOS>" << iLinePos << "</LINEPOS>";
//			sParseErrorReport << "</PARSE-ERROR>";
//			sParseErrorReport << "<BR/><BR/>" << sTemp;
			sParseErrorReport = sTemp;
			TDVASSERT(false,"CXMLObject::ParseXMLForErrors - Parse errors found!!!");
		}
	}


	delete pTemp;
	pTemp = NULL;
	return sParseErrorReport;
}

/*********************************************************************************

	bool CXMLObject::FindTagPairs(const TDVCHAR* pXMLText, const TDVCHAR* pTagName,
								  int* pOpenTagPos, int* pCloseTagPos, int iStartPos)

	Author:		Kim Harries
	Created:	03/07/2000
	Inputs:		pXMLText - the XML text within which to find the tag pairs
				pTagName - the name of the tags which you are searching for
				iStartPos - the position in the string from which to start searching
	Outputs:	pOpenTagPos - the position of the first opening tag found, or -1 if
					none found. Pass NULL if this data not requied.
				pCloseTagPos - the position of the close tag that matches that opening
					tag, or -1 if none found. Pass NULL if this data not requied.
	Returns:	true if tag pairs found okay and no errors occurred, false otherwise.
	Purpose:	Takes a piece of XML text and a starting position and returns the
				position of first opening tag that matches the name provided and the
				position of its corresponding close tag.

*********************************************************************************/

bool CXMLObject::FindTagPairs(const TDVCHAR* pXMLText, const TDVCHAR* pTagName, int* pOpenTagPos, int* pCloseTagPos, UINT iStartPos)
{
	TDVASSERT(iStartPos >= 0, "iStartPos < 0 in CXMLObject::FindTagPairs(...)");

	// fail if start pos is not sensible
	if (iStartPos < 0 || iStartPos >= strlen(pXMLText))
	{
		return false;
	}

	CTDVString sXML = pXMLText;
	CTDVString sOpenTag = "";
	CTDVString sCloseTag = "";
	int iOpenPos = -1;
	int iClosePos = -1;
	int iCount = 0;

	// construct the actual text to search for for the open and close tags
	sOpenTag << "<" << pTagName;
	sCloseTag << "</" << pTagName;
	iOpenPos = sXML.FindText(sOpenTag);

	if (iOpenPos >= 0)
	{
		int iCurrentPos = iOpenPos;
		int iNextOpen = 0;
		int iNextClose = 0;
		int iPos = 0;

		// keep a count of how many tags have been opened and not closed
		// first check that this is not a special case empty tag
		iPos = sXML.Find(">", iOpenPos);
		TDVASSERT(iPos >= 0, "Failed to find end > on opening tag in CXMLObject::FindTagPairs(...)");
		// fail if pos makes no sense
		if (iPos <= 0)
		{
			return false;
		}
		// if this is an empty tag then open and close tags have same pos
		if (sXML[iPos - 1] == '/')
		{
			iClosePos = iOpenPos;
			iCount = 0;
		}
		else
		{
			// otherwise we have one open tag to start with
			iCount = 1;
		}
		// so long as iCount > 0 we have not found the matching close tag
		while (iCount > 0)
		{
			iNextOpen = sXML.FindText(sOpenTag, iCurrentPos + 1);
			iNextClose = sXML.FindText(sCloseTag, iCurrentPos + 1);

			// if there is another open tag before the next close tag
			if (iNextOpen >= 0 && (iNextClose < 0 || iNextOpen < iNextClose))
			{
				// check that this is not a special case empty tag
				iPos = sXML.Find(">", iNextOpen);
				TDVASSERT(iPos >= 0, "Failed to find end > on opening tag in CXMLObject::FindTagPairs(...)");
				// fail if pos makes no sense, as we have broken XML
				if (iPos <= 0)
				{
					return false;
				}
				// if this is an empty tag then it doesn't affect the count
				// otherwise increment the counter as we have opened another tag
				if (sXML[iPos - 1] != '/')
				{
					iCount++;
					iCurrentPos = iNextOpen;
				}
			}
			// if there is a closing tag before the next opening one
			else if (iNextClose >= 0 && (iNextOpen < 0 || iNextClose < iNextOpen))
			{
				iCount--;
				iCurrentPos = iNextClose;
			}
			else
			{
				// neither a close tag nor another opening one was found
				// so fail since the XML must be broken
				TDVASSERT(false, "Tags don't match up in CXMLObject::FindTagPairs(...)");
				return false;
			}
		}
		// if iCount is zero then the open and close tags matched up okay
		// otherwise they did not
		if (iCount == 0)
		{
			iClosePos = iCurrentPos;
		}
	}
	// set the output variables if they have been provided
	// regardless of success
	if (pOpenTagPos != NULL)
	{
		*pOpenTagPos = iOpenPos;
	}
	if (pCloseTagPos != NULL)
	{
		*pCloseTagPos = iClosePos;
	}
	// successful only if both an opening and closing tag found
	return iOpenPos >= 0 && iClosePos >= 0;
}


/*********************************************************************************

	bool CXMLObject::IsEmpty()

	Author:		Kim Harries
	Created:	23/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if object is empty, false otherwise
	Purpose:	Checks if object currently contains anything at all. Prevents the
				need to query the inernal representation (e.g. the tree pointer)
				to discover the status of the object.

*********************************************************************************/

bool CXMLObject::IsEmpty()
{
	return (m_pTree == NULL); // empty if tree is NULL
}

/*********************************************************************************

	bool CXMLObject::Destroy()

	Author:		Kim Harries
	Created:	23/02/2000
	Modified:	24/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	true on successful destruction of contents, false otherwise
				- should always succeed however.
	Purpose:	Destroys the internal representation of this objects XML tree,
				leaving the object empty. This is NOT the same as deleting the
				object itself, since the object still exists and can now be
				re-initialised if requierd.

*********************************************************************************/

bool CXMLObject::Destroy()
{
	if (!this->IsEmpty())
	{
		m_pTree->DetachNodeTree(); // this should not be necessary, but just in case
		delete m_pTree;
		m_pTree = NULL;
	}
	return true;
}

/*********************************************************************************

	bool CXMLObject::AddInside(const TDVCHAR *pTagName, CXMLObject *pObject)

	Author:		Jim Lynn, Kim Harries, Oscar Gillesbie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	01/03/2000
	Inputs:		pTagName - name of tag into which to add the tree
				pObject - ptr to CXMLObject whose tree should be added
	Outputs:	-
	Returns:	true if successful, false if it failed.
	Purpose:	takes the XML tree generated by pObject and inserts it into
				this object, as a child of the first instance of the named
				tag.

				Implementation question: Does this function remove the nodes
				physically from its internal tree, or does it make a copy?
				- currently removes it.

*********************************************************************************/

bool CXMLObject::AddInside(const TDVCHAR *pTagName, CXMLObject *pObject)
{
	TDVASSERT(pTagName != NULL, "CXMLObject::AddInside(...) called with NULL TDVCHAR pointer");
	TDVASSERT(pObject != NULL, "CXMLObject::AddInside(...) called with NULL CXMLObject pointer");
	TDVASSERT(m_pTree != NULL, "CXMLObject::AddInside(...) called on empty XML object");

	// Make sure we call the virtual IsEmpty function on pObject so it
	// accurately reports if it can deliver a tree
	if (pTagName == NULL || m_pTree == NULL || pObject == NULL || pObject->IsEmpty())
	{
// Nonsense to add a NULL tree, or to add into one, plus must give a tag name
		return false;
	}
	else
	{
// current behaviour is to find the first matching tag, though perhaps if
// there are multiple matching tags alternative behaviour should be defined
		CXMLTree* pTemp = m_pTree->FindFirstTagName(pTagName);

		if (pTemp == NULL) // no matching tag => return failure
		{
			return false;
		}
		else
		{
// pObject relinquishes all control of its CXMLTree and no longer has a
// pointer to it ???

			// Note that because of the nature of XML parsing, the root of any
			// XML tree will *not* be an actual element. So this function must
			// Find the first node which is a T_NODE type and insert that.

			CXMLTree* pNodeToInsert = pObject->ExtractTree();

			// if we successfully found a node, use it
			if (pNodeToInsert != NULL)
			{
				// Insert it into the main object
				pTemp->AddChild(pNodeToInsert);
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}

/*********************************************************************************

	bool CXMLObject::AddInside(const TDVCHAR *pTagName, const TDVCHAR* pXMLText)

	Author:		Kim Harries
	Created:	22/02/2000
	Modified:	01/03/2000
	Inputs:		pTagName - name of tag into which to add the tree
				pXMLText - well-formed XML text to be added to tree
	Outputs:	-
	Returns:	true if successful, false if it failed.
	Purpose:	Takes the well-formed XML represented by xmlText and inserts
				inside the named tag node of the XML tree. Will fail if the XML
				text is not well-formed.

*********************************************************************************/

bool CXMLObject::AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText)
{
	TDVASSERT(pXMLText != NULL, "CXMLObject::AddInside(...) called with NULL TDVCHAR pointer");
	TDVASSERT(pTagName != NULL, "CXMLObject::AddInside(...) called with NULL TDVCHAR pointer");
	TDVASSERT(!this->IsEmpty(), "CXMLObject::AddInside(...) called on empty XML object");

// WARNING !!!
// This function realies on the other AddInside method not leaving the inserted
// xml object in a state whereby it still points to the same tree inside this object

	CXMLObject temp(m_InputContext);
	bool bSuccess = temp.CreateFromXMLText(pXMLText);

	if (!bSuccess)		// if could not initialise temp object all is doomed
	{
		return false;
	}					// otherwise use add inside on new object
	else				// - since it is created on the stack its memory will
	{					// be released appropriately
		return this->AddInside(pTagName, &temp);
	}
}

/*********************************************************************************

	bool CXMLObject::SetAttribute(const TDVCHAR* pTagName, const TDVCHAR* pAttributeName, const TDVCHAR* pAttributeValue)

	Author:		Kim Harries
	Created:	09/11/2000
	Inputs:		pTagName - name of tag which we are adding an attribute to
				pAttributeName - name of the new attribute
				pAttributeValue - value of the new attribute
	Outputs:	-
	Returns:	true if successful, false if it failed.
	Purpose:	Set the value of the named attribute on the named tag. Creates the
				attribute if it does not already exist. Fails if the tag name is not
				found.

*********************************************************************************/

bool CXMLObject::SetAttribute(const TDVCHAR* pTagName, const TDVCHAR* pAttributeName, const TDVCHAR* pAttributeValue)
{
	TDVASSERT(m_pTree != NULL, "CXMLObject::AddAttribute(...) called on empty XML object");
	CXMLTree* pTemp = m_pTree->FindFirstTagName(pTagName);
	if (pTemp == NULL)
	{
		return false;
	}
	else
	{
		pTemp->SetAttribute(pAttributeName, pAttributeValue);
		return true;
	}
}

/*********************************************************************************

	bool CXMLObject::RemoveTag(const TDVCHAR* pTagName)

	Author:		Kim Harries
	Created:	14/06/2000
	Inputs:		pTagName - the name of the tag which is to be removed
	Outputs:	-
	Returns:	true for success, false otherwise.
	Purpose:	Removes the named tag and all its children from the internal
				representation of the XML. Will find the first tag with the given
				name and remove it, but any other tags with the same name will be
				left untouched. Returns true is successful, or false if failed or
				tag was not found.

*********************************************************************************/

bool CXMLObject::RemoveTag(const TDVCHAR* pTagName)
{
	TDVASSERT(m_pTree != NULL, "CXMLObject::RemoveTag(...) called with NULL m_pTree");
	TDVASSERT(pTagName != NULL, "CXMLObject::RemoveTag(...) called with NULL TDVCHAR pointer");

	// fail if no tag name provided or object is empty
	if (m_pTree == NULL || pTagName == NULL)
	{
		return false;
	}
	// otherwise find the node with the given tag name
	CXMLTree* pTemp = m_pTree->FindFirstTagName(pTagName, 0, false);
	if (pTemp == NULL)
	{
		// tag not found, so fail
		return false;
	}
	// otherwise detach the node, delete it, and return true for success
	pTemp->DetachNodeTree();
	delete pTemp;
	pTemp = NULL;
	return true;
}

/*********************************************************************************

	bool CXMLObject::RemoveTagIfItsAchild(const TDVCHAR* pTagName)

	Author:		Kim Harries
	Created:	14/06/2000
	Inputs:		pTagName - the name of the tag which is to be removed
	Outputs:	-
	Returns:	true for success, false otherwise.
	Purpose:	Removes the named tag and all its children from the internal
				representation of the XML. Will find the first tag with the given
				name and remove it but only as a child of the current position, but any other tags with the same name will be
				left untouched. Returns true is successful, or false if failed or
				tag was not found.

*********************************************************************************/

bool CXMLObject::RemoveTagIfItsAChild(const TDVCHAR* pTagName)
{
	TDVASSERT(m_pTree != NULL, "CXMLObject::RemoveTag(...) called with NULL m_pTree");
	TDVASSERT(pTagName != NULL, "CXMLObject::RemoveTag(...) called with NULL TDVCHAR pointer");

	// fail if no tag name provided or object is empty
	if (m_pTree == NULL || pTagName == NULL)
	{
		return false;
	}
	// otherwise find the node with the given tag name
	CXMLTree* pTemp = m_pTree->FindFirstTagName(pTagName,m_pTree,false);
	if (pTemp == NULL)
	{
		// tag not found, so fail
		return false;
	}
	// otherwise detach the node, delete it, and return true for success
	pTemp->DetachNodeTree();
	delete pTemp;
	pTemp = NULL;
	return true;
}

/*********************************************************************************

	bool CXMLObject::RemoveTagContents(const TDVCHAR* pTagName)

	Author:		Kim Harries
	Created:	14/06/2000
	Inputs:		pTagName - the name of the tag whose contents are to be removed
	Outputs:	-
	Returns:	true for success, false otherwise.
	Purpose:	Removes all the tags inside the named tag and all their children
				from the internal representation of the XML. Will only find the
				first tag with the given name and remove its contents - any other
				tags with the same name will be left untouched. Returns true is
				successful, or false if failed or tag was not found. If the tag is
				found but is already empty, true is returned.

*********************************************************************************/

bool CXMLObject::RemoveTagContents(const TDVCHAR* pTagName)
{
	TDVASSERT(m_pTree != NULL, "CXMLObject::RemoveTag(...) called with NULL m_pTree");
	TDVASSERT(pTagName != NULL, "CXMLObject::RemoveTag(...) called with NULL TDVCHAR pointer");

	// fail if no tag name provided or object is empty
	if (m_pTree == NULL || pTagName == NULL)
	{
		return false;
	}
	// otherwise find the node with the given tag name
	CXMLTree* pTag = m_pTree->FindFirstTagName(pTagName);
	if (pTag == NULL)
	{
		// tag not found, so fail
		return false;
	}
	// otherwise keep finding first child and removing it until there is no longer
	// a first child to remove, then the tag must be empty
	CXMLTree* pTemp = pTag->GetFirstChild();
	while (pTemp != NULL)
	{
		pTemp->DetachNodeTree();
		delete pTemp;
		pTemp = NULL;
		pTemp = pTag->GetFirstChild();
	}
	// operation was successful
	return true;
}

/*********************************************************************************

	bool CXMLObject::GetAsString(CTDVString& sResult)

	Author:		Kim Harries
	Created:	22/02/2000
	Inputs:		-
	Outputs:	sResult, a string that will contain the text representation
				of this XML object on a successful call.
	Returns:	true for success, false otherwise.
	Purpose:	Converts the XML represented by the current instance from whatever
				its internal format is (e.g. a CXMLTree) into text format
				e.g. <H2G2><ARTICLE>Stuff</ARTICLE></H2G2>

*********************************************************************************/

bool CXMLObject::GetAsString(CTDVString &sResult)
{
	if (this->IsEmpty())
	{
// could instead return an empty string ???
		return false;
	}
	else
	{
// CXMLTree method needs to report if an error occurs, which
// currently it doesn't ???
		m_pTree->OutputXMLTree(sResult);
		return true;
	}
}


/*********************************************************************************

	CXMLTree* CXMLObject::ExtractTree()

	Author:		Jim Lynn
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	pointer to root element node of the XML tree
				Returns NULL if there was no suitable node.
	Purpose:	Extracts the tree from the XML object suitable for inserting into
				another XML object. Base class implementation will destroy the 
				member tree and pass out a pointer to the root element node (which
				won't be the root node of the internal tree - it will be of type 
				CXMLTagNode). This will leave the object empty.
				Note: The calling code becomes the owner of the tree returned,
				as is responsible for deleting it or otherwise disposing of it.

*********************************************************************************/

CXMLTree* CXMLObject::ExtractTree()
{
	// Don't even bother if the tree is empty
	if (m_pTree == NULL)
	{
		return NULL;
	}

	// Get a pointer to the root (T_NONE) node
	CXMLTree* pNodeToInsert = m_pTree;

	// Scan through the tree until we find a node of type T_NODE
	// because that's the root named node we want to extract
	while ((pNodeToInsert != NULL) && (pNodeToInsert->GetNodeType() != CXMLTree::T_NODE))
	{
		pNodeToInsert = pNodeToInsert->FindNext();
	}

	// if we successfully found a node, use it
	if (pNodeToInsert != NULL)
	{
		// Detach this node from the rest of the tree
		pNodeToInsert->DetachNodeTree();

		// Destroy the remaining bits of the tree
		this->Destroy();
		
		// return the tree to the caller
		return pNodeToInsert;
	}
	else
	{
		return NULL;
	}

}

/*********************************************************************************

	bool CXMLObject::DoesTagExist(const TDVCHAR* pNodeName)

	Author:		Jim Lynn
	Created:	01/03/2000
	Inputs:		pNodeName - name of tag to find
	Outputs:	-
	Returns:	true if tag was found, false otherwise
	Purpose:	Asks the XML object if it contains the named tag node.

*********************************************************************************/

bool CXMLObject::DoesTagExist(const TDVCHAR* pNodeName)
{
	// Must be false if there's no tree
	if (m_pTree == NULL)
	{
		return false;
	}

	// It's true if FindFirstTagName returns a pointer instead of NULL
	if (m_pTree->FindFirstTagName(pNodeName,NULL,false) != NULL)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CXMLObject::UpdateRelativeDates()
{
	// Check for tree existence
	TDVASSERT(m_pTree != NULL, "Null XML Object tree found in UpdateRelativeDates");
	if (m_pTree == NULL)
	{
		return false;
	}

	CXMLTree* pNode = m_pTree->FindFirstTagName("DATE",NULL,false);
	while (pNode != NULL)
	{
		int Day = pNode->GetIntAttribute("DAY");
		int Month = pNode->GetIntAttribute("MONTH");
		int Year = pNode->GetIntAttribute("YEAR");
		int Hours = pNode->GetIntAttribute("HOURS");
		int Minutes = pNode->GetIntAttribute("MINUTES");
		int Seconds = pNode->GetIntAttribute("SECONDS");

		if (Day > 0 && Month > 0 && Year > 0)
		{
			CTDVDateTime dDate(Year, Month, Day, Hours, Minutes, Seconds);

			CTDVString sRelative = "";
			
			dDate.GetRelativeDate(sRelative);
			
			pNode->SetAttribute("RELATIVE",sRelative);
		}

		pNode = pNode->FindNextTagNode("DATE");
	}
	return true;
}

/*********************************************************************************

	void CXMLObject::EscapeXMLText(CTDVString *pString)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		pString - string to escape
	Outputs:	pString - escaped string
	Returns:	-
	Purpose:	Escapes & < and > characters in text which needs to be output
				to the XML stream. Any plain text (like article subjects, usernames,
				etc.) should be passed through this function before being sent to
				the XML stream, otherwise the stylesheet will choke on it.

	Note:		Since some XML entities are allowed in plain text entries these
				are not escaped by this method. Should you for some reason need
				to escape all XML then use the EscapeAllXML method below.

*********************************************************************************/

void CXMLObject::EscapeXMLText(CTDVString *pString)
{
	//pString->Replace("&","&amp;");
	CXMLTree::FlagAmpersandErrors(*pString, false, NULL, NULL, 0, pString);
	pString->Replace("<","&lt;");
	pString->Replace(">","&gt;");
}

/*********************************************************************************

	void CXMLObject::EscapeAllXML(CTDVString *pString)

	Author:		Kim Harries
	Created:	17/05/2000
	Inputs:		pString - string to escape
	Outputs:	pString - escaped string
	Returns:	-
	Purpose:	Escapes ALL & < and > characters in text. This should be used instead
				of the EscapeXMLText method above only when you need to ensure that
				all ampersand characters are escaped. The most likely place to use
				this is when escaping the XML in data that is to go inside a form.

*********************************************************************************/

void CXMLObject::EscapeAllXML(CTDVString *pString)
{
	pString->Replace("&","&amp;");
	pString->Replace("<","&lt;");
	pString->Replace(">","&gt;");
}

void CXMLObject::MakeSubjectSafe(CTDVString* pString)
{
	EscapeXMLText(pString);
}

/*********************************************************************************

	void CXMLObject::UnEscapeXMLText(CTDVString *pString)

	Author:		Kim Harries
	Created:	25/03/2000
	Inputs:		pString - string to reverse escape process on
	Outputs:	pString - unescaped string
	Returns:	-
	Purpose:	Reverses the escaping process above by replacing the xml escape
				sequences with the characters that they represent. Used basically
				to reverse the process of producing escaped xml text when for
				instance converting a Guide Entry from plain text back to GuideML.

*********************************************************************************/

void CXMLObject::UnEscapeXMLText(CTDVString *pString)
{
	pString->Replace("&amp;","&");
	pString->Replace("&lt;","<");
	pString->Replace("&gt;",">");
}

/*********************************************************************************

	void CXMLObject::DoPlainTextTranslations(CTDVString* pString)

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		pString - string to apply translations to
	Outputs:	pString - translated string
	Returns:	-
	Purpose:	Does all the translations that occur to plain text entries and forum
				postings, e.g. translating URLs and smilies.

*********************************************************************************/

void CXMLObject::DoPlainTextTranslations(CTDVString* pString)
{
	// make sure we don't try to process a NULL, and don't bother processing an empty one
	if (pString == NULL || pString->IsEmpty())
	{
		return;
	}
	
	CGI::ConvertPlainText(pString);
	return;

	// first replace the special XML characters with their escaped equivalents
	
	CTDVString temp = *pString;
	
	DWORD start = GetTickCount();
	
	pString->Replace("&","&amp;");
	pString->Replace("<","&lt;");
	pString->Replace(">","&gt;");

	// now get the smiley list and do each of the translations indicated there
	CSmileyList*	pSmilies = CGI::GetSmileyList();
	CTDVString		sTag = "<SMILEY TYPE='***' H2G2='Smiley#***'/>";
	CTDVString		sAscii = "";
	CTDVString		sName;
	int				iCount = 0;

	// go through list in order and replace each ascii sequence with its smiley equivalent
	for (iCount = 0; iCount < pSmilies->GetSize(); iCount++)
	{
		sTag = "<SMILEY TYPE='***' H2G2='Smiley#***'/>";
		sName = pSmilies->GetName(iCount);
		sTag.Replace("***", sName);
		sAscii = pSmilies->GetAscii(iCount);
		// string has had these translations made already, so must also do them on
		// the ascii sequence for the search and replace to work
		sAscii.Replace("&","&amp;");
		sAscii.Replace("<","&lt;");
		sAscii.Replace(">","&gt;");
		pString->Replace(sAscii, sTag);
	}
	// replace newlines with linebreaks
	pString->Replace("\r\n","<BR/>");
	pString->Replace("\n","<BR/>");

	// now search out every http:// sequence and turn it into a clickable link
	CTDVString newText = "";
	long pos;
	while ((pos = pString->FindText("http://")) >= 0)
	{
		// We've found an http so munge it
		// clip off everything before the string
		if (pos > 0)
		{
			newText += pString->Left(pos);
			*pString = pString->Mid(pos);
		}

		// get everything up to a space or end of string

		pos = pString->FindContaining("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890&?%-#*+_./:~=;");
		if (pos < 0)
		{
			pos = pString->GetLength();
		}

		CTDVString URL = pString->Left(pos);

		newText << "<LINK HREF=\"" << URL << "\">" << URL << "</LINK>";
		*pString = pString->Mid(pos);
	}
	*pString = newText + *pString;

}

/*********************************************************************************

	void CXMLObject::ReversePlainTextTranslations(CTDVString* pString)

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		pString - string to apply reverse translations to
	Outputs:	pString - translated string
	Returns:	-
	Purpose:	Reverses all the translations that occur to plain text entries and forum
				postings, e.g. undoes the translated URLs and smilies.

*********************************************************************************/

void CXMLObject::ReversePlainTextTranslations(CTDVString* pString)
{
	// attempt to ensure empty tags will be caught by the following replaces
	pString->Replace(" />", "/>");
	// also replace special GuideML sequences which are created automatically from
	// plain text entries

	// replace all the defined smiley tags with their ascii sequence equivalents
	// as defined in the smiley list
	CSmileyList*	pSmilies = CGI::GetSmileyList();
	CTDVString		sTag = "<SMILEY TYPE='***'/>";
	CTDVString		sAscii = "";
	int				iCount = 0;

	for (iCount = 0; iCount < pSmilies->GetSize(); iCount++)
	{
		sTag = "<SMILEY TYPE='***'/>";
		sTag.Replace("***", pSmilies->GetName(iCount));
		sAscii = pSmilies->GetAscii(iCount);
		pString->Replace(sTag, sAscii);
		sTag.Replace("'", "\"");
		pString->Replace(sTag, sAscii);
	}
	// now reverse the transformation of URL links
	// TODO: check how robust this code is

	CTDVString	sTextInURL;
	CTDVString	sTextOfLink;
	CTDVString	sTemp;
	TDVCHAR		cQuote = '\"';
	int			iPos = 0;
	int			iPosTemp = 0;
	int			iLinkOpen = -1;
	int			iLinkClose = -1;
	int			iEndOfURL = -1;
	bool		bOkay = true;

	// find the first link tag
	// only ones with HREF are produced automatically in plain text entries
	iLinkOpen = pString->FindText("<LINK HREF=");
	while (iLinkOpen >= 0)
	{
		// find the closing tag position for this link
		bOkay = CXMLObject::FindTagPairs(*pString, "LINK", &iLinkOpen, &iLinkClose, iLinkOpen);
		if (!bOkay)
		{
			// if failed then there must be something wrong with the XML
			TDVASSERT(false, "CXMLObject::FindTagPairs(...) failed in CXMLObject::GuideMLToPlainText(...)");
			break;
		}
		// find the quote char at beggining of URL
		iPos = pString->Find("\"", iLinkOpen);
		iPosTemp = pString->Find("\'", iLinkOpen);
		if (iPos < 0 && iPosTemp < 0)
		{
			// if no quote char found then the XML is broken
			TDVASSERT(false, "");
			break;
		}
		// use the first quote found
		if (iPosTemp < iPos && iPosTemp >= 0)
		{
			iPos = iPosTemp;
		}
		// get the quote char then move iPos to next char
		cQuote = pString->GetAt(iPos);
		iPos++;
		// find end of URL string and then extract the contents
		sTemp = cQuote;
		iEndOfURL = pString->Find(sTemp, iPos);
		if (iEndOfURL < 0)
		{
			TDVASSERT(false, "Could not find end of URL in CXMLObject::GuideMLToPlainText(...)");
			break;
		}
		sTextInURL = pString->Mid(iPos, iEndOfURL - iPos);
		// now replace that entire link with the contents of its URL
		// find the end of the close tag
		iLinkClose += 7;
		// get the text for the entire link
		sTextOfLink = pString->Mid(iLinkOpen, iLinkClose - iLinkOpen);
		// use replace - if there is more than one occurrence it will need to be replaced anyway
		pString->Replace(sTextOfLink, sTextInURL);
		// find the next link tag, if any
		iLinkOpen = pString->FindText("<LINK HREF=", iLinkOpen);
	}

	// and all the line breaks went back to being plain old newlines
	pString->Replace("<BR/>", "\n");
	// finally, replace the various xml escape sequences
	// do this *after* the other transformations so that no changes are made to escaped GuideML
	pString->Replace("&amp;", "&");
	pString->Replace("&lt;", "<");
	pString->Replace("&gt;", ">");
}

/*********************************************************************************

	void CXMLObject::PlainTextToGuideML(CTDVString* pString)

	Author:		Kim Harries
	Created:	25/03/2000
	Inputs:		pString - string to convert from plain text to GuideML
	Outputs:	pString - converted string
	Returns:	-
	Purpose:	Converts a piece of plain text into GuideML by escaping various
				characters that are special in xml and doing a few custom conversions.

*********************************************************************************/

void CXMLObject::PlainTextToGuideML(CTDVString* pString)
{
	// make sure we don't try to process a NULL, and don't bother processing an empty one
	if (pString == NULL || pString->IsEmpty())
	{
		return;
	}
	// do all the XML translations, smiley replacements, and URL translations
	DoPlainTextTranslations(pString);
	// put the GUIDE and BODY tags round the entry - remember that if there is a
	// <GUIDE><BODY> sequence in there already this will be escaped and be part of
	// the plain text entries content
	*pString = "<GUIDE><BODY>" + *pString + "</BODY></GUIDE>";
}
	
/*********************************************************************************

	void CXMLObject::GuideMLToPlainText(CTDVString* pString)

	Author:		Kim Harries
	Created:	25/03/2000
	Inputs:		pString - string to be converted to plain text
	Outputs:	pString - resulting plain text
	Returns:	-
	Purpose:	Converts the text from GuideML to plain text by replacing any special
				xml escape sequences with their appropriate characters, and reversing
				any custom conversions.

*********************************************************************************/

void CXMLObject::GuideMLToPlainText(CTDVString* pString)
{
	// old Chinese proverb say 'NULL string require no processing'
	if (pString == NULL || pString->IsEmpty())
	{
		return;
	}
	// first thing to do is strip off the surrounding GUIDE and BODY tags
	int iPos = 0;
	int iPosTemp = 0;
	int iLen = 0;

	// chop the opening GUIDE tag
	iLen = pString->GetLength();
	iPos = pString->Find("<GUIDE>");
	if (iPos >= 0)
	{
		iPos += 7; // length of <GUIDE>
		*pString = pString->Right(iLen - iPos);
	}
	// chop the opening BODY tag
	iLen = pString->GetLength();
	iPos = pString->Find("<BODY>");
	if (iPos >= 0)
	{
		iPos += 6; // length of <BODY>
		*pString = pString->Right(iLen - iPos);
	}
	// chop the closing GUIDE tag, ensuring this is the last one (there should only be one of course)
	iPosTemp = pString->Find("</GUIDE>");
	while (iPosTemp >= 0)
	{
		iPos = iPosTemp;
		iPosTemp = pString->Find("</GUIDE>", iPos + 1);
	}
	if (iPos >= 0)
	{
		*pString = pString->Left(iPos);
	}
	// chop the closing BODY tag, making sure it is the last one
	iPosTemp = pString->Find("</BODY>");
	while (iPosTemp >= 0)
	{
		iPos = iPosTemp;
		iPosTemp = pString->Find("</BODY>", iPos + 1);
	}
	if (iPos >= 0)
	{
		*pString = pString->Left(iPos);
	}
	// now reverse any xml escape sequences and GuideML transformations
	ReversePlainTextTranslations(pString);
}
	
/*********************************************************************************

	void CXMLObject::GuideMLToHTML(CTDVString* pString)

	Author:		Kim Harries
	Created:	27/03/2000
	Inputs:		pString - string to be converted to HTML
	Outputs:	pString - resulting HTML
	Returns:	-
	Purpose:	Converts the text from GuideML to HTML bu removing the surrounding
				GUIDE and BODY tags, and also the CDATA section tags. It also unescapes
				any ]]> sequences in the HTML itself.

*********************************************************************************/

void CXMLObject::GuideMLToHTML(CTDVString* pString)
{
	// old Chinese proverb say 'NULL string require no processing'
	if (pString == NULL || pString->IsEmpty())
	{
		return;
	}
	// first thing to do is strip off the surrounding GUIDE and BODY tags
	int iPos = 0;
	int iPosTemp = 0;
	int iLen = 0;

	// TODO: check this works okay
	// could get aways with only choping the inner most tags, but doing all of them
	// seperately is probably safer...?
	// chop the opening GUIDE tag
	iLen = pString->GetLength();
	iPos = pString->Find("<GUIDE>");
	if (iPos >= 0)
	{
		iPos += 7; // length of <GUIDE>
		*pString = pString->Right(iLen - iPos);
	}
	// chop the opening BODY tag
	iLen = pString->GetLength();
	iPos = pString->Find("<BODY>");
	if (iPos >= 0)
	{
		iPos += 6; // length of <BODY>
		*pString = pString->Right(iLen - iPos);
	}
	// chop the opening PASSTHROUGH tag
	iLen = pString->GetLength();
	iPos = pString->Find("<PASSTHROUGH>");
	if (iPos >= 0)
	{
		iPos += 13; // length of <PASSTHROUGH>
		*pString = pString->Right(iLen - iPos);
	}
	// chop the opening CDATA tag
	iLen = pString->GetLength();
	iPos = pString->Find("<![CDATA[");
	if (iPos >= 0)
	{
		iPos += 9; // length of <![CDATA[
		*pString = pString->Right(iLen - iPos);
	}
	// chop the closing GUIDE tag
	// need to make sure it is the outermost tag in each case that is chopped, since
	// HTML will have a BODY tag in it, and could possibly contain the other tags
	iPosTemp = pString->Find("</GUIDE>");
	while (iPosTemp >= 0)
	{
		iPos = iPosTemp;
		iPosTemp = pString->Find("</GUIDE>", iPos + 1);
	}
	if (iPos >= 0)
	{
		*pString = pString->Left(iPos);
	}
	// chop the closing BODY tag
	iPosTemp = pString->Find("</BODY>");
	while (iPosTemp >= 0)
	{
		iPos = iPosTemp;
		iPosTemp = pString->Find("</BODY>", iPos + 1);
	}
	if (iPos >= 0)
	{
		*pString = pString->Left(iPos);
	}
	// chop the closing ]]> tag
	iPosTemp = pString->Find("]]>");
	while (iPosTemp >= 0)
	{
		iPos = iPosTemp;
		iPosTemp = pString->Find("]]>", iPos + 1);
	}
	if (iPos >= 0)
	{
		*pString = pString->Left(iPos);
	}
	// chop the closing PASSTHROUGH tag
	iPosTemp = pString->Find("</PASSTHROUGH>");
	while (iPosTemp >= 0)
	{
		iPos = iPosTemp;
		iPosTemp = pString->Find("</PASSTHROUGH>", iPos + 1);
	}
	if (iPos >= 0)
	{
		*pString = pString->Left(iPos);
	}
	// now replace any escaped ]]> sequence in the HTML
	pString->Replace("]]&gt;", "]]>");
}

/*********************************************************************************

	bool CXMLObject::GetContentsOfTag(const TDVCHAR *pName, CTDVString* oContents)

	Author:		Jim Lynn
	Created:	26/03/2000
	Inputs:		pName - name of tag
	Outputs:	oContents - string to be filled in
	Returns:	true if found, false otherwise
	Purpose:	Find the names tag and gets the text contents

*********************************************************************************/

bool CXMLObject::GetContentsOfTag(const TDVCHAR *pName, CTDVString* oContents)
{
	if (m_pTree != NULL)
	{
		CXMLTree* pNode = m_pTree->FindFirstTagName(pName);
		if (pNode != NULL)
		{
			return pNode->GetTextContents(*oContents);
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

void CXMLObject::EscapeTextForURL(CTDVString *pString)
{
	CTDVString sEscapedTerm;
	
	int iPos = 0;
	int iLen = pString->GetLength();
	while (iPos < iLen)
	{
		char ch = pString->GetAt(iPos);
		if (ch == ' ')
		{
			sEscapedTerm << "+";
		}
		else if (strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-~",ch) != NULL)
		{
			sEscapedTerm += ch;
		}
		else
		{
			char hextemp[20];
			sprintf(hextemp, "%%%2X", ch);
			sEscapedTerm += hextemp;
		}
		iPos++;
	}
	*pString = sEscapedTerm;
	return;
}

/*********************************************************************************

	bool CXMLObject::CacheGetItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, CTDVDateTime *pdExpires, CTDVString* oXMLText)

	Author:		Jim Lynn
	Created:	10/04/2000
	Inputs:		pCacheName - name of the cache to look it
				pItemName - name of the item to find in the cache
				pdExpires - pointer to expiry date - don't return the item if it
				is older than this date
	Outputs:	pdExpires - has new expiry date
				oXMLText - contents of the cache item
	Returns:	true if item found, false if not
	Purpose:	Looks in a given cache directory and finds the requested file if it's
				newer than a given date. It's up to the subclass to define their own
				cache directory and naming convention so that they can find the
				necessary file easily.

				For example, the forum code might ask for a file in the forummessage
				cache, with the name F12345-6789-0-19.txt meaning Forum 12345,
				thread 6789, posts 0-19 in the list.

*********************************************************************************/

bool CXMLObject::CacheGetItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, CTDVDateTime *pdExpires, CTDVString* oXMLText)
{
	if (m_InputContext.Initialised())
	{
		return m_InputContext.CacheGetItem(pCacheName, pItemName, pdExpires, oXMLText);
	}
	else
	{
		TDVASSERT(false, "m_InputContext is not initialised in CXMLObject::CacheGetItem()");
		return false;
	}
}

bool CXMLObject::CachePutItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, const TDVCHAR* pText)
{
	if (m_InputContext.Initialised())
	{
		return m_InputContext.CachePutItem(pCacheName, pItemName, pText);
	}
	else
	{
		TDVASSERT(false, "m_InputContext is not initialised in CXMLObject::CachePutItem()");
		return false;
	}
}

/*********************************************************************************

	bool CXMLObject::CreateCacheText(CTDVString* pCacheText)

	Author:		Kim Harries
	Created:	30/08/2000
	Inputs:		-
	Outputs:	pCacheText - text representing the full data for this object, enabling
					it to be cached safely without loss of information.
	Returns:	true if successful, false if not.
	Purpose:	Provides a method that guarantees producing a representation of the
				objects data suitable for storage in the cache. Must ensure that all
				necessary internal data is placed within the output variable. The
				default behaviour is to use the GetAsString method, but for some
				subclasses this may not be appropriate and these should override this
				method.

	Note:		CreateCacheText and CreateFromCacheText do not necessarily have to
				store the data in XML form, though this is by far the most obvious
				way inwhich to do it.

*********************************************************************************/

bool CXMLObject::CreateCacheText(CTDVString* pCacheText)
{
	TDVASSERT(pCacheText != NULL, "pCacheText NULL in CXMLObject::CreateCacheText(...)");

	if (pCacheText == NULL)
	{
		return false;
	}
	return GetAsString(*pCacheText);
}

/*********************************************************************************

	bool CXMLObject::CreateFromCacheText(const TDVCHAR* pCacheText)

	Author:		Kim Harries
	Created:	30/08/2000
	Inputs:		-
	Outputs:	pCacheText - text representing the full data from which to create
					this object, enabling it to be created with all necessary
					information in place.
	Returns:	true if successful, false if not.
	Purpose:	Provides a method that guarantees that all necessary initialisations
				are done on the object when retrieving it from the cache. Must make
				sure that all member variables are set appropriately and the tree, if
				any, is built. Default behaviour is to use the CreateFromXMLText
				method to generate a tree from the XML text, but for subclasses
				that use member variables this may not be appropriate.

*********************************************************************************/

bool CXMLObject::CreateFromCacheText(const TDVCHAR* pCacheText)
{
	CTDVString sError;
	bool bOkay = true;

	bOkay = CreateFromXMLText(pCacheText, &sError);
	if (sError.GetLength() > 0)
	{
		bOkay = false;
	}
	return bOkay;
}

CXMLTree* CXMLObject::_TEST_ExtractTree()
{
	CXMLTree* pRoot = new CXMLTree;
	CXMLTree* pNode = ExtractTree();
	pRoot->AddChild(pNode);
	return pRoot;
}

bool CXMLObject::FindFirstNode(const TDVCHAR *pNodeName, CXMLTree* pParent, bool bAssertOnNULLNode)
{
	m_pPrevNode = NULL;
	m_CurNodeName = pNodeName;
	m_pCurNode = m_pTree->FindFirstTagName(pNodeName, pParent, bAssertOnNULLNode);
	return (m_pCurNode != NULL);
}

bool CXMLObject::NextNode()
{
	if (m_pCurNode == NULL)
	{
		return false;
	}

	m_pPrevNode = m_pCurNode;
	m_pCurNode = m_pCurNode->FindNextTagNode(m_CurNodeName);
	return (m_pCurNode != NULL);
}

bool CXMLObject::GetTextContentsOfChild(const TDVCHAR *pTagName, CTDVString *oValue)
{
	if (m_pCurNode != NULL)
	{
		CXMLTree* pNode = m_pCurNode->FindFirstTagName(pTagName, m_pCurNode, false);
		if (pNode != NULL)
		{
			return pNode->GetTextContents(*oValue);
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

bool CXMLObject::DoesChildTagExist(const TDVCHAR *pTagName)
{
	// Must be false if there's no current node
	if (m_pCurNode == NULL)
	{
		return false;
	}

	// It's true if FindFirstTagName returns a pointer instead of NULL
	if (m_pCurNode->FindFirstTagName(pTagName, m_pCurNode, false) != NULL)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*
bool CXMLObject::GenerateHash(const TDVCHAR* pString, CTDVString& oResult)
{
	CryptoPP::MD5 md5;

	const char *hex = "0123456789abcdef";
	char *r, result[33];
	int i;
	byte digest[16];
	memset(digest,0,16);
	md5.CalculateDigest(digest, (byte*)pString, strlen(pString));
	for (i = 0, r = result; i < 16; i++) 
	{
		*r++ = hex[digest[i] >> 4];
		*r++ = hex[digest[i] & 0xF];
	}
	*r = '\0';
	oResult = result;
	return true;
}
*/

/*********************************************************************************

	bool CXMLObject::CreateDateXML(const TDVCHAR* pTagName,const CTDVDateTime& dDT,CTDVString& sXML)

	Author:		Mark Neves
	Created:	11/08/2003
	Inputs:		pTagName= Name of the surrounding tag
				dDT		= contains the date in question
	Outputs:	sXML	= receives the generated XML
	Returns:	true if OK, false otherwise
	Purpose:	Creates an XML object containing a standard <DATE> tag.
				e.g. if pTagName="LASTUPDATED", this is created:
					<LASTUPDATED>
						<DATE ...../>
					</LASTUPDATED>

				If this function returns false, the content of sXML is undefined

*********************************************************************************/

bool CXMLObject::CreateDateXML(const TDVCHAR* pTagName,const CTDVDateTime& dDT,CTDVString& sXML)
{
	bool ok = false;
	if (pTagName != NULL)
	{
		sXML << "<" << pTagName << ">";

		CTDVString sDTXML;
		if (dDT.GetAsXML(sDTXML, true))
		{
			sXML << sDTXML << "</" << pTagName << ">";
			ok =true;
		}
	}

	return ok;
}

/*********************************************************************************

	bool CXMLObject::ReplaceLineBreaksWithBreakTags(CXMLTree* pTree)

	Author:		Mark Howitt, Mark Neves
	Created:	8/28/2003
	Inputs:		pTree - A pointer to the tree that contains the returns you want to convert.
	Outputs:	-
	Returns:	true always!
	Purpose:	Replaces all returns in text nodes with <br/> tags.
				NOTE!!! Text nodes that only contain white space DO NOT get converted!

*********************************************************************************/
bool CXMLObject::ReplaceLineBreaksWithBreakTags(CXMLTree* pTree)
{
	// Scan through the tree until we find a node of type T_TEXT
	// because we only want to deal with them
	CTDVString sResult;
	CXMLTree* pNode = pTree;
	while(pNode != NULL)
	{
		//find a text node
		if (pNode->GetNodeType() == CXMLTree::T_TEXT)
		{
			//found a textnode so lets get the contents
			sResult = pNode->GetText();

			// Check to see if we only have white space!
			if (sResult.CountWhiteSpaceChars() != sResult.GetLength())
			{
				//replace the line breaks.
				sResult.Replace("\r\n","<br/>");
				pNode->SetText(sResult);
			}
		}

		// Get the next node
		pNode = pNode->FindNext();
	}

	// return ok!
	return true;
}



/*********************************************************************************

	void CXMLObject::EscapeEverything(CTDVString *pString)

	Author:		Mark Howitt
	Created:	15/10/2003
	Inputs:		pString - string to escape
	Outputs:	pString - escaped string
	Returns:	-
	Purpose:	Escapes & < and > characters in text which needs to be output
				to the XML stream. Any plain text (like article subjects, usernames,
				etc.) should be passed through this function before being sent to
				the XML stream, otherwise the stylesheet will choke on it.

	Note:		Since some XML entities are allowed in plain text entries these
				are not escaped by this method. Should you for some reason need
				to escape all XML then use the EscapeAllXML method below.

*********************************************************************************/

void CXMLObject::EscapeEverything(CTDVString *pString)
{
	pString->Replace("&","&amp;");
	pString->Replace("<","&lt;");
	pString->Replace(">","&gt;");
	pString->Replace("'","&apos;");
}


/*********************************************************************************

	bool CXMLObject::MakeGuideMLTextEditable(CXMLTree *pTree, const TDVCHAR* pNodeName, 
												CTDVString& sNodeText, CTDVString& sEditableText)

	Author:		Mark Neves
	Created:	21/10/2003 (rewrite 20/4/04)
	Inputs:		pTree - a tree object to search.
				pNodeName - A String pointer holding the Name of the Node
							you want to get the editable Text from.
	Outputs:	sNodeText - the XML output for the tag
				sEditableText - the editable version of pNodeName
	Returns:	true if successful, false if not
	Purpose:	Finds the node called pNodeName and gets the XML output for
				all it's children.
                The editable version is escaped and the <BR/> Tags are replaced with "\r\n".

*********************************************************************************/

bool CXMLObject::MakeGuideMLTextEditable(CXMLTree *pTree, const TDVCHAR* pNodeName, 
											CTDVString& sNodeText, CTDVString& sEditableText)
{
	sNodeText.Empty();
	sEditableText.Empty();

	if (pTree == NULL || pNodeName == NULL)
	{
		// If it's NULL, then return true as 
		TDVASSERT(false,"MakeGuideMLTextEditable called with NULL pointers!");
		return false;
	}

	// Make sure we check using uppercase!
	CTDVString sUpperCaseName = pNodeName;
	sUpperCaseName.MakeUpper();

	// Find the first node matching the upper case pNodeName
	CXMLTree* pNode = pTree->FindFirstTagNameNoChild(sUpperCaseName);
	if (pNode != NULL)
	{
		pNode->OutputChildrenXMLTree(sNodeText);

		sEditableText = sNodeText;
//		sEditableText.Replace("<BR />","\r\n");
		// Now Escape All the text
		EscapeAllXML(&sEditableText);

		return true;
	}

	return false;
}

/*********************************************************************************

	void CXMLObject::CreateSimpleTextLineFromXML(const CTDVString& sXML, CTDVString& sText)

	Author:		Mark Neves
	Created:	24/11/2003
	Inputs:		sXML
	Outputs:	sText
	Returns:	-
	Purpose:	It is designed to get an XML structure with a <BODY> tag
	
				It creates a simple single line of text from the text content of the <BODY>
				tag (if it finds one).  All <BR> tags are replaced with full stops.
				The resultant text is escaped.

				If the text doesn't parse, or doesn't contain a <BODY> tag or the <BODY>
				tag is empty it returns empty line.

*********************************************************************************/

void CXMLObject::CreateSimpleTextLineFromXML(const CTDVString& sXML, CTDVString& sText)
{
	sText.Empty();

	CTDVString sNewXML = sXML;

	// Change <BR>s to full stops.  I.e. remove newline characters so that it all fits on one line
	sNewXML.Replace("<BR />",".  ");

	// If the XML contains a BODY tag, take the text from there
	CXMLTree* pTree = CXMLTree::Parse(sNewXML);
	if (pTree != NULL)
	{
		CXMLTree* pNode = pTree->FindFirstTagName("BODY");
		if (pNode != NULL)
		{
			pNode->GetTextContents(sText);
		}
		delete pTree;
	}


	// We need to determine if the text comprises of some visible characters
	// If the user hasn't typed in anything useful, we don't want the tag to exist at all
	// i.e. We don't want empty tags because the XSL becomes messy when handling such cases
	
	sText.RemoveDodgyChars();
	int nNumWhiteSpaces = sText.CountWhiteSpaceChars();
	int nLen = sText.GetLength();

	// If the text only consists of whitespace, treat it as an empty string
	if (nLen <= nNumWhiteSpaces)
	{
		sText.Empty();
	}

	CXMLObject::EscapeXMLText(&sText);
}


/*********************************************************************************

	void CXMLObject::MakeTag(const TDVCHAR* pTagName, const CTDVString& sTagContent, CTDVString& sResultXML)

	Author:		Mark Neves
	Created:	25/11/2003
	Inputs:		pTagName = the name of the tag to make
				sTagContent = the content of the tag.
	Outputs:	sResultXML = the object to put the result in
	Returns:	-
	Purpose:	Helper function for creating a simple XML tag

  				NOTE: sTagContent and sResultXML must be the same object 

*********************************************************************************/

void CXMLObject::MakeTag(const TDVCHAR* pTagName, const CTDVString& sTagContent, CTDVString& sResultXML)
{
	sResultXML.Empty();
	if (sTagContent.IsEmpty())
	{
		sResultXML << "<" << pTagName << " />";
	}
	else
	{
		sResultXML << "<" << pTagName << ">" << sTagContent << "</" << pTagName << ">";
	}
}

CTDVString CXMLObject::MakeTag(const TDVCHAR* pTagName, const CTDVString& sTagContent)
{
	CTDVString sResultXML;
	MakeTag(pTagName, sTagContent,sResultXML);
	return sResultXML;
}

/*********************************************************************************

	bool CXMLObject::ReplaceReturnsWithBreaks(CTDVString &sXMLToChange)

	Author:		Mark Howitt (moved from CTDVString by Markn 27/11/03)
	Created:	19/09/03
	Inputs:		sXMLToChange - the string which contains the returns to replace
	Outputs:	sXMLToChange is modified with converted returns.
	Returns:	true if ok, false if not!
	Purpose:	This function replaces all carrage returns with <BR/> tags.
				NOTE!!! There is an exception, which is if there is already a <BR/>
						tag and it is followed immediatly by \r\n, then the \r\n is removed!!!!

*********************************************************************************/
bool CXMLObject::ReplaceReturnsWithBreaks(CTDVString &sXMLToChange)
{
	// Now create the tree from the text given to us
	CXMLTree* pTree = CXMLTree::Parse(sXMLToChange);
	if (pTree == NULL)
	{
		// We've had a problem!
		TDVASSERT(false,"CXMLObject::ReplaceReturnsWithBreaks - Invalid XML! Parse failed!");
		return false;
	}

	// Now replace the returns with breaks
	if (!CXMLObject::ReplaceLineBreaksWithBreakTags(pTree))
	{
		// We've had a problem!
		TDVASSERT(false,"CXMLObject::ReplaceReturnsWithBreaks - Replace Line breaks failed!");
		delete pTree;
		return false;
	}

	// Now get the tree back into string format
	sXMLToChange.Empty();
	pTree->OutputXMLTree(sXMLToChange);
	delete pTree;
	return true;
}

/*********************************************************************************

	void CXMLObject::FixAmpersand(CTDVString &sXMLToChange)

	Author:		Igor Loboda
	Created:	06/05/2004
	Inputs:		sXMLToChange - the string to fix
	Outputs:	sXMLToChange is modified with & fixed.
	Purpose:	replaces & with &amp; unless it's used as
				part of the following construct:
				&any-non-zero-length-string-without-whitespace;
				in which case it's considered to be a valid entity
				and is left as is.
*********************************************************************************/

void CXMLObject::FixAmpersand(CTDVString &sXMLToChange)
{
	int pos = sXMLToChange.Find("&");
	while (pos >= 0)
	{
		int semicolonPos = sXMLToChange.Find(";", pos + 1);
		if (semicolonPos < 0)
		{
			//no more semicolons - replace all ampersands within the rest of the
			//string. and exit.
			sXMLToChange.Replace("&", "&amp;", pos);
			return;
		}

		//check if there is another ampersand between the one we found and 
		//the semicolon
		int nextampPos = sXMLToChange.Find("&", pos + 1);
		if (nextampPos > pos && nextampPos < semicolonPos)
		{
			//current amersand does not have corresponding semicolon,
			//the next one might have
			sXMLToChange.Replace("&", "&amp;", pos, pos + 1);
			pos = nextampPos + 4; //strlen("amp;")
		}
		else
		{
			//there is no another ampersand or next ampersand is 
			//after the current semicolon. so the semicolon
			//matches current ampersand. now check there is no ws between the two and
			//it's of non-zero length
			bool bValidEntity = (semicolonPos - pos - 1) != 0;
			for (int i = pos + 1; bValidEntity && i < semicolonPos; i++)
			{
				if (isspace(sXMLToChange[i]))
				{
					bValidEntity = false;
					break;
				}
			}

			//if the token has ws this can't be an entity - replace
			if (!bValidEntity)
			{
				sXMLToChange.Replace("&", "&amp;", pos, pos + 1);
				pos += 5;
			}
			else
			{
				pos = nextampPos;
			}

			if (nextampPos < 0)		//no more ampersands
			{	
				pos = -1;			//stop search after current one
			}
		}
	}
}

/*********************************************************************************

	bool CXMLObject::GenerateAsGuideML(const TDVCHAR* pName, const TDVCHAR* pValue, CTDVString& sXML, CTDVString& sParseErrors)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		pName	= the name of the tag
				pValue  = the value of the tag
	Outputs:	sXML = the GuideML version of a tag called pName, who's value is pValue
				sParseErrors = contains the parse errors if the func returns false
	Returns:	true if ok, false if it had problems parsing the input
	Purpose:	Creates a GuideML bit of XML, with a tag name of pName, and a value of pValue

				If there are parsing problems, the LastError variables contain the parse errors

*********************************************************************************/

bool CXMLObject::GenerateAsGuideML(const TDVCHAR* pName, const TDVCHAR* pValue, CTDVString& sXML, CTDVString& sParseErrors)
{
	CTDVString sTag;
	CXMLObject::MakeTag(pName,pValue,sTag);
//	CXMLObject::ReplaceReturnsWithBreaks(sTag);

	sParseErrors = CXMLObject::ParseXMLForErrors(sTag);
	if (!sParseErrors.IsEmpty())
	{
		StripTopLevelTagFromParseErrors(pName,sParseErrors);
		return false;
	}

	// Need to parse and re-get the XML, to make sure the format of the XML is consistent
	// e.g. "<br/>" is turned into "<BR />", etc
	CXMLTree* pTree = CXMLTree::Parse(sTag);
	if (pTree != NULL)
	{
		sTag.Empty();
		pTree->OutputXMLTree(sXML);
		delete pTree;
	}

	return true;
}

/*********************************************************************************

	bool CXMLObject::StripTopLevelTagFromParseErrors(const TDVCHAR* pName,CTDVString& sParseErrors)

	Author:		Mark Neves
	Created:	19/01/2004
	Inputs:		pName = name of the tag to remove
				sParseErrors = a string returned from CXMLObject::ParseXMLForErrors()
	Outputs:	sParseErrors is modified
	Returns:	true
	Purpose:	The parse error string always contains the top-level tag that contains the error.
				In certain circumstances it's desirable to remove this tag from the parse error so
				that the errors make sense to the user.

				E.g. in a typed article, the code will parse text entered in a field.  This text is
				enclosed in a top-level tag, like <BODY>.  If the text contains parse errors, the
				msg contains the tag name "BODY", but the user never typed in a tag called "BODY" so this
				is a source of confusion to the user.  This function strips this top-level tag name
				from the error text, leaving a sensible msg.

*********************************************************************************/

bool CXMLObject::StripTopLevelTagFromParseErrors(const TDVCHAR* pName,CTDVString& sParseErrors)
{
	// Remove tag from start
	CTDVString sStartTag;
	sStartTag << "&lt;" << pName << "&gt;";
	int nStartTagPos = sParseErrors.FindText(sStartTag);
	if (nStartTagPos >= 0)
	{
		sParseErrors.Replace(sStartTag,"",nStartTagPos,nStartTagPos+sStartTag.GetLength());
	}

	// First check to see if there's a "&lt;/NAME&gt;" at the end.
	CTDVString sEndTag;
	sEndTag << "&lt;/" << pName << "&gt;";
	int nEndTagPos = sParseErrors.FindTextLast(sEndTag);

	if (nEndTagPos >= 0)
	{
		// if there, remove it, and job is done
		sParseErrors.Replace(sEndTag,"",nEndTagPos,nEndTagPos+sEndTag.GetLength());
	}
	else
	{
		// Otherwise we may have the case where the <XMLERROR> tag is inside the end tag
		// so look for just "/NAME&gt;"
		sEndTag.Empty();
		sEndTag << "/" << pName << "&gt;";
		nEndTagPos = sParseErrors.FindTextLast(sEndTag);
		if (nEndTagPos >= 0)
		{
			// if "/NAME&gt;" is present, then there will be a bogus "&lt; in front of 
			// an <XMLERROR> tag, remove it
			sParseErrors.Replace(sEndTag,"",nEndTagPos,nEndTagPos+sEndTag.GetLength());
			sParseErrors.Replace("&lt;<XMLERROR>","<XMLERROR>");
		}
	}
	
	return true;
}



/*********************************************************************************

	bool CXMLObject::InitialiseXMLBuilder(CTDVString* psXML, CStoredProcedure* pSP, CStoredProcedure* pOldSP)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psXML - A pointer to a strig that will recieve all the xml results.
				pSP - A pointer to a stored procedure that contains the results
					that you are trying to get as xml.
	Outputs:	
	Returns:	The pointer to the Previous Stored Procedure. Used when sub functions need to
				use a storedprocedure, and then put the old one back before returning.
	Purpose:	Sets up the XMLBuilder member with a string and stored procedure.
				The stored procedure is defaultly NULL as the builder can be used
				purely to add XML Tags without getting results from the stored procedure.
	
	See Also:	Look at CDBXMLBuilder to see more info on the called functions.
				DBXMLBuilder.h

*********************************************************************************/

CStoredProcedure* CXMLObject::InitialiseXMLBuilder(CTDVString* psXML, CStoredProcedure* pSP)
{
	return m_XMLBuilder.Initialise(psXML,pSP);
}

/*********************************************************************************
	bool CXMLObject::OpenXMLTag(const TDVCHAR *psTagName, bool bHasAttributes)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::OpenXMLTag(const TDVCHAR *psTagName, bool bHasAttributes)
{
	return m_XMLBuilder.OpenTag(psTagName,bHasAttributes);
}

/*********************************************************************************
	bool CXMLObject::CloseXMLTag(const TDVCHAR *psTagName, const TDVCHAR* psValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::CloseXMLTag(const TDVCHAR *psTagName, const TDVCHAR* psValue)
{
	return m_XMLBuilder.CloseTag(psTagName,psValue);
}

/*********************************************************************************
	bool CXMLObject::AddXMLTag(const TDVCHAR *psTagName, const TDVCHAR *psValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddXMLTag(const TDVCHAR *psTagName, const TDVCHAR *psValue)
{
	return m_XMLBuilder.AddTag(psTagName,psValue);
}

/*********************************************************************************
	bool CXMLObject::AddXMLAttribute(const TDVCHAR *psTagName, const TDVCHAR *psValue, bool bIsLastAttribute)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddXMLAttribute(const TDVCHAR *psTagName, const TDVCHAR *psValue, bool bIsLastAttribute)
{
	return m_XMLBuilder.AddAttribute(psTagName,psValue,bIsLastAttribute);
}

/*********************************************************************************
	bool CXMLObject::AddXMLIntTag(const TDVCHAR* psTagName, const int iValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddXMLIntTag(const TDVCHAR* psTagName, const int iValue)
{
	return m_XMLBuilder.AddIntTag(psTagName,iValue);
}

/*********************************************************************************
	bool CXMLObject::AddXMLIntAttribute(const TDVCHAR* psTagName, const int iValue, bool bIsLastAttribute)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddXMLIntAttribute(const TDVCHAR* psTagName, const int iValue, bool bIsLastAttribute)
{
	return m_XMLBuilder.AddIntAttribute(psTagName,iValue,bIsLastAttribute);
}

/*********************************************************************************
	bool CXMLObject::AddXMLDateTag(const TDVCHAR* psTagName, CTDVDateTime& Date, bool bIncludeRelative)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddXMLDateTag(const TDVCHAR* psTagName, CTDVDateTime& Date, bool bIncludeRelative)
{
	return m_XMLBuilder.AddDateTag(psTagName,Date,bIncludeRelative);
}

/*********************************************************************************
	bool CXMLObject::AddDBXMLTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, CTDVString* psValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddDBXMLTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, CTDVString* psValue)
{
	return m_XMLBuilder.DBAddTag(psResultName,psTagName,bFailIfNULL,bEscapeText,psValue);
}

/*********************************************************************************
	bool CXMLObject::AddDBXMLAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, bool bIsLastAttribute, CTDVString* psValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddDBXMLAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, bool bIsLastAttribute, CTDVString* psValue)
{
	return m_XMLBuilder.DBAddAttribute(psResultName,psTagName,bFailIfNULL,bEscapeText,bIsLastAttribute,psValue);
}

/*********************************************************************************
	bool CXMLObject::AddDBXMLIntTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, int* piValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddDBXMLIntTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, int* piValue)
{
	return m_XMLBuilder.DBAddIntTag(psResultName,psTagName,bFailIfNULL,piValue);
}

/*********************************************************************************
	bool CXMLObject::AddDBXMLIntAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIsLastAttribute, int* piValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddDBXMLIntAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIsLastAttribute, int* piValue)
{
	return m_XMLBuilder.DBAddIntAttribute(psResultName,psTagName,bFailIfNULL,bIsLastAttribute,piValue);
}

/*********************************************************************************
	bool CXMLObject::AddDBXMLDateTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIncludeRelative, CTDVDateTime* pDate)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddDBXMLDateTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIncludeRelative, CTDVDateTime* pDate)
{
	return m_XMLBuilder.DBAddDateTag(psResultName,psTagName,bFailIfNULL,bIncludeRelative,pDate);
}

/*********************************************************************************
	bool CXMLObject::AddDBXMLDoubleTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, int* pdValue)
	Author:		Mark Howitt
	Created:	05/02/2004
	Purpose:	Wrapper function for the DBXMLBuilder obejct
*********************************************************************************/
bool CXMLObject::AddDBXMLDoubleTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, double* pdValue)
{
	return m_XMLBuilder.DBAddDoubleTag(psResultName,psTagName,bFailIfNULL,pdValue);
}

/*********************************************************************************
	CTDVString CXMLObject::GetBuilderXML()
	Author:		Steven Francis
	Created:	19/10/2004
	Purpose:	Wrapper function for the DBXMLBuilder object
*********************************************************************************/
CTDVString CXMLObject::GetBuilderXML()
{
	return m_XMLBuilder.GetXML();
}

/*********************************************************************************

	bool CXMLObject::AddInsideWhereIntAttributeEquals(const TDVCHAR* psTagName,
														const TDVCHAR* psAttibuteName,
														int iAttributeValue,
														const TDVCHAR* psXML,
														int iAddToParent,
														bool bAssertIfErrors)

		Author:		Mark Howitt
        Created:	26/07/2005
        Inputs:		psTagName - The Name of the tag you want to check the attribute of.
					psAttributeName - The Name of the Int Attribute you want to test the value for.
					iAttributeValue - The value you want to test against the attribute value
					psXML - The XML you want to add inside
					iAddToParent - This optional parameter which allowes you to specify at what level to insert the new XML.
							values :	0 - Adds to the current node
										1 - Adds to the parent node
										2 - Adds to the parents, parent node
										3 - add so on...
					bAssertIfErrors - a flag that states whether to assert if we have a problem during this function
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds a block of XML inside a given xpath tagname where the given attribute is equal to the one passed in.
					This is used to insert XML into specific blocks decided on the values of their attributes.

					NOTE!!! - If the Attribute Value you're checking for is 0, there could be a situation where
								GetIntAttribute() will return 0 if the attribute does not exist! 

*********************************************************************************/
bool CXMLObject::AddInsideWhereIntAttributeEquals(const TDVCHAR* psTagName, const TDVCHAR* psAttibuteName, int iAttributeValue, const TDVCHAR* psXML, int iAddToParent, bool bAssertIfErrors)
{
	// Find the first Node that matches the given xpath and tag name
	CXMLTree* pNode = m_pTree->FindFirstTagName(psTagName);
	while (pNode != NULL && iAttributeValue != pNode->GetIntAttribute(psAttibuteName))
	{
		// Try to find the next one
		pNode = pNode->FindNextTagNode(psTagName);
	}

	// Did we find it?
	if (pNode != NULL)
	{
		// Now see if we're adding it to this node or to a parent?
		if (iAddToParent > 0)
		{
			int iParentLevel = iAddToParent;
			while (pNode != NULL && pNode->GetParent() != NULL && iParentLevel > 0)
			{
				// Get this nodes parent
				pNode = pNode->GetParent();
				--iParentLevel;
			}

			// See if we managed to get the required parent node. if iParentLevel > 0 then we failed
			if (pNode != NULL && iParentLevel > 0)
			{
				// Set the pointer to NULL as it's the wrong parent!
				pNode = NULL;
			}
		}

		// Make sure we found a parent node!
		if (pNode != NULL)
		{
			// Now create the tree for the new bit of XML to be added
			CXMLObject temp(m_InputContext);
			if (temp.CreateFromXMLText(psXML,NULL,true))
			{
				// Try to extract the tree
				CXMLTree* pNodeToInsert = temp.ExtractTree();
				if (pNodeToInsert != NULL)
				{
					// Insert it into the selected node
					pNode->AddChild(pNodeToInsert);
				}
				else
				{
					TDVASSERT(!bAssertIfErrors,"CXMLObject::AddInsideWhereIntAttributeEquals - Failed to extract tree from XMLObject!!!");
					return false;
				}
			}
			else
			{
				TDVASSERT(!bAssertIfErrors,"CXMLObject::AddInsideWhereIntAttributeEquals - Failed to create the tree from XML!!!");
				return false;
			}
		}
		else
		{
			TDVASSERT(!bAssertIfErrors,"CXMLObject::AddInsideWhereIntAttributeEquals - Failed to Find Tag Parent!!!");
			return false;
		}
	}
	else
	{
		TDVASSERT(!bAssertIfErrors,"CXMLObject::AddInsideWhereIntAttributeEquals - Failed to Find matching tag with attribute value!!!");
		return false;
	}

	return true;
}