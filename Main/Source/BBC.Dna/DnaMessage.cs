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
        string _sender;
        string _recipient;
        string _ccAddress;
        string _subject;
        string _body;

        /// <summary>
        /// Constructor 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="recipient"></param>
        /// <param name="ccAddress"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="errorMessage"></param>
        public DnaEmailException(string sender,
                                  string recipient,
                                  string ccAddress,
                                  string subject,
                                  string body,
                                  string errorMessage)
            : base(errorMessage)
        {
            _recipient = recipient;
            _sender = sender;
            _body = body;
            _subject = subject;
            _ccAddress = ccAddress;
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

        /// <summary>
        /// The Carbon Copy 
        /// </summary>
        public string CCAddress
        {
            get { return _ccAddress; }
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
        /// <param name="ccAddress"></param>
        /// <param name="siteId"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <exception>DnaEmailException</exception>
        public void SendEmailOrSystemMessage(int recipientId, string recipient, string sender, string ccAddress, int siteId, string subject, string body)
        {
            if (InputContext.TheSiteList.GetSiteOptionValueBool(siteId, "General", "UseSystemMessages") && recipientId > 0)
            {
                SendSystemMessage(recipientId, siteId, body);
            }
            else if (recipient != String.Empty)
            {
                SendEmail(subject, body, sender, recipient, ccAddress, siteId);
            }
        }

        /// <summary>
        /// Email queued in the database
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="sender"></param>
        /// <param name="recipient"></param>
        /// <param name="ccAddress"></param>
        /// <param name="siteId"></param>
        private void SendEmailViaDatabase(string subject, string body, string sender, string recipient, string ccAddress, int siteId)
        {
            DatabaseEmailQueue emailQueue = new DatabaseEmailQueue(); 
            IDnaDataReaderCreator creator = InputContext.CreateDnaDataReaderCreator();

            emailQueue.QueueEmail(creator, recipient, sender, ccAddress, subject, body, string.Empty, DatabaseEmailQueue.EmailPriority.Medium);
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
        /// <param name="ccAddress"></param>
        /// <param name="siteId"></param>
        /// <exception cref="DnaEmailException">If there is an error sending email.</exception>
        public void SendEmail(string subject, string body, string sender, string recipient, string ccAddress, int siteId)
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

                if (ccAddress != null && ccAddress.Length > 0)
                {
                    message.CC.Add(new System.Net.Mail.MailAddress(ccAddress));
                }
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
                // Send the email to the database so we can try later. This is more secure than storing it locally to the server.
                SendEmailViaDatabase(subject, body, sender, recipient, ccAddress, siteId);
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
