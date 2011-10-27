using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Moderation;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Users;
using System.Linq;
using System.Collections.ObjectModel;

namespace BBC.Dna.Component
{
    /// <summary>
    /// 
    /// </summary>
    public class ModeratorManagement : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModeratorManagement(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Process Request Override
        /// </summary>
        public override void ProcessRequest()
        {

            if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsEditor)
            {
                AddErrorXml("Unauthorised", "User not authorised", RootElement);
                return;
            }

            string groupName = String.Empty;
            if (InputContext.DoesParamExist("manage", "manage"))
            {
                groupName = InputContext.GetParamStringOrEmpty("manage", "manage");
            }

            if ( groupName == String.Empty )
                groupName = "moderator";

            // Process Input
            var foundUserId = ProcessSubmission( groupName );

            // Generate XML
            GenerateXml( groupName, foundUserId );

            // Get a list of all the sites.
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            RootElement.AppendChild(ImportNode(siteXml.GenerateSitesForUserAsEditorXml(InputContext.TheSiteList).FirstChild));

        }

        /// <summary>
        /// Generates XML for ModeratorManagement page.
        /// </summary>
        public void GenerateXml(  string groupName, int foundUserid )
        {
            XmlElement modList = AddElementTag(RootElement,"MODERATOR-LIST");
            AddAttribute(modList, "GROUPNAME", groupName);
            XmlElement sites = null;
            XmlElement classes = null;
            using ( IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getfullmoderatorlist") )
            {
                dataReader.AddParameter("groupname", groupName);
                dataReader.AddParameter("userid", InputContext.ViewingUser.UserID);
                dataReader.AddParameter("founduserid", foundUserid);
                dataReader.Execute();

                int userId = 0;
                int classId = -1;
                int siteId = -1;
                while ( dataReader.Read() )
                {
                    if ( userId != dataReader.GetInt32NullAsZero("userid") )
                    {
                        userId = dataReader.GetInt32NullAsZero("userid");

                        XmlElement moderator = AddElementTag(modList, "MODERATOR");
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, userId,moderator);

                        sites = AddElementTag(moderator, "SITES");
                        classes = AddElementTag(moderator, "CLASSES");
                        classId = -1;
                        siteId = -1;
                    }

                    if ( !dataReader.IsDBNull("modclassid") )
                    {
                        // User is assigned to moderation class
                        if (classId != dataReader.GetInt32NullAsZero("modclassid"))
                        {
                            classId = dataReader.GetInt32NullAsZero("modclassid");
                            AddIntElement(classes, "CLASSID", classId);
                        }
                    }
                    else if ( !dataReader.IsDBNull("siteid") && siteId != dataReader.GetInt32NullAsZero("siteid") )
                    {
                        // User is assigned to a specific site
                        siteId = dataReader.GetInt32NullAsZero("siteid");
                        XmlElement site = AddElementTag(sites, "SITE");
                        AddAttribute(site, "SITEID", siteId);
                    }
                }
            }

            AddModerationClasses();
        }

        /// <summary>
        /// Checks parameters and performs moderator actions.
        /// </summary>
        public int ProcessSubmission( string groupName )
        {
            var userId=0;
            if (InputContext.DoesParamExist("finduser", "Find User"))
            {
                XmlElement foundUsers = AddElementTag(RootElement, "FOUNDUSERS");
                String emailorId = InputContext.GetParamStringOrEmpty("email", "email");
                if (EmailAddressFilter.IsValidEmailAddresses(emailorId))
                {
                    userId= FindUserFromEmail(foundUsers, emailorId);
                }
                else
                {
                    userId = FindUserFromUserId(foundUsers, emailorId);
                }
            }
            if (InputContext.DoesParamExist("updateuser", "UpdateUser"))
            {
                userId = InputContext.GetParamIntOrZero("userid", "UserId");

                updateUser(groupName, userId);
                UserGroups.GetObject().SendSignal();

                //Produce Found User XML.
                XmlElement foundUsers = AddElementTag(RootElement, "FOUNDUSERS");
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("finduserfromid"))
                {
                    reader.AddParameter("userid", userId);
                    reader.Execute();

                    while (reader.Read())
                    {
                        User find = new User(InputContext);
                        find.AddUserXMLBlock(reader, userId, foundUsers);
                    }
                }
                
            }
            else if (InputContext.DoesParamExist("giveaccess", "Give Access"))
            {
                GiveAccess(groupName);
                UserGroups.GetObject().SendSignal();
            }
            else if (InputContext.DoesParamExist("removeaccess", "removeaccess") || InputContext.DoesParamExist("removeallaccess", "removeallaccess"))
            {
                RemoveAccess(groupName);
                UserGroups.GetObject().SendSignal();
            }

            return userId;
        }

        /// <summary>
        /// Remove a users access to a site or mod class for the given group.
        /// </summary>
        /// <param name="groupName"></param>
        private void RemoveAccess(string groupName)
        {
            //Create comma seperated list of users.
            String userList = String.Empty;
            for (int index = 0; index < InputContext.GetParamCountOrZero("userid", "UserId"); ++index)
            {
                if (userList != String.Empty)
                {
                    userList += "|";
                }
                int userId = InputContext.GetParamIntOrZero("userid", index, "UserId");
                userList += Convert.ToString(userId);
            }

            if (userList != String.Empty)
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("removeaccess"))
                {
                    int clearAll = InputContext.DoesParamExist("removeallaccess", "removeallaccess") == true ? 1 : 0;
                    reader.AddParameter("clearall", clearAll);
                    reader.AddParameter("userlist", userList);
                    reader.AddParameter("groupname", groupName);
                    if (InputContext.DoesParamExist("classid", "ClassId"))
                    {
                        int modClassId = InputContext.GetParamIntOrZero("classId", "classId");
                        reader.AddParameter("modclassid", modClassId);
                    }
                    if (InputContext.DoesParamExist("siteid", "SiteId"))
                    {
                        int siteId = InputContext.GetParamIntOrZero("siteid", "SiteId");
                        reader.AddParameter("siteid", siteId);
                    }
                    reader.Execute();
                }
            }
        }

        /// <summary>
        /// Give a user access to a class or site.
        /// </summary>
        /// <param name="groupName"></param>
        private void GiveAccess(string groupName)
        {
            //Create comma seperated list of users.
            String userList = String.Empty;
            for (int index = 0; index < InputContext.GetParamCountOrZero("userid", "UserId"); ++index)
            {
                if (userList != String.Empty)
                {
                    userList += "|";
                }
                int userId = InputContext.GetParamIntOrZero("userid", index, "UserId");
                userList += Convert.ToString(userId);
            }

            if (userList != String.Empty)
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("giveaccess"))
                {
                    reader.AddParameter("userlist", userList);
                    reader.AddParameter("groupname", groupName);
                    if (InputContext.DoesParamExist("classid", "ClassId"))
                    {
                        int modClassId = InputContext.GetParamIntOrZero("classId", "classId");
                        reader.AddParameter("modclassid", modClassId);
                    }

                    if (InputContext.DoesParamExist("siteid", "SiteId"))
                    {
                        int siteId = InputContext.GetParamIntOrZero("siteid", "SiteId");
                        reader.AddParameter("siteid", siteId);
                    }
                    reader.Execute();
                }
            }
        }

        /// <summary>
        /// Update a users access to a class or site.
        /// </summary>
        /// <param name="groupName"></param>
        /// <param name="userId"></param>
        private void updateUser(string groupName, int userId)
        {
            //Create comma seperated list of sites.
            String siteList = String.Empty;
            for (int index = 0; index < InputContext.GetParamCountOrZero("tosite", "SiteId"); ++index)
            {
                if (siteList != String.Empty)
                {
                    siteList += "|";
                }
                int siteId = InputContext.GetParamIntOrZero("tosite", index, "tosite");
                siteList += Convert.ToString(siteId);
            }
            
            //add access to moderation tools
            if(!string.IsNullOrEmpty(siteList))
            {
                siteList += "|" + InputContext.TheSiteList.GetSite("moderation").SiteID;
            }
            
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addnewmoderatortosites"))
            {
                reader.AddParameter("sitelist", siteList);
                reader.AddParameter("userid", userId);
                reader.AddParameter("groupname", groupName);
                reader.Execute();
            }
            

            String classList = String.Empty;
            for (int index = 0; index < InputContext.GetParamCountOrZero("toclass", "ModerationClassId"); ++index)
            {
                if (classList != String.Empty)
                {
                    classList += "|";
                }
                int classId = InputContext.GetParamIntOrZero("toclass", index, "toclass");
                classList += Convert.ToString(classId);
            }

            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addnewmoderatortoclasses"))
            {
                reader.AddParameter("classlist", classList);
                reader.AddParameter("userid", userId);
                reader.AddParameter("groupname", groupName);
                reader.Execute();
            }
            
        }

        /// <summary>
        /// Find a user from userid.
        /// </summary>
        /// <param name="foundUsers"></param>
        /// <param name="email"></param>
        private int FindUserFromUserId(XmlElement foundUsers, String email)
        {
            int userId;
            //Search for user by userid.
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("finduserfromidwithorwithoutmasthead"))
            {
                
                if (Int32.TryParse(email, out userId))
                {
                    reader.AddParameter("userid", userId);
                    reader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                    reader.Execute();

                    while (reader.Read())
                    {
                        User find = new User(InputContext);
                        find.AddUserXMLBlock(reader, userId, foundUsers);
                        userId = reader.GetInt32NullAsZero("userid");
                    }
                }
            }
            return userId;
        }

        /// <summary>
        /// Find user from email.
        /// </summary>
        /// <param name="foundUsers"></param>
        /// <param name="email"></param>
        private int FindUserFromEmail(XmlElement foundUsers, String email)
        {
            int userId = 0;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("finduserfromemail"))
            {
                reader.AddParameter("email", email);
                reader.Execute();
                while (reader.Read())
                {
                    User find = new User(InputContext);
                    find.AddUserXMLBlock(reader, reader.GetInt32NullAsZero("userid"), foundUsers);
                    userId = reader.GetInt32NullAsZero("userid");
                }
            }
            return userId;
        }

        /// <summary>
        /// determines which moderation classes should be shown
        /// </summary>
        private void AddModerationClasses()
        {
            ModerationClassList moderationClassList =
                ModerationClassListCache.GetObject();
            if (InputContext.ViewingUser.IsSuperUser)
            {
                SerialiseAndAppend(moderationClassList, "");
            }
            else
            {

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoderatingclassbyuser"))
                {
                    dataReader.AddParameter("userid", InputContext.ViewingUser.UserID);
                    dataReader.Execute();

                    List<int> modClasses = new List<int>();
                    while (dataReader.Read())
                    {
                        modClasses.Add(dataReader.GetInt32NullAsZero("ModClassID"));
                    }

                    var classes = moderationClassList.ModClassList.Where(y => modClasses.Contains(y.ClassId)).ToList<ModerationClass>();
                    var tmpList = new ModerationClassList();
                    foreach (var modClass in classes)
                    {
                        tmpList.ModClassList.Add(modClass);
                    }
                    SerialiseAndAppend(tmpList, "");
                }
                
            }
        }
    }
}
