using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.IO;

namespace FunctionalTests
{
    /// <summary>
    /// Test utility class TwitterProfileListPageTests.cs
    /// </summary>
    [TestClass]
    public class TwitterProfileListPageTests
    {
        //private static string _siteName = "moderation";
        private static int _siteId = 1;
        private static int _normalUserId = 1;//TestUserAccounts.GetNormalUserAccount.UserID;
        private string _normalUserSearch = String.Format("HostDashboardUserActivity?s_user={0}&s_siteid={1}&skin=purexml", _normalUserId, _siteId);
        private IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {

        }
    }
}
