using System;
using System.Diagnostics;
using System.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeExperiments
{
    [TestClass]
    public class ThreadingAndNonThreadedTesting
    {
        [TestMethod]
        public void CompareThreadedAndNonThreaded()
        {
            TestThreading test = new TestThreading();

            // Simulate the time taken to process an item in milliseconds
            int simulatedProcessTimeForItem = 50;

            // Do the first run with threading
            DateTime start = DateTime.Now;
            test.SetUpAndProcess(true, simulatedProcessTimeForItem);
            double threadedTime = TimeSpan.FromTicks(DateTime.Now.Ticks - start.Ticks).TotalMilliseconds;

            // Now repeat, but not using threading
            start = DateTime.Now;
            test.SetUpAndProcess(false, simulatedProcessTimeForItem);
            double nonThreadedTime = TimeSpan.FromTicks(DateTime.Now.Ticks - start.Ticks).TotalMilliseconds;

            Trace.WriteLine("Threaded Total time = " + threadedTime + ", Non Threaded Total time = " + nonThreadedTime);
        }
    }

    public class ItemToProcess
    {
        public int startValue = 0;
        public int processedValue = 0;
        public bool hasProcessed = false;
        public int processingTime = 50;
    }

    public class TestThreading
    {
        public void SetUpAndProcess(bool threading, int simulatedProcessTimeForItem)
        {
            int totalItems = 100;
            ItemToProcess[] startvalues = new ItemToProcess[totalItems];

            for (int i = 0; i < totalItems; i++)
            {
                startvalues[i] = new ItemToProcess();
                startvalues[i].startValue = i;
                startvalues[i].processingTime = simulatedProcessTimeForItem;
            }

            if (threading)
            {
                ProcessItemsThreaded(startvalues);
            }
            else
            {
                ProcessItemsNonThreaded(startvalues);
            }

            // It's vital we wait for all the child threads to finish before we continue this thread.
            // The main thead could close before it's children.
            WaitForProcessingToFinish(totalItems, startvalues);

            Trace.WriteLine("All Done!");
        }

        private static void WaitForProcessingToFinish(int totalItems, ItemToProcess[] startvalues)
        {
            bool allDone = false;
            while (!allDone)
            {
                allDone = true;
                for (int j = 0; j < totalItems; j++)
                {
                    if (!startvalues[j].hasProcessed)
                    {
                        allDone = false;
                        break;
                    }
                }
            }
        }

        private void ProcessItemsThreaded(ItemToProcess[] items)
        {
            int maxThreads, minThreads, completionPortThreads, completionPortThreads2;
            ThreadPool.GetMaxThreads(out maxThreads, out completionPortThreads);
            ThreadPool.GetMinThreads(out minThreads, out completionPortThreads2);
            Trace.WriteLine("maxThreads = " + maxThreads + ", minThreads = " + minThreads + "compThreads = " + completionPortThreads + ", " + completionPortThreads2);
            ThreadPool.SetMinThreads(100, completionPortThreads2);

            for (int i = 0; i < items.Length; i++)
            {
                ThreadPool.QueueUserWorkItem(new WaitCallback(callbackMethod), new SimpleTaskThread(items[i]));
            }
        }

        private void ProcessItemsNonThreaded(ItemToProcess[] items)
        {
            for (int i = 0; i < items.Length; i++)
            {
                SimpleTaskThread simple = new SimpleTaskThread(items[i]);
                simple.DoSomehing();
            }
        }

        public void callbackMethod(Object obState)
        {
            SimpleTaskThread task = (SimpleTaskThread)obState;
            task.DoSomehing();
            Trace.WriteLine("Item " + task.id + " Done!");
        }
    }

    // Worker class to do all the action on the give item object
    public class SimpleTaskThread
    {
        private ItemToProcess item;
        public int id = 0;

        public SimpleTaskThread(ItemToProcess item)
        {
            this.item = item;
            id = item.startValue;
        }

        public void DoSomehing()
        {
            // Show what thread we're running this on.
            Trace.WriteLine("Starting item " + id + " with Thread ID : " + Thread.CurrentThread.ManagedThreadId);

            item.processedValue = item.startValue * item.startValue;
            Trace.WriteLine("Calculated value  = " + item.processedValue);
            
            // Simulate long running process. Even a 50ms delay means the Threaded version is about twice as fast overall!
            Thread.Sleep(item.processingTime);
            
            // Flag that everything is finished
            item.hasProcessed = true;
        }
    }
}
