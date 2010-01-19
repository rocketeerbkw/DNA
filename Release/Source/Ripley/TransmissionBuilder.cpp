// TransmissionBuilder.cpp: implementation of the CTransmissionBuilder class.
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
#include "TransmissionBuilder.h"
#include "PageBody.h"
#include "tdvassert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CTransmissionBuilder::CTransmissionBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for transmit.cgi mimic class

*********************************************************************************/

CTransmissionBuilder::CTransmissionBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

/*********************************************************************************

	CTransmissionBuilder::~CTransmissionBuilder()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CTransmissionBuilder class. Functionality due when we start allocating memory

*********************************************************************************/

CTransmissionBuilder::~CTransmissionBuilder()
{

}

/*********************************************************************************

	CXMLObject* CTransmissionBuilder::Build()

	Author:		Oscar Gillespie
	Created:	17/03/2000
	Modified:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes an transmission page (for sending Flash style stuff to the user)

*********************************************************************************/

bool CTransmissionBuilder::Build(CWholePage* pPageXML)
{
	// XML object subclasses representing various parts of the front page
	CPageBody  BodyXML(m_InputContext);

	// boolean that tracks success of operations through the work we do in Build()
	bool bSuccess = false;

	// first create the page root into which to insert the article
	bSuccess = InitPage(pPageXML, "TRANSMIT",false);
	TDVASSERT(bSuccess, "Failed to initialise PageXML");

	// A string to hold the entry (URL of a .swf file)
	CTDVString sEntryUrl = "";

	if (bSuccess)
	{
		// find out which letter they want to look at in the index (from the url)
		bool bSuccess = m_InputContext.GetParamString("entry", sEntryUrl);
	}
	if (bSuccess)
	{
		// legacy problem that needs to be fixed if present
		sEntryUrl.Replace("http//", "http://"); 

		// find the location of the farthest right slash in the url
		int iLastSlash = sEntryUrl.ReverseFind('/');
		// get the actual filename (everything after the last slash)
		CTDVString sDoodah = sEntryUrl.Mid(iLastSlash + 1);
		// chop off the ".swf" suffix
		sDoodah = sDoodah.TruncateRight(4);

		// a string to build up XML to put into the page
		CTDVString sTransmitXML;

		// build up the XML
		sTransmitXML << "<FLASHITEM>";
		sTransmitXML << "<NAME>" << sDoodah << "</NAME>";
		sTransmitXML << "<URL>" << sEntryUrl << "</URL>";
		sTransmitXML << "</FLASHITEM>";

		// pBodyXML is a CPageBody object... a kind of simple GuideEntry
		// it isn't really an article so it doesn't have an article subject
		// xml needs the GUIDE and BODY tags round it
		sTransmitXML = "<GUIDE><BODY>" + sTransmitXML + "</BODY></GUIDE>";
		bSuccess = BodyXML.CreatePageFromXMLText("", sTransmitXML);
		TDVASSERT(bSuccess, "Failed to initialise body with xmlfrontpage");
	}
	if (bSuccess)
	{
		// add the article xml inside the H2G2 tag
		bSuccess = pPageXML->AddInside("H2G2", &BodyXML);
		TDVASSERT(bSuccess, "Failed to AddInside pBody");
	}

	return bSuccess;

}