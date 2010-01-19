#include "stdafx.h"
#include "xmlcookie.h"

//class used for describing cookies which will be returned from the server to client
//bascially to use, create and initialise an instance of this class
//and pass it to the CWholePage::RedirectWithCookie member  or alternatively 
//create a new member (called for eg)  CWholePage::SetCookie which should
//create the cookie-setting xml fragment and insert into page's xml
//the class  CHTMLTransformer::Output does the actual cookie processing 
//and the CGI class does the actual streaming 
//author DE
//date: 15-02-2005

//constructor
CXMLCookie::CXMLCookie(void)
{
	m_sCookieName =  "";
	m_sCookieValue = "";
	m_sCookieDomain =  "";
	m_bIsSessionCookie = false;
}

//destructor
CXMLCookie::~CXMLCookie(void)
{

}

//constructor
CXMLCookie::CXMLCookie(const CTDVString& sCookieName, const CTDVString& sCookieValue, const CTDVString& sCookieDomain, const bool bIsSessionCookie)
{
	m_sCookieName =  sCookieName;
	m_sCookieValue = sCookieValue;
	m_sCookieDomain =  sCookieDomain;
	m_bIsSessionCookie = bIsSessionCookie;
}

//copy constructor required for STL and function passing
CXMLCookie::CXMLCookie(const CXMLCookie& rhs)
{
	this->m_sCookieName =  rhs.m_sCookieName;
	this->m_sCookieValue = rhs.m_sCookieValue;
	this->m_sCookieDomain =  rhs.m_sCookieDomain;
	this->m_bIsSessionCookie = rhs.m_bIsSessionCookie;
}

//equality operator required for STL
bool CXMLCookie::operator==(const CXMLCookie& rhs) const
{
	return  (( m_sCookieName == rhs.m_sCookieName) && (m_sCookieDomain == rhs.m_sCookieDomain));
}

//less than operator required for STL
bool CXMLCookie::operator<(const CXMLCookie& rhs) const
{
	if ( m_sCookieName == rhs.m_sCookieName)
	{
		return m_sCookieDomain < rhs.m_sCookieDomain;
	}
	else
	{
		return m_sCookieName < rhs.m_sCookieName;
	}
}

//greater than operator required for STL
bool CXMLCookie::operator>(const CXMLCookie& rhs) const
{
	if ( m_sCookieName == rhs.m_sCookieName)
	{
		return m_sCookieDomain > rhs.m_sCookieDomain;
	}
	else
	{
		return m_sCookieName > rhs.m_sCookieName;
	}
}

//assignment operator required for STL
CXMLCookie& CXMLCookie::operator=(const CXMLCookie& rhs)
{
	this->m_sCookieName =  rhs.m_sCookieName;
	this->m_sCookieValue = rhs.m_sCookieValue;
	this->m_sCookieDomain =  rhs.m_sCookieDomain;
	this->m_bIsSessionCookie = rhs.m_bIsSessionCookie;
	return *this;
}

//accessor
CTDVString CXMLCookie::GetCookieName( ) const
{
	return m_sCookieName;
}

//accessor
CTDVString CXMLCookie::GetCookieValue( ) const
{
	return m_sCookieValue;
}

//accessor
CTDVString CXMLCookie::GetCookieDomain( ) const
{
	return m_sCookieDomain;
}

//accessor
bool CXMLCookie::GetIsSessionCookie(  ) const
{
	return m_bIsSessionCookie;
}

//accessor
void CXMLCookie::SetCookieName( const CTDVString sCookieName)
{
	m_sCookieName = sCookieName;
}

//accessor
void CXMLCookie::SetCookieValue( const CTDVString sCookieValue)
{
	m_sCookieValue = sCookieValue;
}

//accessor
void CXMLCookie::SetCookieDomain( const CTDVString sCookieDomain)
{
	m_sCookieDomain  = sCookieDomain;
}

//accessor
void CXMLCookie::SetIsSessionCookie( const bool bIsSessionCookie)
{
	m_bIsSessionCookie = bIsSessionCookie;
}
