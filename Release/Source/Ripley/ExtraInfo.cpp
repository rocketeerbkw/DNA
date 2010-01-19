// ExtraInfo.cpp: implementation of the CExtraInfo class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ExtraInfo.h"
#include "tdvassert.h"
#include "XMLObject.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


CExtraInfo::CExtraInfo() : m_pXMLTree(NULL), m_iType(0)
{

}

CExtraInfo::CExtraInfo(int iType) : m_pXMLTree(NULL), m_iType(0)
{
	Create(iType);
}

CExtraInfo::~CExtraInfo()
{
	Clear();
}

/*********************************************************************************

	void CExtraInfo::Clear()

	Author:		Dharmesh Raithatha
	Created:	6/26/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Clears the ExtraInfo object

*********************************************************************************/

void CExtraInfo::Clear()
{
	delete m_pXMLTree;
	m_pXMLTree = NULL;
	m_iType = 0;
}


/*********************************************************************************

	bool CExtraInfo::Create(int iType)
	
	Author:		Nick Stevenson
	Created:	20/08/2003
	Inputs:		iType = GuideEntry type id
	Outputs:	
	Returns:	true if successfull false otherwise
	Purpose:	Creates an ExtraInfo object and sets the type child with the XML 
				format<EXTRAINFO><TYPE ID="xx"/></EXTRAINFO>


*********************************************************************************/

bool CExtraInfo::Create(int iType)
{
	return Create(iType,"<EXTRAINFO></EXTRAINFO>");
}

/*********************************************************************************

	bool CExtraInfo::Create(int iType, const TDVCHAR* pExtraInfoXML)

	Author:		Dharmesh Raithatha, Nick Stevenson
	Created:	6/23/2003
	Inputs:		iType = GuideEntry type id
				pExtraInfoXML - the extrainfo as xml
	Outputs:	-
	Returns:	true, if successful false otherwise	
	Purpose:	creates the extrainfo given the to create it. Ensure that the 
				xml is enclosed by <EXTRAINFO></EXTRAINFO> or it will fail

*********************************************************************************/

bool CExtraInfo::Create(int iType, const TDVCHAR* pExtraInfoXML)
{
	if (iType <= 0)
	{
		TDVASSERT(false,"CExtraInfo::Create() Type param <= 0");
		return false;
	}

	Clear();
	
	m_pXMLTree = CXMLTree::Parse(pExtraInfoXML);

	if (m_pXMLTree != NULL)
	{
		CXMLTree* pExtraInfoNode = GetRoot();

		// If the root node is found, it must be called <EXTRAINFO>
		if (pExtraInfoNode != NULL)
		{
			RemoveAllInfoItems("TYPE");

			CTDVString sTypeXML;
			BuildTypeTag(iType, sTypeXML);
			if (AddInfoItems(sTypeXML))
			{
				m_iType = iType;
				return true;
			}
			else
			{
				TDVASSERT(false,"CExtraInfo::Create() TYPE tag parse error");
			}
		}
		else
		{
			TDVASSERT(false,"CExtraInfo::Create() root is not <EXTRAINFO>");
		}
	}
	else
	{
		TDVASSERT(false,"CExtraInfo::Create() parse error");
	}

	Clear();
	return false;
}

/*********************************************************************************

	bool CExtraInfo::AddInfoItems(const TDVCHAR* pInfoItem)

	Author:		Dharmesh Raithatha
	Created:	6/24/2003
	Inputs:		pInfoItem - a list of xml items that are to be added to the extra
				info
	Outputs:	-
	Returns:	true if successfully added false otherwise
	Purpose:	Adds xml to the extra info object. You 
				can put in xml with a root or multiple roots.
				If the ExtraInfoObject has not been created it will get created 
				first.

*********************************************************************************/

bool CExtraInfo::AddInfoItems(const TDVCHAR* pInfoItem)
{
	if (!IsCreated())
	{
		return false;
	}

	bool ok = false;

	CXMLTree* pTree = CXMLTree::Parse(pInfoItem);
	if (pTree != NULL)
	{
		CXMLTree* pInfoItems = pTree->GetDocumentRoot();

		if (pInfoItems != NULL)
		{
			CXMLTree* pExtraInfoNode = GetRoot();
			if (pExtraInfoNode != NULL)
			{
				CXMLTree* pNode = pInfoItems;
				while (pNode != NULL)
				{
					CXMLTree* pNext = pNode->GetNextSibling();
					pExtraInfoNode->AddChild(pNode->DetachNodeTree());
					pNode = pNext;
				}
				ok = true;
			}
			else
			{
				TDVASSERT(false,"CExtraInfo::AddInfoItems: No <EXTRAINFO> tag");
			}
		}
		else
		{
			TDVASSERT(false,"CExtraInfo::AddInfoItems: No document root");
		}
	}
	else
	{
		TDVASSERT(false,"CExtraInfo::AddInfoItems: Parse failed");
	}
	
	delete pTree;
	return ok;
}



/*********************************************************************************

	bool CExtraInfo::RemoveInfoItem(const TDVCHAR* pInfoItemName)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		pInfoItemName = the name of the info item tag
	Outputs:	-
	Returns:	true if one was removed, false otherwise
	Purpose:	Deletes the first tag (and all it's children) with the name provided.

*********************************************************************************/

bool CExtraInfo::RemoveInfoItem(const TDVCHAR* pInfoItemName)
{
	CTDVString sInfoItemName(pInfoItemName);
	if (sInfoItemName.CompareText("EXTRAINFO"))
	{
		TDVASSERT(false,"Trying to delete EXTRAINFO tag");
		return false;
	}

	if (m_pXMLTree != NULL)
	{
		CXMLTree* pInfoItem = GetFirstInfoItem();

		while (pInfoItem != NULL)
		{
			if (pInfoItem->GetName().CompareText(pInfoItemName))
			{
				pInfoItem->DetachNodeTree();
				delete pInfoItem;
				return true;
			}

			pInfoItem = pInfoItem->GetNextSibling();
		}
	}

	return false;
}

/*********************************************************************************

	int CExtraInfo::RemoveAllInfoItems(const TDVCHAR* pInfoItemName)

	Author:		Mark Neves
	Created:	21/11/2003
	Inputs:		pInfoItemName = the name of the item
	Outputs:	-
	Returns:	the number of items it removed
	Purpose:	Removes all items called pInfoItemName

*********************************************************************************/

int CExtraInfo::RemoveAllInfoItems(const TDVCHAR* pInfoItemName)
{
	int n = 0;
	while (RemoveInfoItem(pInfoItemName))
	{
		n++;
	}
	return n;
}

/*********************************************************************************

	bool CExtraInfo::ExistsInfoItem(const TDVCHAR* pInfoItemName)

	Author:		Nick Stevenson
	Created:	12/08/2003
	Inputs:		pInfoItemName = the name of the info item tag
	Outputs:	-
	Returns:	boolean value stating the existence of the tag	
	Purpose:	returns true if tag with the name is found
	
*********************************************************************************/

bool CExtraInfo::ExistsInfoItem(const TDVCHAR* pInfoItemName)
{
	if (m_pXMLTree != NULL)
	{
		CXMLTree* pInfoItem = GetFirstInfoItem();

		while (pInfoItem != NULL)
		{
			if (pInfoItem->GetName().CompareText(pInfoItemName))
			{
				return true;
			}

			pInfoItem = pInfoItem->GetNextSibling();
		}
	}

	return false;
}

/*********************************************************************************

	bool CExtraInfo::GetInfoAsXML(CTDVString& sExtraInfoXML, bool bHiddenVersion) const

	Author:		Dharmesh Raithatha
	Created:	6/24/2003
	Inputs:		bHiddenVersion = if true, only produce an ExtraInfo object that only contains the type
	Outputs:	sExtraInfoXML
	Returns:	true if string was generated, false otherwise
	Purpose:	Returns the contents of the ExtraInfo as XML

*********************************************************************************/

bool CExtraInfo::GetInfoAsXML(CTDVString& sExtraInfoXML, bool bHiddenVersion) const
{
	if (m_pXMLTree == NULL)
	{
		return false;
	}

	sExtraInfoXML.Empty();

	if (bHiddenVersion)
	{
		CExtraInfo TempExtraInfo(m_iType);
		TempExtraInfo.GetInfoAsXML(sExtraInfoXML,false);
	}
	else
	{
		m_pXMLTree->OutputXMLTree(sExtraInfoXML);
	}

	return true;
}

/*********************************************************************************

	CExtraInfo& CExtraInfo::operator=(CExtraInfo& ExtraInfo)

	Author:		Dharmesh Raithatha
	Created:	6/26/2003
	Inputs:		-
	Outputs:	-
	Returns:	this
	Purpose:	An inefficient = operator as xmltree does not yet have an = operator
				So this works by getting the xml and then recreating from the XML.

*********************************************************************************/

const CExtraInfo& CExtraInfo::operator=(const CExtraInfo& ExtraInfo)
{
	if (!ExtraInfo.IsCreated())
	{
		TDVASSERT(false,"Can't assign when right hand side has not been created");
		return *this;
	}

	Clear();

	CTDVString sExtraInfo;
	ExtraInfo.GetInfoAsXML(sExtraInfo);

	Create(ExtraInfo.GetType(),sExtraInfo);

	return *this;
}

/*********************************************************************************

	
	void CExtraInfo::BuildTypeTag(CTDVString& sTypeTag) const
	Author:		Nick Stevenson
	Created:	20/08/2003
	Inputs:		-
	Outputs:	sTypeTag -ref to a string object to be populated with type xml
	Returns:	true
	Purpose:	Builds the ExtraInfo type xml tag and assigns it to string ref

*********************************************************************************/


void CExtraInfo::BuildTypeTag(int iType, CTDVString& sTypeTag) const
{
	sTypeTag << "<TYPE ID='" << iType << "'/>";
}


/*********************************************************************************

	bool CExtraInfo::SetType(int iType)	

	Author:		Nick Stevenson
	Created:	20/08/2003
	Inputs:		iType: expresses guide type id
	Outputs:	-
	Returns:	true or false
	Purpose:	obtains the guide type name for the given type id and calls 
				ExtraInfo (EI) set methods to set the values in the EI object.
				if no type tag is defined in the EI xml, the
				tagstring is built and assigned to it

*********************************************************************************/

bool CExtraInfo::SetType(int iType)
{
	if (iType <= 0)
	{
		TDVASSERT(false,"CExtraInfo::SetType() Type param <= 0");
		return false;
	}

	if (!IsCreated())
	{
		return false;
	}

	// set ExtraInfo instance vars
	m_iType = iType;

	//delete exiting type tags if they exists
	RemoveAllInfoItems("TYPE");

	// add the type tag to extrainfo
	CTDVString sTypeTag;
	BuildTypeTag(iType, sTypeTag);
	return AddInfoItems(sTypeTag);
}


/*********************************************************************************

	bool CExtraInfo::AddUniqueInfoItem(const TDVCHAR* pTagName, const CTDVString& sXML)

	Author:		Mark Neves
	Created:	06/08/2003 (moved from CClub on 08/10/2003)
	Inputs:		pTagName  = the name of the tag to place the supplied data under
				sXML	  = the XML of the tag whose name matches pTagName
	Outputs:	-
	Returns:	-
	Purpose:	Helper function for adding tags.
				It firstly removes all tags with the same name, if they exist

				NOTE: If the supplied sText is empty or only contains whitespace, nothing is added

*********************************************************************************/

bool CExtraInfo::AddUniqueInfoItem(const TDVCHAR* pTagName, const CTDVString& sXML)
{
	bool bSuccess = false;
	if (pTagName != NULL)
	{
		// Remove existing ones, if there are any
		RemoveAllInfoItems(pTagName);
		bSuccess = AddInfoItems(sXML);
	}

	return bSuccess;
}


/*********************************************************************************

	void CExtraInfo::ReplaceMatchingItems(const CExtraInfo& OtherExtraInfo)

	Author:		Mark Neves
	Created:	08/10/2003
	Inputs:		OtherExtraInfo = contains the source tags
	Outputs:	-
	Returns:	-
	Purpose:	Iterates through all the elements in OtherExtraInfo, and adds them to this
				ExtraInfo object.
				If the tag already exists in this ExtraInfo, it is replaced.

				NOTE: This will only work for elements that only contain text.
				If the elements contain attributes, the attributes will NOT be copied across

*********************************************************************************/

void CExtraInfo::ReplaceMatchingItems(const CExtraInfo& OtherExtraInfo)
{
	CTDVString sName, sXML;

	int i=0;
	while (OtherExtraInfo.GetElementFromIndex(i++,sName,sXML))
	{
		AddUniqueInfoItem(sName, sXML);
	}
}


/*********************************************************************************

	bool CExtraInfo::GetElementFromIndex(int iIndex, CTDVString& sName, CTDVString& sXML) const

	Author:		Mark Neves
	Created:	08/10/2003
	Inputs:		iIndex = index of element you want (0 = first element)
	Outputs:	sName = filled with element name
				sXML = filled in with element value
	Returns:	true if found, false otherwise
	Purpose:	Gets a specific element.

*********************************************************************************/

bool CExtraInfo::GetElementFromIndex(int iIndex, CTDVString& sName, CTDVString& sXML) const
{
	sName.Empty();
	sXML.Empty();

	if (iIndex < 0)
	{
		return false;
	}

	bool bOK = false;

	CXMLTree* pTree = NULL;
	if (m_pXMLTree != NULL)
	{
		pTree = GetRoot();

		if (pTree != NULL)
		{
			pTree = pTree->GetFirstChild(CXMLTree::T_NODE);
		}

		while (iIndex > 0 && pTree != NULL)
		{
			pTree = pTree->GetNextSibling();
			iIndex--;
		}
	}

	if (pTree != NULL)
	{
		sName = pTree->GetName();
		pTree->OutputXMLTree(sXML);
		bOK = true;
	}

	return bOK;
}

/*********************************************************************************

	CXMLTree* CExtraInfo::GetRoot() const

	Author:		Mark Neves
	Created:	05/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CXMLTree* CExtraInfo::GetRoot() const
{
	CXMLTree* pRoot = NULL;

	if (IsCreated())
	{
		pRoot = m_pXMLTree->GetDocumentRoot();

		if (pRoot != NULL)
		{
			if (!pRoot->GetName().CompareText("EXTRAINFO"))
			{
				TDVASSERT(false,"Root of extrainfo object is NOT EXTRAINFO!");
				pRoot = NULL;
			}
		}
	}

	return pRoot;
}

/*********************************************************************************

	CXMLTree* CExtraInfo::GetFirstInfoItem() const

	Author:		Mark Neves
	Created:	05/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CXMLTree* CExtraInfo::GetFirstInfoItem() const
{
	CXMLTree* pRoot = GetRoot();
	if (pRoot != NULL)
	{
		return pRoot->GetFirstChild();
	}

	return NULL;
}

/*********************************************************************************

	void CExtraInfo::GenerateAutoDescription(const CTDVString& sText)

	Author:		Mark Neves
	Created:	06/08/2003 (moved to ExtraInfo on 17/10/2003)
	Inputs:		sText	  = the auto description text
	Outputs:	extrainfo is updated
	Returns:	-
	Purpose:	Helper function for adding the <AUTODESCRIPTION> tag to extra info.
				It makes sure the text is not greater than the maximum allowed length.
				It also escapes any XML in the text.
				It uses AddToExtraInfo() to do the rest.

*********************************************************************************/

void CExtraInfo::GenerateAutoDescription(const CTDVString& sText)
{
	CTDVString sNewText;

	CXMLObject::CreateSimpleTextLineFromXML(sText,sNewText);

	if (sNewText.GetLength() >= CExtraInfo::AUTODESCRIPTIONSIZE)
	{
		sNewText = sNewText.Left(CExtraInfo::AUTODESCRIPTIONSIZE - 3);
		sNewText << "...";
	}

	CTDVString sXML;
	CXMLObject::MakeTag("AUTODESCRIPTION",sNewText,sXML);
	
	AddUniqueInfoItem("AUTODESCRIPTION", sXML);
}


/*********************************************************************************

	inline bool CExtraInfo::IsCreated()

	Author:		Dharmesh Raithatha
	Created:	6/24/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the object has been created, false otherwise
	Purpose:	returns whether the object has been created or not

*********************************************************************************/

bool CExtraInfo::IsCreated() const
{
	return (m_pXMLTree != NULL);
}

/*********************************************************************************

	bool CExtraInfo::GetInfoItem(const TDVCHAR* pInfoItemName, CTDVString& sXML)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		pInfoItemName = the name of the item
	Outputs:	sXML = the value of the item
	Returns:	-
	Purpose:	It returns the XML tree of the node specified

*********************************************************************************/

bool CExtraInfo::GetInfoItem(const TDVCHAR* pInfoItemName, CTDVString& sXML)
{
	sXML.Empty();

	if (IsCreated())
	{
		CXMLTree* pInfoItem = GetFirstInfoItem();

		while (pInfoItem != NULL)
		{
			if (pInfoItem->GetName().CompareText(pInfoItemName))
			{
				pInfoItem->OutputXMLTree(sXML);
				return true;
			}

			pInfoItem = pInfoItem->GetNextSibling();
		}
	}

	return false;
}
