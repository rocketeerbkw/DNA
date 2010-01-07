#pragma once
#include "TDVString.h"
#include <list>

/*
Used for describing cookies which will be returned from the server to client
Basically to use, create and initialize an instance of this class
And pass it to the CWholePage::RedirectWithCookie member or alternatively 
Create a new member (called for e.g.) CWholePage::SetCookie which should
Create the cookie-setting xml fragment and insert into page's xml
The class CHTMLTransformer::Output does the actual cookie processing 
And the CGI class does the actual streaming
*/
class CXMLCookie
{
protected:
	CTDVString m_sCookieName;
	CTDVString m_sCookieValue;
	CTDVString m_sCookieDomain;
	bool m_bIsSessionCookie;

public:
	//encapsulated list container
	typedef std::list<CXMLCookie> CXMLCookieList;
	//encapsulated iterator 
	typedef std::list<CXMLCookie>::iterator iterator;
public:
	CXMLCookie(void);
	virtual ~CXMLCookie(void);
	CXMLCookie(const CXMLCookie& rhs);
	CXMLCookie(const CTDVString& sCookieName, const CTDVString& sCookieValue, const CTDVString& sCookieDomain, const bool bIsSessionCookie);
public:
	//get accessors
	CTDVString GetCookieName( ) const;
	CTDVString GetCookieValue( ) const;
	CTDVString GetCookieDomain( ) const;
	bool GetIsSessionCookie(  ) const;
	//set accessors
	void SetCookieName( const CTDVString sCookieName);
	void SetCookieValue( const CTDVString sCookieValue);
	void SetCookieDomain( const CTDVString sCookieDomain);
	void SetIsSessionCookie( const bool bIsSessionCookie);
public:
	//operators which are neccessary for STL 
	bool operator==(const CXMLCookie& rhs) const;
	bool operator<(const CXMLCookie& rhs) const;
	bool operator>(const CXMLCookie& rhs) const;
	CXMLCookie& operator=(const CXMLCookie& rhs);
};
