using System;
using System.Security.Cryptography.X509Certificates;
using System.ServiceProcess;
using System.Threading;
using BBC.Dna.Data;
using BBC.Dna.Net.Security;
using Dna.BIEventSystem;
using Dna.DatabaseEmailProcessor;
using Dna.ExModerationProcessor;
using Dna.SiteEventProcessor;
using Dna.SnesIntegration.ActivityProcessor;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace DnaEventProcessorService
{
    public partial class DnaEventProcessorServiceHost : ServiceBase
    {
        private SnesActivityProcessor snesActivityProcessor;
        private ExModerationProcessor exModerationProcessor;
        private Dna.SiteEventProcessor.SiteEventsProcessor siteEventProcessor;
        private Timer activityTimer, exModerationTimer, siteEventTimer;
        private int timerPeriod;
        private string guideConnectionString;
        private string certificateName;
        
        public DnaEventProcessorServiceHost()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            if (Properties.Settings.Default.DebugOn)
            {
                #if DEBUG
                System.Diagnostics.Debugger.Break();
                #endif
            }

            if (Properties.Settings.Default.SiteEventsOn)
                CreateSiteEventTimer();

            if (Properties.Settings.Default.SnesOn)
                CreateSnesActivityTimer();

            if (Properties.Settings.Default.ExModOn)
                CreateExModerationEventTimer();

            if (Properties.Settings.Default.BIEventsOn)
                CreateBIEventProcessor(new DnaLogger());

            if (Properties.Settings.Default.DatabaseEmailsOn)
                CreateDatabaseEmailProcessor(new DnaLogger());
        }

        private void CreateDatabaseEmailProcessor(IDnaLogger logger)
        {
            DnaDataReaderCreator theGuideDnaDataReaderCreator = new DnaDataReaderCreator(Properties.Settings.Default.ConnectionString_TheGuide);
            int interval = Properties.Settings.Default.DatabaseEmailProcessor_Interval;
            int numThreads = Properties.Settings.Default.DatabaseEmaiProcessor_NumThreads;
            int batchSize = Properties.Settings.Default.DatabaseEmaiProcessor_BatchSize;
            string smtpSettings = Properties.Settings.Default.DatabaseEmailProcessor_SMTPSettings;
            int maxRetryAttempts = Properties.Settings.Default.DatabaseEmailProcessor_MaxRetryAttempts;

            var databaseEMailProcessor = DatabaseEmailProcessor.CreateDatabaseEmailProcessor(logger, theGuideDnaDataReaderCreator, interval, numThreads, batchSize, smtpSettings, maxRetryAttempts);
            databaseEMailProcessor.Start();
        }

        private void CreateBIEventProcessor(IDnaLogger logger)
        {
            DnaDataReaderCreator theGuideDnaDataReaderCreator = new DnaDataReaderCreator(Properties.Settings.Default.ConnectionString_TheGuide);
            DnaDataReaderCreator RiskDnaDataReaderCreator = new DnaDataReaderCreator(Properties.Settings.Default.ConnectionString_RiskMod);
            int interval = Properties.Settings.Default.BIEventsProcessor_Interval;
            bool disableRiskMod = Properties.Settings.Default.BIEventsProcessor_DisableRiskMod;
            bool recordRiskModDecisionsOnPost = Properties.Settings.Default.BIEventsProcessor_RecordRiskModDecisionsOnPost;
            int numThreads = Properties.Settings.Default.BIEventsProcessor_NumThreads;

            var biEventProc = BIEventProcessor.CreateBIEventProcessor(logger, theGuideDnaDataReaderCreator, RiskDnaDataReaderCreator, interval, disableRiskMod, recordRiskModDecisionsOnPost, numThreads);
            biEventProc.Start();
        }

        private void CreateSnesActivityTimer()
        {
            Uri snesBaseUri = new Uri(Properties.Settings.Default.snesBaseUri);
            Uri proxyAddress = new Uri(Properties.Settings.Default.proxyAddress);
            X509Certificate cert = X509CertificateLoader.FindCertificate(GetCertificateName("SnesActivityProcessor"));
            guideConnectionString = Properties.Settings.Default.ConnectionString_TheGuide;

            snesActivityProcessor = PolicyInjection.Create<SnesActivityProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger(),
                new DnaHttpClientCreator(snesBaseUri, proxyAddress, cert));

            timerPeriod = Properties.Settings.Default.SnesActivityProcessor_Interval;
            activityTimer = new Timer(snesActivityProcessor.ProcessEvents, null, 0, timerPeriod);
        }

        private void CreateExModerationEventTimer()
        {
            Uri proxyAddress = new Uri(Properties.Settings.Default.proxyAddress);
            X509Certificate cert = X509CertificateLoader.FindCertificate(GetCertificateName("ExModerationProcessor"));

            guideConnectionString = Properties.Settings.Default.ConnectionString_TheGuide;

            exModerationProcessor = PolicyInjection.Create<ExModerationProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger(),
                new DnaHttpClientCreator(null, proxyAddress, cert));

            timerPeriod = Properties.Settings.Default.SnesActivityProcessor_Interval;
            exModerationTimer = new Timer(exModerationProcessor.ProcessEvents, null, 0, timerPeriod);
        }

        protected string GetCertificateName(string type)
        {
            certificateName = string.Empty;
            string settingName = type + "_certificateName";
            if (Properties.Settings.Default.PropertyValues[settingName] != null)
            {
                certificateName = Properties.Settings.Default.PropertyValues[settingName].PropertyValue.ToString();
            }
            else
            {
                throw new Exception("Missing app.config setting " + settingName);
            }
            return certificateName;
        }

        private void CreateSiteEventTimer()
        {
            guideConnectionString = Properties.Settings.Default.ConnectionString_TheGuide;

            siteEventProcessor = PolicyInjection.Create<SiteEventsProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger());

            timerPeriod = Properties.Settings.Default.SnesActivityProcessor_Interval;
            siteEventTimer = new Timer(siteEventProcessor.ProcessEvents, null, 0, timerPeriod);
        }

        protected override void OnStop()
        {
            
        }
    }
}
