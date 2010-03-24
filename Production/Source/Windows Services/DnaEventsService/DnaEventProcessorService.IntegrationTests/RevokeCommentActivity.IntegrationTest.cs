using System;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using BBC.Dna.Data;
using BBC.Dna.Net.Security;
using Dna.SnesIntegration.ActivityProcessor;
using DnaEventService.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace DnaEventProcessorService.IntegrationTests
{
    /// <summary>
    /// Summary description for RevokeCommentActivity
    /// </summary>
    [TestClass]
    public class RevokeCommentActivityTests
    {
        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext { get; set; }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void RevokeCommentActivity_SubmitActivityAndRevoke_Success()
        {
            LogUtility.Logger = MockRepository.GenerateStub<IDnaLogger>();
            
            var currentRow = MockRepository.GenerateStub<IDnaDataReader>();
            DateTime now = DateTime.Now;
            currentRow.Stub(x => x.GetDateTime("ActivityTime")).Return(now);
            currentRow.Stub(x => x.GetString("AppId")).Return("testApplication");

            var httpClient = GetHttpClient();

            var activity = CommentActivityBase.CreateActivity(19, currentRow);
            activity.Send(httpClient);

            var revokeActivity = RevokeCommentActivity.CreateActivity(currentRow);
            revokeActivity.Send(httpClient);

            var getActivity = new SnesActivitiesQuery()
                                  {
                                      FilterBy = "postedTime",
                                      FilterOp = "equals",
                                      FilterValue = now.ToString(),
                                      IdentityUserId = 0,
                                  };
            var statusCode =  getActivity.Send(httpClient);
            Assert.AreEqual(HttpStatusCode.InternalServerError, statusCode);
        }

        private static IDnaHttpClient GetHttpClient()
        {
            var baseUri = new Uri(Properties.Settings.Default.baseUri);
            var proxyAddress = new Uri(Properties.Settings.Default.proxyAddress);
            var cert = X509CertificateLoader.FindCertificate(Properties.Settings.Default.certificateName);
            var httpClientCreator = new DnaHttpClientCreator(baseUri, proxyAddress, cert);
            return httpClientCreator.CreateHttpClient();
        }
    }
}
