using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class HostDashboardBuilder : DnaInputComponent
    {
        private int _siteId = 0;
        private SiteType _type = SiteType.Undefined;
        private int _userId = 0;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public HostDashboardBuilder(IInputContext context)
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
            //get moderator stats
            var moderatorInfo = ModeratorInfo.GetModeratorInfo(AppContext.ReaderCreator, _userId, InputContext.TheSiteList);
            var modStats = new ModStats(){Moderator = moderatorInfo};
            if (_siteId != 0)
            {
                modStats = ModStats.FetchModStatsBySite(AppContext.ReaderCreator, _userId, _siteId,
                    moderatorInfo, InputContext.ViewingUser.IsReferee, false);
            }
            else
            {
                modStats = ModStats.FetchModStatsBySiteType(AppContext.ReaderCreator, _userId, _type,
                   moderatorInfo, true, false);
            }
            SerialiseAndAppend(modStats, "");

            //get sitelist
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            siteXml.CreateXmlSiteList(InputContext.TheSiteList);
            RootElement.AppendChild(ImportNode(siteXml.RootElement.FirstChild));

        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = InputContext.GetParamIntOrZero("s_siteid", "siteid to display");
            _type = (SiteType)InputContext.GetParamIntOrZero("s_type", "type to display");

            _userId = InputContext.ViewingUser.UserID;
            if (InputContext.ViewingUser.IsSuperUser)
            {
                if (InputContext.DoesParamExist("s_userid", "test userid"))
                {
                    _userId = InputContext.GetParamIntOrZero("s_userid", "test userid");
                }
            }
        }
    }
}