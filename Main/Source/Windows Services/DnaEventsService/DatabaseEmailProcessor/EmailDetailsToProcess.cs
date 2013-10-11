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

        public void ProcessEmail(SmtpClient client, IDnaLogger logger)
        {
            try
            {
                using (MailMessage message = new MailMessage())
                {
                    message.From = new MailAddress(FromAddress);
                    message.To.Add(ToAddress);

                    message.Subject = Subject;
                    message.SubjectEncoding = Encoding.UTF8;

                    message.Body = Body;
                    message.BodyEncoding = Encoding.UTF8;

                    message.Priority = MailPriority.Normal;

                    client.Send(message);
                    Sent = true;
                }
            }
            catch (Exception e)
            {
                logger.Log(System.Diagnostics.TraceEventType.Verbose, e.Message + " : " + e.InnerException.Source);
                LastFailedReason = e.Message;
                Sent = false;
            }
        }
    }
}
