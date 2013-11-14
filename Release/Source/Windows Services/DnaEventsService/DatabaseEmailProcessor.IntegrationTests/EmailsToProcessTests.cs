using System;
using Dna.DatabaseEmailProcessor;
using DnaEventService.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace DatabaseEmailProcessor.IntegrationTests
{
    [TestClass]
    public class EmailDetailstoProcessTests
    {
        [TestMethod]
        public void GivenValidEmailDetailsAndEmailClientShouldSendEmail()
        {
            TestLogger logger = new TestLogger();
            IDnaSmtpClient client = MockRepository.GenerateMock<IDnaSmtpClient>();

            EmailDetailsToProcess emailDetailsToProcess = new EmailDetailsToProcess();
            emailDetailsToProcess.ID = 1;
            emailDetailsToProcess.Subject = "Subject";
            emailDetailsToProcess.Body = "Email Body";
            emailDetailsToProcess.FromAddress = "test@bbc.co.uk";
            emailDetailsToProcess.ToAddress = "theBBC@bbc.co.uk";

            emailDetailsToProcess.ProcessEmail(client, logger);

            Assert.IsTrue(emailDetailsToProcess.Sent);
            Assert.IsNull(emailDetailsToProcess.LastFailedReason);
        }

        [TestMethod]
        public void GivenValidEmailDetailsAndInvalidEmailClientShouldNOTSendEmail()
        {
            TestLogger logger = new TestLogger();
            IDnaSmtpClient client = MockRepository.GenerateMock<IDnaSmtpClient>();

            client.Stub(x => x.SendMessage(null)).Throw(new Exception("No Host Set"));

            EmailDetailsToProcess emailDetailsToProcess = new EmailDetailsToProcess();
            emailDetailsToProcess.ID = 1;
            emailDetailsToProcess.Subject = "Subject";
            emailDetailsToProcess.Body = "Email Body";
            emailDetailsToProcess.FromAddress = "test@bbc.co.uk";
            emailDetailsToProcess.ToAddress = "theBBC@bbc.co.uk";

            emailDetailsToProcess.ProcessEmail(client, logger);

            Assert.IsTrue(emailDetailsToProcess.Sent);
            Assert.IsNull(emailDetailsToProcess.LastFailedReason);
        }
    }
}
