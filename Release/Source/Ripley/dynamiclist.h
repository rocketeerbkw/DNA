#pragma once

#include "xmlobject.h"
#include "tdvstring.h"

// Executes dynamic list stored procedure and generates xml
// jamesp - 19 jul 1905
class CDynamicList : public CXMLObject
{
private:
	
	// List attributes
	CTDVString ListName, ListType;
	int ListID;

	// Automatically delete CXMLTree pointer
	class CAutoDelTreePtr
	{
		public:
			CAutoDelTreePtr(CXMLTree * pTree) : m_pTree(pTree) {};
			~CAutoDelTreePtr() { delete m_pTree; }
			CXMLTree * Detach() {CXMLTree * p = m_pTree; m_pTree = NULL; return p;}
		private:
			CXMLTree * m_pTree;
	};

public:
	CDynamicList(CInputContext& inputContext, int listid, const TDVCHAR * listname, const TDVCHAR * listtype);
	~CDynamicList();

	// Generates xml for this object
	bool MakeXML();
};
