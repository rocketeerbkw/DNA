// MonthSummaryPageBuilder.h: interface for the CMonthSummaryPageBuilder class.
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


#if !defined(AFX_MONTHSUMMARYPAGEBUILDER_H__B22CDD0F_460E_11D5_8765_00A024998768__INCLUDED_)
#define AFX_MONTHSUMMARYPAGEBUILDER_H__B22CDD0F_460E_11D5_8765_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CGuideEntry;
/**

  Produces the MonthSummary page on H2G2
*/

class CMonthSummaryPageBuilder : public CXMLBuilder 
{
public:

	/**	Author:		Dharmesh Raithatha\n
	*	Created:	11/05/2001\n
	*	Inputs:		inputContext - input context object.\n
	*				but will normally be supplied unless no database access is required\n
	*	Outputs:	-\n
	*	Returns:	-\n	
	*	Purpose:	Constructs the minimal requirements for a CMonthSummaryPageBuilder object.\n
	*/
	CMonthSummaryPageBuilder(CInputContext& inputContext);

	/**
	*	Author:		Dharmesh Raithatha\n
	*	Created:	11/05/2001\n
	*	Inputs:		-\n
	*	Outputs:	-\n
	*	Returns:	-\n
	*	Purpose:	Release any resources this object is responsible for.\n
	*/

	virtual ~CMonthSummaryPageBuilder();

	/**	Author:		Dharmesh Raithatha\n
	*	Created:	11/05/2001\n
	*	Inputs:		-\n
	*	Outputs:	-\n
	*	Returns:	Pointer to a CWholePage containing the entire XML for this page\n
	*	Purpose:	Constructs the XML to build the page that provides a summary of the entries\n
	*				for the month, NULL if unsuccessfull\n
	*/
	virtual bool Build(CWholePage* pPage);

protected:

	/**
	*	Author:		Dharmesh Raithatha\n
	*	Created:	15/5/01\n
	*	Inputs:		\n
	*	Outputs:	\n
	*	Returns:	True if a tree was successfully built, false otherwise\n
	*	Purpose		Constructs the XMl Tree to represent the body of a guide entry that \n
	*				contains the summary of the months guide entries\n
	*/
	//virtual bool BuildMonthSummaryXMLFromDB(CTDVString* pBodyText,CGuideEntry* pGuideEntry);


};

#endif // !defined(AFX_MONTHSUMMARYPAGEBUILDER_H__B22CDD0F_460E_11D5_8765_00A024998768__INCLUDED_)
