﻿using System;
using System.Security.Cryptography.X509Certificates;
using System.ServiceProcess;
using System.Threading;
using BBC.Dna.Data;
using BBC.Dna.Net.Security;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ExModerationProcessor;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;

namespace DnaEventProcessorService
{
    public partial class DnaEventProcessorServiceHost : ServiceBase
    {
        private SnesActivityProcessor snesActivityProcessor;
        private ExModerationProcessor exModerationProcessor;
        private Timer activityTimer, exModerationTimer;
        private int timerPeriod;
        private string guideConnectionString;
        private string certificateName;
        
        public DnaEventProcessorServiceHost()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            CreateActivityTimer();
            CreateExModerationEventTimer();
        }

        private string GetCertificateName()
        {
            certificateName = Properties.Settings.Default.certificateName;
            return certificateName;
        }

        private void CreateActivityTimer()
        {
            Uri snesBaseUri = new Uri(Properties.Settings.Default.snesBaseUri);
            string proxyAddress = Properties.Settings.Default.proxyAddress;
            X509Certificate cert = X509CertificateLoader.FindCertificate(GetCertificateName());
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
            string proxyAddress = Properties.Settings.Default.proxyAddress;
            X509Certificate cert = X509CertificateLoader.FindCertificate(GetCertificateName());

            guideConnectionString = Properties.Settings.Default.guideConnectionString;

            exModerationProcessor = PolicyInjection.Create<ExModerationProcessor>(
                new DnaDataReaderCreator(guideConnectionString),
                new DnaLogger(),
                new DnaHttpClientCreator(null, proxyAddress, cert));

            timerPeriod = Properties.Settings.Default.activityProcessingPeriod;
            exModerationTimer = new Timer(exModerationProcessor.ProcessEvents, null, 0, timerPeriod);

        }

        protected override void OnStop()
        {
            
        }
    }
}
