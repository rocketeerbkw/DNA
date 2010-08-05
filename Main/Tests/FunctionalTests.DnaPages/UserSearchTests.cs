using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using NUnit.Framework;

namespace FunctionalTests
{
    /// <summary>
    /// Test utility class UserSearchTests.cs
    /// </summary>
    [TestFixture]
    public class UserSearchTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("haveyoursay");

        
        /// <summary>
        /// Set up function
        /// </summary>
        [SetUp]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                _request.UseEditorAuthentication = true;
                _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [Test]
        public void Test01CreateUserSearchPageTest()
        {
            Console.WriteLine("Test01CreateUserSearchPageTest");
            _request.RequestPage("UserSearch?skin=purexml");
            Console.WriteLine("After Test01CreateUserSearchPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2[@TYPE='USERSEARCH']") != null, "The user search page has not been generated!!!");
        }

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [Test]
        public void Test02CreateUserSearchForUserIDPageTest()
        {
            Console.WriteLine("Test02CreateUserSearchForUserIDPageTest");
            _request.RequestPage("UserSearch?usersearchtype=0&userid=1090497224&skin=purexml");
            Console.WriteLine("After Test02CreateUserSearchForUserIDPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2[@TYPE='USERSEARCH']") != null, "The user search page has not been generated!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHTYPE=0]") != null, "The member list does not have the right user type xml!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHID='1090497224']") != null, "The member list does not have the right user search id xml!!!");
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [Test]
        public void Test03CreateUserSearchForEmailPageTest()
        {
            Console.WriteLine("Test03CreateUserSearchForEmailPageTest");
            _request.RequestPage("UserSearch?usersearchtype=1&useremail=damnyoureyes@yahoo.com&skin=purexml");
            Console.WriteLine("After Test03CreateUserSearchForEmailPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2[@TYPE='USERSEARCH']") != null, "The user search page has not been generated!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHTYPE=1]") != null, "The member list does not have the right user type xml!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHEMAIL='damnyoureyes@yahoo.com']") != null, "The member list does not have the right user search email xml!!!");
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [Test]
        public void Test04CreateUserSearchForUserNamePageTest()
        {
            Console.WriteLine("Test04CreateUserSearchForUserNamePageTest");
            _request.RequestPage("UserSearch?usersearchtype=2&username=Damnyoureyes&skin=purexml");
            Console.WriteLine("After Test04CreateUserSearchForUserNamePageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2[@TYPE='USERSEARCH']") != null, "The user search page has not been generated!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHTYPE=2]") != null, "The member list does not have the right user type xml!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHName='Damnyoureyes']") != null, "The member list does not have the right user search name xml!!!");
        }

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [Test]
        public void Test05CreateUserSearchForUserIDAccountPageTest()
        {
            Console.WriteLine("Test05CreateUserSearchForUserIDAccountPageTest");
            _request.RequestPage("UserSearch?usersearchtype=2userid=1090497224&skin=purexml");
            Console.WriteLine("After Test05CreateUserSearchForUserIDAccountPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2[@TYPE='USERSEARCH']") != null, "The user search page has not been generated!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHTYPE=2]") != null, "The member list does not have the right user type xml!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST[@USERSEARCHID='1090497224']") != null, "The member list does not have the right user search id xml!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MEMBERLIST/USERACCOUNTS/USERACCOUNT[@USERID='1090497224']") != null, "The member list does not contain the right user search id xml!!!");
        }
    }
}
