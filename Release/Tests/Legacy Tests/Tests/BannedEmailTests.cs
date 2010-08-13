using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using BBC.Dna.Moderation;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace Tests
{
    /// <summary>
    /// Test class for the banned emails functionality
    /// </summary>
    [TestClass]
    public class BannedEmailTests
    {
        /// <summary>
        /// Setup method
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();

            var b = new BannedEmails(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default,
                CacheFactory.GetCacheManager(), null, null);

            AddTestEmailsToDatabase();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            
        }

        /// <summary>
        /// Make sure that banned users are not created in the datase. Also make sure that we only check the database once
        /// for more than one page.
        /// </summary>
        [TestMethod]
        public void TestBannedEmailIsHandledCorrectlyUsingMockedObjects()
        {
            Console.WriteLine("Before TestBannedEmailIsHandledCorrectlyUsingMockedOnbjects");
            Mockery mockery = new Mockery();
            IInputContext mockedInput = mockery.NewMock<IInputContext>();

            DnaCookie testCookie = new DnaCookie();
            testCookie.Value = "6042002|DotNetNormalUser|DotNetNormalUser|1273497514775|0|bf78fdd57a1f70faee630c07ba31674eab181a3f6c6f";
            testCookie.Name = "IDENTITY";
             
            DnaCookie testCookie2 = new DnaCookie();
            testCookie2.Value = "1eda650cb28e56156217427336049d0b8e164765";
            testCookie2.Name = "IDENTITY-HTTPS";
           
            //DnaCookie testCookie = new DnaCookie();
            //testCookie.Value = "THIS-IS-A-TEST-COOKIE-THAT-IS-LONGER-THAN-SIXTYFOUR-CHARACTURES-LONG";
            //testCookie.Name = "SSO2-UID";

            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY").Will(Return.Value(testCookie));
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY-HTTPS").Will(Return.Value(testCookie2));
            Stub.On(mockedInput).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
            Stub.On(mockedInput).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));

            CreateMockedProfileConnection(mockery, mockedInput, 1063883681, "Fink", "TEST-TEST-TEST", "tester@bbc.co.uk", true);

            SetDefaultDiagnostics(mockery, mockedInput);

            CreateMockedSite(mockery, mockedInput, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");

            // Add the mocked datareader for getting the user info from the database.
            CreateMockedReaderForUserNotInDataBase(mockery, mockedInput);

            // Now mock the database reader for the two requests. The first needs to return true for email in banned list.
            CreateMockedReaderForEmailInBannedListCheck(mockery, mockedInput, 1, true);
            
            // Ok, create the user object and try to create the user.
            User testUser = new User(mockedInput);
            testUser.CreateUser();

            // The expect Once call on the IsEmailInBannedList procedure should indicate that the second call to the create method is using the
            // cookie banned list functionality.
            User testUser2 = new User(mockedInput);
            testUser2.CreateUser();

            // This will fail if the create user call got to check the data base more than once!
            mockery.VerifyAllExpectationsHaveBeenMet();
            Console.WriteLine("After TestBannedEmailIsHandledCorrectlyUsingMockedObjects");
        }

        /// <summary>
        /// Test to make sure that a normal user can be created after a banned user is caught
        /// </summary>
        /// TODO NEED TO GO THROUGH WITH MARK HOWITT TO FIND OUT WHAT THIS TEST IS TRYING TO DO
        [TestMethod]
        public void TestNormalUserCanBeCreatedAfterABannedUserIsCaught()
        {
            Console.WriteLine("Before TestNormalUserCanBeCreatedAfterABannedUserIsCaught");
            
            // Start by creating two contexts. One for each request
            Mockery mockery = new Mockery();
            IInputContext mockedInput = mockery.NewMock<IInputContext>();
            IInputContext mockedInput2 = mockery.NewMock<IInputContext>();

            DnaCookie testBannedCookie = new DnaCookie();
            testBannedCookie.Value = "6042004|DotNetUserBanned|DotNetUserBanned|1273497847257|0|9d9ee980c4b831e419915b452b050f327862bba748ff";
            testBannedCookie.Name = "IDENTITY";

            DnaCookie testBannedCookie2 = new DnaCookie();
            testBannedCookie2.Value = "a684c1a5736f052c4acc1b35908f8dbad2e2ea0b";
            testBannedCookie2.Name = "IDENTITY-HTTPS";

            DnaCookie testNormalCookie = new DnaCookie();
            testNormalCookie.Value = "6042002|DotNetNormalUser|DotNetNormalUser|1273497514775|0|bf78fdd57a1f70faee630c07ba31674eab181a3f6c6f";
            testNormalCookie.Name = "IDENTITY";

            DnaCookie testNormalCookie2 = new DnaCookie();
            testNormalCookie2.Value = "1eda650cb28e56156217427336049d0b8e164765";
            testNormalCookie2.Name = "IDENTITY-HTTPS";

            // Now set the two test cookies. One for each user
            DnaCookie cookie1 = new DnaCookie();
            cookie1.Name = "SSO2-UID";
            cookie1.Value = "VALID-COOKIE-ABCDEFGHIJKLMNOPQRRSTUVWXYZ-SSO-BANNED-USER-ACCOUNT";

            DnaCookie cookie2 = new DnaCookie();
            cookie2.Name = "SSO2-UID";
            cookie2.Value = "VALID-COOKIE-ABCDEFGHIJKLMNOPQRRSTUVWXYZ-SSO-NORMAL-USER-ACCOUNT";

            // Stub the cookies to the contexts
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY").Will(Return.Value(testBannedCookie));
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY-HTTPS").Will(Return.Value(testBannedCookie2));

            Stub.On(mockedInput2).Method("GetCookie").With("IDENTITY").Will(Return.Value(testNormalCookie));
            Stub.On(mockedInput2).Method("GetCookie").With("IDENTITY-HTTPS").Will(Return.Value(testNormalCookie2));
            
            Stub.On(mockedInput).Method("GetCookie").With("SSO2-UID").Will(Return.Value(cookie1));
			Stub.On(mockedInput2).Method("GetCookie").With("SSO2-UID").Will(Return.Value(cookie2));
			Stub.On(mockedInput).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
			Stub.On(mockedInput2).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
            Stub.On(mockedInput).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));
            Stub.On(mockedInput2).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));

            // Now add the mocked profile connections
            CreateMockedProfileConnection(mockery, mockedInput, 106663681, "BadFink", "TEST-TEST-TEST-BANNED-USER", "BannedUser@bbc.co.uk", true);
            IDnaIdentityWebServiceProxy mockedGoodProfile = CreateMockedProfileConnection(mockery, mockedInput2, 1063883681, "GoodFink", "TEST-TEST-TEST-NORMAL-USER", "NormalUser@bbc.co.uk", true);

            // Create the mocked data reader for the createnewuserfromuserid call
            CreateMockedCreateUserDataReader(mockery, mockedInput2, 106663681);

            // Set the diagnostics for the contexts
            SetDefaultDiagnostics(mockery, mockedInput);
            SetDefaultDiagnostics(mockery, mockedInput2);

            // Add the site for the contexts
            CreateMockedSite(mockery, mockedInput, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");
            CreateMockedSite(mockery, mockedInput2, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");

            // Add the mocked datareader for getting the user info from the database.
            CreateMockedReaderForUserNotInDataBase(mockery, mockedInput);

            //CreateMockedReaderForUserNotInDataBase(mockery, mockedInput2);
            IDnaDataReader mockedNormalUserReader = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockedNormalUserReader).Method("AddParameter").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedNormalUserReader).Method("Execute").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedNormalUserReader).Method("Dispose").Will(Return.Value(null));
            Stub.On(mockedNormalUserReader).Method("Read").Will(Return.Value(false));

            // Create an action list for the Read and HasRows method/property
            IAction mockReaderResults = new MockedReaderResults(new bool[] {false,true,true});
            Stub.On(mockedNormalUserReader).GetProperty("HasRows").Will(mockReaderResults);

            // These both need to return the same results, so use the same mocked reader for both requests
            Stub.On(mockedInput2).Method("CreateDnaDataReader").With("fetchusersgroups").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput2).Method("CreateDnaDataReader").With("finduserfromid").Will(Return.Value(mockedNormalUserReader));
            //Stub.On(mockedInput2).Method("CreateDnaDataReader").With("GetDnaUserIDFromSSOUserID").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput2).Method("CreateDnaDataReader").With("GetDnaUserIDFromIdentityUserID").Will(Return.Value(mockedNormalUserReader));
            
            // Now mock the database reader for the two requests. The first needs to return true for email in banned list.
            CreateMockedReaderForEmailInBannedListCheck(mockery, mockedInput, 1, true);
            CreateMockedReaderForEmailInBannedListCheck(mockery, mockedInput2, 1, false);

            // Mock the siteoption call for the checkusernameset option
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));
            Stub.On(mockedInput2).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            // Now do the test.
            // 1. Test banned user is caught and not created in the database
            // 2. Test that a normal user can be created after the banned user
            // 3. Test to make sure the banned user is caught by the banned cookie list with out calling the database.

            // Banned user first call. This should check the database and then add their cookie to the list
            User bannedUser = new User(mockedInput);
            bannedUser.CreateUser();

            // Normal user. This should check the database and return false for being in the banned list. This should create the user in the database.
            User normalUser = new User(mockedInput2);
            normalUser.CreateUser();

            // Banned user second call. This should not call the database, but be caught by the cookie list.
            bannedUser.CreateUser();

            // This will fail if the create user call got to check the data base more than once for both users!
            mockery.VerifyAllExpectationsHaveBeenMet();
            Console.WriteLine("After TestNormalUserCanBeCreatedAfterABannedUserIsCaught");
        }

        /// <summary>
        /// Test to make sure that a non banned user will still be created if they have a invalid cookie.
        /// </summary>
        [TestMethod]
        public void TestNonBannedUserWithInvalidCookieGetsCreatedOk()
        {
            Console.WriteLine("Before TestNonBannedUserWithInvalidCookieGetsCreatedOk");
            Mockery mockery = new Mockery();
            IInputContext mockedInput = mockery.NewMock<IInputContext>();

            DnaCookie testCookie = new DnaCookie();
            testCookie.Value = "THIS-IS-A-TEST-COOKIE-THAT-IS-NOT-VALID";
            testCookie.Name = "SSO2-UID";
			Stub.On(mockedInput).Method("GetCookie").With("SSO2-UID").Will(Return.Value(testCookie));
			Stub.On(mockedInput).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
            Stub.On(mockedInput).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));

            CreateMockedProfileConnection(mockery, mockedInput, 1063883681, "Fink", "TEST-TEST-TEST", "tester@bbc.co.uk", true);

            SetDefaultDiagnostics(mockery, mockedInput);

            CreateMockedSite(mockery, mockedInput, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");

            // Add the mocked datareader for getting the user info from the database.
            IDnaDataReader mockedNormalUserReader = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockedNormalUserReader).Method("AddParameter").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedNormalUserReader).Method("Execute").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedNormalUserReader).Method("Dispose").Will(Return.Value(null));
            Stub.On(mockedNormalUserReader).Method("Read").Will(Return.Value(false));

            // Create an action list for the HasRows property
            IAction mockReaderResults = new MockedReaderResults(new bool[] { false, true, true });
            Stub.On(mockedNormalUserReader).GetProperty("HasRows").Will(mockReaderResults);

            // These both need to return the same results, so use the same mocked reader for both requests
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("fetchusersgroups").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("finduserfromid").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("GetDnaUserIDFromSSOUserID").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("GetDnaUserIDFromIdentityUserID").Will(Return.Value(mockedNormalUserReader));

            // Mock the siteoption call for the checkusernameset option
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            // Create the mocked data reader for the createnewuserfromuserid call
            CreateMockedCreateUserDataReader(mockery, mockedInput, 106663681);

            // Now mock the database reader for the two requests. The first needs to return true for email in banned list.
            CreateMockedReaderForEmailInBannedListCheck(mockery, mockedInput, 1, false);

            // Mock the siteoption call for the checkusernameset option
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            // Ok, create the user object and try to create the user.
            User testUser = new User(mockedInput);
            testUser.CreateUser();

            // This will fail if the create user call got to check the data base more than once!
            mockery.VerifyAllExpectationsHaveBeenMet();
            Console.WriteLine("After TestNonBannedUserWithInvalidCookieGetsCreatedOk");
        }

        /// <summary>
        /// Helper class for providing multiple results for a DNaDataReader call to HasRows property.
        /// </summary>
        internal class MockedReaderResults : IAction
        {
            private int _rowCount = 0;
            private List<bool> _values = new List<bool>();

            public MockedReaderResults(bool[] values)
            {
                foreach (bool value in values)
                {
                    _values.Add(value);
                }
            }

            public void Invoke(NMock2.Monitoring.Invocation invocation)
            {
                if (invocation.Method.Name == "get_HasRows")
                {
                    invocation.Result = _values[_rowCount];
                    _rowCount++;
                }
            }

            public void DescribeTo(System.IO.TextWriter writer)
            {
                writer.Write("Reading a data line");
            }
        }

        /// <summary>
        /// Test to make sure that we still ban users if their cookies are not valid
        /// </summary>
        [TestMethod]
        public void TestBannedUserCaughtEvenWithinvalidCookie()
        {
            Console.WriteLine("Before TestBannedUserCaughtEvenWithinvalidCookie");

            // Create the input context to run the requests in
            Mockery mockery = new Mockery();
            IInputContext mockedInput = mockery.NewMock<IInputContext>();

            // Create the invalid cookie. Invalid cookies are less or equal to 64 chars long
            DnaCookie cookie = new DnaCookie();
            cookie.Name = "SSO2-UID";
            cookie.Value = "INVALID-COOKIE";

            // Stub the cookie to the context
			Stub.On(mockedInput).Method("GetCookie").With("SSO2-UID").Will(Return.Value(cookie));
			Stub.On(mockedInput).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
            Stub.On(mockedInput).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));

            // Now add the mocked profile connection
            CreateMockedProfileConnection(mockery, mockedInput, 106663681, "BadFink", "TEST-TEST-TEST-BANNED-USER", "BannedUser@bbc.co.uk", true);

            // Set the diagnostics for the context
            SetDefaultDiagnostics(mockery, mockedInput);

            // Add the site for the context
            CreateMockedSite(mockery, mockedInput, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");

            // Add the mocked datareader for getting the user info from the database.
            CreateMockedReaderForUserNotInDataBase(mockery, mockedInput);

            // Now mock the database reader for the two requests. The first needs to return true for email in banned list.
            CreateMockedReaderForEmailInBannedListCheck(mockery, mockedInput, 2, true);

            // Now create the banned user for the first time.
            User bannedUser = new User(mockedInput);
            bannedUser.CreateUser();

            // Now call the create method again. This should also check the database
            bannedUser.CreateUser();

            // This will fail if the create user call got to check the data base more than twice!
            mockery.VerifyAllExpectationsHaveBeenMet();
            Console.WriteLine("Before TestBannedUserCaughtEvenWithinvalidCookie");
        }

        /// <summary>
        /// This tests to make sure that a service that does not support email attributes creates users correctly
        /// </summary>
        [TestMethod]
        public void TestServiceWithNoEmailAttributeCreatesUsers()
        {
            Console.WriteLine("Before TestBannedUserCaughtEvenWithinvalidCookie");

            // Create the input context to run the requests in
            Mockery mockery = new Mockery();
            IInputContext mockedInput = mockery.NewMock<IInputContext>();

            // Create the invalid cookie. Invalid cookies are less or equal to 64 chars long
            DnaCookie cookie = new DnaCookie();
            cookie.Name = "SSO2-UID";
            cookie.Value = "VALID-COOKIE-ABCDEFGHIJKLMNOPQRRSTUVWXYZ-SSO-NORMAL-USER-ACCOUNT";

            // Stub the cookie to the context
			Stub.On(mockedInput).Method("GetCookie").With("SSO2-UID").Will(Return.Value(cookie));
			Stub.On(mockedInput).Method("GetCookie").With("H2G2DEBUG").Will(Return.Value(null));
            Stub.On(mockedInput).Method("GetParamIntOrZero").With("s_sync", "User's details must be synchronised with the data in SSO.").Will(Return.Value(0));

            // Now add the mocked profile connection
            CreateMockedProfileConnection(mockery, mockedInput, 106663681, "Fink", "TEST-TEST-TEST-NOEMAIL-ATTRIBUTE", "", false);

            SetDefaultDiagnostics(mockery, mockedInput);

            CreateMockedSite(mockery, mockedInput, 1, "h2g2", "h2g2", true, "http://identity/policies/dna/adult");

            // Add the mocked datareader for getting the user info from the database.
            IDnaDataReader mockedNormalUserReader = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockedNormalUserReader).Method("AddParameter").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedNormalUserReader).Method("Execute").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedNormalUserReader).Method("Dispose").Will(Return.Value(null));
            Stub.On(mockedNormalUserReader).Method("Read").Will(Return.Value(false));

            // Create an action list for the HasRows property
            IAction mockReaderResults = new MockedReaderResults(new bool[] { false, true, true });
            Stub.On(mockedNormalUserReader).GetProperty("HasRows").Will(mockReaderResults);

            // These both need to return the same results, so use the same mocked reader for both requests
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("fetchusersgroups").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("finduserfromid").Will(Return.Value(mockedNormalUserReader));
            //Stub.On(mockedInput).Method("CreateDnaDataReader").With("GetDnaUserIDFromSSOUserID").Will(Return.Value(mockedNormalUserReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("GetDnaUserIDFromIdentityUserID").Will(Return.Value(mockedNormalUserReader));
            
            // Create the mocked data reader for the createnewuserfromuserid call
            CreateMockedCreateUserDataReader(mockery, mockedInput, 106663681);

            // Mock the siteoption call for the checkusernameset option
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            // Ok, create the user object and try to create the user.
            User testUser = new User(mockedInput);
            testUser.CreateUser();

            // This will fail if the create user call got to check the data base more than twice!
            mockery.VerifyAllExpectationsHaveBeenMet();
            Console.WriteLine("Before TestBannedUserCaughtEvenWithinvalidCookie");
        }

        /// <summary>
        /// Test sto make sure that the IsEmailBannedFromComplaints storeprocedure correctly returns the right values
        /// </summary>
        [TestMethod]
        public void TestIsEmailBannedFromComplaintsStoredProcedure()
        {
            // First check to make sure that the email is not in the table
            // Create a reader for the stored procedure
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("isemailbannedfromcomplaints"))
            {
                reader.AddParameter("Email", "TestIsEmailBannedFromComplaintsStoredProcedure@Test.com");
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the isemailbannedfromcomplaints storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the isemailbannedfromcomplaints storedprocedure");
                Assert.IsTrue(reader.Exists("IsBanned"), "The IsBanned result field is not in the isemailbannedfromcomplaints dataset");
                Assert.IsFalse(reader.GetBoolean("IsBanned"), "The IsBanned result should be false!");
            }

            // Now add the email to the banned emails list
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "TestIsEmailBannedFromComplaintsStoredProcedure@Test.com");
                reader.AddParameter("SigninBanned", 0);
                reader.AddParameter("ComplaintBanned", 1);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsFalse(reader.GetBoolean("Duplicate"), "The Duplicate result should be false!");
            }

            // Now check again
            using (IDnaDataReader reader = context.CreateDnaDataReader("isemailbannedfromcomplaints"))
            {
                reader.AddParameter("Email", "TestIsEmailBannedFromComplaintsStoredProcedure@Test.com");
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the isemailbannedfromcomplaints storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the isemailbannedfromcomplaints storedprocedure");
                Assert.IsTrue(reader.Exists("IsBanned"), "The IsBanned result field is not in the isemailbannedfromcomplaints dataset");
                Assert.IsTrue(reader.GetBoolean("IsBanned"), "The IsBanned result should be true!");
            }
        }

        /// <summary>
        /// Test sto make sure that the IsEmailInBannedList storedprocedure correctly returns the right values
        /// </summary>
        [TestMethod]
        public void TestIsEmailInBannedListStoredProcedure()
        {
            // First check to make sure that the email is not in the table
            // Create a reader for the stored procedure
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("isemailinbannedlist"))
            {
                reader.AddParameter("Email", "TestIsEmailInBannedListStoredProcedure@Test.com");
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the isemailinbannedlist storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the isemailinbannedlist storedprocedure");
                Assert.IsTrue(reader.Exists("IsBanned"), "The IsBanned result field is not in the isemailinbannedlist dataset");
                Assert.IsFalse(reader.GetBoolean("IsBanned"), "The IsBanned result should be false!");
            }

            // Now add the email to the banned emails list
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "TestIsEmailInBannedListStoredProcedure@Test.com");
                reader.AddParameter("SigninBanned", 1);
                reader.AddParameter("ComplaintBanned", 0);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsFalse(reader.GetBoolean("Duplicate"), "The Duplicate result should be false!");
            }

            // Now check again
            using (IDnaDataReader reader = context.CreateDnaDataReader("isemailinbannedlist"))
            {
                reader.AddParameter("Email", "TestIsEmailInBannedListStoredProcedure@Test.com");
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the isemailinbannedlist storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the isemailinbannedlist storedprocedure");
                Assert.IsTrue(reader.Exists("IsBanned"), "The IsBanned result field is not in the isemailinbannedlist dataset");
                Assert.IsTrue(reader.GetBoolean("IsBanned"), "The IsBanned result should be true!");
            }
        }

        /// <summary>
        /// Test to make sure that if we put duplicate emails into the banned email list that we catch them correctly
        /// </summary>
        [TestMethod]
        public void TestDuplicateBannedEmailEntry()
        {
            // Create a data reader for the stored procedure
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "TestDuplicateBannedEmailEntry@Test.com");
                reader.AddParameter("SigninBanned", 1);
                reader.AddParameter("ComplaintBanned", 0);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsFalse(reader.GetBoolean("Duplicate"), "The Duplicate result should be false!");
            }

            // Now try to add it again
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "TestDuplicateBannedEmailEntry@Test.com");
                reader.AddParameter("SigninBanned", 1);
                reader.AddParameter("ComplaintBanned", 0);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsTrue(reader.GetBoolean("Duplicate"), "The Duplicate result should be true!");
            }
        }

        /// <summary>
        /// Test to make sure that the banned emails update procedure works correctly
        /// </summary>
        [TestMethod]
        public void TestGetAndUpdateBannedEmailSettings()
        {
            // Create a data reader for the stored procedure
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "TestGetAndUpdateBannedEmailSettings@Test.com");
                reader.AddParameter("SigninBanned", 1);
                reader.AddParameter("ComplaintBanned", 1);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsFalse(reader.GetBoolean("Duplicate"), "The Duplicate result should be false!");
            }

            // Now get the email from the database using the getbannedemails stored procedure
            using (IDnaDataReader reader = context.CreateDnaDataReader("GetBannedEmails"))
            {
                reader.AddParameter("skip", 0);
                reader.AddParameter("show", 20);
                reader.AddParameter("showsigninbanned", 1);
                reader.AddParameter("showcomplaintbanned", 1);
                reader.AddParameter("showall", 1);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the GetBannedEmails storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the GetBannedEmails storedprocedure");
                Assert.AreEqual("TestGetAndUpdateBannedEmailSettings@Test.com", reader.GetString("Email"), "Failed to get email from banned emails list");
                Assert.IsTrue(reader.GetBoolean("SignInBanned"), "Signin banned value should be 1");
                Assert.IsTrue(reader.GetBoolean("ComplaintBanned"), "Complaint banned value should be 1");
            }

            // Now update the setting for the email so that the complaint banned is set to 0
            using (IDnaDataReader reader = context.CreateDnaDataReader("UpdateBannedEmailSettings"))
            {
                reader.AddParameter("Email", "TestGetAndUpdateBannedEmailSettings@Test.com");
                reader.AddParameter("EditorID", 6);
                reader.AddParameter("ToggleSigninBanned", 0);
                reader.AddParameter("ToggleComplaintBanned", 1);
                reader.Execute();

                Assert.IsFalse(reader.HasRows, "No rows should come back from the UpdateBannedEmailSettings storedprocedure");
            }

            // Now get the email from the database using the getbannedemails stored procedure
            using (IDnaDataReader reader = context.CreateDnaDataReader("GetBannedEmails"))
            {
                reader.AddParameter("skip", 0);
                reader.AddParameter("show", 20);
                reader.AddParameter("showsigninbanned", 1);
                reader.AddParameter("showcomplaintbanned", 1);
                reader.AddParameter("showall", 1);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the GetBannedEmails storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the GetBannedEmails storedprocedure");
                Assert.AreEqual("TestGetAndUpdateBannedEmailSettings@Test.com", reader.GetString("Email"), "Failed to get email from banned emails list");
                Assert.IsTrue(reader.GetBoolean("SignInBanned"), "Signin banned value should be 1");
                Assert.IsFalse(reader.GetBoolean("ComplaintBanned"), "Complaint banned value should be 0");
            }

            // Now update the setting for the email so that the signin banned is set to 0 and the complaint is set back to 1
            using (IDnaDataReader reader = context.CreateDnaDataReader("UpdateBannedEmailSettings"))
            {
                reader.AddParameter("Email", "TestGetAndUpdateBannedEmailSettings@Test.com");
                reader.AddParameter("EditorID", 6);
                reader.AddParameter("ToggleSigninBanned", 1);
                reader.AddParameter("ToggleComplaintBanned", 1);
                reader.Execute();

                Assert.IsFalse(reader.HasRows, "No rows should come back from the UpdateBannedEmailSettings storedprocedure");
            }

            // Now get the email from the database using the getbannedemails stored procedure
            using (IDnaDataReader reader = context.CreateDnaDataReader("GetBannedEmails"))
            {
                reader.AddParameter("skip", 0);
                reader.AddParameter("show", 20);
                reader.AddParameter("showsigninbanned", 1);
                reader.AddParameter("showcomplaintbanned", 1);
                reader.AddParameter("showall", 1);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the GetBannedEmails storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the GetBannedEmails storedprocedure");
                Assert.AreEqual("TestGetAndUpdateBannedEmailSettings@Test.com", reader.GetString("Email"), "Failed to get email from banned emails list");
                Assert.IsFalse(reader.GetBoolean("SignInBanned"), "Signin banned value should be 0");
                Assert.IsTrue(reader.GetBoolean("ComplaintBanned"), "Complaint banned value should be 1");
            }
        }

        /// <summary>
        /// Checks to make sure that the find user from id returns the correct banned from complaints status for a given user
        /// </summary>
        [TestMethod]
        public void TestFetchUserFromIDReturnsComplaintBannedStatus()
        {
            // Create a data reader for the stored procedure
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            bool validEMail = false;
            using (IDnaDataReader reader = context.CreateDnaDataReader("FindUserFromID"))
            {
                reader.AddParameter("UserID", 24);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the FindUserFromID storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the FindUserFromID storedprocedure");
                Assert.AreEqual(24, reader.GetInt32("UserID"), "The userid should come back as 24, as that's the id we wanted to get!");
                Assert.AreEqual("Peta", reader.GetString("UserName"), "The user name has been changed in the small guide.");
                Assert.AreEqual(2, reader.GetInt32("Status"), "The status of this user should be 2, superuser");
                Assert.IsFalse(reader.GetBoolean("BannedFromComplaints"), "The use should not be banned from complaints at this stage");
                validEMail = reader.GetStringNullAsEmpty("EMail").Contains("@");
            }

            // Now put he users emails in the banned list, but first make sure they have an email
            if (!validEMail)
            {
                // Quickly update the user with a test email
                using (IDnaDataReader reader = context.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("UPDATE dbo.Users SET EMail = 'TestFetchUserFromIDReturnsComplaintBannedStatus@Test.com' WHERE UserID = 24");
                }
            }

            // Add the email to the banned list for complints
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "TestFetchUserFromIDReturnsComplaintBannedStatus@Test.com");
                reader.AddParameter("SigninBanned", 0);
                reader.AddParameter("ComplaintBanned", 1);
                reader.AddParameter("EditorID", 6);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the AddEMailToBannedList storedprocedure");
                Assert.IsTrue(reader.Exists("Duplicate"), "The Duplicate result field is not in the AddEMailToBannedList dataset");
                Assert.IsFalse(reader.GetBoolean("Duplicate"), "The Duplicate result should be false!");
            }

            // Now recall the find user procedure to check it now comes back as this user is banned from complaints
            using (IDnaDataReader reader = context.CreateDnaDataReader("FindUserFromID"))
            {
                reader.AddParameter("UserID", 24);
                reader.Execute();

                Assert.IsTrue(reader.HasRows, "No rows came back from the FindUserFromID storedprocedure");
                Assert.IsTrue(reader.Read(), "Failed to read the first set of results from the FindUserFromID storedprocedure");
                Assert.AreEqual(24, reader.GetInt32("UserID"), "The userid should come back as 24, as that's the id we wanted to get!");
                Assert.AreEqual("Peta", reader.GetString("UserName"), "The user name has been changed in the small guide.");
                Assert.AreEqual(2, reader.GetInt32("Status"), "The status of this user should be 2, superuser");
                Assert.IsTrue(reader.GetBoolean("BannedFromComplaints"), "The use should be banned from complaints at this stage");
                validEMail = reader.GetStringNullAsEmpty("EMail").Contains("@");
            }
        }

        /// <summary>
        /// Test to make sure the correct default view is created if we goto the banned email page
        /// with no params. We should see the top 20 most recent banned emails
        /// </summary>
        [TestMethod]
        public void TestGetBannedEmailsDefaultActionWithNoParams()
        {
            // Create the context for the object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            DnaMockery.SetDefaultDiagnostics(context);

            // Mock up the request params for the test
            Stub.On(context).Method("DoesParamExist").With("show", "Do we have the number of items to show?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("skip", "Do we have the number of items to skip?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("ViewAll", "Are we viewing all items?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("ViewByLetter", "Are we wanting to search by letter?").Will(Return.Value(false));

            // Mock the action params
            Stub.On(context).Method("DoesParamExist").With("togglecomplaintban", "Are we toggling the complaint ban for an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("togglesigninban", "Are we toggling the signin ban for an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("remove", "Are we tring to remove an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("AddEmail", "Are we tring to remove an email").Will(Return.Value(false));
            Stub.On(context).Method("UrlEscape").WithAnyArguments().Will(Return.Value("Escaped EMail"));

            // Now create banned email object and process the request
            BannedEmailsPageBuilder testBannedEmails = new BannedEmailsPageBuilder(context);
            testBannedEmails.ProcessRequest();

            // Get the resultant XML from the object
            System.Xml.XmlNode testXML = testBannedEmails.RootElement;

            Assert.AreEqual("0", testXML.SelectSingleNode("//BANNEDEMAILS/SKIP").InnerText, "We should have a default value of 0 for the skip value");
            Assert.AreEqual("20", testXML.SelectSingleNode("//BANNEDEMAILS/SHOW").InnerText, "We should have a default value of 20 for the show value");
            Assert.AreEqual("", testXML.SelectSingleNode("//BANNEDEMAILS/SEARCHLETTER").InnerText, "We should have a default value of empty for the search letter value");
            Assert.AreEqual("0", testXML.SelectSingleNode("//BANNEDEMAILS/SEARCHTYPE").InnerText, "The search type value should be 0!");
        }

        /// <summary>
        /// Test to make sure the correct results are displayed when we ask for banned emails by letter
        /// </summary>
        [TestMethod]
        public void TestGetBannedEmailsWithSeachByLetter()
        {
            // Create the context for the object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            DnaMockery.SetDefaultDiagnostics(context);

            // Mock up the request params for the test
            Stub.On(context).Method("DoesParamExist").With("show", "Do we have the number of items to show?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("skip", "Do we have the number of items to skip?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("ViewAll", "Are we viewing all items?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("ViewByLetter", "Are we wanting to search by letter?").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("ViewByLetter", "Get the search letter").Will(Return.Value("g"));
            Stub.On(context).Method("UrlEscape").WithAnyArguments().Will(Return.Value("Escaped EMail"));

            // Mock the action params
            Stub.On(context).Method("DoesParamExist").With("togglecomplaintban", "Are we toggling the complaint ban for an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("togglesigninban", "Are we toggling the signin ban for an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("remove", "Are we tring to remove an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("AddEmail", "Are we tring to remove an email").Will(Return.Value(false));

            // Now create banned email object and process the request
            BannedEmailsPageBuilder testBannedEmails = new BannedEmailsPageBuilder(context);
            testBannedEmails.ProcessRequest();

            // Get the resultant XML from the object
            System.Xml.XmlNode testXML = testBannedEmails.RootElement;

            Assert.AreEqual("0", testXML.SelectSingleNode("//BANNEDEMAILS/SKIP").InnerText, "We should have a default value of 0 for the skip value");
            Assert.AreEqual("20", testXML.SelectSingleNode("//BANNEDEMAILS/SHOW").InnerText, "We should have a default value of 20 for the show value");
            Assert.AreEqual("g", testXML.SelectSingleNode("//BANNEDEMAILS/SEARCHLETTER").InnerText, "We should have the letter 'g' as the value");
            Assert.AreEqual("1", testXML.SelectSingleNode("//BANNEDEMAILS/SEARCHTYPE").InnerText, "The search type value should be 1!");
            Assert.AreEqual("1", testXML.SelectSingleNode("//BANNEDEMAILS/TOTALEMAILS").InnerText, "We should have only one in the totals field");
        }

        /// <summary>
        /// Add some sample data to the banned emails table
        /// </summary>
        private void AddTestEmailsToDatabase()
        {
            // Check to see if we've already added data
            if (!BannedEmailsAdded)
            {
                // Run the add email tests to add some emails to the database
                TestAddingSampleDataToBannedEmails("adam@books.com", true, true);
                TestAddingSampleDataToBannedEmails("brian@cooking.com", true, true);
                TestAddingSampleDataToBannedEmails("craig@draw.co.uk", true, true);
                TestAddingSampleDataToBannedEmails("darren@effects.com", true, true);
                TestAddingSampleDataToBannedEmails("eric@functions.com", true, true);
                TestAddingSampleDataToBannedEmails("fred@graphics.co.uk", true, true);
                TestAddingSampleDataToBannedEmails("graham@hours.co.uk", true, true);
                TestAddingSampleDataToBannedEmails("henry@iteractive.co.uk", false, true);
                TestAddingSampleDataToBannedEmails("ian@jackass.co.uk", true, false);
                TestAddingSampleDataToBannedEmails("john@klassact.com", false, false);
                BannedEmailsAdded = true;
            }
        }

        /// <summary>
        /// Test to make sure that we can add emails to the banned emails table
        /// </summary>
        private void TestAddingSampleDataToBannedEmails(string email, bool complaintBanned, bool signinBanned)
        {
            // Create the context for the object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            DnaMockery.SetDefaultDiagnostics(context);

            // Mock up the request params for the test
            Stub.On(context).Method("DoesParamExist").With("show", "Do we have the number of items to show?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("skip", "Do we have the number of items to skip?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("ViewAll", "Are we viewing all items?").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("ViewByLetter", "Are we wanting to search by letter?").Will(Return.Value(false));

            // Mock the action params
            Stub.On(context).Method("DoesParamExist").With("togglecomplaintban", "Are we toggling the complaint ban for an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("togglesigninban", "Are we toggling the signin ban for an email").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("remove", "Are we tring to remove an email").Will(Return.Value(false));

            // Mock the add params
            Stub.On(context).Method("DoesParamExist").With("AddEmail", "Are we tring to remove an email").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("NewEmail", "Get the new email address to add").Will(Return.Value(email));
            Stub.On(context).Method("GetParamStringOrEmpty").With("NewComplaintBanned", "Get the complaint banned setting").Will(Return.Value(complaintBanned ? "on" : ""));
            Stub.On(context).Method("GetParamStringOrEmpty").With("NewSignInBanned", "Get the signin banned setting").Will(Return.Value(signinBanned ? "on" : ""));
            Stub.On(context).Method("UrlEscape").WithAnyArguments().Will(Return.Value("Escaped EMail"));

            // Create the editor
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558353));
            Stub.On(mockedUser).GetProperty("UserName").Will(Return.Value("username"));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Now create banned email object and process the request
            BannedEmailsPageBuilder testBannedEmails = new BannedEmailsPageBuilder(context);
            testBannedEmails.ProcessRequest();

            // Get the resultant XML from the object
            System.Xml.XmlNode testXML = testBannedEmails.RootElement;

            // Check the search params
            Assert.AreEqual("0", testXML.SelectSingleNode("//BANNEDEMAILS/SKIP").InnerText, "We should have a default value of 0 for the skip value");
            Assert.AreEqual("20", testXML.SelectSingleNode("//BANNEDEMAILS/SHOW").InnerText, "We should have a default value of 20 for the show value");
            Assert.AreEqual("", testXML.SelectSingleNode("//BANNEDEMAILS/SEARCHLETTER").InnerText, "We should have a default value of empty for the search letter value");
            Assert.AreEqual("0", testXML.SelectSingleNode("//BANNEDEMAILS/SEARCHTYPE").InnerText, "The search type value should be 0!");

            // Now check to make sure that the email was actually added
            Assert.IsNotNull(testXML.SelectSingleNode("//BANNEDEMAILS/BANNEDEMAILLIST/BANNEDEMAIL[EMAIL = '" + email + "']"), "Failed to find the email we just added");
        }

        // Set up a flag to state whether or not that we've added some emails to the banned emails table
        private bool _bannedEmailsAdded = false;
        private bool BannedEmailsAdded
        {
            get { return _bannedEmailsAdded; }
            set { _bannedEmailsAdded = value; }
        }

        /// <summary>
        /// Helper method for creating a mocker datareader for the IsEmailInBannedList procedure
        /// </summary>
        /// <param name="mockery">The mockery object from the test</param>
        /// <param name="mockedInput">The context you wanty to add the mocked reader to</param>
        /// <param name="expectedNumberOfCalls">The number of calls the procedure is expected to be called</param>
        /// <param name="isBanned">A flag to state whether or not the user should appear as banned</param>
        /// <returns>The new mocked datareader</returns>
        private static IDnaDataReader CreateMockedReaderForEmailInBannedListCheck(Mockery mockery, IInputContext mockedInput, int expectedNumberOfCalls, bool isBanned)
        {
            IDnaDataReader mockedReader2 = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockedReader2).Method("AddParameter").Will(Return.Value(mockedReader2));
            Stub.On(mockedReader2).Method("Execute").Will(Return.Value(mockedReader2));
            Stub.On(mockedReader2).Method("Read").Will(Return.Value(true));
            Stub.On(mockedReader2).GetProperty("HasRows").Will(Return.Value(true));
            if (isBanned)
            {
                Stub.On(mockedReader2).Method("GetInt32").With("IsBanned").Will(Return.Value(1));
            }
            else
            {
                Stub.On(mockedReader2).Method("GetInt32").With("IsBanned").Will(Return.Value(0));
            }
            Stub.On(mockedReader2).Method("Dispose").Will(Return.Value(null));

            if (expectedNumberOfCalls == 1)
            {
                // We should only check this once, the next time should use the banned cookie list
                Expect.Once.On(mockedInput).Method("CreateDnaDataReader").With("IsEmailInBannedList").Will(Return.Value(mockedReader2));
            }
            else if (expectedNumberOfCalls > 1)
            {
                // We should call this procedure # number of time only
                Expect.Exactly(expectedNumberOfCalls).On(mockedInput).Method("CreateDnaDataReader").With("IsEmailInBannedList").Will(Return.Value(mockedReader2));
            }
            else
            {
                // We don't care how many times this gets called
                Stub.On(mockedInput).Method("CreateDnaDataReader").With("IsEmailInBannedList").Will(Return.Value(mockedReader2));
            }

            return mockedReader2;
        }

        /// <summary>
        /// Helper method for creating a mocked reader for the CreateNewUserFromUserID procedure
        /// </summary>
        /// <param name="mockery">The mockery object from the test</param>
        /// <param name="mockedInput2">The context you want to add the mocked reader to</param>
        /// <param name="userID">The userid that you are expecting from the call</param>
        private static void CreateMockedCreateUserDataReader(Mockery mockery, IInputContext mockedInput2, int userID)
        {
            // Create the mocked data reader for the createnewuserfromuserid call
            IDnaDataReader mockCreateUserReader = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockCreateUserReader).Method("AddParameter").Will(Return.Value(mockCreateUserReader));
            Stub.On(mockCreateUserReader).Method("Execute").Will(Return.Value(mockCreateUserReader));
            Stub.On(mockCreateUserReader).Method("Dispose").Will(Return.Value(null));
            Stub.On(mockCreateUserReader).GetProperty("HasRows").Will(Return.Value(true));
            Stub.On(mockCreateUserReader).Method("Read").Will(Return.Value(true));
            Stub.On(mockCreateUserReader).Method("GetInt32").With("userid").Will(Return.Value(userID));
            //Expect.Once.On(mockedInput2).Method("CreateDnaDataReader").With("createnewuserfromssoid").Will(Return.Value(mockCreateUserReader));
            Expect.Once.On(mockedInput2).Method("CreateDnaDataReader").With("createnewuserfromidentityid").Will(Return.Value(mockCreateUserReader));
        }

        /// <summary>
        /// Helper Method for creating a mocked datareader for FetchUserInGroups and FindUserFromID procedure calls
        /// </summary>
        /// <param name="mockery">The mockery object from the test</param>
        /// <param name="mockedInput">The context you want to add the mocked reader to</param>
        /// <returns>The new mocked datareader</returns>
        private static IDnaDataReader CreateMockedReaderForUserNotInDataBase(Mockery mockery, IInputContext mockedInput)
        {
            IDnaDataReader mockedReader = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockedReader).Method("AddParameter").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Read").Will(Return.Value(false));
            Stub.On(mockedReader).GetProperty("HasRows").Will(Return.Value(false));
            Stub.On(mockedReader).Method("Dispose").Will(Return.Value(null));

            // These both need to return the same results, so use the same mocked reader for both requests
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("fetchusersgroups").Will(Return.Value(mockedReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("finduserfromid").Will(Return.Value(mockedReader));
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("GetDnaUserIDFromSSOUserID").Will(Return.Value(mockedReader));
            
            Stub.On(mockedInput).Method("CreateDnaDataReader").With("GetDnaUserIDFromIdentityUserID").Will(Return.Value(mockedReader));
            
            return mockedReader;
        }

        /// <summary>
        /// Helper method for creating a mocked site object
        /// </summary>
        /// <param name="mockery">The mockery object from the test</param>
        /// <param name="mockedInput">The context you want to added the mocked site to</param>
        /// <param name="siteID">The id of the site</param>
        /// <param name="siteName">The name of the sitte</param>
        /// <param name="ssoName">The name of the sso service to use</param>
        /// <param name="useIdentitySignIn">Set this to true if the site is to use identity as it's sign in system</param>
        /// <param name="identityPolicy">Identity policy</param>
        /// <returns>The new mocked site</returns>
        public static ISite CreateMockedSite(Mockery mockery, IInputContext mockedInput, int siteID, string siteName, string ssoName, bool useIdentitySignIn, string identityPolicy)
        {
            ISite mockedSite = mockery.NewMock<ISite>();
            Stub.On(mockedSite).GetProperty("SSOService").Will(Return.Value(ssoName));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(siteID));
            Stub.On(mockedSite).GetProperty("UseIdentitySignInSystem").Will(Return.Value(useIdentitySignIn));
            Stub.On(mockedInput).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            Stub.On(mockedSite).GetProperty("IdentityPolicy").Will(Return.Value(identityPolicy));
            return mockedSite;
        }

        /// <summary>
        /// Helper method for creating a mocked default diagnostics object
        /// </summary>
        /// <param name="mockery">The mockery object from the test</param>
        /// <param name="mockedInput">The context that you want to add the diagnostics mocked object to</param>
        public static void SetDefaultDiagnostics(Mockery mockery, IInputContext mockedInput)
        {
            IDnaDiagnostics mockedDiag = mockery.NewMock<IDnaDiagnostics>();
            Stub.On(mockedDiag).Method("WriteTimedEventToLog").Will(Return.Value(null));
            Stub.On(mockedDiag).Method("WriteWarningToLog").Will(Return.Value(null));
            Stub.On(mockedDiag).Method("WriteToLog").Will(Return.Value(null));
            Stub.On(mockedDiag).Method("WriteTimedSignInEventToLog").Will(Return.Value(null));
            Stub.On(mockedInput).GetProperty("Diagnostics").Will(Return.Value(mockedDiag));
        }

        /// <summary>
        /// Helper method for creating a mocked profile connection object.
        /// This method defaults to setting the user to be logged in, and having the service set
        /// </summary>
        /// <param name="mockery">The mockery object from the test</param>
        /// <param name="mockedInput">The context you want to add the mocked connection to</param>
        /// <param name="userID">The users ID</param>
        /// <param name="loginName">The user login name</param>
        /// <param name="bbcUID">The user BBCUID</param>
        /// <param name="email">The users email</param>
        /// <param name="serviceHasEmail">A flag to state whether or not the service supports emails</param>
        /// <returns>The new mocked profile connection</returns>
        public static IDnaIdentityWebServiceProxy CreateMockedProfileConnection(Mockery mockery, IInputContext mockedInput, int userID, string loginName, string bbcUID, string email, bool serviceHasEmail)
        {
            // Create and initialise the mocked profile connection
            IDnaIdentityWebServiceProxy mockedProfile = mockery.NewMock<IDnaIdentityWebServiceProxy>();
            Stub.On(mockedProfile).Method("SetService").Will(Return.Value(null));
            Stub.On(mockedProfile).GetProperty("IsServiceSet").Will(Return.Value(true));
            Stub.On(mockedProfile).GetProperty("IsSecureRequest").Will(Return.Value(true));
            
            //Stub.On(mockedProfile).Method("TrySetUserViaCookie").Will(Return.Value(true));
            //Stub.On(mockedProfile).Method("TrySetUserViaCookieAndUserName").Will(Return.Value(true));

            Stub.On(mockedProfile).Method("TrySecureSetUserViaCookies").Will(Return.Value(true));

            Stub.On(mockedProfile).GetProperty("IsUserLoggedIn").Will(Return.Value(true));
            Stub.On(mockedProfile).GetProperty("IsUserSignedIn").Will(Return.Value(true));            

            Stub.On(mockedProfile).GetProperty("UserID").Will(Return.Value(userID.ToString()));
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
            Stub.On(mockedProfile).GetProperty("SignInSystemType").Will(Return.Value(SignInSystem.Identity));
            IDnaIdentityWebServiceProxy mockedSignIn = mockery.NewMock<IDnaIdentityWebServiceProxy>();
            Stub.On(mockedProfile).GetProperty("GetCookieValue").Will(Return.Value(""));

            // Add the mocked profile to the first context
            Stub.On(mockedInput).GetProperty("GetCurrentSignInObject").Will(Return.Value(mockedProfile));
            Stub.On(mockedInput).Method("GetCookie").With("BBC-UID").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("BBC-UID", bbcUID))));
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY-USERNAME").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("IDENTITY-USERNAME", loginName + "|huhi|7907980"))));

            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("IDENTITY", loginName + "|huhi|7907980"))));
            Stub.On(mockedInput).Method("GetCookie").With("IDENTITY-HTTPS").Will(Return.Value(new DnaCookie(new System.Web.HttpCookie("IDENTITY-HTTPS", ""))));

            Stub.On(mockedInput).GetProperty("IsSecureRequest").Will(Return.Value(true));
            Stub.On(mockedInput).SetProperty("IsSecureRequest").To(true);

            // Mock the siteoption call for the UseSiteSuffix and AutoGeneratedNames option
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("User", "UseSiteSuffix").Will(Return.Value(false));
            Stub.On(mockedInput).Method("GetSiteOptionValueBool").With("User", "AutoGeneratedNames").Will(Return.Value(false));

            Stub.On(mockedInput).Method("UrlEscape").WithAnyArguments().Will(Return.Value("Escaped Email"));

            return mockedProfile;
        }
    }
}