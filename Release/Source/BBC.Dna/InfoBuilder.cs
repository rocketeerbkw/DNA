using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{

    /// <summary>
    /// Builds the sub-article details and builds them into the page XML
    /// </summary>
    public class InfoBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default constructor of SubArticleStatusBuilder
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public InfoBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {


            //prepare XML Doc
            RootElement.RemoveAll();
            XmlElement infoRoot = AddElementTag(RootElement, "INFO");

            //get parameters for request
            string command = InputContext.GetParamStringOrEmpty("cmd", "The switch that outlines what to return");
            int skip = InputContext.GetParamIntOrZero("skip", "The number of entries to skip");
            int show = InputContext.GetParamIntOrZero("show", "the number of entries to show");
            if (show == 0)
            {
                show = 20;
            }

            //switch to get correct behaviour for inputs
            switch(command.ToUpper())
            {
                case "CONV"://show recent conversations
                    CreateRecentConversations(InputContext.CurrentSite.SiteID, skip, show);
                    break;

                case "ART"://show recent articles
                    CreateRecentArticles(InputContext.CurrentSite.SiteID, skip, show);
                    break;

                case "TAE"://show total approved entries
                    CreateTotalApprovedEntries(InputContext.CurrentSite.SiteID);
                    break;

                case "TRU"://show total registered users
                    CreateTotalRegisteredUsers();
                    break;

                case "TUE"://show uneditted entries count
                    CreateUneditedArticleCount(InputContext.CurrentSite.SiteID);
                    break;

                case "PP"://show top 10 prolific posters
                    CreateProlificPosters(InputContext.CurrentSite.SiteID);
                    break;

                case "EP"://show total 10 Erudite posters
                    CreateEruditePosters(InputContext.CurrentSite.SiteID);
                    break;

                default://nothing passed - show all options
                    infoRoot.InnerText = "No specific info requested";
                    break;
            }



        }

        /// <summary>
        /// Gets the latest conversation for a given site
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <param name="skip">Number to skip</param>
        /// <param name="show"></param>
        /// <returns></returns>
        private bool CreateRecentConversations(int siteID, int skip, int show)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("freshestconversations"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("show", show);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                if (!dataReader.HasRows)
                {
                    return false;
                }

                int originalShow = show;
                XmlElement recentConversations = CreateElement("RECENTCONVERSATIONS");
                while (dataReader.Read() && show > 0)
                {
                    XmlElement recentConversation = CreateElement("RECENTCONVERSATION");
                    AddTextElement(recentConversation, "FIRSTSUBJECT", dataReader.GetAmpersandEscapedStringNullAsEmpty("FirstSubject"));

                    AddElement(recentConversation, "DATEPOSTED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dataReader.GetDateTime("LastPosted")));

                    AddIntElement(recentConversation, "FORUMID", dataReader.GetInt32NullAsZero("Forumid"));
                    AddIntElement(recentConversation, "THREADID", dataReader.GetInt32NullAsZero("ThreadID"));
                    recentConversations.AppendChild(recentConversation);

                    show--;
                }
                ImportAndAppend(recentConversations, "/DNAROOT/INFO");

                XmlNode infoNode = RootElement.SelectSingleNode("/DNAROOT/INFO");
                AddAttribute(infoNode, "SKIPTO", skip);
                AddAttribute(infoNode, "COUNT", originalShow - show);
                AddAttribute(infoNode, "MODE", "conversations");
                if (dataReader.Read() && show == 0)
                {
                    AddAttribute(infoNode, "MORE", 1);
                }
            }
            return true;
        }

        /// <summary>
        /// Gets the latest articles for a given site
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <param name="skip">Number to skip</param>
        /// <param name="show"></param>
        /// <returns></returns>
        private bool CreateRecentArticles(int siteID, int skip, int show)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("freshestarticles"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("show", show);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                if (!dataReader.HasRows)
                {
                    return false;
                }
                XmlElement recentArticles = CreateElement("FRESHESTARTICLES");
                int originalShow = show;
                while (dataReader.Read() && show > 0)
                {
                    XmlElement recentArticle = CreateElement("RECENTARTICLE");
                    AddIntElement(recentArticle, "H2G2ID", dataReader.GetInt32NullAsZero("h2g2ID"));
                    AddIntElement(recentArticle, "STATUS", dataReader.GetInt32NullAsZero("STATUS"));

                    AddElement(recentArticle, "DATEUPDATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dataReader.GetDateTime("DateCreated")));
                    AddTextElement(recentArticle, "SUBJECT", dataReader.GetAmpersandEscapedStringNullAsEmpty("subject"));
                    recentArticles.AppendChild(recentArticle);

                    show--;
                }
                ImportAndAppend(recentArticles, "/DNAROOT/INFO");

                XmlNode infoNode = RootElement.SelectSingleNode("/DNAROOT/INFO");
                AddAttribute(infoNode, "SKIPTO", skip);
                AddAttribute(infoNode, "COUNT", originalShow - show);
                AddAttribute(infoNode, "MODE", "articles");
                if (dataReader.Read() && show == 0)
                {
                    AddAttribute(infoNode, "MORE", 1);
                }
            }
            return true;
        }

        /// <summary>
        /// Gets the total number of approved entries
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <returns></returns>
        private bool CreateTotalApprovedEntries(int siteID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("totalapprovedentries"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();

                if (!dataReader.HasRows || !dataReader.Read())
                {
                    return false;
                }
                AddIntElement(RootElement.SelectSingleNode("/DNAROOT/INFO"), "APPROVEDENTRIES", dataReader.GetInt32NullAsZero("cnt"));
            }
            return true;
        }

        /// <summary>
        /// Gets the total number of registered users
        /// </summary>
        /// <returns></returns>
        private bool CreateTotalRegisteredUsers()
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("totalregusers"))
            {
                dataReader.Execute();

                if (!dataReader.HasRows || !dataReader.Read())
                {
                    return false;
                }
                AddIntElement(RootElement.SelectSingleNode("/DNAROOT/INFO"), "TOTALREGUSERS", dataReader.GetInt32NullAsZero("cnt"));
            }
            return true;
        }

        /// <summary>
        /// Gets the total number of uneditted articles
        /// </summary>
        /// <param name="siteID">The site id</param>
        /// <returns></returns>
        private bool CreateUneditedArticleCount(int siteID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("totalunapprovedentries"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();

                if (!dataReader.HasRows || !dataReader.Read())
                {
                    return false;
                }
                AddIntElement(RootElement.SelectSingleNode("/DNAROOT/INFO"), "UNEDITEDARTICLES", dataReader.GetInt32NullAsZero("cnt"));
            }
            return true;
        }

        /// <summary>
        /// Creates a list of prolific posters
        /// </summary>
        /// <param name="siteID">The site ID</param>
        /// <returns></returns>
        private bool CreateProlificPosters(int siteID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("prolificposters"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();

                XmlElement prolificPosters = CreateElement("PROLIFICPOSTERS");
                if (!dataReader.HasRows)
                {
                    prolificPosters.InnerText = "No even remotely prolific posters at the moment :(";
                }
                else
                {
                    //process results
                    while (dataReader.Read())
                    {
                        XmlElement prolificPoster = CreateElement("PROLIFICPOSTER");

                        XmlElement userXML = CreateElement("USER");
                        AddTextElement(userXML, "USERNAME", dataReader.GetStringNullAsEmpty("USERNAME"));
                        AddIntElement(userXML, "USERID", dataReader.GetInt32NullAsZero("USERID"));
                        prolificPoster.AppendChild(userXML);

                        AddIntElement(prolificPoster, "COUNT", dataReader.GetInt32NullAsZero("cnt"));
                        AddIntElement(prolificPoster, "AVERAGESIZE", dataReader.GetInt32NullAsZero("ratio"));

                        prolificPosters.AppendChild(prolificPoster);
                    }
                }
                ImportAndAppend(prolificPosters, "/DNAROOT/INFO");
            }
            return true;

        }

        /// <summary>
        /// Creates a list of erudite posters
        /// </summary>
        /// <param name="siteID">The site ID</param>
        /// <returns></returns>
        private bool CreateEruditePosters(int siteID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("eruditeposters"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();

                XmlElement eruditePosters = CreateElement("ERUDITEPOSTERS");
                if (!dataReader.HasRows)
                {
                    eruditePosters.InnerText = "No even remotely erudite posters at the moment :(";
                }
                else
                {
                    //process results
                    while (dataReader.Read())
                    {
                        XmlElement eruditePoster = CreateElement("ERUDITEPOSTER");

                        XmlElement userXML = CreateElement("USER");
                        AddTextElement(userXML, "USERNAME", dataReader.GetStringNullAsEmpty("USERNAME"));
                        AddIntElement(userXML, "USERID", dataReader.GetInt32NullAsZero("USERID"));
                        eruditePoster.AppendChild(userXML);

                        AddIntElement(eruditePoster, "COUNT", dataReader.GetInt32NullAsZero("cnt"));
                        AddIntElement(eruditePoster, "AVERAGESIZE", dataReader.GetInt32NullAsZero("ratio"));

                        eruditePosters.AppendChild(eruditePoster);
                    }
                }
                ImportAndAppend(eruditePosters, "/DNAROOT/INFO");
            }
            return true;

        }

    }
}
