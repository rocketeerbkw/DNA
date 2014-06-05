using System.Collections.Generic;

namespace Dna.DatabaseEmailProcessor
{
    public interface IDatabaseWorker
    {
        List<EmailDetailsToProcess> GetEmailDetailsBatch(int batchSize);
        void UpdateEmails(List<EmailDetailsToProcess> emails);
    }
}
