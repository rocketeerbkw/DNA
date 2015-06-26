using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// This class tests that the database handles users who are in premod or autosinbin
    /// </summary>
    [TestClass]
    public class AutoSinBinUserTests
    {
        internal class DnaHasher
        {
            /// <summary>
            /// GenerateCommentHashValue - Generate a hash value unique for a given content, uid and userid.
            /// </summary>
            /// <param name="content">comment body</param>
            /// <param name="uid">unique identifier of comment box</param>
            /// <param name="userID">userid of author</param>
            public Guid GenerateCommentHashValue(string content, string uid, int userID)
            {
                string source = content + "<:>" + uid + "<:>" + userID.ToString();
                System.Text.UTF8Encoding utf8 = new System.Text.UTF8Encoding();
                MD5CryptoServiceProvider md5Hasher = new System.Security.Cryptography.MD5CryptoServiceProvider();
                byte[] hashedDataBytes = md5Hasher.ComputeHash(utf8.GetBytes(source));
                return new Guid(hashedDataBytes);
            }
        }

        /// <summary>
        /// Test to make sure that a user in auto sin bin gets their posts modded and that when the post count threshhold
        /// is reached, they are taken out of the bin
        /// </summary>
        [TestMethod]
        public void TestAutoSinBinUsersPostsArePreModdedUsingCreateComment()
        {
            // Restore the database
            SnapshotInitialisation.ForceRestore();

            // Create a context capable for creating real data readers
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the autosinbin flag
            using (IDnaDataReader reader = context.CreateDnaDataReader("setsiteoption"))
            {
                // Set users in h2g2 to be premodded for a day
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PostCountThreshold");
                reader.AddParameter("Value", "1");
                reader.Execute();
            }

            // Not using premod timeout for this test.
            using (IDnaDataReader reader = context.CreateDnaDataReader("setsiteoption"))
            {
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PreModDuration");
                reader.AddParameter("Value", "0");
                reader.Execute();
            }

            // Create a new user in the database for h2g2
            int userID = CreateUserInDatabase(context, 1);

            // First create a new comment forum
            string uid = "TestUniqueKeyValue" + Guid.NewGuid().ToString();
            string url = "www.bbc.co.uk/dna/commentforumtestpage.html";
            using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
            {
                reader.AddParameter("uid", uid);
                reader.AddParameter("url", url);
                reader.AddParameter("Title", "TEST");
                reader.AddParameter("siteid", 1);
                reader.AddParameter("CreateIfNotExists", 1);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                byte moderationStatus = reader.GetByteNullAsZero("moderationStatus");
                int forumid = reader.GetInt32("ForumID");
                int canread = reader.GetByteNullAsZero("ForumCanRead");
                int canwrite = reader.GetByteNullAsZero("ForumCanWrite");
            }

            // Now post using create comment
            DnaHasher hasher = new DnaHasher();
            string comment = "Testing autosinbin user";
            Guid guid = hasher.GenerateCommentHashValue(comment, uid, userID);
            using (IDnaDataReader reader = context.CreateDnaDataReader("CreateComment"))
            {
                reader.AddParameter("uniqueid", uid);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("userid", userID);
                reader.AddParameter("content", comment);
                reader.AddParameter("hash", guid);
                reader.AddParameter("forcemoderation", 0);
                reader.AddParameter("ignoremoderation", 0);
                reader.AddParameter("isnotable", 0);
                reader.AddParameter("poststyle", 1);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");
                Assert.IsTrue(reader.GetInt32("PostID") > 0, "No post id was returned!");
                Assert.IsTrue(reader.GetStringNullAsEmpty("HostPageURL") != String.Empty, "The host page url was not present");
                Assert.IsTrue(reader.GetBoolean("ispremoderated"), "The premod value was not 1");
                Assert.IsTrue(reader.GetInt32("PreModPostingModId")==0, "The post should not of been in the premod posting queue");
            }

            // Now update the users sinbin status
            using (IDnaDataReader reader = context.CreateDnaDataReader("updateautosinbinstatus"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddIntOutputParameter("AutoSinBin");
                reader.Execute();

                // Check to make sure that the user has been taken out of the sinbin
                int isInSinBin = 0;
                reader.TryGetIntOutputParameter("AutoSinBin", out isInSinBin);
                Assert.AreEqual(0, isInSinBin, "The user should not be in the auto sin bin any more!");
            }

            // Now post again, this time the autosinbin should not effect the user as they have posted the require amount to lift the ban
            hasher = new DnaHasher();
            comment = "Testing autosinbin user out of bin";
            guid = hasher.GenerateCommentHashValue(comment, uid, userID);
            using (IDnaDataReader reader = context.CreateDnaDataReader("CreateComment"))
            {
                reader.AddParameter("uniqueid", uid);
                reader.AddParameter("userid", userID);
                reader.AddParameter("siteid", 1);
                reader.AddParameter("content", comment);
                reader.AddParameter("hash", guid);
                reader.AddParameter("forcemoderation", 0);
                reader.AddParameter("ignoremoderation", 0);
                reader.AddParameter("isnotable", 0);
                reader.AddParameter("poststyle", 1);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");
                Assert.IsTrue(reader.GetInt32("PostID") > 0, "No post id was returned!");
                Assert.IsTrue(reader.GetStringNullAsEmpty("HostPageURL") != String.Empty, "The host page url was not present");
                Assert.IsFalse(reader.GetBoolean("ispremoderated"), "The premod value was not 0");
                Assert.IsTrue(reader.GetInt32("PreModPostingModId") == 0, "The post should not of been in the premod posting queue");
            }
        }


        /// <summary>
        /// Test to make sure that a user in auto sin bin gets their articles modded and that when the post count threshhold
        /// is reached, they are taken out of the bin
        /// </summary>
        [TestMethod]
        public void TestAutoSinBinUsersPostsArePreModdedUsingCreateArticle()
        {
            // Restore the database
            SnapshotInitialisation.ForceRestore();

            // Create a context capable for creating real data readers
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the autosinbin flag
            using (IDnaDataReader reader = context.CreateDnaDataReader("setsiteoption"))
            {
                // Set users in h2g2 to be premodded for a day
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PostCountThreshold");
                reader.AddParameter("Value", "1");
                reader.Execute();
            }

            // Not using premod timeout for this test.
            using (IDnaDataReader reader = context.CreateDnaDataReader("setsiteoption"))
            {
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("Section", "User");
                reader.AddParameter("Name", "PreModDuration");
                reader.AddParameter("Value", "0");
                reader.Execute();
            }

            // Create a new user in the database for h2g2
            int userID = CreateUserInDatabase(context, 1);

            // Create an article
            int entryID = 0;
            using (IDnaDataReader reader = context.CreateDnaDataReader("createguideentry"))
            {
                reader.AddParameter("Subject","Test Article");
                reader.AddParameter("BodyText","Sample test data");
                reader.AddParameter("ExtraInfo","Nothing special");
                reader.AddParameter("Editor",userID);
                reader.AddParameter("TypeID",1);
                reader.AddParameter("SiteID",1);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");
                entryID = reader.GetInt32("EntryID");
                Assert.IsTrue(entryID > 0, "Invalid entry id returned");
            }

            // Now check to make sure the article was premoderated
            using (IDnaDataReader reader = context.CreateDnaDataReader("FetchArticleDetails"))
            {
                reader.AddParameter("EntryID", entryID);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");
                Assert.AreEqual(3, reader.GetInt32("Hidden"), "The hidden flag should be set to 3 for moderation!");
            }

            // Now update the users sinbin status
            using (IDnaDataReader reader = context.CreateDnaDataReader("updateautosinbinstatus"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", 1);
                reader.AddIntOutputParameter("AutoSinBin");
                reader.Execute();

                // Check to make sure that the user has been taken out of the sinbin
                int isInSinBin = 0;
                reader.TryGetIntOutputParameter("AutoSinBin", out isInSinBin);
                Assert.AreEqual(0, isInSinBin, "The user should not be in the auto sin bin any more!");
            }

            // Now create another article 
            using (IDnaDataReader reader = context.CreateDnaDataReader("createguideentry"))
            {
                reader.AddParameter("Subject", "Test Article3");
                reader.AddParameter("BodyText", "Sample test data3");
                reader.AddParameter("ExtraInfo", "Nothing special3");
                reader.AddParameter("Editor", userID);
                reader.AddParameter("TypeID", 1);
                reader.AddParameter("SiteID", 1);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");
                entryID = reader.GetInt32("EntryID");
                Assert.IsTrue(entryID > 0, "Invalid entry id returned");
            }

            // Now check to make sure the article was not premodded due to the user comming out of autosinbin
            using (IDnaDataReader reader = context.CreateDnaDataReader("FetchArticleDetails"))
            {
                reader.AddParameter("EntryID", entryID);
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");
                Assert.AreEqual(0, reader.GetInt32NullAsZero("Hidden"), "The hidden flag should be set to NULL for moderation!");
            }
        }

        /// <summary>
        /// Helper method for creating a new user in the database
        /// </summary>
        /// <param name="context">The context in which to create the data reader</param>
        /// <param name="autoSinBinExpectedValue">The expected value for the autosinbin when checked</param>
        /// <returns>The id of the new user</returns>
        private static int CreateUserInDatabase(IInputContext context, int autoSinBinExpectedValue)
        {
            int userID = Int32.MaxValue - 1000000;
            using (IDnaDataReader reader = context.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("ssouserid", userID);
                reader.AddParameter("UserName", "TestUser");
                reader.AddParameter("Email", "a@b.c");
                reader.AddParameter("SiteID", 1);
                reader.AddParameter("FirstNames", "MR");
                reader.AddParameter("LastName", "TESTER");
                reader.Execute();

                // Check to make sure that we got something back
                Assert.IsTrue(reader.HasRows, "Creating a new user returned no data!");
                Assert.IsTrue(reader.Read(), "Failed to read the first row of data!");

                // Now check the values comming back from the database
                userID = reader.GetInt32("UserID");
                Assert.AreNotEqual(0, reader.GetInt32("UserID"), "UserId does not match the one entered");
                Assert.AreEqual("TestUser", reader.GetString("LoginName"), "Users login name does not match the one entered");
                Assert.AreEqual("TestUser", reader.GetString("UserName"), "Users name does not match the one entered");

                //**************************************************************************************
                // SPF 3/12/09 Due to the removal of First Names Last Name due to legal issues,
                // the First Names and Last Name will be NULL
                //**************************************************************************************
                Assert.IsTrue(reader.IsDBNull("FirstNames"), "Users first name is not NULL");
                Assert.IsTrue(reader.IsDBNull("LastName"), "The users last name is not NULL");
                // *************************************************************************************

                Assert.AreEqual("a@b.c", reader.GetString("Email"), "The users email does not match the one entered");

                // Here are the important ones for this test
                Assert.IsTrue(reader.GetDateTime("DateJoined") > DateTime.Now.AddMinutes(-1), "The users date joined value is not with in the tolarences of this test!");
                Assert.AreEqual(autoSinBinExpectedValue, reader.GetTinyIntAsInt("AutoSinBin"), "The user should be in the auto sin bin!");
                Assert.AreEqual(1, reader.GetTinyIntAsInt("Status"), "The user status is not correct");
                Assert.AreEqual(0, reader.GetTinyIntAsInt("PrefStatus"), "The user pref status is not correct");
            }

            return userID;
        }
    }
}
