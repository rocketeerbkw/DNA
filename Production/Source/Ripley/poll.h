// Header file for CPoll
// James Pullicino Jan 05

#pragma once
#include "XMLObject.h"
#include <map>
#include <string>

using namespace std;


/*********************************************************************************
		Author:		James Pullicino
        Created:	06/01/2005
        Inputs:		DB Context, poll id
        Purpose:	Base class to perform core poll functions. Derive from
					this class to create new poll type and customize behaviour of 
					poll
*********************************************************************************/
class CPoll : public CXMLObject
{

public:
	// Constructor
	CPoll(CInputContext& inputContext, int nPollID = -1);
	virtual ~CPoll() {};
	
	// Poll Types
	enum PollType
	{
		POLLTYPE_UNKNOWN		= 0,
		POLLTYPE_CLUB			= 1,
		POLLTYPE_NOTICE			= 2,
		POLLTYPE_CONTENTRATING	= 3
	};

	// User status types
	enum UserStatus
	{
		USERSTATUS_UNKNOWN		= 0,	// Unknown state
		USERSTATUS_LOGGEDIN		= 1,	// User was logged in when he voted
		USERSTATUS_HIDDEN		= 2,	// User wishes his vote to remain hidden
	};

	// Item Types
	enum ItemType
	{
		ITEMTYPE_UNKNOWN		= 0,	// Beware of the unknown
		ITEMTYPE_ARTICLE		= 1,	// Article
		ITEMTYPE_CLUB			= 2,	// Club
		ITEMTYPE_NOTICE			= 3		// Notice (a thread of a noticeboard)
	};

	// Error Codes
	enum ErrorCode
	{
		ERRORCODE_UNSPECIFIED		= 0,	// Unknown/Unspecified error
		ERRORCODE_UNKNOWNCMD		= 1,	// Unknown cmd param
		ERRORCODE_BADPARAMS			= 2,	// Invalid parameters (e.g. missing cmd/s_redirectto param)
		ERRORCODE_BADPOLLID			= 3,	// Invalid poll id
		ERRORCODE_NEEDUSER			= 4,	// User required for operation (User not logged in)
		ERRORCODE_ACCESSDENIED		= 5,	// Access denied/operation not allowed
		ERRORCODE_AUTHORCANNOTVOTE	= 6,	// Page author cannot vote
	};

public:	

	// Poll results
	typedef map<string, string> COptionAttributes;
	typedef std::map<int, COptionAttributes> optionsMap;
	class resultsMap : public std::map<UserStatus, optionsMap>
	{
		public:
			void Add(const UserStatus& userStatus, int iResponse, 
				const char* pKey, const char* pValue);
	};

	// Poll stats
	typedef std::map<std::string, std::string> statisticsMap;
	statisticsMap	m_Stats;

	// Properties of single poll, including results of poll
	struct PollProperties
	{
		PollProperties(int nPollID, PollType pollType=POLLTYPE_UNKNOWN)
			: m_PollID(nPollID), m_PollType(pollType)
		{
			m_CurrentUserVote=-1;
		}

		int			m_PollID;			// PollID
        PollType	m_PollType;			// Type of Poll
		resultsMap	m_Results;			// Results of poll voting
		int			m_CurrentUserVote;	// Current user vote
	};


	// Attributes for a link between a poll and an item
	struct PollLink
	{
		PollLink(int nPollID, bool bHidden)
			: m_PollProperties(nPollID), m_Hidden(bHidden)
		{}

		// Shortcuts
		const int GetPollID() const { return m_PollProperties.m_PollID; };
		const int GetPollType() const { return m_PollProperties.m_PollType; }
		const resultsMap & GetPollResults() const { return(m_PollProperties.m_Results); }
		resultsMap & GetPollResults() { return(m_PollProperties.m_Results); }
		const int GetCurrentUserVote() const { return m_PollProperties.m_CurrentUserVote; }
		int & GetCurrentUserVote() { return (m_PollProperties.m_CurrentUserVote); }

		// Data

		PollProperties	m_PollProperties;		// Properties of poll
		bool			m_Hidden;				// Hidden flag
	};

	//virtual CPoll* Clone() = 0;


// Overridables: Override these functions to customise behaviour
protected: 

	// Adds Error XML to object
	virtual bool AddErrorElement(const TDVCHAR* pTagName, ErrorCode nErrorCode, const TDVCHAR* pDebugString = 0);

	// Load results of a single poll
	virtual bool LoadPollResults(resultsMap & pollResults, int & nUserVote);

	// Load user vote.
	virtual bool LoadCurrentUserVote(int & nUserVote);

	// Make XML for single poll
	virtual bool MakePoll(const PollLink & pollLink);

	// Dispatch command
	virtual bool DispatchCommand(const CTDVString & sCmd);

	// Called when DispatchCommand does not recognise sAction
	virtual bool UnhandledCommand(const CTDVString & sCmd);
	
	// Register a Vote (Must be implemented)
	// Return false to wipe out XML and populate it with <ERROR code = 0>
	virtual bool Vote() = 0;

	// Remove a vote. Must be implemented
	virtual bool RemoveVote() = 0;

	// Returns poll type. Must be implemented
	virtual const PollType GetPollType() const = 0;

	// returns xml root element
	virtual const CTDVString GetRootElement() const;

	// Creates poll entry in the database
	virtual bool CreatePoll();

	// Create link entity in database
	virtual bool LinkPoll(int nItemID, ItemType nItemType);

	// Hides/Unhides poll
	virtual bool HidePoll(bool bHide, int nItemID=0,  CPoll::ItemType nItemType=ITEMTYPE_UNKNOWN);

	// Load poll properties
	// Removed: at the moment, the only 'property' we load is the poll type, which
	// is known through the GetPollType() function, so there is no need to load it
	// from the database
	// virtual bool LoadPollProperties(PollProperties & pollProperties);

protected:

	int m_nPollID;	// PollID. Access using GetPollID()

	int m_nResponseMax;
	int m_nResponseMin;

	bool m_bAllowAnonymousRating;

	// Instruct builder to redirect URL after returning from ProcessParamsFromBuilder
	void SetRedirectURL(const CTDVString & sRedirectURL)
	{ m_sRedirectURL = sRedirectURL; }

private:	// Internal data

	// Redirect URL
	CTDVString	m_sRedirectURL;

public:	// Interface

	// Make XML for poll
	bool MakePollXML(const PollLink & pollLink, bool bIncludePollResults=true);

	// Process builder params
	bool ProcessParamsFromBuilder(CTDVString & sRedirectURL);

	// Get PollID. Can return -1 if poll is not yet created 
	const int GetPollID() const { return m_nPollID; }

	// Create new poll
	bool CreateNewPoll();

	// Link a poll with an article/club etc...
	bool LinkPollWithItem(int nItemID, CPoll::ItemType nItemType);

	// Add poll statistic to be included in <statistics> tag
	void SetPollStatistic(const char * szName, const char * szValue);

	//Set Response Range.
	void SetResponseMinMax( int iResponseMin = -1, int iResponseMax = - 1);

	//Set Allow Anonymous Rating.
	void SetAllowAnonymousRating( bool bAllowAnonymousRating = false);
};

struct POLLDATA
{
	CPoll::PollType m_Type;
	int				m_ResponseMin;
	int				m_ResponseMax;

	bool			m_AllowAnonymousRating;

	POLLDATA() :  m_Type(CPoll::POLLTYPE_UNKNOWN), m_ResponseMin(-1), m_ResponseMax(-1), m_AllowAnonymousRating(false) {}
};