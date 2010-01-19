using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna.Component;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Data;
using System.Threading;

namespace BBC.Dna
{
    /// <summary>
    /// Helper class user list and adds to xml
    /// </summary>
    public class UserList : DnaInputComponent
    {
        /// <summary>
        /// Default constructor of SubAllocationForm
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UserList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Creates a list of all the users that registered within the given
        ///		number of time units.
        /// </summary>
        /// <param name="numberOfUnits">The number of time units since registration to use as a definition of being a new user for this list.</param>
        /// <param name="maxNumber">The maximum number of users to include in the list</param>
        /// <param name="skip">The number of users to skip before starting the list</param>
        /// <param name="unitType">The type of time unit to use. Default is day, but other valid values include hour, month, week, year, etc.</param>
        /// <param name="filterUsers">True if only want subset of users</param>
        /// <param name="filterType">Filter type name to filter users.</param>
        /// <param name="siteID"></param>
        /// <param name="showUpdatingUsers"></param>
        /// <returns></returns>
        public bool CreateNewUsersList(int numberOfUnits, string unitType, int maxNumber, int skip,
                                         bool filterUsers,
                                        string filterType, int siteID,
                                        int showUpdatingUsers)
        {

            string newuserslistXML = String.Empty;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchNewUsers"))
            {
                dataReader.AddParameter("NumberOfUnits", numberOfUnits);
                dataReader.AddParameter("UnitType", unitType);
                dataReader.AddParameter("FilterUsers", filterUsers);
                dataReader.AddParameter("FilterType", filterType);
                dataReader.AddParameter("SiteID", siteID);
                dataReader.AddParameter("ShowUpdatingUsers", showUpdatingUsers);

                dataReader.Execute();

                XmlElement userList = null;
                if (!CreateListFromEmptyList(dataReader, "NEW-USERS", maxNumber, skip, ref userList))
                {
                    return false;
                }

                newuserslistXML = userList.OuterXml;
            }
            
            RipleyAddInside(RootElement, newuserslistXML);
            UpdateRelativeDates();
            return true;

        }

        /// <summary>
        /// Creates a list of all the sub editors, containing info about their
        ///		quota and current workload.
        /// </summary>
        /// <param name="maxNumber">the maximum number of users to include in the list</param>
        /// <param name="skip">the number of users to skip before starting the list</param>
        /// <returns>true if successful, false if not</returns>
        public bool CreateSubEditorsList(int maxNumber, int skip)
        {
            //get sub editors list for this site
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchSubEditorsDetails"))
            {
                dataReader.AddParameter("currentsiteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("show", maxNumber);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                XmlElement parentNode = null;
                if (!CreateListFromEmptyList(dataReader, "SUB-EDITORS", maxNumber, skip, ref parentNode))
                {
                    return false;
                }
                RootElement.AppendChild(parentNode);
            }
            return true;

        }
        /// <summary>
        /// Creates a list of all the sub editors, containing info about their
        ///		quota and current workload.
        /// </summary>
        /// <returns>true if successful, false if not</returns>
        public bool CreateSubEditorsList()
        {
            return CreateSubEditorsList(100000, 0);

        }

        /// <summary>
        /// Creates a list of all the users who are members of the specified group
        /// </summary>
        /// <param name="groupName">The name of the group</param>
        /// <param name="maxNumber">number of rows to return, default 100000</param>
        /// <param name="skip">how many to skip, default 0</param>
        /// <returns></returns>
        public bool CreateGroupMembershipList(string groupName, int maxNumber, int skip)
        {
            groupName = groupName.ToUpper();

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchGroupMembershipList"))
            {
                dataReader.AddParameter("groupname", groupName);
                dataReader.AddParameter("SiteID", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", maxNumber);
                dataReader.Execute();

                XmlElement userList = null;
                CreateEmptyList("GROUP-MEMBERSHIP", maxNumber, skip, ref userList);
                AddAttribute(userList, "GROUP-NAME", groupName);

                if (!CreateList(dataReader, ref userList, maxNumber, skip))
                {
                    return false;
                }
                RootElement.AppendChild(userList);
            }

            return true;


        }

        /// <summary>
        /// Creates a list of all the users who are members of the specified group
        /// </summary>
        /// <param name="groupName">The name of the group</param>
        /// <returns></returns>
        public bool CreateGroupMembershipList(string groupName)
        {
            return CreateGroupMembershipList(groupName, 100000, 0);
        }

        /// <summary>
        /// Creates and returns an array containing all the user IDs of the
        ///		users in the list.
        /// </summary>
        /// <param name="ids">ints containing the user IDs of all the users in the list</param>
        /// <returns>true if successful, false if not.</returns>
        public bool GetUserIDs(ref int[] ids)
        {
            XmlNode listNode = RootElement.SelectSingleNode("USER-LIST");
            if (listNode == null)
                return false;

            XmlNodeList userList = listNode.SelectNodes("USER");
            if (userList == null || userList.Count ==0 )
            {
                return false;
            }

            ids = new int[userList.Count];

            for (int i = 0; i < userList.Count; i++)
            {
                ids[i] = Int32.Parse(userList[i].SelectSingleNode("USERID").InnerText);
            }
            return true;
        }

        /// <summary>
        /// Returns the user with this ID from the list.
        /// </summary>
        /// <param name="userID">user to be removed from list</param>
        /// <returns>true if successful, false if not.</returns>
        public bool RemoveUser(int userID)
        {
            if (userID == 0)
            {
                return false;
            }
            if (RootElement.SelectSingleNode("USER-LIST") == null)
                return false;

            if (RootElement.SelectSingleNode("USER-LIST").SelectNodes("USER") == null || RootElement.SelectSingleNode("USER-LIST").SelectNodes("USER").Count == 0)
            {
                return false;
            }
            //find the element and remove it
            for (int i = 0; i < RootElement.SelectSingleNode("USER-LIST").SelectNodes("USER").Count; i++)
            {
                if (Int32.Parse(RootElement.SelectSingleNode("USER-LIST").SelectNodes("USER")[i].SelectSingleNode("USERID").InnerText) == userID)
                {
                    RootElement.SelectSingleNode("USER-LIST").RemoveChild(RootElement.SelectSingleNode("USER-LIST").SelectNodes("USER")[i]);
                    break;
                }
            }

            return true;


        }

        /// <summary>
        /// Adds the details for the user represented by the current row
        ///		in the data member stored procedures results set as a new user
        ///		in the user list. Only adds those fields which are present in
        ///		the results set to the XML.
        /// </summary>
        /// <returns>true if successfull, false if not.</returns>
        public bool AddCurrentUserToList()
        {
            if (InputContext.ViewingUser == null)
                return false;

            //already there so just so its there
            if (FindUserInList(InputContext.ViewingUser.UserID))
                return true;

            //no user list so fail
            if (RootElement.SelectSingleNode("USER-LIST") == null)
            {
                return false;
            }


            User viewUser = (User)InputContext.ViewingUser;
            XmlNode userXML = viewUser.GenerateUserXml(viewUser.UserID, viewUser.FirstNames, "", viewUser.FirstNames,
                viewUser.LastName, viewUser.Status, 0, true, 0.0, "", "", viewUser.Title, viewUser.Journal, DateTime.MinValue, 0, 0, DateTime.MinValue, -1, -1, -1, -1);

            RootElement.SelectSingleNode("USER-LIST").AppendChild(RootElement.OwnerDocument.ImportNode(userXML,true));

            return true;
        }

        /// <summary>
        /// User id to check
        /// </summary>
        /// <param name="userID">User id to check</param>
        /// <returns>true if user is in list, false if not.</returns>
        public bool FindUserInList(int userID)
        {
            //return false if no userid or no list
            if (userID == 0)
            {
                return false;
            }
            XmlNode listNode = RootElement.SelectSingleNode("USER-LIST");
            if (listNode == null)
                return false;

            XmlNodeList userList = listNode.SelectNodes("USER");
            if (userList == null || userList.Count == 0)
            {
                return false;
            }
            for (int i = 0; i < userList.Count; i++)
            {
                if (userList[i].SelectSingleNode("USERID") != null && Int32.Parse(userList[i].SelectSingleNode("USERID").InnerText) == userID)
                    return true;
            }
            return false;

        }
               
        /// <summary>
        /// Helper method to create the list after a specific stored procedure
        ///		has been called to return an appropriate results set.
        /// </summary>
        /// <param name="dataReader">The data reader containing results</param>
        /// <param name="userlistXML">returned XmlElement</param>
        /// <param name="maxNumber">max number of rows to add</param>
        /// <param name="skip">number of rows to skip</param>
        /// <returns>true if successful, false if not.</returns>
        private bool CreateList(IDnaDataReader dataReader, ref XmlElement userlistXML, int maxNumber, int skip)
        {
            if (!dataReader.HasRows)
            {
                return false;
            }

            int numberShown = 0;

            if (skip > 0)
            {
                //Read/skip over the skip number of rows
                for (int i = 0; i < skip; i++)
                {
                    dataReader.Read();
                }
            }

            //add rows, assume that sp has limited the amount returned
            while (maxNumber > numberShown && dataReader.Read())           
            {
                User user = new User(InputContext);
                user.AddUserXMLBlock(dataReader, dataReader.GetInt32NullAsZero("USERID"), userlistXML);

                numberShown++;
            } 

            if (dataReader.Read())
            {
                AddAttribute(userlistXML, "MORE", 1);
            }

            AddAttribute(userlistXML, "COUNT", numberShown);

            return true;
        }

        /// <summary>
        /// Helper method to create the list after a specific stored procedure
        ///		has been called to return an appropriate results set.
        /// </summary>
        /// <param name="dataReader">The data reader containing results</param>
        /// <param name="type">type of list returned</param>
        /// <param name="maxNumber">the maximum number of users to go in the list</param>
        /// <param name="skip">the number of users to skip before starting the list</param>
        /// <param name="userlistXML">returned XmlElement</param>
        /// <returns></returns>
        private bool CreateListFromEmptyList(IDnaDataReader dataReader, string type, int maxNumber, int skip, ref XmlElement userlistXML)
        {
            CreateEmptyList(type, maxNumber, skip, ref userlistXML);

            return CreateList(dataReader, ref  userlistXML, maxNumber, skip);
            
        }

        /// <summary>
        /// Creates the default user list element
        /// </summary>
        /// <param name="type">type of list returned</param>
        /// <param name="count">the maximum number of users to go in the list</param>
        /// <param name="skip">the number of users to skip before starting the list</param>
        /// <param name="userList">returned XmlElement</param>
        /// <returns></returns>
        private bool CreateEmptyList(string type, int count, int skip, ref XmlElement userList)
        {

            if (userList == null)
            {
                userList = CreateElement("USER-LIST");
            }
            else
            {
                userList = AddElementTag(userList, "USER-LIST");
            }
            AddAttribute(userList, "SHOW", count);
            AddAttribute(userList, "SKIP", skip);
            AddAttribute(userList, "TYPE", type);

            return true;

        }
    }
}
