using System;
using System.Net;
using System.Net.Mail;

namespace DnaEventService.Common
{
    public class DnaSmtpClient : IDnaSmtpClient
    {
        private readonly SmtpClient client;

        public DnaSmtpClient(string hostname, string userName, string password, bool enableSsl)
        {
            client = new SmtpClient(hostname)
            {
                EnableSsl = enableSsl
            };

            if (!string.IsNullOrEmpty(userName))
            {
                client.Credentials = new NetworkCredential(userName, password);
            }
        }

        #region IDnaSmtpClient Members

        public void SendMessage(MailMessage message)
        {
            client.Send(message);
        }

        public string Host
        {
            get { return client.Host; }
            set { client.Host = value; }
        }

        #endregion
    }
}
