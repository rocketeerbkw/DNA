using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Data
{
    public class DatabaseEmailQueue
    {
        public enum EmailPriority
        {
            Low = 0,
            Medium,
            High,
            Urgent
        }

        public void QueueEmail(IDnaDataReaderCreator readerCreator, string toEmailAddress, string fromEmailAddress, string ccAddress, string subject, string body, string notes, EmailPriority priority)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("QueueEmail"))
            {
                reader.AddParameter("toEmailAddress", toEmailAddress);
                reader.AddParameter("fromEmailAddress", fromEmailAddress);
                reader.AddParameter("ccAddress", ccAddress == null ? "" : ccAddress);
                reader.AddParameter("subject", subject);
                reader.AddParameter("body", body);
                reader.AddParameter("priority", priority);
                reader.AddParameter("notes", notes);
                reader.Execute();
            }
        }
    }
}
