using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;
using System.Xml;
//using BBC.Dna.Moderation;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;


namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    ///This is a test class for TermTest and is intended
    ///to contain all TermTest Unit Tests
    ///</summary>
    [TestClass]
    public class TermTest
    {

        public MockRepository Mocks = new MockRepository();

        /// <summary>
        ///A test for Terms Constructor
        ///</summary>
        [TestMethod]
        public void TermConstructor_CorrectObject_ValidXml()
        {
            Term target = CreateTerm();
            var expected = "<TERM xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" ID=\"0\" ACTION=\"ReEdit\" TERM=\"term\" ModClassID=\"0\" ForumID=\"0\" />";
            XmlDocument xml = Serializer.SerializeToXml(target);
            Assert.AreEqual(expected, xml.SelectSingleNode("TERM").OuterXml);
        }

        public static Term CreateTerm()
        {
            return new Term() { Id = 0, Action = TermAction.ReEdit, Value = "term" };
        }

        /// <summary>
        ///A test for UpdateTermForModClassId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForModClassId_WithoutModclassId_ThrowsException()
        {
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            //creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(reader);

            Mocks.ReplayAll();

            var target = new Term{Value="term"}; 
            int modClassId = 0;

            try
            {
                target.UpdateTermForModClassId(creator, modClassId, 1);
            }
            catch (Exception e)
            {
                Assert.AreEqual("ModClassId cannot be 0.", e.Message);
            }
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            
        }

        /// <summary>
        ///A test for UpdateTermForModClassId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForModClassId_WithBlankTerm_ThrowsException()
        {
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();


            Mocks.ReplayAll();

            var target = new Term { Value = "" };
            try
            {
                target.UpdateTermForModClassId(creator, 1, 1);
            }
            catch (Exception e)
            {
                Assert.AreEqual("Term value cannot be empty.", e.Message);
            }
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));

        }

        /// <summary>
        ///A test for UpdateTermForModClassId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForModClassId_WithoutHistoryId_ThrowsException()
        {
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();


            Mocks.ReplayAll();

            var target = new Term { Value = "term" };
            int historyId = 0;

            try
            {
                target.UpdateTermForModClassId(creator, 1, historyId);
            }
            catch (Exception e)
            {
                Assert.AreEqual("HistoryId cannot be 0.", e.Message);
            }
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));

        }

        /// <summary>
        ///A test for UpdateTermForModClassId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForModClassId_ValueInput_ReturnsNoException()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(reader);

            Mocks.ReplayAll();

            var target = new Term { Value = "term" };
            target.UpdateTermForModClassId(creator, 1, 1);

            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));

        }

        /// <summary>
        ///A test for UpdateTermForForumId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForForumId_WithoutForumId_ThrowsException()
        {
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            
            Mocks.ReplayAll();

            var target = new Term { Value = "term" };
            int forumId = 0;

            try
            {
                target.UpdateTermForForumId(creator, forumId, 1);
            }
            catch (Exception e)
            {
                Assert.AreEqual("ForumId cannot be 0.", e.Message);
            }
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addforumfilterterm"));

        }

        /// <summary>
        ///A test for UpdateTermForForumId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForForumId_WithBlankTerm_ThrowsException()
        {
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();


            Mocks.ReplayAll();

            var target = new Term { Value = "" };
            try
            {
                target.UpdateTermForForumId(creator, 1, 1);
            }
            catch (Exception e)
            {
                Assert.AreEqual("Term value cannot be empty.", e.Message);
            }
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addforumfilterterm"));

        }


        /// <summary>
        ///A test for UpdateTermForForumId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForForumId_WithoutHistoryId_ThrowsException()
        {
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();


            Mocks.ReplayAll();

            var target = new Term { Value = "term" };
            int historyId = 0;

            try
            {
                target.UpdateTermForForumId(creator, 1, historyId);
            }
            catch (Exception e)
            {
                Assert.AreEqual("HistoryId cannot be 0.", e.Message);
            }
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addforumfilterterm"));

        }


        /// <summary>
        ///A test for UpdateTermForForumId
        ///</summary>
        [TestMethod()]
        public void UpdateTermForForumId_ValueInput_ReturnsNoException()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addforumfilterterm")).Return(reader);

            Mocks.ReplayAll();

            var target = new Term { Value = "term" };
            target.UpdateTermForForumId(creator, 1, 1);

            creator.AssertWasCalled(x => x.CreateDnaDataReader("addforumfilterterm"));

        }
    }
}