using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Moderation;
using System.Linq;

namespace BBC.Dna.Component
{
    /// <summary>
    /// 
    /// </summary>
    public class SiteManager : DnaInputComponent
    {
         /// <summary>
        /// Default constructor for the MoreLinks component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SiteManager(IInputContext context)
            : base(context)
        {
          
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool GenerateXML( int siteId)
        {
            XmlElement xml = AddElementTag(RootElement, "SITEMANAGER");
            AddAttribute(xml, "SITEID", siteId);

            if (siteId > 0)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchsitedata"))
                {
                    dataReader.AddParameter("@siteid", siteId);
                    dataReader.Execute();

                    if (dataReader.Read())
                    {
                        AddTextElement(xml, "URLNAME", dataReader.GetStringNullAsEmpty("urlname"));
                        AddTextElement(xml, "SHORTNAME", dataReader.GetStringNullAsEmpty("shortname"));
                        AddTextElement(xml, "SSOSERVICE", dataReader.GetStringNullAsEmpty("ssoservice"));
                        AddTextElement(xml, "DESCRIPTION", dataReader.GetStringNullAsEmpty("description"));
                        AddTextElement(xml, "DEFAULTSKIN", dataReader.GetStringNullAsEmpty("defaultskin"));
                        AddTextElement(xml, "SKINSET", dataReader.GetStringNullAsEmpty("skinset"));
                        AddTextElement(xml, "MODERATORSEMAIL", dataReader.GetStringNullAsEmpty("moderatorsemail"));
                        AddTextElement(xml, "EDITORSEMAIL", dataReader.GetStringNullAsEmpty("editorsemail"));
                        AddTextElement(xml, "FEEDBACKEMAIL", dataReader.GetStringNullAsEmpty("feedbackemail"));
                        AddIntElement(xml, "PASSWORDED", dataReader.GetByteNullAsZero("passworded"));
                        AddIntElement(xml, "PREMODERATED", dataReader.GetByteNullAsZero("premoderation"));
                        AddIntElement(xml, "UNMODERATED", dataReader.GetByteNullAsZero("unmoderated"));
                        AddIntElement(xml, "INCLUDECRUMBTRAIL", dataReader.GetByteNullAsZero("includecrumbtrail"));
                        AddIntElement(xml, "ARTICLEFORUMSTYLE", dataReader.GetByteNullAsZero("articleforumstyle"));
                        AddIntElement(xml, "ALLOWREMOVEVOTE", dataReader.GetByteNullAsZero("allowremovevote"));
                        AddIntElement(xml, "ALLOWPOSTCODESINSEARCH", dataReader.GetInt32NullAsZero("allowpostcodesinsearch"));
                        AddIntElement(xml, "QUEUEPOSTINGS", dataReader.GetByteNullAsZero("queuepostings"));
                        AddIntElement(xml, "AUTOMESSAGEUSERID", dataReader.GetInt32NullAsZero("automessageuserid"));
                        AddIntElement(xml, "EVENTALERTMESSAGEUSERID", dataReader.GetInt32NullAsZero("eventalertmessageuserid"));
                        AddTextElement(xml, "EVENTEMAILSUBJECT", dataReader.GetStringNullAsEmpty("eventemailsubject"));
                        AddIntElement(xml, "THREADEDITTIMELIMIT", dataReader.GetInt32NullAsZero("threadedittimelimit"));
                        AddIntElement(xml, "THREADSORTORDER", dataReader.GetInt32NullAsZero("threadorder"));
                        AddIntElement(xml, "CUSTOMTERMS", dataReader.GetByteNullAsZero("agreedterms") == 0 ? 1 : 0);
                        AddIntElement(xml, "NOAUTOSWITCH", dataReader.GetByteNullAsZero("noautoswitch"));
                        AddIntElement(xml, "MODERATIONCLASSID", dataReader.GetInt32NullAsZero("modclassid"));
                        AddTextElement(xml, "CURRENTIDENTITYPOLICY", dataReader.GetStringNullAsEmpty("IdentityPolicy"));
                    }
                }
            }
            else
            {
                AddTextElement(xml, "URLNAME", "");
                AddTextElement(xml, "SHORTNAME", "");
                AddTextElement(xml, "SSOSERVICE", "");
                AddTextElement(xml, "DESCRIPTION","");
                AddTextElement(xml, "DEFAULTSKIN", "html");
                AddTextElement(xml, "SKINSET", "vanilla");
                AddTextElement(xml, "MODERATORSEMAIL", "");
                AddTextElement(xml, "EDITORSEMAIL", "");
                AddTextElement(xml, "FEEDBACKEMAIL", "");
                AddIntElement(xml, "PASSWORDED", 0);
                AddIntElement(xml, "PREMODERATED", 0);
                AddIntElement(xml, "UNMODERATED", 1);
                AddIntElement(xml, "INCLUDECRUMBTRAIL", 0);
                AddIntElement(xml, "ARTICLEFORUMSTYLE", 0);
                AddIntElement(xml, "ALLOWREMOVEVOTE", 0);
                AddIntElement(xml, "ALLOWPOSTCODESINSEARCH", 0);
                AddIntElement(xml, "QUEUEPOSTINGS", 0);
                AddIntElement(xml, "AUTOMESSAGEUSERID", 0);
                AddIntElement(xml, "EVENTALERTMESSAGEUSERID", 0);
                AddTextElement(xml, "EVENTEMAILSUBJECT", "");
                AddIntElement(xml, "THREADEDITTIMELIMIT", 0);
                AddIntElement(xml, "THREADSORTORDER", 0);
                AddIntElement(xml, "CUSTOMTERMS", 0);
                AddIntElement(xml, "NOAUTOSWITCH", 0);
                AddIntElement(xml, "MODERATIONCLASSID", 1);
                AddTextElement(xml, "CURRENTIDENTITYPOLICY", "");
            }

            // Get the Identity Policies and add them to the xml
            try
            {
                string identityWebServiceConnetionDetails = InputContext.GetConnectionDetails["IdentityURL"].ConnectionString;
                DnaIdentityWebServiceProxy.IDnaIdentityWebServiceProxy identityService = new DnaIdentityWebServiceProxy.IdentityRestSignIn(identityWebServiceConnetionDetails, "");
                identityService.SetService("h2g2");
                string[] policies = identityService.GetDnaPolicies();

                XmlElement policyTag = AddElementTag(xml, "IDENTITYPOLICIES");
                foreach (string policy in policies)
                {
                    AddTextElement(policyTag, "POLICY", policy);
                }

                SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
                XmlNode sites = siteXml.GenerateAllSitesXml(InputContext.TheSiteList);
                RootElement.AppendChild(ImportNode(sites.FirstChild));
            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private bool UpdateSite()
        {
            int modClassId = InputContext.GetParamIntOrZero("modclassid", "Moderation Class");
            int siteId = InputContext.GetParamIntOrZero("siteid", "siteId");
            if (!IsSiteLanguageCompatibleWithModClass(siteId, modClassId))
            {
                return false;
            }
            
            string shortName = InputContext.GetParamStringOrEmpty("shortname", "ShortName");
            string description = InputContext.GetParamStringOrEmpty("description", "Description");
            string skinSet = InputContext.GetParamStringOrEmpty("skinset", "SkinSet");
            string defaultSkin = InputContext.GetParamStringOrEmpty("defaultSkin", "DefaultSkin");
            string ssoService = InputContext.GetParamStringOrEmpty("ssoservice", "SSOService");
            int modStatus = InputContext.GetParamIntOrZero("modstatus", "Moderation Status");
            
            int noAutoSwitch = InputContext.GetParamIntOrZero("noautoswitch", "NoAutoSwitch");
            int customTerms = InputContext.GetParamIntOrZero("customterms", "CustomTerms");
            string moderatorsEmail = InputContext.GetParamStringOrEmpty("moderatorsemail", "Moderators Email");
            string editorsEmail = InputContext.GetParamStringOrEmpty("editorsemail", "Editors Email");
            string feedbackEmail = InputContext.GetParamStringOrEmpty("feedbackemail", "feedback Email");
            int autoMessageUserId = InputContext.GetParamIntOrZero("automessageuserid", "AutoMessageUserId");
            int passworded = InputContext.GetParamIntOrZero("passworded", "Passworded");
            int forumStyle = InputContext.GetParamIntOrZero("articleforumstyle", "ForumStyle");
            int threadOrder = InputContext.GetParamIntOrZero("threadorder", "Thread Sort Order");
            int threadEditTimeLimit = InputContext.GetParamIntOrZero("threadedittimelimit", "ThreadEditTimeLimit");
            int eventAlertMessageUserId = InputContext.GetParamIntOrZero("eventalertmessageuserid", "EventAlertMessageUserId");
            int allowRemoveVote = InputContext.GetParamIntOrZero("allowremovevote", "AllowRemoveVote");
            int includeCrumbTrail = InputContext.GetParamIntOrZero("includecrumbtrail", "IncludeCrumbrail");
            int allowPostCodesInSearch = InputContext.GetParamIntOrZero("allowpostcodesinsearch", "AllowPostCodesInSearch");
            string eventEmailSubject = InputContext.GetParamStringOrEmpty("eventemailsubject", "EventEmailSubject");
            int queuePostings = InputContext.GetParamIntOrZero("queuePostings", "QueuePostings");
            string identityPolicy = InputContext.GetParamStringOrEmpty("identitypolicy", "IdentityPolicy");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updatesitedetails"))
            {
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("shortname", shortName);
                dataReader.AddParameter("description", description);
                dataReader.AddParameter("defaultskin", defaultSkin);
                dataReader.AddParameter("skinset", skinSet);
                dataReader.AddParameter("premoderation", modStatus == 3 ? 1 : 0 );
                dataReader.AddParameter("unmoderated", modStatus == 1 ? 1 : 0);
                dataReader.AddParameter("noautoswitch", noAutoSwitch);
                dataReader.AddParameter("customterms", customTerms);
                dataReader.AddParameter("moderatorsemail", moderatorsEmail);
                dataReader.AddParameter("editorsemail", editorsEmail);
                dataReader.AddParameter("feedbackemail", feedbackEmail);
                dataReader.AddParameter("automessageuserid", autoMessageUserId);
                dataReader.AddParameter("passworded", passworded);
                dataReader.AddParameter("articleforumstyle", forumStyle);
                dataReader.AddParameter("threadorder", threadOrder);
                dataReader.AddParameter("threadedittimelimit", threadEditTimeLimit);
                dataReader.AddParameter("eventalertmessageuserid", eventAlertMessageUserId);
                dataReader.AddParameter("allowremovevote", allowRemoveVote);
                dataReader.AddParameter("includecrumbtrail", includeCrumbTrail);
                dataReader.AddParameter("allowpostcodesinsearch", allowPostCodesInSearch);
                dataReader.AddParameter("eventemailsubject", eventEmailSubject);
                dataReader.AddParameter("queuepostings", queuePostings);
                dataReader.AddParameter("ssoservice", ssoService);
                dataReader.AddParameter("IdentityPolicy", identityPolicy);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    if ( dataReader.GetInt32NullAsZero("Result") != 0 )
                    {
                        String error = String.Empty;
                        if (dataReader.DoesFieldExist("error"))
                            error = dataReader.GetStringNullAsEmpty("Error");
                        AddErrorXml("UPDATE ERROR", "Unable to update site ." + error, RootElement);
                        return false;
                    }
                }
                else
                {
                    AddErrorXml("UPDATE ERROR", "Unable to update site .", RootElement);
                    return false;
                }
            }
            

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("changemoderationclassofsite"))
            {
                dataReader.AddParameter("siteid",siteId);
                dataReader.AddParameter("classid", modClassId);
                dataReader.Execute();

                if (!dataReader.Read() || dataReader.GetInt32NullAsZero("Result") != 0 )
                {
                    AddErrorXml("UPDATE ERROR", "Unable to update site moderation class .", RootElement);
                    return false;
                }
            }

            return true;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private bool CreateSite(ref int siteId)
        {
            string urlName = InputContext.GetParamStringOrEmpty("urlname", "UrlName");
            string shortName = InputContext.GetParamStringOrEmpty("shortname", "ShortName");
            string description = InputContext.GetParamStringOrEmpty("description", "Description");
            string skinSet = InputContext.GetParamStringOrEmpty("skinset", "SkinSet");
            string defaultSkin = InputContext.GetParamStringOrEmpty("defaultSkin", "DefaultSkin");
            string ssoService = InputContext.GetParamStringOrEmpty("ssoservice", "SSOService");
            int modStatus = InputContext.GetParamIntOrZero("modstatus", "Moderation Status");
            int modClassId = InputContext.GetParamIntOrZero("modclassid", "Moderation Class");
            int noAutoSwitch = InputContext.GetParamIntOrZero("noautoswitch", "NoAutoSwitch");
            int customTerms = InputContext.GetParamIntOrZero("customterms", "CustomTerms");
            string moderatorsEmail = InputContext.GetParamStringOrEmpty("moderatorsemail", "Moderators Email");
            string editorsEmail = InputContext.GetParamStringOrEmpty("editorsemail", "Editors Email");
            string feedbackEmail = InputContext.GetParamStringOrEmpty("feedbackemail", "feedback Email");
            int autoMessageUserId = InputContext.GetParamIntOrZero("automessageuserid", "AutoMessageUserId");
            int passworded = InputContext.GetParamIntOrZero("passworded", "Passworded");
            int forumStyle = InputContext.GetParamIntOrZero("articleforumstyle", "ForumStyle");
            int threadOrder = InputContext.GetParamIntOrZero("threadorder", "Thread Sort Order");
            int threadEditTimeLimit = InputContext.GetParamIntOrZero("threadedittimelimit", "ThreadEditTimeLimit");
            int eventAlertMessageUserId = InputContext.GetParamIntOrZero("eventalertmessageuserid", "EventAlertMessageUserId");
            int allowRemoveVote = InputContext.GetParamIntOrZero("allowremovevote", "AllowRemoveVote");
            int includeCrumbTrail = InputContext.GetParamIntOrZero("includecrumbtrail", "IncludeCrumbrail");
            int allowPostCodesInSearch = InputContext.GetParamIntOrZero("allowpostcodesinsearch", "AllowPostCodesInSearch");
            string eventEmailSubject = InputContext.GetParamStringOrEmpty("eventemailsubject", "EventEmailSubject");
            int queuePostings = InputContext.GetParamIntOrZero("queuePostings", "QueuePostings");
            int useFrames = InputContext.GetParamIntOrZero("useframes", "UseFrames");
            string identityPolicy = InputContext.GetParamStringOrEmpty("identitypolicy", "IdentityPolicy");

            if ( urlName == string.Empty || description == string.Empty || shortName == string.Empty)
            {
                AddErrorXml("CREATE ERROR", "Unable to create site - url, Description, shortName are required.", RootElement);
                return false;
            }

            ISite site = InputContext.TheSiteList.GetSite(urlName);
            if (site != null)
            {
                AddErrorXml("CREATE ERROR", "Unable to create site - urlname already in use.", RootElement);
                return false;
            }

            // string siteConfig = ""; // Assume no site config in the default case
            //string siteType = InputContext.GetParamStringOrEmpty("sitetype", "SiteType");
			//bool bCommentsSite = false, bMessageboardSite = false, bBlogSite = false;
            /*switch ( siteType)
            {
                case "Messageboard":
                    siteConfig = GetMessageboardSiteConfig( urlName );
                    bMessageboardSite = true;
                    break;
                case "Comments":
                    siteConfig = GetCommentsSiteConfig( urlName );
                    // The current commenting sites have "boards" set as their default, with the
                    // "acs" skin added as an extra skin.  This gives the commenting sites a bit more
                    // functionality, but is really a hack.  The "acs" skin needs developing to have all
                    // the functionality that comments need, and commenting sites should only have the 
                    // "acs" skin assigned to them
                    bCommentsSite = true;
                    break;
				case "Blog":
                    siteConfig = GetBlogSiteConfig( urlName );
					bBlogSite = true;
					break;
            }*/

            int premoderationValue = InputContext.GetParamIntOrZero("modstatus", "ModerationStatus") == 3 ? 1 : 0; 
            int unmoderatedValue = InputContext.GetParamIntOrZero("modstatus", "ModerationStatus")  == 1 ? 1 : 0;
            

            
            if (ssoService == string.Empty)
            {
                ssoService = urlName;
            }

          
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createnewsite"))
            {
                reader.AddParameter("urlname", urlName);
                reader.AddParameter("shortname", shortName);
                reader.AddParameter("description", description);
                reader.AddParameter("ssoservice", ssoService);

                reader.AddParameter("defaultskin", defaultSkin);
                reader.AddParameter("skindescription", defaultSkin);
                reader.AddParameter("skinset", skinSet);
                reader.AddParameter("useframes", useFrames);

                reader.AddParameter("premoderation", premoderationValue);
                reader.AddParameter("noautoswitch", noAutoSwitch);
                reader.AddParameter("customterms", customTerms);

                reader.AddParameter("moderatorsemail", moderatorsEmail);
                reader.AddParameter("editorsemail", editorsEmail);
                reader.AddParameter("feedbackemail", feedbackEmail);

                reader.AddParameter("automessageuserid", autoMessageUserId);
                reader.AddParameter("passworded", passworded);
                reader.AddParameter("unmoderated", unmoderatedValue);
                reader.AddParameter("articleforumstyle", forumStyle);
                reader.AddParameter("threadorder", threadOrder);
                reader.AddParameter("threadedittimelimit", threadEditTimeLimit);

                reader.AddParameter("eventalertmessageuserid", eventAlertMessageUserId );
                reader.AddParameter("eventemailsubject", eventEmailSubject);

                reader.AddParameter("includecrumbtrail", includeCrumbTrail );
                reader.AddParameter("allowpostcodesinsearch", allowPostCodesInSearch );
                reader.AddParameter("allowremovevote", allowRemoveVote);
                reader.AddParameter("queuepostings", queuePostings);
                reader.AddParameter("IdentityPolicy", identityPolicy);
                if ( modClassId > 0 )
                    reader.AddParameter("modclassid", modClassId);

                reader.Execute();
                reader.Read();
                siteId = reader.GetInt32("SiteID");
            }

            if (siteId == 0)
            {
                AddErrorXml("CREATE ERROR", "Unable to create site .", RootElement);
                return false;
            }


            /*if (bCommentsSite)
            {
                // Add the "acs" skin to the site, for Comments sites.
                using (IDnaDataReader reader = _basePage.CreateDnaDataReader("addskintosite"))
                {
                    reader.AddParameter("siteid", siteId);
                    reader.AddParameter("skinname", "acs");
                    reader.AddParameter("description", "acs");
                    reader.AddParameter("useframes", GetYesNoValue(ddUseFrames));
                    reader.Execute();
                }
            }*/

            // Create xml skin if it exists in specified skinset. ( Funcionality Available on OutputContext.
            String path = AppContext.TheAppContext.Config.GetSkinRootFolder() + "SkinSets" + @"\" + skinSet + @"\xml\output.xsl";
            FileInfo fileInfo = new FileInfo(path);
            if ( fileInfo.Exists )
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addskintosite"))
                {
                    reader.AddParameter("siteid", siteId);
                    reader.AddParameter("skinname", "xml");
                    reader.AddParameter("description", "xml");
                    reader.AddParameter("useframes", 0);
                    reader.Execute();
                }
            }


            //if (bCommentsSite || bMessageboardSite || bBlogSite)
            //{
            //    using (IDnaDataReader reader = InputContext.CreateDnaDataReader("updatesiteconfig"))
            //    {
            //        reader.AddParameter("siteid", siteId);
            //        reader.AddParameter("config", siteConfig);
            //        reader.Execute();
            //    }
            //}

            return true;
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            int siteId = InputContext.GetParamIntOrZero("siteid", "siteid");
            if (siteId == 0)
            {
                siteId = InputContext.CurrentSite.SiteID;
            }

            if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsSuperUser)
            {
                AddErrorXml("INVALID PERMISSIONS", "Superuser permissions required", RootElement);
                return;
            }

            if (InputContext.DoesParamExist("create","Create Site") )
            {
                if (CreateSite(ref siteId))
                {
                    AppContext.TheAppContext.TheSiteList.SendSignal(siteId);
                }
            }
            else if (InputContext.DoesParamExist("update", "Update Site") )
            {
                if (UpdateSite())
                {
                    AppContext.TheAppContext.TheSiteList.SendSignal(siteId);
                }
            }

            GenerateXML(siteId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private bool IsSiteLanguageCompatibleWithModClass(int siteId, int modClassId)
        {
            //check modclass language vs site language to ensure they are compatible
            var modClasses = ModerationClassList.GetAllModerationClasses(AppContext.ReaderCreator, AppContext.DnaCacheManager, false);
            var modClass = modClasses.ModClassList.FirstOrDefault(x => x.ClassId == modClassId);
            var siteLanguage = InputContext.TheSiteList.GetSiteOptionValueString(siteId, "General", "SiteLanguage");
            if (siteLanguage.ToUpper() != modClass.Language.ToUpper())
            {
                AddErrorXml("UPDATE ERROR", "Site language is not compatible with new moderation class language.", RootElement);
                return false;
            }
            return true;
        }
    }
}
