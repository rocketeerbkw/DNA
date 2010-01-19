using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Functionality for the Moderation of NickNames.
    /// </summary>
    public class ModerateNickNames : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerateNickNames (IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// ModerateNickName - Handles the moderation of a nickname.
        /// </summary>
        /// <param name="modId">Mod Id of the Moderation item.</param>
        /// <param name="siteId">SiteId of moderation item.</param>
        /// <param name="userId">UserId of user being moderated.</param>
        /// <param name="userName">UserName of user being moderated.</param>
        /// <param name="status">Moderation Descision.</param>
        /// <exception cref="DnaException">if there is an error sending email.</exception>
        public void ModerateNickName(int modId, int siteId, int userId, string userName, int status)
        {
            try
            {
                string email;
                Update(modId, status, out email);
                if (status == 4)
                {
                    SendEmail(userId, siteId, userName, email);
                }
            }
            catch (DnaException e)
            {
                throw e;
            }
        
        }

        /// <summary>
        /// Adds nickname to the queue for moderation
        /// </summary>
        /// <param name="userName">The new user name</param>
        /// <param name="userId">Thes users id</param>
        /// <param name="siteId">The site id</param>
        /// <param name="modId">The outputted moderation id</param>
        public void QueueNicknameForModeration(string userName, int userId, int siteId, out int modId)
        {
            modId = 0;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("queuenicknameformoderation"))
            {
                dataReader.AddParameter("@userid", userId);
                dataReader.AddParameter("@siteid", siteId);
                dataReader.AddParameter("@nickname", userName);
                dataReader.Execute();
                if (dataReader.Read())
                {
                    modId = dataReader.GetInt32NullAsZero("modid");
                }
            }
        }

        /// <summary>
        /// Forces resetting of a nickname.
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="userId"></param>
        /// <param name="siteId"></param>
        /// <exception cref="DnaException">Error occurred moderating nickname</exception>
        public void ResetNickName(string userName, int userId, int siteId )
        {
            int modId = 0;
            QueueNicknameForModeration(userName, userId, siteId, out modId);

            try
            {
                //Fail NickName forcing it to be reset.
                ModerateNickName(modId, siteId, userId, userName, 4);
            }
            catch (DnaException e)
            {
                throw e;
            }
        }

        /// <summary>
        /// Method for Updating NickName Moderation Item with the given decision.
        /// To standardise processing of nicknames not publicly available.
        /// 
        /// </summary>
        /// <param name="modId">ModId.</param>
        /// <param name="status">Moderation decision pass, fail.</param>
        /// <param name="email">Returns user email address.</param>
        private void Update(int modId,  int status, out string email )
        {
            email = string.Empty;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("ModerateNickname"))
            {
                dataReader.AddParameter("modid", modId);
                dataReader.AddParameter("status", status);
                dataReader.Execute();
                if (dataReader.Read())
                {
                    email = dataReader.GetStringNullAsEmpty("emailaddress");
                }
            }
        }

        /// <summary>
        /// Sends Email to the given recipient. eg If a nickname is failed the user concerned will be sent a 
        /// notification email.
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="siteId"></param>
        /// <param name="oldNickName"></param>
        /// <param name="userEmail"></param>
        /// <exception cref="DnaException">If there is an error sending email.</exception>
        private void SendEmail(int userId, int siteId, string oldNickName, string userEmail )
        {

            // do any necessary substitutions
            string emailSubject;
            string emailBody;
            EmailTemplate emailTemplate = new EmailTemplate(InputContext);
            emailTemplate.FetchEmailText(siteId, "NicknameResetEmail", out emailSubject, out emailBody);
            emailSubject = emailSubject.Replace("++**nickname**++", oldNickName);
            emailBody = emailBody.Replace("++**nickname**++", oldNickName);
            emailSubject = emailSubject.Replace("++**userid**++", userId.ToString());
            emailBody = emailBody.Replace("++**userid**++", userId.ToString());

            string moderatorEmail = InputContext.TheSiteList.GetSite(siteId).GetEmail(Site.EmailType.Moderators);

            try
            {
                //Actually send the email.
                DnaMessage sendMessage = new DnaMessage(InputContext);
                sendMessage.SendEmailOrSystemMessage(userId, userEmail, moderatorEmail, siteId, emailSubject, emailBody);
            }
            catch (DnaEmailException e)
            {
                //Uable to usefully handle the error here so rethrow.
                string error = "Unable to send Email. Sender:" + e.Sender + " Recipient: " + e.Recipient + "." + e.Message;
                throw new DnaException(error);
            }
        }
    }
}
