﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Mail;
using System.Threading;
using System.Timers;
using BBC.Dna.Data;
using DnaEventService.Common;

namespace Dna.DatabaseEmailProcessor
{
    public class DatabaseEmailProcessor : System.Timers.Timer
    {
        private static IDnaLogger ProcessorLogger { get; set; }
        private static DatabaseEmailProcessor ProcessorInstance { get; set; }
        private static IDnaDataReaderCreator DataReaderCreator { get; set; }
        private static int NumberOfThreads { get; set; }
        private static int BatchSize { get; set; }
        private static int TickCounter { get; set; }
        private static IDnaSmtpClient SMTPClient { get; set; }
        private static int MaxRetryAttempts { get; set; }
        static readonly object _locker = new object();

        public static DatabaseEmailProcessor CreateDatabaseEmailProcessor(IDnaLogger logger, IDnaDataReaderCreator dataReaderCreator, int processInterval, int numThreads, int batchSize, string emailServerConnectionDetails, int maxRetryAttempts)
        {
            ProcessorLogger = logger;

            if (ProcessorInstance != null)
            {
                // It's designed to have only one instance of BIEventProcessor running at a time
                // so turn the old one off and close it 
                ProcessorInstance.Stop();
                ProcessorInstance.Close();
            }

            DataReaderCreator = dataReaderCreator;
            NumberOfThreads = numThreads;
            BatchSize = batchSize;
            SMTPClient = new DnaSmtpClient(emailServerConnectionDetails);
            MaxRetryAttempts = maxRetryAttempts;

            int minNumThreads, minCompPorts;
            ThreadPool.GetMinThreads(out minNumThreads, out minCompPorts);

            if (minNumThreads < NumberOfThreads)
                ThreadPool.SetMinThreads(NumberOfThreads, NumberOfThreads);

            ProcessorInstance = new DatabaseEmailProcessor(processInterval);

            bool isDebugBuild = false;
#if DEBUG
            isDebugBuild = true;
#endif

            var props = new Dictionary<string, object>() 
            { 
                { "Database connection string",   DataReaderCreator != null ? DataReaderCreator.ConnectionString : "NULL" },
                { "Interval",                     processInterval },
                { "NumThreads",                   NumberOfThreads },
                { "BatchSize",                    BatchSize },
                { "MaxRetryAttempts",             MaxRetryAttempts },
                { "SMTP Settings",                emailServerConnectionDetails },
                { "Debug Build",                  isDebugBuild ? 1 : 0 }
            };
            logger.Log(TraceEventType.Information, "Created DatabaseEmailProcessor with these params", props);

            return ProcessorInstance;
        }

        DatabaseEmailProcessor(int interval)
        {
            Interval = interval;
            Enabled = false;
            Elapsed += new ElapsedEventHandler(DatabaseEmailProcessor_Tick);
        }

        public void WaitWhileHandlingEvent()
        {
            Monitor.TryEnter(_locker, Timeout.Infinite);
            Monitor.Exit(_locker);
        }

        public new void Start()
        {
            ProcessorLogger.Log(TraceEventType.Information, "Starting Database Email Processor");
            base.Start();
        }

        void DatabaseEmailProcessor_Tick(object sender, ElapsedEventArgs e)
        {
            if (Monitor.TryEnter(_locker))
            {
                DateTime tickStart = DateTime.Now;

                TickCounter += 1;
                ProcessorLogger.Log(TraceEventType.Verbose, "============== Tick start: " + TickCounter);

                DatabaseWorker worker = null;
                List<EmailDetailsToProcess> emailBatch = null;
                
                try
                {
                    worker = new DatabaseWorker(DataReaderCreator);
                    emailBatch = worker.GetEmailDetailsBatch(BatchSize, MaxRetryAttempts);

                    if (emailBatch.Count > 0)
                    {
                        ProcessEmailBatch(emailBatch, NumberOfThreads);
                    }
                }
                catch (Exception ex)
                {
                    ProcessorLogger.LogException(ex);
                }
                finally
                {
                    try
                    {
                        worker.UpdateEmails(emailBatch);
                    }
                    catch (Exception ex)
                    {
                        ProcessorLogger.LogException(ex);
                    }

                    TimeSpan tickTime = DateTime.Now - tickStart;

                    ProcessorLogger.Log(TraceEventType.Verbose, "^^^^^^^^^^^^^^ Tick end: " + TickCounter + " (" + tickTime.TotalSeconds + "s)");
                    Monitor.Exit(_locker);
                }
            }
         }

        private List<EmailDetailsToProcess> GetProcessedEmailsList(List<EmailDetailsToProcess> emailBatch)
        {
            var processedEvents = new List<EmailDetailsToProcess>();

            foreach (var email in emailBatch.Where(x => x.Sent))
                processedEvents.Add(email);

            return processedEvents;
        }

        public void ProcessEmailBatch(List<EmailDetailsToProcess> emailsToProcess, int numThreads)
        {
            ProcessorLogger.Log(TraceEventType.Verbose, "Starting ProcessEmailBatch");
            DateTime startTime = DateTime.Now;

            EmailProcessorQueue emailProcessorQueue = new EmailProcessorQueue();

            foreach (var email in emailsToProcess)
                emailProcessorQueue.Enqueue(email);

            Action<EmailProcessorQueue>[] workers = new Action<EmailProcessorQueue>[numThreads];
            IAsyncResult[] workerResults = new IAsyncResult[numThreads];

            if (emailsToProcess.Count < numThreads)
                numThreads = emailsToProcess.Count;

            for (int i = 0; i < numThreads; i++)
            {
                workers[i] = evQ =>
                {
                    var ev = evQ.Dequeue();
                    while (ev != null)
                    {
                        ProcessorLogger.LogEmailProcessEvent("Processing Email", ev);
                        ev.ProcessEmail(SMTPClient, ProcessorLogger);
                        ev = evQ.Dequeue();
                    }
                };
                workerResults[i] = workers[i].BeginInvoke(emailProcessorQueue, null, null);
            }

            for (int i = 0; i < numThreads; i++)
                workers[i].EndInvoke(workerResults[i]);

            ProcessorLogger.Log(TraceEventType.Information, "Finished ProcessEmailBatch", startTime, "Threads Used", numThreads, "Emails Processed", emailsToProcess.Count());
        }
    }
}
