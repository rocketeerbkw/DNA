// SSOBuilder.h: interface for the CSSOBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SSOBUILDER_H__AEC4EB11_4ED6_48B6_8BBC_16AF33D5753B__INCLUDED_)
#define AFX_SSOBUILDER_H__AEC4EB11_4ED6_48B6_8BBC_16AF33D5753B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

#define POSTCODER_COOKIENAME "BBCpostcoder"
#define POSTCODER_IDENTIFIER "PST"

class CSSOBuilder : public CXMLBuilder  
{
public:
	CSSOBuilder(CInputContext& inputContext);
	virtual ~CSSOBuilder();

	virtual bool Build(CWholePage* pPage);

protected:

	bool ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);
	bool UserNewRegister( bool bFirstTime, bool bCreateXML = true, bool bSynchronise = true );	
	bool UserSignedOut();
	bool UserSaidNotMe();
	bool UserChangedDetails();
	bool UserLoggedOut();
	bool LoginErrorMessage(int iSsoResult);
	bool VerifyPostcode();
	bool GetPostcodeFromUser();
	bool GetPostcodeFromCookie(CTDVString& sPostcode);
	bool UnknownAction();

protected:

	bool GetPassThrough(CTDVString& sPassThrough,CTDVString& sURLParams);

protected:

	CWholePage* m_pPage;
};

#endif // !defined(AFX_SSOBUILDER_H__AEC4EB11_4ED6_48B6_8BBC_16AF33D5753B__INCLUDED_)
