using System;
using System.Net.Mail;
using System.Text;
using DnaEventService.Common;

namespace Dna.DatabaseEmailProcessor
{
    public class EmailDetailsToProcess
    {
        public int ID { get; set; }
        public string FromAddress { get; set; }
        public string ToAddress { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public string LastFailedReason { get; private set; }
        public bool Sent { get; private set; }

        public void ProcessEmail(IDnaSmtpClient client, IDnaLogger logger)
        {
            try
            {
                using (var message = new MailMessage())
                {
                    message.From = new MailAddress(FromAddress);
                    message.To.Add(ToAddress);

                    message.Subject = Subject;
                    message.SubjectEncoding = Encoding.UTF8;

                    message.Body = Body;
                    message.BodyEncoding = Encoding.UTF8;

                    message.Priority = MailPriority.Normal;

                    client.SendMessage(message);
                    Sent = true;
                }
            }
            catch (Exception e)
            {
                var errorMsg = e.Message;
                if (e.InnerException != null)
                {
                    errorMsg += " : " + e.InnerException.Message;
                }

                logger.Log(System.Diagnostics.TraceEventType.Verbose, errorMsg);
                LastFailedReason = errorMsg;
                Sent = false;
            }
        }
    }
}
