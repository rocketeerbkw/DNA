using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using BBC.Dna.Data;

namespace Dna.DatabaseEmailProcessor
{
    public class DatabaseWorker : IDatabaseWorker
    {
        private IDnaDataReaderCreator ReaderCreator { get; set; }
        public static string PersistentErrorMessageSnippet { get; set; }

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
            foreach (var email in emails)
            {
                if (email.Sent)
                {
                    RemoveSentMailFromQueue(email.ID);
                }
                else
                {

                    var failureType = ConvertToSMTPFailureType(email.LastFailedReason);
                    switch (failureType)
                    {
                        case SMTPFailureType.Persistent:
                            UpdateEmailFailure(email, true);
                            break;
                        case SMTPFailureType.Permanent:
                        case SMTPFailureType.Unclassified:
                            UpdateEmailFailure(email, false);
                            break;
                    }
                }
            }
        }

        private enum SMTPFailureType
        {
            Persistent,
            Permanent,
            Unclassified
        }

        private static SMTPFailureType ConvertToSMTPFailureType(String failureReason)
        {
            var smtpFailureType = SMTPFailureType.Unclassified;

            //  SMTP Error Status Code
            //  4.YYY.ZZZ	Persistent Transient Failure
            //  5.YYY.ZZZ	Permanent Failure
            var match = Regex.Match(failureReason, @"(\s{1}4.[0-9].[0-9]{1,2}\s{1})", RegexOptions.IgnoreCase);
            if (match.Success || DoesFailureMessageContainSnippet(failureReason))
            {
                smtpFailureType = SMTPFailureType.Persistent;
            }
            else
            {
                match = Regex.Match(failureReason, @"(\s{1}5.[0-9].[0-9]{1,2}\s{1})", RegexOptions.IgnoreCase);
                if (match.Success)
                {
                    smtpFailureType = SMTPFailureType.Permanent;
                }
            }
            
            return smtpFailureType;
        }

        private static bool DoesFailureMessageContainSnippet(string failureReason)
        {
            var containSnippet = false;

            var errorSnippets = PersistentErrorMessageSnippet.Split("#".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);

            foreach (var errMsg in errorSnippets)
            {
                if (failureReason != null && failureReason.IndexOf(errMsg, StringComparison.OrdinalIgnoreCase) > 0)
                {
                    containSnippet = true;
                }
            }

            return containSnippet;
        }

        private void UpdateEmailFailure(EmailDetailsToProcess email, bool allowRetry)
        {
            using (var reader = ReaderCreator.CreateDnaDataReader("updatequeuedemail"))
            {
                reader.AddParameter("id", email.ID);
                reader.AddParameter("failuredetails", email.LastFailedReason);
                reader.AddParameter("retry", allowRetry ? 1 : 0);
                reader.Execute();
            }
        }

        private void RemoveSentMailFromQueue(int emailId)
        {
            using (var reader = ReaderCreator.CreateDnaDataReader("deletequeuedemail"))
            {
                reader.AddParameter("id", emailId);
                reader.Execute();
            }
        }

        #endregion
    }
}
