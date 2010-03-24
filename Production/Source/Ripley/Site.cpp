#include "stdafx.h"
#include "Site.h"


/*********************************************************************************
CSite::CSite()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CSite::CSite()
{
}


/*********************************************************************************
CSite::~CSite()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CSite::~CSite()
{
}


/*********************************************************************************
void CSite::Clear()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	-
Purpose:	Clears or zeros all internal variables
*********************************************************************************/

void CSite::Clear()
{
	m_iId = 0;
	m_sName.Empty();
}


/*********************************************************************************
CTDVString CSite::GetAsXML()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	true on success
Purpose:	Builds the entire XML structure for this object
			Name is repeated twice as <NAME> <SHORTNAME> due to legacy skin support.
			
*********************************************************************************/

CTDVString CSite::GetAsXML()
{
	CTDVString sXML;
	sXML << "<SITE ID ='" << m_iId << "'>";
	sXML << "<ID>" << m_iId << "</ID>";
	sXML << "<NAME>" << m_sName << "</NAME>";
	sXML << "<SHORTNAME>" << m_sName << "</SHORTNAME>";
	if ( !m_sUrlName.IsEmpty())
	{
		sXML << "<URLNAME>" << m_sUrlName << "</URLNAME>";
	}
	if ( !m_sDescription.IsEmpty() )
		sXML << "<DESCRIPTION>" << m_sDescription << "</DESCRIPTION>";
	if ( m_iModerationClass > 0 )
		sXML << "<CLASSID>" << m_iModerationClass << "</CLASSID>";
	sXML << "</SITE>";
	return sXML;
}
