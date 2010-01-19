using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// WatchList - A derived DnaInputComponent object to get the watch list
    /// </summary>
    public class WatchList : DnaInputComponent
    {
        /// <summary>
        /// Default Constructor for the Watch List object
        /// </summary>
        public WatchList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Generate the Watched User List for a particular user
        /// </summary>
        /// <param name="userID">User ID</param>
        public void Initialise(int userID)
        {
            RootElement.RemoveAll();
            XmlElement watchedUserList = AddElementTag(RootElement, "WATCHED-USER-LIST");
            AddAttribute(watchedUserList, "USERID", userID);
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchwatchedjournals"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int watchedUserID = dataReader.GetInt32NullAsZero("UserID");
                        User tempUser = new User(InputContext);
                        tempUser.AddUserXMLBlock(dataReader, watchedUserID, watchedUserList);
                    }
                }
            }

        }
        /// <summary>
        /// Generate the Watching User List for a particular user
        /// </summary>
        /// <param name="userID">User ID</param>
        /// <param name="siteID">Site ID</param>
        public void WatchingUsers(int userID, int siteID)
        {
            RootElement.RemoveAll();
            XmlElement watchingUserList = AddElementTag(RootElement, "WATCHING-USER-LIST");
            AddAttribute(watchingUserList, "USERID", userID);
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("watchingusers"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("siteID", siteID);
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int watchingUserID = dataReader.GetInt32NullAsZero("UserID");
                        User tempUser = new User(InputContext);
                        tempUser.AddUserXMLBlock(dataReader, watchingUserID, watchingUserList);
                    }
                }
            }

        }
    }
}

