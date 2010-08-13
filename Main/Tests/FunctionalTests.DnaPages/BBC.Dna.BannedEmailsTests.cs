using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Common;
using TestUtils;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Transactions;
using BBC.Dna.Moderation;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Groups project
    /// </summary>
    [TestClass]
    public class BBCDnaBannedEmailsTests
	{
        private string _knownBannedEmail = "";
        private string _newBannedEmail = "this.isatest@dna.bbc.co.uk";
        private IDnaDataReaderCreator readerCreator;
        private DnaDiagnostics dnaDiagnostics;
        ICacheManager _emailCache = CacheFactory.GetCacheManager();

        /// <summary>
        /// Restore the database for each test
        /// </summary>
        [TestInitialize]
        public void TestsSetup()
        {
            //SnapshotInitialisation.ForceRestore();
            using (FullInputContext _context = new FullInputContext(""))
            {
                dnaDiagnostics = _context.dnaDiagnostics;
                readerCreator = new DnaDataReaderCreator(_context.DnaConfig.ConnectionString, dnaDiagnostics);
            }
            var bannedEmails = new BannedEmails(readerCreator, dnaDiagnostics, _emailCache, null, null);

            bannedEmails.Clear();
        }

        [TestCleanup]
        public void ShutDown()
        {
            //SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Check that we have banned email in the database
        /// </summary>
        [TestMethod]
        public void Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase()
        {
            // Create a new banned emails object
            using (new TransactionScope())
            {
                var bannedEmails = BannedEmails.GetObject();

                Dictionary<string, BannedEmailDetails> emailList = bannedEmails.GetAllBannedEmails();
                Assert.IsNotNull(emailList, "The list of emails is null!");
                Assert.IsTrue(emailList.Count > 0, "The email list contains no banned emails!");
                
                // Find an email to test against
                Dictionary<string, BannedEmailDetails>.Enumerator emails = emailList.GetEnumerator();
                while (emails.MoveNext())
                {
                    // Check to make sure the email is banned from both complaints and signin
                    if (emails.Current.Value.IsBannedFromComplaints && emails.Current.Value.IsBannedFromSignIn)
                    {
                        _knownBannedEmail = emails.Current.Value.Email;
                        break;
                    }
                }

                // Now comfirm the known email
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is not banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is not banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure we have a known email in the list after we create the banned emails object
        /// </summary>
        [TestMethod]
        public void Test01CheckToSeeIfKnownEmailIsInBannedListAfterInitialization()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is not banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is not banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure we can add new emails that are banned from signin
        /// </summary>
        [TestMethod]
        public void Test02CheckAddingBannedFromSignInEmail()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                // Create a new banned emails object
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromComplaintsList(_newBannedEmail), "The new email is already in the banned from complaints");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromSignInList(_newBannedEmail), "The new email is already in the banned from signin");
                Assert.IsTrue(bannedEmails.AddEmailToBannedList(_newBannedEmail, true, false, TestUserAccounts.GetEditorUserAccount.UserID, ""), "Failed to add new email to the list");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromComplaintsList(_newBannedEmail), "The new email is in the banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_newBannedEmail), "The new email is not in the banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure we can add new email that are banned from complaints
        /// </summary>
        [TestMethod]
        public void Test03CheckAddingBannedFromComplaintsEmail()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                // Create a new banned emails object
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromComplaintsList(_newBannedEmail), "The new email is already in the banned from complaints");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromSignInList(_newBannedEmail), "The new email is already in the banned from signin");
                Assert.IsTrue(bannedEmails.AddEmailToBannedList(_newBannedEmail, false, true, TestUserAccounts.GetEditorUserAccount.UserID, ""), "Failed to add new email to the list");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_newBannedEmail), "The new email is not in the banned from complaints");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromSignInList(_newBannedEmail), "The new email is in the banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure we can add new emails that are both banned from signin and complaints
        /// </summary>
        [TestMethod]
        public void Test04CheckAddingBannedFromSignInAndComplaintsEmail()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromComplaintsList(_newBannedEmail), "The new email is already in the banned from complaints");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromSignInList(_newBannedEmail), "The new email is already in the banned from signin");
                Assert.IsTrue(bannedEmails.AddEmailToBannedList(_newBannedEmail, true, true, TestUserAccounts.GetEditorUserAccount.UserID, ""), "Failed to add new email to the list");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_newBannedEmail), "The new email is not in the banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_newBannedEmail), "The new email is not in the banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure that we can toggle the status of the signin status for an email
        /// </summary>
        [TestMethod]
        public void Test05CheckToggleOfBannedFromSignIn()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is not banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is not banned from signin");
                Assert.IsTrue(bannedEmails.UpdateEmailDetails(_knownBannedEmail, false, true, TestUserAccounts.GetEditorUserAccount.UserID), "Failed to update the email details");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is not banned from complaints");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure we can toggle the status of the comlaints status for an emaiil
        /// </summary>
        [TestMethod]
        public void Test06CheckToggleOfBannedFromComplaints()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is not banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is not banned from signin");
                Assert.IsTrue(bannedEmails.UpdateEmailDetails(_knownBannedEmail, true, false, TestUserAccounts.GetEditorUserAccount.UserID), "Failed to update the email details");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is not banned from signin");
            }
        }

        /// <summary>
        /// Check to make sure we can toggle the status of the signin and complaints for an email
        /// </summary>
        [TestMethod]
        public void Test07CheckRemoveEmailFromBannedList()
        {
            Test00CheckThatWeCanGetAllTheBannedEmailsCurrentlyInTheDatabase();
            using (new TransactionScope())
            {
                var bannedEmails = BannedEmails.GetObject();
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is not banned from complaints");
                Assert.IsTrue(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is not banned from signin");
                bannedEmails.RemoveEmailFromBannedList(_knownBannedEmail);
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromComplaintsList(_knownBannedEmail), "The known email is banned from complaints");
                Assert.IsFalse(bannedEmails.IsEmailInBannedFromSignInList(_knownBannedEmail), "The known email is is banned from signin");
            }
        }
    }
}
