// EditorsPick.cpp: implementation of the CVote class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "EditorsPick.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"
#include "MultiStep.h"
#include "link.h"
#include "User.h"

#include <set>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CEditorsPick::CEditorsPick(CInputContext& inputContext): CXMLObject(inputContext)
{
}


CEditorsPick::~CEditorsPick(void)
{
}

/*********************************************************************************

	bool CTopic::Initialise 

		Author:		Martin R
        Created:	17/01/2005
        Inputs:		- CDBXMLBuilder& XML
        Outputs:	-
        Returns:	-
        Purpose:	- Create  Editors Pick XML 
					- Fetches Items tagged to user ( clippings )
					- Fetches items already tagged/ clipped to TextBox.
*********************************************************************************/
bool CEditorsPick::Initialise(int iTextBoxID)
{
	CTDVString sXML;
	CStoredProcedure SP;
	InitialiseXMLBuilder(&sXML,&SP);

	//CMultiStep Multi(m_InputContext,"TEXTANDIMAGE");
	//Multi.AddRequiredParam("title","");
	//Multi.AddRequiredParam("text","");

	// Process the inputs to make sure we've got all the info we require
	//Multi.ProcessInput();

	//CTDVString sMultiXML;
	//Multi.GetAsXML(sMultiXML);
	//sXML << sMultiXML;

	OpenXMLTag("LINKS");

	//keep a record of existing links.
	std::set< std::pair<int,CTDVString> > existinglinks;

	//Get existing Links for element
	if ( iTextBoxID )
	{
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		SP.GetFrontPageElementLinks(iTextBoxID,true);

		//Create XML.
		CTDVString sXML;
		while( !SP.IsEOF() )
		{
			OpenXMLTag("LINK",true);

			CTDVString sType;
			SP.GetField("DestinationType",sType);
			AddXMLAttribute("Type",sType);
			
			AddXMLIntAttribute("SELECTED",1,true);
			AddDBXMLIntTag("LINKID","LinkID");
			AddDBXMLTag("Title","Title");
			AddDBXMLDateTag("DATELINKED","DateLinked",false);

			int iDestinationID = SP.GetIntField("DestinationID");
			AddXMLIntTag("DestinationID",iDestinationID);

			CloseXMLTag("LINK");
	
			existinglinks.insert( std::make_pair(iDestinationID,sType) );
			SP.MoveNext();
		}
	}

	//Get Clippings.
	if ( m_InputContext.GetCurrentUser() )
	{
		SP.GetUserLinks(m_InputContext.GetCurrentUser()->GetUserID(), "", true);

		while ( !SP.IsEOF() )
		{
			//Add Link if not already tagged to text box.
			int iDestinationID = SP.GetIntField("DESTINATIONID");
			CTDVString sType;
			SP.GetField("DestinationType", sType);
			std::set< std::pair<int,CTDVString> >::iterator iter_found = existinglinks.find(std::make_pair(iDestinationID,sType) );
			if ( iter_found == existinglinks.end() )
			{
				OpenXMLTag("LINK",true);
				AddXMLAttribute("Type",sType,true);

				AddDBXMLIntTag("LINKID","LinkID");
				AddXMLIntTag("DESTINATIONID",iDestinationID);
				AddDBXMLTag("Title","Title");
				AddDBXMLDateTag("DATELINKED","DateLinked");

				CloseXMLTag("LINK");
			}
			SP.MoveNext();
		}
	}

	CloseXMLTag("LINKS");
	
	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool CTopic::Process 

		Author:		Martin R
        Created:	19/01/2005
        Inputs:		- ID of Element to process.
        Outputs:	-	None.
        Returns:	-	False on error
        Purpose:	-	Setup links from the Input Context to the provided Element ID.
						Create a list of selected links.
						Delete existing links that are unselected.
						Copy/tag any remaining selected links to the TextBoxID.
*********************************************************************************/
bool CEditorsPick::Process(int iTextBoxID)
{
	bool bResult = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	//Assimilate the selected links.
	int ilinks = m_InputContext.GetParamCount("LinkID");
	std::set<int> linkstoprocess;
	for ( int i = 0; i < ilinks; ++i )
	{
		int iLinkID = m_InputContext.GetParamInt("LinkID",i);
		linkstoprocess.insert(iLinkID);
	}


	if ( !m_InputContext.GetCurrentUser() )
	{
		return false;
	}

	//Delete Existing Links that are no longer selected.
	int iUserID = m_InputContext.GetCurrentUser()->GetUserID();
	int iSiteID = m_InputContext.GetSiteID();
	CStoredProcedure SPExisting;
	m_InputContext.InitialiseStoredProcedureObject(SPExisting);
	SPExisting.GetFrontPageElementLinks(iTextBoxID,true);
	while ( !SPExisting.IsEOF() )
	{
		int iLinkID = SPExisting.GetIntField("LINKID");
		std::set<int>::iterator iter = linkstoprocess.find(iLinkID);
		if ( iter != linkstoprocess.end() )
		{
			//existing link is still selected - no action necessary.
			linkstoprocess.erase(iter);
		}
		else
		{
			//Delete unseleced link.
			bResult = bResult && SP.DeleteLink(iLinkID,iUserID,iSiteID,bResult);
		}
		SPExisting.MoveNext();
	}

	//Copy newly selected links to textbox.
	for ( std::set<int>::iterator iter = linkstoprocess.begin(); iter != linkstoprocess.end(); ++iter )
	{
		//bResult = bResult && SP.CopySingleLinkToObject( *iter, iTextBoxID );
	}

	return bResult;
}
