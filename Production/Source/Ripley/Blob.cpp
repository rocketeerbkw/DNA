// Blob.cpp: implementation of the CBlob class.
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

#include "Blob.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CPageBody::CPageBody(CInputContext& inputContext)

	Author:		Oscar Gillespie
	Created:	13/03/2000
	Inputs:		inputContext - input context
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	constructor just does base class construction...
				anything that could blow up potentially is in Initialise()

*********************************************************************************/

CBlob::CBlob(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

/*********************************************************************************

	CPageBody::~CPageBody()

	Author:		Oscar Gillespie
	Created:	13/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated.
				We don't use any memory in CBlob yet so the destructor does
				sod all.

*********************************************************************************/

CBlob::~CBlob()
{

}


/*********************************************************************************

	CBlob::ShowBinary(int iBlobID, const TDVCHAR* BGColour)

	Author:		Oscar Gillespie
	Created:	13/03/2000
	Inputs:		iBlobID - the ID number of the blob we're using
				BGColour - the background colour of the blob
	Outputs:	-
	Returns:	boolean success of building and returning the binary information context
	Purpose:	pull the blob out of the database and store it in a cool XML format
				setting the MIME header to be the right kind of file first and
				setting the url for the binary file appropriately

*********************************************************************************/

bool CBlob::Initialise(int iBlobID, const TDVCHAR* BGColour)
{
	TDVASSERT( iBlobID > 0, "BlobID should be a positive number (CBlobInitialise)");

	CTDVString xmlText;
	CTDVString sCacheName = "B";
	sCacheName << iBlobID << "-" << BGColour << ".xml";
	
	CTDVDateTime dDate;	// will default to last century so cache is always valid
	if (CacheGetItem("blobs",sCacheName, &dDate, &xmlText))
	{
		return CreateFromXMLText(xmlText);
	}

	// create a stored procedure to access the database
	CStoredProcedure SP;
	bool bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (bSuccess)
	{
		// try to get the XML giving a path to the binary file from the SP
		bSuccess = SP.FetchBlobServerPath(iBlobID, BGColour, xmlText);
		SP.Release();
	}
	

	if (bSuccess)
	{
		CachePutItem("blobs", sCacheName, xmlText);
		// if it worked then munge it into some xmlText and return the success of that
		return CXMLObject::CreateFromXMLText(xmlText);
	}	
	else
	{
		// if it didn't work create an XML block containing some error XML
		return CXMLObject::CreateFromXMLText("<REDIRECT-TO>notfound.gif</REDIRECT-TO>");
	}
}

/*********************************************************************************

	bool CBlob::Initialise(const TDVCHAR* pBlobName, const TDVCHAR* BGColour)

	Author:		Oscar Gillespie
	Created:	30/08/2000
	Inputs:		pBlobName - the name of the blob we're using
				BGColour - the background colour of the blob
	Outputs:	-
	Returns:	boolean success of building and returning the binary information context
	Purpose:	pull the blob out of the database and store it in a cool XML format
				setting the MIME header to be the right kind of file first and
				setting the url for the binary file appropriately.
				The important difference between this method and the one above
				is that we're using a key blob system so there is some fun keyblob table
				faffing going one.

*********************************************************************************/

bool CBlob::Initialise(const TDVCHAR* pBlobName, const TDVCHAR* BGColour)
{
	TDVASSERT( pBlobName != NULL , "the named blob really ought to have a name");

	// create a stored procedure to access the database
	CStoredProcedure SP;
	bool bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString xmlText;
	if (bSuccess)
	{
		// try to get the XML giving a path to the binary file from the SP
		bSuccess = SP.FetchKeyBlobServerPath(pBlobName, BGColour, xmlText);
	}
	
	SP.Release();

	if (bSuccess)
	{
		// if it worked then munge it into some xmlText and return the success of that
		return CXMLObject::CreateFromXMLText(xmlText);
	}	
	else
	{
		// if it didn't work create an XML block containing some error XML
		return CXMLObject::CreateFromXMLText("<REDIRECT-TO>notfound.gif</REDIRECT-TO>");
	}
}
