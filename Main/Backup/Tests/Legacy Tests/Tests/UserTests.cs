using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestUtils;

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
            using (FullInputContext fullinputcontext = new FullInputContext(TestUserAccounts.GetProfileAPITestUserAccount.UserName))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie(TestUserAccounts.GetProfileAPITestUserAccount.Cookie, TestUserAccounts.GetProfileAPITestUserAccount.SecureCookie);
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
            Assert.AreEqual(_testUser.Email, "james.conway@bbc.co.uk");
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

            using (FullInputContext fullinputcontext = new FullInputContext(TestUserAccounts.GetProfileAPITestUserAccount.UserName))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie(TestUserAccounts.GetProfileAPITestUserAccount.Cookie, TestUserAccounts.GetProfileAPITestUserAccount.SecureCookie);
                User tempUser = new User(fullinputcontext);
                tempUser.CreateUser(_testUser.UserID);
                Assert.AreEqual(tempUser.UserName, newUserName);
            }

            //change back to old user name
            _testUser.BeginUpdateDetails();
            _testUser.SetUsername(originalUserName);
            _testUser.UpdateDetails();

            using (FullInputContext fullinputcontext = new FullInputContext(TestUserAccounts.GetProfileAPITestUserAccount.UserName))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie(TestUserAccounts.GetProfileAPITestUserAccount.Cookie, TestUserAccounts.GetProfileAPITestUserAccount.SecureCookie);
                User tempUser = new User(fullinputcontext);
                tempUser.CreateUser(_testUser.UserID);
                Assert.AreEqual(tempUser.UserName, originalUserName);
            }
            

            Console.WriteLine("After Test6CheckUserNameChange");
        }
    }
}
