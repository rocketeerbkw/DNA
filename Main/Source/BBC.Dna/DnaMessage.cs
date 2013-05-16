using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Exception for failure to send email.
    /// </summary>
    public class DnaEmailException : DnaException
    {
        string _recipient;
        string _subject;
        string _sender;
        string _body;

        /// <summary>
        /// Constructor 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="recipient"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="errorMessage"></param>
        public DnaEmailException(string sender,
                                  string recipient,
                                  string subject,
                                  string body,
                                  string errorMessage)
            : base(errorMessage)
        {
            _recipient = recipient;
            _sender = sender;
            _body = body;
            _subject = subject;
        }

        /// <summary>
        /// Return to address
        /// </summary>
        public string Recipient
        {
            get { return _recipient; }
        }

        /// <summary>
        /// Return Sender
        /// </summary>
        public string Sender
        {
            get { return _sender; }
        }

        /// <summary>
        /// Return Email Body
        /// </summary>
        public string Body
        {
            get { return _body; }
        }

        /// <summary>
        /// Return Email Subject
        /// </summary>
        public string Subject
        {
            get { return _subject; }
        }

    }

    /// <summary>
    /// Class for Sending Emails and System Messages.
    /// </summary>
    public class DnaMessage : DnaInputComponent
    {
        //private int LINE_LENGTH = 72;

        /// <summary>
        /// 
        /// </summary>
        public DnaMessage(IInputContext context)
            : base(context)
        { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="recipientId"></param>
        /// <param name="recipient"></param>
        /// <param name="sender"></param>
        /// <param name="siteId"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <exception>DnaEmailException</exception>
        public void SendEmailOrSystemMessage(int recipientId, string recipient, string sender, int siteId, string subject, string body)
        {
            if (InputContext.TheSiteList.GetSiteOptionValueBool(siteId, "General", "UseSystemMessages") && recipientId > 0)
            {
                SendSystemMessage(recipientId, siteId, body);
            }
            else if (recipient != String.Empty)
            {
                SendEmail(subject, body, sender, recipient, siteId);
            }
        }

        /// <summary>
        /// Email queued in the database
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="sender"></param>
        /// <param name="recipient"></param>
        /// <param name="siteId"></param>
        private void SendEmail(string subject, string body, string sender, string recipient, int siteId)
        {
            DatabaseEmailQueue emailQueue = new DatabaseEmailQueue(); 
            IDnaDataReaderCreator creator = new DnaDataReaderCreator(AppContext.TheAppContext.Config.ConnectionString, AppContext.TheAppContext.Diagnostics);
            
            emailQueue.QueueEmail(creator, recipient, sender, subject, body, string.Empty, DatabaseEmailQueue.EmailPriority.Medium);
        }

        /// <summary>
        /// Sends Email.
        /// Uses smtp server configuration from Web.Config.
        /// This will be deprecated soon
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="sender"></param>
        /// <param name="recipient"></param>
        /// <param name="siteId"></param>
        /// <param name="tmp"></param>
        /// <exception cref="DnaEmailException">If there is an error sending email.</exception>
        public void SendEmail(string subject, string body, string sender, string recipient, int siteId, bool tmp)
        {
            string errorMessage = string.Empty;
            bool bEmailFailed = false;

            var isRtlSite = InputContext.TheSiteList.GetSiteOptionValueBool(siteId, "General", "RTLSite");
            if (isRtlSite)
            {
                body = "<html dir='rtl'><body>" + body.Replace("\n\r", "<br/>").Replace("\n", "<br/>") + "</body></html>";
                //subject = "<html dir='rtl'>" + subject + "</html>";
            }

            try
            {
                System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                message.From = new System.Net.Mail.MailAddress(sender);

                foreach (string r in recipient.Split(';'))
                    message.To.Add(new System.Net.Mail.MailAddress(r));

                message.CC.Add(new System.Net.Mail.MailAddress(sender));
                message.Subject = subject;
                message.Body = AddLineBreaks(body);
                if (isRtlSite)
                {
                    message.IsBodyHtml = true;
                    message.BodyEncoding = System.Text.Encoding.UTF8;
                }

                System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
                client.Send(message);
            }

            catch (Exception e)
            {
                errorMessage = e.Message;

                bEmailFailed = true;
                InputContext.Diagnostics.WriteExceptionToLog(e);
            }

            if (bEmailFailed)
            {
                string failedFrom = "From: " + sender + "\r\n";
                string failedRecipient = "Recipient: " + recipient + "\r\n";
                string failedEmail = failedFrom + failedRecipient + subject + "\r\n" + AddLineBreaks(body);

                //Create filename out of date and random number.
                string fileName = "M" + DateTime.Now.ToString("yyyyMMddhmmssffff");
                Random random = new Random(body.Length);
                fileName += "-" + random.Next().ToString() + ".txt";

                //Failed to Send - write to Failed Emails Folder.
                //Probably shouldn't be using a cache function for non-cache activity.
                FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "failedmails", fileName, failedEmail);

                //Removed as a failed email shouldn't kill the page response
                //throw new DnaEmailException(sender, recipient, subject, body, errorMessage);
            }
        }

        /// <summary>
        /// Sends a System Message.
        /// </summary>
        public void SendSystemMessage(int userId, int siteId, string body)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("senddnasystemmessage"))
            {
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("messagebody", body);
                dataReader.Execute();
            }
        }

        /// <summary>
        /// Method to add line breaks to email body.
        /// </summary>
        /// <param name="body"></param>
        private string AddLineBreaks(string body)
        {
            return body;

            /*System.Text.RegularExpressions.Regex regex = new System.Text.RegularExpressions.Regex( @"(?<Line>.{1,72})(?:\W)",
                           System.Text.RegularExpressions.RegexOptions.IgnoreCase
                           | System.Text.RegularExpressions.RegexOptions.Multiline
                           | System.Text.RegularExpressions.RegexOptions.ExplicitCapture
                           | System.Text.RegularExpressions.RegexOptions.CultureInvariant
                           | System.Text.RegularExpressions.RegexOptions.Compiled);

            string newBody = string.Empty;
            string[] lines = regex.Split(body);
            foreach (string line in lines)
            {
                newBody += line + "\r\n";
            }

            return body;*/
        }
    }
}
