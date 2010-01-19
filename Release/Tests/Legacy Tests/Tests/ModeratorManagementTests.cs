using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// 
    /// </summary>
    [TestClass]
    public class ModeratorManagementTests
    {
        /// <summary>
        /// Check that the Stored Procedure is called correctly.
        /// </summary>
        [TestMethod]
        public void TestFindUser()
        {
            IInputContext context = DnaMockery.CurrentMockery.NewMock<IInputContext>();
            Stub.On(context).Method("GetParamIntOrZero").With("manage").Will(Return.Value("editor"));

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsSuperUser").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(context).Method("DoesParamExist").With("manage","manage").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("manage","manage").Will(Return.Value("editor"));
            Stub.On(context).Method("GetParamStringOrEmpty").With("email", "email").Will(Return.Value("dotnetuser@bbc.com"));
            Stub.On(context).Method("DoesParamExist").With("finduser", "Find User").Will(Return.Value(true));
            Stub.On(context).Method("DoesParamExist").With("updateuser", "UpdateUser").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("giveaccess", "Give Access").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("removeaccess", "removeaccess").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("removeallaccess", "removeallaccess").Will(Return.Value(false));

            // Mock the stored procedure call
            IDnaDataReader mockedReader = DnaMockery.CurrentMockery.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").With("finduserfromemail").Will(Return.Value(mockedReader)); 
            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Dispose");
            Expect.Once.On(mockedReader).Method("AddParameter").With("email","dotnetuser@bbc.com");


            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("userid").Will(Return.Value(6));
            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("modid").Will(Return.Value(1));
            Stub.On(mockedReader).Method("Read").Will(Return.Value(false));


            ModeratorManagement mm = new ModeratorManagement(context);
            mm.ProcessSubmission("editor");

            DnaMockery.CurrentMockery.VerifyAllExpectationsHaveBeenMet();

        }

        /// <summary>
        /// Test The Update User stored procedure is called correctly.
        /// </summary>
        [TestMethod]
        public void TestUpdateUser()
        {
            IInputContext context = DnaMockery.CurrentMockery.NewMock<IInputContext>();
            //Stub.On(context).Method("GetParamIntOrZero").With("manage").Will(Return.Value("editor"));
            Stub.On(context).Method("GetParamIntOrZero").With("userid","UserId").Will(Return.Value(6));

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsSuperUser").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(context).Method("DoesParamExist").With("manage", "manage").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("manage", "manage").Will(Return.Value("editor"));
            Stub.On(context).Method("DoesParamExist").With("finduser", "Find User").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("updateuser", "UpdateUser").Will(Return.Value(true));
            Stub.On(context).Method("DoesParamExist").With("giveaccess", "Give Access").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("removeaccess", "removeaccess").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("removeallaccess", "removeallaccess").Will(Return.Value(false));

            Stub.On(context).Method("GetParamCountOrZero").With("tosite","SiteId").Will(Return.Value(3) );
            Stub.On(context).Method("GetParamIntOrZero").With("tosite", 0, "tosite").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("tosite", 1, "tosite").Will(Return.Value(2));
            Stub.On(context).Method("GetParamIntOrZero").With("tosite", 2, "tosite").Will(Return.Value(3));
            
            Stub.On(context).Method("GetParamCountOrZero").With("toclass","ModerationClassId").Will(Return.Value(3));
            Stub.On(context).Method("GetParamIntOrZero").With("toclass", 0, "toclass").Will(Return.Value(4));
            Stub.On(context).Method("GetParamIntOrZero").With("toclass", 1, "toclass").Will(Return.Value(5));
            Stub.On(context).Method("GetParamIntOrZero").With("toclass", 2, "toclass").Will(Return.Value(6));

            // Mock the stored procedure call
            IDnaDataReader mockedReader = DnaMockery.CurrentMockery.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").With("addnewmoderatortosites").Will(Return.Value(mockedReader));
            Expect.Once.On(mockedReader).Method("AddParameter").With("sitelist", "1|2|3");
            Expect.Exactly(3).On(mockedReader).Method("AddParameter").With("userid", 6);
            Expect.Exactly(2).On(mockedReader).Method("AddParameter").With("groupname", "editor");
            
            Stub.On(context).Method("CreateDnaDataReader").With("addnewmoderatortoclasses").Will(Return.Value(mockedReader));
            Expect.Once.On(mockedReader).Method("AddParameter").With("classlist", "4|5|6");

            Stub.On(context).Method("CreateDnaDataReader").With("finduserfromid").Will(Return.Value(mockedReader));
            
            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Dispose");
            Stub.On(mockedReader).Method("Read").Will(Return.Value(false));

            ModeratorManagement mm = new ModeratorManagement(context);
            mm.ProcessSubmission("editor");

            DnaMockery.CurrentMockery.VerifyAllExpectationsHaveBeenMet();
        }

        /// <summary>
        /// Test the Give Access SP is called correctly.
        /// </summary>
        [TestMethod]
        public void TestGiveAccess()
        {
            IInputContext context = DnaMockery.CurrentMockery.NewMock<IInputContext>();
            //Stub.On(context).Method("GetParamIntOrZero").With("manage").Will(Return.Value("editor"));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", "UserId").Will(Return.Value(6));

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsSuperUser").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(context).Method("DoesParamExist").With("manage", "manage").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("manage", "manage").Will(Return.Value("editor"));
            Stub.On(context).Method("DoesParamExist").With("finduser", "Find User").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("updateuser", "UpdateUser").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("giveaccess", "Give Access").Will(Return.Value(true));
            Stub.On(context).Method("DoesParamExist").With("removeaccess", "removeaccess").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("removeallaccess", "removeallaccess").Will(Return.Value(false));


            Stub.On(context).Method("GetParamCountOrZero").With("userid","UserId").Will(Return.Value(3));
            Stub.On(context).Method("GetParamIntOrZero").With("userid",0,"UserId").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", 1, "UserId").Will(Return.Value(2));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", 2, "UserId").Will(Return.Value(3));
            Stub.On(context).Method("DoesParamExist").With("siteid", "SiteId").Will(Return.Value(true));
            Stub.On(context).Method("DoesParamExist").With("classid", "ClassId").Will(Return.Value(true));
            Stub.On(context).Method("GetParamIntOrZero").With("classId","classId").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("siteid", "SiteId").Will(Return.Value(16));



            // Mock the stored procedure call
            IDnaDataReader mockedReader = DnaMockery.CurrentMockery.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").With("giveaccess").Will(Return.Value(mockedReader));
            Expect.Once.On(mockedReader).Method("AddParameter").With("userlist", "1|2|3");
            Expect.Once.On(mockedReader).Method("AddParameter").With("modclassid", 1);
            Expect.Once.On(mockedReader).Method("AddParameter").With("siteid", 16);
            Expect.Once.On(mockedReader).Method("AddParameter").With("groupname", "editor");

            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Dispose");
            Stub.On(mockedReader).Method("Read").Will(Return.Value(false));

            ModeratorManagement mm = new ModeratorManagement(context);
            mm.ProcessSubmission("editor");

            DnaMockery.CurrentMockery.VerifyAllExpectationsHaveBeenMet();

        }

        /// <summary>
        /// Test RemoveAccess sp is called correctly.
        /// </summary>
        [TestMethod]
        public void TestRemoveAccess()
        {
            IInputContext context = DnaMockery.CurrentMockery.NewMock<IInputContext>();
            //Stub.On(context).Method("GetParamIntOrZero").With("manage").Will(Return.Value("editor"));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", "UserId").Will(Return.Value(6));

            // Mock the viewing user
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("IsSuperUser").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(context).Method("DoesParamExist").With("manage", "manage").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("manage", "manage").Will(Return.Value("editor"));
            Stub.On(context).Method("DoesParamExist").With("finduser", "Find User").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("updateuser", "UpdateUser").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("giveaccess", "Give Access").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("removeaccess", "removeaccess").Will(Return.Value(true));
            Stub.On(context).Method("DoesParamExist").With("removeallaccess", "removeallaccess").Will(Return.Value(false));


            Stub.On(context).Method("GetParamCountOrZero").With("userid", "UserId").Will(Return.Value(3));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", 0, "UserId").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", 1, "UserId").Will(Return.Value(2));
            Stub.On(context).Method("GetParamIntOrZero").With("userid", 2, "UserId").Will(Return.Value(3));
            Stub.On(context).Method("DoesParamExist").With("siteid", "SiteId").Will(Return.Value(true));
            Stub.On(context).Method("DoesParamExist").With("classid", "ClassId").Will(Return.Value(true));
            Stub.On(context).Method("GetParamIntOrZero").With("classId", "classId").Will(Return.Value(1));
            Stub.On(context).Method("GetParamIntOrZero").With("siteid", "SiteId").Will(Return.Value(16));



            // Mock the stored procedure call
            IDnaDataReader mockedReader = DnaMockery.CurrentMockery.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").With("removeaccess").Will(Return.Value(mockedReader));
            Expect.Once.On(mockedReader).Method("AddParameter").With("userlist", "1|2|3");
            Expect.Once.On(mockedReader).Method("AddParameter").With("modclassid", 1);
            Expect.Once.On(mockedReader).Method("AddParameter").With("siteid", 16);
            Expect.Once.On(mockedReader).Method("AddParameter").With("clearall", 0);
            Expect.Once.On(mockedReader).Method("AddParameter").With("groupname", "editor");


            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Dispose");
            Stub.On(mockedReader).Method("Read").Will(Return.Value(false));

            ModeratorManagement mm = new ModeratorManagement(context);
            mm.ProcessSubmission("editor");

            DnaMockery.CurrentMockery.VerifyAllExpectationsHaveBeenMet();

        }
    }
}
