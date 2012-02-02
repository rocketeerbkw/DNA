using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System;
using BBC.Dna.Common;

namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class BannedEmailsTests
    {
        [TestInitialize]
        public void StartUp()
        {
            //obj.Clear();

        }

        private readonly MockRepository _mocks = new MockRepository();

        [TestMethod]
        public void InitializebannedEmails_EmptyCacheValidRecordSet_ReturnsValidObject()
        {
            var expectedEmail = "a@b.com";

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetString("email")).Return(expectedEmail);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.AreEqual(1, obj.GetAllBannedEmails().Count);
            Assert.AreEqual(expectedEmail, obj.GetAllBannedEmails()[expectedEmail].Email);

        }

        [TestMethod]
        public void InitializebannedEmails_MissingCacheValidRecordSet_ReturnsValidObject()
        {
            var expectedEmail = "a@b.com";

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Throw(new Exception("cache doesn't exist"));

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetString("email")).Return(expectedEmail);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.AreEqual(1, obj.GetAllBannedEmails().Count);
            Assert.AreEqual(expectedEmail, obj.GetAllBannedEmails()[expectedEmail].Email);

            diag.AssertWasNotCalled(x => x.WriteExceptionToLog(null));
            

        }

        [TestMethod]
        public void InitializebannedEmails_RecordSetThrowsException_ReturnsValidObject()
        {
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Throw(new Exception("cache doesn't exist"));

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute()).Return(null).Throw(new Exception("IDnaDataReader not there"));
            

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.AreEqual(0, obj.GetAllBannedEmails().Count);
            
            diag.AssertWasNotCalled(x => x.WriteExceptionToLog(null));
        }

        [TestMethod]
        public void IsEmailInBannedFromSignInList_EmailNotInList_False()
        {
            var expectedEmail = "a@b.com";

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Throw(new Exception("cache doesn't exist"));

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute()).Return(null).Throw(new Exception("IDnaDataReader not there"));


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsFalse(obj.IsEmailInBannedFromSignInList(expectedEmail));
        }

        [TestMethod]
        public void IsEmailInBannedFromSignInList_EmailInListWithNull_CorrectResult()
        {
            var testEmail = "null@bbc.co.uk";
            var emailList = new BannedEmailsList();
            emailList.bannedEmailsList.Add("null@bbc.co.uk", null);

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);
            Assert.AreEqual(emailList.bannedEmailsList.Count, obj.GetAllBannedEmails().Count);
            Assert.IsFalse(obj.IsEmailInBannedFromSignInList(testEmail));
        }

        [TestMethod]
        public void IsEmailInBannedFromSignInList_EmailInList_CorrectResult()
        {
            var testEmail = "userbannedfromsigning@bbc.co.uk";
            var emailList = GetBannedEmailsList();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);
            Assert.AreEqual(emailList.bannedEmailsList.Count, obj.GetAllBannedEmails().Count);
            Assert.IsTrue(obj.IsEmailInBannedFromSignInList(testEmail));
        }

        [TestMethod]
        public void IsEmailInBannedFromComplaintsList_EmailNotInList_False()
        {
            var expectedEmail = "a@b.com";

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Throw(new Exception("cache doesn't exist"));

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute()).Return(null).Throw(new Exception("IDnaDataReader not there"));


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsFalse(obj.IsEmailInBannedFromComplaintsList(expectedEmail));
        }

        [TestMethod]
        public void IsEmailInBannedFromComplaintsList_EmailInList_CorrectResult()
        {
            var testEmail = "userbannedfromcomplaining@bbc.co.uk";
            var emailList = GetBannedEmailsList();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);
            Assert.AreEqual(emailList.bannedEmailsList.Count, obj.GetAllBannedEmails().Count);
            Assert.IsTrue(obj.IsEmailInBannedFromComplaintsList(testEmail));
        }

        [TestMethod]
        public void IsEmailInBannedFromComplaintsList_EmailInListWithNull_CorrectResult()
        {
            var testEmail = "null@bbc.co.uk";
            var emailList = new BannedEmailsList();
            emailList.bannedEmailsList.Add("null@bbc.co.uk", null);

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);
            Assert.AreEqual(emailList.bannedEmailsList.Count, obj.GetAllBannedEmails().Count);
            Assert.IsFalse(obj.IsEmailInBannedFromComplaintsList(testEmail));
        }

        [TestMethod]
        public void AddEmailToBannedList_ValidEmail_CorrectlyAdds()
        {
            var testEmail = "a@b.com";
            bool isBannedFromComplaints = true;
            bool isBannedFromSignin = true;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerAddEmail = _mocks.DynamicMock<IDnaDataReader>();
            readerAddEmail.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.HasRows).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.GetInt32("Duplicate")).Return(0);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("AddEMailToBannedList")).Return(readerAddEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsTrue(obj.AddEmailToBannedList(testEmail, isBannedFromComplaints, isBannedFromSignin, 0, ""));
            var returnedEmail = obj.GetAllBannedEmails();
            Assert.IsNotNull(returnedEmail[testEmail]);
            Assert.AreEqual(isBannedFromComplaints, returnedEmail[testEmail].IsBannedFromComplaints);
            Assert.AreEqual(isBannedFromSignin, returnedEmail[testEmail].IsBannedFromSignIn);
        }

        [TestMethod]
        public void AddEmailToBannedList_ExceptionThrown_DoesNotAdd()
        {
            var testEmail = "a@b.com";
            bool isBannedFromComplaints = true;
            bool isBannedFromSignin = true;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerAddEmail = _mocks.DynamicMock<IDnaDataReader>();
            readerAddEmail.Stub(x => x.Execute()).Throw(new Exception("exception thrown"));

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("AddEMailToBannedList")).Return(readerAddEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsFalse(obj.AddEmailToBannedList(testEmail, isBannedFromComplaints, isBannedFromSignin, 0, ""));
        }

        [TestMethod]
        public void AddEmailToBannedList_DBNotRead_CorrectlyAdds()
        {
            var testEmail = "a@b.com";
            bool isBannedFromComplaints = true;
            bool isBannedFromSignin = true;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerAddEmail = _mocks.DynamicMock<IDnaDataReader>();
            readerAddEmail.Stub(x => x.Read()).Return(false).Repeat.Once();
            readerAddEmail.Stub(x => x.HasRows).Return(false).Repeat.Once();

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("AddEmailToBannedList")).Return(readerAddEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsFalse(obj.AddEmailToBannedList(testEmail, isBannedFromComplaints, isBannedFromSignin, 0, ""));

        }

        [TestMethod]
        public void AddEmailToBannedList_DuplicateEmail_NotAdded()
        {
            var testEmail = "a@b.com";
            bool isBannedFromComplaints = true;
            bool isBannedFromSignin = true;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerAddEmail = _mocks.DynamicMock<IDnaDataReader>();
            readerAddEmail.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.HasRows).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.GetIntReturnValue()).Return(1);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("AddEMailToBannedList")).Return(readerAddEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsTrue(obj.AddEmailToBannedList(testEmail, isBannedFromComplaints, isBannedFromSignin, 0, ""));
            var returnedEmail = obj.GetAllBannedEmails();
            Assert.AreEqual(0, returnedEmail.Count);

        }

        [TestMethod]
        public void AddEmailToBannedList_InvalidEmail_NotAdded()
        {
            var testEmail = "notevalidemail";
            bool isBannedFromComplaints = true;
            bool isBannedFromSignin = true;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerAddEmail = _mocks.DynamicMock<IDnaDataReader>();
            readerAddEmail.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.HasRows).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.GetInt32("Duplicate")).Return(0);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("AddEmailToBannedList")).Return(readerAddEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsFalse(obj.AddEmailToBannedList(testEmail, isBannedFromComplaints, isBannedFromSignin, 0, ""));
            var returnedEmail = obj.GetAllBannedEmails();
            Assert.AreEqual(0, returnedEmail.Count);
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("AddEmailToBannedList"));
            

        }

        [TestMethod]
        public void RemoveEmailFromBannedList_ValidEmail_CorrectlyRemoves()
        {
            var testEmail = "userbannedfromcomplaining@bbc.co.uk";
            var emailList = GetBannedEmailsList();
            var itemCount = emailList.bannedEmailsList.Count;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerRemoveEmail = _mocks.DynamicMock<IDnaDataReader>();

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("RemoveBannedEMail")).Return(readerRemoveEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            obj.RemoveEmailFromBannedList(testEmail);

            Assert.AreEqual(itemCount - 1, obj.GetAllBannedEmails().Count);
        }

        [TestMethod]
        public void RemoveEmailFromBannedList_EmailNotExist_NoAction()
        {
            var testEmail = "notinemail@bbc.co.uk";
            var emailList = GetBannedEmailsList();
            var itemCount = emailList.bannedEmailsList.Count;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerRemoveEmail = _mocks.DynamicMock<IDnaDataReader>();

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("RemoveBannedEMail")).Return(readerRemoveEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            obj.RemoveEmailFromBannedList(testEmail);

            Assert.AreEqual(itemCount, obj.GetAllBannedEmails().Count);
        }

        [TestMethod]
        public void UpdateEmailDetails_ValidEmailInObject_CorrectChange()
        {
            var emailList = GetBannedEmailsList();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var readerUpdate = _mocks.DynamicMock<IDnaDataReader>();
            

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatebannedemailsettings")).Return(readerUpdate);


            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            var testObj = (GetBannedEmailsList()).bannedEmailsList["userbannedfromcomplaining@bbc.co.uk"];

            Assert.IsTrue(obj.UpdateEmailDetails(testObj.Email, !testObj.IsBannedFromSignIn, !testObj.IsBannedFromComplaints, 0));
            var returnedList = obj.GetObjectFromCache().bannedEmailsList;
            Assert.AreEqual(!testObj.IsBannedFromComplaints, returnedList[testObj.Email].IsBannedFromComplaints);
            Assert.AreEqual(!testObj.IsBannedFromSignIn, returnedList[testObj.Email].IsBannedFromSignIn);
            
        }

        [TestMethod]
        public void UpdateEmailDetails_InvalidEmailInObject_ReturnsFalse()
        {
            var emailList = GetBannedEmailsList();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var readerUpdate = _mocks.DynamicMock<IDnaDataReader>();


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatebannedemailsettings")).Return(readerUpdate);


            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            var testObj = (GetBannedEmailsList()).bannedEmailsList["userbannedfromcomplaining@bbc.co.uk"];

            Assert.IsFalse(obj.UpdateEmailDetails(testObj.Email + "notemail", !testObj.IsBannedFromSignIn, !testObj.IsBannedFromComplaints, 0));
            

        }

        [TestMethod]
        public void UpdateEmailDetails_EmailContainsNullObject_ReturnsFalse()
        {
            var testEmail = "null@bbc.co.uk";
            var emailList = new BannedEmailsList();
            emailList.bannedEmailsList.Add("null@bbc.co.uk", null);
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var readerUpdate = _mocks.DynamicMock<IDnaDataReader>();


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatebannedemailsettings")).Return(readerUpdate);


            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            Assert.IsFalse(obj.UpdateEmailDetails(testEmail, false, false, 0));


        }

        [TestMethod]
        public void HandleSignal_CorrectCacheKey_ReturnsValidObject()
        {
            var expectedEmail = "a@b.com";

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetString("email")).Return(expectedEmail);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            _mocks.ReplayAll();
            Assert.IsTrue(obj.HandleSignal(obj.SignalKey, null));

            Assert.AreEqual(expectedEmail, obj.GetAllBannedEmails()[expectedEmail].Email);

        }

        [TestMethod]
        public void HandleSignal_IncorrectCacheKey_ReturnsValidObject()
        {
            var expectedEmail = "a@b.com";

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetString("email")).Return(expectedEmail);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);
            Assert.IsFalse(obj.HandleSignal("notcachekey", null));

            Assert.AreEqual(expectedEmail, obj.GetAllBannedEmails()[expectedEmail].Email);

        }

        [TestMethod]
        public void GetObject_NewBannedEmailObject_ReturnsObject()
        {
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var readerAddEmail = _mocks.DynamicMock<IDnaDataReader>();
            readerAddEmail.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.HasRows).Return(true).Repeat.Once();
            readerAddEmail.Stub(x => x.GetInt32("Duplicate")).Return(1);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("AddEmailToBannedList")).Return(readerAddEmail);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);
            Assert.IsNotNull(BannedEmails.GetObject());
        }

        [TestMethod]
        public void GetBannedEmailsStats_GetsValidStats_ReturnsValidObject()
        {
            var expectedEmail = "a@b.com";
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetString("email")).Return(expectedEmail);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new BannedEmails(creator, diag, cache, null, null);

            var stats = obj.GetStats(typeof(BannedEmails));
            Assert.IsNotNull(stats);
            Assert.AreEqual(typeof(BannedEmails).AssemblyQualifiedName, stats.Name);
            Assert.AreEqual(obj.GetObjectFromCache().bannedEmailsList.Count.ToString(), stats.Values["NumberOfBannedEmailsInList"]);

        }
        

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        static public BannedEmailsList GetBannedEmailsList()
        {
            var bannedEmailsList = new BannedEmailsList();
            bannedEmailsList.bannedEmailsList.Add("userbannedfromsigning@bbc.co.uk",
                new BannedEmailDetails()
                {
                    Email = "userbannedfromsigning@bbc.co.uk",
                    IsBannedFromComplaints = false,
                    IsBannedFromSignIn = true,
                    DateAdded = DateTime.Now
                });

            bannedEmailsList.bannedEmailsList.Add("userbannedfromcomplaining@bbc.co.uk",
                new BannedEmailDetails()
                {
                    Email = "userbannedfromcomplaining@bbc.co.uk",
                    IsBannedFromComplaints = true,
                    IsBannedFromSignIn = false,
                    DateAdded = DateTime.Now
                });

            bannedEmailsList.bannedEmailsList.Add("userbannedcompletely@bbc.co.uk",
                new BannedEmailDetails()
                {
                    Email = "userbannedcompletely@bbc.co.uk",
                    IsBannedFromComplaints = true,
                    IsBannedFromSignIn = true,
                    DateAdded = DateTime.Now
                });

            

            return bannedEmailsList;
        }

        /// <summary>
        /// 
        /// </summary>
        static public BannedEmails InitialiseMockBannedEmails()
        {
            MockRepository _mocks = new MockRepository();
            var emailList = GetBannedEmailsList();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey())).Return(emailList);
            cache.Stub(x => x.Contains(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(true);
            cache.Stub(x => x.GetData(BannedEmails.GetCacheKey("LASTUPDATE"))).Return(DateTime.Now);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();

            _mocks.ReplayAll();

            return new BannedEmails(creator, diag, cache, null, null);

        }
    }
}

