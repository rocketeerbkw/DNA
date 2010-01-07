// TestArticleXML.cpp: implementation of the CTestArticleXML class.
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
#include "TestArticleXML.h"
#include "TDVAssert.h"
#include "InputContext.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CTestArticleXML::CTestArticleXML(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	22/02/2000
	Inputs:		inputContext - input context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class with all data members
				correctly initialised. Note that any initialisation that
				could possibly fail is put in a seperate initialise method.

*********************************************************************************/

CTestArticleXML::CTestArticleXML(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
// no other construction code required here
}

/*********************************************************************************

	CTestArticleXML::~CTestArticleXML()

	Author:		Kim Harries
	Created:	22/02/2000
	Modified:	29/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class ONLY are correctly released. e.g. memory is deallocated.

*********************************************************************************/

CTestArticleXML::~CTestArticleXML()
{
	// tree is destroyed by base class
	// no further destruction required for this class
}

/*********************************************************************************

	CTestArticleXML::Initialise(int h2g2ID)

	Author:		Kim Harries
	Created:	23/02/2000
	Modified:	24/02/2000
	Inputs:		h2g2ID - the ID of the article from which to initialise this object
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds an internal representation of the XML associated with a
				particular article by querying the database or accessing cache as
				appropriate.

*********************************************************************************/

bool CTestArticleXML::Initialise(int ih2g2ID)
{
	TDVASSERT(ih2g2ID > 0, "Negative h2g2ID in CTestArticleXML::Initialise(...)");
	TDVASSERT(this->IsEmpty(), "CTestArticleXML::Initialise(...) called on non-empty XML object");

	CTDVString xmlText;				// string to store the xml text returned by the stored procedure
	CStoredProcedure StoredProcedure;	// pointer to a stored procedure

	// get a stored procedure object via the database context
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&StoredProcedure))
	{
		// fail if stored procedure object can't be created
		return false;
	}
	else
	{
		// now use stored procedure object to fetch the relevent XML for the article ID
		bool bSuccess = StoredProcedure.FetchTextOfArticle(ih2g2ID, xmlText);
		// stored procedure can be deleted now regardless of success or failure
		StoredProcedure.Release();
		if (bSuccess)
		{
			// if text fetched successfully attempt to create the current objects
			// tree from this and return its success or failure
			bSuccess = CreateFromXMLText(xmlText);
		}
		// false returned if couldn't get text for some reason, or if couldn't
		// create xml text for some reason
		return bSuccess;
	}
}
