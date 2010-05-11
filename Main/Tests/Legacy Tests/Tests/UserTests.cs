using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Tests for the User Class
    /// </summary>
    [TestClass]
    public class UserTests
    {
        User _testUser;

        /// <summary>
        /// Constructor for the User Tests to set up the context for the tests
        /// </summary>
        public UserTests()
        {
            using (FullInputContext fullinputcontext = new FullInputContext(true))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie("6041996|ProfileAPITest|ProfileAPITest|1273497769580|0|35006c522418c48a9a3470cea341b5cd9c9c8a9d28c1", "22f58fef9cd74c0f515b94bfaaa6adf60e395c6f");
                //fullinputcontext.InitUserFromCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                _testUser = (User)fullinputcontext.ViewingUser;
            }
       }

        /// <summary>
        /// Test1CreateUserClassTest
        /// </summary>
        [TestMethod]
        public void Test1CreateUserClassTest()
        {
            Console.WriteLine("Before Test1CreateUserClassTest");
            Assert.IsNotNull(_testUser, "User object created.");
            Console.WriteLine("After Test1CreateUserClassTest");
        }

        /// <summary>
        /// Test2GetUserIDTest
        /// </summary>
        [TestMethod]
        public void Test2GetUserIDTest()
        {
            Console.WriteLine("Before Test2GetUserIDTest");
            Assert.AreEqual(_testUser.UserID, 1090498911);
            Assert.AreEqual(_testUser.RootElement.SelectSingleNode("USER//USERID").InnerText, "1090498911");
            Console.WriteLine("After Test2GetUserIDTest");
        }

        /// <summary>
        /// Test3GetUserNameTest
        /// </summary>
        [TestMethod]
        public void Test3GetUserNameTest()
        {
            Console.WriteLine("Before Test3GetUserNameTest");
            Assert.AreEqual(_testUser.UserName, "ProfileAPITest");
			Assert.AreEqual(_testUser.RootElement.SelectSingleNode("USER//USERNAME").InnerText, "ProfileAPITest");
            Console.WriteLine("After Test3GetUserNameTest");
        }

        /// <summary>
        /// Test4GetUserEmailTest
        /// </summary>
        [TestMethod]
        public void Test4GetUserEmailTest()
        {
            Console.WriteLine("Before Test4GetUserEmailTest");
            Assert.AreEqual(_testUser.Email, "damnyoureyes72+1@googlemail.com");
            Console.WriteLine("After Test4GetUserEmailTest");
        }

        /// <summary>
        /// Test5CheckUserGroups
        /// </summary>
        [TestMethod]
        public void Test5CheckUserGroups()
        {
            Console.WriteLine("Before Test5CheckUserGroups");
            Assert.AreEqual(_testUser.IsAutoSinBin, false);
            Assert.AreEqual(_testUser.IsBanned, false);
            Assert.AreEqual(_testUser.IsEditor, false);
            Assert.AreEqual(_testUser.IsModerator, false);
            Assert.AreEqual(_testUser.IsNotable, false);
            Assert.AreEqual(_testUser.IsPreModerated, false);
            Assert.AreEqual(_testUser.IsReferee, false);
            Assert.AreEqual(_testUser.IsSuperUser, false);
            Console.WriteLine("After Test5CheckUserGroups");
        }

        /// <summary>
        /// Create a request that indicates that a synchronisation is necessary s_sync=1.
        /// Compare the SSO details for a synchronised user against the DNA user values exposed as XML in the Inspect user page.
        /// </summary>
        ///TODO DO WE NEED TO DO THIS RESYSNCH USER TEST NOW!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        [TestMethod, Ignore]
        public void TestUserIsSynchronised()
        {
            Console.WriteLine("Before TestUserIsSynchronised");
            //Log a user in and specify that user may need synchronisation.
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.NORMALUSER);
            request.RequestPage("acs?s_sync=1&skin=purexml");

            //Get SiteId.
            System.Xml.XmlDocument doc = request.GetLastResponseAsXML();
            System.Xml.XmlNode node = doc.SelectSingleNode(@"H2G2/SITE");
            Assert.IsNotNull(node);
            string siteid = node.Attributes["ID"].Value;

            //Check the SSO Details.
            using (FullInputContext fullinputcontext = new FullInputContext(true))
            {
                IDnaIdentityWebServiceProxy testProfile = fullinputcontext.GetCurrentSignInObject;
                testProfile.SetService(request.Currentservice);
                testProfile.TrySetUserViaCookie(request.CurrentCookie);
                Assert.IsTrue(testProfile.IsUserLoggedIn, "User is not logged in and they should be.");

                string ssofirstnames = string.Empty;
                if (testProfile.DoesAttributeExistForService("haveyoursay", "firstname"))
                {
                    ssofirstnames = testProfile.GetUserAttribute("firstname");
                }

                string ssolastname = string.Empty;
                if (testProfile.DoesAttributeExistForService("haveyoursay", "lastname"))
                {
                    ssolastname = testProfile.GetUserAttribute("lastname");
                }

                //Get Details from the database.
                string email = string.Empty;
                string loginname = string.Empty;
                string firstnames = string.Empty;
                string lastname = string.Empty;
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("finduserfromid"))
                {
                    dataReader.AddParameter("@userid", testProfile.UserID)
                    .AddParameter("@siteid", siteid)
                   .Execute();

                    if (dataReader.Read())
                    {
                        email = dataReader.GetString("Email");
                        loginname = dataReader.GetString("loginname");
                        firstnames = dataReader.GetStringNullAsEmpty("firstnames");
                        lastname = dataReader.GetStringNullAsEmpty("lastname");
                    }
                }

                Assert.AreEqual(email, testProfile.GetUserAttribute("email"));
                Assert.AreEqual(loginname, testProfile.LoginName);
                //Assert.AreEqual("", firstnames);
                //Assert.AreEqual("", lastname);

                //Login as editor and request inspectuser page.
                /*request = new DnaTestURLRequest("haveyoursay");
                request.SetCurrentUserEditor();
                request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.EDITOR);
                request.UseEditorAuthentication = true;
                request.RequestPage("InspectUser?userid=" + testProfile.UserID);
                
                //Look at DNA User Values.
                System.Xml.XmlDocument doc = request.GetLastResponseAsXML();
                System.Xml.XmlNode node = doc.SelectSingleNode(@"DNAROOT/INSPECT-USER-FORM/USER/EMAIL-ADDRESS");
                Assert.IsNull(node);
                Assert.AreEqual(node.InnerText,testProfile.GetUserAttribute("email"));

                node = doc.SelectSingleNode(@"DNAROOT/INSPECT-USER-FORM/USER/LOGIN-NAME");
                Assert.IsNull(node);
                Assert.AreEqual(node.InnerText,testProfile.LoginName);

                string ssofirstnames = string.Empty;
                if ( testProfile.DoesAttributeExistForService("haveyoursay","firstnames" ) )
                {
                    testProfile.GetUserAttribute("firstnames");
                }
                node = doc.SelectSingleNode(@"DNAROOT/INSPECT-USER-FORM/USER/FIRSTNAMES");
                Assert.IsNull(node);
                Assert.AreEqual(node.InnerText, ssofirstnames);

                string ssolastname = string.Empty;
                if ( testProfile.DoesAttributeExistForService("haveyoursay","lastname") )
                {
                    ssolastname = testProfile.GetUserAttribute("lastname");
                }
                node = doc.SelectSingleNode(@"DNAROOT/INSPECT-USER-FORM/USER/LASTNAME");
                Assert.IsNull(node);
                Assert.AreEqual(node.InnerText, ssolastname);*/
                
                Console.WriteLine("After TestUserIsSynchronised");
            }
        }

        /// <summary>
        /// Test6CheckUserNameChange
        /// </summary>
        [TestMethod]
        public void Test6CheckUserNameChange()
        {
            Console.WriteLine("Before Test6CheckUserNameChange");
            string originalUserName = _testUser.UserName;

            //change to new user name
            string newUserName = originalUserName + "new";
            _testUser.BeginUpdateDetails();
            _testUser.SetUsername(newUserName);
            _testUser.UpdateDetails();

            using (FullInputContext fullinputcontext = new FullInputContext(true))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie("6041996|ProfileAPITest|ProfileAPITest|1273497769580|0|35006c522418c48a9a3470cea341b5cd9c9c8a9d28c1", "22f58fef9cd74c0f515b94bfaaa6adf60e395c6f");
                //                fullinputcontext.InitUserFromCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                User tempUser = new User(fullinputcontext);
                tempUser.CreateUser(_testUser.UserID);
                Assert.AreEqual(tempUser.UserName, newUserName);
            }

            //change back to old user name
            _testUser.BeginUpdateDetails();
            _testUser.SetUsername(originalUserName);
            _testUser.UpdateDetails();

            using (FullInputContext fullinputcontext = new FullInputContext(true))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie("6041996|ProfileAPITest|ProfileAPITest|1273497769580|0|35006c522418c48a9a3470cea341b5cd9c9c8a9d28c1", "22f58fef9cd74c0f515b94bfaaa6adf60e395c6f");
                //                fullinputcontext.InitUserFromCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");
                User tempUser = new User(fullinputcontext);
                tempUser.CreateUser(_testUser.UserID);
                Assert.AreEqual(tempUser.UserName, originalUserName);
            }
            

            Console.WriteLine("After Test6CheckUserNameChange");
        }
    }
}
