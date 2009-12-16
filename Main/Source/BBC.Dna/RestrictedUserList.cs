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
    /// Restricted User List - A derived DnaInputComponent object to get the list of restricted user for a site
    /// </summary>
    public class RestrictedUserList : DnaInputComponent
    {
        int _totalUsers = 0;

        /// <summary>
        /// Default Constructor for the Restricted User List object
        /// </summary>
        public RestrictedUserList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Field for the Total Users returned in the list
        /// </summary>
        public int TotalUsers
        {
            get { return _totalUsers; }
        }

        /// <summary>
        /// Functions generates the Restricted User List
        /// </summary>
        /// <param name="siteID">Site of the restricted users</param>
        /// <param name="skip">Number of accounts to skip</param>
        /// <param name="show">Number to show</param>
        /// <param name="userTypes">The type of restricted users to bring back Banned and/or Premoderated</param>
        /// <param name="searchType">The type of search to perform</param>
        /// <param name="letter">The beginning letter of the restricted users email to restrict to</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRestrictedUserList(int siteID, int skip, int show, int userTypes, int searchType, string letter)
        {
            if (show <= 0)
            {
                return false;
            }

            int count = show;

            XmlElement restrictedUserList = AddElementTag(RootElement, "RESTRICTEDUSER-LIST");
            AddAttribute(restrictedUserList, "SKIP", skip);
            AddAttribute(restrictedUserList, "SHOW", show);
            AddAttribute(restrictedUserList, "TYPES", userTypes);
            AddAttribute(restrictedUserList, "SEARCHTYPE", searchType);
            AddAttribute(restrictedUserList, "LETTER", letter);

            using (IDnaDataReader dataReader = GetRestrictedUserList(siteID, skip, show + 1, userTypes, searchType, letter))	// Get +1 so we know if there are more left
            {
                // Check to see if we found anything
                string userName = String.Empty;
                if (dataReader.HasRows && dataReader.Read())
                {
                    XmlElement userAccounts = CreateElement("USERACCOUNTS");
                    XmlNode userAccount = null;

                    _totalUsers = dataReader.GetInt32NullAsZero("total");

                    do
                    {
                        int restrictedUserID = dataReader.GetInt32NullAsZero("UserID");
                        
                        userAccount = CreateElementNode("USERACCOUNT");

                        //Start filling new user xml
                        AddAttribute(userAccount, "USERID", restrictedUserID);

                        AddTextTag(userAccount, "SITEID", dataReader.GetInt32NullAsZero("SITEID"));

                        AddTextTag(userAccount, "USERNAME", dataReader.GetStringNullAsEmpty("USERNAME"));
                        AddTextTag(userAccount, "LOGINNAME", dataReader.GetStringNullAsEmpty("LOGINNAME"));
                        AddTextTag(userAccount, "EMAIL", dataReader.GetStringNullAsEmpty("EMAIL"));
                        AddTextTag(userAccount, "PREFSTATUS", dataReader.GetInt32NullAsZero("PREFSTATUS"));
                        AddTextTag(userAccount, "PREFSTATUSDURATION", dataReader.GetInt32NullAsZero("PREFSTATUSDURATION"));
                        AddTextTag(userAccount, "USERSTATUSDESCRIPTION", dataReader.GetStringNullAsEmpty("USERSTATUSDESCRIPTION"));

                        if (!dataReader.IsDBNull("PREFSTATUSCHANGEDDATE"))
                        {
                            DateTime prefStatusChangedDate = dataReader.GetDateTime("PREFSTATUSCHANGEDDATE");
                            AddDateXml(prefStatusChangedDate, userAccount, "PREFSTATUSCHANGEDDATE");
                        }
                        else
                        {
                            AddTextTag(userAccount, "PREFSTATUSCHANGEDDATE", "");
                        }

                        AddTextTag(userAccount, "SHORTNAME", dataReader.GetStringNullAsEmpty("SHORTNAME"));
                        AddTextTag(userAccount, "URLNAME", dataReader.GetStringNullAsEmpty("URLNAME"));

                        userAccounts.AppendChild(userAccount);

                        count--;

                    } while (count > 0 && dataReader.Read());	// dataReader.Read won't get called if count == 0

                    restrictedUserList.AppendChild(userAccounts);

					// See if there's an extra row waiting
					if (count == 0 && dataReader.Read())
					{
                        AddAttribute(restrictedUserList, "MORE", 1);
					}
                }
            }
            return true;
        }

        /// <summary>
        /// Does the correct call to the database to get the restricted user list for a site.
        /// </summary>
        /// <param name="siteId">SiteID of the restricted user list to get</param>
        /// <param name="skip">The number of users to skip</param>
        /// <param name="show">The number of users to show</param>
        /// <param name="userTypes">The type of restricted users to bring back Banned and/or Premoderated</param>
        /// <param name="searchType">The type of search to perform</param>
        /// <param name="letter">The beginning letter of the restricted users email to restrict to</param>
        /// <returns>Data Reader</returns>
        IDnaDataReader GetRestrictedUserList(int siteId, int skip, int show, int userTypes, int searchType, string letter)
        {
            IDnaDataReader dataReader;
            string storedProcedureName = String.Empty;
            if (searchType == 1)
            {
                storedProcedureName = "GetRestrictedUserListWithLetter";
            }
            else
            {
                storedProcedureName = "GetRestrictedUserList";
            }


            dataReader = InputContext.CreateDnaDataReader(storedProcedureName);

            dataReader.AddParameter("viewinguserid", InputContext.ViewingUser.UserID)
                .AddParameter("skip", skip)
                .AddParameter("show", show)
                .AddParameter("usertypes", userTypes)
                .AddParameter("siteid", siteId);

            if (searchType == 1)
            {
                dataReader.AddParameter("letter", letter);
            }

            dataReader.Execute();

            return dataReader;
        }
    }
}