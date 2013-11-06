using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;

namespace DnaEventService.Common
{
    public interface IDnaSmtpClient
    {
        void SendMessage(MailMessage message);
        string Host { get; set; }
    }
}
