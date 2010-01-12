using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace TestUtils
{
    
    /// <summary>
    /// Constructor
    /// </summary>
    public class TestDataCreator : DnaInputComponent
    {
        /// <summary>
        /// alphabet used for creating random strings
        /// </summary>
        //private string _Alphabet = "abcdefghijklmnopqrstuvwxyz";

        /// <summary>
        /// Constructor
        /// </summary>
        public TestDataCreator(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// CreateEntries creates random entries for a given site id
        /// </summary>
        /// <param name="siteID">the site id</param>
        /// <param name="EntryIDs">an array returned of entries that was created. Pass in an initalised array for size</param>
        /// <param name="H2G2IDs">an array returned of H2G2IDs that was created. Pass in an initalised array for size</param>
        /// <returns></returns>
        public bool CreateEntries(int siteID, int editorid, int typeid, int status, ref int[] EntryIDs, ref int[] H2G2IDs)
        {
            if (EntryIDs == null)
                return false;

            if (H2G2IDs == null)
                return false;

            if (H2G2IDs.Length != EntryIDs.Length)
                return false;

            for (int counter = 0; counter < EntryIDs.Length; counter++)
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createguideentry"))
                {
                    reader.AddParameter("subject", CreateRandomString(20));
                    reader.AddParameter("bodytext", CreateRandomString(20));
                    reader.AddParameter("extrainfo", "");
                    reader.AddParameter("editor", editorid);
                    reader.AddParameter("typeid", typeid);
                    reader.AddParameter("status", status);
                    reader.AddParameter("siteid", siteID);

                    reader.Execute();
                    if (!reader.Read())
                    {
                        return false;
                    }
                    EntryIDs[counter] = reader.GetInt32NullAsZero("EntryID");
                    H2G2IDs[counter] = reader.GetInt32NullAsZero("h2g2ID");
                }
            }
            return true;
        }

        /// <summary>
        /// Creates a random entry for a given site id
        /// </summary>
        /// <param name="siteID">the site id</param>
        /// <param name="EntryID">The entry ID that was created. </param>
        /// <param name="H2G2ID">The H2G2ID that was created. </param>
        /// <returns></returns>
        public bool CreateEntry(int siteID, int editorid, int typeid, int status, ref int EntryID, ref int H2G2ID)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createguideentry"))
            {
                reader.AddParameter("subject", CreateRandomString(20));
                reader.AddParameter("bodytext", CreateRandomString(20));
                reader.AddParameter("extrainfo", "");
                reader.AddParameter("editor", editorid);
                reader.AddParameter("typeid", typeid);
                reader.AddParameter("status", status);
                reader.AddParameter("siteid", siteID);

                reader.Execute();
                if (!reader.Read())
                {
                    return false;
                }
                EntryID  = reader.GetInt32NullAsZero("EntryID");
                H2G2ID  = reader.GetInt32NullAsZero("h2g2ID");
            }
            return true;
        }
        
        /// <summary>
        /// Takes the entry ids and recommends them
        /// </summary>
        /// <param name="scoutid">Teh user id who is recommending</param>
        /// <param name="EntryIDs">an array of entries to recommend</param>
        /// <param name="RecommendationIDs">A returned array of recommendation IDs</param>
        /// <returns>True for success</returns>
        public bool CreateRecommendations(int scoutID, int[] EntryIDs, ref int[] RecommendationIDs)
        {
            if (EntryIDs == null)
                return false;

            RecommendationIDs =  new int[EntryIDs.Length];

            for (int counter = 0; counter < EntryIDs.Length; counter++)
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("storescoutrecommendation"))
                {
                    reader.AddParameter("entryid", EntryIDs[counter]);
                    reader.AddParameter("@comments", CreateRandomString(30));
                    reader.AddParameter("scoutid", scoutID);
                    reader.Execute();
                    if (!reader.Read())
                    {
                        return false;
                    }
                    RecommendationIDs[counter] = reader.GetInt32NullAsZero("RecommendationID");
                }
            }
            return true;
        }

        /// <summary>
        /// Accepts recommendations made by scout
        /// </summary>
        /// <param name="acceptorid">the acceptors userid</param>
        /// <param name="RecommendationIDs">an array of recommendations for acceptance</param>
        /// <returns></returns>
        public bool AcceptRecommendations(int acceptorID, int[] RecommendationIDs)
        {
            if (RecommendationIDs == null)
                return false;

            for (int counter = 0; counter < RecommendationIDs.Length; counter++)
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("acceptscoutrecommendation"))
                {
                    reader.AddParameter("recommendationid", RecommendationIDs[counter]);
                    reader.AddParameter("comments", CreateRandomString(30));
                    reader.AddParameter("acceptorid", acceptorID);
                    reader.Execute();
                    if (!reader.Read())
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        
        /// <summary>
        /// Creates new users for a given site
        /// </summary>
        /// <param name="siteID">site id</param>
        /// <param name="userIDs">returned array of userids</param>
        /// <returns></returns>
        public bool CreateNewUsers(int siteID, ref int[] userIDs)
        {
            if (userIDs == null)
                return false;

            for (int counter = 0; counter < userIDs.Length; counter++)
            {
                Random randObj = new Random();
                int userID = randObj.Next(Int32.MaxValue);
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createnewuserfromuserid"))
                {
                    reader.AddParameter("userid", userID);
                    reader.AddParameter("username", CreateRandomString(30));
                    reader.AddParameter("email", String.Format("{0}@{1}.co.uk", CreateRandomString(30), CreateRandomString(30)));
                    reader.AddParameter("siteid", siteID);
                    reader.AddParameter("firstnames", CreateRandomString(30));
                    reader.AddParameter("lastname", CreateRandomString(30));
                    reader.Execute();
                    if (!reader.Read())
                    {
                        return false;
                    }
                    userIDs[counter] = userID;
                }
            }

            return true;

        }

        /// <summary>
        /// Creates a new user group if it doesn't exist
        /// </summary>
        /// <param name="ownerID">the userid who owns the group</param>
        /// <param name="GroupName">The name of the group</param>
        /// <returns></returns>
        public bool CreateNewUserGroup(int ownerID, string GroupName)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createnewusergroup"))
            {
                reader.AddParameter("userid", ownerID);
                reader.AddParameter("groupname", GroupName);
                reader.Execute();
                if (!reader.Read())
                {
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Adds users to a certain group
        /// </summary>
        /// <param name="userIDs">user IDs to add</param>
        /// <param name="siteID">the site id</param>
        /// <param name="groupName">The name of the group</param>
        /// <returns></returns>
        public bool AddUsersToGroup(int[] userIDs, int siteID, string groupName)
        {
            if (userIDs == null)
                return false;

            for (int counter = 0; counter < userIDs.Length; counter++)
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addusertogroups"))
                {
                    reader.AddParameter("userid", userIDs[counter]);
                    reader.AddParameter("siteid", siteID);
                    reader.AddParameter("groupname1", groupName);
                    reader.Execute();
                    if (!reader.Read())
                    {
                        return false;
                    }
                }
            }

            return true;
        }


        /// <summary>
        /// Returns a random string of 
        /// </summary>
        /// <param name="size">the size of the string</param>
        /// <returns>the random string</returns>
        private string CreateRandomString(int size)
        {
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            char ch;
            for (int i = 0; i < size; i++)
            {
                ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
                builder.Append(ch);
            }
            return builder.ToString();
        }

        /// <summary>
        /// Creates and Submits an article for Review
        /// </summary>
        /// <returns>The forum id of the created peer review forum</returns>
        public int CreateAndSubmitArticleForReview()
        {
            int entryID = 0;
            int h2g2ID = 0;
            //create a dummy article

            string subject = "TEST ARTICLE" + CreateRandomString(20);
            string content = "TEST ARTICLE" + CreateRandomString(20);

            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createguideentry"))
            {
                reader.AddParameter("subject", subject);
                reader.AddParameter("bodytext", content);
                reader.AddParameter("extrainfo", "<EXTRAINFO>TEST ARTICLE</EXTRAINFO>");
                reader.AddParameter("editor", 6);
                reader.AddParameter("typeid", 3001);
                reader.AddParameter("status", 3);
                reader.AddParameter("siteid", 1);

                reader.Execute();
                if (!reader.Read())
                {
                    return 0;
                }

                entryID = reader.GetInt32NullAsZero("entryid");
                h2g2ID = reader.GetInt32NullAsZero("h2g2id");
            }

            string hashString = subject + "<:>" + content + "<:>6<:>0";
            int threadID = 0;
            int postID = 0;
            int forumID = 0;

            using (IDnaDataReader reader2 = InputContext.CreateDnaDataReader("addarticletoreviewforummembers"))
            {
                reader2.AddParameter("h2g2id", h2g2ID);
                reader2.AddParameter("reviewforumid", 1);
                reader2.AddParameter("submitterid", 6);
                reader2.AddParameter("subject", subject);
                reader2.AddParameter("content", content);
                reader2.AddParameter("hash", DnaHasher.GenerateHash(hashString));

                reader2.Execute();
                if (!reader2.Read())
                {
                    return 0;
                }

                threadID = reader2.GetInt32NullAsZero("ThreadID");
                postID = reader2.GetInt32NullAsZero("PostID");
                forumID = reader2.GetInt32NullAsZero("ForumID");
            }

            return forumID;
        }


    }
}
