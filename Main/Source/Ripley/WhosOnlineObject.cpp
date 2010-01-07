// WhosOnlineObject.cpp: implementation of the CWhosOnlineObject class.
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
#include "WhosOnlineObject.h"
#include "tdvassert.h"
#include "TDVDateTime.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CWhosOnlineObject::CWhosOnlineObject(CInputContext& inputContext)

	Author:		Oscar Gillespie
	Created:	08/03/2000
	Inputs:		inputContext - input context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class. Note that any initialisation that
				could possibly fail is put in a seperate initialise method.

*********************************************************************************/

CWhosOnlineObject::CWhosOnlineObject(CInputContext& inputContext) : CXMLObject(inputContext)
{
// no other construction code required here (he says)
}

/*********************************************************************************

	CWhosOnlineObject::~CWhosOnlineObject()

	Author:		Oscar Gillespie
	Created:	08/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated.
				We don't use any memory in CWhosOnlineObject yet so the destructor does
				sod all. The base class will zap the memory it used.

*********************************************************************************/

CWhosOnlineObject::~CWhosOnlineObject()
{

}

/*********************************************************************************

	CWhosOnlineObject::Initialise(const TDVCHAR* pOrderBy)

	Author:		Oscar Gillespie
	Created:	08/03/2000
	Modified:	02/10/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Builds an internal representation some XML to display a list of the users that
				are currently online (active on h2g2)

*********************************************************************************/

bool CWhosOnlineObject::Initialise(const TDVCHAR* pOrderBy, int iSiteID, bool bCurrentSiteOnly, bool bFetchFromCache)
{
	// string holding the XML for the page showing the list of online users
	CTDVString sXMLText;
	CTDVString sOrderBy = pOrderBy;

	// check for a valid ordering method, otherwise specify 'none'
	sOrderBy.MakeLower();
	if (!sOrderBy.CompareText("id") &&
		!sOrderBy.CompareText("name"))
	{
		sOrderBy = "none";
	}
	
	CTDVString cachename;
	if ( bCurrentSiteOnly )
	{
		//Cache - users specific to current site
		cachename << "online-" << iSiteID << ".txt";
	}
	else
	{
		//All users.
		cachename << "online.txt";
	}

	
	CTDVDateTime dLastDate;
	if (bFetchFromCache)
	{
		dLastDate = CTDVDateTime(60*20);
	}
	else
	{
		dLastDate = CTDVDateTime(60*5);	// cache for five minutes
	}

	if (CacheGetItem("onlineusers",cachename, &dLastDate, &sXMLText))
	{
		if (CreateFromCacheText(sXMLText))
		{
			SetAttribute("ONLINEUSERS","ORDER-BY", sOrderBy);
			UpdateRelativeDates();
			return true;
		}
	}

	CTDVString sSiteSpecific;
	if ( bCurrentSiteOnly )
	{
		//Indicate - recently logged users for this site only.
		sSiteSpecific << " THISSITE='1' ";
	}
	sXMLText << "<ONLINEUSERS " << sSiteSpecific << "ORDER-BY='" << sOrderBy << "'>";

	// create a stored procedure to access the database
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// string to hold the XML for the actual list of users... passed into the stored procedure
	CTDVString sUsers = "";

	// attempt to query the database through the stored procedure
	// asking for a block listing all the online users in a valid XML format
	bool bOk = SP.FetchCurrentUsers(sUsers, iSiteID, bCurrentSiteOnly );

	SP.Release();

	if (bOk) 
	{
		// if it worked then put the users XML in the page XML
		sXMLText << sUsers;
	}
	else
	{
		// otherwise tell the user that nobody is online
		sXMLText << "<WEIRD>Nobody is online! Nobody! Not even you!</WEIRD>";
	}

	sXMLText << "</ONLINEUSERS>";

	bool bSuccess = CreateFromXMLText(sXMLText);

	//If have results and XML created then cache.
	if (bOk && bSuccess)
	{
		CTDVString StringToCache;
		CreateCacheText(&StringToCache);
		CachePutItem("onlineusers", cachename, StringToCache);
	}
	
	return bSuccess;

}
