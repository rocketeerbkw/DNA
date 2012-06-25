using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;
using System.Net.Mail;

namespace BBC.Dna.Api
{
    public partial class Contacts : Context
    {
        public Contacts(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
            : base(dnaDiagnostics, dataReaderCreator, cacheManager, siteList)
        {
        }

        public void SendDetailstoContactEmail(CommentInfo commentInfo, string recipient)
        {
            string sender = SiteList.GetSite("h2g2").EditorsEmail;
            string subject = commentInfo.ForumUri;
            string body = commentInfo.text;

            try
            {
                MailMessage message = new MailMessage();
                message.From = new MailAddress(sender);

                foreach (string toAddress in recipient.Split(';'))
                    message.To.Add(new MailAddress(toAddress));

                message.Subject = subject;
                message.Body = body;

                SmtpClient client = new SmtpClient();
                client.SendAsync(message, new SendCompletedEventHandler(client_SendCompleted));
            }
            catch (Exception e)
            {
                DnaDiagnostics.WriteExceptionToLog(e);
            }
        }

        private void client_SendCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            if (e.Error != null || e.Cancelled)
            {
                throw new ApiException("Failed");
                //    string failedFrom = "From: " + sender + "\r\n";
                //    string failedRecipient = "Recipient: " + recipient + "\r\n";
                //    string failedEmail = failedFrom + failedRecipient + subject + "\r\n" + body;

                //    //Create filename out of date and random number.
                //    string fileName = "M" + DateTime.Now.ToString("yyyyMMddhmmssffff");
                //    Random random = new Random(body.Length);
                //    fileName += "-" + random.Next().ToString() + ".txt";

                //    //Failed to Send - write to Failed Emails Folder.
                //    //Probably shouldn't be using a cache function for non-cache activity.
                //    FileCache.PutItem(Dna.Utils. "failedmails", fileName, failedEmail);

                //    //Removed as a failed email shouldn't kill the page response
                //    //throw new DnaEmailException(sender, recipient, subject, body, errorMessage);
            }
        }
    }
}
