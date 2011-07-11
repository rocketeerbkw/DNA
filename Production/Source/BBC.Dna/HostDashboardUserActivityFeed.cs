using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;
using System.Collections;
using System.Collections.Generic;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class HostDashboardUserActivityFeed : DnaInputComponent
    {
        private int _siteId = 0;
        private int _modClassId = 0;
        private int _userId = 0;
        private DateTime _startDate;
        private DateTime _endDate = DateTime.MaxValue;
        private int _startIndex = 0;
        private int _itemsPerPage = 100;
        private bool _updateStatus = false;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public HostDashboardUserActivityFeed(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Assemble page parts.
            RootElement.RemoveAll();
            if (InputContext.ViewingUser.IsSuperUser == false && InputContext.ViewingUser.IsEditor == false)
            {
                SerialiseAndAppend(new Error { Type = "Access Denied", ErrorMessage = "Access denied" }, "");
                return;
            }
            GetQueryParameters();

            if (_modClassId == 0)
            {
                if(_siteId == 0)
                {
                    AddErrorXml("NoSites", "No site data available", null);
                return;
                }
                //get moderator stats
                _modClassId = InputContext.TheSiteList.GetSite(_siteId).ModClassID;
            }
            ModerationClass modClass = ModerationClassListCache.GetObject().ModClassList.FirstOrDefault(x => x.ClassId == _modClassId);

            ModifyUserModerationStatus(modClass);

            var userRep = UserReputation.GetUserReputation(AppContext.ReaderCreator, modClass, _userId);
            SerialiseAndAppend(userRep, "");

            var userEventList = UserEventList.GetUserEventList(modClass, _startIndex,
                _itemsPerPage, _startDate, _endDate, AppContext.ReaderCreator, _userId);
            SerialiseAndAppend(userEventList, "");

            //get sitelist
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            siteXml.CreateXmlSiteList(InputContext.TheSiteList);
            RootElement.AppendChild(ImportNode(siteXml.RootElement.FirstChild));


            SerialiseAndAppend(SiteTypeEnumList.GetSiteTypes(), "");


        }

        private bool ModifyUserModerationStatus(ModerationClass modClass)
        {
            if (_updateStatus)
            {
                bool hideAllSites = InputContext.DoesParamExist("hideAllSites", "hideAllSites");
                var newPrefStatus = (BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus)Enum.Parse(typeof(BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus), InputContext.GetParamStringOrEmpty("userStatusDescription", "new status"));
                int newPrefStatusDuration = InputContext.GetParamIntOrZero("duration", "new status");
                bool hideAllContent = InputContext.DoesParamExist("hideAllPosts", "hideAllPosts");
                
                
                string reason = InputContext.GetParamStringOrEmpty("reasonChange", "");
                if (string.IsNullOrEmpty(reason))
                {
                    AddErrorXml("EmptyReason", "Please provide a valid reason for this change for auditing purposes.", null);
                    return false;
                }
                var extraNotes = InputContext.GetParamStringOrEmpty("additionalNotes", "");
                if (!String.IsNullOrEmpty(extraNotes))
                {
                    reason += " - " + extraNotes;
                }
                if (hideAllContent && newPrefStatus != BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Deactivated)
                {
                    AddErrorXml("InvalidStatus", "To hide all content you must deactivate the users account.", null);
                    return false;
                }

                if (newPrefStatusDuration != 0 && (newPrefStatus != BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Postmoderated
                    && newPrefStatus != BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Premoderated))
                {
                    AddErrorXml("UnableToSetDuration", "You cannot set a status duration when the status is not premoderation or postmoderation.", null);
                    return false;
                }

                if (newPrefStatus == BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Deactivated)//deactivate account
                {
                    if (!InputContext.ViewingUser.IsSuperUser)
                    {
                        AddErrorXml("InsufficientPermissions", "You do not have sufficient permissions to deactivate users.", null);
                        return false;
                    }
                    BBC.Dna.Moderation.Utils.ModerationStatus.DeactivateAccount(AppContext.ReaderCreator, new List<int>{_userId},
                        hideAllContent, reason, InputContext.ViewingUser.UserID);
                }
                else
                {
                    UserReputation userRep = new UserReputation()
                    {
                        ModClass = modClass,
                        UserId = _userId,
                        ReputationDeterminedStatus = newPrefStatus
                    };
                    userRep.ApplyModerationStatus(AppContext.ReaderCreator, hideAllSites, newPrefStatusDuration, reason,
                        InputContext.ViewingUser.UserID); 
                }

            }
            return true;
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = 0;
            if (InputContext.DoesParamExist("s_siteid", "sites to display"))
            {
                _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");
            }

            if (InputContext.DoesParamExist("s_modclassid", "mod class to display"))
            {
                _modClassId = InputContext.GetParamIntOrZero("s_modclassid", "s_modclassid");
            }
            
            _startDate = DateTime.MinValue;
            if(InputContext.DoesParamExist("s_startdate", "date to start display"))
            {
                var startDateStr = InputContext.GetParamStringOrEmpty("s_startdate", "days of stats to display");
                if (!DateTime.TryParse(startDateStr, out _startDate))
                {
                    _startDate = DateTime.MinValue;
                }
            }

            if (InputContext.DoesParamExist("s_enddate", "date to start display"))
            {
                var endDateStr = InputContext.GetParamStringOrEmpty("s_enddate", "days of stats to display");
                if (!DateTime.TryParse(endDateStr, out _endDate))
                {
                    _endDate = DateTime.Now;
                }
            }
            

            if (InputContext.DoesParamExist("s_user", "test userid"))
            {
                _userId = InputContext.GetParamIntOrZero("s_user", "test userid");
            }

            _updateStatus = InputContext.DoesParamExist("applyaction", "moderation action");

            if (InputContext.DoesParamExist("s_startindex", "startindex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startindex", "s_startindex");
            }

            if(InputContext.DoesParamExist("s_days", "amount of days to view"))
            {
                var days = InputContext.GetParamIntOrZero("s_days", "amount of days to view");
                if (days > 0)
                {
                    _endDate = DateTime.Now;
                    _startDate = _endDate.AddDays(days * -1);
                }
            }
        }

        private void TryGetUserSiteList(ref ArrayList userIDs, ref ArrayList siteIDs, ref ArrayList userNames, ref ArrayList deactivatedUsers)
        {
            userIDs = new ArrayList();
            siteIDs = new ArrayList();
            userNames = new ArrayList();
            deactivatedUsers = new ArrayList();

            bool applyToAll = InputContext.DoesParamExist("applyToAll", "applyToAll");

            var users = RootElement.SelectNodes("MEMBERLIST/USERACCOUNTS/USERACCOUNT");
            for (int i = 0; i < users.Count; i++)
            {
                var userId = 0;
                var siteId = 0;
                var userName = users.Item(i).SelectSingleNode("USERNAME").InnerText;
                var deactivated = users.Item(i).SelectSingleNode("ACTIVE").InnerText == "0";

                if (Int32.TryParse(users.Item(i).Attributes["USERID"].Value, out userId) && Int32.TryParse(users.Item(i).SelectSingleNode("SITEID").InnerText, out siteId))
                {
                    string formVar = string.Format("applyTo|{0}|{1}", userId, siteId);
                    if (applyToAll || InputContext.DoesParamExist(formVar, formVar))
                    {
                        userIDs.Add(userId);
                        siteIDs.Add(siteId);
                        userNames.Add(userName);
                        if (deactivated)
                        {
                            deactivatedUsers.Add(userId);
                        }
                    }
                }
            }
        }


    }
}