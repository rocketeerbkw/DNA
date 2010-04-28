using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Transactions;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;
using System.Collections;
using BBC.Dna.Api;
using System.Net;
using System.Threading;

namespace FunctionalTests
{
    /// <summary>
    /// Summary description for ForumsStickyThreads
    /// </summary>
    [TestClass]
    public class TermsFilterAdminPageTests
    {
        private const string SiteName = "moderation";

        [TestInitialize]
        public void Initialise()
        {
            SnapshotInitialisation.ForceRestore();
            //_ts = new TransactionScope();
        }

        [TestCleanup]
        public void CleanUp()
        {
           //_ts.Dispose();
        }


        [TestMethod]
        public void TermsFilterAdminPage_AsSuperUser_PassesValidation()
        {
            
            var request = new DnaTestURLRequest(SiteName) {UseEditorAuthentication = true};
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilteradmin?modclassid=2&skin=purexml");
            ValidateResponse(request);
        }

        [TestMethod]
        public void TermsFilterAdminPage_WithoutEditorAuthentication_AccessDenied()
        {
            var siteName = "moderation";
            var request = new DnaTestURLRequest(siteName) {UseEditorAuthentication = false};
            request.SetCurrentUserSuperUser();
            bool exceptionThrown=false;
            try
            {
                request.RequestPage("termsfilteradmin?modclassid=2&skin=purexml");
            }
            catch (Exception)
            {
                exceptionThrown = true;
            }

            Assert.IsTrue(exceptionThrown);
        }

        [TestMethod]
        public void TermsFilterAdminPage_WithEditorAuthenticationAsEditor_AccessDenied()
        {
            var siteName = "moderation";
            var request = new DnaTestURLRequest(siteName) { UseEditorAuthentication = true };
            request.SetCurrentUserEditor();

            request.RequestPage("termsfilteradmin?modclassid=2&skin=purexml");
            var doc = request.GetLastResponseAsXML();
            Assert.AreEqual("ERROR",doc.SelectSingleNode("//H2G2").Attributes["TYPE"].Value);
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE"));
            Assert.IsNull(doc.SelectSingleNode("//H2G2/TERMADMIN"));
        }

        [TestMethod]
        public void TermsFilterAdminPage_UpdateExistingTerm_CorrectlyUpdates()
        {
            const int modClassId = 2;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termText = termNode.InnerText;
            var action = (TermAction) Enum.Parse(typeof (TermAction), termNode.Attributes["ACTION"].Value);
            TermAction expectedAction = (action == TermAction.ReEdit ? TermAction.Refer : TermAction.ReEdit);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext",termText));
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            ValidateResponse(request);
            ValidateOkResult(request, "TermsUpdateSuccess", "Terms updated successfully.");
            doc = request.GetLastResponseAsXML();
            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            Assert.AreEqual(expectedAction.ToString(), termNode.Attributes["ACTION"].Value);
            Assert.AreEqual(termText, termNode.InnerText);

            //check history audit
            var terms = new List<Term>();
            terms.Add(new Term { Id = Int32.Parse(termNode.Attributes["ID"].Value), Action = expectedAction});
            CheckAuditTable(modClassId, terms);

        }

        [TestMethod]
        public void TermsFilterAdminPage_UpdateExistingTermMissingTerm_CorrectError()
        {
            const int modClassId = 2;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termText = termNode.InnerText;
            var action = (TermAction)Enum.Parse(typeof(TermAction), termNode.Attributes["ACTION"].Value);
            TermAction expectedAction = (action == TermAction.ReEdit ? TermAction.Refer : TermAction.ReEdit);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            doc = request.GetLastResponseAsXML();
            ValidateError(request, "UPDATETERM", "Terms text cannot be empty.");
 
            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            Assert.AreEqual(action.ToString(), termNode.Attributes["ACTION"].Value);//should not have changed
            Assert.AreEqual(termText, termNode.InnerText);
        }

        [TestMethod]
        public void TermsFilterAdminPage_UpdateExistingTermMissingAction_CorrectError()
        {
            const int modClassId = 2;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termText = termNode.InnerText;
            var action = (TermAction)Enum.Parse(typeof(TermAction), termNode.Attributes["ACTION"].Value);
            TermAction expectedAction = (action == TermAction.ReEdit ? TermAction.Refer : TermAction.ReEdit);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", termText));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            doc = request.GetLastResponseAsXML();
            ValidateError(request, "UPDATETERM", "Terms action invalid.");

            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            Assert.AreEqual(action.ToString(), termNode.Attributes["ACTION"].Value);//should not have changed
            Assert.AreEqual(termText, termNode.InnerText);
        }

        [TestMethod]
        public void TermsFilterAdminPage_UpdateExistingTermMissingModClassId_CorrectError()
        {
            const int modClassId = 1;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termText = termNode.InnerText;
            var action = (TermAction)Enum.Parse(typeof(TermAction), termNode.Attributes["ACTION"].Value);
            TermAction expectedAction = (action == TermAction.ReEdit ? TermAction.Refer : TermAction.ReEdit);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", termText));
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?action=UPDATETERM&skin=purexml"),
                postParams);

            doc = request.GetLastResponseAsXML();
            ValidateError(request, "UPDATETERM", "Moderation Class ID cannot be 0.");

            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            Assert.AreEqual(action.ToString(), termNode.Attributes["ACTION"].Value);//should not have changed
            Assert.AreEqual(termText, termNode.InnerText);
        }

        [TestMethod]
        public void TermsFilterAdminPage_ModifyExistingTermText_CreatesNewTerm()
        {
            const int modClassId = 2;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml&ignorecache=1", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termNodeCount = doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count;
            var termText = termNode.InnerText + "withchange";
            var action = (TermAction)Enum.Parse(typeof(TermAction), termNode.Attributes["ACTION"].Value);
            TermAction expectedAction = (action == TermAction.ReEdit ? TermAction.Refer : TermAction.ReEdit);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", termText));
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            ValidateResponse(request);
            ValidateOkResult(request, "TermsUpdateSuccess", "Terms updated successfully.");
            doc = request.GetLastResponseAsXML();
            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM[text()='" + termText +"']");
            Assert.AreEqual(expectedAction.ToString(), termNode.Attributes["ACTION"].Value);
            Assert.AreEqual(termText, termNode.InnerText);
            Assert.AreEqual(termNodeCount + 1, doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count);

            //check history audit
            var terms = new List<Term>();
            terms.Add(new Term { Id = Int32.Parse(termNode.Attributes["ID"].Value), Action = expectedAction });
            CheckAuditTable(modClassId, terms);

        }

        [TestMethod]
        public void TermsFilterAdminPage_CreateTermRefreshSitePostViaApi_CorrectlyBlocksContent()
        {
            const int modClassId = 3;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml&ignorecache=1", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termNodeCount = doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count;
            var termText = "你好";
            TermAction expectedAction = TermAction.ReEdit;

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", termText));
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            ValidateResponse(request);
            ValidateOkResult(request, "TermsUpdateSuccess", "Terms updated successfully.");
            doc = request.GetLastResponseAsXML();
            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM[text()='" + termText + "']");
            Assert.AreEqual(expectedAction.ToString(), termNode.Attributes["ACTION"].Value);
            Assert.AreEqual(termText, termNode.InnerText);
            Assert.AreEqual(termNodeCount + 1, doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count);

            //check history audit
            var terms = new List<Term>();
            terms.Add(new Term { Id = Int32.Parse(termNode.Attributes["ID"].Value), Action = expectedAction });
            CheckAuditTable(modClassId, terms);

            //Do siterefresh
            SendSignal(String.Format("http://{0}/dna/api/comments/status?action=recache-site",
                                     DnaTestURLRequest.CurrentServer));
            //Post Via Comments Api
            var commentForumObj = new CommentForumTests_V1();
            var commentForum = commentForumObj.CommentForumCreateHelper();
            var commentXml = String.Format("<?xml version=\"1.0\" encoding=\"UTF-8\"?><comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", termText);

            // Setup the request url
            var url = String.Format("http://{0}/dna/api/comments/CommentsService.svc/V1/site/{1}/commentsforums/{2}/", DnaTestURLRequest.CurrentServer, commentForum.SiteName, commentForum.Id);
            // now get the response
            request = new DnaTestURLRequest(commentForum.SiteName);
            request.SetCurrentUserNormal();
            var exceptionThrown = false;
            try
            {
                request.RequestPageWithFullURL(url, commentXml, "text/xml");

            }
            catch (Exception)
            {
                exceptionThrown = true;
                Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            }
            Assert.IsTrue(exceptionThrown);
            


        }

        [TestMethod]
        public void TermsFilterAdminPage_CreateGreekTermRefreshSitePostViaAcs_CorrectlyBlocksContent()
        {
            const int modClassId = 3;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml&ignorecache=1", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termNodeCount = doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count;
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml", modClassId));
            var termText = "πρόσωπο";
            TermAction expectedAction = TermAction.ReEdit;

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", termText));
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            ValidateResponse(request);
            ValidateOkResult(request, "TermsUpdateSuccess", "Terms updated successfully.");
            doc = request.GetLastResponseAsXML();
            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM[text()='" + termText + "']");
            Assert.AreEqual(expectedAction.ToString(), termNode.Attributes["ACTION"].Value);
            Assert.AreEqual(termText, termNode.InnerText);
            Assert.AreEqual(termNodeCount + 1, doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count);

            //check history audit
            var terms = new List<Term>();
            terms.Add(new Term { Id = Int32.Parse(termNode.Attributes["ID"].Value), Action = expectedAction });
            CheckAuditTable(modClassId, terms);

            //Do siterefresh
            SendSignal(String.Format("http://{0}/dna/h2g2/DnaSignal?action=recache-site",
                                     DnaTestURLRequest.CurrentServer));

            // Setup the request url
            var url = String.Format("acs?dnauid={0}&dnahostpageurl={1}&dnainitialtitle={2}&dnaur=0&skin=purexml", 
                Guid.NewGuid(), "http://www.bbc.co.uk/dna/h2g2/test.aspx", "test forum");
            // now get the response
            request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPage(url);//create forum
            doc = request.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("//H2G2/ERROR"));

            url += "&dnaaction=add";
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("dnacomment", termText));
            request.RequestPage(url, postParams);
            ValidateError(request, "profanityblocked", termText);


        }

        [TestMethod]
        public void TermsFilterAdminPage_CreateEnglishTermRefreshSitePostViaAddThread_CorrectlyBlocksContent()
        {
            const int modClassId = 3;
            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml&ignorecache=1", modClassId));
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM");
            var termNodeCount = doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count;
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&skin=purexml", modClassId));
            var termText = "testterm";
            TermAction expectedAction = TermAction.ReEdit;

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", termText));
            postParams.Enqueue(new KeyValuePair<string, string>("termaction", expectedAction.ToString()));

            //update the first term
            request.RequestPage(string.Format("termsfilteradmin?modclassid={0}&action=UPDATETERM&skin=purexml", modClassId),
                postParams);

            ValidateResponse(request);
            ValidateOkResult(request, "TermsUpdateSuccess", "Terms updated successfully.");
            doc = request.GetLastResponseAsXML();
            termNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM[text()='" + termText + "']");
            Assert.AreEqual(expectedAction.ToString(), termNode.Attributes["ACTION"].Value);
            Assert.AreEqual(termText, termNode.InnerText);
            Assert.AreEqual(termNodeCount + 1, doc.SelectNodes("//H2G2/TERMSFILTERADMIN/TERMSLIST/TERM").Count);

            //check history audit
            var terms = new List<Term>();
            terms.Add(new Term { Id = Int32.Parse(termNode.Attributes["ID"].Value), Action = expectedAction });
            CheckAuditTable(modClassId, terms);

            //Do siterefresh
            SendSignal(String.Format("http://{0}/dna/h2g2/Signal?action=recache-site",
                                     DnaTestURLRequest.CurrentServer));

            // Setup the request url
            var url = String.Format("AddThread?skin=purexml");
            request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("threadid", "0"));
            postParams.Enqueue(new KeyValuePair<string, string>("inreplyto", "0"));
            postParams.Enqueue(new KeyValuePair<string, string>("dnapoststyle", "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("forum", "150"));
            postParams.Enqueue(new KeyValuePair<string, string>("subject", "test post"));
            postParams.Enqueue(new KeyValuePair<string, string>("body", termText));
            postParams.Enqueue(new KeyValuePair<string, string>("post", "Post message"));
            request.RequestPage(url, postParams);
            doc = request.GetLastResponseAsXML();
            //check for profanity triggered value
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/POSTTHREADFORM[@PROFANITYTRIGGERED='1']"));



        }

        /// <summary>
        /// Looks for errors and correct page validation
        /// </summary>
        /// <param name="request"></param>
        private static void ValidateResponse(DnaTestURLRequest request)
        {
            //no errors
            var doc = request.GetLastResponseAsXML();
            Assert.IsNull(doc.SelectSingleNode("//H2G2/ERROR"));
            Assert.IsNull(doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE"));

            var termsAdminNode = doc.SelectSingleNode("//H2G2/TERMSFILTERADMIN");
            Assert.IsNotNull(termsAdminNode);
            var dnaXmlValidator = new DnaXmlValidator(termsAdminNode.OuterXml, "TermsFilterAdmin.xsd");
            dnaXmlValidator.Validate();
        }

        /// <summary>
        /// Looks for errors and correct validation
        /// </summary>
        /// <param name="request"></param>
        /// <param name="expectedType"></param>
        /// <param name="expectedMessage"></param>
        private static void ValidateError(DnaTestURLRequest request, string expectedType, string expectedMessage)
        {
            //no errors
            var doc = request.GetLastResponseAsXML();
            var error = doc.SelectSingleNode("//H2G2/ERROR");
            Assert.IsNotNull(error);
            Assert.IsNull(doc.SelectSingleNode("//H2G2/RESULT"));

            var dnaXmlValidator = new DnaXmlValidator(error.OuterXml, "error.xsd");
            dnaXmlValidator.Validate();

            Assert.AreEqual(expectedType, error.Attributes["TYPE"].Value);
            Assert.AreEqual(expectedMessage, error.ChildNodes[0].InnerText);
        }

        /// <summary>
        /// Looks for errors and correct validation
        /// </summary>
        /// <param name="request"></param>
        /// <param name="expectedType"></param>
        /// <param name="expectedMessage"></param>
        private static void ValidateOkResult(DnaTestURLRequest request, string expectedType, string expectedMessage)
        {
            //no errors
            var doc = request.GetLastResponseAsXML();
            var result = doc.SelectSingleNode("//H2G2/RESULT");
            Assert.IsNotNull(result);
            Assert.IsNull(doc.SelectSingleNode("//H2G2/ERROR"));
            

            var dnaXmlValidator = new DnaXmlValidator(result.OuterXml, "Result.xsd");
            dnaXmlValidator.Validate();

            Assert.AreEqual(expectedType, result.Attributes["TYPE"].Value);
            Assert.AreEqual(expectedMessage, result.ChildNodes[0].InnerText);
        }

        /// <summary>
        /// Check audit table for correct values
        /// </summary>
        /// <param name="modClassId"></param>
        /// <param name="terms"></param>
        private static void CheckAuditTable(int modClassId, List<Term> terms)
        {
            int updateId = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                var sql = String.Format("select top 1 * from TermsUpdateHistory order by updatedate desc");
                dataReader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(dataReader.HasRows);
                while(dataReader.Read())
                {
                    updateId = dataReader.GetInt32NullAsZero("id");
                    Assert.AreNotEqual(0, updateId);
                }

                sql = String.Format("select * from TermsByModClassHistory where updateid={0}", updateId);
                dataReader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(dataReader.HasRows);
                while (dataReader.Read())
                {
                    int termId = dataReader.GetInt32NullAsZero("termid");
                    Assert.AreEqual(modClassId, dataReader.GetInt32NullAsZero("modclassid"));
                    int actionId = dataReader.GetTinyIntAsInt("actionid");
                    var termFound = terms.Where(i => i.Id == termId && i.Action == (TermAction)actionId);
                    Assert.AreEqual(1, termFound.Count());
                    Assert.IsTrue(terms.Remove(termFound.ElementAt(0)));
                }
                Assert.AreEqual(0, terms.Count);//should be none left
            }


        }

        private void SendSignal(string url)
        {
            var request = new DnaTestURLRequest(SiteName);
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");
            

        }

    }
}
