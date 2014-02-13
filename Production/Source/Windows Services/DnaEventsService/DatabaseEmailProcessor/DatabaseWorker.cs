using System.Collections.Generic;
using BBC.Dna.Data;

namespace Dna.DatabaseEmailProcessor
{
    public class DatabaseWorker : IDatabaseWorker
    {
        private IDnaDataReaderCreator ReaderCreator { get; set; }

        public DatabaseWorker(IDnaDataReaderCreator readerCreator)
        {
            ReaderCreator = readerCreator;
        }

        #region IDatabaseWorker Members

        public List<EmailDetailsToProcess> GetEmailDetailsBatch(int batchSize, int maxRetryAttempts)
        {
            List<EmailDetailsToProcess> emailBatch = new List<EmailDetailsToProcess>();
            using (IDnaDataReader reader = ReaderCreator.CreateDnaDataReader("getemailbatchtosend"))
            {
                reader.AddParameter("batchsize", batchSize);
                reader.AddParameter("maxretryattempts", maxRetryAttempts);
                reader.Execute();
                while (reader.Read() && reader.HasRows)
                {
                    emailBatch.Add(CreateProcessorForEmail(reader));
                }
            }
            return emailBatch;
        }

        private EmailDetailsToProcess CreateProcessorForEmail(IDnaDataReader reader)
        {
            EmailDetailsToProcess emailToProcess = new EmailDetailsToProcess();

            emailToProcess.ID = reader.GetInt32("ID");
            emailToProcess.Subject = reader.GetString("Subject");
            emailToProcess.Body = reader.GetString("Body");
            emailToProcess.FromAddress = reader.GetString("FromEmailAddress");
            emailToProcess.ToAddress = reader.GetString("ToEmailAddress");

            return emailToProcess;
        }

        public void UpdateEmails(List<EmailDetailsToProcess> emails)
        {
            foreach(EmailDetailsToProcess email in emails)
            {
                using (IDnaDataReader reader = ReaderCreator.CreateDnaDataReader("updatequeuedemail"))
                {
                    reader.AddParameter("id", email.ID);
                    reader.AddParameter("sent", email.Sent ? 1 : 0);
                    reader.AddParameter("failuredetails", email.LastFailedReason);
                    reader.Execute();
                }
            }
        }

        #endregion
    }
}
