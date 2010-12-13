using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;
using System.Data;
using System.Data.SqlClient;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "LINK")]
    [DataContract(Name = "link")]
    public partial class Link
    {
        #region Properties

        [XmlAttribute(AttributeName = "TYPE")]
        [DataMember(Name = "type", Order = 1)]
        public string Type { get; set; }

        [XmlAttribute(AttributeName = "LINKID")]
        [DataMember(Name = "linkId", Order = 2)]
        public int LinkId { get; set; }

        [XmlAttribute(AttributeName = "TEAMID")]
        [DataMember(Name = "teamId", Order = 3)]
        public int TeamId { get; set; }

        [XmlAttribute(AttributeName = "RELATIONSHIP")]
        [DataMember(Name = "relationship", Order = 4)]
        public string Relationship { get; set; }

        [XmlAttribute(AttributeName = "PRIVATE")]
        [DataMember(Name = "private", Order = 5)]
        public int Private { get; set; }

        [XmlAttribute(AttributeName = "DNAUID")]
        [DataMember(Name = "dnaUid", Order = 6)]
        public string DnaUid { get; set; }

        [XmlElement(Order = 1, ElementName = "DESCRIPTION")]
        [DataMember(Name = "description", Order = 7)]
        public string Description { get; set; }

        [XmlElement(Order = 2, ElementName = "SUBMITTER")]
        [DataMember(Name = "submitter", Order = 8)]
        public UserElement Submitter { get; set; }

        [XmlElement(Order = 3, ElementName = "DATELINKED")]
        [DataMember(Name = "dateLinked", Order = 9)]
        public DateElement DateLinked { get; set; }

        #endregion

        public static Link CreateLinkFromReader(IDnaDataReader reader)
        {
            Link link = new Link();
            link.Type = reader.GetStringNullAsEmpty("destinationtype");

            link.LinkId = reader.GetInt32NullAsZero("linkid");
            link.TeamId =  reader.GetInt32NullAsZero("teamid");
            link.Relationship =  reader.GetStringNullAsEmpty("relationship");
            link.Private =  reader.GetTinyIntAsInt("private");
            link.Description = reader.GetStringNullAsEmpty("linkdescription");
            link.DateLinked = new DateElement(reader.GetDateTime("DateLinked"));

            link.Submitter = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "submitter") };

            //Create appropriate URL from link type. 
            int destinationId = reader.GetInt32NullAsZero("DestinationID");
            switch (link.Type)
            {
                case "article":
                {
                    link.DnaUid =  "A" + destinationId.ToString();
                    break;
                }
                case "userpage":
                {
                    link.DnaUid =  "U" + destinationId.ToString();
                    break;
                }
                case "category":
                {
                    link.DnaUid =  "C" + destinationId.ToString();
                    break;
                }
                case "forum":
                {
                    link.DnaUid =  "F" + destinationId.ToString();
                    break;
                }
                case "thread":
                {
                    link.DnaUid =  "T" + destinationId.ToString();
                    break;
                }
                case "posting":
                {
                    link.DnaUid =  "TP" + destinationId.ToString();
                    break;
                }
                default: // "club" )
                {
                    link.DnaUid =  "G" + destinationId.ToString();
                    break;
                }
            }
            return link;
        }

        /// <summary>
        /// Clips the given page to the Users user page
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="user">User who's clipping</param>
        /// <param name="siteId">Site Id we're clipping in</param>
        /// <param name="pageType"> textual type of page we're clipping</param>
        /// <param name="objectID">ID of page we're clipping</param>
        /// <param name="linkDescription">Textual description (link text)</param>
        /// <param name="linkGroup">textual (optional) group containing link (user defined)</param>
        /// <param name="isPrivate">Whether the link is private</param>
        public static void ClipPageToUserPage(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                BBC.Dna.Users.User user, 
                                                int siteId, 
                                                string pageType, 
                                                int objectID, 
                                                string linkDescription, 
                                                string linkGroup, 
                                                bool isPrivate)
        {
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("addlinks"))
            {
                dataReader.AddParameter("sourcetype", "userpage");
                dataReader.AddParameter("sourceid", user.UserID);
                dataReader.AddParameter("desttype", pageType);
                dataReader.AddParameter("destid", objectID);
                dataReader.AddParameter("submitterid", user.UserID);
                dataReader.AddParameter("description", linkDescription);
                dataReader.AddParameter("group", linkGroup);
                dataReader.AddParameter("ishidden", isPrivate);
                dataReader.AddParameter("teamid", user.TeamID);
                dataReader.AddParameter("url", String.Empty);
                dataReader.AddParameter("title", DBNull.Value);
                dataReader.AddParameter("relationship", "Bookmark");
                dataReader.AddParameter("destsiteid", siteId);

                try
                {
                    dataReader.Execute();
                    if (dataReader.HasRows)
                    {
                        if (dataReader.Read())
                        {
                            string result = dataReader.GetStringNullAsEmpty("result");
                            if (result != "success")
                            {
                                throw ApiException.GetError(ErrorType.AlreadyLinked);
                            }
                        }
                    }
                }
                catch (SqlException ex)
                {
                    if (ex.Message.Contains("Violation of UNIQUE"))
                    {
                        //Don't need to flag this error up now
                        //They're just trying to bookmark the same thing just carry on
                        return;
                        //throw ApiException.GetError(ErrorType.AlreadyLinked);
                    }
                    else
                    {
                        throw ex;
                    }
                }
            }
        }
        /// <summary>
        /// Delete a link
        /// </summary>
        /// <param name="readerCreator">DataReader Creator</param>
        /// <param name="linkId">Link to delete</param>
        /// <param name="identifier">User ID or id username involved</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="byDnaUserId"></param>
        public static void DeleteLink(IDnaDataReaderCreator readerCreator,
                                        BBC.Dna.Users.CallingUser viewingUser,
                                        string identifier,
                                        int siteID,
                                        int linkId,
                                        bool byDnaUserId)
        {
            int dnaUserId = 0;
            if (!byDnaUserId)
            {
                // fetch all the lovely intellectual property from the database
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getdnauseridfromidentityusername"))
                {
                    reader.AddParameter("identityusername", identifier);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        dnaUserId = reader.GetInt32NullAsZero("userid");
                    }
                    else
                    {
                        throw ApiException.GetError(ErrorType.UserNotFound);
                    }
                }
            }
            else
            {
                try
                {
                    dnaUserId = Convert.ToInt32(identifier);
                }
                catch (Exception)
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }
            //You can't delete someone else's links (unless you're an editor or superuser)
            if (viewingUser.UserID == dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("deletelink"))
                {
                    dataReader.AddParameter("linkid", linkId);
                    dataReader.AddParameter("userID", dnaUserId);
                    dataReader.AddParameter("siteID", siteID);
                    dataReader.Execute();
                }
            }
            else
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }
        }
    }
}