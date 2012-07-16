// ProfileConnection.h: interface for the CProfileConnection class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PROFILECONNECTION_H__14D25C59_BE37_44D2_AFDE_883DA08E2FD3__INCLUDED_)
#define AFX_PROFILECONNECTION_H__14D25C59_BE37_44D2_AFDE_883DA08E2FD3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "TDVDateTime.h"
#import "..\Reference DLLs\DnaIdentityWebServiceProxy.tlb" no_namespace

class CProfileConnectionPool;
class CGI;

#define BLOCK_PASSWORD			"password_block"
#define BLOCK_PASSWORD_TIME     "password_block_time"

//UPDATE m_CantLoginStr if you change any of these or add/remove
#define CANLOGIN_UNKNOWN						0	
#define CANLOGIN								1
#define CANLOGIN_STR							"User can login."
#define CANTLOGIN_NOT_VALID						3
#define CANTLOGIN_NOT_VALID_STR					"User can't login. User account is not valid, possibly removed."
#define CANTLOGIN_MANDATORY_MISSING				4
#define CANTLOGIN_MANDATORY_MISSING_STR			"User can't login. Not all mamdatory fields are present."
#define CANTLOGIN_NOT_VALIDATED					5
#define CANTLOGIN_NOT_VALIDATED_STR				"User can't login. Not all fields which require validation are validated."
#define CANTLOGIN_BANNED						6
#define CANTLOGIN_BANNED_STR					"User can't login. User is banned from the service."
#define CANTLOGIN_PASSBLOCK						7
#define CANTLOGIN_PASSBLOCK_STR					"User can't login. User account is blocked (password block)."
#define CANTLOGIN_SQBLOCK						8
#define CANTLOGIN_SQBLOCK_STR					"User can't login. User account is blocked (sq block)."
#define CANTLOGIN_GLOBAL_AGREEMENT				9
#define CANTLOGIN_GLOBAL_AGREEMENT_STR			"User can't login. User has not accepted global agreement."
#define CANTLOGIN_SERVICE_AGREEMENT				10
#define CANTLOGIN_SERVICE_AGREEMENT_STR			"User can't login. User has not accepted service agreement."
#define CANTLOGIN_NOT_REGISTERED				11
#define CANTLOGIN_NOT_REGISTERED_STR			"User can't login. User is not registered for the service."
#define CANTLOGIN_CHANGE_PASSWORD				12
#define CANTLOGIN_CHANGE_PASSWORD_STR			"User can't login. User is required to change his/her password first."
#define CANLOGIN_LOGGEDIN						13
#define CANLOGIN_LOGGEDIN_STR					"User is already logged in."
#define CANTLOGIN_INCORRECT_AUTHENTICATION_TYPE	14
#define CANTLOGIN_INCORRECT_AUTHENTICATION_TYPE_STR	"User can't login. User is adminuser and service is not adminservice or vice versa."
#define CANTLOGIN_TOO_YOUNG						15
#define CANTLOGIN_TOO_YOUNG_STR					"User can't login. User's age is lower than minimum age for the service."
#define CANTLOGIN_TOO_OLD						16
#define CANTLOGIN_TOO_OLD_STR					"User can't login. User's age is greater than maximum age for the service."
#define CANTLOGIN_MAX							16
//UPDATE m_CantLoginStr if you change any of these or add/remove

#define PASSCONSTR_SPACE		1			//password has space(s) in it
#define PASSCONSTR_SHORT		2			//password is too short
#define PASSCONSTR_FORBIDDEN	3			//some forbidden word is used as a password
#define PASSCONSTR_OK			4			//password is fine


#define USERNAME_MAX_LEN	255


#define USERNAME_CONSTR_OK			1			//user name is fine
#define USERNAME_CONSTR_LONG		2			//user name is too long


#define SELECT_FOR_UPDATE	1
#define SELECT_CONSISTENT	2
#define	SELECT_SHARE		3


#define SCRATCHPAD_SESSION_ID_LENGTH	32


#define CALL_SYSTEM		true
#define CALL_APP		false

class CProfileConnection  
{
public:
	CProfileConnection();
	virtual ~CProfileConnection();

	enum eSignInType
	{
		SIT_PROFILEAPI,
		SIT_IDENTITY
	};

	virtual bool InitialiseConnection(CProfileConnectionPool* pOwningPool, bool bUseIdentityWebService, const TDVCHAR* sClientIPAddress, CTDVString sDebugUserID);
	virtual bool IsInitialised();
	virtual bool ReleaseConnection();
	virtual bool SetService(const TDVCHAR* sSiteName, CGI* pCGI);
	virtual const TDVCHAR* GetUserName();
	virtual const TDVCHAR* GetUserId();

	virtual bool UpdateUserProfileValue(const TDVCHAR* sName, const TDVCHAR* sValue);
	virtual bool LoginUser(unsigned int& uiCanLogin);
	virtual bool GetUserProfileValue(const TDVCHAR* sName, CTDVString& sValue);
	virtual const WCHAR* GetUserDisplayNameUniCode();
	virtual bool CheckUserIsLoggedIn(bool& bUserLoggedIn);
	virtual bool IsUserSignedIn(bool& bUserSignedIn);
	virtual bool SetUser(const TDVCHAR* sSsoCookie);
	virtual bool SetUserViaCookieAndUserName(const TDVCHAR* sSsoCookie, const TDVCHAR* sIdentityUserName);
	virtual const TDVCHAR* GetErrorMessage();
	virtual bool SetUser(const TDVCHAR* sUsername, const TDVCHAR* sPassword);
	virtual bool GetCookieValue(bool bRemember, CTDVString& sCookieValue);
	virtual bool AttributeExistsForService(const TDVCHAR* sAttributeName, bool* pbIsMandatory = NULL);
	virtual bool IsUsersEMailValidated(bool& bValidated);
	virtual eSignInType GetSignInType() { return SIT_PROFILEAPI; }

	virtual bool DoesAppNamedSpacedAttributeExist(const TDVCHAR* pAppNameSpace, const TDVCHAR* pAttributeName);
	virtual bool GetAppNamedSpacedAttribute(const TDVCHAR* pAppNameSpace, const TDVCHAR* pAttributeName, CTDVString& sValue);

	virtual const TDVCHAR* GetLastTimings();

	virtual bool GetSecureCookieValue(CTDVString& sSecureCookieValue);
	virtual bool SecureSetUserViaCookies(const TDVCHAR* sCookie, const TDVCHAR* sSecureCookie);
	virtual bool IsSecureRequest(bool& bSecureRequest);

protected:

	CProfileConnectionPool* m_pOwningPool;
	IDnaIdentityWebServiceProxyPtr m_pIdentityInteropPtr;
	CTDVDateTime m_DateCreated;
	CTDVString m_sServiceName;
	CTDVString m_sUserName;
	CTDVString m_sLastIdentityError;
	CTDVString m_sLastTimingInfo;
	CTDVString m_sCookieValue;
	CTDVString m_sSecureCookieValue;
	CTDVString m_sSignInUserId;
	DWORD m_dTimerStart;
	DWORD m_dTimerSplitTime;

	void AddTimingsInfo(const TDVCHAR* sInfo, bool bNewInfo);
};

#endif // !defined(AFX_PROFILECONNECTION_H__14D25C59_BE37_44D2_AFDE_883DA08E2FD3__INCLUDED_)
