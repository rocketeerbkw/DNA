#ifndef PROFILE_H
#define PROFILE_H

#include "WarningPeriod.h"
#include "ProfileApiContext.h"
#include <MySqlDBConnection.h>
#include <DBCursor.h>
#include <map>
#include <ProfileErrorMessage.h>
#include <ProfileCodeRef.h>
#include <assert.h>
#include <UserProfile.h>
#include <Attribute.h>
#include <UserStatus.h>
#include <UserToUserRequest.h>
#include <MiscUt.h>
#include <AdminMessage.h>
#include <UserService.h>
#include <AdminLogMessage.h>
#include <Service.h>
#include <Constants.h>		//must be included the last
#include <Dll.h>

class CUsers;
class CUsersMap;
class CUserId;

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


/*********************************************************************************
class CProfileApi : public CProfileApiContext
Author:		Igor Loboda
Purpose:	an api to profile db
			<docit_asis>
			Defines:
			
			#define CANLOGIN								1
			#define CANTLOGIN_NOT_VALID						3
			#define CANTLOGIN_MANDATORY_MISSING				4
			#define CANTLOGIN_NOT_VALIDATED					5
			#define CANTLOGIN_BANNED						6
			#define CANTLOGIN_PASSBLOCK						7
			#define CANTLOGIN_SQBLOCK						8
			#define CANTLOGIN_GLOBAL_AGREEMENT				9
			#define CANTLOGIN_SERVICE_AGREEMENT				10
			#define CANTLOGIN_NOT_REGISTERED				11
			#define CANTLOGIN_CHANGE_PASSWORD				12
			#define CANLOGIN_LOGGEDIN						13
			#define CANTLOGIN_INCORRECT_AUTHENTICATION_TYPE	14
			#define CANTLOGIN_TOO_YOUNG						15
			#define CANTLOGIN_TOO_OLD						16


			#define PASSCONSTR_SPACE		1			//password has space(s) in it
			#define PASSCONSTR_SHORT		2			//password is too short
			#define PASSCONSTR_FORBIDDEN	3			//some forbidden word is used as a password
			#define PASSCONSTR_OK			4			//password is fine
			</docit_asis>
*********************************************************************************/

class DllExport CProfileApi : public CProfileApiContext
{
	protected:			
		typedef map<CStr, CWarningPeriod> CWarningTime;
		CWarningTime m_WarningTime;
		
	private:
		static const char* m_CantLoginStr[CANTLOGIN_MAX + 1];

	public:
		static const char* const ATTR_BYPASS_AGE_CHECK;
		static const char* const ATTR_AGE;
		static const char* const ATTR_DOB;

	protected:

	
	public:

		//			
		//Init
		//
			
		CProfileApi();
		~CProfileApi();
		static CProfileApi* Create();
		static void Destroy(CProfileApi* pApi);
		static const char* GetVersion();


		bool Initialise(const char* configpath = DEFAULT_CONFIG_FILE);	
		bool IsAllSet();
		bool IsAllSetAdmin();
		

		//
		//Profile attributes
		//
			
		bool GetUserProfile(CUserProfile& profile);
		bool GetUserProfile(const char* pAttributes, CUserProfile& profile);
		bool GetUserProfileValue(const char* pAttributeName, CProfileValue& profileValue);
		int RemovePrivateValues(CUserProfile& profile);
		
		
		//
		//Other user profile - this is the user calling context do not authentification information
		//for (user name - password pair or the cookie), but has user name only. For such
		//users only information they've marked to be public could be retrieved.
		//None of these methods reveal id of the user. If public value requires
		//validation it will not be returned if not validated yet.
		//

		bool GetOtherUserPublicProfile(const char* pUserName, CUserProfile& profile);
		bool GetOtherUserPublicProfile(const char* pUserName, const char* pAttributes, CUserProfile& profile);
		bool GetOtherUserPublicProfileValue(const char* pUserName, const char* pAttributeName, CProfileValue& profileValue);
		bool GetOtherUserPublicProfile(unsigned long ulId, const char* pAttributes, CUserProfile& profile);
		bool GetOtherUserPublicProfile(unsigned long ulId, CUserProfile& profile);
		bool GetOtherUserPublicProfileValue(unsigned long ulId, const char* pAttributeName, CProfileValue& profileValue);

		
		//
		//other user status
		//
				
		bool GetOtherUserStatus(const char* pUserName, COtherUserStatus& userStatus);
		bool GetOtherUserStatus(unsigned long ulId, COtherUserStatus& userStatus);
		
		
		//
		//Update user profile
		//
		
		bool UpdateUserProfile(CUserProfile& profile);
		bool UpdateUserProfileValue(const CProfileValue& profileValue);
		bool UpdateUserProfileTextValue(const char* pAttributeKey, const char* pNewValue);
		bool UpdateUserProfileBooleanValue(const char* pAttributeKey, bool bNewValue);
		bool UpdateUserProfileDateValue(const char* pAttributeKey, const char* pNewValue);
		bool UpdateUserProfileIntegerValue(const char* pAttributeKey, int iNewValue);
		bool UpdateUserProfileDecimalValue(const char* pAttributeKey, double dNewValue);
		bool UpdateUserProfileValueVisibility(const char* pAttributeKey, bool bPublic);
		bool UpdateUserProfileValueValidity(const char *pAttributeKey, bool bValidated);

		
		//
		//user status
		//
				
		bool GetUserStatus(CUserStatus& userStatus);
		bool GetForceChangePassword(bool& bMustChange);
		bool SetForceChangePassword(bool bMustChange);
		bool UpdateUserOnlineStatus(const char* pOnlineStatusCode);
		bool UpdateUserStatus(const char* pUserStatus);
		bool SetUserGlobalAgreementAccepted(bool bAccepted);
		bool SetUserServiceAgreementAccepted(bool bAccepted);
		bool SetUserServiceAgreementAccepted(const char* pService, bool bAccepted);
		bool GetUserStatus(const char* pServiceName, CUserStatus& userStatus);
		
		
		//
		//login
		//
		
		bool CheckUserCanLogin(unsigned int& uiCanLogin);
		bool LoginUser(unsigned int& uiLoginStatus);
		bool LogoutUser();
		bool CheckUserIsLoggedIn(bool& bIsLoggedIn);
		static const char* GetCantLoginStr(unsigned int uiLoginStatus);
		bool CheckUserCanLogin(const char* pServiceName, unsigned int& uiCanLogin);
		bool LoginUser(const char* pServiceName, unsigned int& uiLoginStatus);
		bool LogoutUser(const char* pServiceName);
		bool CheckUserIsLoggedIn(const char* pServiceName, bool& bIsLoggedIn);
		bool LogoutFromAllServices();
		bool LogoutOnInvalidation(const char* pAttributeName);
		bool LogoutOnMandatoryMissing(const char* pAttributeName);
				
		//
		//user warning level
		//
		
		bool GetUserWarningLevel(CStr& warning, CStr& validToDate);
		bool GetUserWarningLevel(const char* pServiceName, CStr& warning, CStr& validToDate);
		bool SetUserWarningLevel(const char* pWarning, CStr& validToDate);
		bool SetUserWarningLevel(const char* pServiceName, const char* pWarning, CStr& validToDate);
		static bool IsUserBanned(const char* pWarningLevel);
		
				
		//
		//User contact list functions.
		//

		bool AddToUserList(const char* pListNameCode, const char* pContactUserName);
		bool GetUserList(const char* pListName, COtherUsersList& userList);
		bool GetReverseUserList(const char* pListName, COtherUsersList& userList);
		bool DeleteFromUserList(const char* pListName, const char* pContactUserName);


		//
		//user to user request
		//This is used when user want to add another user to his buddy list for example.
		//

		bool SendRequestToUser(const char* pDestUserName, const char* pRequestCode, unsigned long& ulRequestId);
		bool UpdateIncomingRequestStatus(unsigned long ulRequestId, const char* pResponseCode);
		bool GetOutgoingRequests(CUserToUserRequests& requests);
		bool GetIncomingRequests(CUserToUserRequests& requests);
		bool DeleteOutgoingRequest(unsigned long ulRequestId);
		
		
		//
		//Sratchpad. This is temporary storage which application can use for their 
		//purposes. Scratchpad session will be dated and removed automatically by
		//some kind of job. No delete here - cron job should delete all old sessions

		void CreateScratchpadSession(CStr& scratchpadSessionId);
		bool ReadFromScratchpad(const char* pScratchpadSessionId, CStr& sValue);
		bool WriteToScratchpad(const char* pScratchpadSessionId, const char* pValue);


		//
		//Administrator messages
		//This is a lis of offline messages from administrator to users of the service.
		//Each user will get the message sent later that last login date.
		//

		bool GetUserAdminMessages(bool bBeforeLogin, CUserAdminMessages& messages);
		bool GetUserAdminMessages(bool bBeforeLogin, const char* pServiceName, CUserAdminMessages& messages);
		bool GetAdminMessages(bool bUpcoming, CAdminMessages& messages);
		bool SendAdminMessage(const char* pServiceName, const char* pMessage, const char* pActivateDate, 
			const char* pExpireDate);
		bool DeleteAdminMessage(unsigned long ulId);
		

		//
		//Extended user information
		//

		bool GetUserServices(CUserServices& services);
		bool GetUserAdminServices(CUserServices& services);

		
		//
		//bulk logout
		//

		//logout all logged in users (current service) with the given value for the given attribute
		bool BulkLogout(const char* pAttributeKey, const char* pAttributeValue, 
			unsigned long& ulTotalLoggedIn, unsigned long& ulLoggedOut);
		//logout all logged in users (given service) with the given value for the given attribute
		bool BulkLogout(const char* pServiceName, const char* pAttributeKey, const char* pAttributeValue,
			unsigned long& ulTotalLoggedIn, unsigned long& ulLoggedOut);
		
		
		//
		//Admin users
		//

		bool GetAdminUsersList(CUsersList& users);
		bool ChangeAdminPassword(const char* pNewPassword, unsigned int& uiConstraintsCheck);
		
		
		//
		//AdminUser log
		//

		bool AddToAdminUserLog(const char* pMessage);
		bool GetAdminUserLog(CAdminLog& log);

				
		//
		//update user account details
		//

		bool ChangePassword(const char* pNewPassword, unsigned int& uiConstraintsCheck);
		bool ChangeName(const char* pNewName);
		bool GetUserType(CStr& userType);
		bool SetUserType(const char* pUserType);
		bool CheckPasswordConstraints(const char* pPassword, unsigned int& uiResult);
		bool CheckUsernameConstraints(const char* pUsername, unsigned int& uiResult);

				
		//
		//Functions for user blocking/unblocking a user
		//

		bool CheckIsPasswordBlockSet(bool& bIsSet, CStr& dateSet);
		bool CheckIsCompleteBlockSet(bool& bIsSet, CStr& dateSet);
		bool ClearCompleteBlock();
		bool ClearPasswordBlock();
		bool SetCompleteBlock();
		bool SetPasswordBlock();


		//
		//Register new user
		//
		
		bool RegisterUser(unsigned long& ulUserId, CStr& cudId, const char* pUserName, const char* pPassword, 
			const char* pUserType, const char* pUserStatus, bool bGlobalAgreementAccepted, 
			const char* pDateRegistered = NULL);
		bool CheckIsUserNameTaken(const char *pUserName, bool& bTaken);
		bool RegisterAdminUser(unsigned long& ulUserId, CStr& cudId, const char* pUserName, const char* pPassword, 
			const char* pAdminPassword, const char* pAdminUserType, const char* pUserStatus, 
			bool bGlobalAgreementAccepted);
		
				
		//
		//adding a user to a service
		//
		
		
		bool CheckUserIsRegisteredForService(bool& bIsRegistered);
		bool AddUserToService(bool bServiceAgreementAccepted);
		bool DeleteUserFromService();
		
		bool CheckUserIsRegisteredForService(const char* pServiceName, bool& bIsRegistered);
		bool AddUserToService(const char* pServiceName, bool bServiceAgreementAccepted, const char* pDateJoined);
		bool DeleteUserFromService(const char* pServiceName);

		
		//
		//Services administration
		//

		//list of all services
		bool GetServices(CServices& services);
		//service information
		bool GetServiceInfo(const char* pServiceName, CService& service);
		bool UpdateService(const char* pServiceName, const char* pNewName, const char* pDescription, 
			const char* pTag, const char* pUrl, int* pMinAge, int* pMaxAge, bool* pRequiresSecureLogin, 
			const char* pApiAccess, bool* pAutoLogout, bool* pAccessUnregisteredUsers);
		//add new service
		bool AddService(int* pId, const char* pServiceName, const char* pDescription, 
			const char* pTag, const char* pUrl, int iMinAge, int iMaxAge, bool bRequiresSecureLogin, 
			const char* pApiAccess, bool bAutoLogout, bool bAccessUnregisteredUsers);
		bool GetServiceAttribute(const char* pAttributeKey, CServiceAttribute& attribute);
 		bool GetServiceAttributes(CServiceAttributes& attributes);
		bool GetServiceAttribute(const char* pServiceName, const char* pAttributeKey, CServiceAttribute& attribute);
		bool GetServiceAttributes(const char* pServiceName, CServiceAttributes& attributes);
		bool AddServiceAttribute(const char* pServiceName, const char* pAttributeName, 
			int iMandatory, bool bProvider, int iNeesValidation);
		bool DeleteServiceAttribute(const char* pServiceName, const char* pAttributeName);
		bool UpdateServiceAttribute(const char* pServiceName, const char* pAttributeName, 
			int* pMandatory, bool* pbProvider, int* pNeesValidation);

				
		//
		//Attributes administration
		//

		bool GetAttribute(const char* pAttributeKey, CAttribute& attribute);
		bool GetAttributes(CAttributes& attributes);
		bool DeleteAttribute(const char* pAttributeName);
		bool AddAttribute(const char* pAttributeName, const char* pDataType, bool bSystem, 
			bool bLogChange, const char* pDescription);
		bool UpdateAttribute(const char* pAttributeName, const char* pNewAttributeName, 
			bool* pbSystem, bool* pbLogChange, const char* pDescription);
		
		
		//
		//statistics
		//

		bool GetAttributeServices(const char* pAttributeName, CServices& services);
		bool GetUnusedAttributes(CAttributes& attributes);
		
		
		//
		//DNA migration
		//
		
		bool GetDnaUser(const char* pCudId, unsigned long& ulDnaUserId, CStr& dateJoined);

		
		//
		//CUD
		//
		
		bool GetCudUserByName(const char* pUserName, CStr& cudId);
		bool CheckIsCudAccount(const char *pUserName, const char* pCudId, bool& bCudAccount);
		
		//
		//Search for users
		//

		bool GetUserListByAttribute(const char* pAttributeName, const char* pAttributeValue, bool bAllowPartialMatch, CUsersList& userList);
		bool GetUsers(const char* pAttributes, bool bGetStatus, CUsers& users, 
			const char* pCudIdStart, const char* pCudIdEnd);
		bool GetUsers(const char* pAttributes, bool bGetStatus, CUsersMap& users, 
			const char* pCudIdStart, const char* pCudIdEnd);
		bool GetUsersRange(const char* pAttributes, bool bGetStatus, CUsers& users, 
			unsigned long ulUserIdStart, unsigned long ulUserIdEnd);
		bool GetUsersRange(const char* pAttributes, bool bGetStatus, CUsersMap& users, 
			unsigned long ulUserIdStart, unsigned long ulUserIdEnd);
	
	protected:
		bool GetUsers(const char* pAttributes, bool bGetStatus, CUsers* pUsers,
			CUsersMap* pUsersMap, const char* pCudIdStart, const char* pCudIdEnd);
		bool GetUsersRange(const char* pAttributes, bool bGetStatus, CUsers* pUsers,
			CUsersMap* pUsersMap, unsigned long ulUserIdStart, unsigned long ulUserIdEnd);
		void ReadOtherUserStatus(CDBCursor& cursor, COtherUserStatus& status);
		bool ReadUsers(CDBCursor& cursor,  bool bGetProfile, bool bGetStatus, CUsers* pUsers, 
			CUsersMap* pUsersMap);
		void ReadUserId(CDBCursor& cursor, CUserId& userId);
		void ReadUserToUserRequest(CDBCursor& cursor, CUserToUserRequest& request);
		void ReadProfileValue(CDBCursor& cursor, CProfileValue& value);
		void ReadUserServiceInfo(CDBCursor& cursor, CUserService& service);
		void ReadUserStatus(CDBCursor& cursor, CUserStatus& status);
		void ReadAttribute(CDBCursor& cursor, CAttribute& attribute);
		void ReadAdminLog(CDBCursor& cursor, CAdminLogMessage& message);					
		bool IntRegisterUser(unsigned long& ulUserId, CStr& cudId, const char* pUserName, const char* pPassword, 
			const char* pAdminPassword, const char* pUserType, const char* pUserStatus, 
			bool bGlobalAgreementAccepted, const char* pDateRegistered);
		bool CheckAccessToService(const char* pServiceName, unsigned uOtherServicePrivilege, 
			unsigned uAdminServicePrivilege, unsigned long& ulServiceId, bool& bSecure);
		void ReadServiceAttribute(CDBCursor& cursor, CServiceAttribute& attribute);
		void ReadAttributeBase(CDBCursor& cursor, CAttributeBase& attribute);
		bool CheckAllMandatoryFieldsFilled(bool& bAllFilled);
		bool CheckFieldsValidated(bool& bAllValidated);
		bool CheckIsServiceRegisteredForAttribute(unsigned long ulServiceId, 
			const char* pAttributeKey, const char* pServiceName);

	private:
		bool GetServiceAccessToUserProfile(const CService& service, unsigned long ulUserId);
		bool CheckServiceCanAccessUserProfile(const CService& service, unsigned long ulUserId,
			 bool& bCanAccess);
		bool AnalizeAgeRangeCode(int iInRange);
		bool GetAge(unsigned long ulServiceId, const char* pServiceName, unsigned long ulUserId, int& iAge);
		bool CheckUserAgeIsInServiceRange(const CService& service, 
			unsigned long ulUserId, int iAge, int iBypassAgeCheck, int& iInRange);
		bool GetBypassAgeCheck(unsigned long ulServiceId, const char* pServiceName, 
			unsigned long ulUserId, bool& bypassOn);
		bool ValidAccountNameToId(const char* pUserName, unsigned long& ulId);	
		bool IntUpdateUserProfile(unsigned long ulServiceId, const char* pServiceName,
			unsigned long ulUserId, const CUserProfile& profile);
		bool IntGetServiceInfo(const char* pServiceName, unsigned long& ulServiceId, bool& bSecureService);
		bool IntGetServiceAttributes(unsigned long ulServiceId, CServiceAttributes& attributes);
		bool IntGetServiceAttribute(unsigned long ulServiceId, const char* pServiceName, 
			const char* pAttributeKey, CServiceAttribute& attribute);
		bool IntGetUserWarningLevel(unsigned long ulServiceId, const char* pServiceName, CStr& warning, CStr& validToDate);
		bool IntSetUserWarningLevel(unsigned long ulServiceId, const char* pServiceName, 
			const char* pWarning, CStr& validToDate, time_t validToTime = 0);
		bool IntGetUserProfileValue(unsigned long ulServiceId, const char* pServiceName, unsigned long ulUserId,
			const char* pAttributeName, bool bSystemCall, CProfileValue& profileValue, 
			unsigned uSelectType = SELECT_CONSISTENT);
		bool IntUpdateUserProfileValue(unsigned long ulServiceId, const char* pServiceName, 
			unsigned long ulUserId,	bool bSystemCall, const CProfileValue& profileValue);
		bool IntAddUserToService(unsigned long ulServiceId, const char* pServiceName,
			unsigned long ulUserId,	bool bServiceAgreementAccepted, const char* pDateJoined);
		bool IntDeleteUserFromService(unsigned long ulServiceId, unsigned long ulUserId);
		bool IntUpdateUserProfileBooleanValue(const char* pAttributeKey, bool bNewValue, bool bSystemCall);
		bool IntUpdateUserProfileTextValue(const char* pAttributeKey, const char* pNewValue, bool bSystemCall);
		bool IntSendAdminMessage(unsigned long ulServiceId, const char* pMessage, const char* pActivateDate, 
			const char* pExpireDate);
		bool IntBulkLogout(unsigned long ulServiceId, const char* pServiceName, const char* pAttributeKey, 
			const char* pAttributeValue, unsigned long& ulTotalLoggedIn, unsigned long& ulLoggedOut);
		bool IntLogUserEvent(unsigned long ulServiceId, unsigned long ulUserId, const char *pEventCode, 
			const char *pOtherInfo = NULL);
		bool IntLogoutUser(unsigned long ulServiceId, unsigned long ulUserId, const char* pUserEvent);
		bool IntGetUserAdminMessages(bool bBeforeLogin, unsigned long ulServiceId, CUserAdminMessages& messages);
		bool IntCheckAllMandatoryFieldsFilled(unsigned long ulServiceId, bool& bAllFilled);
		bool IntCheckFieldsValidated(unsigned long ulServiceId, bool& bAllValidated);
		bool IntCheckUserIsRegisteredForService(unsigned long ulServiceId, bool& bIsRegistered);
		bool IntGetUserStatus(unsigned long ulServiceId, CUserStatus& userStatus);
		bool IntCheckUserCanLogin(unsigned long ulServiceId, const char* pServiceName,
			bool bSecureService, unsigned int& uiCanLogin);
		bool IntLoginUser(unsigned long ulServiceId, const char* pServiceName,
			bool bSecureService, unsigned int& uiLoginStatus);
		bool IntCheckIsBlockSet(unsigned long ulServiceId, const char* pServiceName,
			const char* pBlock, const char* pBlockTime, bool& bIsSet, CStr& dateSet);
};


#endif
