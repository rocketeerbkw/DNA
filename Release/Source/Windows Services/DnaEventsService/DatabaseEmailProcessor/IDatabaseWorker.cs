using System.Collections.Generic;

namespace Dna.DatabaseEmailProcessor
{
    public interface IDatabaseWorker
    {
        List<EmailDetailsToProcess> GetEmailDetailsBatch(int batchSize, int maxRetryAttempts);
        void UpdateEmails(List<EmailDetailsToProcess> emails);
    }
}
