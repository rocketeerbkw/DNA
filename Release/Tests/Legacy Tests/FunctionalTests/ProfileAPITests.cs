using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Text;
using BBC.Dna;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test the profile api when trying to set the current user via their cookie.
    /// Uses the URL to signin and signout before setting the user
    /// </summary>
    //[TestClass]
    class ProfileAPITestsValidUserLoginUsingURLSignInSignOut
    {
        /// <summary>
        /// Start the test by setting up the test bench.
        /// Make sure that the user is logged into the actionnetwork site via the URL
        /// </summary>
        [TestInitialize]
        private void LoginProfileAPITestUser()
        {
            new DnaTestURLRequest("h2g2").SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.PROFILETEST);
        }

        /// <summary>
        /// Test that we can set the current user via a valid cookie.
        /// Check that the user is sihned in and logged in.
        /// </summary>
        [TestMethod]
        private void TestValidUserIsLoggedIn()
        {
            Console.WriteLine("TestValidUserIsLoggedIn");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                testProfile.TrySetUserViaCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                Assert.IsTrue(testProfile.IsUserLoggedIn, "User should be logged in.");
            }
        }
/*
        /// <summary>
        /// Finally make sure that the user is logged out and signed out of SSO after all the tests have been run.
        /// </summary>
        [TestCleanup]
        public void LogoutProfileAPITestUser()
        {
            new DnaTestURLRequest("actionnetwork").SignOutUserFromSSO();
        }
*/
        /// <summary>
        /// Helper function for writting timming info to the logs
        /// </summary>
        /// <param name="message"></param>
        public void LogTimerEvent(string message)
        {
            System.Diagnostics.Trace.WriteLine(message);
        }
    }

    /// <summary>
    /// Test class for testing that we can log a user in when they are only signed in
    /// </summary>
    [TestClass]
    public class ProfileAPITestsValidUserLoginUsingLogUserInLogUserOut
    {
        /// <summary>
        /// Start the test bench off with the user logged out
        /// </summary>
        [TestInitialize]
        public void LogoutProfileAPITestUserSetUp()
        {
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                testProfile.TrySetUserViaCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                if (testProfile.IsUserLoggedIn)
                {
#if DEBUG
                    testProfile.LogoutUser();
#endif
                }
            }
        }

        /// <summary>
        /// Test that we can log the user into the service when they are only signed in
        /// </summary>
        [TestMethod]
        public void TestValidUserIsLoggedIn()
        {
            Console.WriteLine("TestValidUserIsLoggedIn");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                testProfile.TrySetUserViaCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                if (testProfile.IsUserLoggedIn)
                {
                    Assert.Fail("User should be signed in, but not logged in!");
                }
                else
                {
                    testProfile.LoginUser();
                }
            }
        }

        /// <summary>
        /// Finally make sure we leave the tests with the user logged out.
        /// </summary>
        [TestCleanup]
        public void LogoutProfileAPITestUserTearDown()
        {
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                testProfile.TrySetUserViaCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                if (testProfile.IsUserLoggedIn)
                {
#if DEBUG
                    testProfile.LogoutUser();
#endif
                }
            }
        }
    }

    /// <summary>
    /// Test class that checks to make sure that we get the correct errors when we try to log a user into a service that they are not registered for
    /// </summary>
    [TestClass]
    public class ProfileAPITestsValidUserLoginToServiceThatTheyAreNotRegisteredWithUsingLogUserInLogUserOut
    {
        /// <summary>
        /// Test to make sure that we get the correct errors when we try to log a user into a service that they have not regiostered with.
        /// </summary>
        [TestMethod]
        public void TestValidUserIsLoggedIn()
        {
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("mbcbbc");
                testProfile.TrySetUserViaCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                Assert.IsFalse(testProfile.IsUserLoggedIn, "User should signed in, but not logged in!");
                Assert.IsFalse(testProfile.LoginUser(), "User should not be able to log into a service they are not registered with!");
            }
        }
    }
    
    /// <summary>
    /// Test class to test the creation of a profileapi instance and various operations.
    /// </summary>
    [TestClass]
    public class ProfileAPITestsServiceAndCookies
    {
        /// <summary>
        /// Test to make sure that we can create an instance of the ProfileAPI object
        /// </summary>
        [TestMethod]
        public void TestCreateProfile()
        {
            Console.WriteLine("TestCreateProfile");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                using (DnaIdentityWebServiceProxy.ProfileAPI testProfile = new DnaIdentityWebServiceProxy.ProfileAPI(inputContext.GetConnectionDetails["ProfileRead"].ConnectionString))
                {
                }
            }
        }

        /// <summary>
        /// Tests to make sure that the set service function works correcly
        /// </summary>
        [TestMethod]
        public void TestSetService()
        {
            Console.WriteLine("TestSetService");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
            }
        }

        /// <summary>
        /// Test to make sure that we can set a service and then set the current user via a valid cookie
        /// </summary>
        [TestMethod]
        public void TestSetUserViaValidCookie()
        {
            Console.WriteLine("TestSetUserViaValidCookie");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                testProfile.TrySetUserViaCookie("3420578cf0c5a180d2de517ce172cf15a1d75962e850da37b546589db499466a00");
            }
        }

        /// <summary>
        /// Test to make sure that we can set the service and correcly handle setting the current user via a cookie which is not of valid length.
        /// </summary>
        [TestMethod]
        public void TestSetUserViaInValidLengthCookie()
        {
            Console.WriteLine("TestSetUserViaInValidLengthCookie");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                Assert.IsFalse(testProfile.TrySetUserViaCookie("3420578cfe517ce172cf15a1d75962e850da37b546589db499466a00"), "Cookie does not meet minimum length criteria");
            }
        }

        /// <summary>
        /// Check to make sure that we can set the service and correctly handle setting the current user via an invalid cookie.
        /// </summary>
        [TestMethod]
        public void TestSetUserViaInValidCookie()
        {
            Console.WriteLine("TestSetUserViaInValidCookie");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                Assert.IsFalse(testProfile.TrySetUserViaCookie("c3cf768b729af00abf51566a3135b5296ab87ca8c8e02ae7c50628dd40d0193900"), "The invalid cookie was excepted and did not raise an error!");
            }
        }

        /// <summary>
        /// Check to make sure that we can set the service and correctly handle setting the current user via an valid cookie with validation mark > 1 charater.
        /// </summary>
        [TestMethod]
        public void TestSetUserViaInValidCookieWithValidationMarkGreaterThanOneCharacter()
        {
            Console.WriteLine("TestSetUserViaInValidCookieWithValidationMarkGreaterThanOneCharacter");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                Assert.IsTrue(testProfile.TrySetUserViaCookie("a3bff62be225c0fa2f51161a31a54569caf83c6858900ac7c5d6183da0007949010"), "Failed to handle a valid cookie with validation mark greater than one char!");
            }
        }

        /// <summary>
        /// Check to make sure that we can handle logging in of invalid users
        /// </summary>
        [TestMethod]
        public void TestInvalidUserLoggedIn()
        {
            Console.WriteLine("TestInvalidUserLoggedIn");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                Assert.IsFalse(testProfile.TrySetUserViaCookie("c3cf768b729af00abf51566a3135b5296ab87ca8c8e02ae7c50628dd40d0193900"), "The invalid cookie was excepted and did not raise an error!");
            }
        }

        /// <summary>
        /// Check to make sure that we throw the correct exceptions when we try to check if a user is logged in without setting the service or setting the user first.
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(ProfileAPIServiceException), "Service not set")]
        public void TestLoggedInStatusForNonSetUserAndServiceNotSet()
        {
            Console.WriteLine("TestLoggedInStatusForNonSetUserAndServiceNotSet");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                bool loggedin = testProfile.IsUserLoggedIn;
            }
        }

        /// <summary>
        /// Check to make sure we handle trying to check if the user is logged in before setting the user
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(ProfileAPIUserException), "User must be signed in before logging in")]
        public void TestLoggedInStatusForNonSetUserAndServiceSet()
        {
            Console.WriteLine("TestLoggedInStatusForNonSetUserAndServiceSet");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                Assert.IsFalse(testProfile.IsUserLoggedIn);
            }
        }
    }

    /// <summary>
    /// Test class for testing that we can get user attributes from SSO
    /// </summary>
    [TestClass]
    public class ProfileAPITestsGetUserValue
    {
        /// <summary>
        /// Now check to make sure that we can set the service, set the user, make sure they are logged in and then get the users email address
        /// </summary>
        [TestMethod]
        public void TestGetUserValue()
        {
            Console.WriteLine("TestGetUserValue");
            // Create the profile connection first
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy testProfile = inputContext.GetCurrentSignInObject;
                testProfile.SetService("h2g2");
                testProfile.TrySetUserViaCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                testProfile.LoginUser();
                Assert.IsTrue(testProfile.IsUserLoggedIn, "User is not logged in and they should be.");
                Assert.AreEqual(testProfile.GetUserAttribute("email"), "james.conway@bbc.co.uk");
            }
        }
    }

    /// <summary>
    /// This class tests the connections for the profile api
    /// </summary>
    [TestClass]
    public class ProfileAPIConnectionTests
    {
        /// <summary>
        /// Tests to make sure that we can use a single instance of the profile api for multiple calls.
        /// It calls profile api serveal times, closing the connection in between.
        /// </summary>
        [TestMethod]
        public void TestMultipleCallsForSingleInstanceOfProfileAPIClosingConnections()
        {
            Console.WriteLine("TestMultipleCallsForSingleInstanceOfProfileAPIClosingConnections");
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy profileAPI = inputContext.GetCurrentSignInObject;
                int firstMinAge = -1;
                int firstMaxAge = -1;
                profileAPI.GetServiceMinMaxAge("h2g2",ref firstMinAge, ref firstMaxAge);
                profileAPI.CloseConnections();

                int secondMinAge = -1;
                int secondMaxAge = -1;
                profileAPI.GetServiceMinMaxAge("h2g2",ref secondMinAge, ref secondMaxAge);
                profileAPI.CloseConnections();

                Assert.AreEqual(firstMaxAge,secondMaxAge,"The max ages do not match for the same call!");
                Assert.AreEqual(firstMinAge,secondMinAge,"The min ages do not match for the same call!");
            }
        }

        /// <summary>
        /// Tests to make sure that we can use a single instance of the profile api for multiple calls.
        /// It calls profile api serveral time, without closing the connection in between
        /// </summary>
        [TestMethod]
        public void TestMultipleCallsForSingleInstanceOfProfileAPINotClosingConnections()
        {
            Console.WriteLine("TestMultipleCallsForSingleInstanceOfProfileAPINotClosingConnections");
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                IDnaIdentityWebServiceProxy profileAPI = inputContext.GetCurrentSignInObject;
                int firstMinAge = -1;
                int firstMaxAge = -1;
                profileAPI.GetServiceMinMaxAge("h2g2",ref firstMinAge, ref firstMaxAge);

                int secondMinAge = -1;
                int secondMaxAge = -1;
                profileAPI.GetServiceMinMaxAge("h2g2",ref secondMinAge, ref secondMaxAge);

                Assert.AreEqual(firstMaxAge,secondMaxAge,"The max ages do not match for the same call!");
                Assert.AreEqual(firstMinAge,secondMinAge,"The min ages do not match for the same call!");
            }
        }
    }
}
