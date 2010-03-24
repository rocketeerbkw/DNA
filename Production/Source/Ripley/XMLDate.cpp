// XMLDate.cpp: implementation of the CXMLDate class.
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
#include "XMLDate.h"
#include "TDVDateTime.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CXMLDate::CXMLDate(CInputContext& inputContext)

	Author:		Oscar Gillespie
	Created:	03/03/2000
	Inputs:		inputContext - input context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	

*********************************************************************************/

CXMLDate::CXMLDate(CInputContext& inputContext) : CXMLObject(inputContext)
{
// no other construction code required here (he says)
}


/*********************************************************************************

	CXMLDate::~CXMLDate()

	Author:		Oscar Gillespie
	Created:	03/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated.
				We don't use any memory in CXMLDate yet so the destructor does
				sod all. The base class will zap the memory it used.

*********************************************************************************/


CXMLDate::~CXMLDate()
{

}

/*********************************************************************************

	CXMLDate::Initialise()

	Author:		Oscar Gillespie
	Created:	03/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Initialises the CXMLDate with the current date.
				With the true XMLObject tree we could put off calculating
				the date until it's extracted from the tree ;)

*********************************************************************************/

bool CXMLDate::Initialise()
{

	COleDateTime theTime = COleDateTime::GetCurrentTime();

	int iDayOfWeek = theTime.GetDayOfWeek();
	int iDay = theTime.GetDay();
	int iMonth = theTime.GetMonth();
	int iYear = theTime.GetYear();

	CTDVString sDayOfWeek = NULL;

	switch (iDayOfWeek)
	{
		case 1 :
			sDayOfWeek = "Sunday";
			break;
	case 2 : 
			sDayOfWeek = "Monday";
			break;
	case 3 :	
			sDayOfWeek = "Tuesday";
			break;
	case 4 : 
			sDayOfWeek = "Wednesday";
			break;
	case 5 :	
			sDayOfWeek = "Thursday";
			break;
	case 6 : 
			sDayOfWeek = "Friday";
			break;
	case 7 :
			sDayOfWeek = "Saturday";
			break;
	default : sDayOfWeek = "ImaginaryCrazyErrorDay";
	}


	CTDVString xmlText = "<DATE>";
	
	xmlText += "<DAYOFWEEK>";
	xmlText += sDayOfWeek;
	xmlText += "</DAYOFWEEK>";

	xmlText += "<DAY>";
	xmlText += CTDVString(iDay);
	xmlText += "</DAY>";

	xmlText += "<MONTH>";
	xmlText += CTDVString(iMonth);
	xmlText += "</MONTH>";

	xmlText += "<YEAR>";
	xmlText += CTDVString(iYear);
	xmlText += "</YEAR>";

	xmlText += "</DATE>";
	
// to generate an XMLDate of the form
//
//     <DATE>
//       <DAYOFWEEK>Thursday</DAYOFWEEK>
//       <DAY>3</DAY>
//       <MONTH>2</MONTH>
//       <YEAR>2000</YEAR>
//     </DATE>

	return CXMLObject::CreateFromXMLText(xmlText);
}