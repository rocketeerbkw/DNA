// User.cpp: implementation of the CUser class.
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
#include "TDVAssert.h"
#include "User.h"
#include "StoredProcedure.h"
#include "GuideEntry.h"
#include "ProfileConnection.h"
#include "profileapi\profileapi\include\ProfileApi.h"
#include "user.h"
#include "SiteOptions.h"
#include "UserStatuses.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CUser::CUser(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	15/03/2000
	Inputs:		inputContext - input context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class with all data members
				correctly initialised. For this base class there is no
				meaningful initialisation method, so this is left to be
				implemented by subclasses.

*********************************************************************************/

CUser::CUser(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_ObjectStatus(NO_USER_DATA),
	m_VisibilityStatus(ID_NAME_VISIBLE),
	m_bDataModified(false),
	m_bGroupsModified(false),
	m_pStoredProcedure(NULL),
	m_UserID(0),
	m_LoginName(NULL),
	m_Username(NULL),
	m_FirstNames(NULL),
	m_LastName(NULL),
	m_Email(NULL),
	m_Cookie(NULL),
	m_BBCUID(NULL),
	m_Password(NULL),
/* Don't know how best to initialise these ???
	m_DateJoined(NULL),
	m_DateReleased(NULL),
	m_LastUpdated(NULL),
*/
	m_Masthead(0),
	m_SinBin(0),
	m_Status(0),
	m_Journal(0),
	m_Latitude(0.0),
	m_Longitude(0.0),
	m_Active(false),
	m_Anonymous(false),
	m_PrivateForum(0),
	m_PrefSkin("Alabaster"),
	m_PrefUserMode(0),
	m_PrefForumStyle(0),
	m_PrefForumThreadStyle(0),
	m_PrefForumShowMaxPosts(0),
	m_PrefReceiveWeeklyMailshot(true),
	m_PrefReceiveDailyUpdates(false),
	m_PrefStatus(0),
	m_SiteID(1),
	m_AgreedTerms(false),
	m_LoggedIn(false),
	m_SignedIn(false),
	m_bCreateNewUser(false),
	m_TaxonomyNode(0),
	m_TeamID(0),
	m_bIsModClassMember(false),
	m_HideLocation(0),
	m_HideUserName(0),
	m_bIsAutoSinBin(false),
	m_bIsEditorOnAnySite(false),
	m_bIsSynchronised(false),
	m_bFailIfUserHasNoMasthead(true),
	m_bAcceptSubscriptions(false),
	m_bInBannedEmailList(false),
	m_bBannedFromComplaints(false),
	m_bPromptUserName(false),
	m_syncByDefault(false),
	m_IsSecure(false)
{
	// no other construction
	InitializeCriticalSection(&m_criticalsection);
}

CArray<CTDVString,CTDVString&> CUser::m_sBannedCookies;

/*********************************************************************************

	CUser::~CUser()

	Author:		Kim Harries
	Created:	29/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated. It is
				virtual in order to ensure correct deallocation for subclasses,
				which should do their own release of resources.

*********************************************************************************/

CUser::~CUser()
{
	// need to release the stroed procedure member variable if it has been allocated
	delete m_pStoredProcedure;
	m_pStoredProcedure = NULL;

	// use assert to log a warning that may be forgetting to call UpdateDetails... ???
	TDVASSERT(!m_bDataModified && !m_bGroupsModified, "User object being destroyed when data modified flag still set");
}

/*********************************************************************************

	bool CUser::CreateFromID(int iUserID)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	02/05/2000
	Inputs:		iUserID - the unique ID for the user to be created.
				bCreateIfNotFound - set to true if you want to create the user if
									they are not found
	Outputs:	-
	Returns:	true if user exists, false if not (or any other error).
	Purpose:	Create a an XML object representing this users data. Whether the
				users data is got from the cache/database at the time of creation
				is hidden by use of an internal mechanism that records the current
				status of the object.

*********************************************************************************/
bool CUser::CreateFromIDInternal(int iUserID, bool bCreateIfNotFound /*false*/)
{
	TDVASSERT(iUserID > 0, "Non-positive UserID in CUser::CreateFromID(...)");

	//this should always be the current site
	SetSiteID(m_InputContext.GetSiteID());
	m_bCreateNewUser = bCreateIfNotFound;
	m_UserID = iUserID;
	SetStatusUserIDOnly();
//	return true;
	// fetch data now rather than delaying till later
	return FetchData();
}

/*********************************************************************************

	bool CUser::CreateFromSigninIDInternal(int iUserID)

	Author:		Mark Howitt
	Created:	29/02/2000
	Inputs:		pIdentityUserID - the unique Identity ID for the user to be created.
				bCreateIfNotFound - set to true if you want to create the user if
									they are not found
	Outputs:	-
	Returns:	true if user exists, false if not (or any other error).
	Purpose:	Creates the user from their signin userid.

*********************************************************************************/
bool CUser::CreateFromSigninIDInternal(const TDVCHAR *pIdentityUserID, bool bCreateIfNotFound /*false*/)
{
	TDVASSERT(pIdentityUserID != NULL, "Null Identity userid from CreateFromSigninIDInternal(...)");

	//this should always be the current site
	SetSiteID(m_InputContext.GetSiteID());
	m_bCreateNewUser = bCreateIfNotFound;

	// Get the DnaUserID from the signin userid
	m_UserID = 0;
	bool bOk = false;
	CStoredProcedure SP;
	if (m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// Check to see which signin system the site is using
		bool bIDFound = false;

		// Get the dna userid from the identity id
		bOk = SP.GetDNAUserIDFromIdentityUserID(pIdentityUserID, bIDFound);

		if (!bOk)
		{
			SetStatusNoData();
			return false;
		}
		else if (bIDFound)
		{
			// Set the user id to the dna userid
			m_UserID = SP.GetIntField("DNAUserID");
		}
	}
	else
	{
		// Failed to find the userid
		return false;
	}

	SetStatusUserIDOnly();

	// fetch data now rather than delaying till later
	return FetchData();
}

bool CUser::CreateFromSigninIDAndInDatabase(const TDVCHAR *pIdentityUserID)
{
	return CreateFromSigninIDInternal(pIdentityUserID, true);
}

bool CUser::CreateFromID(int iUserID)
{
	return CreateFromIDInternal(iUserID, false);
}

bool CUser::CreateFromID(int iUserID, bool bFailIfNoMasthead)
{
	m_bFailIfUserHasNoMasthead = bFailIfNoMasthead;
	return CreateFromIDInternal(iUserID, false);
}

/*********************************************************************************

	bool CUser::CreateFromIDForSite(int iUserID, int iSiteID)

		Author:		Mark Howitt
        Created:	21/11/2005
        Inputs:		iUserID - The ID of the user you want to create the object for.
					iSiteID - The ID of the site you want to get the users details for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Same as CUser::CreateFromID(), but you can specify the site
					that the users details will be used.

*********************************************************************************/
bool CUser::CreateFromIDForSite(int iUserID, int iSiteID)
{
	TDVASSERT(iUserID > 0, "Non-positive UserID in CUser::CreateFromID(...)");

	// Set the site that we want to use
	SetSiteID(iSiteID);
	m_bCreateNewUser = false;
	m_UserID = iUserID;
	SetStatusUserIDOnly();

	// fetch data now rather than delaying till later
	return FetchData();
}

/*********************************************************************************

	bool CUser::CreateFromH2G2ID(int ih2g2ID)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Given a h2g2 id and a SiteID, go get the User details

*********************************************************************************/

bool CUser::CreateFromH2G2ID(int ih2g2ID, int iSiteID)
{
	TDVASSERT(ih2g2ID > 0, "Non-positive UserID in CUser::CreateFromID(...)");

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (SP.GetUserFromH2G2ID(ih2g2ID, iSiteID))
	{
		m_UserID = SP.GetIntField("UserID");
		SetStatusUserIDOnly();
		SetSiteID(iSiteID);
	//	return true;
		// fetch data now rather than delaying till later
		return FetchData();
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CUser::CreateFromCookie(const TDVCHAR* pCookie)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	02/05/2000
	Inputs:		pCookie - the cookie for this user
	Outputs:	-
	Returns:	true if user exists, false if not (or any other error).
	Purpose:	Create a an XML object representing this users data. Whether the
				users data is got from the cache/database at the time of creation
				is hidden by use of an internal mechanism that records the current
				stauts of the object.

*********************************************************************************/
/*
bool CUser::CreateFromCookie(const TDVCHAR* pCookie)
{
	TDVASSERT(pCookie != NULL, "NULL cookie pointer in CUser::CreateFromCookie(...)");

	m_Cookie = pCookie;
	SetStatusCookieOnly();
//	return true;
	return FetchData();
}
*/
/*********************************************************************************

	bool CUser::CreateFromEmail(const TDVCHAR* pEmail)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	02/05/2000
	Inputs:		pEmail - the email address for this user
	Outputs:	-
	Returns:	true if user exists, false if not (or any other error).
	Purpose:	Create a an XML object representing this users data. Whether the
				users data is got from the cache/database at the time of creation
				is hidden by use of an internal mechanism that records the current
				stauts of the object.

*********************************************************************************/

bool CUser::CreateFromEmail(const TDVCHAR* pEmail)
{
	TDVASSERT(pEmail != NULL, "NULL email pointer in CUser::CreateFromEmail(...)");

	m_Email = pEmail;
	SetStatusEmailOnly();
//	return true;
	return FetchData();
}

/*********************************************************************************

	bool CUser::GetSignedInStatusAsString(CTDVString& sSigned)

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		-
	Outputs:	String generated
	Returns:	true is a string was generated
	Purpose:	returns the signed in status in the form
				<SSO>
					<SSOLOGINNAME>sdfsdf</SSOLOGINNAME>
				</SSO>

				if there is an error then it will be of the form

				<SSO>
					<SSOERROR>klkj</SSOERROR>
				</SSO>

*********************************************************************************/

bool CUser::GetSignedInStatusAsString(CTDVString& sSigned, bool bUseIdentity)
{
	if (!bUseIdentity)
	{
		sSigned = "<SSO>";
		if (IsUserSignedIn())
		{
			sSigned << "<SSOLOGINNAME>" << m_SsoUsername << "</SSOLOGINNAME>";
		}
		else if (!m_ProfileErrorMsg.IsEmpty())
		{
			sSigned << "<SSOERROR>" << m_ProfileErrorMsg << "</SSOERROR>";
		}
		else
		{
			sSigned << "<SSOERROR>Unidentified error</SSOERROR>";
		}
		sSigned << "</SSO>";
	}
	else
	{
		// New Bit!!! Add the Identity bits
		m_XMLBuilder.Initialise(&sSigned);
		m_XMLBuilder.OpenTag("IDENTITY");
		if (IsUserSignedIn())
		{
			m_InputContext.GetCookieByName("IDENTITY",m_IdentityCookie);
			m_XMLBuilder.OpenTag("COOKIE",true);
			CTDVString cookie = m_IdentityCookie;
			m_XMLBuilder.AddAttribute("PLAIN",cookie);
			CXMLObject::EscapeTextForURL(&cookie);
			m_XMLBuilder.AddAttribute("URLENCODED",cookie);
			m_XMLBuilder.CloseTag("COOKIE");
		}
		m_XMLBuilder.CloseTag("IDENTITY");
	}

	return true;
}

/*********************************************************************************

	bool CUser::GetAsString(CTDVString& sResult)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	09/05/2000
	Inputs:		-
	Outputs:	sResult - the string representation of the users XML
	Returns:	true if successful, false for failure.
	Purpose:	Converts the internal representation of the XML for this user into
				a text representation and puts it in sResult. May have to access
				cache or database but this is a hidden implemenation detail.

*********************************************************************************/

bool CUser::GetAsString(CTDVString& sResult)
{
	// should only ever be called on initialised objects
	TDVASSERT(!GotNoData(), "CUser::GetAsString(...) called on unitialised object");
	// need to convert internal representation into a xml string representation

	// check object has been initialised
	if (GotNoData())
	{
		// if unitialised return false for failure and leave sResult unchanged
		return false;
	}
	if (!GotCompleteData())
	{
		// if we haven't got all the data yet then get it now
		if (!FetchData())
		{
			return false;
		}
	}

	InitialiseXMLBuilder(&sResult);
	bool bOk = OpenXMLTag("USER");
	bOk = bOk && AddXMLIntTag("USERID",m_UserID);
	bOk = bOk && AddXMLTag("USERNAME",m_Username);
	//TODO:IL:I have not put POSTCODE into DoesTagExist as I can't figure out
	//why this class has DoesTagExist as the base class has the
	//generic implementation and it's not virtual as well. And also it does not 
	//seem to be used
	bOk = bOk && AddXMLTag("POSTCODE", m_Postcode);
	bOk = bOk && AddXMLTag("REGION", m_Region);
	bOk = bOk && AddXMLIntTag("USER-MODE",m_PrefUserMode);
	bOk = bOk && AddXMLIntTag("STATUS",m_Status);
	bOk = bOk && AddXMLTag("AREA",m_Area);
	bOk = bOk && AddXMLTag("TITLE",m_Title);
	bOk = bOk && AddXMLTag("FIRSTNAMES",m_FirstNames);
	bOk = bOk && AddXMLTag("LASTNAME",m_LastName);
	bOk = bOk && AddXMLTag("SITESUFFIX",m_sSiteSuffix);
	bOk = bOk && AddXMLIntTag("TEAMID", m_TeamID);
	bOk = bOk && AddXMLIntTag("UNREADPUBLICMESSAGECOUNT", m_UnreadPublicMessageCount);
	bOk = bOk && AddXMLIntTag("UNREADPRIVATEMESSAGECOUNT", m_UnreadPrivateMessageCount);
	if (m_TaxonomyNode > 0)
	{
		bOk = bOk && AddXMLIntTag("TAXONOMYNODE",m_TaxonomyNode);
	}
	bOk = bOk && AddXMLIntTag("HIDELOCATION", m_HideLocation);
	bOk = bOk && AddXMLIntTag("HIDEUSERNAME", m_HideUserName);

    // Premoderated / PostModerated etc.
    bOk = bOk && OpenXMLTag("MODERATIONSTATUS",true);
    bOk = bOk && AddXMLIntAttribute("ID",m_PrefStatus);
    bOk = bOk && AddXMLAttribute("NAME",CUserStatuses::GetDescription(m_PrefStatus) ,true);
    bOk = bOk && CloseXMLTag("MODERATIONSTATUS");
			
	sResult	<< "<GROUPS>";
	// iterate through the map of group names and for each one that we are
	// a member of put some XML in
	CTDVString	sGroupName;
	int			iIsMember = 0;
	map<CTDVString, int>::const_iterator it;
	for (it = m_Groups.	begin(); it != m_Groups.end(); it++)
	{
		sGroupName = it->first;
		iIsMember = it->second;
		if (iIsMember == 1)
		{
			// make sure group name is in upper case for XML output
			sGroupName.MakeUpper();
			// also escape all XML - just in case of crazy messed-up group names
			CXMLObject::EscapeAllXML(&sGroupName);
			sResult << "<" << sGroupName << "/>";
			sResult << "<GROUP><NAME>" << sGroupName << "</NAME></GROUP>";
		}
	}

	// Bodge!!! We nolonger user the Premod/Restricted Group for premoderated/restricted users. We instead use the PrefStatus value in the preferences table.
	//			As this would require a big change to the skins, we are simulating the group by checking the PrefStatus and adding the
	//			PREMODERATED group if it's set to 1.
	/*if (m_PrefStatus == 1)
	{
		sResult << "<PREMODERATED /><GROUP><NAME>PREMODERATED</NAME></GROUP>";
	}
	else if (m_PrefStatus == 4)
	{
		sResult << "<RESTRICTED /><GROUP><NAME>RESTRICTED</NAME></GROUP>";
	}*/

	sResult << "</GROUPS>";

	sResult << "<SITEPREFERENCES>" << m_PrefXML << "</SITEPREFERENCES>";

	// See if we need to prompt the user to change or set their username
	if (m_bPromptUserName)
	{
		sResult << "<PROMPTSETUSERNAME>1</PROMPTSETUSERNAME>";
	}

	if (m_VisibilityStatus != ID_NAME_VISIBLE)
	{
		CTDVString safe = m_Email;
		EscapeAllXML(&safe);
		sResult << "<EMAIL-ADDRESS>" << safe << "</EMAIL-ADDRESS>";
	}
	if (m_VisibilityStatus == EVERYTHING_VISIBLE)
	{
		CTDVString	sDateJoined = "";
		CTDVString	sDateReleased = "";

		if (m_DateJoined.GetYear() > 1900)
		{
			m_DateJoined.GetAsXML(sDateJoined, true);
		}
		if (m_DateReleased.GetYear() > 1900)
		{
			m_DateReleased.GetAsXML(sDateReleased, true);
		}
		// cookie and password dodgy ???
		CTDVString safePassword = m_Password;
		EscapeAllXML(&safePassword);
		CTDVString safeFirstNames = m_FirstNames;
		EscapeAllXML(&safeFirstNames);
		CTDVString safeLastName = m_LastName;
		EscapeAllXML(&safeLastName);
		sResult << "<LOGIN-NAME>" << m_LoginName << "</LOGIN-NAME>"
				<< "<BBCUID>" << m_BBCUID << "</BBCUID>"
				<< "<COOKIE>" << m_Cookie << "</COOKIE>"
				<< "<PASSWORD>" << safePassword << "</PASSWORD>"
				<< "<FIRST-NAMES>" << safeFirstNames << "</FIRST-NAMES>"
				<< "<LAST-NAME>" << safeLastName << "</LAST-NAME>"
				<< "<MASTHEAD>" << m_Masthead << "</MASTHEAD>"
				<< "<JOURNAL>" << m_Journal << "</JOURNAL>"
				<< "<PRIVATEFORUM>" << m_PrivateForum << "</PRIVATEFORUM>"
				<< "<DATE-JOINED>" << sDateJoined << "</DATE-JOINED>"
				<< "<DATE-RELEASED>" << sDateReleased << "</DATE-RELEASED>"
				<< "<POSTCODE>" << m_Postcode << "</POSTCODE>"
				<< "<REGION>" << m_Region << "</REGION>"
				<< "<ACTIVE>";
		if (m_Active)
		{
			sResult << "Yes";
		}
		else
		{
			sResult << "No";
		}
		sResult << "</ACTIVE>"
				<< "<STATUS>" << m_Status << "</STATUS>"
				<< "<ANONYMOUS>";
		if (m_Anonymous)
		{
			sResult << "Yes";
		}
		else
		{
			sResult << "No";
		}
		sResult << "</ANONYMOUS>"
				<< "<SIN-BIN>" << m_SinBin << "</SIN-BIN>"
				<< "<LATITUDE>" << m_Latitude << "</LATITUDE>"
				<< "<LONGITUDE>" << m_Longitude << "</LONGITUDE>"
				<< "<PREFERENCES>"
				<< "<SKIN>" << m_PrefSkin << "</SKIN>"
				<< "</PREFERENCES>";
	}
	sResult << "</USER>";
	return true;
}

/*********************************************************************************

	bool CUser::AddInside(const TDVCHAR* pTagName, CXMLObject* pObject)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	15/03/2000
	Inputs:		pTagName - name of tag to insert the xml object inside of
	Outputs:	-
	Returns:	true if operation successful, false if failed for any reason.
	Purpose:	Overides the base class implementation so that it is not possible
				to insert arbitrary XML within user xml. If you wish to change the
				value of some element then you should use one of the specialised
				set methods.

*********************************************************************************/

bool CUser::AddInside(const TDVCHAR* pTagName, CXMLObject* pObject)
{
	// Not allowed to add arbitrary xml into a user, must use specific set methods
	TDVASSERT(false, "CUser::AddInside(..) called with a CXMLObject parameter");
	return false;
}

/*********************************************************************************

	bool CUser::AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	15/03/2000
	Inputs:		pTagName - name of tag to insert the xml text inside of
	Outputs:	-
	Returns:	true if operation successful, false if failed for any reason.
	Purpose:	Overides the base class implementation so that it is not possible
				to insert arbitrary XML within user xml. If you wish to change the
				value of some element then you should use one of the specialised
				set methods.

*********************************************************************************/

bool CUser::AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText)
{
	// Not allowed to add arbitrary xml into a user, must use specific set methods
	TDVASSERT(false, "CUser::AddInside(..) called with arbitrary XML text");
	return false;
}

/*********************************************************************************

	bool CUser::DoesTagExist(const TDVCHAR* pNodeName)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	09/05/2000
	Inputs:		pNodeName - name of the tag whose existence we are checking for
	Outputs:	-
	Returns:	true if tag exists, false otherwise.
	Purpose:	Checks if a certain tag exists inside the xml. Since the tags
				for a user are fixed it should not be necessary to actually get
				the users data in order to check for this.

	Question:	Should this method check for the existence of the tag in the
				current dat within the object, or the available data? I say the
				latter if it is to be a public method, since what data has actually
				been currently retrieved should be hidden from the outside.

*********************************************************************************/

bool CUser::DoesTagExist(const TDVCHAR* pNodeName)
{
	TDVASSERT(!GotNoData(), "CUser::DoesTagExist(...) called on empty object");
	TDVASSERT(pNodeName != NULL, "CUser::DoesTagExist(...) called with NULL pNodeName pointer");

	// if object uninitialised then it contains no tags by definition
	if (GotNoData())
	{
		return false;
	}
	// otherwise every user object contains the same set of tags, so no need to
	// actually get the data to do the check
	CTDVString sTagName = pNodeName;
	
	sTagName.MakeUpper();
	// just do a comparison with every tag name that a user object will have
	// this code might well be improved by using e.g. a single static string
	// containing all the tag names and a single search for the tag name
	if (sTagName == "USER" ||
		sTagName == "USERID" ||
		sTagName == "USERNAME" ||
		sTagName == "GROUPS" ||
/*
		sTagName == "MODERATOR" && m_IsModerator ||
		sTagName == "SUBS" && m_IsSub ||
		sTagName == "ACES" && m_IsAce ||
		sTagName == "SECTIONHEADS" && m_IsSectionHead ||
		sTagName == "FIELDRESEARCHERS" && m_IsFieldResearcher ||
		sTagName == "ARTISTS" && m_IsArtist ||
		sTagName == "GURUS" && m_IsGuru ||
		sTagName == "SCOUTS" && m_IsScout ||
*/
		IsUserInGroup(sTagName) ||
			EmailIsVisible() && sTagName == "EMAIL-ADDRESS" ||
			EverythingIsVisible() &&
				(sTagName == "FIRST-NAMES" ||
				 sTagName == "LAST-NAME" ||
				 sTagName == "LOGIN-NAME" ||
				 sTagName == "COOKIE" ||
				 sTagName == "PASSWORD" ||
				 sTagName == "DATE-JOINED" ||
				 sTagName == "DATE-RELEASED" ||
				 sTagName == "DATE" ||
				 sTagName == "WEEK-DAY" ||
				 sTagName == "DAY" ||
				 sTagName == "MONTH" ||
				 sTagName == "YEAR" ||
				 sTagName == "MASTHEAD" ||
				 sTagName == "JOURNAL" ||
				 sTagName == "SINBIN" ||
				 sTagName == "STATUS" ||
				 sTagName == "LATITUDE" ||
				 sTagName == "LONGITUDE" ||
				 sTagName == "ACTIVE" ||
				 sTagName == "ANONYMOUS" ||
				 sTagName == "PRIVATEFORUM" ||
				 sTagName == "PREFERENCES" ||
				 sTagName == "SKIN")) // TODO: other preferences tags
	{
		// tag exists
		return true;
	}
	else
	{
		// tag doesn't exist
		return false;
	}
}

/*********************************************************************************

	bool CUser::IsEmpty()

	Author:		Kim Harries
	Created:	29/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if object is empty, false otherwise.
	Purpose:	Returns whether or not the user object is empty. Due to the manner
				of implementation the object is only empty when it has not been
				initialised, or has been reset (by Destroy()) to an uninitialised
				state.

	Question:	Should it check that the m_pTree pointer is NULL also? It always
				should be for this class, so what would it mean if it wasn't?

*********************************************************************************/

bool CUser::IsEmpty()
{
	// object is only empty when it has not been intialised
	if (GotNoData())
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CUser::Destroy()

	Author:		Kim Harries
	Created:	29/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if object destroyed successfully, false if any error occurred
				to prevent this.
	Purpose:	Destroys the information contained within this object and hence
				resets it to an uninitialised state.

*********************************************************************************/

bool CUser::Destroy()
{
	// delete tree pointer if we have one (though we should not have one)
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// set status to indicate no data
	SetStatusNoData();
	return true;
}

/*********************************************************************************

	CXMLTree* CUser::ExtractTree()

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	14/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	CXMLTree* - a pointer to the XML tree that used to belong to this
				object. Currently actually returns the first node within the tree
				rather than the tree root itself.
	Purpose:	Extracts the xml from this object as an XML tree. Unlike other
				ExtractTree implementations this method does not destroy the current
				object since this is unnecessary and possibly dangerous. Instead it
				builds a CXMLTree and returns this, but leaves the internal state
				of this object unchanged.

	Note:		This uses a somewhat dodgy technique of calling base class methods
				on a temporary CUser object. This could become a problem if the base
				class methods are reimplemented in such a way that they call this
				derived classes methods.

*********************************************************************************/

CXMLTree* CUser::ExtractTree()
{
	TDVASSERT(!GotNoData(), "CUser::ExtractTree() called on empty object");
	// if object is empty return NULL for failure
	if (GotNoData())
	{
		return NULL;
	}
	// use get as string to get a text representation of the XML for this object
	// => this is better than building it here as it avoids duplicating code
	// for dealing with what is visible and what is not etc.
	CXMLTree* pTempTree = NULL;
	CXMLTree* pFirstTagNode = NULL;
	CTDVString sText;
	bool bSuccess = this->GetAsString(sText);

	// if xml text was got successfully parse it into a temp tree and then extract
	// the first actual tag node, as this is what we really want to return a pointer to
	if (bSuccess)
	{
		// only care if parse is successfull or not, since it should never fail anyway
		pTempTree = CXMLTree::Parse(sText);
		if (pTempTree == NULL)
		{
			TDVASSERT(false, "Internal parse failed in CUser::ExtractTree()");
			bSuccess = false;
		}
	}
	// if all okay then find the first tag node
	if (bSuccess)
	{
		pFirstTagNode = pTempTree;
		// Scan through the tree until we find a node of type T_NODE
		// because that's the root named node we want to extract
		while ((pFirstTagNode != NULL) && (pFirstTagNode->GetNodeType() != CXMLTree::T_NODE))
		{
			pFirstTagNode = pFirstTagNode->FindNext();
		}
		// if we successfully found a node, use it
		if (pFirstTagNode != NULL)
		{
			// Detach this node from the rest of the tree
			pFirstTagNode->DetachNodeTree();
		}
	}
	// Destroy the remaining bits of the tree => safe because the node
	// we want has been detached already, or if something went wrong we
	// must delete the entire temp tree anyhow
	delete pTempTree;
	pTempTree = NULL;
	// should be ptr to first tag node, or NULL if something bizarre went wrong
	return pFirstTagNode;
}

/*********************************************************************************

	bool CUser::CreateFromXMLText(const TDVCHAR* xmlText)

	Author:		Kim Harries
	Created:	29/02/2000
	Inputs:		xmlText - string containing the well-formed XML from which to create
					an object.
	Outputs:	-
	Returns:	true for success, false for failure. Since you should not attempt
				to create a user from arbitrary xml text this will always return
				false.
	Purpose:	Overides the base class implementation to prevent attempts to create
				a users xml from arbitrary xml text.

*********************************************************************************/

bool CUser::CreateFromXMLText(const TDVCHAR* xmlText)
{
	// TODO: check if this is correct behaviour ???
	// should not attempt to create a CUser object from xml text, so assert
	// something impossible and return false for failure
	TDVASSERT(false, "Error: CUser::CreateFromXMLText(...) called");
	return false;
}

/*********************************************************************************

	bool CUser::EmailIsVisible()

	Author:		Kim Harries
	Created:	06/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user email address is visible from this object, false if
				it is not (or the object is uninitialised).
	Purpose:	Returns whether or not the users email address is part of the
				visible XML represented by this object, in other words whether
				this bit of data will be exposed when the object is asked for its
				contents.

*********************************************************************************/

bool CUser::EmailIsVisible()
{
	if (GotNoData() || m_VisibilityStatus == ID_NAME_VISIBLE)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/*********************************************************************************

	bool CUser::EverythingIsVisible()

	Author:		Kim Harries
	Created:	06/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if all the user data for this user is visible from this
				object, false if it is not (or the object is uninitialised).
	Purpose:	Returns whether or not all the data for this user is visible through
				this object, in other words whether all of the data will be exposed
				when the object is asked for its contents.

*********************************************************************************/

bool CUser::EverythingIsVisible()
{
	if (GotNoData() || m_VisibilityStatus != EVERYTHING_VISIBLE)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/*********************************************************************************

	bool CUser::SetEverythingVisible()

	Author:		Kim Harries
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Purpose:	Sets the visibility level of the contents of this User XML object.
				After a call to this method the entire contents will be visible,
				which means any requests for this objects contents (via GetAsString
				or ExtractTree for example) will get everything.

*********************************************************************************/

bool CUser::SetEverythingVisible()
{
	// always succeeds
	m_VisibilityStatus = EVERYTHING_VISIBLE;
	return true;
}

/*********************************************************************************

	bool CUser::SetIDNameEmailVisible()

	Author:		Kim Harries
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Purpose:	Sets the visibility level of the contents of this User XML object.
				After a call to this method the user ID, username, and email
				address are the only contents which will be expressed when the
				object is asked for its contents.

*********************************************************************************/

bool CUser::SetIDNameEmailVisible()
{
	// always succeeds
	m_VisibilityStatus = ID_NAME_EMAIL_VISIBLE;
	return true;
}

/*********************************************************************************

	bool CUser::SetIDNameVisible()

	Author:		Kim Harries
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success, false for failure. Should never fail however.
	Purpose:	Sets the visibility level of the contents of this User XML object.
				After a call to this method the user ID and username address are
				the only contents which will be expressed when the object is
				asked for its contents.

*********************************************************************************/

bool CUser::SetIDNameVisible()
{
	// always succeeds
	m_VisibilityStatus = ID_NAME_VISIBLE;
	return true;
}

/*********************************************************************************

	bool CUser::GetIsModerator()

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a a moderator
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsModerator()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		//User is a moderator if they are in the moderators group for this site or
		//if they are a member of the appropriate moderation class for this site.
		return IsUserInGroup("MODERATOR") || m_bIsModClassMember;
	}
}

bool CUser::GetIsUserLocationHidden()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		if (m_HideLocation > 0)
		{
			return true; 
		}

		return false; 
	}
}

bool CUser::GetIsUserNameHidden()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		if (m_HideUserName > 0)
		{
			return true; 
		}

		return false; 
	}
}

bool CUser::GetAcceptSubscriptions()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return m_bAcceptSubscriptions;
	}
}

/*********************************************************************************

	bool CUser::SetUsersLocationHidden(bool bHide)

		Author:		Mark HOwitt
        Created:	09/05/2006
        Inputs:		bHide - A flag to say whether or not to hide the location
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the member variable for the current instance of the user

*********************************************************************************/
bool CUser::SetUsersLocationHidden(bool bHide)
{
	// Check to make sure that we've got valid data before setting the value
	if (!GotNoData())
	{
		m_HideLocation = bHide;
		return true;
	}
	return false;
}

/*********************************************************************************

	bool CUser::SetUsersUserNameHidden(bool bHide)

		Author:		Mark Howitt
        Created:	09/05/2006
        Inputs:		bHide - A flag to say whether or not to hide the username
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the member variable for the current instance of the user

*********************************************************************************/
bool CUser::SetUsersUserNameHidden(bool bHide)
{
	// Check to make sure that we've got valid data before setting the value
	if (!GotNoData())
	{
		m_HideUserName = bHide;
		return true;
	}
	return false;
}

bool CUser::SetIsGroupMember(const TDVCHAR* pcGroupName, bool bIsMember)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsGroupMember(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the groups modified flag
		m_Groups[pcGroupName] = bIsMember;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::ClearGroupMembership()
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsGroupMember(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// clear the groups map and set the groups modified flag
	m_Groups.clear();
	m_bGroupsModified = true;
	return true;
}

/*********************************************************************************

	bool CUser::GetIsSub()

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a Sub Editor, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsSub()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsSub;
		return IsUserInGroup("SUBS");
	}
}

/*********************************************************************************

	bool CUser::GetIsAce()

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is an Ace, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsAce()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsAce;
		return IsUserInGroup("ACES");
	}
}

/*********************************************************************************

	bool CUser::GetIsFieldResearcher()

	Author:		Kim Harries
	Created:	10/05/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a field researcher, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsFieldResearcher()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsFieldResearcher;
		return (IsUserInGroup("FIELDRESEARCHERS"));
	}
}

/*********************************************************************************

	bool CUser::GetIsSectionHead()

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a Section Head, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsSectionHead()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsSectionHead;
		return IsUserInGroup("SECTIONHEADS");
	}
}

/*********************************************************************************

	bool CUser::GetIsArtist()

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is an Artist, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsArtist()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsArtist;
		return IsUserInGroup("ARTISTS");
	}
}

/*********************************************************************************

	bool CUser::GetIsGuru()

	Author:		Kim Harries
	Created:	19/09/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a guru, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsGuru()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsGuru;
		return IsUserInGroup("GURUS");
	}
}

/*********************************************************************************

	bool CUser::GetIsScout()

	Author:		Kim Harries
	Created:	19/09/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a scout, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsScout()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
//		return m_IsScout;
		return IsUserInGroup("SCOUTS");
	}
}

/*********************************************************************************

	bool CUser::GetIsNotable()

		Author:		Mark Neves
        Created:	24/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if the user is in the Notables group
        Purpose:	-

*********************************************************************************/

bool CUser::GetIsNotable()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return IsUserInGroup("NOTABLES");
	}
}

/*********************************************************************************

	bool CUser::GetIsEditor()

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if user is an editor, false if not or it object uninitialised
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetIsEditor()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		//return (m_Status == 2);
		return (IsUserInGroup("EDITOR") || m_Status == 2);
	}
}

/*********************************************************************************

	bool CUser::GetUserID(int& iUserID)

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	piUserID - pointer to the integer in which to place the user ID of
					the user represented by the current object.
	Returns:	true for success, false for failure.
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetUserID(int* piUserID)
{
	TDVASSERT(piUserID != NULL, "NULL piUserID in CUser::GetUserID(...)");

	// must ensure we don't try to put data into a NULL pointer
	if (piUserID == NULL)
	{
		return false;
	}
	// if we have the user ID then get it and return true
	// else do nothing and return false
	if (GotNoData())
	{
		// got nothing, so were are no one
		return false;
	}
	else if (GotUserID())
	{
		// already have the ID
		*piUserID = m_UserID;
		return true;
	}
	else
	{
		// fetch data first then set the ID
		if (FetchData())
		{
			*piUserID = m_UserID;
			return true;
		}
		else
		{
			return false;
		}
	}
}

/*********************************************************************************

	bool CUser::GetUsername(CTDVString& sUsername)

	Author:		Kim Harries
	Created:	02/03/2000
	Inputs:		-
	Outputs:	sUsername - the username of the user represented by this object.
	Returns:	true for success, false for failure.
	Purpose:	Allows controlled access to the contents of this object.

*********************************************************************************/

bool CUser::GetUsername(CTDVString& sUsername)
{
	if (GotNoData())
	{
		// no data, no fun
		return false;
	}
	else if (!GotCompleteData())
	{
		// fetch data if we haven't already got it
		if (!FetchData())
		{
			return false;
		}
	}
	sUsername = m_Username;
	return true;
}

bool CUser::GetLoginName(CTDVString& sLoginName)
{
	if (GotNoData())
	{
		// no data, no fun
		return false;
	}
	else if (!GotCompleteData())
	{
		// fetch data if we haven't already got it
		if (!FetchData())
		{
			return false;
		}
	}
	sLoginName = m_LoginName;
	return true;
}

bool CUser::GetFirstNames(CTDVString& sFirstNames)
{
	if (GotNoData())
	{
		// no data, no fun
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sFirstNames = m_FirstNames;
	return true;
}

bool CUser::GetLastName(CTDVString& sLastName)
{
	if (GotNoData())
	{
		// no data, no fun
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sLastName = m_LastName;
	return true;
}

bool CUser::GetEmail(CTDVString& sEmail)
{
	if (GotNoData())
	{
		return false;
	}
	else if (GotEmail())
	{
		sEmail = m_Email;
		return true;
	}
	else
	{
		if (!FetchData())
		{
			return false;
		}
		sEmail = m_Email;
		return true;
	}
}

bool CUser::GetTitle(CTDVString& sTitle)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	
	sTitle = m_Title;
	return true;
}

bool CUser::GetSiteSuffix(CTDVString& sSiteSuffix)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	
	sSiteSuffix = m_sSiteSuffix;
	return true;
}

bool CUser::GetCookie(CTDVString& sCookie)
{
	if (GotNoData())
	{
		return false;
	}
	else if (GotCookie())
	{
		sCookie = m_Cookie;
		return true;
	}
	else
	{
		if (!FetchData())
		{
			return false;
		}
		sCookie = m_Cookie;
		return true;
	}
}

bool CUser::GetBBCUID(CTDVString& sBBCUID)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sBBCUID = m_BBCUID;
	return true;
}

bool CUser::GetPassword(CTDVString& sPassword)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sPassword = m_Password;
	return true;
}

bool CUser::GetPostcode(CTDVString& sPostcode)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	
	if (m_Postcode.IsEmpty())
	{
		return false;
	}

	sPostcode = m_Postcode;

	return true;
}


bool CUser::GetArea(CTDVString& sArea)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sArea = m_Area;
	return true;
}

bool CUser::GetRegion(CTDVString& sRegion)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sRegion = m_Region;
	return true;
}

bool CUser::GetTaxonomyNode(int* iNode)
{
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*iNode = m_TaxonomyNode;
	return true;
}

bool CUser::GetDateJoined(CTDVString& sDateJoined)
{
	if (GotNoData())
	{
		return false;
	}
	if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sDateJoined = CTDVString(m_DateJoined.GetDay() + "/" + m_DateJoined.GetMonth() + m_DateJoined.GetYear());
	return true;
}

bool CUser::GetDateReleased(CTDVString& sDateReleased)
{
	if (GotNoData())
	{
		return false;
	}
	if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	sDateReleased = CTDVString(m_DateReleased.GetDay() + "/" + m_DateReleased.GetMonth() + m_DateReleased.GetYear());
	return true;
}

bool CUser::GetMasthead(int* piMasthead)
{
	TDVASSERT(piMasthead != NULL, "NULL piMasthead in CUser::GetMasthead(...)");

	// ensure non-NULL pointer
	if (piMasthead == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piMasthead = m_Masthead;
	return true;
}

bool CUser::GetJournal(int* piJournal)
{
	TDVASSERT(piJournal != NULL, "NULL piJournal in CUser::GetJournal(...)");

	if (piJournal == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piJournal = m_Journal;
	return true;
}

bool CUser::GetSinBin(int* piSinBin)
{
	TDVASSERT(piSinBin != NULL, "NULL piSinBin in CUser::GetSinBin(...)");

	if (piSinBin == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piSinBin = m_SinBin;
	return true;
}

bool CUser::GetStatus(int* piStatus)
{
	TDVASSERT(piStatus != NULL, "NULL piStatus in CUser::GetStatus(...)");

	if (piStatus == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piStatus = m_Status;
	return true;
}

bool CUser::GetTeamID(int* piTeamID)
{
	TDVASSERT(piTeamID != NULL, "NULL piTeamID in CUser::GetTeamID(...)");

	if (piTeamID == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piTeamID = m_TeamID;
	return true;
}

bool CUser::GetUnreadPublicMessageCount(int* piUnreadPublicMessageCount)
{
	TDVASSERT(piUnreadPublicMessageCount != NULL, "NULL piUnreadPublicMessageCount in CUser::GetUnreadPublicMessageCount(...)");

	if (piUnreadPublicMessageCount == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piUnreadPublicMessageCount = m_UnreadPublicMessageCount;
	return true;
}

bool CUser::GetUnreadPrivateMesageCount(int* piUnreadPrivateMessageCount)
{
	TDVASSERT(piUnreadPrivateMessageCount != NULL, "NULL piUnreadPrivateMessageCount in CUser::GetUnreadPrivateMesageCount(...)");

	if (piUnreadPrivateMessageCount == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*piUnreadPrivateMessageCount = m_UnreadPrivateMessageCount;
	return true;
}

bool CUser::GetLatitude(double* pdLatitude)
{
	TDVASSERT(pdLatitude != NULL, "NULL pdLatitude in CUser::GetLatitude(...)");

	if (pdLatitude == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*pdLatitude = m_Latitude;
	return true;
}

bool CUser::GetLongitude(double* pdLongitude)
{
	TDVASSERT(pdLongitude != NULL, "NULL pdLongitude in CUser::GetLongitude(...)");

	if (pdLongitude == NULL)
	{
		return false;
	}

	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*pdLongitude = m_Longitude;
	return true;
}

bool CUser::GetActive(bool* pbActive)
{
	TDVASSERT(pbActive != NULL, "NULL pbActive in CUser::GetActive(...)");

	if (pbActive == NULL)
	{
		return NULL;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*pbActive = m_Active;
	return true;
}

bool CUser::GetAnonymous(bool* pbAnonymous)
{
	TDVASSERT(pbAnonymous != NULL, "NULL pbAnonymous in CUser::GetAnonymous(...)");

	if (pbAnonymous == NULL)
	{
		return false;
	}
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return false;
		}
	}
	*pbAnonymous = m_Anonymous;
	return true;
}

bool CUser::GetPrefSkin(CTDVString* pPrefSkin)
{
	TDVASSERT(pPrefSkin != NULL, "NULL pPrefSkin in CUser::GetPrefSkin(...)");

	if (pPrefSkin == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*pPrefSkin = m_PrefSkin;
	return true;
}

bool CUser::GetPrefUserMode(int* piPrefUserMode)
{
	TDVASSERT(piPrefUserMode != NULL, "NULL piPrefUserMode in CUser::GetPrefUserMode(...)");

	if (piPrefUserMode == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*piPrefUserMode = m_PrefUserMode;
	return true;
}

bool CUser::GetPrefForumStyle(int* piPrefForumStyle)
{
	TDVASSERT(piPrefForumStyle != NULL, "NULL piPrefForumStyle in CUser::GetPrefForumStyle(...)");

	if (piPrefForumStyle == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*piPrefForumStyle = m_PrefForumStyle;
	return true;
}

bool CUser::GetPrefForumThreadStyle(int* piPrefForumThreadStyle)
{
	TDVASSERT(piPrefForumThreadStyle != NULL, "NULL piPrefForumThreadStyle in CUser::GetPrefForumThreadStyle(...)");

	if (piPrefForumThreadStyle == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*piPrefForumThreadStyle = m_PrefForumThreadStyle;
	return true;
}

bool CUser::GetPrefForumShowMaxPosts(int* piPrefForumShowMaxPosts)
{
	TDVASSERT(piPrefForumShowMaxPosts != NULL, "NULL piPrefForumShowMaxPosts in CUser::GetPrefForumShowMaxPosts(...)");

	if (piPrefForumShowMaxPosts == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*piPrefForumShowMaxPosts = m_PrefForumShowMaxPosts;
	return true;
}

bool CUser::GetPrefReceiveWeeklyMailshot(bool* pbPrefReceiveWeeklyMailshot)
{
	TDVASSERT(pbPrefReceiveWeeklyMailshot != NULL, "NULL pbPrefReceiveWeeklyMailshot in CUser::GetPrefReceiveWeeklyMailshot(...)");

	if (pbPrefReceiveWeeklyMailshot == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*pbPrefReceiveWeeklyMailshot = m_PrefReceiveWeeklyMailshot;
	return true;
}

bool CUser::GetPrefReceiveDailyUpdates(bool* pbPrefReceiveDailyUpdates)
{
	TDVASSERT(pbPrefReceiveDailyUpdates != NULL, "NULL pbPrefReceiveDailyUpdates in GetPrefReceiveDailyUpdates(...)");

	if (pbPrefReceiveDailyUpdates == NULL)
	{
		return false;
	}
	// if we have no data at all then fail
	if (GotNoData())
	{
		return false;
	}
	else if (!GotCompleteData())
	{
		// if we don't have the complete data then fetch it, or fail if we can't
		if (!FetchData())
		{
			return false;
		}
	}
	// set the value and return success
	*pbPrefReceiveDailyUpdates = m_PrefReceiveDailyUpdates;
	return true;
}

// set methods for internal data

/*********************************************************************************

	bool CUser::SetIsModerator(bool bIsModerator)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsModerator - new value for whether they are a Moderator or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsModerator(bool bIsModerator)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsModerator(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsModerator(bIsModerator);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsModerator = bIsModerator;
		m_Groups["MODERATOR"] = bIsModerator;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsSub(bool bIsSub)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsSub - new value for whether they are a sub or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsSub(bool bIsSub)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsSub(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsSub(bIsSub);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsSub = bIsSub;
		m_Groups["SUBS"] = bIsSub;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsAce(bool bIsAce)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsAce - new value for whether they are an Ace or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsAce(bool bIsAce)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsAce(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsAce(bIsAce);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsAce = bIsAce;
		m_Groups["ACES"] = bIsAce;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsFieldResearcher(bool bIsFieldResearcher)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsFieldResearcher - new value for whether they are a Field Researcher or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsFieldResearcher(bool bIsFieldResearcher)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsFieldResearcher(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsFieldResearcher(bIsFieldResearcher);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsFieldResearcher = bIsFieldResearcher;
		m_Groups["FIELDRESEARCHERS"] = bIsFieldResearcher;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsSectionHead(bool bIsSectionHead)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsSectionHead - new value for whether they are a section head or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsSectionHead(bool bIsSectionHead)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsSectionHead(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsSectionHead(bIsSectionHead);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsSectionHead = bIsSectionHead;
		m_Groups["SECTIONHEADS"] = bIsSectionHead;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsArtist(bool bIsArtist)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsArtist - new value for whether they are an artist or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsArtist(bool bIsArtist)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsArtist(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsArtist(bIsArtist);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsArtist = bIsArtist;
		m_Groups["ARTISTS"] = bIsArtist;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsGuru(bool bIsGuru)

	Author:		Kim Harries
	Created:	19/09/2000
	Inputs:		bIsGuru - new value for whether they are a guru or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsGuru(bool bIsGuru)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsGuru(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsGuru(bIsGuru);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsGuru = bIsGuru;
		m_Groups["GURUS"] = bIsGuru;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetIsScout(bool bIsScout)

	Author:		Kim Harries
	Created:	19/09/2000
	Inputs:		bIsScout - new value for whether they are a scout or not
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetIsScout(bool bIsScout)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsScout(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsScout(bIsScout);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsScout = bIsScout;
		m_Groups["SCOUTS"] = bIsScout;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

bool CUser::SetUsername(const TDVCHAR* pUsername)
																			 ,
	Author:		Kim Harries
	Created:	13/03/2000
	Modified:	15/03/2000
	Inputs:		pUsername - the value to set the username to
	Outputs:	-
	Returns:	true for success, false for failure.
	Purpose:	Sets the member variables value for the specific piece of data. Has
				to be aware of details such as whether the object has been initialised,
				whether it has fetched its data or not, etc. Also needs to set the
				data modified flag and start up the stored procedure for updating
				the users details if necessary.

*********************************************************************************/

bool CUser::SetUsername(const TDVCHAR* pUsername)
{
	TDVASSERT(pUsername != NULL, "CUser::SetUsername(...) called with NULL pUsername");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetUsername(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateUsername(pUsername);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Username = pUsername;
		// We have to fix dodgy characters - the stored procedure will fix them in the database
		m_Username.Replace("<","&lt;");
		m_Username.Replace(">","&lt;");
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetFirstNames(const TDVCHAR* pFirstNames)
{
	TDVASSERT(pFirstNames != NULL, "CUser::SetFirstNames(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetFirstNames(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateFirstNames(pFirstNames);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_FirstNames = pFirstNames;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetLastName(const TDVCHAR* pLastName)
{
	TDVASSERT(pLastName != NULL, "CUser::SetLastName(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetLastName(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateLastName(pLastName);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_LastName = pLastName;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetTitle(const TDVCHAR* pTitle)

	Author:		Dharmesh Raithatha
	Created:	10/7/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Sets the title of the user

*********************************************************************************/

bool CUser::SetTitle(const TDVCHAR* pTitle)
{
	TDVASSERT(pTitle != NULL, "CUser::SetTitle(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetTitle(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateTitle(pTitle);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Title = pTitle;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetSiteSuffix(const TDVCHAR* pSiteSuffix)
{
	TDVASSERT(pSiteSuffix != NULL, "CUser::SetSiteSuffix(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetSiteSuffix(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;

	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		m_pStoredProcedure->UserUpdateSiteSuffix(pSiteSuffix);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_sSiteSuffix = pSiteSuffix;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*********************************************************************************

	bool CUser::SetPostcode(const char* pPostcode)

	Author:		Dharmesh Raithatha
	Created:	9/11/2003
	Inputs:		pPostcode - the postcode to set for this user
	Outputs:	-
	Returns:	true if successfull, false otherwise
	Purpose:	this will set the postcode for this user in the profile api for the
				current service. 

*********************************************************************************/

bool CUser::SetPostcode(const TDVCHAR* pPostcode)
{
	TDVASSERT(pPostcode != NULL, "CUser::SetPostcode(...) called with NULL parameter");
	// first check that user has been initialised
	
	if (pPostcode == NULL)
	{
		return false;
	}

	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPostcode(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}

	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}

	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();

	if (pProfile == NULL)
	{
		bSuccess = false;
	}
	// if all okay then now add the username to the list of details to update
	
	//update the profile first as some services do not have a postcode and hence this will fail
	//and we don't want to be out of sync.
	if (bSuccess)
	{
		bSuccess = pProfile->UpdateUserProfileValue("postcode",pPostcode);
	}

	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePostcode(pPostcode);
	}

	if (!bSuccess)
	{
		TDVASSERT(false,"in CUser::SetPostcode failed to update the postcode in profile api");
	}

	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Postcode = pPostcode;
		m_bDataModified = true;
	}

	return true;

}

/*********************************************************************************

	bool CUser::SetRegion(const TDVCHAR* pRegion)

	Author:		Martin Robb
	Created:	25/07/2005
	Inputs:		pRegion
	Outputs:	-
	Returns:	true if successfull, false otherwise
	Purpose:	Sets Users Region 
*********************************************************************************/
bool CUser::SetRegion( const TDVCHAR* pRegion )
{	
	TDVASSERT(pRegion != NULL, "CUser::SetPostcode(...) called with NULL parameter");
	// first check that user has been initialised
	
	if (pRegion == NULL)
	{
		return false;
	}

	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetRegion(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}

	// if SP has not been created yet then create it and start the update process up
	bool bSuccess = true;
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}

	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
	if ( pProfile && pProfile->AttributeExistsForService("region") )
	{
		bSuccess = bSuccess && pProfile->UpdateUserProfileValue("region",pRegion);
	}
	bSuccess = bSuccess && m_pStoredProcedure->UserUpdateRegion(pRegion);
	
	if (!bSuccess)
	{
		TDVASSERT(false,"in CUser::SetRegion failed to update the postcode in profile api");
	}
	else
	{
		m_Region = pRegion;
		m_bDataModified = true;
	}

	return true;
}

bool CUser::SetEmail(const TDVCHAR* pEmail)
{
	TDVASSERT(pEmail != NULL, "CUser::SetEmail(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetEmail(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateEmail(pEmail);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Email = pEmail;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}


bool CUser::SetTaxonomyNode(int iNode)
{
	TDVASSERT(iNode > 0, "CUser::SetTaxonomyNode(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetTaxonomyNode(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateTaxonomyNode(iNode);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_TaxonomyNode = iNode;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetCookie(const TDVCHAR* pCookie)
{
	TDVASSERT(pCookie != NULL, "CUser::SetCookie(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetCookie(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateCookie(pCookie);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Cookie = pCookie;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetPassword(const TDVCHAR* pPassword)
{
	TDVASSERT(pPassword != NULL, "CUser::SetPassword(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPassword(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePassword(pPassword);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Password = pPassword;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}



bool CUser::SetArea(const TDVCHAR* pArea)
{
	TDVASSERT(pArea != NULL, "CUser::SetArea(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetArea(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateArea(pArea);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Area = pArea;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetDateJoined(const TDVCHAR* pDateJoined)
{
	TDVASSERT(pDateJoined != NULL, "CUser::SetDateJoined(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetDateJoined(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// use the OleDateTime method ParseDateTime to convert the string
	// this can throw exception so make sure they are caught and handled
	bool bSuccess = true;
	CTDVDateTime dateJoined;
	try
	{
		bSuccess = (dateJoined.ParseDateTime(pDateJoined) != FALSE);
	}
	catch (...)
	{
		bSuccess = false;
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	// if SP has not been created yet then create it and start the update process up
	if (bSuccess && m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateDateJoined(dateJoined);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_DateJoined = dateJoined;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}


bool CUser::SetDateReleased(const TDVCHAR* pDateReleased)
{
	TDVASSERT(pDateReleased != NULL, "CUser::SetDateReleased(...) called with NULL parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetDateReleased(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// use the OleDateTime method ParseDateTime to convert the string
	// this can throw exception so make sure they are caught and handled
	bool bSuccess = true;
	CTDVDateTime dateReleased;
	try
	{
		bSuccess = (dateReleased.ParseDateTime(pDateReleased) != FALSE);
	}
	catch (...)
	{
		bSuccess = false;
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	// if SP has not been created yet then create it and start the update process up
	if (bSuccess && m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateDateReleased(dateReleased);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_DateReleased = dateReleased;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

// This method is deprecated
/*
bool CUser::SetMasthead(int iMasthead)
{
	TDVASSERT(iMasthead > 0, "CUser::SetMasthead(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetMasthead(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateMasthead(iMasthead);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Masthead = iMasthead;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}
*/

/* Never called
bool CUser::SetJournal(int iJournal)
{
	TDVASSERT(iJournal < 0, "CUser::SetJournal(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetJournal(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateJournal(iJournal);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Journal = iJournal;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}
*/

bool CUser::SetSinBin(int iSinBin)
{
	TDVASSERT(iSinBin < 0 != NULL, "CUser::SetSinBin(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetSinBin(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateSinBin(iSinBin);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_SinBin = iSinBin;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetStatus(int iStatus)
{
	TDVASSERT(iStatus < 0, "CUser::SetStatus(...) called with negative parameter");
	bool bSuccess = InitUpdate();
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateStatus(iStatus);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Status = iStatus;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetLatitude(double dLatitude)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetLatitude(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateLatitude(dLatitude);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Latitude = dLatitude;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetLongitude(double dLongitude)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetLongitude(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateLongitude(dLongitude);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Longitude = dLongitude;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetActive(bool bActive)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetActive(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateActive(bActive);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Active = bActive;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetAnonymous(bool bAnonymous)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetAnonymous(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateAnonymous(bAnonymous);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_Anonymous = bAnonymous;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetPrefSkin(const TDVCHAR* pPrefSkin)
{
	TDVASSERT(pPrefSkin != NULL, "CUser::SetPrefSkin(...) called with NULL pPrefSkin");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefSkin(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the skin preference to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefSkin(pPrefSkin);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefSkin = pPrefSkin;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetPrefUserMode(int iPrefUserMode)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefUserMode(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the skin preference to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefUserMode(iPrefUserMode);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefUserMode = iPrefUserMode;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetPrefForumStyle(int iPrefForumStyle)
{
	TDVASSERT(iPrefForumStyle > 0, "CUser::SetPrefForumStyle(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefForumStyle(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefForumStyle(iPrefForumStyle);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefForumStyle = iPrefForumStyle;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetPrefForumThreadStyle(int iPrefForumThreadStyle)
{
	TDVASSERT(iPrefForumThreadStyle < 0, "CUser::SetPrefForumThreadStyle(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefForumThreadStyle(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefForumThreadStyle(iPrefForumThreadStyle);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefForumThreadStyle = iPrefForumThreadStyle;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetAcceptSubscriptions( bool bAcceptSubscriptions )
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetAcceptSubscriptions() called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdateAllowSubscriptions(bAcceptSubscriptions);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_bAcceptSubscriptions = bAcceptSubscriptions;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

/*bool CUser::SetPrefForumShowMaxPosts(int iPrefForumShowMaxPosts)
{
	TDVASSERT(iPrefForumShowMaxPosts < 0, "CUser::SetPrefForumShowMaxPosts(...) called with negative parameter");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefForumShowMaxPosts(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefForumShowMaxPosts(iPrefForumShowMaxPosts);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefForumShowMaxPosts = iPrefForumShowMaxPosts;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}
*/

/*
bool CUser::SetPrefReceiveWeeklyMailshot(bool bPrefReceiveWeeklyMailshot)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefReceiveWeeklyMailshot(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefReceiveWeeklyMailshot(bPrefReceiveWeeklyMailshot);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefReceiveWeeklyMailshot = bPrefReceiveWeeklyMailshot;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::SetPrefReceiveDailyUpdates(bool bPrefReceiveDailyUpdates)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefReceiveDailyUpdates(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID);
		}
	}
	// if all okay then now add the username to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefReceiveDailyUpdates(bPrefReceiveDailyUpdates);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefReceiveDailyUpdates = bPrefReceiveDailyUpdates;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}
*/

/*********************************************************************************

	bool CUser::UpdateDetails()

	Author:		Kim Harries
	Created:	13/03/2000
	Modified:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if database was updated successfully, false if this failed
				for some reason.
	Purpose:	Tells the CUser object to update the database with whatever its
				current data is. Should be called whenever changes have been made
				to a users details that should be persistent.

*********************************************************************************/

bool CUser::UpdateDetails()
{
	// if data not modified no point in updating it
	if (!m_bDataModified && !m_bGroupsModified)
	{
		// log a warning as this may indicate an error somewhere
		TDVASSERT(false, "CUser::UpdateDetails() called when data unmodified");
		return true;
	}
	// otherwise proceed with the update
	// fail if SP member variable is NULL for some reason
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();

		if (m_pStoredProcedure == NULL)
		{
			return false;
		}
	}
	bool	bSuccess = true;
	// update the users details via the appropriate SP method
	// all that remains to be done is to finalise the actual update
	if (m_bDataModified)
	{
		bSuccess = bSuccess && m_pStoredProcedure->DoUpdateUser();
	}
	// update the users groups if necessary
	if (bSuccess && m_bGroupsModified)
	{
		// if successful rest modified flag, otherwise assert error and fail
		if (m_pStoredProcedure->UpdateUsersGroupMembership(m_UserID, m_SiteID, m_Groups))
		{
			m_bGroupsModified = false;
		}
		else
		{
			TDVASSERT(false, "Failed to update users groups in CUser::UpdateDetails()");
			bSuccess = false;
		}
	}
	// if update successfull then the DB now has identical data to the
	// current object, so the data is no longer 'modified'
	if (bSuccess)
	{
		m_bDataModified = false;
	}

	// Since we've completed this update, we delete the SP.
	delete m_pStoredProcedure;
	m_pStoredProcedure = NULL;

	return bSuccess;
}


/*********************************************************************************

	bool CUser::LoginUser()

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the user successfully logged in, false otherwise
	Purpose:	This logs the user in and makes sure that the data that needs to
				be synchronized with the Profile Api is done so. If the user is 
				logged in the relevant flag will be set. 
				
				Once logged in the the user's data will be retrieved from the id.

				Finally the profile api values that need to be synchronised with
				the dna user record in the database will be synchronised.

*********************************************************************************/

bool CUser::LoginUserToProfile()
{
	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
	
	if (pProfile == NULL)
	{
		return false;
	}

	CTDVString sSignInUserId = pProfile->GetUserId();
	m_InputContext.WriteInputLog("USER", "UserID:" + sSignInUserId);
	
	if (sSignInUserId == NULL || sSignInUserId.GetLength() <= 0 )
	{
		TDVASSERT(false,"In CUSER::LoginUserToProfile sSignInUserId is Empty");
		return false;
	}

	if (!IsUserLoggedIn() && IsUserSignedIn())
	{
		unsigned int uiCanLogin = 0;
		
		pProfile->LoginUser(uiCanLogin);
		
		if (uiCanLogin == CANLOGIN_LOGGEDIN)
		{
			m_InputContext.WriteInputLog("USER", "New User");
			
			//we can't find the user in our database so they are new to dna
			//this means that we have to create them in our database as a new user
			
			if (!CreateFromSigninIDAndInDatabase(sSignInUserId))
			{
				SetUserNotLoggedIn();
				return false;
			}
			
			//No Need to synchronise a new user.
			//SynchroniseWithProfile();
			
			SetUserLoggedIn();

			return true;
		}
		else
		{
			SetUserNotLoggedIn();
			return false;
		}
	}
	
	return false;
}

/*********************************************************************************

	bool CUser::SynchroniseWithProfile()

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		- bForceUpdate - Forces and Update.
				The reason for this is that the SynchroniseWithProfile also make an entry into the 
				users preferences for the site. 
				So if it is the users first visit eg they have just registered allow a forced update.	
	Outputs:	-
	Returns:	-
	Purpose:	retrieves the data from the 

*********************************************************************************/

bool CUser::SynchroniseWithProfile( bool bForceUpdate )
{
	m_InputContext.WriteInputLog("USER", "SynchroniseWithProfile\n\r");

	//if you don't have the user data then you can't synchronise
	if (!GotUserData())
	{
		return false;
	}

	//If User Details have already been checked against SSO return.
	if ( !bForceUpdate && IsSynchronised() )
	{
		return false;
	}

	// check for the autogen site suffixes
	CheckAndSyncAutoGeneratedSiteSuffix();

	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
	if(pProfile == NULL)
	{
		return false;
	}

#ifdef DEBUG
	// Check to make sure we've got a user that is logged in!
	bool bLoggedIn = false;
	pProfile->CheckUserIsLoggedIn(bLoggedIn);
	if (!bLoggedIn)
	{
		// Set the last error
		return SetDNALastError("CUser::SynchroniseWithProfile","UserNotLoggedIn","User not logged in to SSO!!!");
	}
#endif

	// Get the users email first
	CTDVString sEmail;

	// Check to see if email is a required attribute
	if (pProfile->AttributeExistsForService("email"))
	{
		// Get the value for the email
		pProfile->GetUserProfileValue("email",sEmail);
	}
	else
	{
		// Attribute does not exists or is not mandatory. Leave the email as it is
		sEmail = m_Email;
	}

	//Get SSO Login name.
	CTDVString sLoginName = pProfile->GetUserName();

	// Get the users first and last name as we want to synchronise these if they are ICan users.
	CTDVString sFirstNames, sLastName, sDisplayName;
	CTDVString* pFirstNames = NULL, *pLastName = NULL;

	if (pProfile->AttributeExistsForService("firstname") && !m_HideUserName)
	{
		pProfile->GetUserProfileValue("firstname",sFirstNames);
		pFirstNames = &sFirstNames;
	}
	
	if (pProfile->AttributeExistsForService("lastname") && !m_HideUserName)
	{
		pProfile->GetUserProfileValue("lastname",sLastName);
		pLastName = &sLastName;
	}

	const WCHAR* pDisplayName = NULL;
	if (pProfile->AttributeExistsForService("displayname"))
	{
		pDisplayName = pProfile->GetUserDisplayNameUniCode();
		USES_CONVERSION;
		sDisplayName = W2A(pDisplayName);
	}	

	//Do a check to see if the details need synchronised - ( A LastUpdated field on SSO would be nice )
	if ( bForceUpdate ||
		(m_FirstNames != sFirstNames && !m_HideUserName) ||
		(m_LastName != sLastName && !m_HideUserName) ||
		m_Email != sEmail ||
		m_LoginName != sLoginName ||
		(pDisplayName != NULL && m_Username != sDisplayName))
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		
		//Do DB Update
		if (!SP.SynchroniseUserWithProfile(pFirstNames, pLastName, 
			m_UserID, sEmail, sLoginName, m_InputContext.GetSiteID(), pDisplayName, m_InputContext.GetSiteUsesIdentitySignIn(m_InputContext.GetSiteID())))
		{
			return false;
		}

		//Refresh
		m_Email = sEmail;
		m_FirstNames = sFirstNames;
		m_LastName = sLastName;
		m_LoginName = sLoginName;
		if (sDisplayName.GetLength() > 0)
		{
			m_Username = sDisplayName;
		}
	}

	//Record that user has been checked against SSO.
	m_bIsSynchronised = true;
	return true;
}

/*********************************************************************************

	void CUser::CheckForExistingUDNGifSiteSuffixIsNullOrDisplayName()

	Author:		Steve Francis
	Created:	08/04/2010
	Purpose:	Checks if the site suffix is null or the same as their display name and if we're on a 
				site that uses AutoGen names.	
				Checks if one exists and goes and gets the users autogen nickname from the signin system

*********************************************************************************/
void CUser::CheckForExistingUDNGifSiteSuffixIsNullOrDisplayName()
{
	m_InputContext.WriteInputLog("USER", "CheckForExistingUDNGifSiteSuffixIsNullOrDisplayName");

	if (m_InputContext.GetCurrentSiteOptionInt("User","UseSiteSuffix") > 0 && m_InputContext.GetCurrentSiteOptionString("User","AutoGeneratedNames") != "")
	{
		if (m_InputContext.GetCurrentSiteOptionInt("General","IsKidsSite") > 0)
		{
			if (m_sSiteSuffix.GetLength() == 0 || m_sSiteSuffix == m_Username)
			{
				CheckAndSyncAutoGeneratedSiteSuffix();
			}
		}
	}
}
/*********************************************************************************

	void CUser::CheckAndSyncAutoGeneratedSiteSuffix()

	Author:		Mark Howitt
	Created:	24/02/2010
	Purpose:	Checks and gets the users autogen nickname from the signin system

*********************************************************************************/
void CUser::CheckAndSyncAutoGeneratedSiteSuffix()
{
	m_InputContext.WriteInputLog("USER", "CheckAndSyncAutoGeneratedSiteSuffix");

		// Check to see if the current site uses sitesuffix and autogen nicknames
	if (m_InputContext.GetCurrentSiteOptionInt("User","UseSiteSuffix") > 0 && m_InputContext.GetCurrentSiteOptionString("User","AutoGeneratedNames") != "")
	{
		// Check to see the SignIn system has a name for the user
		CTDVString sAttributeName, sAttributeAppNameSpace;
		if (m_InputContext.GetCurrentSiteOptionInt("General","IsKidsSite") > 0)
		{
			sAttributeName = "cbbc_displayname";
			sAttributeAppNameSpace = "cbbc";
		}

		CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
		if(pProfile == NULL)
		{
			return;
		}

		if (pProfile->DoesAppNamedSpacedAttributeExist(sAttributeAppNameSpace,sAttributeName))
		{
			m_InputContext.WriteInputLog("USER", "Has Named Space attribute");
			// Get the value and check to make sure it's not empty
			CTDVString sValue;
			if (pProfile->GetAppNamedSpacedAttribute(sAttributeAppNameSpace,sAttributeName,sValue) && sValue.GetLength() > 0)
			{
				m_InputContext.WriteInputLog("USER", "Has Attribute Value that is not NULL");
				// Update the database with the current value
				CStoredProcedure SP;
				m_InputContext.InitialiseStoredProcedureObject(&SP);
				if (SP.BeginUpdateUser(m_UserID, m_SiteID))
				{
					SP.UserUpdateSiteSuffix(sValue);
					if (SP.DoUpdateUser())
					{
						// Set the current users sitesuffix to the new one
						m_sSiteSuffix = sValue;
					}
				}
			}
		}
		else
		{
			//Blank site suffix to force them to go and get a UDNG
			m_sSiteSuffix = "";
		}
	}
}

void CUser::SetSsoUserName(const TDVCHAR* sSsoUsername)
{
	if (sSsoUsername == NULL)
	{
		return;
	}
	
	m_SsoUsername = sSsoUsername;
}

bool CUser::GetSsoUserName(CTDVString& sSsoUsername)
{
	if (!IsUserSignedIn())
	{
		return false;
	}
	
	sSsoUsername = m_SsoUsername;
	return true;
}

/*********************************************************************************

	bool CUser::GotNoData()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if object has no data, i.e. is totally uninitialised, false
				otherwise.
	Purpose:	Used internally to check the objects current status. If this returns
				true then we do not even have a user ID, cookie or email address
				from which we can get any other data we need.

*********************************************************************************/

bool CUser::GotNoData()
{
	if (m_ObjectStatus == NO_USER_DATA)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CUser::GotUserID()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if we have at least the user ID, false if we do not.
	Purpose:	Used internally to check the objects current status. If this is
				true then we at least have the users ID and can hence get any
				other data we require from the cache/database/wherever.

*********************************************************************************/

bool CUser::GotUserID()
{
	if (m_ObjectStatus == COMPLETE_DATA ||
		m_ObjectStatus == USERID_ONLY)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CUser::GotCookie()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if we have at least the users cookie, false if we do not.
	Purpose:	Used internally to check the objects current status. If this is
				true then we at least have the users cookie and can hence get any
				other data we require from the cache/database/wherever.

*********************************************************************************/

bool CUser::GotCookie()
{
	if (m_ObjectStatus == COMPLETE_DATA ||
		m_ObjectStatus == COOKIE_ONLY)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CUser::GotEmail()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if we have at least the users email address, false if we do not.
	Purpose:	Used internally to check the objects current status. If this is
				true then we at least have the users email address and can hence get
				any other data we require from the cache/database/wherever.

*********************************************************************************/

bool CUser::GotEmail()
{
	if (m_ObjectStatus == COMPLETE_DATA ||
		m_ObjectStatus == EMAIL_ONLY)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CUser::GotCompleteData()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if object has all the data available, false if not.
	Purpose:	Used internally to check the objects current status. If this returns
				true then the object can supply any data onthe user without needing
				to access the cache/database/whatever.

*********************************************************************************/

bool CUser::GotCompleteData()
{
	if (m_ObjectStatus == COMPLETE_DATA)
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	void CUser::SetStatusNoData()

	Author:		Kim Harries
	Created:	01/03/2000
	Modified:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Used internally to set the current status of this object. This
				returns the object to a completely uninitialised state where it
				has no data about any user and cannot supply any without first
				being re-initialised using one of the create methods.

*********************************************************************************/

void CUser::SetStatusNoData()
{
	m_ObjectStatus = NO_USER_DATA;
	m_bDataModified = false;
	m_bGroupsModified = false;
}

/*********************************************************************************

	void CUser::SetStatusUserIDOnly()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Used internally to set the current status of this object. Tells
				the object it has the user ID only and so if requests are made for
				anything else it will have to access cache/database/whatever.

*********************************************************************************/

void CUser::SetStatusUserIDOnly()
{
	m_ObjectStatus = USERID_ONLY;
}

/*********************************************************************************

	void CUser::SetStatusCookieOnly()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Used internally to set the current status of this object. Tells
				the object it has the user cookie only and so if requests are made for
				anything else it will have to access cache/database/whatever.

*********************************************************************************/

void CUser::SetStatusCookieOnly()
{
	m_ObjectStatus = COOKIE_ONLY;
}

/*********************************************************************************

	void CUser::SetStatusEmailOnly()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Used internally to set the current status of this object. Tells
				the object it has the user email only and so if requests are made for
				anything else it will have to access cache/database/whatever.

*********************************************************************************/

void CUser::SetStatusEmailOnly()
{
	m_ObjectStatus = EMAIL_ONLY;
}

/*********************************************************************************

	void CUser::SetStatusCompleteData()

	Author:		Kim Harries
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Used internally to set the current status of this object. Tells the
				object that it has all the data available on this user so can
				respond to all requests without needing the cache/database.

*********************************************************************************/

void CUser::SetStatusCompleteData()
{
	m_ObjectStatus = COMPLETE_DATA;
}

/*********************************************************************************

	bool CUser::FetchData()

	Author:		Kim Harries
	Created:	01/03/2000
	Modified:	16/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Used internally to go and get any missing data.

*********************************************************************************/

bool CUser::FetchData()
{
	if (GotNoData())
	{
		// if we haven't been given a user ID, cookie or email can't get data
		return false;
	}
	else if (GotCompleteData())
	{
		// we already have data
		return true;
	}
	else
	{
		// TODO: deal with caching issues
		// first create a stored procedure object in order to access the database
		CStoredProcedure SP;
		
		bool bSuccess = false;
		// if couldn't get the sotred procedure then fail
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return false;
		}
		if (GotUserID())
		{
			// call the method for getting a users details from their ID
			//If we are requested to create a new user then you also want 
			//to log the user session. Currently, we don't expect to want to
			// log the user's session if m_bFailIfNoMasthead is false. That flag
			// should only be false for a page like InspectUser.

			if (m_bFailIfUserHasNoMasthead)
			{
				// Note that for our purposes, m_bCreateNewUser can also be used
				// to determine whether we want to log the session so it's being sent
				// into this method in the LogUserSession flag. This confused me when
				// I first saw it, but it's correct.
				bSuccess = SP.GetUserFromUserID(m_UserID, m_SiteID, m_bCreateNewUser);
			}
			else
			{
				bSuccess = SP.GetUserFromIDWithOrWithoutMasthead(m_UserID, m_SiteID);
			}

			// Check to see if we're required to create the user in the database.
			if (!bSuccess && m_bCreateNewUser)
			{
				// Only create the user if their email is not in the banned email list
				if (!IsUsersEmailInTheBannedList())
				{
					// Not banned, create the user.
					bSuccess = CreateNewUserInDatabase(SP);
				}
				else
				{
					m_bInBannedEmailList = true;
				}
			}
		}
		else if (GotCookie())
		{
			// call the method for getting a users details from a cookie
			bSuccess = SP.GetUserFromCookie(m_Cookie, m_SiteID);
		}
		else if (GotEmail())
		{
			// TODO: call stored procedure for getting user from their email
			TDVASSERT(false, "CUser::FetchData() called with email only provided - not implemented!");
			bSuccess = false;
		}
		else
		{
			// should never reach this code so something is wrong
			// assert some weirdness and then fail
			TDVASSERT(false, "Reaching code that should not be reached in CUser::FetchData()");
			bSuccess = false;
		}
		// if successful then retrieve each of the fields individually and
		// assign them to the relevant data members in the user object
		if (bSuccess)
		{
			// some of these getters return an error value some do not
			// should all succeed unless a field name has been misstyped or something
			m_UserID = SP.GetIntField("UserID");
			if (m_UserID <= 0)
			{
				bSuccess = false;
			}
			bSuccess = bSuccess && SP.GetField("LoginName", m_LoginName);
			bSuccess = bSuccess && SP.GetField("Username", m_Username);
			bSuccess = bSuccess && SP.GetField("FirstNames", m_FirstNames);
			bSuccess = bSuccess && SP.GetField("LastName", m_LastName);
			bSuccess = bSuccess && SP.GetField("Email", m_Email);
			bSuccess = bSuccess && SP.GetField("BBCUID", m_BBCUID);
			bSuccess = bSuccess && SP.GetField("Cookie", m_Cookie);
			bSuccess = bSuccess && SP.GetField("Password", m_Password);
						
			if (SP.IsNULL("Area"))
				m_Area.Empty();
			else
				bSuccess = bSuccess && SP.GetField("Area", m_Area);
			
			if (SP.IsNULL("Title"))
				m_Title.Empty();
			else
				bSuccess = bSuccess && SP.GetField("Title",m_Title);

			if (SP.IsNULL("SiteSuffix"))
				m_sSiteSuffix.Empty();
			else
				bSuccess = bSuccess && SP.GetField("SiteSuffix",m_sSiteSuffix);
			
			if ( SP.IsNULL("postcode") )
				m_Postcode.Empty();
			else
				bSuccess = bSuccess && SP.GetField("postcode",m_Postcode);

			if ( SP.IsNULL("region") )
				m_Region.Empty();
			else
				bSuccess = bSuccess && SP.GetField("region",m_Region);

			if ( SP.IsNULL("IsModClassMember") )
				m_bIsModClassMember = false;
			else
				m_bIsModClassMember = (SP.GetIntField("IsModClassMember") != 0);

			m_TaxonomyNode = SP.GetIntField("TaxonomyNode");
			m_DateJoined = SP.GetDateField("DateJoined");
			m_DateReleased = SP.GetDateField("DateReleased");
			m_LastUpdated = SP.GetDateField("LastUpdatedDate");
			m_Masthead = SP.GetIntField("Masthead");
			m_SinBin = SP.GetIntField("SinBin");
			m_Status = SP.GetIntField("Status");
			m_Journal = SP.GetIntField("Journal");
			m_Latitude = SP.GetDoubleField("Latitude");
			m_Longitude = SP.GetDoubleField("Longitude");
			m_Active = SP.GetBoolField("Active");
			m_Anonymous = SP.GetBoolField("Anonymous");
			m_PrivateForum = SP.GetIntField("PrivateForum");
			m_PrefSkin = "";
			if (!SP.IsNULL("PrefSkin"))
			{
				bSuccess = SP.GetField("PrefSkin", m_PrefSkin) && bSuccess;
			}
			m_PrefUserMode = SP.GetIntField("PrefUserMode");
			m_PrefForumStyle = SP.GetIntField("PrefForumStyle");
			m_AgreedTerms = SP.GetBoolField("AgreedTerms");
			SP.GetField("PrefXML", m_PrefXML);
			m_PrefStatus = SP.GetIntField("PrefStatus");
			m_TeamID = SP.GetIntField("TeamID");
			m_UnreadPublicMessageCount = SP.GetIntField("UnreadPublicMessageCount");
			m_UnreadPrivateMessageCount = SP.GetIntField("UnreadPrivateMessageCount");
			m_HideLocation = SP.GetIntField("HideLocation");
			m_HideUserName = SP.GetIntField("HideUserName") != 0;
			m_bIsAutoSinBin = SP.GetIntField("AutoSinBin") != 0;
			m_bAcceptSubscriptions = SP.GetIntField("AcceptSubscriptions") != 0;
			m_bBannedFromComplaints = SP.GetIntField("BannedFromComplaints") != 0;
		}

		// now check what groups the user belongs to
		if (bSuccess)
		{
			// fetch the groups from the DB
			bSuccess = SP.FetchUserGroups( m_UserID, m_SiteID );
			TDVASSERT(bSuccess, "FetchUserGroups failed in CUser::FetchData()");
		}

		if (bSuccess)
		{
			CTDVString sValue = "";

			// default to no groups
			// clear the map then fill it with values
			m_Groups.clear();

			// get each row in the dataset and compare the name field to the various
			// group names, and set the appropriate member variable if it matches
			while (!SP.IsEOF())
			{
				SP.GetField("Name", sValue);
				sValue.MakeUpper();
				m_Groups[sValue] = 1;
				SP.MoveNext();
			}
		}

		//get the info from the profile api
		//if we can't get it for whatever reason then just fall through
		//if (bSuccess)
		//{
		//	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
		//	if (pProfile != NULL)
		//	{
		//		pProfile->GetUserProfileValue("postcode",m_Postcode);
		//	}
		//}

		//Get Region from SSO - Could optimise by storing in database.
		if ( bSuccess ) 
		{
			CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
			if (pProfile != NULL && pProfile->AttributeExistsForService("region") )
			{
				pProfile->GetUserProfileValue("region",m_Postcode);
			}
		}

		if (bSuccess)
		{
			bSuccess = SP.GetIsEditorOnAnySite(m_UserID);
			m_bIsEditorOnAnySite = SP.GetIntField("count") > 0;
		}

		// Check to see if the CheckNickNameSet site option is set. If so, do the check for the users nickname
		CSiteOptions* pSiteOptions = m_InputContext.GetSiteOptions();
		if (pSiteOptions != NULL && pSiteOptions->GetValueBool(m_InputContext.GetSiteID(),"General","CheckUserNameSet"))
		{
			// Check the user to see if they need to update their username / nickname
			// If they havn't prompt them for it
			m_bPromptUserName = !HasUserSetUserName();
		}

		// if all was successfull then the user objects status is set to
		// show it has all the data on this user and it has not yet been modified,
		// otherwise it remains as it was
		if (bSuccess)
		{
			SetStatusCompleteData();
			m_bDataModified = false;
			m_bGroupsModified = false;


			CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
			CTDVDateTime dLastUpdated;
			CTDVString sLastUpdated;

			m_InputContext.WriteInputLog("USER", "Check for synch");

			if (m_syncByDefault && pProfile != NULL && pProfile->AttributeExistsForService("lastupdatedcpp"))
			{
				pProfile->GetUserProfileValue("lastupdatedcpp",sLastUpdated);
				dLastUpdated.SetFromString(sLastUpdated);

				dLastUpdated.GetAsString(sLastUpdated);
				m_InputContext.WriteInputLog("USER", "Users last updated from ID - " + sLastUpdated);
				m_LastUpdated.GetAsString(sLastUpdated);
				m_InputContext.WriteInputLog("USER", "Users last updated from DNA - " + sLastUpdated);

				if (m_LastUpdated < dLastUpdated)
				{
					SynchroniseWithProfile(true);
				}
				else
				{
					//Just check for the SiteSuffix being Null or the same as the display name,
					//if on a kids site that needs UDNG and there is already one in identity
					m_InputContext.WriteInputLog("USER", "Check for UDNG name from existing site");
					CheckForExistingUDNGifSiteSuffixIsNullOrDisplayName();
				}
			}
		}
		TDVASSERT(bSuccess, "CUser::FetchData() unsuccessfull");
		return bSuccess;
	}
}

/*********************************************************************************

	bool CUser::CreateNewUserInDatabase(SP)

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		pSP - pointer to a stored procedure if you want the results
					  from the sp_finduserfromid, NULL otherwise
	Outputs:	-
	Returns:	-
	Purpose:	creates a new user in the database. This is because the profile
				api has the user as logged into the service but we have yet to 
				create them in DNA. Our userid's and profile api's userids are 
				synced up. So we just take their id and put it into our database
				firstly making sure that the user doesn't exist already.
				When successfull the user data is populated and away we go.

*********************************************************************************/

bool CUser::CreateNewUserInDatabase(CStoredProcedure& SP)
{
	if (!IsUserSignedIn())
	{
		return false;
	}

	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();

	if (pProfile == NULL)
	{
		return false;
	}

	CTDVString sFirstName;
	CTDVString sLastName;
	
	if (pProfile->AttributeExistsForService("firstname") && !m_HideUserName)
	{
		pProfile->GetUserProfileValue("firstname",sFirstName);
	}
	
	if (pProfile->AttributeExistsForService("lastname") && !m_HideUserName)
	{
		pProfile->GetUserProfileValue("lastname",sLastName);
	}

	m_SsoUsername = pProfile->GetUserName();
	m_Username = m_SsoUsername;

	CTDVString sDisplayName = "";
	if (pProfile->AttributeExistsForService("displayname") && pProfile->GetUserProfileValue("displayname",sDisplayName))
	{
		if (sDisplayName.GetLength() > 0)
		{
			m_Username = sDisplayName;
		}
	}
	
	m_IdentityUserID = pProfile->GetUserId();

	pProfile->GetUserProfileValue("email",m_Email);

	// Get the legacy SSO UserID
	CTDVString sLegacySSOID;
	if (pProfile->AttributeExistsForService("legacy_user_id"))
	{
		pProfile->GetUserProfileValue("legacy_user_id",sLegacySSOID);
	}
	int iLegacySSOID = 0;
	if (!sLegacySSOID.IsEmpty())
	{
		iLegacySSOID = atoi(sLegacySSOID);
	}
	else
	{
		//Creating a new user copies the current SSO details.
		m_bIsSynchronised = true;
	}

	// Call the stored procedure with the details
	if (!SP.CreateNewUserFromIdentityID(m_IdentityUserID, iLegacySSOID, m_SsoUsername, m_Email, m_InputContext.GetSiteID(), sFirstName, sLastName, m_Username))
	{
		return false;
	}



	return true;
}

/*********************************************************************************

	bool CUser::IsUsersEmailInTheBannedList()

		Author:		Mark Howitt
		Created:	09/07/2007
		Returns:	True if the users email is in the list, false if not.
		Purpose:	Checks to see if the users email is listed in the banned email list.
		NOTE:		If the method experiences any problems, it sets the user to be banned
					but will not add them to the banned list.

*********************************************************************************/
bool CUser::IsUsersEmailInTheBannedList()
{
	// Set the user to be banned by default
	bool bIsBanned = true;

	// Connect to the Profile Database and get the users email if not supplied
	if (!IsUserSignedIn())
	{
		// Can't do anything if we're not signed in.
		return true;
	}

	// Check to make sure we've got the current users cookie
	bool bValidCookie = m_Cookie.GetLength() >= 64;
	if (!bValidCookie)
	{
		if (m_InputContext.GetSiteUsesIdentitySignIn(m_InputContext.GetSiteID()))
		{
			// Try to get the cookie form the inputcontext
			bValidCookie = m_InputContext.GetCookieByName("IDENTITY",m_Cookie);
		}
		else
		{
			// Try to get the cookie form the inputcontext
			bValidCookie = m_InputContext.GetCookieByName("SSO2-UID",m_Cookie);
		}
	}

	// First check to see if the users cookie is cached in the banned cookie list
	if (bValidCookie)
	{
		// The next bit should only be done by one thread only, so go into a critical section
		EnterCriticalSection(&m_criticalsection);

		for (int i = 0; i < m_sBannedCookies.GetCount(); i++)
		{
			// Check to see if the cookie is already in the banned cookie list
			if (m_Cookie == m_sBannedCookies[i])
			{
				// Yes, return now
				LeaveCriticalSection(&m_criticalsection);
				return true;
			}
		}

		LeaveCriticalSection(&m_criticalsection);
	}

	// Get a pointer to the current profile connection
	CTDVString sEmailToCheck;
	CProfileConnection* pProfile = m_InputContext.GetProfileConnection();
	if (pProfile == NULL)
	{
		// Problems. Leave the critical section and return
		SetDNALastError("CUser","IsEmailInBannedList","NULL profile pointer!");
		return true;
	}

	// Check to see if the email attribute exists for this service
	if (!pProfile->AttributeExistsForService("email"))
	{
		// Nothing to check against. Return false for not in the list
		return false;
	}

	// Get the users email
	if (!pProfile->GetUserProfileValue("email",sEmailToCheck))
	{
		SetDNALastError("CUser","IsEmailInBannedList","Failed getting email from profile API!");
		return true;
	}

	// Check to see if the user has an email address
	if (sEmailToCheck.IsEmpty())
	{
		// No EMail, can't check against the list. Return false for not in the list
		return false;
	}

	// Now check the database to see if the email exists in the banned list.
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP) || !SP.IsEmailInBannedList(sEmailToCheck))
	{
		// Problems. Leave the critical section and return
		SetDNALastError("CUser","IsEmailInBannedList","Failed checking database for banned email!");
		return true;
	}

	// Get the result form the stored procedure
	bIsBanned = (SP.GetIntField("IsBanned") > 0);

	// Check the banned flag and see if the cookie is valid
	if (bIsBanned && bValidCookie)
	{
		// The user is banned, so add the cookie to the banned cookie list
		// The next bit should only be done by one thread only, so go into a critical section
		EnterCriticalSection(&m_criticalsection);

		m_sBannedCookies.Add(m_Cookie);

		LeaveCriticalSection(&m_criticalsection);
	}

	return bIsBanned;
}

int CUser::GetUserID()
{
	// if we have the user ID then get it and return true
	// else do nothing and return false
	if (GotNoData())
	{
		// got nothing, so were are no one
		return 0;
	}
	else if (GotUserID())
	{
		// already have the ID
		return m_UserID;
	}
	else
	{
		// fetch data first then set the ID
		if (FetchData())
		{
			return m_UserID;
		}
		else
		{
			return 0;
		}
	}
}

int CUser::GetMasthead()
{
	if (GotNoData())
	{
		return 0;
	}
	else if (!GotCompleteData())
	{
		if (!FetchData())
		{
			return 0;
		}
	}
	return m_Masthead;
}

bool CUser::QueueForModeration(int iSiteID, const CTDVString& sUserName )
{
	// Check to see if we've got any data
	if (GotNoData())
	{
		// We don't have any data on this user!
		return false;
	}
	else
	{
		// Setup a Stored Procedure and call the Queue Nickname method
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		return SP.QueueNicknameForModeration(GetUserID(), iSiteID, sUserName );
	}
}

bool CUser::IsUserInGroup(const TDVCHAR* pGroupName)
{
	// Make sure the passed in group name is upper case else this will fail!!!
	CTDVString sUpperCase = pGroupName;
	sUpperCase.MakeUpper();
	return (1 == m_Groups[sUpperCase]);
}

bool CUser::SetSiteID(int iSiteID)
{
	m_SiteID = iSiteID;
	return true;
}





bool CUser::SetIsEditor(bool bIsEditor)
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetIsEditor(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
// if all okay then now add the username to the list of details to update
//	if (bSuccess)
//	{
//		bSuccess = m_pStoredProcedure->UserUpdateIsScout(bIsScout);
//	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
//		m_IsScout = bIsScout;
		m_Groups["EDITOR"] = bIsEditor;
//		m_bDataModified = true;
		m_bGroupsModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;

}

bool CUser::GetAgreedTerms()
{
	return m_AgreedTerms;
}

bool CUser::SetAgreedTerms(bool bAgreedTerms)
{
	bool bSuccess = InitUpdate();
	bSuccess = bSuccess && m_pStoredProcedure->UserUpdateAgreedTerms(bAgreedTerms);
	if (bSuccess)
	{
		m_AgreedTerms = bAgreedTerms;
		m_bDataModified = true;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CUser::InitUpdate()

	Author:		Jim Lynn
	Created:	15/08/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if succeeded, false if failed
	Purpose:	Init function common to all the update calls.

*********************************************************************************/

bool CUser::InitUpdate()
{
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::InitUpdate(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the username to the list of details to update
	return bSuccess;
}

/*********************************************************************************

	bool CUser::GetIsPostingAllowed()

	Author:		Jim Lynn
	Created:	21/09/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if user is allowed to post, false otherwise
	Purpose:	Determines if the user is allowed to post to this site

*********************************************************************************/

bool CUser::GetIsPostingAllowed()
{
	return GetAgreedTerms() && !GetIsBannedFromPosting();
}

bool CUser::CreateFromCacheText(const TDVCHAR* pCacheText)
{
	return false;
}

bool CUser::CreateCacheText(CTDVString* pCacheText)
{
	if (pCacheText == NULL)
	{
		return false;
	}
	// simply store member variables in order on a seperate line before
	// the XML representation of the tree
/*
	*pCacheText << m_UserID << "\n";
	*pCacheText << m_LoginName;
	*pCacheText << m_Username;
	*pCacheText << m_FirstNames;
	CTDVString		m_LastName;
	CTDVString		m_Email;
	CTDVString		m_Cookie;
	CTDVString		m_BBCUID;
	CTDVString		m_Password;
	CTDVDateTime	m_DateJoined;
	CTDVDateTime	m_DateReleased;
	int				m_Masthead;
	int				m_Journal;
	int				m_SinBin;
	int				m_Status;
	double			m_Latitude;
	double			m_Longitude;
	bool			m_Active;
	bool			m_Anonymous;
	// groups that they belong to
	map<CTDVString, int>	m_Groups;
	// current preferences
	CTDVString		m_PrefSkin;
	int				m_PrefUserMode;
	int				m_PrefForumStyle;
	int				m_PrefForumThreadStyle;
	int				m_PrefForumShowMaxPosts;
	bool			m_PrefReceiveWeeklyMailshot;
	bool			m_PrefReceiveDailyUpdates;

	int				m_SiteID;
	bool			m_AgreedTerms;
*/
	return false;
}

bool CUser::GetIsPreModerated()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
        return m_PrefStatus == CUserStatuses::PREMODERATED;
	}
}

bool CUser::GetIsPostModerated()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return m_PrefStatus == CUserStatuses::POSTMODERATED;
	}
}

bool CUser::GetIsBannedFromPosting()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
        return m_PrefStatus == CUserStatuses::RESTRICTED;
	}
}

bool CUser::GetIsInBannedEmailList()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return m_bInBannedEmailList;
	}
}

bool CUser::GetIsBannedFromComplaints()
{
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return m_bBannedFromComplaints;
	}
}

bool CUser::GetIsBBCStaff()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return IsUserInGroup("BBCSTAFF");
	}
}

/*********************************************************************************

	bool CUser::GetIsSuperuser()

	Author:		Igor Loboda
	Created:	2/4/2002
	Inputs:		-
	Outputs:	-
	Returns:	true if user is a superuser. false otherwize or if object is not 
				initialized
	Purpose:	detects if user is superuser.

*********************************************************************************/
bool CUser::GetIsSuperuser()
{
	// if we have no data the object has not been initialised
	if (GotNoData())
	{
		return false;
	}
	else
	{
		return m_Status == 2;
	}
}

bool CUser::SetPrefXML(const TDVCHAR *pXML)
{
	TDVASSERT(pXML != NULL, "CUser::UpdatePrefXML(...) called with NULL pXML");
	// first check that user has been initialised
	if (GotNoData())
	{
		// if not then log an error and return false
		TDVASSERT(false, "CUser::SetPrefSkin(...) called on uninitialised user object");
		return false;
	}
	else if (!GotCompleteData())
	{
		// make sure we have the data for this user before attempting to modify it
		if (!FetchData())
		{
			return false;
		}
	}
	// now must keep track of what data has been changed by keeping the member
	// stored procedure up to date
	bool bSuccess = true;
	// if SP has not been created yet then create it and start the update process up
	if (m_pStoredProcedure == NULL)
	{
		m_pStoredProcedure = m_InputContext.CreateStoredProcedureObject();
		if (m_pStoredProcedure == NULL)
		{
			bSuccess = false;
		}
		else
		{
			bSuccess = m_pStoredProcedure->BeginUpdateUser(m_UserID, m_SiteID);
		}
	}
	// if all okay then now add the skin preference to the list of details to update
	if (bSuccess)
	{
		bSuccess = m_pStoredProcedure->UserUpdatePrefXML(pXML);
	}
	// finally modify the actual data member and change the data modified flag
	if (bSuccess)
	{
		// all okay so set the member variable and set the data modified flag
		m_PrefXML = pXML;
		m_bDataModified = true;
	}
	// could delete the SP if something has failed at this point ???
	return bSuccess;
}

bool CUser::GetPrefXML(CTDVString *oXML)
{
	*oXML = m_PrefXML;
	return true;
}

bool CUser::GetPrivateForum(int* piPrivateForum)
{
	*piPrivateForum = m_PrivateForum;
	return true;
}

/*********************************************************************************

	bool CUser::HasEntryLockedForModeration(int ih2g2ID)

	Author:		Kim Harries (moved from CArticleEditForm by Markn)
	Created:	26/02/2001 (moved 16/09/2003)
	Inputs:		ih2g2ID = the id of the entry in question
	Outputs:	-
	Returns:	true if this user currently has the entry locked for moderation
	Purpose:	Determines if user has the entry locked for moderation

*********************************************************************************/

bool CUser::HasEntryLockedForModeration(int ih2g2ID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CUser::HasEntryLockedForModeration(...)");
		return false;
	}

	bool bLocked = false;

	// call the SP to check if the user has this entry locked
	bLocked = SP.UserHasEntryLockedForModeration(GetUserID(), ih2g2ID);
	return bLocked;
}

/*********************************************************************************

	bool CUser::GetIsImmuneFromModeration(int ih2g2id)

	Author:		Mark Neves 
	Created:	12/11/2003
	Inputs:		ih2g2id = h2g2id of article subject to moderation decision
	Outputs:	-
	Returns:	true if this user is immune from moderating this article, false otherwise
	Purpose:	

*********************************************************************************/

bool CUser::GetIsImmuneFromModeration(int ih2g2id)
{
	// If the user has special editing privileges, the user is also immune from
	// moderation
	return HasSpecialEditPermissions(ih2g2id);
}


/*********************************************************************************

	bool CUser::HasSpecialEditPermissions(int ih2g2id)

	Author:		Mark Neves
	Created:	17/11/2003
	Inputs:		ih2g2id = the article in question
	Outputs:	-
	Returns:	true if yes, false otherwise
	Purpose:	Does user have special editing powers?  Call this to find out
				If user is an editor or super user, the answer is yes regardless of ih2g2id
				If user is a moderator, it's yes if they have it locked for moderation

*********************************************************************************/

bool CUser::HasSpecialEditPermissions(int ih2g2id)
{
	return (GetIsEditor() || (GetIsModerator() && HasEntryLockedForModeration(ih2g2id)));
}


/*********************************************************************************

	bool CUser::GetMatchingUserAccounts(CTDVString& sXML)

		Author:		Mark Howitt
        Created:	23/07/2004
        Inputs:		-
        Outputs:	sXML - The string that will hold the XML fro this operation
        Returns:	true if ok, false if not
        Purpose:	Tries to find matching user accounts by matching either the firstnames
					Last name OR email.

*********************************************************************************/
bool CUser::GetMatchingUserAccounts(CTDVString& sXML)
{
	// Setup the storedprocedure and the XML Builder
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	bool bOk = SP.GetMatchingUserAccounts(m_FirstNames,m_LastName,m_Email);
	if (bOk)
	{
		// Now get the info from the results
		InitialiseXMLBuilder(&sXML,&SP);
		bOk = bOk && OpenXMLTag("MATCHING-ACCOUNTS");

		// Zip through the results
		while (bOk && !SP.IsEOF())
		{
			bOk = bOk && OpenXMLTag("MATCH");
			bOk = bOk && AddDBXMLIntTag("USERID");
			bOk = bOk && AddDBXMLTag("USERNAME");
			bOk = bOk && AddDBXMLTag("EMAIL");
			bOk = bOk && AddDBXMLTag("FIRSTNAMES",NULL,false);
			bOk = bOk && AddDBXMLTag("LASTNAME",NULL,false);
			bOk = bOk && AddDBXMLIntTag("ACTIVE");
			bOk = bOk && AddDBXMLDateTag("DATEJOINED",NULL,true,true);
			bOk = bOk && AddDBXMLIntTag("STATUS");
			bOk = bOk && AddDBXMLIntTag("ANONYMOUS");
			bOk = bOk && AddDBXMLIntTag("SINBIN",NULL,false);
			bOk = bOk && AddDBXMLTag("LOGINNAME",NULL,false);
			bOk = bOk && CloseXMLTag("MATCH");
			SP.MoveNext();
		}

		// finally close the tag
		bOk = bOk && CloseXMLTag("MATCHING-ACCOUNTS");
	}

	// return the verdict!
	return bOk;
}

/*********************************************************************************

	bool CUser::IsUsersEMailVerified(bool& bVerified)

		Author:		Mark Howitt
        Created:	21/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if it is verified, false if not
        Purpose:	Checks to make sure the users email is verified and safe to use.

*********************************************************************************/
bool CUser::IsUsersEMailVerified(bool& bVerified)
{
	// Get the required info
	return m_InputContext.IsUsersEMailVerified(bVerified);
}

/*********************************************************************************

	bool CUser::IsSynchronised()

		Author:		Martin Robb
        Created:	14/11/2006
        Inputs:		-
        Outputs:	-
        Returns:	True if user instance has been synchronised.
        Purpose:	Optimisation To prevnt user being unnecesarily synchronised.
					Ripley::HandleRequest() will synchronise user if s_sync specified.
					Synchronisation will effectively occur when new user is created.
					SSoBuilder attempts to Synchronise user too.

*********************************************************************************/
bool CUser::IsSynchronised()
{
	return m_bIsSynchronised;
}

bool CUser::GetIsAutoSinBin()
{
	return m_bIsAutoSinBin;
}

bool CUser::GetIsEditorOnAnySite()
{
	return m_bIsEditorOnAnySite;
}
/*********************************************************************************

	bool CUser::GetSitesUserIsEditorOfXMLWithEditPermissionCheck()

		Author:		James Conway
        Created:	05/12/2006
        Inputs:		iUserID - User to get editor permissions of.
					sSiteUserIsEditorOf - <EDITABLESITES> xml string. Lists the sites the user is editor of. 
					iFirstSiteID - The first SiteID in the results set. 
					iSiteID - SiteID to check the existance of in user's editor permissions. 
        Outputs:	sSiteUserIsEditorOf - <EDITABLESITES> xml string. Lists the sites the user is editor of. 
					iFirstSiteID - The first SiteID in the results set. 
        Returns:	True if user has permission to edit iSiteID, false if not. 
        Purpose:	Get sites user is editor of and checks whether user has edit permission on SiteID passed in. 

*********************************************************************************/
bool CUser::GetSitesUserIsEditorOfXMLWithEditPermissionCheck(int iUserID, CTDVString& sSitesUserIsEditorOf, int& iFirstSiteID, int iSiteID)
{
	std::vector<int> vSiteIDsUserEditorOf;
	GetSitesUserIsEditorOf(iUserID, vSiteIDsUserEditorOf);

	bool bUserHasEditPermission = false; 
	// Now create the XML TODO: AND CHECK EDIT PERMISSIONS
	CTDVString sSiteData = ""; 

	sSitesUserIsEditorOf << "<EDITABLESITES>";
	for ( std::vector<int>::iterator iter = vSiteIDsUserEditorOf.begin(); iter != vSiteIDsUserEditorOf.end(); ++iter )
	{
		sSiteData.Empty(); 	
		sSiteData = m_InputContext.GetSiteAsXML(*iter, 1);
		sSitesUserIsEditorOf << sSiteData; 

		if (*iter == iSiteID)
		{
			bUserHasEditPermission = true; 
		}
	}
	sSitesUserIsEditorOf << "</EDITABLESITES>";

	return bUserHasEditPermission; 
}
bool CUser::GetSitesUserIsEditorOfXML(int iUserID, CTDVString& sSitesUserIsEditorOf, int& iFirstSiteID)
{
	std::vector<int> vSiteIDsUserEditorOf;
	bool bOk = GetSitesUserIsEditorOf(iUserID, vSiteIDsUserEditorOf);

	iFirstSiteID = vSiteIDsUserEditorOf[0];

	// Now create the XML
	CTDVString sSiteData = ""; 

	sSitesUserIsEditorOf << "<EDITABLESITES>";
	for ( std::vector<int>::iterator iter = vSiteIDsUserEditorOf.begin(); iter != vSiteIDsUserEditorOf.end(); ++iter )
	{
		sSiteData.Empty(); 	
		sSiteData = m_InputContext.GetSiteAsXML(*iter, 1);
		sSitesUserIsEditorOf << sSiteData; 
	}
	sSitesUserIsEditorOf << "</EDITABLESITES>";

	return bOk; 
}

bool CUser::GetSitesUserIsEditorOf(int iUserID, std::vector<int>& vSiteIDsUserEditorOf)
{
	// Get and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// Report the error!
		return SetDNALastError("CUser::GetSitesUserIsEditorOf","FailedToInitialiseStoredProcedure","Failed to Initialise Stored Procedure!!!");
	}

	// Now call the procedure and check to make sure we got something
	if (!SP.GetSitesUserIsEditorOf(iUserID))
	{
		return SetDNALastError("CUser::GetSitesUserIsEditorOf","FailedToGetSitesUserIsEditorOf","Failed to get sites user is editor of!!!");
	}

	// Get the values from the stored procedure
	while (!SP.IsEOF())
	{
		vSiteIDsUserEditorOf.push_back(SP.GetIntField("SiteID"));
		SP.MoveNext();
	}

	return true; 
}

/*********************************************************************************

	bool CUser::HasUserSetUserName()

		Author:		Mark Howitt
		Created:	13/12/2007
		Inputs:		-
		Outputs:	-
		Returns:	True if the user has set their nickname, false if not
		Purpose:	Checks to see if the user has set their nickname yet. It also
					takes into account of the nickname moderation queue.

*********************************************************************************/
bool CUser::HasUserSetUserName()
{
	bool bIsSet = true;

	// First check to see if the nickname/username is set to U#########
	CTDVString checkName = "U";
	checkName << m_UserID;

	if (m_Username.CompareText(checkName))
	{
		// Check to see if they have an entry in the nickname moderation queue
		bIsSet = false;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (SP.IsNickNameInModerationQueue(m_UserID))
		{
			// Get the first result
			if (SP.FieldExists("Status") && !SP.IsNULL("Status"))
			{
				int status = SP.GetIntField("Status");
				bIsSet = (status != 4);
			}
		}
	}

	return bIsSet;
}