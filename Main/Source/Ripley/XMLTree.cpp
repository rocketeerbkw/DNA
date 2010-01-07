// XMLTree.cpp: implementation of the CXMLTree class.
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
#include "tdvassert.h"
#include "XMLTree.h"
#include <map>
//#include "msxml.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//Do not allow indefinate nesting of nodes - FogBugz 1044 'Excessing Quoting causes stack overflow.'
#define TREE_LEVEL 50 

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CXMLAttribute::CXMLAttribute(const TDVCHAR* pName, const TDVCHAR* pValue) : CXMLTree(T_ATTRIBUTE, 0)

	Author:		Jim Lynn
	Inputs:		pName - attribute name
				pValue - string representation of the attribute's value
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructor for CXMLAttribute object. Creates a node
				which can be inserted into a tree.
				A CXMLAttribute node can only appear as the child of a
				CXMLTagNode object, and cannot have children of its own.

*********************************************************************************/

CXMLAttribute::CXMLAttribute(const TDVCHAR* pName, const TDVCHAR* pValue) : CXMLTree(T_ATTRIBUTE, 0)
{
	if (pName)
	{
		m_Name = pName;
	}
	else
	{
		m_Name = "";
	}

	if (pValue)
	{
		m_Value = pValue;
	}
	else
	{
		m_Value = "";
	}

}

/*********************************************************************************

	CXMLAttribute::~CXMLAttribute()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	virtual destructor for attribute.

*********************************************************************************/

CXMLAttribute::~CXMLAttribute()
{
}



/*********************************************************************************

  CXMLTree::CXMLTree(e_nodetype NodeType, long TagPos)

	Author:		Jim Lynn
	Inputs:		NodeType - enum telling us what type of node this is
				TagPos - character position in source text from where this object
				was created.
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructor for the CXMLTree base class. Initialises an object
				with no parent, siblings or children. TagPos is passed by the
				parser to tell us from where in the source document the node 
				was created (for debugging and error reporting purposes).

*********************************************************************************/

CXMLTree::CXMLTree(e_nodetype NodeType, long TagPos) :	m_PrevSibling(NULL),
													m_NextSibling(NULL),
													m_FirstChild(NULL),
													m_Parent(NULL),
													m_LastChild(NULL),
													m_NodeType(NodeType),
													m_Pos(TagPos)
{
	// I think that list says it all, really
}

/*********************************************************************************

	CXMLTagNode::CXMLTagNode(const TDVCHAR* pName, const TDVCHAR* pParams, long TagPos) 

	Author:		Jim Lynn
	Inputs:		pName - name of node element
				pParams - string containing any other parameters of the tag
				TagPos - position in source of the node.
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructor for CXMLTagNode object (equivalent to DOMElement - 
				the fundamental XML element object.

*********************************************************************************/

CXMLTagNode::CXMLTagNode(const TDVCHAR* pName, const TDVCHAR* pParams, long TagPos) 
	:	CXMLTree(T_NODE, TagPos), 
		m_Name(pName),
		m_RawParams(pParams)
{
	// Don't Parse attributes as part of the constructor...
	//ParseAttributes(m_RawParams);		// Scan the attributes list if it's there
}

/*********************************************************************************

	CXMLTextNode::CXMLTextNode(const TDVCHAR* pText, long TagPos) : CXMLTree(T_TEXT, TagPos), m_Text(pText)

	Author:		Jim Lynn
	Inputs:		pText - text to store in the node
				TagPos - position of text in source document
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructor for a text node. Just contains literal text.

*********************************************************************************/

CXMLTextNode::CXMLTextNode(const TDVCHAR* pText, long TagPos) : CXMLTree(T_TEXT, TagPos), m_Text(pText)
{
}

/*********************************************************************************

	CXMLErrorNode::CXMLErrorNode(const TDVCHAR* pText, long tpos) : CXMLTree(T_ERROR, tpos), m_Text(pText)

	Author:		Jim Lynn
	Inputs:		pText - error message
				tpos - position in the source where the error occurred
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructor for the Error node. Used when parsing a document
				to indicate where in the document the error occurred.

*********************************************************************************/

CXMLErrorNode::CXMLErrorNode(const TDVCHAR* pText, long tpos) : CXMLTree(T_ERROR, tpos), m_Text(pText)
{
}

/*********************************************************************************

	CXMLCDATANode::CXMLCDATANode(const TDVCHAR* pText, long TagPos) : CXMLTree(T_CDATA, TagPos), m_CDATA(pText)

	Author:		Jim Lynn
	Inputs:		pText - text within the CDATA node
				TagPos - position of object in source text
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructs a CDATA node.

*********************************************************************************/

CXMLCDATANode::CXMLCDATANode(const TDVCHAR* pText, long TagPos) : CXMLTree(T_CDATA, TagPos), m_CDATA(pText)
{
}

/*********************************************************************************

	CXMLCommentNode::CXMLCommentNode(const TDVCHAR* pText, long TagPos) : CXMLTree(T_COMMENT, TagPos), m_CDATA(pText)

	Author:		Jim Lynn
	Inputs:		pText - contents of the comment node
				TagPos - position of node in source text
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructs a Commane node.

*********************************************************************************/

CXMLCommentNode::CXMLCommentNode(const TDVCHAR* pText, long TagPos) : CXMLTree(T_COMMENT, TagPos), m_CDATA(pText)
{
}

/*********************************************************************************

	bool CXMLTagNode::ParseAttributes(bool bShowErrors, long StartPos, long* pErrNum)

	Author:		Jim Lynn
	Inputs:		bShowErrors - TRUE if errors are to be inserted into the tree
				StartPos - position of start of attribute string in input
	Outputs:	-
	Returns:	-
	Purpose:	Parses the attributes of an element, inserting them into the
				tree as children of this element.

*********************************************************************************/

bool CXMLTagNode::ParseAttributes(bool bShowErrors, long StartPos, long* pErrNum)
{
	// Parse the attribute list here
/*
			my $rest = $params . " ";				// add space so regex works
			while ($rest =~ m[
								\s*?				// possible whitespace
								(\w+)				// (tag) any word chars
								\s*					// possible whitepace
								=					// the equals
								\s*					// possible whitespace
								("(?:""|.)*?")		// match a quoted string
								|					// or
								([^\s]*)			// non-quoted string (no spaces)
								\s+					// followed by more whitespace
							]gxs)
			{
				my ($key, $value) = ($1,$2);
				$value = substr($value,1);
				chop($value);
				$value =~ s/""/"/g;
				$newtagelement->{$key} = $value;
				//print ("got param: $key = $value\n");
			}
*/

/*
	Well, that's the Perl method. If only life were that simple.
	An attribute list is as follows:
	ATTRNAME [= ('|") value ('|") ]
*/
	if (m_RawParams.GetLength() == 0)
	{
		return true;
	}

	std::map<CTDVString,int> mAttrNames;

	CTDVString tempparam = m_RawParams;
	long strpos = 0;
	while (strpos >= 0)
	{
		// Skip whitespace
		strpos = tempparam.FindContaining(" \r\n\t", strpos);
		
		// return if nothing but whitespace - we've finished
		if (strpos < 0)
		{
			return true;
		}

		// strpos is the index to the first non-whitespace character
		// so find the whole name
		long endofname = tempparam.FindContaining("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-:",strpos);
		
		// see if the name starts with an illegal character
		if (endofname == strpos)
		{
			// abandon the attribute parsing - store an error node here
			if (bShowErrors)
			{	CXMLErrorNode* pError = new CXMLErrorNode("Attribute starts with illegal character", strpos + StartPos);
				this->AddChild(pError);
				*pErrNum = *pErrNum + 1;
			}
			return false;
		}
		
		// Get the name of the attribute
		CTDVString attrname;
		if (endofname >= 0)
		{
			attrname = tempparam.Mid(strpos,endofname - strpos);
		}
		else
		{
			attrname = tempparam.Mid(strpos);
		}
		
		long skipwhitespace = endofname;
		if (endofname >= 0)
		{
			skipwhitespace = tempparam.FindContaining(" \r\n\t",endofname);
		}

		// Now strpos points at first char of name, endofname points directly after
		// and skipwhitespace points after any whitespace
		// Strictly according to the XML spec we now expect an equals sign
		// but some of our tags can have 'blank' attributes, so cope with that here

		if (skipwhitespace < 0 || tempparam.GetAt(skipwhitespace) != '=')
		{
			// It's a 'blank' attribute so create it
			attrname.MakeUpper();

			if (mAttrNames.find(attrname) != mAttrNames.end())
			{
				// We have a duplicate attribute name, which will cause MSXML to barf, so error
				if (bShowErrors)
				{	CXMLErrorNode* pError = new CXMLErrorNode(CTDVString("Duplicate attribute name: ")+attrname, strpos + StartPos);
					this->AddChild(pError);
					*pErrNum = *pErrNum + 1;
				}
				return false;
			}

			// Add it to the set of attrs for this node
			mAttrNames[attrname] = 1;

			CXMLAttribute* pAttr = new CXMLAttribute(attrname, "1");
			AddChild(pAttr);
			strpos = skipwhitespace;
			continue;
		}

		// so we've got an equals sign. Skip it and any whitespace
		skipwhitespace++;
		skipwhitespace = tempparam.FindContaining(" \r\n\t",skipwhitespace);
		if (skipwhitespace < 0)
		{
			// error: missing parameter after equals sign
			if (bShowErrors)
			{
				CXMLErrorNode* pError = new CXMLErrorNode("Missing attribute value after =", StartPos);
				this->AddChild(pError);
				*pErrNum = *pErrNum + 1;
			}
			return false;
		}

		// Now we either have double-quoted or single quoted string
		// Easiest thing is to see what the first quote is, and then find 
		// everything within it

		TDVCHAR quotechar = tempparam.GetAt(skipwhitespace);
		if (quotechar != '\'' && quotechar != '"')
		{
			// error: value not quoted
			if (bShowErrors)
			{
				CXMLErrorNode* pError = new CXMLErrorNode("Attribute value must be quoted", StartPos);
				this->AddChild(pError);
				*pErrNum = *pErrNum + 1;
			}
			return false;
		}

		// Now we've got the quote character, so let's scan for the end
		skipwhitespace++;
		long valuestart = skipwhitespace;
		while (skipwhitespace < tempparam.GetLength() && tempparam.GetAt(skipwhitespace) != quotechar)
		{
			skipwhitespace++;
		}

		// Now skipwhitespace is the index of the closing quote or the end
		// of the string
		if (skipwhitespace == tempparam.GetLength())
		{
			if (bShowErrors)
			{
				CXMLErrorNode* pError = new CXMLErrorNode("Attribute value is missing closing quote", StartPos);
				this->AddChild(pError);
				*pErrNum = *pErrNum + 1;
			}
			return false;
		}

		// Is it safe to assume that we're pointing at the closing quote?
		// I think so, because we've handled the other case just above
		// Get the actual value of the attribute and store it

		CTDVString actualvalue = tempparam.Mid(valuestart, skipwhitespace - valuestart);
		
		attrname.MakeUpper();
		if (actualvalue.Find('<') >= 0)
		{
			if (bShowErrors)
			{
				CXMLErrorNode* pError = new CXMLErrorNode("Attributes cannot contain the '<' character. Perhaps you omitted closing quotes? -->", StartPos);
				this->AddChild(pError);
				*pErrNum = *pErrNum + 1;
			}
			return false;
		}

		if (mAttrNames.find(attrname) != mAttrNames.end())
		{
			// We have a duplicate attribute name, which will cause MSXML to barf, so error
			if (bShowErrors)
			{	CXMLErrorNode* pError = new CXMLErrorNode(CTDVString("Duplicate attribute name: ")+attrname, strpos + StartPos);
				this->AddChild(pError);
				*pErrNum = *pErrNum + 1;
			}
			return false;
		}

		// Add it to the set of attrs for this node
		mAttrNames[attrname] = 1;

		// this will alter the actualvalue string
		FlagAmpersandErrors(actualvalue, bShowErrors, pErrNum, this, StartPos, &actualvalue);
		CXMLAttribute *pAttr = new CXMLAttribute(attrname, actualvalue);
		AddChild(pAttr);
		// skip the closing quote
		skipwhitespace++;
		
		// Now set up to do it all again
		strpos = skipwhitespace;

		if (strpos >= tempparam.GetLength())
		{
			strpos = -1;
		}
		
	} // endwhile
	
	return true;	// no errors
}

/*********************************************************************************

	CXMLTree::~CXMLTree()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Destructor for an XMLTree object. The destructor will delete
				all children (whose destructors will naturally kick in) and
				all right siblings. Because of the order in which the destruvtors
				are called, this guarantees to delete the entire subtree.
				Be very careful when deleting a root node that it doesn't have
				either a parent or a right sibling. Trouble is, we can't check this
				because the recursive nature of the destruction means that any
				children will still have pointers to their parents...

				Just be careful.

*********************************************************************************/

CXMLTree::~CXMLTree()
{
	// Detach this node from the tree
	DetachNodeTree();
	
	// Now delete all of its children
	while (m_FirstChild)
	{
		delete (m_FirstChild);
	}

	// Now the siblings
//	if (m_NextSibling)
//	{
//		delete (m_NextSibling);
//	}

	// Deleting the next sibling will call its destructor which will delete its next sibling
	// and so on until the heat-death of the universe or it runs out of siblings,
	// whichever is sooner.

}

/*********************************************************************************

	CXMLTagNode::~CXMLTagNode()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	virtual dtor for subclass. No extra functionality needed.

*********************************************************************************/

CXMLTagNode::~CXMLTagNode()
{
}

/*********************************************************************************

	CXMLCDATANode::~CXMLCDATANode()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	virtual dtor for subclass. No extra functionality needed.

*********************************************************************************/

CXMLCDATANode::~CXMLCDATANode()
{
}

/*********************************************************************************

	CXMLCommentNode::~CXMLCommentNode()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	virtual dtor for subclass. No extra functionality needed.

*********************************************************************************/

CXMLCommentNode::~CXMLCommentNode()
{
}

/*********************************************************************************

	CXMLErrorNode::~CXMLErrorNode()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	virtual dtor for subclass. No extra functionality needed.

*********************************************************************************/

CXMLErrorNode::~CXMLErrorNode()
{
}

/*********************************************************************************

	CXMLTextNode::~CXMLTextNode()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	virtual dtor for subclass. No extra functionality needed.

*********************************************************************************/

CXMLTextNode::~CXMLTextNode()
{
	// Don't do anything
}

/*********************************************************************************

	void CXMLTree::AddChild(CXMLTree* pNewChild)

	Author:		Jim Lynn
	Inputs:		pNewChild
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Insert the given node as a new child of this node.

*********************************************************************************/

void CXMLTree::AddChild(CXMLTree* pNewChild)
{
	//assert(pNewChild->m_Parent == NULL && pNewChild->m_NextSibling == NULL && pNewChild->m_PrevSibling == NULL);
	
//	CXMLTree* pElement = m_FirstChild;			// point at first child of this node
	CXMLTree* pElement = m_LastChild;			// point at first child of this node
	if (pElement)								// if there's already a child
	{
		// There's already a firstchild - add as last sibling of the child list
//		while (pElement->m_NextSibling)			// while there's siblings
//		{
//			pElement = pElement->m_NextSibling;	// get the next sibling
//		}

		// no more siblings - pElement points at last sibling

		pElement->m_NextSibling = pNewChild;	// add new child as last sibling
		pNewChild->m_PrevSibling = pElement;	// set prevsibling ptr of child
		pNewChild->m_NextSibling = NULL;		// no next sibling
		m_LastChild = pNewChild;
	}
	else	// no children yet
	{
		// No first child, just add it
		m_FirstChild = pNewChild;		// Store as the first child
		m_LastChild = pNewChild;		// And as last child
		pNewChild->m_PrevSibling = NULL;			// no prevsibling
		pNewChild->m_NextSibling = NULL;			// or nextsibling
	}
	// make sure the parent pointer is correct
	pNewChild->m_Parent = this;

#ifdef _DEBUG
	//debugchecktree();
#endif
}

//# addSibling ([self],newsibling)
//#
//# Add the node to this node as a sibling

/*********************************************************************************

	void CXMLTree::AddSibling(CXMLTree* pNewSibling)

	Author:		Jim Lynn
	Inputs:		pNewSibling
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Inserts the new node as the last sibling to the current node.

*********************************************************************************/

void CXMLTree::AddSibling(CXMLTree* pNewSibling)
{
	CXMLTree* pElement = this;						// pElement points to this node
	if (m_Parent)
	{
		pElement = m_Parent->m_LastChild;
	}
	
	while (pElement->m_NextSibling)			// while there are more siblings
	{
		pElement = pElement->m_NextSibling;	// point pElement to the next sibling
	}
	
	// no more siblings - pElement is the last
	
	pElement->m_NextSibling = pNewSibling;	// set the new sibling to be nextsibling og last
	pNewSibling->m_PrevSibling = pElement;	// set its prevsibling node accordingly
	pNewSibling->m_NextSibling = NULL;			// no next sibling
	pNewSibling->m_Parent = pElement->m_Parent;	// they share parents
}

//# findNext([self])
//#
//# find the next node using depth-first methods

/*********************************************************************************
CXMLTree* CXMLTree::FindNext(CXMLTree* pParent)

	Author:		Jim Lynn
	Inputs:		pParent (=NULL) - parent node to halt at
	Outputs:	-
	Returns:	pointer to next node or NULL
	Purpose:	Traverses the tree in depth-first right-sibling order. If pParent
				is not NULL this function will stop returning nodes when it 
				finishes with the ancestors of pParent, i.e. it won't traverse to
				any node above or at the same level as pParent.

**********************************************************************************/

CXMLTree* CXMLTree::FindNext(CXMLTree* pParent)
{
	if (m_FirstChild)	// if there's a child
	{
		return m_FirstChild;	// it's the next one
	}
	if (m_NextSibling)	// if there's a sibling
	{
		return (m_NextSibling);	// return that as next
	}
	if (m_Parent)		// if there's a parent
	{
		return m_Parent->FindNextNoChild(pParent);	// traverse up the tree
	}
	return NULL;	// otherwise no result
}

/*********************************************************************************

	CXMLTree* CXMLTree::FindNextNoChild(CXMLTree* pParent)

	Author:		Jim Lynn
	Inputs:		pParent - Node to halt at if not NULL
	Outputs:	-
	Returns:	ptr to next node in traversal order without looking at the
				child of the current node.
	Scope:		protected
	Purpose:	Helper function for FindNext, not useful from outside.

*********************************************************************************/

CXMLTree* CXMLTree::FindNextNoChild(CXMLTree* pParent)
{
	if (this == pParent)
	{
		return NULL;
	}

	if (m_NextSibling)
	{
		return (m_NextSibling);
	}
	if (m_Parent)
	{
		return m_Parent->FindNextNoChild(pParent);
	}
	return NULL;
}

/*********************************************************************************

	CXMLTree* CXMLTree::ParseForInsert(const TDVCHAR* pText)

	Author:		Nick Stevenson
	Created:	30/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/
CXMLTree* CXMLTree::ParseForInsert(const TDVCHAR* pText)
{
	CXMLTree* pRoot = Parse(pText);
	if (pRoot != NULL)
	{
		CXMLTree* pTree = pRoot->GetFirstChild(T_NODE);
		if (pTree != NULL)
		{
			pTree->DetachNodeTree();
			delete pRoot;
			return pTree;
		}
	}

	return pRoot;
}

/*********************************************************************************

	CXMLTree* CXMLTree::Parse(const TDVCHAR* pText, bool bShowErrors, long* pNumErrors)

	Author:		Jim Lynn
	Inputs:		pText - text to parse
				bShowErrors - true if errors should be inserted into the tree
	Outputs:	pNumErrors - number of errors inserted (if bShowErrors == true)
	Returns:	ptr to root node of parsed XML tree
	Scope:		public
	Purpose:	Static function to parse a given piece of text and return a parsed
				document tree (with error nodes if required - turn them off when
				error reporting isn't useful or required).
				The returned tree is yours. To get rid of it, simply delete the 
				pointer returned to you, and the whole tree will be deleted.
				It is the caller's responsibility to delete this tree.

				Note: Our parser is less strict than a regular XML parser, and will
				cope with some common errors (like unclosed tags) while still
				returning a tree.

*********************************************************************************/

CXMLTree* CXMLTree::Parse(const TDVCHAR* pText, bool bShowErrors, long* pNumErrors)
{
// parsing rules:
// find an element
// if it's an opening element. make a new node
// if it's empty, don't go down the tree
// if it's text, add a text node
// if it's a close, go up until either you find a matching parent or the root
// if you find a matching parent,stay there, if not, ignore the closing tag
	long StartPos = 0;
	long NumErrors = 0;
	long TagStartPos = 0;
	CXMLTree* pDocRoot = new CXMLTree;
	CXMLTree* pCurTree = pDocRoot;
	CTDVParseString Text(pText);			// editable string to hold parsed text

/*	OutputDebugString("Parsing: ");
	OutputDebugString(Text.Left(100));
	
	DWORD begin = GetTickCount();
	
*/
	// search for a tag:
	// starts with < followed by an optional / (returned in match variable $1)
	// followed by alphanumerics (for the tag name, returned in $2)
	// followed by any other characters (returned in $3) and a final >
	
	int treelevel = 0;
	CXMLErrorNode* pTreeLevelError = NULL;
	while (Text.GetLength() > 0)
	{
		// two choices (at least) - tag or not
		if (Text.GetAt(0) == '<')
		{
			// Mark the start of the tag
			TagStartPos = StartPos;
			
			// Check for CDATA
			if (Text.Left(9) == "<![CDATA[")
			{
				long EndCdata = Text.Find("]]>");
				if (EndCdata < 0)
				{
					// error - no closing CDATA tag
					// eventually insert an error tag
					// for now just skip opening CDATA tag
					
					if (bShowErrors)
					{
						CXMLErrorNode* pError = new CXMLErrorNode("CDATA tag doesn't have a matching ]]> terminator", StartPos);
						pCurTree->AddChild(pError);
						NumErrors++;
					}
					
					//Text = Text.Mid(9);
					Text.RemoveLeftChars(9);
					StartPos += 9;
					continue;		// continue the while statement
				}
				else
				{
					// Put the text inside the CDATA tag in a node
					CXMLCDATANode* pCDATA = new CXMLCDATANode(Text.Mid(9,EndCdata - 9));
					pCurTree->AddChild(pCDATA);
					//Text = Text.Mid(EndCdata + 3);
					Text.RemoveLeftChars(EndCdata + 3);
					StartPos += EndCdata + 3;
					continue;
				}
			}
			// Check for <!--
			if (Text.Left(4) == "<!--")
			{
				long EndCdata = Text.Find("-->");
				if (EndCdata < 0)
				{
					// error - no closing CDATA tag
					// eventually insert an error tag
					// for now just skip opening CDATA tag
					
					if (bShowErrors)
					{
						CXMLErrorNode* pError = new CXMLErrorNode("<!-- tag doesn't have a matching --> terminator", StartPos);
						pCurTree->AddChild(pError);
						NumErrors++;
					}
					
					//Text = Text.Mid(4);
					Text.RemoveLeftChars(4);
					StartPos += 4;
					continue;		// continue the while statement
				}
				else
				{
					// Put the text inside the CDATA tag in a node
					CXMLCommentNode* pCDATA = new CXMLCommentNode(Text.Mid(4,EndCdata - 4));
					pCurTree->AddChild(pCDATA);
					//Text = Text.Mid(EndCdata + 3);
					Text.RemoveLeftChars(EndCdata + 3);
					StartPos += EndCdata + 3;
					continue;
				}
			}
			// It's a tag
			//print ("got tag: [$p] ID = ($slash1)$tag($slash2), rest = $params\n");
			
			long TagStart = 1;
			bool bClosingTag = false;
			bool bEmptyTag = false;
			long EmptyTagPos = 0;

			// Check for a closing slash
			if (Text.GetAt(TagStart) == '/')
			{
				TagStart++;					// skip over the closing slash
				bClosingTag = true;
			}
			
			long TagEnd = Text.FindContaining("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-:",TagStart);
			// What if there's no end of the tag?
			if (TagEnd < 0)
			{
				// I guess we have to do some error handling
				// Think about putting an Error tag in here...
				if (bShowErrors)
				{
					CXMLErrorNode* pError = new CXMLErrorNode("Tag is missing close bracket - perhaps you have mismatched quote marks.", StartPos);
					pCurTree->AddChild(pError);
					NumErrors++;
				}
				CXMLTextNode* pText = new CXMLTextNode(Text);
				pCurTree->AddChild(pText);
				break;
			}
			// Get the tag name out of the tag
			CTDVString TagName = "";
			TagName.AppendMid(Text, TagStart,TagEnd-TagStart);

			TagName.MakeUpper();
			
			// Point ParamStart at the first non-whitespace character
			long ParamStart = Text.FindContaining(" \t\n\r",TagEnd);

			// Now scan through the parameters, taking quotes into account

			long tptr;
			long tlength = Text.GetLength();
			
			// If we mark what kind of quotes we're in, it makes scanning easier
			// so when we hit a quote, store its char in quotechar and scan until
			// we hit the closing quote. Not that there is no way of escaping
			// quote characters at this stage

			TDVCHAR quotechar = 0;
			for (tptr = ParamStart;tptr < tlength;tptr++)		// we scan the whole string
																// but break out when we find
																// the terminator
			{
				TDVCHAR ThisChar = Text.GetAt(tptr);			// Get the current character
				if (quotechar != 0)								// Are we inside quotes?
				{
					if (quotechar == ThisChar)					// might be close quote
					{
						quotechar = 0;							// close out the quote
					}
					// otherwise just scan to the next character
					continue;
				}
				else
				{
					if (ThisChar == '\'' || ThisChar == '"')	// It's a quote
					{
						quotechar = ThisChar;					// Set so we can look for closing quotes
					}
					else
					{
						// We're not in a quoted string so anything else is significant

						if (ThisChar == '/')					// It's an empty tag?
						{
							bEmptyTag = true;					// Flag it
							EmptyTagPos = tptr;					// Remember slash position
						}
						else
						{
							if (ThisChar == '>')				// Closing bracket
							{
								break;							// terminate the loop
							}
						}
					}
				}
			}

			// Now either tptr points at the closing > or past the end of the string
			if (tptr >= tlength || tptr < 0)
			{
				// Error case - do something about it later
				if (bShowErrors)
				{
					CXMLErrorNode* pError = new CXMLErrorNode("Missing closing bracket in tag - perhaps you've missed a closing quote", StartPos);
					pCurTree->AddChild(pError);
					NumErrors++;
				}
				CXMLTextNode* pText = new CXMLTextNode(Text);
				pCurTree->AddChild(pText);
				break;
			}

			// Get the raw string that makes up the tag params
			CTDVString RawParams;
			// If there's an empty tag slash, get params up to there
			if (bEmptyTag)
			{
				RawParams.AppendMid(Text, ParamStart, EmptyTagPos - ParamStart);
			}
			else	// otherwise get the params up to the closing >
			{
				RawParams.AppendMid(Text, ParamStart, tptr - ParamStart);
			}

			// See if the name makes no sense - might be a random <>
			if (TagName.GetLength() == 0)
			{
				// Just pass it through as escaped text
				CTDVString WholeTag;
				WholeTag.AppendMid(Text, 0, tptr + 1);
				WholeTag.Replace("<", "&lt;");
				WholeTag.Replace(">", "&gt;");
				CXMLTree* pNewTextNode = new CXMLTextNode(WholeTag);
				if (pCurTree)
				{
					pCurTree->AddChild(pNewTextNode);
				}
				// cut off the tag from the text we're scanning
				//Text = Text.Mid(tptr + 1);
				Text.RemoveLeftChars(tptr + 1);
				StartPos += tptr + 1;
				continue;	// loop again
			}
			
			// cut off the tag from the text we're scanning
			//Text = Text.Mid(tptr + 1);
			Text.RemoveLeftChars(tptr + 1);
			StartPos += tptr + 1;

			// if bClosingTag is true, this is a closing tag - make sure it matches
			if (bClosingTag)
			{
				// bounce up the tree to find the tag this one closes
				if (!pCurTree || !pCurTree->CompareNodeName(TagName))
				{
					//print "Bad closing element $tag found at $p\n";
					// **** insert error node here
					if (bShowErrors)
					{
						CTDVString errmess = "";
						errmess << "Bad closing element " << TagName << " expecting " << pCurTree->GetName();
						CXMLErrorNode* pError = new CXMLErrorNode(errmess, StartPos);
						NumErrors++;
						pCurTree->AddChild(pError);
					}

					int uplevels = 0;
					CXMLTree* pUpTree = pCurTree;
					while (pUpTree = pUpTree->m_Parent)
					{
						++uplevels;
						if (pUpTree->CompareNodeName(TagName))
						{
							break;
						}
					}
					if (!pUpTree)
					{
						// who knows what the heck that tag was!
						//print "Extra closing tag $tag found at $p\n";
						// Insert error tag at current tree position
					}
					else
					{
						pUpTree = pUpTree->m_Parent;
						if (!pUpTree)
						{
							// Recursed all the way up...
							//print "recursed all the way up...\n";
						}
						else
						{
							pCurTree = pUpTree;
							treelevel -= ++uplevels;
						}
					}
				}
				else
				{
					pCurTree = pCurTree->m_Parent;
					if (!pCurTree)
					{
						// no parent! return.
						//print "Bad closing element $tag found at $p\n";
						//return (0,"Bad closing element $tag found at $p");
						// I don't think this situation ever arises as long as we use
						// a root node.
					}
					else
						--treelevel;;
				}
//				if ($curtree->{name} ne $tag)
//				{
//					return (0,"Bad closing element $tag found at $p");
//				}
//				// just close this tag
//				$curtree = $curtree->{parent};
//				if (!$curtree)	// ouch - too many closing tags
//				{
//					return (0, "Extra closing tag $tag found at $p");
//				}
			}
			else if (bEmptyTag)
			{
				CXMLTagNode* pNodeTag = new CXMLTagNode(TagName, RawParams);		// Create a new node
				if (pNodeTag)
				{
					pNodeTag->ParseAttributes(bShowErrors, TagStartPos, &NumErrors);
				}
				// This is an empty tag - simply add it as a child
				pCurTree->AddChild(pNodeTag);
			}
			else
			{
				if ( treelevel < TREE_LEVEL )
				{
					CXMLTagNode* pNodeTag = new CXMLTagNode(TagName, RawParams);		// Create a new node
					if (pNodeTag)
					{
						pNodeTag->ParseAttributes(bShowErrors, TagStartPos, &NumErrors);
					}

					// It's an opening tag - add it as a child and make it the current tree pos
					if (TagName == "BR" || TagName == "HR" || TagName == "INPUT")
					{
						if (bShowErrors && !bEmptyTag)
						{
							CTDVString errmess = TagName + " tag must be empty (warning)";
							CXMLErrorNode* pError = new CXMLErrorNode(errmess, StartPos);
							pCurTree->AddChild(pError);
							NumErrors++;
						}
						pCurTree->AddChild(pNodeTag);
					}
					else
					{
						pCurTree->AddChild(pNodeTag);
						pCurTree = pNodeTag;
						++treelevel;
					}
				}
				else if ( !pTreeLevelError )
				{
					//Report Once - Too many levels / nested elements.
					if ( pCurTree )
					{
						pTreeLevelError = new CXMLErrorNode("Nested Tag Limit Reached - Further children ignored.", StartPos);
						NumErrors++;
						pCurTree->AddChild(pTreeLevelError);
					}
					TDVASSERT(false,"Nested Tag Limit Reached - Further children ignored");
				}
			}
		}
		else 
		{
			// It's plaintext
			long pos = Text.Find("<");		// Find the next <
			if (pos < 0)					// wasn't there one?
			{
				pos = Text.GetLength();		// so point to the end of the string
			}
			CTDVString tText;
			tText.AppendMid(Text, 0, pos);
			FlagAmpersandErrors(tText, bShowErrors, &NumErrors, pCurTree, StartPos, &tText);
			tText.Replace(">", "&gt;");
			tText.Replace(" & ", " &amp; ");
			CXMLTree* pPlainText = new CXMLTextNode(tText);	// Create a text node

			// Now add the node to the tree
			if (pCurTree)						// If we already have a tree
			{
				pCurTree->AddChild(pPlainText);
			}
			else
			{
				// There's no tree - throw away text nodes
			}

			// Remove that chunk of text
			//Text = Text.Mid(pos);
			Text.RemoveLeftChars(pos);
			StartPos += pos;
		}
	}

	if (pNumErrors)
	{
		*pNumErrors = NumErrors;
	}
#ifdef _DEBUG
	//pDocRoot->debugchecktree();
#endif
/*
	CTDVString mess = "Parse took: ";
	mess << (GetTickCount() - begin) << " milliseconds\r\n";
	OutputDebugString(mess);
	printf ("%S",mess);
*/
	return (pDocRoot);
}

/*********************************************************************************

	CTDVString CXMLTree::GetName()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	String containing name of node.
	Scope:		public
	Purpose:	virtual function to return node name. CXML tree returns "NULL"

*********************************************************************************/

CTDVString CXMLTree::GetName()
{
	return CTDVString("NULL");
}

/*********************************************************************************

	bool CXMLTextNode::SetText(const TDVCHAR* pText)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pText - new text for this node
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Scope:		public
	Purpose:	virtual function to set the text for this node.

*********************************************************************************/

bool CXMLTextNode::SetText(const TDVCHAR* pText)
{
	m_Text = pText;
	return true;
}

/*********************************************************************************

	bool CXMLCDATANode::SetText(const TDVCHAR* pText)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pText - new text for this node
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Scope:		public
	Purpose:	virtual function to set the text for this node.

*********************************************************************************/

bool CXMLCDATANode::SetText(const TDVCHAR* pText)
{
	m_CDATA = pText;
	return true;
}

/*********************************************************************************

	bool CXMLErrorNode::SetText(const TDVCHAR* pText)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pText - new text for this node
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Scope:		public
	Purpose:	virtual function to set the text for this node.

*********************************************************************************/

bool CXMLErrorNode::SetText(const TDVCHAR* pText)
{
	m_Text = pText;
	return true;
}

/*********************************************************************************

	bool CXMLCommentNode::SetText(const TDVCHAR* pText)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pText - new text for this node
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Scope:		public
	Purpose:	virtual function to set the text for this node.

*********************************************************************************/

bool CXMLCommentNode::SetText(const TDVCHAR* pText)
{
	m_CDATA = pText;
	return true;
}

/*********************************************************************************

	CTDVString CXMLTextNode::GetName()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	node name
	Scope:		public
	Purpose:	CXMLTextNode always returns TEXTNODE as the name of the node

*********************************************************************************/

CTDVString CXMLTextNode::GetName()
{
	return CTDVString("TEXTNODE");
}

/*********************************************************************************

	CTDVString CXMLTagNode::GetName()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	String containing the name of the node
	Scope:		public
	Purpose:	Whatever the tag name is is returned.

*********************************************************************************/

CTDVString CXMLTagNode::GetName()
{
	return m_Name;
}

/*********************************************************************************

	CTDVString CXMLErrorNode::GetName()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	node name
	Scope:		public
	Purpose:	Error nodes always return ERRORNODE as their name

*********************************************************************************/

CTDVString CXMLErrorNode::GetName()
{
	return CTDVString("ERRORNODE");
}

/*********************************************************************************

	void CXMLTree::DebugDump(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append to
	Outputs:	sOutput - appended with debug information
	Returns:	-
	Scope:		public
	Purpose:	dumps out debugging information on this node.

*********************************************************************************/

//void CXMLTree::DebugDump(CTDVString &sOutput)
//{
//	sOutput += "[Root node]<BR>";
//
//}

/*********************************************************************************

	void CXMLTextNode::DebugDump(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append to
	Outputs:	sOutput - appended with debug information
	Returns:	-
	Scope:		public
	Purpose:	dumps out debugging information on this node.

*********************************************************************************/

//void CXMLTextNode::DebugDump(CTDVString &sOutput)
//{
//	sOutput += "[Text Node<BR>";
//	sOutput += m_Text;
//	sOutput += "<BR>]<BR>\n";
//}

/*********************************************************************************

	void CXMLCDATANode::DebugDump(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append to
	Outputs:	sOutput - appended with debug information
	Returns:	-
	Scope:		public
	Purpose:	dumps out debugging information on this node.

*********************************************************************************/

//void CXMLCDATANode::DebugDump(CTDVString &sOutput)
//{
//	sOutput += "[CDATA Node<BR>";
//	sOutput += m_CDATA;
//	sOutput += "<BR>]<BR>\n";
//}

/*********************************************************************************

	void CXMLCommentNode::DebugDump(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append to
	Outputs:	sOutput - appended with debug information
	Returns:	-
	Scope:		public
	Purpose:	dumps out debugging information on this node.

*********************************************************************************/

//void CXMLCommentNode::DebugDump(CTDVString &sOutput)
//{
//	sOutput += "!-- comment Node<BR>";
//	sOutput += m_CDATA;
//	sOutput += "<BR>--><BR>\n";
//}

/*********************************************************************************

	void CXMLTagNode::DebugDump(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append to
	Outputs:	sOutput - appended with debug information
	Returns:	-
	Scope:		public
	Purpose:	dumps out debugging information on this node.

*********************************************************************************/

//void CXMLTagNode::DebugDump(CTDVString &sOutput)
//{
//	sOutput += "[Tag " + m_Name + " " + m_RawParams + "]<BR>\n";
//}

/*********************************************************************************

	void CXMLTree::DebugDumpTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append debug info to
	Outputs:	sOutput - appended string
	Returns:	-
	Scope:		public
	Purpose:	Dumps the tree with debug information - each node gets to 
				dump debug information.

*********************************************************************************/

void CXMLTree::DebugDumpTree(CTDVString& sOutput)
{
	CXMLTree* pNode = m_FirstChild;
	while (pNode)
	{
		pNode->DebugDumpTree(sOutput);
		pNode = pNode->m_NextSibling;
	}
}

/*********************************************************************************

	void CXMLTextNode::DebugDumpTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append debug info to
	Outputs:	sOutput - appended string
	Returns:	-
	Scope:		public
	Purpose:	Dumps the tree with debug information - each node gets to 
				dump debug information.

*********************************************************************************/

void CXMLTextNode::DebugDumpTree(CTDVString& sOutput)
{
	sOutput +=  m_Text ;
	return;
}

/*********************************************************************************

	void CXMLCDATANode::DebugDumpTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append debug info to
	Outputs:	sOutput - appended string
	Returns:	-
	Scope:		public
	Purpose:	Dumps the tree with debug information - each node gets to 
				dump debug information.

*********************************************************************************/

void CXMLCDATANode::DebugDumpTree(CTDVString& sOutput)
{
	CTDVString out;
	out <<  "<![CDATA[" << m_CDATA << "]]>";
	out.Replace("<","&lt;");
	out.Replace(">","&gt;");
	out += "<BR>";
	sOutput += out;
	return;
}

/*********************************************************************************

	void CXMLCommentNode::DebugDumpTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append debug info to
	Outputs:	sOutput - appended string
	Returns:	-
	Scope:		public
	Purpose:	Dumps the tree with debug information - each node gets to 
				dump debug information.

*********************************************************************************/

void CXMLCommentNode::DebugDumpTree(CTDVString& sOutput)
{
	CTDVString out;
	out <<  "<!--" << m_CDATA << "-->";
	out.Replace("<","&lt;");
	out.Replace(">","&gt;");
	out += "<BR>";
	sOutput += out;
	return;
}

/*********************************************************************************

	void CXMLTagNode::DebugDumpTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - string to append debug info to
	Outputs:	sOutput - appended string
	Returns:	-
	Scope:		public
	Purpose:	Dumps the tree with debug information - each node gets to 
				dump debug information.

*********************************************************************************/

void CXMLTagNode::DebugDumpTree(CTDVString& sOutput)
{
	sOutput += "&lt;" + m_Name;
	if (m_RawParams != "")
	{
		sOutput += " " + m_RawParams;
	}
	if (!m_FirstChild)
	{
		sOutput += "/&gt";
	}
	else
	{
		sOutput += "&gt;";
		//my @children;
		CXMLTree* pNode = m_FirstChild;
	//	while (firstchild)
	//	{
	//		push (@children,$firstchild);
	//		$firstchild = $firstchild->{nextsibling};
	//	}
		while (pNode)
		{
			pNode->DebugDumpTree(sOutput);
			pNode = pNode->GetNextSibling();
		}
		sOutput += "&lt;/" + m_Name + "&gt;";
	}
}

/*********************************************************************************

	void CXMLTagNode::OutputXMLTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput
	Outputs:	sOutput
	Returns:	-
	Scope:		public
	Purpose:	Outputs the node in XML format. Will recurse down children.

*********************************************************************************/

void CXMLTagNode::OutputXMLTree(CTDVString& sOutput)
{
	// output the opening tag <TAGNAME[ attributes]>
	// or an empty tag <TAGNAME />
	
	// start the tag
	sOutput << "<" << m_Name;
	
	// This will have to cope with attributes properly one day
	// So today's a good day to do it

//	if (m_RawParams != "")
//	{
//		sOutput += " " + m_RawParams;
//	}

	CXMLTree* pAttrNode = m_FirstChild;
	bool bOnlyAttributes = true;		// So we can tell if we only have attributes

	while (pAttrNode)
	{
		if (pAttrNode->GetNodeType() != T_ATTRIBUTE)
		{
			bOnlyAttributes = false;		// There was a non-attribute child
		}
		else
		{
			((CXMLAttribute*)pAttrNode)->OutputXMLAttribute(sOutput);
		}
		pAttrNode = pAttrNode->GetNextSibling();
	}

	// Is this an empty tag? Again, with attributes this will change
	if (bOnlyAttributes)
	{
		sOutput += " />";
	}
	else
	{
		// Close the opening tag
		sOutput += ">";

		// Get the first child
		CXMLTree* pNode = m_FirstChild;
	//	while (firstchild)
	//	{
	//		push (@children,$firstchild);
	//		$firstchild = $firstchild->{nextsibling};
	//	}
		while (pNode)
		{
			pNode->OutputXMLTree(sOutput);
			pNode = pNode->GetNextSibling();
		}
		sOutput << "</" << m_Name << ">";
	}
}

/*********************************************************************************

	void CXMLErrorNode::DebugDumpTree(CTDVString& sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput
	Outputs:	sOutput
	Returns:	-
	Scope:		public
	Purpose:	Outputs debug info about node. HTML specific!

*********************************************************************************/

void CXMLErrorNode::DebugDumpTree(CTDVString& sOutput)
{
	sOutput << "<FONT COLOR=\"#FF1111\">Error: " << m_Text << "</FONT><BR>";
	return;
}


/*********************************************************************************

	bool CXMLTree::CheckXPath(const TDVCHAR* psXPath)

		Author:		Mark Howitt
        Created:	19/07/2004
        Inputs:		psXPath - The path you want to check exists.
        Outputs:	-
        Returns:	true if the nodes partents match the given XPath, false if not.
        Purpose:	-

*********************************************************************************/
bool CXMLTree::CheckXPath(const TDVCHAR* psXPath)
{
	// Get and check the parent pointer
	CXMLTree* pParent = GetParent();
	if (pParent == NULL || psXPath == NULL)
	{
		// No Parent!!! Return false
		return false;
	}

	// If no XPath is given, or the XPath root ("/") is specified, then we have a 
	// match as long as this node is the root of the tree.
	if ((strlen(psXPath) == 0) || (strcmp(psXPath,"/") == 0))
	{
		// If the parent has a NULL parent ptr, then the parent is the root node
		CXMLTree* pParentsParent = pParent->GetParent();
		if (pParentsParent == NULL)
		{
			return true;
		}
	}

	// Setup a flag to catch the result
	bool bMatch = false;

	// Check to see if we've been given an XPATH with more than one part?
	const TDVCHAR* psTopTagPos = strrchr(psXPath,'/');	// Have to cast away the const from the return function
	if (psTopTagPos != NULL)
	{
		// Get top most tag from the xpath.
		TDVCHAR sTopTagName[256];
		strncpy(sTopTagName,psTopTagPos + 1,255);

		// Now get the Parent Path
		TDVCHAR sParentPath[1024];
		memset(sParentPath,0,1024);
		strncpy(sParentPath,psXPath,psTopTagPos-psXPath);

		// Check to see if we still match?
		bMatch = pParent->GetName().CompareText(sTopTagName);
		if (bMatch)
		{
			// Now check the parent nodes
			bMatch = pParent->CheckXPath(sParentPath);
		}
	}
	else
	{
		// Check to see if the parent matches the XPath
		bMatch = pParent->GetName().CompareText(psXPath);
	}

	// Return the verdict
	return bMatch;
}

/*********************************************************************************

	CXMLTree* CXMLTree::FindFirstTagName(const TDVCHAR *pTagName, CXMLTree* pParent, bool bAssertOnNULLNode)

	Author:		Jim Lynn
	Inputs:		pTagName - name of node element to find
				pParent - if not NULL, don't find any nodes which are not children
				or otherwise descendants of this node
	Outputs:	-
	Returns:	ptr to first node that matches the node name or NULL for no match
	Scope:		public
	Purpose:	Scans the tree and returns a pointer to the first node whose
				name matches the search name. pParent allows you to search only 
				within a particular subtree.

*********************************************************************************/

CXMLTree* CXMLTree::FindFirstTagName(const TDVCHAR *pTagName, CXMLTree* pParent, bool bAssertOnNULLNode)
{
	// Start from this position and keep scanning until you find the next one that matches
	CXMLTree* pNode = this;

	// Check to see if we've been given an XPATH?
	const TDVCHAR* psTopTagPos = strrchr(pTagName,'/');
	if (psTopTagPos != NULL)
	{
		// Check the XPath
		bool bFoundMatch = false;

		// Get top most tag from the xpath.
		TDVCHAR sTopTagName[256];
		strncpy(sTopTagName,psTopTagPos + 1,256);

		// Now get the leftover path
		TDVCHAR sParentPath[1024];
		memset(sParentPath,0,1024);
		strncpy(sParentPath,pTagName,psTopTagPos-pTagName);

		// Now find the first node of this type!
		while (!bFoundMatch && pNode)
		{
			// Find the next node that matches the top most tag name, if there is one.
			while (pNode && pNode->GetName() != sTopTagName)
			{
				pNode = pNode->FindNext(pParent);
			}


			if (pNode)
			{
				// Now get the Parent Path
                bFoundMatch = pNode->CheckXPath(sParentPath);

				// Did we match the XPath? if not, find the next node and try again
				if (!bFoundMatch)
				{
					pNode = pNode->FindNext(pParent);
				}
			}
		}
	}
	else
	{
		// Get the first node for the given name.
		while (pNode && pNode->GetName() != pTagName)
		{
			pNode = pNode->FindNext(pParent);
		}
	}

#ifdef DEBUG
	if (pNode == NULL && bAssertOnNULLNode)
	{
		CTDVString sError = "Failed to find a matching node for : ";
		sError << pTagName;
		TDVASSERT(false,sError);
	}
#endif

	return (pNode);
}

/*********************************************************************************

	CXMLTree* CXMLTree::FindNextTagNode(const TDVCHAR *pTagName, CXMLTree* pParent)

	Author:		Jim Lynn
	Inputs:		pTagName - name of node to find
				pParent - if not NULL, don't go above this node
	Outputs:	-
	Returns:	ptr to next node which matches the name
	Scope:		public
	Purpose:	Returns the next node which matches the supplied name. will
				not traverse up beyond pParent if it's supplied, allowing you
				to search within a subtree.

*********************************************************************************/

CXMLTree* CXMLTree::FindNextTagNode(const TDVCHAR *pTagName, CXMLTree* pParent)
{
	CXMLTree* pNode = FindNext(pParent);	// Get a pointer to the next one after this one
	while (pNode && pNode->GetName() != pTagName)
	{
		pNode = pNode->FindNext(pParent);
	}

	return (pNode);		// returns NULL if no more found
}

/*********************************************************************************

	CXMLTree* CXMLTree::FindFirstTagNameNoChild(const TDVCHAR *pTagName, CXMLTree* pParent)

	Author:		Markn (adapted from Jim Lynn code)
	Inputs:		pTagName - name of node element to find
				pParent - if not NULL, don't find any nodes which are not children
				or otherwise descendants of this node
	Outputs:	-
	Returns:	ptr to first node that matches the node name or NULL for no match
	Scope:		public
	Purpose:	Same as FindFirstTagName() except that child nodes of this node
				are not traversed.
				
*********************************************************************************/

CXMLTree* CXMLTree::FindFirstTagNameNoChild(const TDVCHAR *pTagName, CXMLTree* pParent)
{
	// Start from this position and keep scanning until you find the next one that matches
	CXMLTree* pNode = this;
	while (pNode && pNode->GetName() != pTagName)
	{
		pNode = pNode->FindNextNoChild(pParent);
	}

	return (pNode);
}

/*********************************************************************************

	CXMLTree* CXMLTree::FindNextTagNodeNoChild(const TDVCHAR *pTagName, CXMLTree* pParent)

	Author:		Markn (adapted from Jim Lynn code)
	Inputs:		pTagName - name of node to find
				pParent - if not NULL, don't go above this node
	Outputs:	-
	Returns:	ptr to next node which matches the name
	Scope:		public
	Purpose:	Same as FindNextTagNode() except that child nodes of this node
				are not traversed.

*********************************************************************************/

CXMLTree* CXMLTree::FindNextTagNodeNoChild(const TDVCHAR *pTagName, CXMLTree* pParent)
{
	CXMLTree* pNode = FindNextNoChild(pParent);	// Get a pointer to the next one after this one
	while (pNode && pNode->GetName() != pTagName)
	{
		pNode = pNode->FindNextNoChild(pParent);
	}

	return (pNode);		// returns NULL if no more found
}
/*********************************************************************************

	CTDVString CXMLTree::GetText()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	string containing text
	Scope:		public
	Purpose:	Returns the text of a node. CXMLTree nodes return an empty string.

*********************************************************************************/

CTDVString CXMLTree::GetText()
{
	return ("");
}

/*********************************************************************************

	bool CXMLTree::SetText(const TDVCHAR* pText)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pText - new text for this node
	Outputs:	-
	Returns:	returns false for failure, because this method should not be called
				on the base class.
	Scope:		public
	Purpose:	virtual function to set the text for this node. The default
				behaviour for the base class is to simply fail however because
				not all nodes have text.

*********************************************************************************/

bool CXMLTree::SetText(const TDVCHAR* pText)
{
	// default is to fail because you should not be trying to set the text
	// on a non text node
	return false;
}

/*********************************************************************************

	CTDVString CXMLTextNode::GetText()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	string containing text
	Scope:		public
	Purpose:	gets the text contents of the text node.

*********************************************************************************/

CTDVString CXMLTextNode::GetText()
{
	return m_Text;
}

/*********************************************************************************

	CTDVString CXMLTagNode::GetText()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	string containing text
	Scope:		public
	Purpose:	returns textual representation of this node

*********************************************************************************/

CTDVString CXMLTagNode::GetText()
{
	CTDVString ret = "<";
	ret += m_Name;
	if (m_RawParams.GetLength() > 0)
	{
		ret += " " + m_RawParams;
	}
	if (!m_FirstChild)
	{
		ret += "/";
	}
	ret += ">";
	return ret;

}

/*********************************************************************************

	CTDVString CXMLCDATANode::GetText()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	string containing text
	Scope:		public
	Purpose:	returns text contents of node

*********************************************************************************/

CTDVString CXMLCDATANode::GetText()
{
	return m_CDATA;
}

/*********************************************************************************

	CTDVString CXMLCDATANode::GetName()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	name of node
	Scope:		public
	Purpose:	CDATA nodes return "_CDATA"

*********************************************************************************/

CTDVString CXMLCDATANode::GetName()
{
	return "_CDATA";
}

/*********************************************************************************

	CTDVString CXMLErrorNode::GetText()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	string containing text
	Scope:		public
	Purpose:	Returns text contents of the given node

*********************************************************************************/

CTDVString CXMLErrorNode::GetText()
{
	return m_Text;
}

/*********************************************************************************

	CTDVString CXMLCommentNode::GetText()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	string containing text
	Scope:		public
	Purpose:	Returns text contents of the given node

*********************************************************************************/

CTDVString CXMLCommentNode::GetText()
{
	return m_CDATA;
}

/*********************************************************************************

	CTDVString CXMLCommentNode::GetName()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	name of node
	Scope:		public
	Purpose:	Comment nodes return "_COMMENT" as their name.

*********************************************************************************/

CTDVString CXMLCommentNode::GetName()
{
	return "_COMMENT";
}


/*********************************************************************************
CXMLTree* CXMLTree::IsNodeWithin(const TDVCHAR* pNames)

	Author:		Jim Lynn
	Inputs:		pNames - names of nodes this one could be within
				for example "LINK|HREF" will return either parent type
	Outputs:	-
	Returns:	pointer to matchig parent or NULL if it isn't within
	Purpose:	Tells you if a given node is a descendant of a named node
				type. This function was used in our transformation code, and
				is unlikely to be useful generally.

**********************************************************************************/

CXMLTree* CXMLTree::IsNodeWithin(const TDVCHAR* pNames)
{
	CTDVString Name = pNames;
	CXMLTree* pParent = m_Parent;
	while (pParent)
	{
		if (Name.FindText(pParent->GetName()) >= 0)
		{
			return (pParent);
		}
		pParent = pParent->m_Parent;
	}
	return (NULL);
}

/*********************************************************************************

	bool CXMLTree::GetAttribute(const TDVCHAR *pAttrName, CTDVString& sValue)

	Author:		Jim Lynn
	Inputs:		pAttrName - name of attribute to get
	Outputs:	sValue - string containing value of attribute
	Returns:	true if attribute exists, false otherwise
	Scope:		public
	Purpose:	virtual function to get an attribute of a given node. Only
				CXMLTagNodes can contain attributes, so other nodes return
				false.

*********************************************************************************/

bool CXMLTree::GetAttribute(const TDVCHAR *pAttrName, CTDVString& sValue)
{
	return false;
}

/*********************************************************************************
bool CXMLTagNode::GetAttribute(const TDVCHAR *pAttrName, CTDVString& sValue)

	Author:		Jim Lynn
	Inputs:		pAttrName - name of the attribute to find
	Outputs:	sValue - string containing value
	Returns:	true if attribute found, false otherwise
	Purpose:	Gets the value of the named attribute (if it exists).
				NEEDS REWRITING TO USE NEW ATTRIBUTE OBJECTS - this version
				directly manipulates the raw attribute params

**********************************************************************************/

bool CXMLTagNode::GetAttribute(const TDVCHAR *pAttrName, CTDVString& sValue)
{
	CXMLAttribute* pNode = FindAttribute(pAttrName);
	if (pNode)
	{
		sValue = pNode->GetValue();
		return true;
	}
	else
	{
		return false;
	}

}


/*********************************************************************************

	CTDVString CXMLTree::DisplayErrors(const TDVCHAR *pText)

	Author:		Jim Lynn
	Inputs:		pText - original source text
	Outputs:	-
	Returns:	string containing marked up text
	Scope:		public
	Purpose:	returns the source text marked up with error messages.
				HTML result, so needs to be changed.

*********************************************************************************/

CTDVString CXMLTree::DisplayErrors(const TDVCHAR *pText)
{
	CTDVString result = pText;
	long offset = 0;
	long lasterrpos = 0;

	CXMLTree* pNode = this;
	while (pNode)
	{
		// Find the next node that has the same position as lasterrpos
		bool notgot = true;
		while (notgot)
		{
			pNode = pNode->FindNext();
			if (pNode == NULL || (pNode->m_NodeType == T_ERROR && ((CXMLErrorNode*)pNode)->m_Pos == lasterrpos))
			{
				notgot = false;
			}
		}

		// either pNode == NULL or we've got another node that matches
		if (pNode == NULL)
		{
			pNode = this;
			while (pNode)
			{
				if (pNode->m_NodeType == T_ERROR && ((CXMLErrorNode*)pNode)->m_Pos > lasterrpos)
				{
					break;
				}
				pNode = pNode->FindNext();
			}
		}
		
		if (pNode == NULL)
		{
			break;
		}

		lasterrpos = ((CXMLErrorNode*)pNode)->m_Pos;

		if (pNode->m_NodeType == T_ERROR)
		{
			CTDVString message = pNode->GetText();
			long errpos = ((CXMLErrorNode*)pNode)->m_Pos;
			errpos += offset;

			message  = "[[***start***]]" + message + "[[***end***]]";

			result = result.Left(errpos) + message + result.Mid(errpos);
			offset += message.GetLength();
		}
		//pNode = pNode->FindNext();
	}
	result.Replace("&", "&amp;");
	result.Replace("<","&lt;");
	result.Replace(">","&gt;");
	result.Replace("\n","<BR/>");
	result.Replace("[[***start***]]","<XMLERROR>");
	result.Replace("[[***end***]]","</XMLERROR>");

	return result;
}

/*********************************************************************************

	CXMLTagNode* CXMLTree::GetDocumentRoot()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	ptr to the root node of this document
	Purpose:	Fetches the root node of a document. This function is only
				applicable to the root of a document. If the document has no
				nodes, then this call returns NULL. The root node should
				always be a CXMLTagNode.

*********************************************************************************/

CXMLTree* CXMLTree::GetDocumentRoot()
{
	if (!this)
	{
		return NULL;
	}
	return m_FirstChild;
}

/*********************************************************************************

	void CXMLTree::OutputXMLTree(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		sOutput - output string to fill
	Outputs:	sOutput - contains XML output for this node and children
	Returns:	-
	Scope:		public
	Purpose:	Outputs the tree in pure XML form. Each node overrides this
				function to output itself appropriately. CXMLTree has no
				visible result, so it just calls the function on its children.

*********************************************************************************/

void CXMLTree::OutputXMLTree(CTDVString &sOutput)
{
	CXMLTree* pNode = m_FirstChild;
	while (pNode)
	{
		pNode->OutputXMLTree(sOutput);
		pNode = pNode->m_NextSibling;
	}

}

/*********************************************************************************

	void CXMLTree::OutputChildrenXMLTree(CTDVString &sOutput)

	Author:		Markn
	Inputs:		sOutput - output string to fill
	Outputs:	sOutput - contains XML output for this node's children
	Returns:	-
	Scope:		public
	Purpose:	Outputs the child nodes in pure XML form. 
				It calls OutputXMLTree() on each child node, and concatinates the results

*********************************************************************************/

void CXMLTree::OutputChildrenXMLTree(CTDVString &sOutput)
{
	CXMLTree* pChild = GetFirstChild();
	while (pChild != NULL)
	{
		pChild->OutputXMLTree(sOutput);
		pChild = pChild->GetNextSibling();
	}
}

/*********************************************************************************

	CXMLTree* CXMLTree::GetFirstChild()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	ptr to the first child of this node, or NULL if no children
	Purpose:	Fetches the first child of a given node.

*********************************************************************************/


/*********************************************************************************

	CXMLTree* CXMLTree::DetachNodeTree()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to detached root
	Purpose:	Removes this node and all its children from its parent tree
				and returns its pointer. Does not delete anything. After calling
				this function, you own the node, and must either delete it
				or put it into another tree.
				Does nothing if this node has no parent...

*********************************************************************************/

CXMLTree* CXMLTree::DetachNodeTree()
{
	if (!m_Parent)
	{
		ASSERT((!m_NextSibling) && (!m_PrevSibling));
		return this;
	}
	
	// handle siblings - prev sibling's next pointer should point to
	// next sibling, and vice versa
	if (m_PrevSibling)
	{
		m_PrevSibling->m_NextSibling = m_NextSibling;
	}

	if (m_NextSibling)
	{
		m_NextSibling->m_PrevSibling = m_PrevSibling;
	}

	// If this one is the first child, adjust its parent's firstchild pointer
	if (!m_PrevSibling)
	{
		m_Parent->m_FirstChild = m_NextSibling;
	}

	if (!m_NextSibling)
	{
		m_Parent->m_LastChild = m_PrevSibling;
	}
	
	// Now wipe all of its pointers
	m_NextSibling = m_PrevSibling = m_Parent = NULL;
	return this;
}

/*********************************************************************************

	void CXMLTextNode::OutputXMLTree(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		Current XML output
	Outputs:	output appended with this object's XML
	Returns:	-
	Scope:		public
	Purpose:	Outputs the text node to an XML stream.

*********************************************************************************/

void CXMLTextNode::OutputXMLTree(CTDVString &sOutput)
{
	sOutput +=  m_Text ;
	return;

}

/*********************************************************************************

	void CXMLAttribute::OutputXMLAttribute(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		XML string to append to
	Outputs:	string with attribute appended to it. Escapes any dodgy characters
	Returns:	-
	Scope:		public
	Purpose:	Outputs the attribute to the XML string.

*********************************************************************************/

void CXMLAttribute::OutputXMLAttribute(CTDVString &sOutput)
{
	sOutput << " " << m_Name << "=";

	if (m_Value.Find('"') >= 0)
	{
		CTDVString safevalue = m_Value;
		safevalue.Replace("\"","&quot;");
		sOutput << "\"" << safevalue << "\"";
	}
	else
	{
		sOutput << "\"" << m_Value << "\"";
	}
}

/*********************************************************************************

	void CXMLCDATANode::OutputXMLTree(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		string to append to
	Outputs:	string with bits appended
	Returns:	-
	Scope:		public
	Purpose:	appends XML representation of the CDATA node to the string

*********************************************************************************/

void CXMLCDATANode::OutputXMLTree(CTDVString &sOutput)
{
	sOutput << "<![CDATA[" << m_CDATA << "]]>";
}

/*********************************************************************************

	void CXMLCommentNode::OutputXMLTree(CTDVString &sOutput)

	Author:		Jim Lynn
	Inputs:		string to append to
	Outputs:	string with bits appended
	Returns:	-
	Scope:		public
	Purpose:	appends XML representation of the comment node to the string

*********************************************************************************/

void CXMLCommentNode::OutputXMLTree(CTDVString &sOutput)
{
	sOutput << "<!--" << m_CDATA << "-->";
}

void CXMLTree::dumptree()
{
#ifdef _DEBUG
	OutputDebugString("Dumping tree\n");
	char* buff = new char[4000];
	CXMLTree* pNode = this;
	while (pNode)
	{
		sprintf(buff, "This: %X\nParent: %X\nPrev: %X\nNext: %X\nChild: %X\n\n", pNode, pNode->m_Parent, pNode->m_PrevSibling, pNode->m_NextSibling, pNode->m_FirstChild);
		OutputDebugString(buff);
		if (pNode->m_PrevSibling == pNode || pNode->m_NextSibling == pNode || pNode->m_FirstChild == pNode || pNode->m_Parent == pNode)
		{
			OutputDebugString("***WARNING: Badly formed tree found\n");
		}
		pNode = pNode->FindNext();
	}
	delete buff;


	OutputDebugString("Finished dumping tree\n\n");
#endif
}

void CXMLTree::SetAttribute(const TDVCHAR *pAttrName, const TDVCHAR *pValue)
{
	
}

void CXMLTree::debugchecktree()
{
#ifdef _DEBUG
	CXMLTree* pNode = this;
	while (pNode->m_Parent)
	{
		pNode = pNode->m_Parent;
	}

	while (pNode)
	{
		if (pNode->m_PrevSibling == pNode || pNode->m_NextSibling == pNode || pNode->m_FirstChild == pNode || pNode->m_Parent == pNode)
		{
			OutputDebugString("***WARNING: Badly formed tree found\n");
		}
		pNode = pNode->FindNext();
	}
#endif
}

/*********************************************************************************

	void CXMLTagNode::SetAttribute(const TDVCHAR *pName, const TDVCHAR *pValue)

	Author:		Jim Lynn
	Inputs:		pName - attribute name
				pValue - string value of this attribute
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Sets the value of a given attribute. Creates it if it doesn't exist

*********************************************************************************/

void CXMLTagNode::SetAttribute(const TDVCHAR *pName, const TDVCHAR *pValue)
{
	CXMLAttribute* pNode = FindAttribute(pName);

	// On exit, pNode is NULL if there isn't one, otherwise we've got one to change
	if (pNode)
	{
		pNode->SetValue(pValue);
	}
	else
	{
		pNode = new CXMLAttribute(pName, pValue);
		AddChild(pNode);
		pNode = NULL;
	}
}

/*********************************************************************************

	void CXMLTagNode::SetAttribute(const TDVCHAR* pName, int iValue)

	Author:		Dharmesh Raithatha
	Created:	5/30/2003
	Inputs:		pName - attribute name
				iValue - int value of this attribute
	Outputs:	-
	Returns:	-
	Purpose:	Sets the value of a given attribute. Creates it if it doesn't exist

*********************************************************************************/

void CXMLTagNode::SetAttribute(const TDVCHAR* pName, int iValue)
{
	CTDVString sValue(iValue);
	SetAttribute(pName,sValue);
}

/*********************************************************************************

	void CXMLAttribute::SetValue(const TDVCHAR *pValue)

	Author:		Jim Lynn
	Inputs:		pValue
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	set the value of the attribute to pValue. Discards existing value

*********************************************************************************/

void CXMLAttribute::SetValue(const TDVCHAR *pValue)
{
	m_Value = pValue;
}

/*********************************************************************************

	CXMLAttribute* CXMLTagNode::FindAttribute(TDVCHAR *pName)

	Author:		Jim Lynn
	Inputs:		pName - name of attribute to find (case insensitive)
	Outputs:	-
	Returns:	ptr to attribute found or NULL
	Scope:		protected
	Purpose:	scans the children of the node to find the given attribute

*********************************************************************************/

CXMLAttribute* CXMLTagNode::FindAttribute(const TDVCHAR *pName)
{
	// The attribute is always a child of the tag node
	CXMLTree* pNode = m_FirstChild;

	bool bNotFound = true;

	while (bNotFound && (pNode != NULL))
	{
		if ((pNode->GetNodeType() == CXMLTree::T_ATTRIBUTE)
			&& (pNode->GetName().CompareText(pName))
			)
		{
			bNotFound = false;
		}
		else
		{
			pNode = pNode->GetNextSibling();
		}
	}
	if (bNotFound)
	{
		return NULL;
	}
	else
	{
		return (CXMLAttribute*)pNode;
	}
}

/*********************************************************************************

	CTDVString CXMLAttribute::GetValue()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	Value
	Scope:		public
	Purpose:	Gets the string value of this attribute.

*********************************************************************************/

CTDVString CXMLAttribute::GetValue()
{
	return m_Value;
}

/*********************************************************************************

	CXMLTree* CXMLTree::FindFirstNodeXP(const TDVCHAR* pNodeSpec, CXMLTree* pParent)

	Author:		Jim Lynn
	Created:	23/02/2000
	Inputs:		pNodeSpec - path to find node, e.g. "/H2G2/ARTICLE/GUIDE"
				pParent - parent node, to restrict searching for nodes
	Outputs:	-
	Returns:	ptr to first node which fulfills the spec
	Purpose:	More sophisticated version of FindFirstTagNode. This uses a 
				simplified version of the XPath node specification syntax to
				search the tree for nodes. For example:
				H2G2	will find a node matching that name as a child of the 
						current node
				/H2G2	ditto
				//H2G2	finds an H2G2 node anywhere below this one
				/H2G2/ARTICLE/GUIDE/BODY//FOOTNOTE will find all the footnotes
						inside a <H2G2><ARTICLE><GUIDE><BODY> structure

				so, / separates direct descendants, // skips any number of 
				levels.

*********************************************************************************/

CXMLTree* CXMLTree::FindFirstNodeXP(const TDVCHAR* pNodeSpec, CXMLTree* pParent)
{
	// In order to make this quick, do the searching from the end of the path
	// so find the last name in the spec

	// Get a string to hold the path
	CTDVString sPath = pNodeSpec;		
	
	// variable to hold leaf we're searching for
	CTDVString sLeafname = "";
	CTDVString sStartOfPath = "";

	// Find the last slash in the path
	int iSlashpos = sPath.ReverseFind('/');	// -ve if not found

	// did we find a slash?
	if (iSlashpos < 0)
	{
		// The whole string is our leaf
		sLeafname = sPath;
		sStartOfPath = "";
	}
	else
	{
		// Get the leafname and the path before it
		sLeafname = sPath.Mid(iSlashpos+1);
		// Get the start of the path string up to and including
		// the last slash
		sStartOfPath = sPath.Left(iSlashpos);
	}

	// Now we've got the basic node name to search for, we'll scan
	// through the tree until we find a node which matches the
	// leafname, then scan backwards up its parent tree to see if
	// it matches the whole path

	// See if any nodes match this one
	CXMLTree* pNode = FindFirstTagName(sLeafname, pParent);

	// Found one?
	if (pNode == NULL)
	{
		// nope, so just return
		return NULL;
	}
	else
	{
		// Found a node which matches the leafname, so scan its parents
		// to see if they match the rest of the path.
		// while we haven't failed to match
		// {
		//		Set 'skip' flag if end of path is "//"
		//		trim off "//" or "/" and fetch next node name
		//		Get parent of this node
		//		while parents don't match and skip flag is set
		//		{
		//			get next parent
		//		}
		//		if parent name doesn't match
		//		{
		//			set flag saying no match
		//		}
		//

		bool bMatched = true;	// we're matched so far
		
		while (bMatched)
		{
			// Set the skip flag to true if we find //
			// also strip trailing /
			bool bSkip = false;
			if (sStartOfPath.Right(2) == "//")
			{
				bSkip = true;
				sStartOfPath = sStartOfPath.TruncateRight(2);
			}
			else
			{
				sStartOfPath = sStartOfPath.TruncateRight(1);
			}

			// Now we should have a leafname
		}
	}
return NULL;
}

bool /*CXMLTree::*/DoesNodeMatchPattern(const TDVCHAR* pPattern)
{
	CXMLTree* pNode = NULL/*this*/;
	CTDVString sPatternRoot = pPattern;

	CTDVString sLeafname = "";
	CTDVString sStartOfPath = "";
	int iSlashpos = sPatternRoot.ReverseFind('/');	// -ve if not found

	// did we find a slash?
	if (iSlashpos < 0)
	{
		// The whole string is our leaf
		sLeafname = sPatternRoot;
		sStartOfPath = "";
	}
	else
	{
		// Get the leafname and the path before it
		sLeafname = sPatternRoot.Mid(iSlashpos+1);
		// Get the start of the path string up to and including
		// the last slash
		sStartOfPath = sPatternRoot.Left(iSlashpos);
	}

	// Found a node which matches the leafname, so scan its parents
	// to see if they match the rest of the path.
	// while we haven't failed to match
	// {
	//		Set 'skip' flag if end of path is "//"
	//		trim off "//" or "/" and fetch next node name
	//		Get parent of this node
	//		while parents don't match and skip flag is set
	//		{
	//			get next parent
	//		}
	//		if parent name doesn't match
	//		{
	//			set flag saying no match
	//		}
	//

	bool bMatched = true;	// we're matched so far
	
	while (bMatched)
	{
		// Set the skip flag to true if we find //
		// also strip trailing /
		bool bSkip = false;
		if (sStartOfPath.Right(2) == "//")
		{
			bSkip = true;
			sStartOfPath = sStartOfPath.TruncateRight(2);
		}
		else
		{
			sStartOfPath = sStartOfPath.TruncateRight(1);
		}

		// Now we should have a leafname
	}
return true;
}

//bool CXMLTree* CXMLTree::ParseXPString(const TDVCHAR* pCurPath,

/*********************************************************************************

	bool CXMLTree::GetTextContents(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	24/02/2000
	Inputs:		-
	Outputs:	sResult - string containing text contents
	Returns:	true if strings were found, false if not
	Purpose:	Finds all the child nodes of this node which are text nodes
				and concatenates their strings together. Returns false if it
				didn't find any text nodes.

				"&lt;" and "&gt;" are converted to "<" and ">"

*********************************************************************************/

bool CXMLTree::GetTextContents(CTDVString &sResult)
{
	bool bFoundText = GetTextContentsRaw(sResult);
	sResult.Replace("&lt;", "<");
	sResult.Replace("&gt;", ">");
	return bFoundText;
}

/*********************************************************************************

	bool CXMLTree::GetTextContentsRaw(CTDVString &sResult)

	Author:		Jim Lynn (split from GetTextContents() by Markn 18/5/2004)
	Created:	24/02/2000
	Inputs:		-
	Outputs:	sResult - string containing text contents
	Returns:	true if strings were found, false if not
	Purpose:	Finds all the child nodes of this node which are text nodes
				and concatenates their strings together. Returns false if it
				didn't find any text nodes.

				The raw, unaltered, text in the nodes is returned.

*********************************************************************************/

bool CXMLTree::GetTextContentsRaw(CTDVString &sResult)
{
	CXMLTree* pNode = m_FirstChild;
	bool bFoundText = false;		// if we found text children
	while (pNode != NULL)
	{
		if (pNode->m_NodeType == T_TEXT || pNode->m_NodeType == T_CDATA)
		{
			bFoundText = true;
			sResult += pNode->GetText();
		}
//		pNode = pNode->m_NextSibling;
		// Ensure we traverse down the tree to pick out *all* text nodes, even subnodes
		pNode = pNode->FindNext(this);
	}
	// We've added together all the text children, return whether
	// we actually found any
	return bFoundText;
}

void CXMLTree::DebugDumpErrors()
{
#ifdef _DEBUG
	CXMLTree* pNode = this;
	while (pNode != NULL)
	{
		if (pNode->GetNodeType() == T_ERROR)
		{
			CTDVString errmess = "Parsing Error: ";
			errmess << pNode->GetText() << " at pos " << pNode->m_Pos;
			TDVASSERT(false,errmess);
		}
		pNode = pNode->FindNext();
	}
#endif //_DEBUG
}

bool CXMLTree::CompareNodeName(const TDVCHAR *pName)
{
	return false;
}


bool CXMLTagNode::CompareNodeName(const TDVCHAR *pName)
{
	return (m_Name.CompareText(pName) != 0);
}

CTDVString CXMLAttribute::GetName()
{
	return m_Name;
}

/*********************************************************************************

	bool CXMLTree::DoesAttributeExist(const TDVCHAR *pName)

	Author:		Jim Lynn
	Created:	13/03/2000
	Inputs:		pName - name of attribute to find
	Outputs:	-
	Returns:	true if attribute of node exists, false otherwise
	Purpose:	virtual base function. Looks for an attribute and returns true
				if it exists. Only T_NODE elements can have attributes, all other
				classes always return false;

*********************************************************************************/

bool CXMLTree::DoesAttributeExist(const TDVCHAR *pName)
{
	return false;
}

/*********************************************************************************

	bool CXMLTagNode::DoesAttributeExist(const TDVCHAR *pName)

	Author:		Jim Lynn
	Created:	13/03/2000
	Inputs:		pName - attribute name to find
	Outputs:	-
	Returns:	true if attribute exists, false otherwise
	Purpose:	Looks for the named attribute on this node and returns true if it
				exists, false otherwise.

*********************************************************************************/

bool CXMLTagNode::DoesAttributeExist(const TDVCHAR *pName)
{
	if (FindAttribute(pName) == NULL)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/*********************************************************************************

	int CXMLTree::GetIntAttribute(const TDVCHAR *pName)

	Author:		Jim Lynn
	Created:	13/03/2000
	Inputs:		pName
	Outputs:	-
	Returns:	integer value of attribute. If the attribute does not exist the
				function will return 0. Use DoesAttributeExist to check explicitly
				for the attribute's value.
	Purpose:	-

*********************************************************************************/

int CXMLTree::GetIntAttribute(const TDVCHAR *pName)
{
	return 0;
}

/*********************************************************************************

	int CXMLTagNode::GetIntAttribute(const TDVCHAR *pName)

	Author:		Jim Lynn
	Created:	13/03/2000
	Inputs:		pName
	Outputs:	-
	Returns:	integer value of attribute. Zero if failed. 
	Purpose:	If the attribute does not exist the function will return 0. 
				Use DoesAttributeExist to check explicitly for the attribute's 
				existence.

*********************************************************************************/

int CXMLTagNode::GetIntAttribute(const TDVCHAR *pName)
{
	CTDVString sTemp = "";
	if (this->GetAttribute(pName, sTemp))
	{
		return atoi(sTemp);
	}
	else
	{
		return 0;
	}
}

void CXMLTree::SetAttribute(const TDVCHAR *pName, int iValue)
{
	char buffer[40];
	_itoa(iValue, buffer, 10);
	this->SetAttribute(pName, buffer);
}


char* pEntities = 
"&amp;"
"&apos;"
"&lt;"
"&gt;"
"&quot;"
"&AElig;"
"&Aacute;"
"&Acirc;"
"&Agrave;"
"&Alpha;"
"&Aring;"
"&Atilde;"
"&Auml;"
"&Beta;"
"&COPY;"
"&Ccedil;"
"&Chi;"
"&Dagger;"
"&Delta;"
"&ETH;"
"&Eacute;"
"&Ecirc;"
"&Egrave;"
"&Epsilon;"
"&Eta;"
"&Euml;"
"&GT;"
"&Gamma;"
"&Iacute;"
"&Icirc;"
"&Igrave;"
"&Iota;"
"&Iuml;"
"&Kappa;"
"&LT;"
"&Lambda;"
"&Mu;"
"&Ntilde;"
"&Nu;"
"&OElig;"
"&Oacute;"
"&Ocirc;"
"&Ograve;"
"&Omega;"
"&Omicron;"
"&Oslash;"
"&Otilde;"
"&Ouml;"
"&Phi;"
"&Pi;"
"&Prime;"
"&Psi;"
"&QUOT;"
"&REG;"
"&Rho;"
"&Scaron;"
"&Sigma;"
"&THORN;"
"&TRADE;"
"&Tau;"
"&Theta;"
"&Uacute;"
"&Ucirc;"
"&Ugrave;"
"&Upsilon;"
"&Uuml;"
"&Xi;"
"&Yacute;"
"&Yuml;"
"&Zeta;"
"&aacute;"
"&aafs;"
"&acirc;"
"&acute;"
"&aelig;"
"&agrave;"
"&alefsym;"
"&alpha;"
"&and;"
"&ang;"
"&aring;"
"&ass;"
"&asymp;"
"&atilde;"
"&auml;"
"&bdquo;"
"&beta;"
"&brvbar;"
"&bull;"
"&cap;"
"&ccedil;"
"&cedil;"
"&cent;"
"&chi;"
"&circ;"
"&clubs;"
"&cong;"
"&copy;"
"&crarr;"
"&cup;"
"&curren;"
"&dArr;"
"&dagger;"
"&darr;"
"&deg;"
"&delta;"
"&diams;"
"&divide;"
"&eacute;"
"&ecirc;"
"&egrave;"
"&empty;"
"&emsp;"
"&ensp;"
"&epsilon;"
"&equiv;"
"&eta;"
"&eth;"
"&euml;"
"&euro;"
"&exist;"
"&fnof;"
"&forall;"
"&frac12;"
"&frac14;"
"&frac34;"
"&frasl;"
"&gamma;"
"&ge;"
"&hArr;"
"&harr;"
"&hearts;"
"&hellip;"
"&iacute;"
"&iafs;"
"&icirc;"
"&iexcl;"
"&igrave;"
"&image;"
"&infin;"
"&int;"
"&iota;"
"&iquest;"
"&isin;"
"&iss;"
"&iuml;"
"&kappa;"
"&lArr;"
"&lambda;"
"&lang;"
"&laquo;"
"&larr;"
"&lceil;"
"&ldquo;"
"&le;"
"&lfloor;"
"&lowast;"
"&loz;"
"&lre;"
"&lrm;"
"&lro;"
"&lsaquo;"
"&lsquo;"
"&macr;"
"&mdash;"
"&micro;"
"&middot;"
"&minus;"
"&mu;"
"&nabla;"
"&nads;"
"&nbsp;"
"&ndash;"
"&ne;"
"&ni;"
"&nods;"
"&not;"
"&notin;"
"&nsub;"
"&ntilde;"
"&nu;"
"&oacute;"
"&ocirc;"
"&oelig;"
"&ograve;"
"&oline;"
"&omega;"
"&omicron;"
"&oplus;"
"&or;"
"&ordf;"
"&ordm;"
"&oslash;"
"&otilde;"
"&otimes;"
"&ouml;"
"&para;"
"&part;"
"&pdf;"
"&permil;"
"&perp;"
"&phi;"
"&pi;"
"&piv;"
"&plusmn;"
"&pound;"
"&prime;"
"&prod;"
"&prop;"
"&psi;"
"&rArr;"
"&radic;"
"&rang;"
"&raquo;"
"&rarr;"
"&rceil;"
"&rdquo;"
"&real;"
"&reg;"
"&rfloor;"
"&rho;"
"&rle;"
"&rlm;"
"&rlo;"
"&rsaquo;"
"&rsquo;"
"&sbquo;"
"&scaron;"
"&sdot;"
"&sect;"
"&shy;"
"&sigma;"
"&sigmaf;"
"&sim;"
"&spades;"
"&sub;"
"&sube;"
"&sum;"
"&sup;"
"&sup1;"
"&sup2;"
"&sup3;"
"&supe;"
"&szlig;"
"&tau;"
"&there4;"
"&theta;"
"&thetasym;"
"&thinsp;"
"&thorn;"
"&tilde;"
"&times;"
"&trade;"
"&uArr;"
"&uacute;"
"&uarr;"
"&ucirc;"
"&ugrave;"
"&uml;"
"&upsih;"
"&upsilon;"
"&uuml;"
"&weierp;"
"&xi;"
"&yacute;"
"&yen;"
"&yuml;"
"&zeta;"
"&zwj;"
"&zwnj;"
"&zwsp;";



void CXMLTree::FlagAmpersandErrors(const TDVCHAR* pText, bool bShowErrors, long *NumErrors, CXMLTree *pCurParent, long stringstart, CTDVString* pFixedOutput)
{
	CTDVString sText = pText;
	CTDVString sFixedText;
	sFixedText.EnsureAvailable(sText.GetLength());
	long lastpos = 0;

	// look for the ampersands
	long amppos = sText.Find("&",lastpos);
	while (amppos >= 0)
	{
		sFixedText.AppendMid(sText, lastpos, amppos-lastpos);
		lastpos = amppos;
		// We've found an ampersand. The following are legal:
		// &abcd;
		// &#1234;
		// and nothing else (I allege)
		
		// Check the next character (if there is one)
		if (amppos == sText.GetLength() - 1)
		{
			// Ooops - a single ampersand at the end, so flag that
			if (bShowErrors)
			{
				CXMLErrorNode* pError = new CXMLErrorNode("Illegal use of Ampersand", amppos + stringstart);
				pCurParent->AddChild(pError);
				(*NumErrors)++;
			}
			// add the expanded ampersand to the fixed text
			sFixedText << "&amp;";
			lastpos++;
		}
		else
		{
			// There are more characters left, so see what they are
			TDVCHAR ch = sText.GetAt(amppos+1);

			// is it a #
			if (ch == '#')
			{
				// Only accept numbers followed by semicolon
				long semipos = sText.FindContaining("0123456789", amppos+2);
				if (semipos < 0 || sText.GetAt(semipos) != ';')
				{
					// No semicolon found
					if (bShowErrors)
					{
						CXMLErrorNode* pError = new CXMLErrorNode("Illegal use of Ampersand", amppos + stringstart);
						pCurParent->AddChild(pError);
						(*NumErrors)++;
					}
					// add the expanded ampersand to the fixed text
					sFixedText << "&amp;";
					lastpos++;
				}
				else
				{
					// Valid entity, so put it in the fixed string
					sFixedText.AppendMid(sText, amppos, (semipos + 1) - amppos);
					lastpos = semipos + 1;
				}
			}
			else
			{
				// We assume it's an entity so find the first non-alpha char
				long semipos = sText.FindContaining("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-", amppos+1);
				if (semipos < 0 || sText.GetAt(semipos) != ';' || sText.GetAt(amppos + 1) == '-')
				{
					// No semicolon found
					if (bShowErrors)
					{
						CXMLErrorNode* pError = new CXMLErrorNode("Illegal use of Ampersand", amppos + stringstart);
						pCurParent->AddChild(pError);
						(*NumErrors)++;
					}
					// add the expanded ampersand to the fixed text
					sFixedText << "&amp;";
					lastpos++;
				}
				else
				{
					CTDVString sEnt = sText.Mid(amppos, (semipos + 1) - amppos);
					// Valid entity, so put it in the fixed string
					
					if (strstr(pEntities, sEnt) == NULL)
					{
						sEnt.Replace("&","&amp;");
					}
					
					//sFixedText.AppendMid(sText, amppos, (semipos + 1) - amppos);
					sFixedText << sEnt;
					lastpos = semipos + 1;
				}
			}
		}

		amppos = sText.Find("&",lastpos);
	}
	// append the last bit of text to FixedText
	sFixedText.AppendMid(sText, lastpos);

	// return the fixed output if asked
	if (pFixedOutput != NULL)
	{
		*pFixedOutput = sFixedText;
	}
}


CXMLTree* CXMLTree::_TEST_CreateFromFile(const char* sXMLFile)
{
	
	//load the contents of the file into a buffer
	FILE* pFile = fopen(sXMLFile,"rb");
	if (pFile == NULL)
	{
		return false;
	}
	
	// obtain file size.
	fseek (pFile , 0 , SEEK_END);
	const long lSize = ftell (pFile);
	rewind (pFile);
	
	// allocate memory to contain the whole file.
	char* buffer = new char[lSize + 16];
	
	// copy the file into the buffer.
	fread ((void*)buffer,sizeof(char),lSize,pFile);
	
	/*** the whole file is loaded in the buffer. ***/
	// terminate
	fclose (pFile);
	buffer[lSize] = 0;
	
	//Create an xmltree from the text

	long errors;

	//create a tree from the buffer
	CXMLTree* pXMLTree = CXMLTree::Parse(buffer, true, &errors);

	if (errors > 0)
	{	
		TDVASSERT(false,"Errors in parsing in XMLTree::_TEST_CreateFromFile");
		delete pXMLTree;
		pXMLTree = NULL;
	}

	delete buffer;

	return pXMLTree;

}

bool CXMLTree::_TEST_CreateTestFile(const TDVCHAR *pXMLFile)
{
	CTDVString out;
	FILE* pFile = fopen(pXMLFile,"w");
	if (pFile == NULL)
	{
		return false;
	}
	OutputXMLTree(out);
	
	// obtain file size.
	fwrite((void*)(LPCTSTR)out, sizeof(TDVCHAR),out.GetLength(), pFile);
	
	fclose (pFile);
	return true;


}


/*********************************************************************************

	CXMLTree* CXMLTree::GetFirstChild(e_nodetype NodeType)

	Author:		Mark Neves
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CXMLTree* CXMLTree::GetFirstChild(e_nodetype NodeType)
{
	CXMLTree* pNode = GetFirstChild();

	if (NodeType == T_NONE)
	{
		return pNode;
	}

	while (pNode != NULL)
	{
		if (pNode->m_NodeType == NodeType)
		{
			return pNode;
		}
		pNode = pNode->FindNext(this);
	}

	return NULL;
}

/*********************************************************************************

	CXMLTree* CXMLTree::GetNextSibling(e_nodetype NodeType)

		Author:		Mark Neves
        Created:	28/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CXMLTree* CXMLTree::GetNextSibling(e_nodetype NodeType)
{
	CXMLTree* pNode = GetNextSibling();

	if (NodeType == T_NONE)
	{
		return pNode;
	}

	while (pNode != NULL)
	{
		if (pNode->m_NodeType == NodeType)
		{
			return pNode;
		}
		pNode = pNode->GetNextSibling();
	}

	return NULL;
}


/*********************************************************************************

	void CXMLTree::DumpNodes(int nLevel = 0)

	Author:		Mark Neves
	Created:	08/10/2003
	Inputs:		nLevel = start level (this is an optional param, and generally not supplied on initial call)
	Outputs:	-
	Returns:	-
	Purpose:	Dumps the tree's nodes using TRACE calls, for debugging purposes

*********************************************************************************/

void CXMLTree::DumpNodes(int nLevel)
{
#ifdef _DEBUG
	for (int i=(nLevel*4); i > 0;i--)
	{
		TRACE(" ");
	}
	TRACE(GetName());
	TRACE("\n");

	CXMLTree* pChild = GetFirstChild();
	while (pChild)
	{
		pChild->DumpNodes(nLevel+1);
		pChild = pChild->GetNextSibling();
	}
#endif
}

/*********************************************************************************

	void CXMLTree::DumpNodes(int nLevel = 0)

	Author:		David E
	Created:	04/04/2005
	Inputs:		sNode - namer of an xml node 
	Outputs:	-
	Returns:	-xpath of node 
	Purpose:	--return xpath of node 

*********************************************************************************/
CTDVString CXMLTree::GetXPath( CTDVString sNode ) 
{
	CTDVString sPath = GetName( );
	
	// Get and check the parent pointer	
	CXMLTree* pParent = GetParent();
	
	//return if this is the root node 
	if  ( ( sPath.CompareText("NULL") ) &&  ( pParent == NULL ) )
	{
		return "\\" + sNode;
	}

	while ( pParent != NULL )
	{
		if ( ( pParent->GetNodeType( ) == T_NODE) || ( pParent->GetNodeType( ) == T_ATTRIBUTE) )
		{
			sPath = pParent->GetName( ) + "\\" +  sPath;
		}
		pParent = pParent->GetParent();
	}

	sPath = "\\" + sPath;
	
	if ( sPath.CompareText("\\") == true)
	{
		sPath = sPath + sNode;
	}
	else
	{
		if ( sNode.IsEmpty( ) == false)
		{
			sPath = sPath + "\\" + sNode;
		}
	}
	
	return sPath;
}

