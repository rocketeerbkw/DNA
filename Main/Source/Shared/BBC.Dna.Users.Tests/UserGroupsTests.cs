using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using System.Collections.Specialized;

namespace BBC.Dna.Users.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class UserGroupsTests
    {
        private readonly MockRepository _mocks = new MockRepository();

        public UserGroupsTests()
        {
            
        }

        [TestMethod]
        public void InitialiseAllUsersAndGroups_ValidDataSet_ReturnsCorrectObject()
        {
            var groupName = "editor";
            var siteId = new Queue<int>();
            siteId.Enqueue(1);
            siteId.Enqueue(2);
            siteId.Enqueue(2);
            var userId = new Queue<int>();
            userId.Enqueue(6);
            userId.Enqueue(6);
            userId.Enqueue(7);

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            readerMembers.Stub(x => x.GetString("name")).Return(groupName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(1).WhenCalled(x => x.ReturnValue = siteId.Dequeue());
            readerMembers.Stub(x => x.GetInt32("userid")).Return(1).WhenCalled(x => x.ReturnValue = userId.Dequeue());

            var readerGetAllGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetAllGroups.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerGetAllGroups.Stub(x => x.GetString("groupname")).Return(groupName);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsandmembers")).Return(readerMembers);
            creator.Stub(x => x.CreateDnaDataReader("GetAllGroups")).Return(readerGetAllGroups);
            

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            var cachedObj = UserGroups.GetObject().GetCachedObject();
            Assert.IsNotNull(cachedObj);
            Assert.AreEqual(3, cachedObj.AllUsersGroupsAndSites.Count);
            Assert.IsTrue(cachedObj.AllUsersGroupsAndSites.ContainsKey(UserGroups.GetListKey(6, 1)));

            Assert.AreEqual(1, cachedObj.GroupList.Count);
            Assert.AreEqual(groupName, cachedObj.GroupList[0].Name);

        }

        [TestMethod]
        public void InitialiseAllUsersAndGroups_ExceptionThrown_ThrowsException()
        {
            var groupName = "editor";
            

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Execute()).Throw(new Exception("fetchgroupsandmembers"));


            var readerGetAllGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetAllGroups.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerGetAllGroups.Stub(x => x.GetString("groupname")).Return(groupName);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsandmembers")).Return(readerMembers);
            creator.Stub(x => x.CreateDnaDataReader("GetAllGroups")).Return(readerGetAllGroups);


            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            bool exceptionThrown = false;
            try
            {
                var obj = new UserGroups(creator, diag, cache, null, null);
            }
            catch (Exception e)
            {
                Assert.AreEqual("fetchgroupsandmembers", e.InnerException.Message);
                exceptionThrown = true;
            }
            Assert.IsTrue(exceptionThrown);
            readerGetAllGroups.AssertWasNotCalled(x => x.Execute());

        }

        [TestMethod]
        public void InitialiseAllGroups_ExceptionThrown_ThrowsException()
        {
            var groupName = "editor";
            var siteId = new Queue<int>();
            siteId.Enqueue(1);
            siteId.Enqueue(2);
            siteId.Enqueue(2);
            var userId = new Queue<int>();
            userId.Enqueue(6);
            userId.Enqueue(6);
            userId.Enqueue(7);

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            readerMembers.Stub(x => x.GetString("name")).Return(groupName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(1).WhenCalled(x => x.ReturnValue = siteId.Dequeue());
            readerMembers.Stub(x => x.GetInt32("userid")).Return(1).WhenCalled(x => x.ReturnValue = userId.Dequeue());

            var readerGetAllGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetAllGroups.Stub(x => x.Execute()).Throw(new Exception("GetAllGroups"));

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsandmembers")).Return(readerMembers);
            creator.Stub(x => x.CreateDnaDataReader("GetAllGroups")).Return(readerGetAllGroups);


            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            bool exceptionThrown = false;
            try
            {
                var obj = new UserGroups(creator, diag, cache, null, null);
            }
            catch (Exception e)
            {
                Assert.AreEqual("GetAllGroups", e.InnerException.Message);
                exceptionThrown = true;
            }
            Assert.IsTrue(exceptionThrown);
        }

        [TestMethod]
        public void GetUsersGroupsForSite_ValidDataInObject_ReturnsCorrectListOfGroups()
        {
            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            var groupsList = obj.GetUsersGroupsForSite(6, 1);
            Assert.IsNotNull(groupsList);
            Assert.AreEqual(cachedGroups.AllUsersGroupsAndSites[UserGroups.GetListKey(6, 1)], groupsList);

        }

        [TestMethod]
        public void GetUsersGroupsForSite_NoDataInObject_ReturnsEmptyList()
        {
            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            var groupsList = obj.GetUsersGroupsForSite(int.MaxValue, int.MaxValue);
            Assert.IsNotNull(groupsList);
            Assert.AreEqual(0, groupsList.Count);

        }

        [TestMethod]
        public void PutUserIntoGroup_NewUserGroupCombo_CorrectlyAddsUser()
        {
            var userId = 10;
            var siteId = 1;
            var groupName = "newgroup";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("AddUserToGroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            Assert.IsTrue(obj.PutUserIntoGroup(userId, groupName, siteId));
            Assert.AreEqual(1, UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Count);

        }

        [TestMethod]
        public void PutUserIntoGroup_UserAlreadyInGroup_CorrectlyAddsUser()
        {
            var userId = 6;
            var siteId = 1;
            var groupName = "editor";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("AddUserToGroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            Assert.IsTrue(obj.PutUserIntoGroup(userId, groupName, siteId));
            Assert.AreEqual(2, UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Count);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("AddUserToGroup"));

        }

        [TestMethod]
        public void DeleteUserFromGroup_NewUserGroupCombo_DoesNothing()
        {
            var userId = 10;
            var siteId = 1;
            var groupName = "newgroup";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("RemoveUserFromGroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            obj.DeleteUserFromGroup(userId, groupName, siteId);
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("RemoveUserFromGroup"));

        }

        [TestMethod]
        public void DeleteUserFromGroup_UserNotInGroup_DoesNothing()
        {
            var userId = 6;
            var siteId = 1;
            var groupName = "newgroup";
            var cachedGroups = GetCachedGroups();

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("RemoveUserFromGroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            obj.DeleteUserFromGroup(userId, groupName, siteId);
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("RemoveUserFromGroup"));

        }

        [TestMethod]
        public void DeleteUserFromGroup_UserInGroup_UserRemovedFromGroup()
        {
            var userId = 6;
            var siteId = 1;
            var groupName = "editor";
            var cachedGroups = GetCachedGroups();

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("RemoveUserFromGroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            obj.DeleteUserFromGroup(userId, groupName, siteId);
            Assert.AreEqual(1, UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Count);
            Assert.IsFalse(UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Exists(x => x.Name == groupName));

            creator.AssertWasCalled(x => x.CreateDnaDataReader("RemoveUserFromGroup"));

        }

        [TestMethod]
        public void CreateNewGroup_NewGroup_CorrectlyAddsGroup()
        {
            var userId = 10;
            var groupName = "newgroup";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createnewusergroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            Assert.IsTrue(obj.CreateNewGroup(groupName, userId));
            Assert.IsTrue(UserGroups.GetObject().GetCachedObject().GroupList.Exists(x => x.Name == groupName));

        }

        [TestMethod]
        public void CreateNewGroup_DBException_ReturnsException()
        {
            var userId = 10;
            var groupName = "newgroup";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute()).Throw(new Exception("createnewusergroup"));
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createnewusergroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            bool exceptionThrown = false;
            try
            {
            
                obj.CreateNewGroup(groupName, userId);
            }
            catch(Exception e)
            {
                exceptionThrown = true;
                Assert.AreEqual("createnewusergroup", e.Message);
            }
            Assert.IsTrue(exceptionThrown);

        }

        [TestMethod]
        public void CreateNewGroup_ExistingGroup_NoGroupAdded()
        {
            var userId = 10;
            var groupName = "editor";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createnewusergroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            Assert.IsTrue(obj.CreateNewGroup(groupName, userId));
            Assert.IsTrue(UserGroups.GetObject().GetCachedObject().GroupList.Exists(x => x.Name == groupName));

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("createnewusergroup"));
        }

        [TestMethod]
        public void DeleteGroup_ThrowsException()
        {
            
            var groupName = "editor";

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createnewusergroup")).Return(reader);
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            bool exceptionThrown = false;
            try
            {

                obj.DeleteGroup(groupName);
            }
            catch (NotSupportedException e)
            {
                exceptionThrown = true;
                Assert.AreEqual("We do not delete groups at this time!", e.Message);
            }
            Assert.IsTrue(exceptionThrown);
        }

        [TestMethod]
        public void HandleSignal_RefreshAllUsersAndGroups_CorrectlyHandlesSignal()
        {
            var userId = 7;
            var siteId = 2;
            var signalType = "recache-groups";

            var groupName = "editor";
            var siteIds = new Queue<int>();
            siteIds.Enqueue(1);
            siteIds.Enqueue(2);
            siteIds.Enqueue(2);
            var userIds = new Queue<int>();
            userIds.Enqueue(6);
            userIds.Enqueue(6);
            userIds.Enqueue(7);

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true).Repeat.Once();
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups).Repeat.Once();

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            readerMembers.Stub(x => x.GetString("name")).Return(groupName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(1).WhenCalled(x => x.ReturnValue = siteIds.Dequeue());
            readerMembers.Stub(x => x.GetInt32("userid")).Return(1).WhenCalled(x => x.ReturnValue = userIds.Dequeue());

            var readerGetAllGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetAllGroups.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerGetAllGroups.Stub(x => x.GetString("groupname")).Return(groupName);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsandmembers")).Return(readerMembers);
            creator.Stub(x => x.CreateDnaDataReader("GetAllGroups")).Return(readerGetAllGroups);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            Assert.IsTrue(obj.HandleSignal(signalType, null));
            Assert.AreEqual(1, UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Count);
        }

        [TestMethod]
        public void HandleSignal_RefreshSingleUsersGroupsWithOutGroups_CorrectlyHandlesSignal()
        {
            var userId = 7;
            var siteId = 2;
            var signalType = "recache-groups";

            var groupName = "editor";
            var siteIds = new Queue<int>();
            siteIds.Enqueue(1);
            siteIds.Enqueue(2);
            siteIds.Enqueue(2);
            var userIds = new Queue<int>();
            userIds.Enqueue(6);
            userIds.Enqueue(6);
            userIds.Enqueue(7);

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true).Repeat.Once();
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups).Repeat.Once();

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            readerMembers.Stub(x => x.GetString("name")).Return(groupName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(1).WhenCalled(x => x.ReturnValue = siteIds.Dequeue());
            readerMembers.Stub(x => x.GetInt32("userid")).Return(1).WhenCalled(x => x.ReturnValue = userIds.Dequeue());

            var readerGetAllGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetAllGroups.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerGetAllGroups.Stub(x => x.GetString("groupname")).Return(groupName);

            var readerGetUserGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetUserGroups.Stub(x => x.Read()).Return(false);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsandmembers")).Return(readerMembers);
            creator.Stub(x => x.CreateDnaDataReader("GetAllGroups")).Return(readerGetAllGroups);
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsforuser")).Return(readerGetUserGroups);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            NameValueCollection args = new NameValueCollection();
            args.Add("userid", userId.ToString());
            Assert.IsTrue(obj.HandleSignal(signalType, args));
            //none returned as refresh removed all existing groups
            Assert.AreEqual(0, UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Count);
        }

        [TestMethod]
        public void HandleSignal_RefreshSingleUsersGroups_CorrectlyHandlesSignal()
        {
            var userId = 6;
            var siteId = 3;
            var signalType = "recache-groups";

            var groupName = "editor";
            var siteIds = new Queue<int>();
            siteIds.Enqueue(1);
            siteIds.Enqueue(2);
            siteIds.Enqueue(siteId);
            var userIds = new Queue<int>();
            userIds.Enqueue(6);
            userIds.Enqueue(6);
            userIds.Enqueue(userId);

            var siteId2s = new Queue<int>();
            siteId2s.Enqueue(1);
            siteId2s.Enqueue(2);
            siteId2s.Enqueue(3);
            var userId2s = new Queue<int>();
            userId2s.Enqueue(userId);
            userId2s.Enqueue(userId);
            userId2s.Enqueue(userId);

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true).Repeat.Once();
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups).Repeat.Once();

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            readerMembers.Stub(x => x.GetString("name")).Return(groupName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(1).WhenCalled(x => x.ReturnValue = siteIds.Dequeue());
            readerMembers.Stub(x => x.GetInt32("userid")).Return(1).WhenCalled(x => x.ReturnValue = userIds.Dequeue());

            var readerGetAllGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetAllGroups.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerGetAllGroups.Stub(x => x.GetString("groupname")).Return(groupName);

            var readerGetUserGroups = _mocks.DynamicMock<IDnaDataReader>();
            readerGetUserGroups.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            readerGetUserGroups.Stub(x => x.GetString("name")).Return(groupName);
            readerGetUserGroups.Stub(x => x.GetInt32("siteid")).Return(1).WhenCalled(x => x.ReturnValue = siteId2s.Dequeue());
            readerGetUserGroups.Stub(x => x.GetInt32("userid")).Return(1).WhenCalled(x => x.ReturnValue = userId2s.Dequeue());

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsandmembers")).Return(readerMembers);
            creator.Stub(x => x.CreateDnaDataReader("GetAllGroups")).Return(readerGetAllGroups);
            creator.Stub(x => x.CreateDnaDataReader("fetchgroupsforuser")).Return(readerGetUserGroups);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            Assert.AreEqual(3, obj.GetCachedObject().AllUsersGroupsAndSites.Count);

            NameValueCollection args = new NameValueCollection();
            args.Add("userid", userId.ToString());
            Assert.IsTrue(obj.HandleSignal(signalType, args));
            //none returned as refresh removed all existing groups
            Assert.AreEqual(4, obj.GetCachedObject().AllUsersGroupsAndSites.Count);
            Assert.AreEqual(1, UserGroups.GetObject().GetUsersGroupsForSite(userId, siteId).Count);
        }

        [TestMethod]
        public void GetSitesUserIsMemberOf_ValidUserWithGroups_ReturnsCorrectSiteIds()
        {
            var userId = 6;
            var groupName = "editor";
            var expectedSiteId = new List<int>(){1,2};

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            var siteIds = obj.GetSitesUserIsMemberOf(userId, groupName);
            Assert.AreEqual(expectedSiteId.Count, siteIds.Count);
            Assert.IsTrue(siteIds.Contains(expectedSiteId[0]));
            Assert.IsTrue(siteIds.Contains(expectedSiteId[1]));
        
        }

        [TestMethod]
        public void GetSitesUserIsMemberOf_NoMemberOfGroups_ReturnsEmptySiteIds()
        {
            var userId = 6;
            var groupName = "notagroup";
            var expectedSiteId = new List<int>();

            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);

            var siteIds = obj.GetSitesUserIsMemberOf(userId, groupName);
            Assert.AreEqual(expectedSiteId.Count, siteIds.Count);

        }

        [TestMethod]
        public void SendSignal_WithoutUserId_SendsCorrectSignal()
        {
            var url = "1.0.0.1";
            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            List<string> servers = new List<string>() { url };
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, servers, servers);

            var groupsList = obj.GetUsersGroupsForSite(int.MaxValue, int.MaxValue);
            Assert.IsNotNull(groupsList);
            Assert.AreEqual(0, groupsList.Count);
            obj.SendSignal();
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/signal?action={1}", url, obj.SignalKey)));
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/dnasignal?action={1}", url, obj.SignalKey)));

        }

        [TestMethod]
        public void SendSignal_WithUserId_SendsCorrectSignal()
        {
            var url = "1.0.0.1";
            var userId = 1;
            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            List<string> servers = new List<string>() { url };
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, servers, servers);

            var groupsList = obj.GetUsersGroupsForSite(int.MaxValue, int.MaxValue);
            Assert.IsNotNull(groupsList);
            Assert.AreEqual(0, groupsList.Count);
            obj.SendSignal(userId);
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/signal?action={1}&userid={2}", url, obj.SignalKey, userId)));
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/dnasignal?action={1}&userid={2}", url, obj.SignalKey, userId)));

        }

        [TestMethod]
        public void SendSignal_MultipleServersWithUserId_SendsCorrectSignal()
        {
            var url = "1.0.0.1";
            var userId = 1;
            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            List<string> servers = new List<string>() { url, url };
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, servers, servers);

            var groupsList = obj.GetUsersGroupsForSite(int.MaxValue, int.MaxValue);
            Assert.IsNotNull(groupsList);
            Assert.AreEqual(0, groupsList.Count);
            obj.SendSignal(userId);
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/signal?action={1}&userid={2}", url, obj.SignalKey, userId)));
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/dnasignal?action={1}&userid={2}", url, obj.SignalKey, userId)));

        }

        [TestMethod]
        public void GetUserGroupsStats_GetsValidStats_ReturnsValidObject()
        {
            var cachedGroups = GetCachedGroups();
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(UserGroups.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(UserGroups.GetCacheKey())).Return(cachedGroups);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new UserGroups(creator, diag, cache, null, null);


            var stats = obj.GetStats();
            Assert.IsNotNull(stats);
            Assert.AreEqual(typeof(CachedGroups).AssemblyQualifiedName, stats.Name);
            Assert.AreEqual(obj.GetCachedObject().AllUsersGroupsAndSites.Count.ToString(), stats.Values["NumberOfAllUsersGroupsAndSites"]);
            Assert.AreEqual(obj.GetCachedObject().GroupList.Count.ToString(), stats.Values["NumberOfGroups"]);

        }



        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        static public CachedGroups GetCachedGroups()
        {
            var cachedGroups = new CachedGroups();
            cachedGroups.GroupList.Add(new UserGroup() { Name = "editor" });
            cachedGroups.GroupList.Add(new UserGroup() { Name = "moderator" });

            cachedGroups.AllUsersGroupsAndSites.Add(UserGroups.GetListKey(6, 1), new List<UserGroup> { new UserGroup() { Name = "editor" }, new UserGroup() { Name = "moderator" } });
            cachedGroups.AllUsersGroupsAndSites.Add(UserGroups.GetListKey(6, 2), new List<UserGroup> { new UserGroup() { Name = "editor" } });
            cachedGroups.AllUsersGroupsAndSites.Add(UserGroups.GetListKey(7, 1), new List<UserGroup> { new UserGroup() { Name = "moderator" } });

            return cachedGroups;
        }
    }
}

