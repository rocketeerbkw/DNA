using System;
using System.Security.Cryptography.X509Certificates;
using System.ServiceProcess;
using System.Threading;
using BBC.Dna.Data;
using BBC.Dna.Net.Security;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ExModerationProcessor;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;
using Dna.SiteEventProcessor;

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
            //System.Diagnostics.Debugger.Break();
            CreateActivityTimer();
            CreateExModerationEventTimer();
            CreateSiteEventTimer();
        }

        private string GetCertificateName(string type)
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

        private void CreateActivityTimer()
        {
            Uri snesBaseUri = new Uri(Properties.Settings.Default.snesBaseUri);
            Uri proxyAddress = new Uri(Properties.Settings.Default.proxyAddress);
            X509Certificate cert = X509CertificateLoader.FindCertificate(GetCertificateName("SnesActivityProcessor"));
            guideConnectionString = Properties.Settings.Default.guideConnectionString;

            snesActivityProcessor = PolicyInjection.Create<SnesActivityProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger(),
                new DnaHttpClientCreator(snesBaseUri, proxyAddress, cert));

            timerPeriod = Properties.Settings.Default.activityProcessingPeriod;
            activityTimer = new Timer(snesActivityProcessor.ProcessEvents, null, 0, timerPeriod);
        }

        private void CreateExModerationEventTimer()
        {
            Uri proxyAddress = new Uri(Properties.Settings.Default.proxyAddress);
            X509Certificate cert = X509CertificateLoader.FindCertificate(GetCertificateName("ExModerationProcessor"));

            guideConnectionString = Properties.Settings.Default.guideConnectionString;

            exModerationProcessor = PolicyInjection.Create<ExModerationProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger(),
                new DnaHttpClientCreator(null, proxyAddress, cert));

            timerPeriod = Properties.Settings.Default.activityProcessingPeriod;
            exModerationTimer = new Timer(exModerationProcessor.ProcessEvents, null, 0, timerPeriod);

        }

        private void CreateSiteEventTimer()
        {
            guideConnectionString = Properties.Settings.Default.guideConnectionString;

            siteEventProcessor = PolicyInjection.Create<SiteEventsProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger());

            timerPeriod = Properties.Settings.Default.activityProcessingPeriod;
            siteEventTimer = new Timer(siteEventProcessor.ProcessEvents, null, 0, timerPeriod);

        }

        protected override void OnStop()
        {
            
        }
    }
}
