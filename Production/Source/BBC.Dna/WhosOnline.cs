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
    /// WhosOnline - A derived DnaInputComponent object to get whos online
    /// </summary>
    public class WhosOnline : DnaInputComponent
    {
        /// <summary>
        /// Default Constructor for the WhosOnline object
        /// </summary>
        public WhosOnline(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Generate the Whos Online list
        /// </summary>
        /// <param name="orderBy">Ordering parmeter</param>
        /// <param name="siteID">The site </param>
        /// <param name="currentSiteOnly">Whether to only include people from this site</param>
        /// <param name="fetchFromCache">Whether to get it from the cache</param>
        public void Initialise(string orderBy, int siteID, bool currentSiteOnly, bool fetchFromCache)
        {
            string lowerOrderBy = orderBy.ToLower();
            if (lowerOrderBy != "id" && lowerOrderBy != "name")
            {
                lowerOrderBy = "none";
            }
            string cacheName = String.Empty;
            if(currentSiteOnly)
            {
                //Cache - users specific to current site
                cacheName = "online-" + siteID.ToString() + ".txt";
            }
            else
            {
                //All users.
                cacheName = "online.txt";
            }


            DateTime lastDate;
            if (fetchFromCache)
            {
                lastDate = DateTime.Now.AddSeconds(-60 * 20);
            }
            else
            {
                lastDate = DateTime.Now.AddSeconds(-60 * 5);	// cache for five minutes
            }

            string cachedWhosOnline = "";
            if (InputContext.FileCacheGetItem("onlineusers", cacheName, ref lastDate, ref cachedWhosOnline) && cachedWhosOnline.Length > 0)
            {
                // Create the journal from the cache
                CreateAndInsertCachedXML(cachedWhosOnline, "ONLINEUSERS", true);
                return;
            }
            bool cacheResult = false;
            XmlElement whosOnline = AddElementTag(RootElement, "ONLINEUSERS");
            if (currentSiteOnly)
            {
		        //Indicate - recently logged users for this site only.
                AddAttribute(whosOnline, "THISSITE", 1);
            }
            AddAttribute(whosOnline, "ORDER-BY", lowerOrderBy);

	        // create a stored procedure to access the database
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("currentusers"))
            {
                dataReader.AddParameter("siteid", siteID);
                if (currentSiteOnly)
                {
                    dataReader.AddParameter("currentsiteonly", 1);
                }
                // attempt to query the database through the stored procedure
                // asking for a block listing all the online users 
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    cacheResult = true;
                    // generate XML for each online user as we go
                    while (dataReader.Read())
                    {
                        XmlElement onlineUser = AddElementTag(whosOnline, "ONLINEUSER");
                        XmlElement user = AddElementTag(onlineUser, "USER");

                        // add his/her user id
                        int userID = dataReader.GetInt32NullAsZero("userID");
                        AddIntElement(user, "USERID", userID);
                        AddIntElement(user, "EDITOR", dataReader.GetInt32NullAsZero("Editor"));

                        string userName = dataReader.GetStringNullAsEmpty("UserName");
                        if (userName == String.Empty)
                        {
                            userName = "Member " + userID.ToString();
                        }
                        AddTextTag(user, "USERNAME", userName);

                        // get a representation of the date a user joined and the current date
                        DateTime dateJoined = dataReader.GetDateTime("DateJoined");
                        DateTime currentTime = DateTime.Now;

                        // and subtract the date joined from the current time giving a date span
                        TimeSpan howLongAgo = currentTime - dateJoined;

                        // add the information about how long it is since they joined to the block
                        AddIntElement(onlineUser, "DAYSINCEJOINED", howLongAgo.Days);
                    }
                }
                else
                {
                    // otherwise tell the user that nobody is online
                    AddTextTag(whosOnline, "WEIRD", "Nobody is online! Nobody! Not even you!");
                }
            }
            if (cacheResult)
            {
                //If have results and XML created then cache.
                InputContext.FileCachePutItem("onlineusers", cacheName, whosOnline.OuterXml);
            }
        }
    }
}