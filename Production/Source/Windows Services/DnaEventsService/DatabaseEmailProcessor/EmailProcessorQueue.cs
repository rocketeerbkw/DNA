using System.Collections.Generic;
using System.Linq;

namespace Dna.DatabaseEmailProcessor
{
    public class EmailProcessorQueue
    {
        private Queue<EmailDetailsToProcess> queue = new Queue<EmailDetailsToProcess>();
        private object _locker = new object();

        public void Enqueue(EmailDetailsToProcess ev)
        {
            lock (_locker)
            {
                queue.Enqueue(ev);
            }
        }

        public EmailDetailsToProcess Dequeue()
        {
            lock (_locker)
            {
                if (!IsEmpty())
                    return queue.Dequeue();
                else
                    return null;
            }
        }

        public bool IsEmpty()
        {
            return Count() <= 0;
        }

        public int Count()
        {
            lock (_locker)
            {
                return queue.Count();
            }
        }
    }
}
