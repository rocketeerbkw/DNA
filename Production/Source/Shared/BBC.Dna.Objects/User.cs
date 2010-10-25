using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Xml.Serialization;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Runtime.Serialization;
using BBC.Dna.Common;
using BBC.Dna.Users;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "USER")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "USER")]
    [DataContract(Name = "user")]
    public partial class User : IUser
    {
        private static IDnaDataReaderCreator _dnaDataReaderCreator;
        private static IDnaDiagnostics _dnaDiagnostics;
        private static ICacheManager _cacheManager;
        
        /// <summary>
        /// Constructs objects
        /// </summary>
        public User(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager cacheManager)
        {
            _dnaDataReaderCreator = dnaDataReaderCreator;
            _dnaDiagnostics = dnaDiagnostics;
            _cacheManager = cacheManager;
            Groups = new List<Group>();
        }

        /// <summary>
        /// Constructs objects
        /// </summary>
        public User()
        {
            _dnaDataReaderCreator = null;
            _dnaDiagnostics = null;
            _cacheManager = null;
            Groups = new List<Group>();
        }

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "USERID")]
        [DataMember(Name = ("userId"))]
        public int UserId
        {
            get;
            set;
        }


        private string _userName = string.Empty;
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "USERNAME")]
        [DataMember(Name = ("userName"))]
        public string UserName
        {
            get
            {
                if (_userName == string.Empty)
                {
                    return "U" + UserId.ToString();
                }
                else
                {
                    return _userName;
                }
            }
            set { _userName = value; }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("USER-MODE", Order = 2)]
        public int UserMode
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("EMAIL-ADDRESS", Order = 3)]
        public string Email
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "POSTCODE")]
        public string PostCode
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "REGION")]
        public string Region
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "PREFUSERMODE")]
        public bool PrefUserMode
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 7, ElementName = "STATUS")]
        [DataMember(Name = ("status"))]
        public int Status
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 8, ElementName = "AREA")]
        public string Area
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 9, ElementName = "TITLE")]
        public string Title
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("FIRST-NAMES", Order = 10)]
        public string FirstNames
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("FIRSTNAMES", Order = 11)]
        public string FirstNames1
        {
            get
            {
                return FirstNames;
            }
            set
            {
                FirstNames = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("LAST-NAME", Order = 12)]
        public string LastName
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("LASTNAME", Order = 13)]
        private string LastName1
        {
            get
            {
                return LastName;
            }
            set
            {
                LastName = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 14, ElementName = "SITESUFFIX")]
        public string SiteSuffix
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 15, ElementName = "TEAMID")]
        public int TeamId
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool TeamIdSpecified { get { return this.TeamId != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 16, ElementName = "UNREADPUBLICMESSAGECOUNT")]
        public int UnReadPublicMessageCount
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool UnReadPublicMessageCountSpecified { get { return this.UnReadPublicMessageCount != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 17, ElementName = "UNREADPRIVATEMESSAGECOUNT")]
        public int UnReadPrivateMessageCount
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool UnReadPrivateMessageCountSpecified { get { return this.UnReadPrivateMessageCount != 0; } }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 18, ElementName = "TAXONOMYNODE")]
        public int TaxonomyNode
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool TaxonomyNodeSpecified { get { return this.TaxonomyNode != 0; } }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 19, ElementName = "HIDELOCATION")]
        public int HideLocation
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool HideLocationSpecified { get { return this.HideLocation != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 20, ElementName = "HIDEUSERNAME")]
        public int HideUsername
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool HideUsernameSpecified { get { return this.HideUsername != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 21, ElementName = "JOURNAL")]
        public int Journal
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool JournalSpecified { get { return this.Journal != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 22, ElementName = "ACTIVE")]
        public bool Active
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 23, ElementName = "SCORE")]
        public double Score
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool ScoreSpecified { get { return this.Score != 0.0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("SUB-QUOTA", Order = 24)]
        public int SubQuota
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool SubQuotaSpecified { get { return this.SubQuota != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 25, ElementName = "ALLOCATIONS")]
        public int Allocations
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool AllocationsSpecified { get { return this.Allocations != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 26, ElementName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool ForumIdSpecified { get { return this.ForumId != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("FORUM-POSTED-TO", Order = 27)]
        public int ForumPostedTo
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool ForumPostedToSpecified { get { return this.ForumPostedTo != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 28, ElementName = "MASTHEAD")]
        public int MastHead
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool MastHeadSpecified { get { return this.MastHead != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 29, ElementName = "SINBIN")]
        public int SinBin
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool SinBinSpecified { get { return this.SinBin != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("DATE-JOINED", Order = 30)]
        [DataMember (Name="dateJoined")]
        public DateElement DateJoined
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlArray(Order = 31, ElementName = "GROUPS")]
        [System.Xml.Serialization.XmlArrayItem(ElementName = "GROUP")]
        [DataMember(Name = ("groups"))]
        public List<Group> Groups
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 32, ElementName = "ACCEPTSUBSCRIPTIONS")]
        public byte AcceptSubscriptions
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool AcceptSubscriptionsSpecified { get { return this.AcceptSubscriptions != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 33, ElementName = "PROMPTSETUSERNAME")]
        public bool PromptSetUsername
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("DATE-LAST-NOTIFIED", Order = 34)]
        public DateElement DateLastNotified
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(ElementName = "IDENTITYUSERID", Order = 35)]
        [DataMember(Name = ("identityUserId"))]
        public string IdentityUserId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(ElementName = "IDENTITYUSERNAME", Order = 36)]
        [DataMember(Name = ("identityUserName"))]
        public string IdentityUserName
        {
            get;
            set;
        }



        [XmlIgnore]
        public bool UserLoggedIn { get; set; }

        [XmlIgnore]
        public bool IsGuardian
        {
            get
            {
                return (Groups.Find(x => x.Name == "Guardian") != null);
            }
        }

        [XmlIgnore]
        public bool IsEditor
        {
            get
            {
                return (Groups.Find(x => x.Name.ToUpper() == "EDITOR") != null);
            }
        }

        [XmlIgnore]
        public bool IsModerator
        {
            get
            {
                return (Groups.Find(x => x.Name.ToUpper() == "MODERATOR") != null);
            }
        }

        [XmlIgnore]
        public bool IsSuperUser
        {
            get
            {
                return (Groups.Find(x => x.Name.ToUpper() == "SUPERUSER") != null);
            }
        }


        #endregion

        /// <summary>
        /// Checks to see if the current user has special edit permissions for the given article
        /// </summary>
        /// <param name="h2g2ID">Id of the article you what to check for</param>
        /// <returns>True if they have, false if not</returns>
        public bool HasSpecialEditPermissions(int h2g2ID)
        {
            if (IsEditor)
            {
                return true;
            }
            if (IsModerator)//TODO add this && HasEntryLockedForModeration(h2g2ID))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        static public User CreateUserFromReader(IDnaDataReader reader)
        {
            return User.CreateUserFromReader(reader, string.Empty);
        }

        /// <summary>
        /// Creates user object from given reader and user id
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="userID"></param>
        /// <returns></returns>
        static public User CreateUserFromReader(IDnaDataReader reader, string prefix)
        {

            //IUser user = new User(_dnaDataReaderCreator, _dnaDiagnostics, _cacheManager);
            IUser user = new User();

            if (reader.Exists(prefix + "userID"))
            {
                user.UserId = reader.GetInt32NullAsZero(prefix  + "userID");
            }
            else if (reader.Exists(prefix + "ID"))
            {
                user.UserId = reader.GetInt32NullAsZero(prefix + "ID");
            }

            if (reader.Exists(prefix + "IdentityUserID"))
            {
                user.IdentityUserId = reader.GetStringNullAsEmpty(prefix + "IdentityUserId");
            }

            if (reader.Exists(prefix + "IdentityUserName"))
            {
                user.IdentityUserName = reader.GetStringNullAsEmpty(prefix + "IdentityUserName");
            }
            else if (reader.Exists(prefix + "LoginName"))
            {
                user.IdentityUserName = reader.GetStringNullAsEmpty(prefix + "LoginName");
            }

            /*
            if (reader.Exists(prefix + "FirstNames"))
            {

                user.FirstNames = reader.GetStringNullAsEmpty(prefix + "FirstNames") ?? "";
            }

            if(reader.Exists(prefix + "LastName"))
            {

                user.LastName = reader.GetStringNullAsEmpty(prefix + "LastName") ?? "";
            }
            */
            if(reader.Exists(prefix + "Status"))
            {
                
                user.Status= reader.GetInt32NullAsZero(prefix + "Status");
            }

            if(reader.Exists(prefix + "TaxonomyNode"))
            {
                
                user.TaxonomyNode= reader.GetInt32NullAsZero(prefix + "TaxonomyNode");
            }
            if (reader.Exists(prefix + "UserName"))
            {
                user.UserName = reader.GetStringNullAsEmpty(prefix + "UserName") ?? "";
            }
            else if (reader.Exists(prefix + "Name"))
            {
                user.UserName = reader.GetStringNullAsEmpty(prefix + "Name") ?? "";
            }

            if (user.UserName == String.Empty)
            {
                user.UserName = "Member " + user.UserId.ToString();
            }
            /* NO NO not emails
             * if (reader.Exists(prefix + "Email"))
            {
                user.Email = reader.GetStringNullAsEmpty(prefix + "Email") ?? "";
            }
             */
            
            if (reader.Exists(prefix + "SiteSuffix"))
            {
                user.SiteSuffix = reader.GetStringNullAsEmpty(prefix + "SiteSuffix") ?? "";
            }
            if (reader.Exists(prefix + "Area"))
            {
                user.Area = reader.GetStringNullAsEmpty(prefix + "Area") ?? "";
            }
            if (reader.Exists(prefix + "Title"))
            {
                user.Title = reader.GetStringNullAsEmpty(prefix + "Title") ?? "";
            }
            if (reader.Exists(prefix + "SubQuota"))
            {
                user.SubQuota = reader.GetInt32NullAsZero(prefix + "SubQuota");
            }
            if (reader.Exists(prefix + "Allocations"))
            {
                user.Allocations = reader.GetInt32NullAsZero(prefix + "Allocations");
            }
            if (reader.Exists(prefix + "Journal"))
            {
                user.Journal = reader.GetInt32NullAsZero(prefix + "Journal");
            }
            if (reader.Exists(prefix + "Active") && !reader.IsDBNull(prefix + "Active"))
            {
                user.Active = reader.GetBoolean(prefix + "Active");
            }
            if (reader.Exists(prefix + "DateLastNotified") && reader.GetValue(prefix + "DateLastNotified") != DBNull.Value)
            {
                user.DateLastNotified = new DateElement(reader.GetDateTime(prefix + "DateLastNotified"));
            }
            if (reader.Exists(prefix + "DateJoined") && reader.GetValue(prefix + "DateJoined") != DBNull.Value)
            {
                user.DateJoined = new DateElement(reader.GetDateTime(prefix + "DateJoined"));
            }
            if (reader.Exists(prefix + "ForumPostedTo"))
            {
                user.ForumPostedTo = reader.GetInt32NullAsZero(prefix + "ForumPostedTo");
            }
            if (reader.Exists(prefix + "Masthead"))
            {
                user.MastHead = reader.GetInt32NullAsZero(prefix + "Masthead");
            }
            if (reader.Exists(prefix + "SinBin"))
            {
                user.SinBin = reader.GetInt32NullAsZero(prefix + "SinBin");
            }
            if (reader.Exists(prefix + "ForumID"))
            {
                user.ForumId = reader.GetInt32NullAsZero(prefix + "ForumID");
            }
            var siteId = 0;
            if (reader.Exists("SiteID"))
            {
                siteId = reader.GetInt32NullAsZero("SiteID");
            }
            
            
            if (siteId != 0 && user.UserId != 0)
            {
                var userGroups = (UserGroups)SignalHelper.GetObject(typeof(UserGroups));
                var groupList = userGroups.GetUsersGroupsForSite(user.UserId, siteId);
                foreach (var group in groupList)
                {
                    user.Groups.Add(new Group(){Name = group.Name.ToUpper()});
                }
            }
            else
            {

            }
             

            return (User)user;
        
        }




        #region IUser Members

        public void CreateUser()
        {
            throw new NotImplementedException();
        }

        [XmlIgnore]
        public bool ShowFullDetails
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public void BeginUpdateDetails()
        {
            throw new NotImplementedException();
        }

        public bool UpdateDetails()
        {
            throw new NotImplementedException();
        }

        [XmlIgnore]
        public string LoginName
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        bool IUser.IsEditor
        {
            get
            {
                return Groups.Find(x => x.Name.ToUpper() == "EDITOR") != null;
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        bool IUser.IsSuperUser
        {
            get
            {
                return Status == 2;
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsNotable
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsVolunteer
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsReferee
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        bool IUser.IsModerator
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsPreModerated
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsBanned
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsAutoSinBin
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public string PreferredSkin
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public Dictionary<string, object> UserData
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsScout
        {
            get
            {
                return Groups.Find(x => x.Name.ToUpper() == "SCOUT") != null;
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsSubEditor
        {
            get
            {
                return Groups.Find(x => x.Name.ToUpper() == "SUBEDITOR") != null;
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public bool IsTester
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public string BbcUid
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        bool IUser.AcceptSubscriptions
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public void SetAcceptSubscriptions(bool acceptSubscriptions)
        {
            throw new NotImplementedException();
        }

        public void SetPreferredSkinInDB(string skin)
        {
            throw new NotImplementedException();
        }

        public System.Xml.XmlElement GetSitesThisUserIsEditorOfXML()
        {
            throw new NotImplementedException();
        }

        [XmlIgnore]
        bool IUser.IsGuardian
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        [XmlIgnore]
        public int TeamID
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public void SetUsername(string userName)
        {
            throw new NotImplementedException();
        }

        public void SetSiteSuffix(string siteSuffix)
        {
            throw new NotImplementedException();
        }

        public bool SetUserData(string name, object value)
        {
            throw new NotImplementedException();
        }

        [XmlIgnore]
        public bool IsHost
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Converts BBC.Dna.User to BBC.Dna.Objects.User
        /// A hack until user objects are unified.
        /// </summary>
        /// <returns></returns>
        public BBC.Dna.Objects.User ConvertUser()
        {
            return this;
        }

        #endregion
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "USER")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "USER")]
    [DataContract (Name="userElement")]
    public partial class UserElement
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "USER")]
        [DataMember(Name = "user")]
        public User user
        {
            get;
            set;
        }

    }

    public enum UserStatus :int
    {
        Inactive =0,
        Active =1,
        SuperUser=2
    }
}
