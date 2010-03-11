using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;

//Build you bugger!!

namespace BBC.Dna.Component
{
    /// <summary>
    /// The Signal class which is used to signal all the other servers about server wide changes
    /// </summary>
    public class Signal : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context"></param>
        public Signal(IInputContext context) : base(context)
        {
        }

        /// <summary>
        /// The process request function
        /// </summary>
        public override void ProcessRequest()
        {
            // Check to see what we've been asked to do anything
            string action = "";
            if (InputContext.TryGetParamString("action",ref action, "Which signal is this. 'recache-site' or 'recache-groups' are valid"))
            {
                // Now see what that anything is
                if (action.ToLower() == "recache-site")
                {
                    // We need to reload the site data
                    ReloadSiteData();
                    //Get the profanity list as well..
                    ProfanityFilter.InitialiseProfanities(AppContext.ReaderCreator, AppContext.TheAppContext.Diagnostics);
                }
                else if (action.ToLower() == "recache-groups")
                {
                    // We're being asked to reload the groups information
                    ReloadGroupInformation();
                }
                else if (action.ToLower() == "recache-allowedurls")
                {
                    // We're being asked to reload the allowed urls information
                    ReloadAllowedURLs();
                }                    
                else if (action.ToLower() == "new-skin")
                {
                    // A new site skin has been created, so we need to make sure a skin folder with default
                    // skin file exists
                    string skinName = "";
                    if (InputContext.TryGetParamString("skinName", ref skinName, "The name of the new site skin."))
                    {
                        CreateNewSkinFolder(skinName);
                    }
                    else
                    {
                        InputContext.Diagnostics.WriteWarningToLog("Signal", "new-site signal received, but skinName param was missing");
                    }
                }
                else
                {
                    // Don't reconise what the action is!
                    return;
                }

                // Add some XML to the page to say that we actually did something
                XmlNode xml = CreateElementNode("SIGNAL");
                AddAttribute(xml, "ACTION", InputContext.UrlEscape(action));
                RootElement.AppendChild(xml);
            }
        }

        private void CreateNewSkinFolder(string skinName)
        {
            InputContext.Diagnostics.WriteToLog("Signal", "Creating new skin folder: " + skinName);
            string skinFolderPath = Path.Combine(AppContext.TheAppContext.Config.GetSkinRootFolder(), skinName);
            if (!Directory.Exists(skinFolderPath))
            {
                Directory.CreateDirectory(skinFolderPath);

                string devHtmlOutputFile = Path.Combine(AppContext.TheAppContext.Config.GetSkinRootFolder(), @"dev\HTMLOutput.xsl");
                string newSkinHtmlOutputFile = Path.Combine(skinFolderPath, @"HTMLOutput.xsl");
                File.Copy(devHtmlOutputFile, newSkinHtmlOutputFile);

                InputContext.Diagnostics.WriteToLog("Signal", "Created new skin folder: " + skinName);
            }
            else
            {
                InputContext.Diagnostics.WriteToLog("Signal", "Skin folder already exists: " + skinName);
            }
        }

        private void ReloadSiteData()
        {
            // Call the EnsureSiteListExists function with a force to recache
            InputContext.EnsureSiteListExists(true, InputContext);

            InputContext.Diagnostics.WriteToLog("Signal", "Reloaded site data");
        }

        private void ReloadAllowedURLs()
        {
            // Call the EnsureSiteListExists function with a force to recache
            InputContext.EnsureAllowedURLsExists(true, InputContext);

            InputContext.Diagnostics.WriteToLog("Signal", "Reloaded allowed url data");
        }

        private void ReloadGroupInformation()
        {
			int userID = InputContext.GetParamIntOrZero("userID","ID of single user whose group data needs recaching");
			if (userID > 0)
			{
				UserGroups.RefreshCacheForUser(userID, InputContext);
			}
			else
			{
				// Call the refresh usergroups function
				UserGroups.RefreshCache(InputContext);
			}

            InputContext.Diagnostics.WriteToLog("Signal", "Reloaded group info");
        }
    }
}
