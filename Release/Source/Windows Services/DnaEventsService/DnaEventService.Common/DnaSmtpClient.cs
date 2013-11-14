using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;

namespace DnaEventService.Common
{
    public class DnaSmtpClient : IDnaSmtpClient
    {
        private SmtpClient client = new SmtpClient();

        public DnaSmtpClient(string hostDetails)
        {
            client.Host = hostDetails;
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
