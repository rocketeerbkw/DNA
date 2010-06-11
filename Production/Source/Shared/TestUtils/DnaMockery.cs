using System;
using System.Collections.Generic;
using System.Text;
using NMock2;
using BBC.Dna;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Data;

namespace Tests
{
	public class DnaMockery
	{
		static Mockery _mockery = new Mockery();
		static DnaConfig _config = new DnaConfig(TestConfig.GetConfig().GetRipleyServerPath());

        public static Mockery CurrentMockery
        {
            get { return _mockery; }
        }

        public static IInputContext CreateInputContext()
        {
            return InitialiseMockInputContext();
        }

		private static IInputContext InitialiseMockInputContext()
		{
			IInputContext context = _mockery.NewMock<IInputContext>();
            Stub.On(context).GetProperty("Diagnostics").Will(Return.Value(SetDefaultDiagnostics(context)));
			Stub.On(context).GetProperty("IsRunningOnDevServer").Will(Return.Value(false));
			return context;
		}

        public static IInputContext CreateDatabaseInputContext()
        {
            IInputContext databaseInputContext = InitialiseMockInputContext();
            DataReaderCreator action = new DataReaderCreator(databaseInputContext);
            Stub.On(databaseInputContext).Method("CreateDnaDataReader").WithAnyArguments().Will(action);
            return databaseInputContext;
        }

        public static IDnaDataReaderCreator CreateDatabaseReaderCreator()
        {
            DnaDataReaderCreator action = new DnaDataReaderCreator(_config.ConnectionString);
            return action;
        }

        /// <summary>
        /// Helper method for creating a mocked default diagnostics object
        /// </summary>
        /// <param name="mockedInput">The context that you want to add the diagnostics mocked object to</param>
        /// <returns>The new mocked Diagnostics object</returns>
        public static IDnaDiagnostics SetDefaultDiagnostics(IInputContext mockedInput)
        {
            IDnaDiagnostics mockedDiag = _mockery.NewMock<IDnaDiagnostics>();
            Stub.On(mockedDiag).Method("WriteTimedSignInEventToLog").Will(Return.Value(null));
            Stub.On(mockedDiag).Method("WriteTimedEventToLog").Will(Return.Value(null));
            Stub.On(mockedDiag).Method("WriteWarningToLog").Will(Return.Value(null));
            Stub.On(mockedDiag).Method("WriteToLog").Will(Return.Value(null));
            Stub.On(mockedInput).GetProperty("Diagnostics").Will(Return.Value(mockedDiag));
            return mockedDiag;
        }

        /// <summary>
        /// Helper method for creating the mocked AllowedURLs object
        /// </summary>
        /// <param name="mockedInput">The context that you want to add the AllowedURLs mocked object to</param>
        /// <returns>The new mocked AllowedURLs object</returns>
        public static IAllowedURLs SetDefaultAllowedURLs(IInputContext mockedInput)
        {
            //IAllowedURLs mockedAllowedURLs = _mockery.NewMock<IAllowedURLs>();
            //Stub.On(mockedAllowedURLs).Method("DoesAllowedURLListContain").Will(Return.Value(true));

            //Stub.On(mockedAllowedURLs).Method("WriteWarningToLog").Will(Return.Value(null));
            //Stub.On(mockedAllowedURLs).Method("WriteToLog").Will(Return.Value(null));
            //Stub.On(mockedInput).GetProperty("AllowedURLs").Will(Return.Value(mockedAllowedURLs));
            //return mockedAllowedURLs;


            AllowedURLs urls = new AllowedURLs();
            urls.LoadAllowedURLLists(mockedInput);

            Stub.On(mockedInput).GetProperty("AllowedURLs").Will(Return.Value(urls));
            return urls;
        }

        /// <summary>
        /// Returns dna config object
        /// </summary>
        public static DnaConfig DnaConfig
        {
            get { return _config; }
        }
        

        /// <summary>
        /// Helper method for creating a mocked site object
        /// </summary>
        /// <param name="mockedInput">The context you want to added the mocked site to</param>
        /// <param name="siteID">The id of the site</param>
        /// <param name="ssoName">The name of the sso service to use</param>
        /// <param name="siteName">The name of the site</param>
        /// <param name="useIdentitySignIn">Set this to true if the site is to use identity as it's sign in system</param>
        /// <param name="identityPolicy">Identity policy</param>
        /// <returns>The new mocked site</returns>
        public static ISite CreateMockedSite(IInputContext mockedInput, int siteID, string ssoName, string siteName, bool useIdentitySignIn, string identityPolicy)
        {
            ISite mockedSite = _mockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("SSOService").Will(Return.Value(ssoName));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(siteID));
            Stub.On(mockedSite).GetProperty("SiteName").Will(Return.Value(siteName));
            Stub.On(mockedSite).GetProperty("UseIdentitySignInSystem").Will(Return.Value(useIdentitySignIn));
            Stub.On(mockedSite).GetProperty("IdentityPolicy").Will(Return.Value(identityPolicy));
            Stub.On(mockedInput).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            return mockedSite;
        }

        /// <summary>
        /// Helper method for creating a mocked profile connection object.
        /// This method defaults to setting the user to be logged in, and having the service set
        /// </summary>
        /// <param name="mockedInput">The context you want to add the mocked connection to</param>
        /// <param name="userID">The users ID</param>
        /// <param name="loginName">The user login name</param>
        /// <param name="bbcUID">The user BBCUID</param>
        /// <param name="email">The users email</param>
        /// <param name="ssoUID">The SSO-UID cookie value for the user</param>
        /// <param name="serviceHasEmail">A flag to state whether or not the service supports emails</param>
        /// <returns>The new mocked profile connection</returns>
        public static IDnaIdentityWebServiceProxy CreateMockedProfileConnection(IInputContext mockedInput, int userID, string loginName, string bbcUID, string ssoUID, string email, bool serviceHasEmail)
        {
            // Create and initialise the mocked profile connection
            IDnaIdentityWebServiceProxy mockedProfile = _mockery.NewMock<IDnaIdentityWebServiceProxy>();
            Stub.On(mockedProfile).Method("SetService").Will(Return.Value(null));
            Stub.On(mockedProfile).GetProperty("IsServiceSet").Will(Return.Value(true));
            Stub.On(mockedProfile).GetProperty("IsSecureRequest").Will(Return.Value(true));

            //Stub.On(mockedProfile).Method("TrySetUserViaCookie").Will(Return.Value(true));
            //Stub.On(mockedProfile).Method("TrySetUserViaCookieAndUserName").Will(Return.Value(true));
            Stub.On(mockedProfile).Method("TrySecureSetUserViaCookies").Will(Return.Value(true));

            Stub.On(mockedProfile).GetProperty("IsUserLoggedIn").Will(Return.Value(true));
            Stub.On(mockedProfile).GetProperty("IsUserSignedIn").Will(Return.Value(true));
            
            Stub.On(mockedProfile).GetProperty("UserID").Will(Return.Value(userID));
            Stub.On(mockedProfile).GetProperty("LoginName").Will(Return.Value(loginName));

            Stub.On(mockedProfile).Method("DoesAttributeExistForService").With("h2g2", "email").Will(Return.Value(serviceHasEmail));
            Stub.On(mockedProfile).Method("GetUserAttribute").With("email").Will(Return.Value(email));

            Stub.On(mockedProfile).Method("DoesAttributeExistForService").With("h2g2", "legacy_user_id").Will(Return.Value(false));
            Stub.On(mockedProfile).Method("GetUserAttribute").With("legacy_user_id").Will(Return.Value(""));

            Stub.On(mockedProfile).Method("DoesAttributeExistForService").With("h2g2", "firstname").Will(Return.Value(false));
            Stub.On(mockedProfile).Method("DoesAttributeExistForService").With("h2g2", "lastname").Will(Return.Value(false));
            Stub.On(mockedProfile).Method("DoesAttributeExistForService").With("h2g2", "displayname").Will(Return.Value(false));
            Stub.On(mockedProfile).Method("DoesAttributeExistForService").With("h2g2", "lastupdated").Will(Return.Value(false));


            Stub.On(mockedProfile).Method("CloseConnections").Will(Return.Value(null));
            Stub.On(mockedProfile).GetProperty("GetCookieValue").Will(Return.Value(""));
            Stub.On(mockedProfile).GetProperty("SignInSystemType").Will(Return.Value(SignInSystem.Identity));

            Stub.On(mockedInput).GetProperty("IsSecureRequest").Will(Return.Value(true));
            Stub.On(mockedInput).SetProperty("IsSecureRequest").To(true);

            // Create the cookies
            DnaCookie cookie = new DnaCookie();
            cookie.Name = "SSO2-UID";
            cookie.Value = ssoUID;

            DnaCookie bbcuidcookie = new DnaCookie();
            cookie.Name = "BBC-UID";
            cookie.Value = bbcUID;

            // Stub the cookie to the context
            Stub.On(mockedInput).Method("GetCookie").With("SSO2-UID").Will(Return.Value(cookie));
            Stub.On(mockedInput).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
            Stub.On(mockedInput).Method("GetCookie").With("BBC-UID").Will(Return.Value(bbcuidcookie));
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY-USERNAME").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("IDENTITY-USERNAME", loginName + "|huhi|7907980"))));
            Stub.On(mockedInput).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));

            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("IDENTITY", loginName + "|huhi|7907980"))));
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY-HTTPS").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("IDENTITY-HTTPS", ""))));

            // Add the mocked profile to the first context
            Stub.On(mockedInput).GetProperty("GetCurrentSignInObject").Will(Return.Value(mockedProfile));

            // Mock the siteoption call for the UseSiteSuffix and AutoGeneratedNames option
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("User", "UseSiteSuffix").Will(Return.Value(false));
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("User", "AutoGeneratedNames").Will(Return.Value(false));

            Stub.On(mockedInput).Method("UrlEscape").WithAnyArguments().Will(Return.Value("Escaped Email"));

            return mockedProfile;
        }

		internal class DataReaderCreator : IAction
		{
            private IInputContext _mockedContext = null;
            public DataReaderCreator(IInputContext mockedContext)
            {
                _mockedContext = mockedContext;
            }

			#region IInvokable Members

			public void Invoke(NMock2.Monitoring.Invocation invocation)
			{
				if (invocation.Method.Name == "CreateDnaDataReader")
				{
                    invocation.Result = new BBC.Dna.Data.StoredProcedureReader(invocation.Parameters[0].ToString(), _config.ConnectionString, _mockedContext.Diagnostics);
				}
			}

			#endregion

			#region ISelfDescribing Members

			public void DescribeTo(System.IO.TextWriter writer)
			{
				writer.Write("Creating data reader");
			}

			#endregion
		}

        /// <summary>
        /// Helper function to add mocking of TryGetParamString to mockedinput context.
        /// Difficult method to mock as returns value as a reference.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="param"></param>
        /// <param name="value"></param>
        public static void MockTryGetParamString(IInputContext context, string param, string value)
        {
            Stub.On(context).Method("TryGetParamString").WithAnyArguments().Will(new TryGetParamStringAction(param, value));
        }

        /// <summary>
        /// Assiss in Mocking TryGetParamString.
        /// Difficult to Mock as it returns value as a reference.
        /// Reference parameter is set with the appropriate mocked value .
        /// Construct the Action with the paramater + value pair. 
        /// eg Stub.On(context).WithAnyArguments().Will(new TryGetParamStringAction(param,value));
        /// </summary>
        internal class TryGetParamStringAction : IAction
        {
            private string _val;
            private string _name;
            #region IInvokable Members

            public TryGetParamStringAction(string name, string val)
            {
                _name = name;
                _val = val;
            }

            public void Invoke(NMock2.Monitoring.Invocation invocation)
            {
                if (invocation.Method.Name == "TryGetParamString")
                {
                    if (invocation.Parameters[0].ToString() == _name)
                    {
                        invocation.Parameters[1] = _val;
                        invocation.Result = true;
                    }
                    else
                    {
                        invocation.Result = false;
                    }
                }
            }

            #endregion

            #region ISelfDescribing Members

            public void DescribeTo(System.IO.TextWriter writer)
            {
                writer.Write("TryGetParamString Mock");
            }

            #endregion
        }
}
}
