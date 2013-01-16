using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Api
{
    public class FailedEmail
    {
        public FailedEmail(string from, string to, string subject, string body, string fileprefix)
        {
            From = from;
            To = to;
            Subject = subject;
            Body = body;
            FilePreFix = fileprefix;
        }

        public string From { get; set; }
        public string To { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public string FilePreFix { get; set; }
    }
}
