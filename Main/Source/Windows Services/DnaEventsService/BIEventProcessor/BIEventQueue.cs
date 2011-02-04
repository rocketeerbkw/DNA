using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Dna.BIEventSystem
{
    public class BIEventQueue
    {
        private Queue<BIEvent> queue = new Queue<BIEvent>();
        private object _locker = new object();

        public void Enqueue(BIEvent ev)
        {
            lock (_locker)
            {
                queue.Enqueue(ev);
            }
        }

        public BIEvent Dequeue()
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
