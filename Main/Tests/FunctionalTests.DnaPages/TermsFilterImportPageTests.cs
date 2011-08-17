using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
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
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;

namespace FunctionalTests
{
    /// <summary>
    /// Summary description for ForumsStickyThreads
    /// </summary>
    [TestClass]
    public class TermsFilterImportPageTests
    {
        private const string SiteName = "moderation";

        [TestInitialize]
        public void Initialise()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            //_ts = new TransactionScope();
        }

        [TestCleanup]
        public void CleanUp()
        {
           //_ts.Dispose();
        }


        [TestMethod]
        public void TermsFilterImportPage_AsSuperUser_PassesValidation()
        {
            
            var request = new DnaTestURLRequest(SiteName) {UseEditorAuthentication = true};
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?&skin=purexml");
            ValidateResponse(request);
        }

        [TestMethod]
        public void TermsFilterImportPage_WithoutEditorAuthenticationAsInSecured_AccessDenied()
        {
            var siteName = "moderation";
            var request = new DnaTestURLRequest(siteName) { UseEditorAuthentication = false, UseDebugUserSecureCookie=false};
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?&skin=purexml", false, null);
            var xml = request.GetLastResponseAsXML();
            Assert.AreEqual("ERROR", xml.DocumentElement.Attributes[0].Value);
        }

        [TestMethod]
        public void TermsFilterImportPage_WithoutEditorAuthenticationAsSecure_NoError()
        {
            var siteName = "moderation";
            var request = new DnaTestURLRequest(siteName) { UseEditorAuthentication = false};
            request.SetCurrentUserSuperUser();
            bool exceptionThrown = false;
            try
            {
                request.RequestPage("termsfilterimport?&skin=purexml", true, null);
            }
            catch (Exception)
            {
                exceptionThrown = true;
            }

            Assert.IsFalse(exceptionThrown);
        }

        [TestMethod]
        public void TermsFilterImportPage_WithEditorAuthenticationAsEditor_AccessDenied()
        {
            var siteName = "moderation";
            var request = new DnaTestURLRequest(siteName) { UseEditorAuthentication = true };
            request.SetCurrentUserEditor();

            request.RequestPage("termsfilterimport?&skin=purexml");
            var doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR"));
            Assert.IsNotNull(doc.SelectSingleNode("//H2G2/ERROR/ERRORMESSAGE"));
            Assert.IsNull(doc.SelectSingleNode("//H2G2/TERMADMIN"));
        }

        [TestMethod]
        public void TermsFilterImportPage_WithTermIdPassed_PassesValidation()
        {

            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?s_termid=1&skin=purexml");
            ValidateResponse(request);

            var doc = request.GetLastResponseAsXML();
            var termsListNode = doc.SelectSingleNode("//H2G2/TERMSLISTS");
            Assert.IsNotNull(termsListNode);

            Assert.AreEqual(2, termsListNode.ChildNodes.Count);
        }

        [TestMethod]
        public void TermsFilterImportPage_AddSingleTerm_PassesValidation()
        {
            //set up data
            var reason = "this has a reason";
            var termsLists = new TermsLists();
            var termsList = new TermsList(1);
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = "bollocks" });
            termsLists.Termslist.Add(termsList);
            termsList = new TermsList(2);
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = "bollocks" });
            termsLists.Termslist.Add(termsList);

            string postText = termsLists.Termslist.Aggregate("", (current1, tmpTermsList) => tmpTermsList.Terms.Aggregate(current1, (current, term) => current + (term.Value + "\n")));

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("reason", reason));
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", postText));
            foreach (var tempTermsList in termsLists.Termslist)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_" + tempTermsList.ModClassId, (tempTermsList.Terms[0].Action).ToString()));    
            }


            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?action=UPDATETERMS&skin=purexml", postParams);
            ValidateResponse(request);

            //check correct error message returned
            ValidateOkResult(request, "TermsUpdateSuccess", "Term updated successfully.");
            //check history table
            termsLists = ValidateHistory(request, reason, termsLists);
            //Check that all terms are actually associated
            ValidateTermAssociations(request, termsLists);
        }

        [TestMethod]
        public void TermsFilterImportPage_AddSingleTermToAll_PassesValidation()
        {
            //refresh mod classes
            SendSignal();
            //set up data
            var reason = "this has a reason";
            var term = "arse";
            var action = TermAction.ReEdit;

            var moderationClasses = new ModerationClassListCache(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default, CacheFactory.GetCacheManager(), null, null);


            var moderationClassList = moderationClasses.GetObjectFromCache();

            var termsLists = new TermsLists();
            foreach(var modClass in moderationClassList.ModClassList)
            {
                var termsList = new TermsList {ModClassId = modClass.ClassId};
                termsList.Terms.Add(new Term { Value = term, Action = action });
                termsLists.Termslist.Add(termsList);
            }
            Assert.AreNotEqual(0, termsLists.Termslist.Count);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("reason", reason));
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", term));
            postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_all", action.ToString()));



            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?action=UPDATETERMS&skin=purexml", postParams);
            ValidateResponse(request);

            //check correct error message returned
            ValidateOkResult(request, "TermsUpdateSuccess", "Term updated successfully.");
            //check history table
            termsLists = ValidateHistory(request, reason, termsLists);
            //Check that all terms are actually associated
            ValidateTermAssociations(request, termsLists);
        }

        [TestMethod]
        public void TermsFilterImportPage_AddSingleTermWithoutReason_ReturnsCorrectError()
        {
            //set up data
            var reason = "";//empty for test
            var termsLists = new TermsLists();
            var termsList = new TermsList(1);
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = "bollocks" });
            termsLists.Termslist.Add(termsList);
            termsList = new TermsList(2);
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = "bollocks" });
            termsLists.Termslist.Add(termsList);

            string postText = termsLists.Termslist.Aggregate("", (current1, tmpTermsList) => tmpTermsList.Terms.Aggregate(current1, (current, term) => current + (term.Value + "\n")));

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("reason", reason));
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", postText));
            foreach (var tempTermsList in termsLists.Termslist)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_" + tempTermsList.ModClassId, (tempTermsList.Terms[0].Action).ToString()));
            }


            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?action=UPDATETERMS&skin=purexml", postParams);
            ValidateError(request, "UPDATETERMMISSINGDESCRIPTION", "The import description cannot be empty.");
        }

        [TestMethod]
        public void TermsFilterImportPage_AddSingleTermWithoutTerms_ReturnsCorrectError()
        {
            //set up data
            var reason = "Not Empty";//empty for test
            var termsLists = new TermsLists();
            var termsList = new TermsList(1);
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = "bollocks" });
            termsLists.Termslist.Add(termsList);
            termsList = new TermsList(2);
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = "bollocks" });
            termsLists.Termslist.Add(termsList);

            string postText = "";//breaks test

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("reason", reason));
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", postText));
            foreach (var tempTermsList in termsLists.Termslist)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_" + tempTermsList.ModClassId, (tempTermsList.Terms[0].Action).ToString()));
            }


            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?action=UPDATETERMS&skin=purexml", postParams);
            ValidateError(request, "UPDATETERMMISSINGTERM", "Terms text must contain newline delimited terms.");
        }

        [TestMethod]
        public void TermsFilterImportPage_AddMultipleTerms_PassesValidation()
        {
            var term1 = Guid.NewGuid().ToString();
            var term2 = Guid.NewGuid().ToString();
            //set up data
            var reason = "this has a reason";
            var termsLists = new TermsLists();
            var termsList = new TermsList(1);
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = term1 });
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = term2 });
            termsLists.Termslist.Add(termsList);
            termsList = new TermsList(2);
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = term1 });
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = term2 });
            termsLists.Termslist.Add(termsList);

            string postText = termsLists.Termslist.Aggregate("", (current1, tmpTermsList) => tmpTermsList.Terms.Aggregate(current1, (current, term) => current + (term.Value + "\n")));

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("reason", reason));
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", postText));
            foreach (var tempTermsList in termsLists.Termslist)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_" + tempTermsList.ModClassId, (tempTermsList.Terms[0].Action).ToString()));
            }


            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?action=UPDATETERMS&skin=purexml&ignorecache=1", postParams);
            ValidateResponse(request);

            //check correct error message returned
            ValidateOkResult(request, "TermsUpdateSuccess", "Terms updated successfully.");
            //check history table
            termsLists = ValidateHistory(request, reason, termsLists);
            //Check that all terms are actually associated
            ValidateTermAssociations(request, termsLists);
        }

        [TestMethod]
        public void TermsFilterImportPage_AddMultipleTermsWithErrors_ReturnsErrors()
        {
            var term1 = Guid.NewGuid().ToString();
            var term2 = Guid.NewGuid().ToString();
            //set up data
            var reason = "this has a reason";
            var termsLists = new TermsLists();
            var termsList = new TermsList(1);
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = term1 });
            termsList.Terms.Add(new Term { Action = TermAction.Refer, Value = term2 });
            termsLists.Termslist.Add(termsList);
            termsList = new TermsList(2);
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = term1 });
            termsList.Terms.Add(new Term { Action = TermAction.ReEdit, Value = term2 });
            termsLists.Termslist.Add(termsList);

            string postText = termsLists.Termslist.Aggregate("", (current1, tmpTermsList) => tmpTermsList.Terms.Aggregate(current1, (current, term) => current + (term.Value + "\n")));

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("reason", reason));
            postParams.Enqueue(new KeyValuePair<string, string>("termtext", postText));
            foreach (var tempTermsList in termsLists.Termslist)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_" + tempTermsList.ModClassId, (tempTermsList.Terms[0].Action).ToString()));
            }

            postParams.Enqueue(new KeyValuePair<string, string>("action_modclassid_" + 3, "100"));//invalid action

            var request = new DnaTestURLRequest(SiteName) { UseEditorAuthentication = true };
            request.SetCurrentUserSuperUser();
            request.RequestPage("termsfilterimport?action=UPDATETERMS&skin=purexml&ignorecache=1", postParams);

            //check correct error message returned
            ValidateError(request, "UPDATETERMINVALIDACTION", "Terms action invalid.");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="termsLists"></param>
        private void ValidateTermAssociations(DnaTestURLRequest request, TermsLists termsLists)
        {
            XmlDocument doc;
            var termIds = new List<int>();
            foreach (var tmpList in termsLists.Termslist)
            {
                termIds.AddRange(tmpList.Terms.Select(term => term.Id));
            }
            //strip duplicates
            termIds = termIds.Distinct().ToList();


            //check the term association
            foreach (var id in termIds)
            {
                var termsListsClone = (TermsLists)termsLists.Clone();
                termsListsClone.FilterListByTermId(id);
                request.RequestPage(String.Format("termsfilterimport?s_termid={0}&skin=purexml&ignorecache=1", id));
                doc = request.GetLastResponseAsXML();

                ValidateResponse(request);

                var termsListNodes = doc.SelectNodes("//H2G2/TERMSLISTS/TERMSLIST");
                Assert.IsNotNull(termsListNodes);
                foreach(XmlNode termsListNode in termsListNodes)
                {
                    var termsList =
                        termsListsClone.Termslist.FirstOrDefault(
                            x => x.ModClassId == Int32.Parse(termsListNode.Attributes["MODCLASSID"].Value));
                    Assert.IsNotNull(termsList);
                    Assert.AreEqual(id, termsList.Terms[0].Id);

                    termsListsClone.Termslist.Remove(termsList);
                }
                //check if all elements removed
                Assert.AreEqual(0, termsListsClone.Termslist.Count);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="reason"></param>
        /// <param name="termsLists"></param>
        /// <returns></returns>
        private TermsLists ValidateHistory(DnaTestURLRequest request, string reason, TermsLists termsLists)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                foreach (var termsList in termsLists.Termslist)
                {
                    foreach(var term in termsList.Terms)
                    {
                        reader.ExecuteDEBUGONLY("select id from termslookup where term='" + term.Value + "'");
                        if (reader.Read())
                        {
                            term.Id = reader.GetInt32NullAsZero("id");
                        }
                        Assert.AreNotEqual(0, term.Id);
                    }
                }

                var historyId = 0;
                reader.ExecuteDEBUGONLY("select top 1 * from TermsUpdateHistory order by updatedate desc");
                if (reader.Read())
                {
                    historyId = reader.GetInt32NullAsZero("id");
                    Assert.AreNotEqual(0, historyId);
                    Assert.AreEqual(reason, reader.GetStringNullAsEmpty("notes"));
                    Assert.AreEqual(request.CurrentUserID, reader.GetInt32NullAsZero("userid"));
                }


                var termsListsClone = (TermsLists)termsLists.Clone();
                reader.ExecuteDEBUGONLY("select * from TermsByModClassHistory where updateid=" + historyId + " order by modclassid");
                while (reader.Read())
                {
                    //remove items from lists if in db
                    var termsListFound = 
                        termsListsClone.Termslist.FirstOrDefault(x => x.ModClassId == reader.GetInt32NullAsZero("modclassid"));

                    Assert.IsNotNull(termsListFound);
                    var termFound = termsListFound.Terms.FirstOrDefault(x => x.Id == reader.GetInt32NullAsZero("termid")
                        && (byte)x.Action == reader.GetTinyIntAsInt("actionid"));

                    Assert.IsTrue(termsListFound.Terms.Remove(termFound));

                    if(termsListFound.Terms.Count == 0)
                    {
                        Assert.IsTrue(termsListsClone.Termslist.Remove(termsListFound));
                    }

                }
                Assert.AreEqual(0, termsListsClone.Termslist.Count);

            }
            return termsLists;
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

            var termsAdminNode = doc.SelectSingleNode("//H2G2/MODERATION-CLASSES");
            Assert.IsNotNull(termsAdminNode);
            var dnaXmlValidator = new DnaXmlValidator(termsAdminNode.OuterXml, "Moderation-Classes.xsd");
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


        private void SendSignal()
        {
            var request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPage("dnasignal?action=recache-moderationclasses");


        }   
    }
}
