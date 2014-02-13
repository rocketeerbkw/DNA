using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;
using BBC.Dna.Utils;
using System.IO;


namespace FunctionalTests
{
    /// <summary>
    /// Test the XML against the schema.
    /// Sanity check the results.
    /// </summary>
    [TestClass]
    public class UserComplaintPageTests
    {
        private int _postId = 61;
        private int _h2g2Id = 559;
        private string _siteName = "mbiplayer";
        private int _siteId = 72;
        private int _userId = TestUserAccounts.GetNormalUserAccount.UserID;
        private int _modClassId = 4;

        [TestInitialize]
        public void FixtureSetup()
        {
            SnapshotInitialisation.ForceRestore();
            ClearAllEmails();
        }

        [TestCleanup]
        public void ShutDown()
        {
            // Make sure the database is back in the starting position
            // SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Check Schema of UserComplaint page befor submission
        /// </summary>
        [TestMethod]
        public void Test1UserComplaintPage()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = false;
            request.RequestPage("UserComplaintPage?skin=purexml" + "&postid=" + Convert.ToString(_postId) );

            XmlDocument doc = request.GetLastResponseAsXML();

            //Check XML against Schema.
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2UserComplaintFlat.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Check Schema of UserComplaint page befor submission
        /// </summary>
        [TestMethod]
        public void Test2DuplicateComplaint()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = false;
            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&skin=purexml");

            //Check XML against Schema.
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsTrue(doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") != null, "Complaint should be processed");
            String modId = doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID").Value;

            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&skin=purexml");
            Assert.IsTrue(doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") != null, "Complaint should be processed");
            Assert.IsTrue(doc.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID").Value == modId, "New complaint should not be generated");
        }

        /// <summary>
        /// Tests that a banned user either logged in or not does not succeed
        /// </summary>
        [TestMethod]
        public void Test3BannedUser()
        {
            // First make sure that the test user can make a complaint before we put the email in the banned emails list
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNotLoggedInUser();
            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&email=mark.howitt@banned.uk&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();

            // Check to make sure complaint was processed
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/USERCOMPLAINT/@REQUIRESVERIFICATION") != null, "Complaint did not succeed");

             // Now put the users email into the banned emails list for complaints
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("AddEMailToBannedList"))
            {
                reader.AddParameter("Email", "mark.howitt@banned.uk");
                reader.AddParameter("SigninBanned", 0);
                reader.AddParameter("ComplaintBanned", 1);
                reader.AddParameter("EditorID", 6);
                reader.AddIntReturnValue();
                reader.Execute();

                var duplicate = reader.GetIntReturnValue();

                Assert.AreEqual(0,duplicate, "The Duplicate result should be false (0)");
            }

             // Now try to complain again
            request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNotLoggedInUser();
            request.RequestPage("UserComplaintPage?postid=" + Convert.ToString(_postId) + "&action=submit&complaintreason=libellous&complainttext=Complaint&email=mark.howitt@banned.uk&skin=purexml");
            xml = request.GetLastResponseAsXML();

            // Check to make sure that complaint was not made.
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") == null, "User is banned from complaining.");
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/ERROR") != null, "User is banned from complaining.");
        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidComplaintAgainstPost_CorrectDBEntriesAndResponse()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "";
            var complaintUrl = "";
            var anonymous = false;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);
            int modId = -1;


            CheckForValidResponse(xml, out modId, "usercomplaint.xsd");
            CheckDatabaseEntry(modId, complaintText, email, 0, _postId, complaintUrl, anonymous);
            CheckEmailWasSent("From: " + TestUserAccounts.GetNormalUserAccount.UserName, complaintText);

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidComplaintAgainstPostByEditor_CorrectDBEntriesAndResponse()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "";
            var complaintUrl = "";
            var anonymous = false;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous,true, false);
            int modId = -1;


            CheckForValidResponse(xml, out modId, "usercomplaint.xsd");
            CheckDatabaseEntry(modId, complaintText, email, 0, _postId, complaintUrl, anonymous);
            CheckEmailWasSent("From: " + TestUserAccounts.GetEditorUserAccount.UserName + " (Editor)", complaintText);

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstPost_CorrectDBEntriesAndResponse()
        {

            try
            {
                AddVerificationTemplate();

                var complaintText = Guid.NewGuid().ToString();
                var complaintReason = "a reason";
                var email = "a@b.com";
                var complaintUrl = "";
                var anonymous = true;

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);
                int modId = -1;
                Guid verificationCode = Guid.Empty;

                CheckForValidVerificationResponse(xml, out verificationCode, "usercomplaint.xsd", email);
                CheckEmailWasSent("UserComplaintEmailVerification", verificationCode.ToString());
                ClearAllEmails();

                xml = PostVerificationComplaint(verificationCode);
                CheckForValidResponse(xml, out modId, "usercomplaint.xsd");
                CheckDatabaseEntry(modId, complaintText, email, 0, _postId, complaintUrl, anonymous);
                CheckEmailWasSent("From: " + email, complaintText);
            }
            finally
            {
                
                ClearAllEmails();
                RemoveVerificationTemplate();
            }

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstPostWrongCode_CorrectError()
        {

            try
            {
                DeleteFailPost();
                AddVerificationTemplate();

                var complaintText = Guid.NewGuid().ToString();
                var complaintReason = "a reason";
                var email = "a@b.com";
                var complaintUrl = "";
                var anonymous = true;

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);
                Guid verificationCode = Guid.Empty;

                CheckForValidVerificationResponse(xml, out verificationCode, "usercomplaint.xsd", email);
                CheckEmailWasSent("UserComplaintEmailVerification", verificationCode.ToString());
                ClearAllEmails();

                xml = PostVerificationComplaint(Guid.NewGuid());
                CheckForError(xml, "InvalidVerificationCode", "Verification Code is not valid");
            }
            finally
            {
                ClearAllEmails();
                RemoveVerificationTemplate();
            }

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstWithBBCEmailExternal_CorrectVerificationCode()
        {

            try
            {
                AddVerificationTemplate();

                var complaintText = Guid.NewGuid().ToString();
                var complaintReason = "a reason";
                var email = "a@bbc.co.uk";
                var complaintUrl = "";
                var anonymous = true;
                Guid verificationCode = Guid.Empty;

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);

                CheckForValidVerificationResponse(xml, out verificationCode, "usercomplaint.xsd", email);
                CheckEmailWasSent("UserComplaintEmailVerification", verificationCode.ToString());
                ClearAllEmails();
            }
            finally
            {
                ClearAllEmails();
                RemoveVerificationTemplate();
            }

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAlreadyFailed_CorrectErrorCode()
        {

            try
            {
                DeleteFailPost();
                AddVerificationTemplate();

                var complaintText = Guid.NewGuid().ToString();
                var complaintReason = "a reason";
                var email = "a@bbc.co.uk";
                var complaintUrl = "";
                var anonymous = true;
                Guid verificationCode = Guid.Empty;

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);

                CheckForValidVerificationResponse(xml, out verificationCode, "usercomplaint.xsd", email);
                CheckEmailWasSent("UserComplaintEmailVerification", verificationCode.ToString());
                ClearAllEmails();

                //fail post
                FailPost();

                xml = PostVerificationComplaint(verificationCode);
                CheckForError(xml, "AlreadyModerated", "This post has already being moderated and removed.");
            }
            finally
            {
                DeleteFailPost();
                ClearAllEmails();
                RemoveVerificationTemplate();
            }

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstWithBBCEmailInternal_CorrectModId()
        {

            try
            {
                var complaintText = Guid.NewGuid().ToString();
                var complaintReason = "a reason";
                var email = "a@bbc.co.uk";
                var complaintUrl = "";
                var anonymous = true;
                Guid verificationCode = Guid.Empty;

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous, false, true);

                int modId = -1;
                CheckForValidResponse(xml, out modId, "usercomplaint.xsd");
                CheckDatabaseEntry(modId, complaintText, email, 0, _postId, complaintUrl, anonymous);
                CheckEmailWasSent("From: " + email, complaintText);
            }
            finally
            {
                ClearAllEmails();
            }

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstPostMissingVerificationTemplate_CorrectDBEntriesModerationInQueue()
        {

            try
            {
                
                RemoveVerificationTemplate();

                var complaintText = Guid.NewGuid().ToString();
                var complaintReason = "a reason";
                var email = "a@b.com";
                var complaintUrl = "";
                var anonymous = true;
                var modId = 0;

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);
                Guid verificationCode = Guid.Empty;

                //no template submits the email anyway...
                CheckForValidResponse(xml, out modId, "usercomplaint.xsd");
                CheckDatabaseEntry(modId, complaintText, email, 0, _postId, complaintUrl, anonymous);
                ClearAllEmails();
            }
            finally
            {
                
                ClearAllEmails();
                RemoveVerificationTemplate();
            }

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstH2G2ID_CorrectDBEntriesAndResponse()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "a@b.com";
            var complaintUrl = "";
            var anonymous = true;

            var xml = PostComplaint(complaintText, complaintReason, email, _h2g2Id, 0, complaintUrl, anonymous);
            int modId = -1;


            CheckForValidResponse(xml, out modId, "usercomplaintarticle.xsd");
            CheckDatabaseEntry(modId, complaintText, email, _h2g2Id, 0, complaintUrl, anonymous);
            CheckEmailWasSent("From: " + email, complaintText);

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidAnonymousComplaintAgainstUrl_CorrectDBEntriesAndResponse()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "a@b.com";
            var complaintUrl = "http://www.bbc.co.uk/complaint/";
            var anonymous = true;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, 0, complaintUrl, anonymous);
            int modId = -1;


            CheckForValidResponse(xml, out modId, "usercomplainturl.xsd");
            CheckDatabaseEntry(modId, complaintText, email, 0, 0, complaintUrl, anonymous);
            CheckEmailWasSent("From: " + email, complaintText);

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void UserComplaint_MissingComplaintText_CorrectError()
        {
            var complaintText = "";
            var complaintReason = "a reason";
            var email = "a@b.com";
            var complaintUrl = "";
            var anonymous = true;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);


            CheckForError(xml, "COMPLAINTTEXT", "No complaint text");

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void UserComplaint_MissingComplaintReason_CorrectError()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "";
            var email = "a@b.com";
            var complaintUrl = "";
            var anonymous = true;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);


            CheckForError(xml, "COMPLAINTREASON", "No complaint reason");

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void UserComplaint_MissingEmailForAnonymous_CorrectError()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "";
            var complaintUrl = "";
            var anonymous = true;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);


            CheckForError(xml, "EMAIL", "Invalid email address");

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void UserComplaint_InvalidEmailForAnonymous_CorrectError()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "notanemail";
            var complaintUrl = "";
            var anonymous = true;

            var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);


            CheckForError(xml, "EMAIL", "Invalid email address");

        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void UserComplaint_BannedEmail_CorrectError()
        {
            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "ComplainBannedOnly@Test.com";

            var url = String.Format("UserComplaintPage?action=submit&skin=purexml");

            var request = new DnaTestURLRequest(_siteName);
            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("complainttext", complaintText));
            postParams.Enqueue(new KeyValuePair<string, string>("complaintreason", complaintReason));
            postParams.Enqueue(new KeyValuePair<string, string>("email", email));
            postParams.Enqueue(new KeyValuePair<string, string>("postid", _postId.ToString()));
            request.RequestPage(url, postParams);


            CheckForError(request.GetLastResponseAsXML(), "EMAILNOTALLOWED", "Not allowed to complain");

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        [TestMethod]
        public void UserComplaint_ValidComplaintAgainstPostWithoutTemplates_CorrectDBEntriesAndError()
        {


            var complaintText = Guid.NewGuid().ToString();
            var complaintReason = "a reason";
            var email = "a@b.com";
            var complaintUrl = "";
            var anonymous = false;

            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY("delete from emailtemplates where name='UserComplaintEmail'");
                }

                var xml = PostComplaint(complaintText, complaintReason, email, 0, _postId, complaintUrl, anonymous);
                int modId = -1;

                CheckForValidResponse(xml, out modId, "usercomplaint.xsd");
                CheckDatabaseEntry(modId, complaintText, email, 0, _postId, complaintUrl, anonymous);
                CheckEmailWasSent("Error: Unable to send complaint receipt to user - missing template", complaintText);
            }
            finally
            {
                SnapshotInitialisation.ForceRestore();
            }

        }




        private void CheckForValidResponse(XmlDocument xml, out int modId, string schema)
        {
            modId = -1;

            var complaintNode = xml.SelectSingleNode("//H2G2/USERCOMPLAINT");
            Assert.IsNotNull(complaintNode);

            DnaXmlValidator validator = new DnaXmlValidator(Entities.ReplaceEntitiesWithNumericValues(complaintNode.OuterXml), schema);
            validator.Validate();

            modId = Int32.Parse(complaintNode.Attributes["MODID"].Value);
            Assert.IsTrue(modId > 0);

        }

        private void CheckForValidVerificationResponse(XmlDocument xml, out Guid verificationCode, string schema, string email)
        {
            verificationCode = Guid.Empty;

            var complaintNode = xml.SelectSingleNode("//H2G2/USERCOMPLAINT");
            Assert.IsNotNull(complaintNode);

            DnaXmlValidator validator = new DnaXmlValidator(Entities.ReplaceEntitiesWithNumericValues(complaintNode.OuterXml), schema);
            validator.Validate();

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(@"
                    exec openemailaddresskey
                    select * from ThreadModAwaitingEmailVerification where dbo.udf_decryptemailaddress(EncryptedCorrespondenceEmail,PostID)='" + email + "' and postid=" + _postId.ToString());
                Assert.IsTrue(dataReader.Read());

                verificationCode = dataReader.GetGuid("ID");
            }
        }

        private void CheckDatabaseEntry(int modId, string complaintText, string email, int h2g2id,
            int postid, string complaintUrl, bool anonymous)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                string sql = @"
                        exec openemailaddresskey
                        select dbo.udf_decryptemailaddress(EncryptedCorrespondenceEmail,ModID) as CorrespondenceEmail,*
                            from <table> 
                            where modid=" + modId;

                if (h2g2id != 0)
                {
                    sql = sql.Replace("<table>", "articlemod");
                }
                else if (postid != 0)
                {
                    sql = sql.Replace("<table>", "threadmod");
                }
                else if (!String.IsNullOrEmpty(complaintUrl))
                {
                    sql = sql.Replace("<table>", "generalmod");
                }

                dataReader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(dataReader.HasRows);
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual(complaintText, dataReader.GetStringNullAsEmpty("ComplaintText"));

                if (h2g2id != 0)
                {
                    Assert.AreEqual(h2g2id, dataReader.GetInt32NullAsZero("h2g2id"));
                }
                else if (postid != 0)
                {
                    Assert.AreEqual(postid, dataReader.GetInt32NullAsZero("postid"));
                }
                else if (!String.IsNullOrEmpty(complaintUrl))
                {
                    Assert.AreEqual(complaintUrl, dataReader.GetStringNullAsEmpty("url"));
                }

                if (anonymous)
                {
                    Assert.AreEqual(email, dataReader.GetStringNullAsEmpty("CorrespondenceEmail"));
                }
                else
                {
                    Assert.AreNotEqual(0, dataReader.GetInt32NullAsZero("ComplainantID"));
                }

            }
        }


        private void CheckForError(XmlDocument xml, string expectedType, string expectedText)
        {
            var errorNode = xml.DocumentElement.SelectSingleNode("//H2G2/ERROR");
            Assert.IsNotNull(errorNode);

            DnaXmlValidator validator = new DnaXmlValidator(Entities.ReplaceEntitiesWithNumericValues(errorNode.OuterXml), "error.xsd");
            validator.Validate();

            Assert.AreEqual(expectedType, errorNode.Attributes["TYPE"].Value);
            Assert.AreEqual(expectedText, errorNode.SelectSingleNode("ERRORMESSAGE").InnerXml);
        }

        private XmlDocument PostComplaint(string complainttext, string complaintreason, string email, int h2g2id,
            int postid, string complaintUrl, bool anonymous)
        {
            return PostComplaint(complainttext, complaintreason, email, h2g2id,postid, complaintUrl, anonymous, false, false);
        }

        private XmlDocument PostComplaint(string complainttext, string complaintreason, string email, int h2g2id,
            int postid, string complaintUrl, bool anonymous, bool useEditorAccount, bool internalCode)
        {
            var url = String.Format("UserComplaintPage?action=submit&skin=purexml");
            if (internalCode)
            {
                url += "&_bbc_=1";
            }

            var request = new DnaTestURLRequest(_siteName);
            if (!anonymous)
            {
                if (useEditorAccount)
                {
                    request.SetCurrentUserEditor();
                }
                else
                {
                    request.SetCurrentUserNormal();
                }
            }
            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("complainttext", complainttext));
            postParams.Enqueue(new KeyValuePair<string, string>("complaintreason", complaintreason));
            if (anonymous)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("email", email));
            }
            if (h2g2id != 0)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("h2g2id", h2g2id.ToString()));
            }
            else if (postid != 0)
            {
                postParams.Enqueue(new KeyValuePair<string, string>("postid", postid.ToString()));
            }
            else if (!String.IsNullOrEmpty(complaintUrl))
            {
                postParams.Enqueue(new KeyValuePair<string, string>("url", complaintUrl));
            }
            request.RequestPage(url, postParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument PostVerificationComplaint(Guid verificationCode)
        {
            var url = String.Format("UserComplaintPage?skin=purexml&verificationcode=" + verificationCode.ToString());

            var request = new DnaTestURLRequest(_siteName);
            request.RequestPage(url);
            return request.GetLastResponseAsXML();
        }

        private void CheckEmailWasSent(string subject, string expectedInEmail)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("EXEC openemailaddresskey; select top 1 subject = dbo.udf_decrypttext(subject, ID), body = dbo.udf_decrypttext(body, ID) from emailqueue ORDER BY ID Desc");
                Assert.IsTrue(dataReader.Read());
                Assert.IsTrue(dataReader.HasRows);
                Assert.AreEqual(subject, dataReader.GetString("subject"));
                Assert.IsTrue(dataReader.GetString("body").Contains(expectedInEmail));
            }
        }

        private void ClearAllEmails()
        {
            DirectoryInfo dir = new DirectoryInfo(TestConfig.GetConfig().GetRipleyConfSetting("CACHEROOT") + "failedmails");

            if (dir.Exists)
            {
                foreach (var file in dir.GetFiles())
                {
                    file.Delete();
                }
            }
            
        }

        private void AddVerificationTemplate()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("delete from emailtemplates where name='UserComplaintEmailVerification'");
                dataReader.ExecuteDEBUGONLY("insert into emailtemplates (subject, body, name, modclassid) values ('UserComplaintEmailVerification','http://www.bbc.co.uk/dna/++**urlname**++/?verificationcode=++**verificationcode**++', 'UserComplaintEmailVerification', " + _modClassId.ToString() + ")");
                
            }
        }

        private void RemoveVerificationTemplate()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("delete from emailtemplates where name='UserComplaintEmailVerification'");
            }
        }

        private void FailPost()
        {
            var date = "GetDate()";
            using (IDnaDataReader reader = StoredProcedureReader.Create(""))
            {
                var sql = "";
                var rowNames = "[PostID],[DateQueued],[NewPost],[Notes],[SiteID], [Status]";
                var values = "{0}, {1}, {2},'{3}', {4},{5}";

                sql = string.Format("INSERT INTO threadmod" +
                     "(" + rowNames + ")" +
                     "VALUES (" + values + ")"
                     , _postId, date, '1', "failed", _siteId, 4);

                reader.ExecuteDEBUGONLY(sql);
            }
        }

        private void DeleteFailPost()
        {
            
            using (IDnaDataReader reader = StoredProcedureReader.Create(""))
            {
                reader.ExecuteDEBUGONLY("delete from threadmod where postid=" + _postId.ToString());
            }
        }


    }
}
