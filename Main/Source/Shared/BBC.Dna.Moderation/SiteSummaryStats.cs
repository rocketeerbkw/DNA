using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;

namespace BBC.Dna.Moderation
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "SITESUMMARYSTATS")]
    [XmlRootAttribute("SITESUMMARYSTATS", Namespace = "", IsNullable = false)]
    public class SiteSummaryStats
    {
        public SiteSummaryStats() { }

        [XmlElement("TOTALMODERATIONS")]
        public int TotalModerations { get; set; }

        [XmlElement("TOTALREFERREDMODERATIONS")]
        public int TotalReferredModerations { get; set; }

        [XmlElement("TOTALCOMPLAINTS")]
        public int TotalComplaints { get; set; }

        [XmlElement("UNIQUEMODERATIONUSERS")]
        public int UniqueModerationUsers { get; set; }

        [XmlElement("TOTALNOTABLEPOSTS")]
        public int TotalNotablePosts { get; set; }

        [XmlElement("TOTALHOSTPOSTS")]
        public int TotalHostPosts { get; set; }

        [XmlElement("TOTALPOSTS")]
        public int TotalPosts { get; set; }

        [XmlElement("TOTALEXLINKMODERATIONS")]
        public int TotalExLinkModerations { get; set; }

        [XmlElement("TOTALEXLINKREFERRALS")]
        public int TotalExLinkReferrals { get; set; }

        [XmlElement("TOTALEXLINKMODPASSES")]
        public int TotalExLinkModPasses { get; set; }

        [XmlElement("TOTALEXLINKMODFAILS")]
        public int TotalExLinkModFails { get; set; }

        [XmlElement("TOTALPOSTSFAILED")]
        public int TotalPostsFailed { get; set; }

        [XmlElement("TOTALNEWUSERS")]
        public int TotalNewUsers { get; set; }

        [XmlElement("TOTALBANNEDUSERS")]
        public int TotalBannedUsers { get; set; }

        [XmlElement("TOTALNICKNAMESMODERATIONS")]
        public int TotalNickNamesModerations { get; set; }

        [XmlAttributeAttribute("SITEID")]
        public int SiteId{ get; set; }

        [XmlAttributeAttribute("TYPE")]
        public int Type { get; set; }

        [XmlAttributeAttribute("USERID")]
        public int UserId { get; set; }

        [XmlAttributeAttribute("STARTDATE")]
        public DateTime StartDate { get; set; }

        [XmlAttributeAttribute("ENDDATE")]
        public DateTime EndDate { get; set; }


        /// <summary>
        /// Gets the stats for the given site and date range
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="siteId"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static SiteSummaryStats GetStatsBySite(IDnaDataReaderCreator creator, int siteId, DateTime startDate, DateTime endDate)
        {
            var siteSummaryStats = new SiteSummaryStats() { EndDate = endDate, StartDate = startDate, SiteId = siteId };
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getsitedailysummaryreportbysite"))
            {
                dataReader.AddParameter("enddate", endDate);
                dataReader.AddParameter("startdate", startDate);
                dataReader.AddParameter("siteId", siteId);

                dataReader.Execute();

                //replace empty items with actual queue data
                while (dataReader.Read())
                {
                    siteSummaryStats.TotalModerations = dataReader.GetInt32NullAsZero("TotalModerations");
                    siteSummaryStats.TotalReferredModerations = dataReader.GetInt32NullAsZero("TotalReferredModerations");
                    siteSummaryStats.TotalComplaints = dataReader.GetInt32NullAsZero("TotalComplaints");
                    siteSummaryStats.UniqueModerationUsers = dataReader.GetInt32NullAsZero("UniqueModerationUsers");
                    siteSummaryStats.TotalNotablePosts = dataReader.GetInt32NullAsZero("TotalNotablePosts");
                    siteSummaryStats.TotalHostPosts = dataReader.GetInt32NullAsZero("TotalHostPosts");
                    siteSummaryStats.TotalPosts = dataReader.GetInt32NullAsZero("TotalPosts");
                    siteSummaryStats.TotalExLinkModerations = dataReader.GetInt32NullAsZero("TotalExLinkModerations");
                    siteSummaryStats.TotalExLinkReferrals = dataReader.GetInt32NullAsZero("TotalExLinkReferrals");
                    siteSummaryStats.TotalExLinkModPasses = dataReader.GetInt32NullAsZero("TotalExLinkModPasses");
                    siteSummaryStats.TotalExLinkModFails = dataReader.GetInt32NullAsZero("TotalExLinkModFails");
                    siteSummaryStats.TotalPostsFailed = dataReader.GetInt32NullAsZero("TotalPostsFailed");
                    siteSummaryStats.TotalNewUsers = dataReader.GetInt32NullAsZero("TotalNewUsers");
                    siteSummaryStats.TotalBannedUsers = dataReader.GetInt32NullAsZero("TotalBannedUsers");
                    siteSummaryStats.TotalNickNamesModerations = dataReader.GetInt32NullAsZero("TotalNickNamesModerations");
                }
            }
            return siteSummaryStats;
        }

        /// <summary>
        /// Gets the stats for the given site and date range
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="siteId"></param>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static SiteSummaryStats GetStatsByType(IDnaDataReaderCreator creator, SiteType type, int userId, DateTime startDate, DateTime endDate)
        {
            var siteSummaryStats = new SiteSummaryStats() { EndDate = endDate, StartDate = startDate, Type = (int)type, UserId = userId};
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getsitedailysummaryreportbytype"))
            {
                dataReader.AddParameter("enddate", endDate);
                dataReader.AddParameter("startdate", startDate);
                dataReader.AddParameter("type", (int)type);
                dataReader.AddParameter("userId", userId);

                dataReader.Execute();

                //replace empty items with actual queue data
                while (dataReader.Read())
                {

                    siteSummaryStats.TotalModerations = dataReader.GetInt32NullAsZero("TotalModerations");
                    siteSummaryStats.TotalReferredModerations = dataReader.GetInt32NullAsZero("TotalReferredModerations");
                    siteSummaryStats.TotalComplaints = dataReader.GetInt32NullAsZero("TotalComplaints");
                    siteSummaryStats.UniqueModerationUsers = dataReader.GetInt32NullAsZero("UniqueModerationUsers");
                    siteSummaryStats.TotalNotablePosts = dataReader.GetInt32NullAsZero("TotalNotablePosts");
                    siteSummaryStats.TotalHostPosts = dataReader.GetInt32NullAsZero("TotalHostPosts");
                    siteSummaryStats.TotalPosts = dataReader.GetInt32NullAsZero("TotalPosts");
                    siteSummaryStats.TotalExLinkModerations = dataReader.GetInt32NullAsZero("TotalExLinkModerations");
                    siteSummaryStats.TotalExLinkReferrals = dataReader.GetInt32NullAsZero("TotalExLinkReferrals");
                    siteSummaryStats.TotalExLinkModPasses = dataReader.GetInt32NullAsZero("TotalExLinkModPasses");
                    siteSummaryStats.TotalExLinkModFails = dataReader.GetInt32NullAsZero("TotalExLinkModFails");
                    siteSummaryStats.TotalPostsFailed = dataReader.GetInt32NullAsZero("TotalPostsFailed");
                    siteSummaryStats.TotalNewUsers = dataReader.GetInt32NullAsZero("TotalNewUsers");
                    siteSummaryStats.TotalBannedUsers = dataReader.GetInt32NullAsZero("TotalBannedUsers");
                    siteSummaryStats.TotalNickNamesModerations = dataReader.GetInt32NullAsZero("TotalNickNamesModerations");
                }
            }
            return siteSummaryStats;
        }
    }
}
