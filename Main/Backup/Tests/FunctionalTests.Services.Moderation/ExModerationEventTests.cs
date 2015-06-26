using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests.Services.Moderation
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class ExModerationEventTests
    {
        private string _server = DnaTestURLRequest.CurrentServer;
        private Thread _thread = null;
        private String _callbackBody = String.Empty;

        private HttpListener listener = new HttpListener();

        [TestInitialize]
        public void StartService()
        {
            ThreadStart start = new ThreadStart(Run);
            _thread = new Thread(start);
            _thread.Start();

            SnapshotInitialisation.RestoreFromSnapshot();
            System.Diagnostics.Process.Start("net",@"start ""SNesActivitiesService""");

        }

        [TestCleanup]
        public void StopService()
        {
            System.Diagnostics.Process.Start("net", @"stop ""SNesActivitiesService""");
            listener.Stop();
            if (_thread != null && _thread.IsAlive)
                _thread.Abort();
        }


        /// <summary>
        /// Creates a moderation item and then moderates it. 
        /// Listens for a moderation event for the appropriate item.
        /// </summary>
        /// <returns></returns>
        [Ignore]
        public void TestModerationEvent()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserModerator();

            //Put an item into moderation queue and moderate it.
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            String sql = String.Format("EXECUTE addexlinktomodqueue @siteid={0}, @uri='{1}', @callbackuri='{2}', @notes='{3}'",1, "http://localhost:8089/", "http://localhost:8089/", "Test");
            int modId = 0;
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(sql))
            {
                dataReader.ExecuteDEBUGONLY(sql);

                dataReader.ExecuteDEBUGONLY(String.Format("EXEC getmoderationexlinks @modclassid=3, @referrals=0,@alerts=0, @locked=0, @userid={0}", request.CurrentUserID));
                dataReader.Read();
                modId = dataReader.GetInt32NullAsZero("modid");

                dataReader.ExecuteDEBUGONLY(String.Format("EXECUTE moderateexlinks @modid={0}, @userid={1},@decision={2},@notes='{3}',@referto={4}", modId, request.CurrentUserID, 3, "Testing", 0));
            
                //Process Event Queue 
                dataReader.ExecuteDEBUGONLY("EXECUTE processeventqueue");
            }

            //Wait up to 10 seconds for callback.
            if (_thread.IsAlive)
            {
                _thread.Join(60000);
            }

            //Check Moderation Item has been processed.
            Assert.IsTrue( _callbackBody.Contains(Convert.ToString(modId)),"Checking value of returned ModId. In order for this test to work the SNESEventProcessor Service must be running against Small Guide.");

           
        }

        private void Run()
        {
            listener.Prefixes.Add("http://+:8089/");
            listener.Start();

            HttpListenerContext context = listener.GetContext();
            HttpListenerRequest request = context.Request;

            using (StreamReader reader = new StreamReader(request.InputStream))
            {
                _callbackBody = reader.ReadToEnd();
            }

            // Send Response 
            HttpListenerResponse response = context.Response;
            response.ContentLength64 = 0;
            response.StatusCode = (int)HttpStatusCode.OK;
            response.Close();
        }
    }
}
