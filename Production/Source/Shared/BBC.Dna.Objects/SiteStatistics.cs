using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Common;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;

namespace BBC.Dna.Objects
{
    public class SiteStatistics
    {
        public int TotalEditedEntries { get; set;}
        public int TotalUneditedEntries { get; set; }
        public List<ThreadSummary> MostRecentConversations { get; set; }
        public List<ArticleSummary> MostRecentGuideEntries { get; set; }

        public static SiteStatistics CreateSiteStatistics(IDnaDataReaderCreator readerCreator, int siteId)
        {

            var stats = new SiteStatistics();
            stats.TotalUneditedEntries = GetUneditedArticleCount(readerCreator, siteId);
            stats.TotalEditedEntries = GetTotalEditedEntries(readerCreator, siteId);
            stats.MostRecentGuideEntries = CreateRecentArticles(readerCreator, siteId, 0, 20);
            stats.MostRecentConversations = CreateRecentConversations(readerCreator, siteId, 0, 20);

            return stats;
        }

        /// <summary>
        /// Gets the total number of uneditted articles
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <returns></returns>
        private static int GetUneditedArticleCount(IDnaDataReaderCreator readerCreator, int siteID)
        {
            int count;
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("totalunapprovedentries"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();

                if (!dataReader.HasRows || !dataReader.Read()) { return 0; }
                count =  dataReader.GetInt32NullAsZero("cnt");
            }
            return count;
        }

        /// <summary>
        /// Gets the total number of approved articles
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <returns></returns>
        private static int GetTotalEditedEntries(IDnaDataReaderCreator readerCreator, int siteID )
        {
            int count;
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("totalapprovedentries"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();
                
                if (!dataReader.HasRows || !dataReader.Read()) { return 0; }
                count = dataReader.GetInt32NullAsZero("cnt");

            }
            return count;

        }

        /// <summary>
        /// Gets the latest articles for a given site
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <param name="skip">Number to skip</param>
        /// <param name="show"></param>
        /// <returns></returns>
        private static List<ArticleSummary> CreateRecentArticles(IDnaDataReaderCreator readerCreator, int siteID, int skip, int show)
        {            
            List<ArticleSummary> recentArticles = new List<ArticleSummary>();
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("freshestarticles"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("show", show);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                if (!dataReader.HasRows) { return null; }

                while (dataReader.Read())
                {
                    recentArticles.Add(ArticleSummary.CreateArticleSummaryFromReader(dataReader));
                }
            }
            return recentArticles;
        }

        /// <summary>
        /// Gets the latest conversations for a given site
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <param name="skip">Number to skip</param>
        /// <param name="show"></param>
        /// <returns></returns>
        private static List<ThreadSummary> CreateRecentConversations(IDnaDataReaderCreator readerCreator, int siteID, int skip, int show)
        {
            List<ThreadSummary> recentThreads = new List<ThreadSummary>();
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("freshestconversations"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("show", show);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                if (!dataReader.HasRows) { return null; }
                
                while (dataReader.Read() && show > 0)
                {
                    recentThreads.Add(
                        ThreadSummary.CreateThreadSummaryFromReader(dataReader,
                        dataReader.GetInt32NullAsZero("ForumId"),
                         0)
                        );

                    show--;
                }

            }
            return recentThreads;
        }

    }
}
