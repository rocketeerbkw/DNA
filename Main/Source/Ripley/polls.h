// polls.h: interface for the CPolls class.
// James Pullicino
// 10th Jan 2005
//////////////////////////////////////////////////////////////////////

#pragma once
#include "XMLObject.h"
#include "Poll.h"

/*********************************************************************************

	class CPolls : public CXMLObject

		Author:		James Pullicino
        Created:	13/01/2005
        Inputs:		Construct with cinputcontext, itemid and itemtype
        Purpose:	Creates XML for a list of polls and performs other poll
					functions. Class could have been called CPollManager

*********************************************************************************/

class CPolls : public CXMLObject
{
public: 
	CPolls(CInputContext& inputContext);
	virtual ~CPolls();

	// Make <POLL-LIST> xml
	bool MakePollList(int nItemID, 
		CPoll::ItemType nItemType);

public:


	// Helper so that loads pollType from database when set to POLLTYPE_UNKNOWN
	CPoll * GetPoll(int nPollID, CPoll::PollType pollType = CPoll::POLLTYPE_UNKNOWN);

protected:	// Internal data

	// List of poll links
	typedef std::vector<CPoll::PollLink> PollLinks;

protected: // Overrideables

	// Load poll links
	virtual bool LoadPollLinks(PollLinks & pollLinks,
		int nItemID, CPoll::ItemType nItemType);

	// Load poll type
	virtual bool LoadPollDetails(int nPollID, CPoll::PollType & pollType, int& nResponseMin, int& nResponseMax, bool& bAllowAnonymousRating);
};

//Could use std::auto_ptr instead.
template <class T> class CAutoDeletePtr
{
public:
	explicit CAutoDeletePtr(T* pPtr) : m_ptr(pPtr) {}
	~CAutoDeletePtr() { delete m_ptr; }

	T* GetPtr() const { return m_ptr; }
private: 
	T*		m_ptr;

	//Disable copy constructor.
	CAutoDeletePtr( const CAutoDeletePtr<T>&) { }

	//Disable assignement.
	CAutoDeletePtr<T> operator =( const CAutoDeletePtr<T>& ) {}
};