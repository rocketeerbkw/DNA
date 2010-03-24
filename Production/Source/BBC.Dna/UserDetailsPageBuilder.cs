using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using System.Text.RegularExpressions;
using BBC.Dna.Moderation.Utils;


namespace BBC.Dna.Component
{

    /// <summary>
    /// Builds the sub-article details and builds them into the page XML
    /// </summary>
    public class UserDetailsPageBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default constructor of SubArticleStatusBuilder
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UserDetailsPageBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Construct a user page from its various constituent parts based
        ///		on the request info available from the input context supplied during
        ///		construction.
        /// </summary>
        public override void ProcessRequest()
        {
            //prepare XML Doc
            RootElement.RemoveAll();
            XmlElement userForm = AddElementTag(RootElement, "USER-DETAILS-FORM");

            //set up response strings
            string messageString = String.Empty;
            string messageType = String.Empty;

            // We are registered, handle userdetails form 
            // before anything else find out whether we are dealing with a request to view
            // the page or a submit request to update the details
            if (InputContext.DoesParamExist("setskin", "The set skin flag"))
            {
                string newSkin = InputContext.GetParamStringOrEmpty("NewSkin", "the name of the new skin");

                InputContext.ViewingUser.BeginUpdateDetails();
                if (newSkin != InputContext.ViewingUser.PreferredSkin && newSkin.IndexOf("purexml") < 0)
                {//don't set purexml as the default skin
                    InputContext.ViewingUser.SetPreferredSkinInDB(newSkin);
                }
                if (InputContext.ViewingUser.UpdateDetails())
                {
                    messageString = "Your new skin has been set";
                    messageType = "skinset";
                }
            }
            // if a submit request then it will have a CGI parameter called 'cmd'
            // with the value 'submit'
            string formCommand = InputContext.GetParamStringOrEmpty("cmd", "The value of the CMD");

            if (InputContext.ViewingUser.IsBanned || InputContext.ViewingUser.UserID == 0)
            {//either banned user or no user passed
                messageString = "Not allowed";
                messageType = "restricteduser";
            }
            else if (formCommand.ToUpper() == "SUBMIT")
            {
                //do updateuserdetails
                UpdateUserDetails(ref messageString, ref messageType);
            }

            User tempUser = new User(InputContext);
            if (InputContext.ViewingUser.UserID != 0)
            {
                // Refresh the user object to get new data...
                tempUser = new User(InputContext);
                tempUser.ShowFullDetails = true;
                tempUser.CreateUser(InputContext.ViewingUser.UserID);
            }
            int userID = tempUser.UserID;
            string userName = tempUser.UserName;
            string userEmail = tempUser.Email;
            string prefSkin = tempUser.PreferredSkin;
            InputContext.ViewingUser.PreferredSkin = prefSkin;

            int prefUserMode = 0;
            if (tempUser.UserData.ContainsKey("PrefUserMode"))
                prefUserMode = Int32.Parse(tempUser.UserData["PrefUserMode"].ToString());

            int prefForumStyle = 0;
            if (tempUser.UserData.ContainsKey("PrefForumStyle"))
                prefForumStyle = Int32.Parse(tempUser.UserData["PrefForumStyle"].ToString());

            string prefXML = String.Empty;
            if (tempUser.UserData.ContainsKey("PrefXML"))
                prefXML = (string)tempUser.UserData["PrefXML"];

            string siteSuffix = String.Empty;
            if (tempUser.UserData.ContainsKey("SiteSuffix"))
                siteSuffix = (string)tempUser.UserData["SiteSuffix"];

            string region = String.Empty;
            if (tempUser.UserData.ContainsKey("Region"))
                region = (string)tempUser.UserData["Region"];


            //add message xml
            XmlNode messageXML = AddElementTag(userForm, "MESSAGE");
            AddAttribute(messageXML, "TYPE", messageType);
            messageXML.InnerText = messageString;
            AddIntElement(userForm, "USERID", userID);
            AddTextElement(userForm, "USERNAME", userName);
            AddTextElement(userForm, "EMAIL-ADDRESS", userEmail);
            AddTextElement(userForm, "REGION", region);
            XmlElement preferenceXML = AddElementTag(userForm, "PREFERENCES");
            AddTextElement(preferenceXML, "SKIN", prefSkin);
            AddIntElement(preferenceXML, "USER-MODE", prefUserMode);
            AddIntElement(preferenceXML, "FORUM-STYLE", prefForumStyle);
            AddTextElement(preferenceXML, "SITESUFFIX", siteSuffix);

            AddTextElement(userForm, "SITEPREFERENCES", prefXML);

        }

        /// <summary>
        /// Updates the users details based on the current form submission. If
        ///		there is a problem such as the new password not being confirmed
        ///		correctly then will return true since the system itself has not
        ///		failed, but will set the sStatusMessage string to say what the
        ///		problem was so this can be relayed to the user.
        /// </summary>
        /// <param name="statusMessage">string describing the status of things after this
        ///			call, in particular any error messages.</param>
        ///	<param name="statusType">string describing the type of things after this
        ///			call, in particular any error messages.</param>
        /// <returns>true for success, false for failure. A mistake in the users input
        ///		will still return true but will set the sStatusMessage string to
        ///		indicate what was wrong.</returns>
        private bool UpdateUserDetails(ref string statusMessage, ref string statusType)
        {
            //reset error message
            statusMessage = String.Empty;
            statusType = String.Empty;

            InputContext.ViewingUser.BeginUpdateDetails();

            //get values from parameters
            /* Removed because not used in code but ported from C++
            string firstName = InputContext.GetParamStringOrEmpty("FirstNames", "Users first names");
            string lastName = InputContext.GetParamStringOrEmpty("LastName", "Users LastName");
            */

            string userName = InputContext.GetParamStringOrEmpty("UserName", "Users UserName");
            string prefSkin = InputContext.GetParamStringOrEmpty("PrefSkin", "Users PrefSkin");
            string siteSuffix = InputContext.GetParamStringOrEmpty("SiteSuffix", "Users SiteSuffix");
            string userPrefsXML = String.Empty;
            int numPrefs = InputContext.GetParamCountOrZero("p_name", "get number of p_name params");
            for (int i = 0; i < numPrefs; i++)
            {
                string paramName = InputContext.GetParamStringOrEmpty("p_name", i, "user parameter name").ToUpper();
                string paramValue = HttpUtility.HtmlEncode(InputContext.GetParamStringOrEmpty(paramName, "Get parameter value"));
                paramValue = paramValue.Replace("'", "&apos;");//remove ' chars
                userPrefsXML += string.Format("<{0} VALUE='{1}'>", paramName, paramValue);
            }

            ModerationStatus.NicknameStatus modStatus = (ModerationStatus.NicknameStatus) InputContext.GetSiteOptionValueInt("Moderation", "NicknameModerationStatus");

            // get the old username so we can check if they have changed it
            string oldUserName = InputContext.ViewingUser.UserName;
            if (userName == String.Empty)
                userName = oldUserName; //if not passed then default to existing name

            //add user dictionary to update
            if (prefSkin != InputContext.ViewingUser.PreferredSkin && prefSkin.IndexOf("purexml") < 0)
            {//don't set purexml as the default skin
                InputContext.ViewingUser.SetPreferredSkinInDB(prefSkin);
            }

            if (InputContext.DoesParamExist("PrefUserMode", "Users PrefUserMode"))
                InputContext.ViewingUser.SetUserData("PrefUserMode", InputContext.GetParamIntOrZero("PrefUserMode", "Users PrefUserMode"));

            if (InputContext.DoesParamExist("PrefForumStyle", "Users PrefForumStyle"))
                InputContext.ViewingUser.SetUserData("PrefForumStyle", InputContext.GetParamIntOrZero("PrefForumStyle", "Users PrefForumStyle"));

            if (userPrefsXML != String.Empty)
                InputContext.ViewingUser.SetUserData("PrefXML", userPrefsXML);

            // Set the users site suffix if supplied
            if (siteSuffix != String.Empty)
            {
                // Check to make sure the site suffix doesn't contain a profanity
                string matchingProfanity;
                ProfanityFilter.FilterState siteSuffixProfanity = ProfanityFilter.FilterState.Pass;
                siteSuffixProfanity = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, siteSuffix, out matchingProfanity);
                if (siteSuffixProfanity == ProfanityFilter.FilterState.FailBlock)
                {
                    statusMessage = "Site suffix failed profanity check.";
                    statusType = "sitesuffixfailprofanitycheck";
                    return false;
                }

                InputContext.ViewingUser.SetUserData("siteSuffix", siteSuffix);
            }

            if (InputContext.DoesParamExist("Region", "Region parameter"))
            {
                InputContext.ViewingUser.SetUserData("Region", InputContext.GetParamStringOrEmpty("Region", "Region parameter"));
            }

            // only do the update if none of the methods failed and if there is no error
            // message indicating problems with the users input
            if (statusMessage == String.Empty)
            {
                // finally make sure that the users details are updated in the database
                // TODO: if this can fail then we need to decide what to do if it does
                InputContext.ViewingUser.UpdateDetails();

                statusMessage = "Your details have been updated";
                statusType = "detailsupdated";
            }
            else
            {
                return false;
            }

            return true;
        }
    }
}
