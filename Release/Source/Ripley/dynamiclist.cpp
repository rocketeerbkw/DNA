#include "stdafx.h"
#include "dynamiclist.h"
#include "tdvassert.h"
#include "xmltree.h"

CDynamicList::CDynamicList(CInputContext& inputContext, int listid, const TDVCHAR * listname, const TDVCHAR * listtype)
	: CXMLObject(inputContext), ListID(listid), ListName(listname), ListType(listtype)
{
	
}

CDynamicList::~CDynamicList()
{

}

/*********************************************************************************

	bool CDynamicList::MakeXML()

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		-
        Outputs:	<list><item-list><item/>....<item/></item-list></list>
        Returns:	-
        Purpose:	Makes xml for list. XMLObject is cleared and re-populated
					Note that extrainfo and dates are treated seprately.
					Dates fields are expected to be accompanied by XML in the form <DATE-....>.
					Note that this might not be necessary as SP.GetField() is designed to cope with dates.
					It doesnt recognise SQL_TIMESTAMP types though and returns "" rather tham "yyyy-mm-dd hh:mm:ss"

*********************************************************************************/

bool CDynamicList::MakeXML()
{
	// First check cache...
	CTDVDateTime dt24hrsago((COleDateTime::GetCurrentTime() - COleDateTimeSpan(1,0,0,0)));
	CTDVString sCacheXML;
	CTDVString CacheName = ListName + ".txt";

	if(CacheGetItem("dynamiclists", CacheName, &dt24hrsago, &sCacheXML))
	{
		if(!CreateFromXMLText(sCacheXML))
		{
			TDVASSERT(false, "CDynamicList::MakeXML() CreateFromXMLText failed");
			return false;
		}

		return true;
	}

	// Create xml envelope
	CTDVString listxml;
	listxml << "<LIST LISTID='" << ListID << "' LISTNAME='" << ListName << "' LISTTYPE='" << ListType << "'><ITEM-LIST></ITEM-LIST></LIST>";
	if(!CreateFromXMLText(listxml))
	{
		TDVASSERT(false, "CDynamicList::MakeXML CreateFromXMLText failed");
		return false;
	}

	// Get xml schema for list
	CStoredProcedure SPXml;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SPXml))
	{
		TDVASSERT(false, "CDynamicList::MakeXML m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if(!SPXml.GetDynamicListXML(ListName))
	{
		TDVASSERT(false, "CDynamicList::MakeXML SPXml.GetDynamicListXML failed");
		return false;
	}

	CTDVString sListXML;
	if(!SPXml.GetField("xml", sListXML))
	{
		TDVASSERT(false, "CDynamicList::MakeXML SPXml.GetField failed");
		return false;
	}

	if(!SPXml.Release())
	{
		TDVASSERT(false, "CDynamicList::MakeXML() SP.Release() failed");
		return false;	// Don't risk to continue under these conditions
	}

	// Now get data
	CStoredProcedure SPData;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SPData))
	{
		TDVASSERT(false, "CDynamicList::MakeXML m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if(!SPData.GetDynamicListData(ListName))
	{
		TDVASSERT(false, "CDynamicList::MakeXML SPData.GetDynamicListData failed");
		return false;
	}

	// Build xml for each record item
	while(!SPData.IsEOF())
	{
		// Load xml into tree
		CXMLTree *pTree = CXMLTree::Parse(sListXML);
		if(pTree == NULL)
		{
			TDVASSERT(false, "CDynamicList::MakeXML() CXMLTree::Parse failed");
			return false;
		}
		
		CAutoDelTreePtr adt(pTree);	// Make sure tree gets released if we exit prematurley

		// Traverse the tree, filling up text nodes and attributes
		// with field values
		CXMLTree *t = pTree->FindNext(); 
		while((t = t->FindNext()) != NULL)
		{
			CXMLTree::e_nodetype nt = t->GetNodeType();
			
			if(nt == CXMLTree::T_ATTRIBUTE)
			{
				CXMLAttribute *pa = (CXMLAttribute*)t;
				CTDVString field = pa->GetValue();
				if(SPData.FieldExists(field))
				{
					CTDVString sValue;
					if(SPData.GetField(field, sValue))
					{
						pa->SetValue(sValue);
					}
				}
			}
			else if(nt == CXMLTree::T_TEXT)
			{
				//CXMLTextNode *pt = dynamic_cast<CXMLTextNode*>(t);
				CXMLTextNode *pt = (CXMLTextNode*)t;

				CTDVString field = pt->GetText();
				if(SPData.FieldExists(field))
				{
					// Special handling for DATE
					CTDVString sValue; 

					// Special handling for dates (All tags that start with <DATE- are treated as dates.
					if(pt->GetParent() && pt->GetParent()->GetName().Left(5) == "DATE-")
					{
						// Get date, as XML string
						CTDVDateTime dt = SPData.GetDateField(field);
						if(!dt.GetAsXML(sValue))
						{
							TDVASSERT(false, "CDynamicList::MakeXML() dt.GetAsXML failed");
							// Value will be blank
						}
					}
					// Special handling for extra info (no escape text)
					else if(pt->GetParent()
						&& pt->GetParent()->GetName() == "EXTRAINFO")
					{
						// Get field value. Let DBO classes to conversion to string
						if(!SPData.GetField(field, sValue))
						{
							TDVASSERT(false, "CDynamicList::MakeXML() SPData.GetField failed");
							// Value will be blank
						}
					}
					else
					{
						// Get field value. Let DBO classes to conversion to string
						if(!SPData.GetField(field, sValue))
						{
							TDVASSERT(false, "CDynamicList::MakeXML() SPData.GetField failed");
							// Value will be blank
						}
						else
						{
							EscapeXMLText(&sValue);
						}
					}

					// Replace field name in xml by value
					if(!pt->SetText(sValue))
					{
						TDVASSERT(false, "CDynamicList::MakeXML() pt->SetText() failed");
						return false;
					}
				}
			}
		}

		// Add Item to our xml
		CXMLTree *pItemListTree = m_pTree->FindFirstTagName("ITEM-LIST");
		if(!pItemListTree)
		{
			TDVASSERT(false, "CDynamicList::MakeXML() m_pTree->FindFirstTagName failed");
			return false;
		}
		pItemListTree->AddChild(adt.Detach());

		// Next Item
		SPData.MoveNext();
	}

	// Save cache
	CTDVString sXML;
	if(!GetAsString(sXML))
	{
		TDVASSERT(false, "CDynamicList::MakeXML() GetAsString() failed");
		return false;
	}

	if(!CachePutItem("dynamiclists", CacheName, sXML))
	{
		TDVASSERT(false, "CDynamicList::MakeXML() CachePutItem failed");
		//return false;
	}
	
	return true;
}