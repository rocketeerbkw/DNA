using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Users;

namespace Tests
{
    /// <summary>
    /// Test Fixute for the UserGroups class
    /// </summary>
    [TestClass]
    public class UserGroupsTests
    {
        IInputContext _context = DnaMockery.CreateDatabaseInputContext();
        int _reapplyGroupsForUserID = 0;
        List<string> _userGroups = new List<string>();
        string _siteName = "haveyoursay";

        private int GetIDForSiteName()
        {
            return SiteListTests.GetIDForSiteName(_siteName);
        }

        /// <summary>
        /// 
        /// </summary>
        [TestInitialize]
        public void Initialise()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            SetupTestData();
            InitialiseMockedInputContext();

            var dnaDataReader = new DnaDataReaderCreator(DnaMockery.DnaConfig.ConnectionString);
            var usg = new UserGroups(dnaDataReader, _context.Diagnostics, CacheFactory.GetCacheManager("Memcached"),null, null);
        }

        private  void InitialiseMockedInputContext()
        {
            Mockery mock = new Mockery();
            BBC.Dna.IUser viewingUser = mock.NewMock<BBC.Dna.IUser>();
            Stub.On(viewingUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(viewingUser).GetProperty("Email").Will(Return.Value("davewil@bbc.co.uk"));
            Stub.On(viewingUser).GetProperty("IsEditor").Will(Return.Value(false));
            Stub.On(viewingUser).GetProperty("IsSuperUser").Will(Return.Value(false));
            Stub.On(viewingUser).GetProperty("IsBanned").Will(Return.Value(false));

            ISite site = mock.NewMock<BBC.Dna.Sites.ISite>();
            Stub.On(site).GetProperty("IsEmergencyClosed").Will(Return.Value(false));
            Stub.On(site).Method("IsSiteScheduledClosed").Will(Return.Value(false));

            //Mock Up Site 1 .
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));
            Stub.On(site).GetProperty("SiteName").Will(Return.Value("h2g2"));
            Stub.On(site).GetProperty("Description").Will(Return.Value("h2g2"));
            Stub.On(site).GetProperty("ShortName").Will(Return.Value("h2g2"));
            Stub.On(site).GetProperty("SSOService").Will(Return.Value("h2g2"));

            ISite siteDefault = mock.NewMock<BBC.Dna.Sites.ISite>();
            Stub.On(siteDefault).GetProperty("IsEmergencyClosed").Will(Return.Value(false));
            Stub.On(siteDefault).Method("IsSiteScheduledClosed").Will(Return.Value(false));

            //Mock a site for site != 1
            Stub.On(siteDefault).GetProperty("SiteID").Will(Return.Value(2));
            Stub.On(siteDefault).GetProperty("SiteName").Will(Return.Value("DefaultMockedSite"));
            Stub.On(siteDefault).GetProperty("Description").Will(Return.Value("DefaultMockedSite"));
            Stub.On(siteDefault).GetProperty("ShortName").Will(Return.Value("DefaultMockedSite"));
            Stub.On(siteDefault).GetProperty("SSOService").Will(Return.Value("DefaultMockedSite"));

            ISiteList siteList = mock.NewMock<BBC.Dna.Sites.ISiteList>();
            Stub.On(siteList).Method("GetSite").With(Is.EqualTo(1), Is.Anything).Will(Return.Value(site));
            Stub.On(siteList).Method("GetSite").With(Is.GreaterThan(1), Is.Anything).Will(Return.Value(siteDefault));
            Stub.On(_context).GetProperty("TheSiteList").Will(Return.Value(siteList));

            Stub.On(_context).GetProperty("ViewingUser").Will(Return.Value(viewingUser));
            Stub.On(_context).GetProperty("CurrentSite").Will(Return.Value(site));

            DnaMockery.MockTryGetParamString(_context,"dnauid", "this is some unique id blah de blah blah2");
            //Stub.On(_context).Method("TryGetParamString").WithAnyArguments().Will(new TryGetParamStringAction("dnauid","this is some unique id blah de blah blah2"));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnauid"), Is.Anything).Will(Return.Value(true));

            DnaMockery.MockTryGetParamString(_context,"dnahostpageurl", "http://www.bbc.co.uk/dna/something");
            //Stub.On(_context).Method("TryGetParamString").With("dnahostpageurl").Will(new TryGetParamStringAction("dnahostpageurl","http://www.bbc.co.uk/dna/something"));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnahostpageurl"), Is.Anything).Will(Return.Value(true));

            DnaMockery.MockTryGetParamString(_context,"dnainitialtitle", "newtitle");
            //Stub.On(_context).Method("TryGetParamString").With("dnainitialtitle").Will(new TryGetParamStringAction("dnainitialtitle", "newtitle"));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnainitialtitle"), Is.Anything).Will(Return.Value(true));

            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnaerrortype"),Is.Anything).Will(Return.Value(false));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("moduserid"), Is.Anything).Will(Return.Value(false));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnainitialmodstatus"), Is.Anything).Will(Return.Value(false));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnaforumclosedate"), Is.Anything).Will(Return.Value(false));
            Stub.On(_context).Method("DoesParamExist").With(Is.EqualTo("dnaforumduration"), Is.Anything).Will(Return.Value(false));

            Stub.On(_context).Method("GetParamIntOrZero").With(Is.EqualTo("dnafrom"), Is.Anything).Will(Return.Value(0));
            Stub.On(_context).Method("GetParamIntOrZero").With(Is.EqualTo("dnato"), Is.Anything).Will(Return.Value(0));
            Stub.On(_context).Method("GetParamIntOrZero").With(Is.EqualTo("dnashow"), Is.Anything).Will(Return.Value(0));

            Stub.On(_context).Method("GetSiteOptionValueInt").With("CommentForum","DefaultShow").Will(Return.Value(20));
        }

        /// <summary>
        /// First UserGroups Test.
        /// </summary>
        [TestMethod]
        public void Test1GetUserGroups()
        {
            //_context.InitialiseFromFile(@"../../testredirectparams.txt", @"../../userdave.txt");
			//Mockery mocks = new Mockery();
			//ISiteList mocklist = mocks.NewMock<ISiteList>();
			//ISite mocksite = mocks.NewMock<ISite>();
			//Stub.On(mocksite).GetProperty("SiteID").Will(Return.Value(1));
			//Stub.On(mocksite).GetProperty("SiteName").Will(Return.Value("h2g2"));
			//Stub.On(mocksite).GetProperty("Description").Will(Return.Value("h2g2"));
			//Stub.On(mocksite).GetProperty("ShortName").Will(Return.Value("h2g2")); 
			//Stub.On(mocksite).GetProperty("SSOService").Will(Return.Value("h2g2"));
			//Expect.AtLeastOnce.On(mocklist).Method("GetSite").WithAnyArguments().Will(Return.Value(mocksite));
			//_context.InitialiseSiteList(mocklist);
            
            /*
             * This is broken - the mockery object is not returning as created ???
            UserGroups.RefreshCache(_context);
            string output = UserGroups.GetUserGroupsAsXml(6, 1, _context);
            DnaXmlValidator validator = new DnaXmlValidator(output, "Groups.xsd");
            validator.Validate();
            StringAssert.Contains("<GROUPS", output);
			Assert.IsTrue(UserGroups.IsUserEditorForSite(6, 1, _context), "User 6 should be editor on site 1");
			Assert.IsFalse(UserGroups.IsUserEditorForSite(15459, 1, _context), "User 15459 should not be editor on site 1");
			XmlElement groups = UserGroups.GetSiteGroupsElement(1, _context);
			Assert.IsNotNull(groups, "Null groups element found");
			Assert.IsNotNull(groups.SelectSingleNode("/GROUP[NAME='EDITOR']"), "Missing Editor group in SiteGroupsElement");
			Assert.IsNotNull(groups.SelectSingleNode("/GROUP[NAME='MODERATOR']"), "Missing Moderator group in SiteGroupsElement");
			Assert.IsNotNull(groups.SelectSingleNode("/GROUP[NAME='NOTABLES']"), "Missing Notable group in SiteGroupsElement");
			XmlElement sitesuseriseditorof = UserGroups.GetSitesUserIsEditorOfXML(6, false, _context);
			Assert.IsNotNull(sitesuseriseditorof, "Null element for sites user is editor of");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=1]"), "User isn't editor of site 1");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=9]"), "User isn't editor of site 1");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=66]"), "User isn't editor of site 1");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=68]"), "User isn't editor of site 1");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=71]"), "User isn't editor of site 1");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=72]"), "User isn't editor of site 1");
			Assert.IsNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=73]"), "User is editor of site 73");

			sitesuseriseditorof = UserGroups.GetSitesUserIsEditorOfXML(1581231, false, _context);
			Assert.IsNotNull(sitesuseriseditorof, "Null element for sites user is editor of");
			Assert.IsNotNull(sitesuseriseditorof.SelectSingleNode("SITE-LIST/SITE[@ID=72]"), "User isn't editor of site 1");

			XmlElement userGroups = UserGroups.GetUserGroupsElement(6, 1, _context);
			Assert.IsNotNull(userGroups, "Not expecting NULL userGroups");
			Assert.IsNotNull(userGroups.SelectSingleNode("GROUP[NAME='EDITOR']"), "User should be editor");
			Assert.IsNull(userGroups.SelectSingleNode("GROUP[NAME='MODERATOR']"), "User should not be moderator");

			userGroups = UserGroups.GetUserGroupsElement(1090564231, 1, _context);
			Assert.IsNotNull(userGroups, "Not expecting NULL userGroups");
			Assert.IsNotNull(userGroups.SelectSingleNode("GROUP[NAME='MODERATOR']"), "User should be editor");
			Assert.IsNull(userGroups.SelectSingleNode("GROUP[NAME='EDITOR']"), "User should not be moderator");
			
			userGroups = UserGroups.GetUserGroupsElement(1165233424, 1, _context);
			Assert.IsNotNull(userGroups, "Not expecting NULL userGroups");
			Assert.IsNotNull(userGroups.SelectSingleNode("GROUP[NAME='NOTABLES']"), "User should be editor");
			Assert.IsNull(userGroups.SelectSingleNode("GROUP[NAME='EDITOR']"), "User should not be moderator");
             * */
		}
        /// <summary>
        /// Second UserGroups Test.
        /// </summary>
        [TestMethod]
        public void Test2CheckGroupNameXml()
        {
            string output = UserGroupsHelper.GetUserGroupsAsXml(6, 1, _context);
            DnaXmlValidator validator = new DnaXmlValidator(output, "Groups.xsd");
            validator.Validate();
            StringAssert.Contains(output, "<GROUP><NAME>EDITOR");
        }

        /// <summary>
        /// Setupo function tomake sure that there is at least one comment in a comment box by the test user
        /// </summary>
        private void SetupTestData()
        {
			// Check to see if the test user has created a post in a comment box
			//IInputContext inputContext = new StoredProcedureTestInputContext();
			//using (IDnaDataReader dataReader = inputContext.CreateDnaDataReader("addusertogroups"))
			//{
			//}

			DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
			request.SetCurrentUserEditor();
            request.RequestPage(@"DnaSignal?action=recache-groups");
			request.RequestPage(@"acs?dnauid=RecacheUserGroupsTestForum&dnainitialtitle=UserGroupTest&dnahostpageurl=http://localhost.bbc.co.uk/usergrouptestforum&skin=purexml");
			if (request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']") == null)
			{
				// We need to add a comment!
				request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&dnaaction=add&dnacomment=Userposting&skin=purexml");
			}
			request.SetCurrentUserModerator();
			if (request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']") == null)
			{
				// We need to add a comment!
				request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&dnaaction=add&dnacomment=Userposting2&skin=purexml");
			}
		}

        /// <summary>
        /// Tests to make sure that when the _gc parma is used, that the groups get recached
        /// </summary>
        [TestMethod]
        public void TestRecacheGroupsVia_gc()
        {
            // First check to make sure that a given test group is not pressent
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=1");

            DnaXmlValidator validator = new DnaXmlValidator(request.GetLastResponseAsXML().OuterXml, "H2G2CommentBoxFlat.xsd");
            validator.Validate();

            // Make a copy of the user groups so we can put then back at the end of this test
            XmlNodeList groupnodes = request.GetLastResponseAsXML().SelectNodes("H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME");
            foreach (XmlNode node in groupnodes)
            {
                // Add the group name to the list
                _userGroups.Add(node.InnerText);
            }
			
			CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", false, false);

            // At this point, we need to make sure that the teardown function will corrctly put the user back into the original groups
            _reapplyGroupsForUserID = request.CurrentUserID;

            // Now add the user to the new group via the database
            AddUserToGroup(_reapplyGroupsForUserID, GetIDForSiteName(), "FormerStaff", false);

            // Now make sure that the users group information has not changed for the comment, but has for the viewing user block
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=2");
			CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", true, false);

			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='FORMERSTAFF']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='EDITOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='FORMERSTAFF']") == null);

            // Now send the refresh cache request and make sure that the users group info has been updated
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&_gc=1&xyzzy=3");
			CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", true, true);

			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='FORMERSTAFF']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='EDITOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='FORMERSTAFF']") != null);

            // Now remove the user from the group via the database and reaply the original groups
            AddUserToGroups(_reapplyGroupsForUserID, GetIDForSiteName(), _userGroups, true);

            // We've managed to put the user back into their original groups, so don't make the teardowen function do the same work twice
            _reapplyGroupsForUserID = 0;

            // Now send the refresh cache request and make sure that the users group info has been updated
            request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&_gc=1");
			CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", false, false);

			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='FORMERSTAFF']") == null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='EDITOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='FORMERSTAFF']") == null);

			// Extra tests to see if the signal with single-user effect works
			// We test for two different users - editor and moderator

			// first make a normal request for the moderator page, and check all is well. Also save the groups they are currently in

			// Save the current user ID
			int editorUserID = request.CurrentUserID;
			
			request.SetCurrentUserModerator();
			int moderatorUserId = request.CurrentUserID;
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=4");
			CheckResponseForGroups(request, "MODERATOR", true, true, "FORMERSTAFF", false, false);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='MODERATOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='FORMERSTAFF']") == null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='MODERATOR']") != null);
			//Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='FORMERSTAFF']") == null);

			// Save this user's groups
			List<string> moderatorsGroups = new List<string>();
			groupnodes = request.GetLastResponseAsXML().SelectNodes("H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME");
			foreach (XmlNode node in groupnodes)
			{
				// Add the group name to the list
				moderatorsGroups.Add(node.InnerText);
			}

			
			// Now add the users to the new group via the database
			AddUserToGroup(editorUserID, GetIDForSiteName(), "FormerStaff", false);
			AddUserToGroup(moderatorUserId, GetIDForSiteName(), "FormerStaff", false);

			// Now check, for each of these users, that the cached user info is wrong, but ViewingUser is correct

			request.SetCurrentUserModerator();
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=5");
			CheckResponseForGroups(request, "MODERATOR", true, true, "FORMERSTAFF", true, false);

			request.SetCurrentUserEditor();
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=6");
			CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", true, false);

			// Now signal just for the editor user
			request.RequestPage("dnaSignal?action=recache-groups&userid=" + editorUserID + "&skin=purexml");

			// fetch pages for both users - the editor user will have been updated, the moderator user will not
			request.SetCurrentUserModerator();
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=7");
			CheckResponseForGroups(request, "MODERATOR", true, true, "FORMERSTAFF", true, false);//should not be updated in second post as user not recached

			request.SetCurrentUserEditor();
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=8");
            CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", true, true);//should be updated in second post as user recached

			// TODO: reapply groups for both users and check all is well
			AddUserToGroups(editorUserID, GetIDForSiteName(), _userGroups, true);
			AddUserToGroups(moderatorUserId, GetIDForSiteName(), moderatorsGroups, true);

			// tell it to recache data
			request.SetCurrentUserModerator();
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&_gc=1");
			//request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=9");
			CheckResponseForGroups(request, "MODERATOR", true, true, "FORMERSTAFF", false, false);

			request.SetCurrentUserEditor();
			request.RequestPage("acs?dnauid=RecacheUserGroupsTestForum&skin=purexml&xyzzy=10");
			CheckResponseForGroups(request, "EDITOR", true, true, "FORMERSTAFF", false, false);
		}

		private void CheckResponseForGroups(DnaTestURLRequest request, string firstGroup, bool expectFirstViewingUser, bool expectFirstPost, string secondGroup, bool expectSecondViewingUser, bool expectSecondPost)
		{
			Console.WriteLine("Request response:");
			Console.WriteLine(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/VIEWING-USER").InnerXml);
			Console.WriteLine(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").InnerXml);
			CheckResponseForGroup(request, firstGroup, expectFirstViewingUser, expectFirstPost);
			CheckResponseForGroup(request, secondGroup, expectSecondViewingUser, expectSecondPost);
		}

		private void CheckResponseForGroup(DnaTestURLRequest request, string groupname, bool expectInViewingUser, bool expectInPost)
		{
			Assert.AreEqual(expectInViewingUser, IsGroupInViewingUser(request, groupname), "Group " + groupname + " in Viewing User does not match expectations");
			Assert.AreEqual(expectInPost, IsGroupInPostingUser(request, groupname), "Group " + groupname + " in Posting User does not match expectations");
		}

		private bool IsGroupInViewingUser(DnaTestURLRequest request, string groupName)
		{
			return request.GetLastResponseAsXML().SelectSingleNode("H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='" + groupName + "']") != null;
		}

		private bool IsGroupInPostingUser(DnaTestURLRequest request, string groupName)
		{
			return request.GetLastResponseAsXML().SelectSingleNode("H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/USER[USERNAME='" + request.CurrentUserName + "']/GROUPS/GROUP[NAME='" + groupName + "']") != null;
		}


        /// <summary>
        /// Helper function for adding a user to a group on a given site
        /// </summary>
        /// <param name="userID">The id of the user you want to add to a group</param>
        /// <param name="siteID">The id of the site that the groups should be added to</param>
        /// <param name="groupName">The name of the group you want to add the user to</param>
        /// <param name="removeFromAllFirst">A flag that when set to true will remove the user from all groups before adding to the chosen group</param>
        public void AddUserToGroup(int userID, int siteID, string groupName, bool removeFromAllFirst)
        {
            // Check to see if we want to remove the user from all groups first
            if (removeFromAllFirst)
            {
                RemoveUserFromAllGroupsForSite(userID, siteID);
            }

            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("addusertogroups"))
                {
                    dataReader.AddParameter("siteid", siteID);
                    dataReader.AddParameter("userid", userID);
                    dataReader.AddParameter("groupname1", groupName);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
            }
        }

        /// <summary>
        /// Helper function for adding a user to groups for a given site. Note that the user will be removed from all groups first
        /// </summary>
        /// <param name="userID">The id of the user you want to add the groups for</param>
        /// <param name="siteID">The id of the site that you want to add the groups to</param>
        /// <param name="groups">The list of groups that you want the user to belong to</param>
        /// <param name="removeFromAllFirst">A flag that when set to true will remove the user from all groups before adding to the chosen groups</param>
        public void AddUserToGroups(int userID, int siteID, List<string> groups, bool removeFromAllFirst)
        {
            // Check to see if we want to remove the user from all groups first
            if (removeFromAllFirst)
            {
                RemoveUserFromAllGroupsForSite(userID, siteID);
            }

            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("addusertogroups"))
                {
                    dataReader.AddParameter("siteid", siteID);
                    dataReader.AddParameter("userid", userID);
                    int i = 1;
                    foreach (string groupName in groups)
                    {
                        dataReader.AddParameter("groupname" + i++, groupName);
                    }
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
            }
        }

        /// <summary>
        /// Helper function for removing users from all groups on a given site
        /// </summary>
        /// <param name="userID">The id of the user you want to remove from the groups</param>
        /// <param name="siteID">The dite that you want to remove the groups for</param>
        public void RemoveUserFromAllGroupsForSite(int userID, int siteID)
        {
            // First remove the user from all groups and reaply the ones given
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("clearusersgroupmembership"))
                {
                    dataReader.AddParameter("siteid", siteID);
                    dataReader.AddParameter("userid", userID);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
            }
        }

        /// <summary>
        /// Teardown function for making sure that the user is added back to the correct usergroups
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            // Check to see if we're required to reapply the users groups
            if (_reapplyGroupsForUserID > 0)
            {
                // Now remove the user from the group via the database and reaply the original groups
                AddUserToGroups(_reapplyGroupsForUserID, GetIDForSiteName(), _userGroups, true);
            }
        }
    }
}
