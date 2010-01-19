/******************************************************************************
class:	CProfanity

This class manages the PROFANITY xml element. It will be able to generate: 
	- Itself only, no sub-elements

Example usage:
	CProfanity profanity;
	profanity.SetId(1);
	profanity.SetName("butt");
	profanity.SetAction(2);
	AddInside("MYNODE", profanity.GetAsXML());

	profanity.Clear();
	profanity.Populate(5);
	AddInside("MYNODE", profanity.GetAsXML());

Design decisions:
	- Apart from Populate() this class doesn't actually run any stored procedures 
	  itself, so it doesn't have a method to pass a reference to one in and let 
	  it extract the values. Instead the values are passed in by the object that 
	  did run the SP.
	- This object is used for more than just generating XML, hence the Get...()
	  methods
	- Ratings are stored and manipulated as numbers which make them easy to work 
	  with and compare, except (see point below)
	- Numeric ratings in the database are presented as strings in XML. The reason for 
	  this is so that the numbers don't get hard-coded into the XSL. Also words 
	  like 'reedit' and 'premod' are more meaningful in the XSL than 1 and 2
******************************************************************************/

#ifndef _PROFANITY_H_INCLUDED_
#define _PROFANITY_H_INCLUDED_

#include <vector>
#include "InputContext.h"
#include "XMLError.h"
#include "TDVString.h"

// Make sure that this matches up with ratingToString[]
//
#define PROFANITY_RATING_PREMOD 1
#define PROFANITY_RATING_POSTMOD 2
#define PROFANITY_RATING_REPLACE 3
#define PROFANITY_RATING_REEDIT 4

class CProfanity : public CXMLError
{
public:
	CProfanity(CInputContext& inputContext);
	~CProfanity();
	CProfanity& operator=(const CProfanity& profanity);
	void Clear();

	bool Populate(const int iProfanityId);
	CTDVString GetAsXML();

	// Accessor methods
	//
	void SetId(const int iId);
	void SetName(const CTDVString& sName);
	void SetRating(const int iRating);
	void SetReplacement(const CTDVString& sReplacement);
	void SetGroupId(const int iGroupId);
	void SetSiteId(const int iSiteId);
	int GetId();
	const TDVCHAR* GetName();
	int GetRating();
	const TDVCHAR* GetReplacement();
	int GetGroupId();
	int GetSiteId();

	// Methods and members for translating numeric ratings
	// to string and back
	//
	static const CTDVString ratingToString[];
	static const int iMaxRating;
	static bool GetRatingAsString(const int iRating, CTDVString& sRating);
	static bool GetRatingAsInt(const TDVCHAR* sRating, int& iRating);

private:
	CInputContext& m_InputContext;
	int m_iId, m_iRating, m_iGroupId, m_iSiteId;
	CTDVString m_sName, m_sReplacement;

	// If groupid and siteid have not been set they will be 0, meaning global group!
	// Avoid this by using a flag which will leave them out if false
	//
	bool m_bGroupAndSiteSet;
};




/*********************************************************************************
inline void CProfanity::SetId(const int iId)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanity::SetId(const int iId)
{
	m_iId = iId;
}

/*********************************************************************************
inline void CProfanity::SetName(const CTDVString& sName)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanity::SetName(const CTDVString& sName)
{
	m_sName = sName;
}

/*********************************************************************************
inline void CProfanity::SetRating(const int iRating)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanity::SetRating(const int iRating)
{
	m_iRating = iRating;
}

/*********************************************************************************
inline void CProfanity::SetReplacement(const CTDVString& sReplacement)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanity::SetReplacement(const CTDVString& sReplacement)
{
	m_sReplacement = sReplacement;
}

/*********************************************************************************
inline void CProfanity::SetGroupId(const int iGroupId)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanity::SetGroupId(const int iGroupId)
{
	m_bGroupAndSiteSet = true;
	m_iGroupId = iGroupId;
}

/*********************************************************************************
inline void CProfanity::SetSiteId(const int iSiteId)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanity::SetSiteId(const int iSiteId)
{
	m_bGroupAndSiteSet = true;
	m_iSiteId = iSiteId;
}

/*********************************************************************************
inline int CProfanity::GetId()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Returns internal value
*********************************************************************************/

inline int CProfanity::GetId()
{
	return m_iId;
}

/*********************************************************************************
inline const TDVCHAR* CProfanity::GetName()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Returns internal value
*********************************************************************************/

inline const TDVCHAR* CProfanity::GetName()
{
	return m_sName;
}

/*********************************************************************************
inline int CProfanity::GetRating()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Returns internal value
*********************************************************************************/

inline int CProfanity::GetRating()
{
	return m_iRating;
}

/*********************************************************************************
inline const TDVCHAR* CProfanity::GetReplacement()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Returns internal value
*********************************************************************************/

inline const TDVCHAR* CProfanity::GetReplacement()
{
	return m_sReplacement;
}

/*********************************************************************************
inline int CProfanity::GetGroupId()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Returns internal value
*********************************************************************************/

inline int CProfanity::GetGroupId()
{
	return m_iGroupId;
}

/*********************************************************************************
inline int CProfanity::GetSiteId()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Returns internal value
*********************************************************************************/

inline int CProfanity::GetSiteId()
{
	return m_iSiteId;
}

#endif
