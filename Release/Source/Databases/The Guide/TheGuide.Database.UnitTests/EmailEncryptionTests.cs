using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Configuration;
using System.Transactions;
using BBC.Dna.Data;
using System.Data.SqlTypes;

namespace TheGuide.Database.UnitTests
{
    class EmailValues
    {
        public string DecryptedEmail { get; set; }
        public SqlBinary EncryptedEmail { get; set; }
        public SqlBinary HashedEmail { get; set; }
    }

    class GuideEntryInfo
    {
        public int EntryId { get; set; }
        public int Editor { get; set; }
    }

    [TestClass]
    public class EmailEncryptionTests
    {
        string ConnectionDetails { get; set; }
        string NL = Environment.NewLine;

        public EmailEncryptionTests()
        {
            ConnectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        #region General tests
        
        [TestMethod]
        public void EmailEnc_TestUpdate()
        {
            // The trigger on the user table should automatically update the HashedEmailAddress column when EncryptedEmailAddress changes

            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Setting the email address to NULL should set all associated columns to NULL
                    UpdateUserEmailAddress(reader, 6, null);
                    var emailValues = GetUserEmailValues(reader, 6);
                    Assert.IsNull(emailValues.DecryptedEmail);
                    Assert.IsTrue(emailValues.EncryptedEmail.IsNull);   // This array can vary in length
                    Assert.IsTrue(emailValues.HashedEmail.IsNull);    // SHA1 hashes are 160 bit, which is 20 bytes

                    // Try it with an actual email address
                    UpdateUserEmailAddress(reader, 6, "atest@email.co.uk");
                    emailValues = GetUserEmailValues(reader, 6);
                    Assert.AreEqual("atest@email.co.uk", emailValues.DecryptedEmail);
                    Assert.IsTrue(emailValues.EncryptedEmail.Length > 0);   // This array can vary in length
                    Assert.IsTrue(emailValues.HashedEmail.Length == 20);    // SHA1 hashes are 160 bit, which is 20 bytes
                }
            }
        }


        [TestMethod]
        public void EmailEnc_CheckUserTable_NewUser()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int userId = CreateNewUser(reader, "mark.neves@bbc.co.uk");
                    EmailValues emailValues = GetUserEmailValues(reader, userId);

                    Assert.AreEqual("mark.neves@bbc.co.uk", emailValues.DecryptedEmail);
                    Assert.IsTrue(emailValues.EncryptedEmail.Length > 0);   // This array can vary in length
                    Assert.IsTrue(emailValues.HashedEmail.Length == 20);    // SHA1 hashes are 160 bit (20 bytes)
                }
            }
        }

        #endregion

        #region Stored Proc tests

        [TestMethod]
        public void EmailEnc_Test_acceptscoutrecommendation()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Set up the database before calling acceptscoutrecommendation
                    reader.ExecuteWithinATransaction("delete AcceptedRecommendations where recommendationid=1");
                    int entryId = FindGuideEntry(reader);
                    var geInfo = GetGuideEntryInfo(reader,entryId);
                    reader.ExecuteWithinATransaction("update ScoutRecommendations set entryid="+entryId+",scoutid=6 where recommendationid=1");
                    UpdateUserEmailAddress(reader,6,"scout@test.com");
                    UpdateUserEmailAddress(reader,geInfo.Editor,"editor@test.com");

                    // Execute acceptscoutrecommendation
                    reader.ExecuteWithinATransaction("exec acceptscoutrecommendation 1,6,'A comment'");
                    reader.Read();

                    Assert.AreEqual("scout@test.com",reader.GetString("ScoutEmail"));
                    Assert.AreEqual("editor@test.com",reader.GetString("AuthorEmail"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_addemailtobannedlist()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    AddEmailToBannedList(reader, "ABannedEmail@address.com",0,0);

                    string sql=@"EXEC addemailtobannedlist @email='ABannedEmail@address.com', @signinbanned =0, @complaintbanned =0, @editorid = 6";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Close();

                    reader.ExecuteWithOpenKey("select top 1 dbo.udf_decryptemailaddress(EncryptedEmail,0) AS DecryptedEmail,* from BannedEmails order by DateAdded desc");
                    reader.Read();

                    var decryptedEmail = reader.GetString("DecryptedEmail");
                    var encryptedEmail = reader.GetSqlBinary("EncryptedEmail");
                    var hashedEmail = reader.GetSqlBinary("HashedEmail");

                    Assert.AreEqual("ABannedEmail@address.com",decryptedEmail);
                    Assert.AreEqual(HashEmailAddress(reader, "ABannedEmail@address.com"), hashedEmail);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_createnewuserforforum()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("select top 1 forumid from commentforums order by forumid desc");
                    reader.Read();
                    var forumId = reader.GetInt32("ForumId");
                    reader.Close();

                    string sql = string.Format(@"EXEC createnewuserforforum {0},@username = 'Test User',@email = 'emailEnc@test.net',@siteid = 1,@displayname = 'Yo!'", forumId);
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();

                    var email = reader.GetString("email");
                    Assert.AreEqual("emailEnc@test.net", email);
                }
            }
        }


        [TestMethod]
        public void EmailEnc_Test_createnewuserfromuserid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int userId = GetNextUserId(reader);

                    string sql = string.Format(@"EXEC createnewuserfromuserid {0},@loginname ='Test',@email ='groucho@marx.com',@siteid = 1", userId);
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var email = reader.GetString("email");
                    Assert.AreEqual("groucho@marx.com", email);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_deletewatchedusers()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 6, "eh@up.com");
                    reader.ExecuteWithinATransaction("exec deletewatchedusers @userid =6,@watch1=6");
                    reader.Read();
                    var email = reader.GetString("email");
                    Assert.AreEqual("eh@up.com", email);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_doesemailexist()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 6, "kenny@dalglish.com");
                    reader.ExecuteWithinATransaction("exec doesemailexist @email='kenny@dalglish.com'");
                    reader.Read();
                    var userid = reader.GetInt32("userid");
                    Assert.AreEqual(6, userid);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetchandupdatesubsunnotifiedallocations()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    string sql = @"select ar.*,j.siteid from AcceptedRecommendations ar" + NL +
                                    "INNER JOIN GuideEntries AS G ON G.EntryID = AR.EntryID" + NL +
                                    "join users u on userid=ar.subeditorid" + NL +
                                    "INNER JOIN Journals J on J.UserID = U.UserID";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var subEditorId = reader.GetInt32("SubEditorID");
                    var siteId = reader.GetInt32("Siteid");
                    reader.Close();

                    UpdateUserEmailAddress(reader, subEditorId, "woof@bark.dog");
                    reader.ExecuteWithinATransaction("exec fetchandupdatesubsunnotifiedallocations @subid ="+subEditorId+", @currentsiteid = "+siteId);
                    reader.Read();
                    var subEmail = reader.GetString("SubEmail");
                    Assert.AreEqual("woof@bark.dog", subEmail);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetcharticlemoderationhistory()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Set up email address on complainant
                    UpdateUserEmailAddress(reader, 6, "federer@knockedout.com");

                    // Insert entry into mod queue,
                    int h2g2Id = InsertIntoArticleMod(6, 0, 6, "nasty@disease.com");

                    // Fetch history, and check complainant's email address
                    reader.ExecuteWithinATransaction("exec fetcharticlemoderationhistory " + h2g2Id);
                    reader.Read();
                    var complainantEmail = reader.GetString("ComplainantEmail");
                    var correspondenceEmail = reader.GetString("CorrespondenceEmail");

                    Assert.AreEqual("federer@knockedout.com", complainantEmail);
                    Assert.AreEqual("nasty@disease.com", correspondenceEmail);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetcharticlereferralsbatch()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Insert entry into mod queue,
                    InsertIntoArticleMod(6, 2, 6, "texan@bigmouth.com");

                    // Fetch history, and check complainant's email address
                    reader.ExecuteWithinATransaction("exec fetcharticlereferralsbatch 6,1,1");
                    reader.Read();
                    var correspondenceEmail = reader.GetString("CorrespondenceEmail");

                    Assert.AreEqual("texan@bigmouth.com", correspondenceEmail);
                }
            }
        }

        int InsertIntoArticleMod(int complainantId, int status, int lockedBy, string correspondenceEmail)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
            {
                // Find a GuideEntry
                string sql = @"select top 1 h2g2id, siteid from guideentries g inner join users u on u.userid=g.editor order by entryid desc";
                reader.ExecuteWithinATransaction(sql);
                reader.Read();
                var h2g2Id = reader.GetInt32("h2g2id");
                var siteId = reader.GetInt32("siteid");
                reader.Close();

                string sqlFormat = @"
                    DECLARE @modid int;
                    INSERT INTO ArticleMod ([h2g2ID],[ComplainantID],[SiteID],status,lockedBy) VALUES ({0},{1},{2},{3},{4});
                    SET @ModId = SCOPE_IDENTITY();
                    EXEC openemailaddresskey;
                    UPDATE ArticleMod SET EncryptedCorrespondenceEmail=dbo.udf_encryptemailaddress('{5}',@ModId) WHERE Modid=@ModID;
                    ";

                sql = string.Format(sqlFormat, h2g2Id, complainantId, siteId, status, lockedBy, correspondenceEmail);
                reader.ExecuteWithinATransaction(sql);

                return h2g2Id;
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetchpostmoderationhistory_NoHistory()
        {
            EmailEnc_Test_fetchpostmoderationhistory_Internal(false);
        }

        [TestMethod]
        public void EmailEnc_Test_fetchpostmoderationhistory_withhistory()
        {
            EmailEnc_Test_fetchpostmoderationhistory_Internal(true);
        }

        void EmailEnc_Test_fetchpostmoderationhistory_Internal(bool withHistory)
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Set up email address on complainant
                    UpdateUserEmailAddress(reader, 6, "homer@simpson.com");

                    string sql = @"select top 1 modid, postid" + NL +
                                    "from ThreadMod TM" + NL +
                                    "inner join ThreadEntries TE on TE.EntryID = TM.PostID" + NL +
                                    "inner join Users U1 on U1.UserID = TE.UserID" + NL;
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var modId = reader.GetInt32("modid");
                    var postId = reader.GetInt32("postid");
                    reader.Close();

                    // Set up the complainant who has the email address we want to test
                    reader.ExecuteWithinATransaction("update threadmod set complainantid=6 where postid=" + postId);

                    // Clear the mod history by default
                    reader.ExecuteWithinATransaction("delete threadmodhistory");

                    if (withHistory)
                    {
                        // Add in a history item for this mod entry, to exercise the "history" branch of the SP
                        reader.ExecuteWithinATransaction("INSERT dbo.ThreadModHistory (ModId) VALUES (" + modId + ")");
                    }

                    reader.ExecuteWithinATransaction("exec fetchpostmoderationhistory " + postId);
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        var complainantEmail = reader.GetString("complainantEmail");
                        Assert.AreEqual("homer@simpson.com", complainantEmail);
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetchrecommendationdetails()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int recId, entryId;
                    EmailEnc_SetUp_fetchrecommendationdetails(reader, out recId, out entryId);

                    reader.ExecuteWithinATransaction("EXEC fetchrecommendationdetails " + recId);
                    reader.Read();

                    Assert.AreEqual("scout@email.address",reader.GetString("ScoutEmail"));
                    Assert.AreEqual("editor@email.address",reader.GetString("EditorEmail"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetchrecommendationdetailsfromentryid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    int recId, entryId;
                    EmailEnc_SetUp_fetchrecommendationdetails(reader, out recId, out entryId);

                    reader.ExecuteWithinATransaction("EXEC fetchrecommendationdetailsfromentryid " + entryId);
                    reader.Read();

                    Assert.AreEqual("scout@email.address",reader.GetString("ScoutEmail"));
                }
            }
        }
        

        void EmailEnc_SetUp_fetchrecommendationdetails(IDnaDataReader reader, out int recId, out int entryId)
        {
            // Find a Scout Recommendation that matches the SP's join requirements
            string sql = @"select top 1 RecommendationID, SR.EntryId" + NL +
                            "from ScoutRecommendations SR" + NL +
                            "inner join GuideEntries G on G.EntryID = SR.EntryID" + NL +
                            "inner join Users U1 on U1.UserID = SR.ScoutID" + NL +
                            "inner join Users U2 on U2.UserID = G.Editor" + NL +
                            "INNER JOIN Journals J1 on J1.UserID = U1.UserID and J1.SiteID = G.SiteID" + NL +
                            "INNER JOIN Journals J2 on J2.UserID = U2.UserID and J2.SiteID = G.SiteID";
            reader.ExecuteWithinATransaction(sql);
            reader.Read();
            recId = reader.GetInt32("RecommendationID");
            entryId = reader.GetInt32("EntryId");
            reader.Close();

            // Set up the scout and editor user ids to something predictable
            reader.ExecuteWithinATransaction("UPDATE ScoutRecommendations SET ScoutId=42 WHERE RecommendationID=" + recId);
            reader.ExecuteWithinATransaction("UPDATE GuideEntries SET Editor=6 WHERE EntryId=" + entryId);

            // Set up the email adresses in the user accounts
            UpdateUserEmailAddress(reader, 42, "scout@email.address");
            UpdateUserEmailAddress(reader, 6, "editor@email.address");

            reader.Close();
        }

        [TestMethod]
        public void EmailEnc_Test_fetchsubeditorsdetails()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("exec fetchsubeditorsdetails 1,0,2");
                    Assert.IsTrue(reader.HasRows);

                    var userIds = new List<int>();
                    while (reader.Read())
                    {
                        userIds.Add(reader.GetInt32("UserId"));
                    }
                    reader.Close();

                    var usersAndEmails = from u in userIds
                                         select new { UserId = u, Email = "MrTickle"+u+"@MrMen.com" };

                    foreach (var ue in usersAndEmails)
                    {
                        UpdateUserEmailAddress(reader, ue.UserId, ue.Email);
                    }

                    reader.ExecuteWithinATransaction("exec fetchsubeditorsdetails 1,0,2");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        string expectedmail = usersAndEmails.First(x => x.UserId == reader.GetInt32("UserId")).Email;
                        Assert.AreEqual(expectedmail, reader.GetString("Email"));
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_fetchwatchedjournals()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Find a fav forum
                    string sql =    @"select top 1 fav.forumid, fav.userid"+NL+
                                    "from FaveForums fav"+NL+
                                    "INNER JOIN Forums fo WITH(NOLOCK) ON fo.ForumID = fav.ForumID"+NL+
                                    "where fo.siteid=1";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var forumId = reader.GetInt32("forumid");
                    var userId = reader.GetInt32("userid");
                    reader.Close();

                    // Make sure the journal owner is set up
                    reader.ExecuteWithinATransaction("update Forums set journalOwner= 42 where forumid=" + forumId);
                    UpdateUserEmailAddress(reader, 42, "geddylee@rules.com");

                    reader.ExecuteWithinATransaction("EXEC fetchwatchedjournals "+userId);
                    reader.Read();
                    Assert.AreEqual("geddylee@rules.com", reader.GetString("Email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_finduserfromemail()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Set up email addresses
                    UpdateUserEmailAddress(reader, 42, "bill@bryson.com");
                    UpdateUserEmailAddress(reader, 6, "notes@fromasmallisland.com");

                    // Also set up loginname, to exercise the 2nd part of the UNION ALL 
                    reader.ExecuteWithinATransaction("update users set loginname='bill@bryson.com' where userid=6");

                    reader.ExecuteWithinATransaction("exec finduserfromemail @email='bill@bryson.com'");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        switch (reader.GetInt32("UserId"))
                        {
                            case 6: Assert.AreEqual("notes@fromasmallisland.com", reader.GetString("Email")); break;
                            case 42: Assert.AreEqual("bill@bryson.com", reader.GetString("Email")); break;
                        }
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_finduserfromid_and_finduserfromidwithorwithoutmasthead()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    string sql =   @"select top 1 u.userid"+NL+
                                    "from Users U WITH(NOLOCK)"+NL+
                                    "INNER JOIN MastHeads m WITH(NOLOCK) on U.UserID = m.UserID AND m.SiteID = 1"+NL+
                                    "INNER JOIN UserTeams ut WITH(NOLOCK) ON ut.UserID = u.UserID AND ut.SiteID = 1"+NL+
                                    "INNER JOIN Teams t WITH(NOLOCK) ON ut.TeamID = t.TeamID"+NL+
                                    "INNER JOIN Sites s WITH(NOLOCK) ON s.SiteId = 1"+NL+
                                    "INNER JOIN Journals J WITH(NOLOCK) on J.UserID = u.UserID and J.SiteID = 1"+NL+
                                    "where u.status<>0";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var userId = reader.GetInt32("userid");
                    reader.Close();
                    
                    UpdateUserEmailAddress(reader, userId, "thebest@thebestbestman.dude.uk");

                    reader.ExecuteWithinATransaction("EXEC finduserfromid @userid="+userId+", @h2g2id = NULL, @siteid = 1");
                    reader.Read();
                    Assert.AreEqual("thebest@thebestbestman.dude.uk", reader.GetString("email"));
                    reader.Close();

                    reader.ExecuteWithinATransaction("EXEC finduserfromidwithorwithoutmasthead @userid=" + userId + ", @siteid = 1");
                    reader.Read();
                    Assert.AreEqual("thebest@thebestbestman.dude.uk", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getalertstosend()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    SetUpEmailEventQueue(reader);

                    UpdateUserEmailAddress(reader, 6, "thisis@horrendous.com");

                    reader.ExecuteWithinATransaction("EXEC getalertstosend");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        string email = reader.GetString("email");
                        Assert.AreEqual("thisis@horrendous.com", email);
                    }
                }
            }
        }

        void SetUpEmailEventQueue(IDnaDataReader reader)
        {
            string sql = @"

DECLARE @NodeType int, @ArticleType int, @ClubType int, @ForumType int, @ThreadType int, @PostType int, @UserType int, @VoteType int, @LinkType int, @TeamType int, @URLType int
EXEC SetItemTypeValInternal 'IT_NODE', @NodeType OUTPUT
EXEC SetItemTypeValInternal 'IT_H2G2', @ArticleType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB', @ClubType OUTPUT
EXEC SetItemTypeValInternal 'IT_FORUM', @ForumType OUTPUT
EXEC SetItemTypeValInternal 'IT_THREAD', @ThreadType OUTPUT
EXEC SetItemTypeValInternal 'IT_POST', @PostType OUTPUT
EXEC SetItemTypeValInternal 'IT_USER', @UserType OUTPUT
EXEC SetItemTypeValInternal 'IT_VOTE', @VoteType OUTPUT
EXEC SetItemTypeValInternal 'IT_LINK', @LinkType OUTPUT
EXEC SetItemTypeValInternal 'IT_CLUB_MEMBERS', @TeamType OUTPUT
EXEC SetItemTypeValInternal 'IT_URL', @URLType OUTPUT

-- Now get all the values for the different events that can happen
DECLARE @ArticleEdit int, @ArticleTagged int, @TaggedArticleEdited int, @ForumEdit int, @NewTeamMember int, @PostRepliedTo int, @NewThread int, @ThreadTagged int
DECLARE @UserTagged int, @ClubTagged int, @LinkAdded int, @VoteAdded int, @VoteRemoved int, @OwnerTeamChange int, @MemberTeamChange int, @MemberApplication int, @ClubEdit int, @NodeHidden int
EXEC SetEventTypeValInternal 'ET_ARTICLEEDITED', @ArticleEdit OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYARTICLETAGGED', @ArticleTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYARTICLEEDITED', @TaggedArticleEdited OUTPUT
EXEC SetEventTypeValInternal 'ET_FORUMEDITED', @ForumEdit OUTPUT
EXEC SetEventTypeValInternal 'ET_NEWTEAMMEMBER', @NewTeamMember OUTPUT
EXEC SetEventTypeValInternal 'ET_POSTREPLIEDTO', @PostRepliedTo OUTPUT
EXEC SetEventTypeValInternal 'ET_POSTNEWTHREAD', @NewThread OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYTHREADTAGGED', @ThreadTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYUSERTAGGED', @UserTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYCLUBTAGGED', @ClubTagged OUTPUT
EXEC SetEventTypeValInternal 'ET_NEWLINKADDED', @LinkAdded OUTPUT
EXEC SetEventTypeValInternal 'ET_VOTEADDED', @VoteAdded OUTPUT
EXEC SetEventTypeValInternal 'ET_VOTEREMOVED', @VoteRemoved OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBOWNERTEAMCHANGE', @OwnerTeamChange OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBMEMBERTEAMCHANGE', @MemberTeamChange OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBMEMBERAPPLICATIONCHANGE', @MemberApplication OUTPUT
EXEC SetEventTypeValInternal 'ET_CLUBEDITED', @ClubEdit OUTPUT
EXEC SetEventTypeValInternal 'ET_CATEGORYHIDDEN', @NodeHidden OUTPUT

declare @uid uniqueidentifier,@ItemID int,@ItemType int,@EventType int,@ItemID2 int,@ItemType2 int,@NotifyType int
set @uid=newid()

-- Set up the email alert lists
INSERT INTO [dbo].[EMailAlertList] ([EMailAlertListID],[UserID],[CreatedDate],[LastUpdated],[SiteID]) VALUES (@uid, 6, getdate(), getdate(),1)
INSERT INTO [dbo].InstantEMailAlertList (InstantEMailAlertListID,[UserID],[CreatedDate],[LastUpdated],[SiteID]) VALUES (@uid, 6, getdate(), getdate(),1)

-- Now insert a bunch of email event queue items to test the various branches

-- case 1 & 2
select top 1 @ItemID =h.nodeid,@ItemType =@NodeType,@EventType =@UserTagged,@ItemID2 =0,@ItemType2 =0,@NotifyType =0
	from Hierarchy h
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 3 & 4
-- can't be done because inner joins on threads where threadid=0

--case 5 & 6
select top 1 @ItemID =f.forumid,@ItemType =@ForumType,@EventType =@ForumEdit,@ItemID2 =t.threadid,@ItemType2 =@ThreadType,@NotifyType =0
	from forums f
	join threads t on t.forumid=f.forumid
	where t.VisibleTo IS NULL
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 7 & 8
select top 1 @ItemID =t.threadid,@ItemType =@ThreadType,@EventType =@PostRepliedTo,@ItemID2 =te.entryid,@ItemType2 =@PostType,@NotifyType =0
	from forums f
	join threads t on t.forumid=f.forumid
	join threadentries te on te.threadid=t.threadid
	where t.VisibleTo IS NULL and te.hidden is null
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 9 & 10
select top 1 @ItemID =h.nodeid,@ItemType =@NodeType,@EventType =@ThreadTagged,@ItemID2 =t.threadid,@ItemType2 =@ThreadType,@NotifyType =0
	from forums f
	join hierarchy h on nodeid=nodeid
	join threads t on t.forumid=f.forumid
	where t.VisibleTo IS NULL
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 11, 12, 13, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28 - clubs, not in use so not tested

-- case 15 & 16
select top 1 @ItemID =h.nodeid,@ItemType =@NodeType,@EventType =@ArticleTagged,@ItemID2 =g.h2g2id,@ItemType2 =@ArticleType,@NotifyType =0
	from hierarchy h, guideentries g
	where g.hidden IS NULL
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 17 & 18
select top 1 @ItemID =g.h2g2id,@ItemType =@ArticleType,@EventType =@ArticleEdit,@ItemID2 =0,@ItemType2 =0,@NotifyType =0
	from guideentries g
	where g.hidden IS NULL
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 19 & 20
select top 1 @ItemID =g.h2g2id,@ItemType =@ArticleType,@EventType =@ArticleEdit,@ItemID2 =0,@ItemType2 =0,@NotifyType =0
	from guideentries g
	where g.hidden IS NULL
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)

-- case 29 & 30
select top 1 @ItemID =h.nodeid,@ItemType =0,@EventType =@NodeHidden,@ItemID2 =h.nodeid,@ItemType2 =0,@NotifyType =0
	from hierarchy h
INSERT INTO [dbo].[EMailEventQueue] ([ListID],[SiteID],[ItemID],[ItemType],[EventType],[EventDate],[ItemID2],[ItemType2],[NotifyType],[EventUserID],[IsOwner])
     VALUES (@uid,1,@ItemID,@ItemType,@EventType,getdate(),@ItemID2,@ItemType2,@NotifyType,6,1)";

            reader.ExecuteWithinATransaction(sql);
            reader.Close();
        }

        [TestMethod]
        public void EmailEnc_Test_getbannedemails()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("delete bannedEmails");
                    AddEmailToBannedList(reader, "trying@justtheone.com",0,0);

                    reader.ExecuteWithinATransaction("Exec getbannedemails 0,1000,1,1,1");
                    reader.Read();
                    Assert.AreEqual("trying@justtheone.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getbannedemailsstartingwithletter()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("delete bannedEmails");
                    AddEmailToBannedList(reader, "trying@afew.com",0,0);
                    AddEmailToBannedList(reader, "whichstart@withdifferent.com",0,0);
                    AddEmailToBannedList(reader, "letters@dot.com",0,0);
                    AddEmailToBannedList(reader, "whatever@dot.com",0,0);

                    var emails = reader.ExecuteGetStrings("email", "Exec getbannedemailsstartingwithletter 0,1000,'t',1,1,1");
                    Assert.AreEqual(1, emails.Count);
                    Assert.AreEqual("trying@afew.com", emails[0]);

                    emails = reader.ExecuteGetStrings("email", "Exec getbannedemailsstartingwithletter 0,1000,'w',1,1,1");
                    Assert.AreEqual(2, emails.Count);
                    Assert.IsTrue(emails.Contains("whichstart@withdifferent.com"));
                    Assert.IsTrue(emails.Contains("whatever@dot.com"));

                    emails = reader.ExecuteGetStrings("email", "Exec getbannedemailsstartingwithletter 0,1000,'l',1,1,1");
                    Assert.AreEqual(1, emails.Count);
                    Assert.AreEqual("letters@dot.com", emails[0]);

                    emails = reader.ExecuteGetStrings("email", "Exec getbannedemailsstartingwithletter 0,1000,'z',1,1,1");
                    Assert.AreEqual(0, emails.Count);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmatchinguseraccounts()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 6, "postits@rule.com");
                    UpdateUserEmailAddress(reader, 42, "especiallythe@yellowones.com");

                    reader.ExecuteWithinATransaction("getmatchinguseraccounts null, null, 'postits@rule.com'");
                    reader.Read();
                    Assert.AreEqual(6, reader.GetInt32("userid"));
                    Assert.AreEqual("postits@rule.com", reader.GetString("Email"));

                    reader.ExecuteWithinATransaction("getmatchinguseraccounts null, null, 'especiallythe@yellowones.com'");
                    reader.Read();
                    Assert.AreEqual(42, reader.GetInt32("userid"));
                    Assert.AreEqual("especiallythe@yellowones.com", reader.GetString("Email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmbstatshostspostspertopic()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Find any thread entry
                    var entryId = reader.ExecuteGetInts("entryid", "select top 1 entryid from threadentries")[0];

                    // Find a topic to attach the thread entry to
                    var sql = @"select top 1 g.forumid, t.siteid" + NL +
                            "from topics t" + NL +
                            "join guideentries g on g.h2g2id=t.h2g2id";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var siteId = reader.GetInt32("siteid");
                    var forumId = reader.GetInt32("forumid");
                    reader.Close();

                    // update the thread entry so that it's attached to the topic
                    sql = @"update te" + NL +
                            "    SET te.userid=6, te.dateposted='2011-06-29', te.forumid=" + forumId + NL +
                            "    from threadentries te" + NL +
                            "    where te.entryid = " + entryId;
                    reader.ExecuteWithinATransaction(sql);

                    // Make sure the user has an email address we can test
                    UpdateUserEmailAddress(reader, 6, "sharapova@grunts.com");

                    reader.ExecuteWithinATransaction("exec getmbstatshostspostspertopic "+siteId+",'2011-06-29'");
                    reader.Read();
                    Assert.AreEqual("sharapova@grunts.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmbstatsmodstatspertopic()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Find any thread entry
                    var entryId = reader.ExecuteGetInts("entryid","select top 1 entryid from threadentries")[0];

                    // Find a topic to attach the thread entry to
                    var sql = @"select top 1 g.forumid, t.siteid"+NL+
                            "from topics t" + NL +
                            "join guideentries g on g.h2g2id=t.h2g2id";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var siteId = reader.GetInt32("siteid");
                    var forumId = reader.GetInt32("forumid");
                    reader.Close();

                    // update the thread entry so that it's attached to the topic
                    sql =  @"update te" + NL +
                            "    SET te.userid=6, te.dateposted='2011-06-29', te.forumid="+forumId + NL +
                            "    from threadentries te" + NL +
                            "    where te.entryid = " + entryId;
                    reader.ExecuteWithinATransaction(sql);

                    // Associate a threadmod record to the thread entry
                    sql =  @"update tm" + NL +
                            "	set tm.forumid=te.forumid, tm.datequeued='2011-06-29',tm.lockedby=6" + NL +
                            "	from threadmod tm, threadentries te" + NL +
                            "	where tm.modid=(select min(modid) from threadmod) and te.entryid = "+entryId;
                    reader.ExecuteWithinATransaction(sql);

                    // Make sure the user has an email address we can test
                    UpdateUserEmailAddress(reader, 6, "andwe@loveit.com");

                    reader.ExecuteWithinATransaction("exec getmbstatsmodstatspertopic " + siteId + ",'2011-06-29'");
                    reader.Read();
                    Assert.AreEqual("andwe@loveit.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmoderationmemberdetails()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    string sql=@"SELECT	top 1 u.userid"+NL+
	                            "FROM Users u WITH(NOLOCK)"+NL+
	                            "INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID"+NL+
	                            "INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID"+NL+
	                            "INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID"+NL+
	                            "INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var userId = reader.GetInt32("userid");
                    reader.Close();

                    UpdateUserEmailAddress(reader, userId, "everybodyneeds@reversepolarity.com");

                    reader.ExecuteWithinATransaction("exec getmoderationmemberdetails @viewinguserid =6, @usertofindid ="+userId);
                    reader.Read();
                    Assert.AreEqual("everybodyneeds@reversepolarity.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmoderationmemberdetailsforbbcuid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    string sql = @"SELECT	top 1 u.userid" + NL +
                                "FROM Users u WITH(NOLOCK)" + NL +
                                "INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID" + NL +
                                "INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID" + NL +
                                "INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID" + NL +
                                "INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var userId = reader.GetInt32("userid");
                    reader.Close();

                    UpdateUserEmailAddress(reader, userId, "whygivemethat@funnyvibe.com");

                    sql=   @"update ThreadEntriesIPAddress set bbcuid=newid()"+NL+
                            "update threadentries set userid="+userId+NL+
                            "	from threadentries te"+NL+
                            "	join ThreadEntriesIPAddress ip on ip.entryid=te.entryid";
                    reader.ExecuteWithinATransaction(sql);

                    reader.ExecuteWithinATransaction("exec getmoderationmemberdetailsforbbcuid @viewinguserid =6, @usertofindid =" + userId);
                    reader.Read();
                    Assert.AreEqual("whygivemethat@funnyvibe.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmoderationnicknames()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Testing the Alternative account feature, which now matches on HashedEmail column
                    // Strategy:
                    //  Get a couple of nickname mod entries
                    //  Set the same email address on two different accounts, for each mod entry
                    //  Get the same nickname mod entries, and check it's picked up the alternative accounts

                    reader.ExecuteWithinATransaction("exec getmoderationnicknames @userid =6, @status  = 0, @alerts  = 0, @lockeditems  = 0, @issuperuser  = 0, @modclassid  = NULL, @show  = 2");
                    var userIds = new List<int>();
                    while (reader.Read())
                        userIds.Add(reader.GetInt32("userId"));
                    reader.Close();

                    UpdateUserEmailAddress(reader, userIds[0], "alt1@reality.com");
                    UpdateUserEmailAddress(reader, 6,          "alt1@reality.com");

                    UpdateUserEmailAddress(reader, userIds[1], "alt2@reality.com");
                    UpdateUserEmailAddress(reader, 42,         "alt2@reality.com");

                    reader.ExecuteWithinATransaction("exec getmoderationnicknames @userid =6, @status  = 0, @alerts  = 0, @lockeditems  = 0, @issuperuser  = 0, @modclassid  = NULL, @show  = 2");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        if (reader.GetInt32("userId") == userIds[0])
                        {
                            Assert.AreEqual(6, reader.GetInt32("AltUserId"));
                        }

                        if (reader.GetInt32("userId") == userIds[1])
                        {
                            Assert.AreEqual(42, reader.GetInt32("AltUserId"));
                        }
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmoderationposts_varients()
        {
            EmailEnc_Test_getmoderationposts_helper("getmoderationposts");
            EmailEnc_Test_getmoderationposts_helper("getmoderationpostsfastmodfirst");
            EmailEnc_Test_getmoderationposts_helper("getmoderationpostsmostrecentfirst");
        }

        void EmailEnc_Test_getmoderationposts_helper(string spName)
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var modIds = reader.ExecuteGetInts("modId","exec "+spName+" @userid =6, @status  = 0, @alerts  = 0,  @lockeditems  = 0, @fastmod  = 0, @issuperuser  = 1, @modclassid  = NULL, @postid  = NULL, @duplicatecomplaints  = 0, @show  = 10");

                    foreach (var modId in modIds)
                    {
                        reader.ExecuteWithinATransaction(@"
                                exec openemailaddresskey;
                                update threadmod set encryptedcorrespondenceemail=dbo.udf_encryptemailaddress('popsquits@theapprentice.com',"+modId+") where modid=" + modId);
                    }

                    UpdateUserEmailAddress(reader, 42, "popsquits@theapprentice.com");

                    reader.ExecuteWithinATransaction("exec " + spName + " @userid =6, @status  = 0, @alerts  = 0,  @lockeditems  = 0, @fastmod  = 0, @issuperuser  = 1, @modclassid  = NULL, @postid  = NULL, @duplicatecomplaints  = 0, @show  = 10");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        int modid = reader.GetInt32("modid");
                        Assert.AreEqual(42,reader.GetInt32("ComplainantIdViaEmail"));
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmoderatorinfo()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 6, "theflaming@lips.com");
                    reader.ExecuteWithinATransaction("EXEC getmoderatorinfo 6");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        Assert.AreEqual("theflaming@lips.com", reader.GetString("Email"));
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getmoderatorsforsite()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userIds = reader.ExecuteGetInts("userId", "exec getmoderatorsforsite 1");
                    foreach (var userId in userIds.Distinct())
                        UpdateUserEmailAddress(reader, userId, "frank@tortoise.com");

                    reader.ExecuteWithinATransaction("exec getmoderatorsforsite 1");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        Assert.AreEqual("frank@tortoise.com", reader.GetString("Email"));
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getrandomresearcher()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("select rand(1); exec getrandomresearcher");
                    reader.NextResult();
                    reader.Read();
                    var userId = reader.GetInt32("Userid");
                    reader.Close();

                    UpdateUserEmailAddress(reader, userId, "falafel@veggie.com");

                    reader.ExecuteWithinATransaction("select rand(1); exec getrandomresearcher");
                    reader.NextResult();
                    reader.Read();
                    Assert.AreEqual(userId, reader.GetInt32("userid"));
                    Assert.AreEqual("falafel@veggie.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_getrestricteduserlist()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userIds = reader.ExecuteGetInts("userId", "exec getrestricteduserlist @viewinguserid=6, @skip =0, @show =10, @usertypes =0, @siteid =0");
                    foreach (var userId in userIds)
                        UpdateUserEmailAddress(reader, userId, "dexter@happyslasher.com");

                    reader.ExecuteWithinATransaction("exec getrestricteduserlist @viewinguserid=6, @skip =0, @show =10, @usertypes =0, @siteid =0");
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        Assert.AreEqual("dexter@happyslasher.com", reader.GetString("email"));
                    }
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_gettrackedmemberdetails()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userIds = reader.ExecuteGetInts("userId", "select top 2 userid from preferences where siteid=1 and userid<>0");
                    UpdateUserEmailAddress(reader, userIds[0], "jennyagutter@corrblimey.com");
                    UpdateUserEmailAddress(reader, userIds[1], "jennyagutter@corrblimey.com");

                    reader.ExecuteWithinATransaction("exec gettrackedmemberdetails @siteid =1, @userid = " + userIds[0]);
                    reader.Read();
                    Assert.AreEqual("jennyagutter@corrblimey.com", reader.GetString("Email"));
                    reader.NextResult();
                    reader.Read();
                    Assert.AreEqual("jennyagutter@corrblimey.com", reader.GetString("Email"));
                    reader.Read();
                    Assert.AreEqual("jennyagutter@corrblimey.com", reader.GetString("Email"));
                }
            }
        }
        [TestMethod]
        public void EmailEnc_Test_getusernamefromid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "stevie@gerrard.com");
                    reader.ExecuteWithinATransaction("exec getusernamefromid @iuserid =42, @siteid =1");
                    reader.Read();
                    Assert.AreEqual("stevie@gerrard.com", reader.GetString("email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_isemailbannedfromcomplaints()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("delete bannedEmails");
                    AddEmailToBannedList(reader, "istanbul@numberfive.com",0,1);

                    reader.ExecuteWithinATransaction("exec isemailbannedfromcomplaints @email='istanbul@numberfive.com'");
                    reader.Read();
                    Assert.AreEqual(1, reader.GetInt32("IsBanned"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_isemailinbannedlist()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("delete bannedEmails");
                    AddEmailToBannedList(reader, "istanbul@numberfive.com", 1, 0);

                    reader.ExecuteWithinATransaction("exec isemailinbannedlist @email='istanbul@numberfive.com'");
                    reader.Read();
                    Assert.AreEqual(1, reader.GetInt32("IsBanned"));
                }
            }
        }
        [TestMethod]
        public void EmailEnc_Test_lookupemail()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "itzikbengan@bloodybigbrains.com");
                    reader.ExecuteWithinATransaction("update users set cookie=newid() where userid=42"); // make sure it has a cookie
                    reader.ExecuteWithinATransaction("exec lookupemail 'itzikbengan@bloodybigbrains.com'");
                    reader.Read();
                    Assert.AreEqual(42, reader.GetInt32("Userid"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_moderatearticle()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    FixUpModActionTable(reader);
                    reader.ExecuteWithinATransaction( @"select top 1 am.h2g2id,am.modid,g.editor from articlemod am"+NL+ 
                                                       "join guideentries g on g.h2g2id=am.h2g2id");
                    reader.Read();
                    var h2g2id = reader.GetInt32("h2g2id");
                    var modid = reader.GetInt32("modid");
                    var userid = reader.GetInt32("editor");
                    reader.Close();

                    UpdateUserEmailAddress(reader, userid, "lackof@imagination.com");

                    reader.ExecuteWithinATransaction("exec moderatearticle @h2g2id =" + h2g2id + ", @modid =" + modid + ", @status =3, @notes ='', @referto =NULL, @referredby =6");
                    reader.Read();
                    Assert.AreEqual("lackof@imagination.com",reader.GetString("AuthorsEmail"));
                    Assert.AreEqual(userid,reader.GetInt32("AuthorId"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_moderateimage()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "xfire@bestgamesever.com");

                    reader.ExecuteWithinATransaction("truncate table ImageMod");
                    reader.ExecuteWithinATransaction("truncate table imagelibrary");
                    reader.ExecuteWithinATransaction("insert imagelibrary values (42,'','')");
                    reader.ExecuteWithinATransaction(@"INSERT INTO [SmallGuide].[dbo].[ImageMod]([ImageID],[DateQueued],[DateLocked],[LockedBy],[Status],[Notes],[DateReferred],[DateCompleted],[ReferredBy],[ComplainantID],[CorrespondenceEmail],[ComplaintText],[SiteID])"+NL+
                                                         "VALUES(1,getdate(),null,null,0,'',null,null,null,null,null,'',1)");

                    reader.ExecuteWithinATransaction("exec moderateimage @imageid =1,@modid =1, @status =3, @notes ='', @referto =null, @referredby =6");
                    reader.Read();
                    Assert.AreEqual("xfire@bestgamesever.com",reader.GetString("AuthorsEmail"));
                    Assert.AreEqual(42,reader.GetInt32("AuthorId"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_moderatemediaasset_and_moderatemediaassetbyarticleid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "jan@molby.com");

                    // Test moderatemediaasset
                    reader.ExecuteWithinATransaction("truncate table MediaAssetMod");
                    reader.ExecuteWithinATransaction("truncate table mediaasset");
                    reader.ExecuteWithinATransaction(@"INSERT INTO [SmallGuide].[dbo].[MediaAssetMod]([MediaAssetID],[DateQueued],[DateLocked],[LockedBy],[Status],[Notes],[dateReferred],[datecompleted],[ReferredBy],[ComplainantID],[Email],[ComplaintText],[SiteID])" + NL +
                                                        "VALUES (1,getdate() ,null,null,0,'',null,null,null,null,'t@m.c','',1)");
                    reader.ExecuteWithinATransaction(@"INSERT INTO [SmallGuide].[dbo].[MediaAsset] ([SiteID],[Caption],[Filename],[MimeType],[ContentType],[ExtraElementXML],[OwnerID],[DateCreated],[LastUpdated],[Hidden],[Description],[FileSize],[ExternalLinkURL])" + NL +
                                                        "VALUES (1,'' ,'','',1 ,'',42 ,getdate(),getdate(),null,'',1,'')");

                    reader.ExecuteWithinATransaction("exec moderatemediaasset @modid =1, @status =2, @notes ='', @referto =null, @userid =6");
                    reader.Read();
                    Assert.AreEqual("jan@molby.com", reader.GetString("AuthorsEmail"));
                    Assert.AreEqual(42, reader.GetInt32("AuthorId"));
                    reader.Close();

                    // Test moderatemediaassetbyarticleid
                    reader.ExecuteWithinATransaction(@"select top 1 am.h2g2id,am.modid,g.entryid from articlemod am" + NL +
                                                        "join guideentries g on g.h2g2id=am.h2g2id");
                    reader.Read();
                    var modId = reader.GetInt32("modid");
                    var entryId = reader.GetInt32("entryid");
                    reader.Close();

                    reader.ExecuteWithinATransaction("insert ArticleMediaAsset values(" + entryId + "," + modId + ")");

                    reader.ExecuteWithinATransaction("exec moderatemediaassetbyarticleid @articlemodid ="+modId+", @status =3, @notes ='', @referto =null, @userid =6");
                    reader.Read();
                    Assert.AreEqual("jan@molby.com", reader.GetString("AuthorsEmail"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_moderatenickname()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("select top 1 modId, userId from NicknameMod");
                    reader.Read();
                    int modId = reader.GetInt32("ModId");
                    int userId = reader.GetInt32("UserId");
                    reader.Close();

                    UpdateUserEmailAddress(reader, userId, "legendofzelda@awesome.com");

                    reader.ExecuteWithinATransaction("exec moderatenickname @modid ="+modId+", @status =3");
                    reader.Read();
                    Assert.AreEqual("legendofzelda@awesome.com", reader.GetString("emailAddress"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_moderatepost()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    // Find at least one post that has more than one complaint in the db
                    // This is so the UNION ALL at the end that folds in the duplicate complaints is tested too
                    string sql = @"select postid,count(*) from threadmod" + NL +
                                  "where complainantid is not null AND DateCompleted IS NULL and status<>3" + NL +
                                  "group by postid" + NL +
                                  "having count(*)>1";
                    reader.ExecuteWithinATransaction(sql);
                    reader.Read();
                    var postId = reader.GetInt32("postid");
                    reader.Close();

                    reader.ExecuteWithinATransaction("select userid,forumid,threadid from threadentries where entryid=" + postId);
                    reader.Read();
                    var userId = reader.GetInt32("userid");
                    var forumid = reader.GetInt32("forumid");
                    var threadid = reader.GetInt32("threadid");
                    reader.Close();

                    UpdateUserEmailAddress(reader, userId, "theressomethingstrange@goingontonight.com");

                    sql = @"update threadmod set lockedby=6, status=1 " + NL +
                         "where postid="+postId+" and complainantid is not null AND DateCompleted IS NULL and status<>3";
                    reader.ExecuteWithinATransaction(sql);

                    sql=@"exec moderatepost @forumid =7619030, @threadid =1, @postid =1, "+NL+
                         "   @modid =2, @status =3, @notes ='', @referto =null, @referredby =6, @moderationstatus = 0, @emailtype =''";
                    reader.ExecuteWithinATransaction(sql);
                    // We're expecting at least two rows returned, which means dup complaints were found
                    reader.Read();
                    Assert.AreEqual("theressomethingstrange@goingontonight.com", reader.GetString("AuthorsEmail"));
                    reader.Read();
                    Assert.AreEqual("theressomethingstrange@goingontonight.com", reader.GetString("AuthorsEmail"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_rejectscoutrecommendation()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "linq@givesmeorgasms.com");

                    // Set up the first scout recommendation with a valid entryid, for scout 42
                    var entryIds = reader.ExecuteGetInts("entryid","select top 1 entryid from guideentries");
                    reader.ExecuteWithinATransaction("update ScoutRecommendations set status=1,entryid=" + entryIds[0] + ", scoutid=42 where recommendationid=1");

                    reader.ExecuteWithinATransaction("exec rejectscoutrecommendation @recommendationid =1,@comments = 'hello'");
                    reader.Read();
                    Assert.AreEqual("linq@givesmeorgasms.com", reader.GetString("ScoutEmail"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_removebannedemail()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var origCount = CountRowsInTable(reader, "BannedEMails");

                    AddEmailToBannedList(reader,"fuckme@itsfredtitmus.com",0,0);
                    Assert.AreEqual(origCount+1,CountRowsInTable(reader,"BannedEMails"));

                    reader.ExecuteWithinATransaction("exec removebannedemail @email='fuckme@itsfredtitmus.com'");
                    Assert.AreEqual(origCount, CountRowsInTable(reader, "BannedEMails"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchforuserviabbcuid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var guid = Guid.NewGuid();
                    reader.ExecuteWithinATransaction("insert threadentriesipaddress values (1,'','"+guid+"')");
                    var userIds = reader.ExecuteGetInts("userid", "select userid from threadentries where entryid=1");
                    UpdateUserEmailAddress(reader, userIds[0], "lounge@againstthemachine.com");

                    var emails = reader.ExecuteGetStrings("email", "exec searchforuserviabbcuid @viewinguserid =6, @bbcuid ='"+guid+"', @checkallsites =1");
                    foreach (var email in emails)
                        Assert.AreEqual("lounge@againstthemachine.com", email);

                    emails = reader.ExecuteGetStrings("email", "exec searchforuserviabbcuid @viewinguserid =6, @bbcuid ='" + guid + "', @checkallsites =0");
                    foreach (var email in emails)
                        Assert.AreEqual("lounge@againstthemachine.com", email);
                }
            }
        }

        int GetUserIdForSearchTests(IDnaDataReader reader)
        {
            string sql = @"select top 1 u.userid" + NL +
              "FROM Users u WITH(NOLOCK)" + NL +
              "INNER JOIN Preferences p WITH(NOLOCK) ON p.UserID = u.UserID" + NL +
              "INNER JOIN Mastheads m WITH(NOLOCK) ON m.UserID = u.UserID AND m.SiteID = p.SiteID" + NL +
              "INNER JOIN Sites s WITH(NOLOCK) ON s.SiteID = p.SiteID" + NL +
              "INNER JOIN Userstatuses us WITH(NOLOCK) ON us.UserStatusID = p.PrefStatus" + NL +
              "INNER JOIN SignInUserIdMapping sm WITH(NOLOCK) ON sm.DnaUserID = u.UserID" + NL +
              "WHERE s.siteid=1";
            return reader.ExecuteGetInts("userid", sql)[0];
        }

        [TestMethod]
        public void EmailEnc_Test_searchforuserviaemailinternal()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userId = GetUserIdForSearchTests(reader);

                    UpdateUserEmailAddress(reader, userId, "barrongreenback@dangermouse.com");

                    var emails = reader.ExecuteGetStrings("email", "exec searchforuserviaemailinternal @viewinguserid =6, @email ='barrongreenback@dangermouse.com', @checkallsites =1");
                    foreach (var email in emails)
                        Assert.AreEqual("barrongreenback@dangermouse.com", email);

                    emails = reader.ExecuteGetStrings("email", "exec searchforuserviaemailinternal @viewinguserid =6, @email ='barrongreenback@dangermouse.com', @checkallsites =0");
                    foreach (var email in emails)
                        Assert.AreEqual("barrongreenback@dangermouse.com", email);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchforuserviaipaddress()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("insert threadentriesipaddress values (1,'255.254.253.252',null)");
                    var userIds = reader.ExecuteGetInts("userid", "select userid from threadentries where entryid=1");
                    UpdateUserEmailAddress(reader, userIds[0], "shehatesme@tuxicity.com");

                    var emails = reader.ExecuteGetStrings("email", "exec searchforuserviaipaddress @viewinguserid =6, @ipaddress ='255.254.253.252', @checkallsites =1");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("shehatesme@tuxicity.com")));

                    emails = reader.ExecuteGetStrings("email", "exec searchforuserviaipaddress @viewinguserid =6, @ipaddress ='255.254.253.252', @checkallsites =0");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("shehatesme@tuxicity.com")));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchforuservialoginname()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userId = GetUserIdForSearchTests(reader);

                    UpdateUserEmailAddress(reader, userId, "nuns@gobowling.com");

                    reader.ExecuteWithinATransaction("update users set loginname='douglas adams' where userid=" + userId);

                    var emails = reader.ExecuteGetStrings("email", "exec searchforuservialoginname @viewinguserid =6, @loginname ='douglas adams', @checkallsites =1");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("nuns@gobowling.com")));

                    emails = reader.ExecuteGetStrings("email", "exec searchforuservialoginname @viewinguserid =6, @loginname ='douglas adams', @checkallsites =0");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("nuns@gobowling.com")));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchforuserviauserid()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userId = GetUserIdForSearchTests(reader);

                    UpdateUserEmailAddress(reader, userId, "asteroids@rocks.com");

                    var emails = reader.ExecuteGetStrings("email", "exec searchforuserviauserid @viewinguserid =6, @usertofindid =" + userId + ", @checkallsites =1");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("asteroids@rocks.com")));

                    emails = reader.ExecuteGetStrings("email", "exec searchforuserviauserid @viewinguserid =6, @usertofindid ="+userId+", @checkallsites =0");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("asteroids@rocks.com")));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchforuserviausername()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userId = GetUserIdForSearchTests(reader);

                    UpdateUserEmailAddress(reader, userId, "acornsoft@greatestclones.com");

                    reader.ExecuteWithinATransaction("update users set username='douglas adams' where userid=" + userId);

                    var emails = reader.ExecuteGetStrings("email", "exec searchforuserviausername @viewinguserid =6, @username = 'douglas adams', @checkallsites =1");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("acornsoft@greatestclones.com")));

                    emails = reader.ExecuteGetStrings("email", "exec searchforuserviausername @viewinguserid =6, @username = 'douglas adams', @checkallsites =0");
                    Assert.IsTrue(emails.TrueForAll(x => x.Equals("acornsoft@greatestclones.com")));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchtrackedusers()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    var userIds = reader.ExecuteGetInts("userid", "select top 1 userid from preferences where siteid=1 and userid>0");

                    UpdateUserEmailAddress(reader, userIds[0], "neilraine@genius.com");
                    reader.ExecuteWithinATransaction("update preferences set ContentFailedOrEdited=1 where userid="+userIds[0]);

                    var results = reader.ExecuteGetInts("userid","exec searchtrackedusers @siteid =1, @searchon ='email', @emailaddress = 'raine'");
                    Assert.AreEqual(userIds[0],results[0]);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_searchusersbynameoremail()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "scratchand@sniff.com");

                    var userIds = reader.ExecuteGetInts("userid", "EXEC searchusersbynameoremail @nameoremail = 'scratchand@sniff.com', @searchemails = 1, @siteid = 0");
                    Assert.AreEqual(42, userIds[0]);

                    userIds = reader.ExecuteGetInts("userid", "EXEC searchusersbynameoremail @nameoremail = 'scratchand@sniff.com', @searchemails = 1, @siteid = 1");
                    Assert.AreEqual(42, userIds[0]);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_synchroniseuserwithprofile()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "thatwasthen@abc.com");

                    string sql = @"exec synchroniseuserwithprofile @userid =42,                 " + NL +
                                  "                                @firstnames = NULL,          " + NL +
                                  "                                @lastname = NULL,            " + NL +
                                  "                                @email ='thisisnow@abc.com', " + NL +
                                  "                                @loginname ='',              " + NL +
                                  "                                @displayname = NULL,         " + NL +
                                  "                                @identitysite = 1,           " + NL +
                                  "                                @siteid = 1,                 " + NL +
                                  "                                @lastupdated = NULL";
                    var userIds = reader.ExecuteGetInts("userid",sql);
                    Assert.AreEqual(42, userIds[0]);

                    var emailValues = GetUserEmailValues(reader, 42);
                    Assert.AreEqual("thisisnow@abc.com", emailValues.DecryptedEmail);
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_updatebannedemailsettings()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction("truncate table bannedemails");
                    AddEmailToBannedList(reader, "mysql@suckmywiener.com", 0, 0);

                    reader.ExecuteWithinATransaction("exec updatebannedemailsettings @email ='mysql@suckmywiener.com', @editorid =42, @togglesigninbanned =1, @togglecomplaintbanned =1");
                    reader.ExecuteWithinATransaction("select * from bannedemails");
                    reader.Read();
                    Assert.AreEqual(42, reader.GetInt32("EditorID"));
                    Assert.IsTrue(reader.GetBoolean("SignInBanned"));
                    Assert.IsTrue(reader.GetBoolean("ComplaintBanned"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_updateemaileventqueue()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    SetUpEmailEventQueue(reader);

                    UpdateUserEmailAddress(reader, 6, "getmeabucket@abouttopuke.com");

                    var emails = reader.ExecuteGetStrings("email","EXEC updateemaileventqueue");
                    Assert.IsTrue(emails.Count > 0);
                    Assert.IsTrue(emails.TrueForAll(email => email.Equals("getmeabucket@abouttopuke.com")));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_updateuser()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "rogermelly@themanontelly.com");

                    reader.ExecuteWithinATransaction("exec updateuser @userid =42,@email = 'buster@gonad.com'");

                    var emailValues = GetUserEmailValues(reader, 42);
                    Assert.AreEqual("buster@gonad.com", emailValues.DecryptedEmail);
                }
            }
        }
 
        [TestMethod]
        public void EmailEnc_Test_updateuser2()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    UpdateUserEmailAddress(reader, 42, "esb@fullers.com");

                    reader.ExecuteWithinATransaction("exec updateuser2 @userid =42,@siteid=1,@email = 'oldpeculiar@theakston.com'");

                    var emailValues = GetUserEmailValues(reader, 42);
                    Assert.AreEqual("oldpeculiar@theakston.com", emailValues.DecryptedEmail);
                }
            }
        }
        [TestMethod]
        public void EmailEnc_Test_watchingusers()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction(@"select j1.forumid,u1.userid FROM Users u1" + NL +
                                                      "   INNER JOIN Journals J1 ON J1.UserID = u1.UserID and J1.SiteID = 1");
                    reader.Read();
                    var forumId = reader.GetInt32("forumid");
                    var userId = reader.GetInt32("Userid");
                    reader.Close();

                    reader.ExecuteWithinATransaction("insert FaveForums values(" + forumId + "," + userId + ")");

                    UpdateUserEmailAddress(reader, userId, "isthis@theend.com");

                    reader.ExecuteWithinATransaction("exec watchingusers @userid =" + userId + ", @siteid =1");
                    reader.Read();
                    Assert.AreEqual(userId, reader.GetInt32("UserId"));
                    Assert.AreEqual("isthis@theend.com", reader.GetString("Email"));
                }
            }
        }

        [TestMethod]
        public void EmailEnc_Test_UnicodeTextEncryptDecrypt()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    string sampleUniCode = "أنا وعاء الشاي قليلا";

                    reader.ExecuteWithinATransaction(@"EXEC openemailaddresskey; SELECT dbo.udf_DecryptText(dbo.udf_EncryptText(N'" + sampleUniCode + "',1234),1234) as convertedText");
                    reader.Read();
                    var returnedText = reader.GetString("convertedText");
                    reader.Close();

                    Assert.AreEqual(sampleUniCode, returnedText);
                }
            }
        }

        #region(very large text)
        private string veryLargeText = @"** 1000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 2000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 3000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 4000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 5000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 6000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 7000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 8000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 9000 ** 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 10000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 11000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 12000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 13000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 14000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 15000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 16000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 17000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 18000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
** 19000 **12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
END";
        #endregion

        [TestMethod]
        public void EmailEnc_Test_VeryLargeTextEncryptDecrypt()
        {
            using (new TransactionScope())
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", ConnectionDetails))
                {
                    reader.ExecuteWithinATransaction(@"EXEC openemailaddresskey; SELECT dbo.udf_DecryptText(dbo.udf_EncryptText(N'" + veryLargeText + "',1234),1234) as convertedText");
                    reader.Read();
                    var returnedText = reader.GetString("convertedText");
                    reader.Close();

                    Assert.AreEqual(veryLargeText, returnedText);
                }
            }
        }

//        create procedure fetcharticlemoderationhistory @h2g2id int


        /*

use smallguide
begin tran

select j1.forumid,u1.*
		FROM Users u1
		INNER JOIN Journals J1 ON J1.UserID = u1.UserID and J1.SiteID = 1
		--INNER JOIN FaveForums f ON f.ForumID = J1.ForumID
		--INNER JOIN Users u ON f.UserID = u.UserID
		--INNER JOIN Journals J on J.UserID = u.UserID --and J.SiteID = 1
		--INNER JOIN Forums fo ON fo.ForumID = J.ForumID

insert FaveForums values (5819,5)

exec watchingusers @userid =5, @siteid =1, @skip = 0, @show = 100000
rollback tran
use master

         
                         */

        #endregion


        #region Helper methods



        EmailValues GetUserEmailValues(IDnaDataReader reader, int userId)
        {
            string sql = string.Format(@"SELECT DecryptedEmail = dbo.udf_decryptemailaddress(EncryptedEmail,UserID), EncryptedEmail, HashedEmail FROM Users WHERE UserId=" + userId);
            reader.ExecuteWithOpenKey(sql);
            reader.Read();

            EmailValues emailValues = new EmailValues();

            emailValues.DecryptedEmail = reader.GetString("DecryptedEmail");
            emailValues.EncryptedEmail = reader.GetSqlBinary("EncryptedEmail");
            emailValues.HashedEmail = reader.GetSqlBinary("HashedEmail");

            reader.Close();

            return emailValues;
        }

        string GetNextIndentityId(IDnaDataReader reader)
        {
            //string sql = @"select IdentityUserID from signinuseridmapping 
            //               where cast(identityuserid as bigint) = (select max(cast(identityuserid as bigint)) from signinuseridmapping)";

            string sql = @"
                            select '99999999999999998' As IdentityUserID
                          ";
            reader.ExecuteWithinATransaction(sql);
            reader.Read();
            string identityId = reader.GetString("IdentityUserID");
            reader.Close();

            Int64 id = Int64.Parse(identityId);

            return (id+1).ToString();
        }

        int GetNextUserId(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction(@"select max(userid) AS maxuserid from users");
            reader.Read();
            int maxuserId = reader.GetInt32("maxuserid");
            reader.Close();
            return maxuserId + 1;
        }

        int CreateNewUser(IDnaDataReader reader, string email)
        {
            string id = GetNextIndentityId(reader);

            string sql = string.Format(@"EXEC [dbo].[createnewuserfromidentityid]	@identityuserid ='{0}',"+NL+
										"@legacyssoid = null,"+NL+
										"@username = 'test',"+NL+
										"@email = '{1}'",id, email);

            reader.ExecuteWithinATransaction(sql);

            //sql = "SELECT DnaUserId FROM SignInUserIdMapping WHERE IdentityUserId='" + id + "'";
            sql = @" Execute [dbo].[getdnauseridfromidentityuserid] '" + id + "'";
            reader.ExecuteWithinATransaction(sql);
            reader.Read();
            int userId = reader.GetInt32("DnaUserId");
            reader.Close();
            return userId;
        }

        int FindGuideEntry(IDnaDataReader reader)
        {
            string sql=@"select top 1 * from guideentries where text like '<GUIDE%' and siteid=1";
            reader.ExecuteWithinATransaction(sql);
            reader.Read();
            int entryId = reader.GetInt32("entryid");
            reader.Close();
            return entryId;
        }

        GuideEntryInfo GetGuideEntryInfo(IDnaDataReader reader,int entryId)
        {
            string sql = @"select * from guideentries where entryid="+entryId;
            reader.ExecuteWithinATransaction(sql);
            reader.Read();
            var info = new GuideEntryInfo();
            info.EntryId = reader.GetInt32("entryid");
            info.Editor = reader.GetInt32("editor");
            reader.Close();

            return info;
        }

        void UpdateUserEmailAddress(IDnaDataReader reader, int userId, string email)
        {
            string sql;
            
            if (email != null)
                sql = string.Format(@"update users set encryptedemail=dbo.udf_encryptemailaddress('{0}',{1}) where userid={1}",email,userId);
            else
                sql = string.Format(@"update users set encryptedemail=dbo.udf_encryptemailaddress(NULL,{0}) where userid={0}",userId);

            reader.ExecuteWithOpenKey(sql);
            reader.Close();
        }

        SqlBinary HashEmailAddress(IDnaDataReader reader,string email)
        {
            reader.ExecuteWithOpenKey("select dbo.udf_hashemailaddress('" + email + "') AS HashedEmail");
            reader.Read();
            var hashedEmail = reader.GetSqlBinary("HashedEmail");
            reader.Close();
            return hashedEmail;
        }

        void AddEmailToBannedList(IDnaDataReader reader, string email, int siginBanned, int complaintBanned)
        {
            string sql = @"EXEC addemailtobannedlist @email='" + email + "', @signinbanned =" + siginBanned + ", @complaintbanned =" + complaintBanned + ", @editorid = 6";
            reader.ExecuteWithinATransaction(sql);
            reader.Close();
        }

        void FixUpModActionTable(IDnaDataReader reader)
        {
            reader.ExecuteWithinATransaction("delete ModAction");
            reader.ExecuteWithinATransaction("insert ModAction select 0,'None' UNION select 1,'Edited' UNION select 2,'Hidden' UNION select 3,'Unhidden'");
            reader.Close();
        }

        int CountRowsInTable(IDnaDataReader reader, string tableName)
        {
            var counts = reader.ExecuteGetInts("c", "select count(*) c from " + tableName);
            return counts[0];
        }


        #endregion

    }
    
    public static class IDnaDataReaderEmaiEncExtensions
    {
        public static void ExecuteWithOpenKey(this IDnaDataReader reader, string sql)
        {
            sql = "EXEC openemailaddresskey; " + sql;
            reader.ExecuteWithinATransaction(sql);
        }
    }
}
