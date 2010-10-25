using Dna.SnesIntegration.ActivityProcessor.DataReaderAdapters;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using BBC.Dna.Data;
using System.Collections.Generic;
using Rhino.Mocks;
using Dna.SnesIntegration.ActivityProcessor.Contracts;

namespace SnesActivityProcessorTests
{
    
    
    /// <summary>
    ///This is a test class for OpenSocialActvivityDataReaderAdapterTest and is intended
    ///to contain all OpenSocialActvivityDataReaderAdapterTest Unit Tests
    ///</summary>
    [TestClass()]
    public class OpenSocialActvivityDataReaderAdapterTests
    {


        /// <summary>
        ///A test for FormatBody
        ///</summary>
        [TestMethod()]
        public void FormatBody_Variants_ReturnsFormattedText()
        {
            var testDataPlainText = new List<string[]>();
            testDataPlainText.Add(new[] { "This post is ok.", "This post is ok." });//no html
            testDataPlainText.Add(new[] { "This <b>post</b> is ok.", "This post is ok." });//with html
            testDataPlainText.Add(new[] { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at neque orci, vel euismod felis. Mauris euismod nibh sed turpis fermentum eu laoreet eros sodales. Morbi vitae nunc et arcu fringilla tempor sit amet vel elit. Curabitur sit amet ante dolor, eget ultrices enim. Vestibulum metus mi, ultrices tristique volutpat in, consectetur at est. Duis est augue, rutrum non molestie ac, viverra vel lorem. Donec consequat suscipit turpis, in sagittis ante blandit ut. In faucibus dui in diam molestie sit amet sed.", 
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at neque orci, vel euismod felis. Mauris euismod nibh sed turpis fermentum eu laoreet eros sodales. Morbi vitae nunc et arcu fringilla tempor sit amet vel elit. Curabitur sit amet ante dolor, eget ultrices enim. Vestibulum metus mi, ultrices tristique volutpat in, consectetur at est. Duis est augue, rutrum non molestie ac, viverra vel lorem. Donec consequat suscipit turpis, in sagittis ante blandit ut. In faucibus dui in diam molestie sit..." });//over 511 chars

            foreach (var data in testDataPlainText)
            {
                Assert.AreEqual(data[1], data[0].FormatBody());
            }
        }

        /// <summary>
        ///A test for OpenSocialActvivityDataReaderAdapter Constructor
        ///</summary>
        [TestMethod()]
        public void OpenSocialActivityDataReaderAdapter_StandardResponse_ReturnsCorrectObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader dataReader = CreateDefaultReader(ref mocks);
            mocks.ReplayAll();

            OpenSocialActivityDataReaderAdapter target = new OpenSocialActivityDataReaderAdapter(dataReader);

            Assert.AreEqual("bbc:dna:1:1:1", target.ObjectUri);
            
        }

        [TestMethod()]
        public void OpenSocialActivityDataReaderAdapter_IPlayerTvResponse_ReturnsCorrectObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader dataReader = CreateDefaultReader(ref mocks, "bbc:programme:{commentforumuid}", "recommend_comment",
                "pid");

            mocks.ReplayAll();

            OpenSocialActivityDataReaderAdapter target = new OpenSocialActivityDataReaderAdapter(dataReader);

            Assert.AreEqual("bbc:programme:pid", target.ObjectUri);
            Assert.AreEqual("recommend_comment", target.CustomActivityType);

        }


        private IDnaDataReader CreateDefaultReader(ref MockRepository mocks)
        {
            return CreateDefaultReader(ref mocks, "bbc:dna:{forumid}:{threadid}:{postid}", "comment", "");
        }

        private IDnaDataReader CreateDefaultReader(ref MockRepository mocks, string ObjectUriFormat, string CustomActivityType,
           string ObjectUri )
        {
            var dataReader = mocks.DynamicMock<IDnaDataReader>();

            dataReader.Stub(x => x.GetInt32("EventID")).Return(1);
            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(19);
            dataReader.Stub(x => x.GetString("IdentityUserId")).Return("testuserid");
            dataReader.Stub(x => x.GetString("Username")).Return("testusername");
            dataReader.Stub(x => x.GetString("DisplayName")).Return("testDisplayName");
            dataReader.Stub(x => x.GetInt32("AppId")).Return(1);
            dataReader.Stub(x => x.GetString("AppName")).Return("test");
            dataReader.Stub(x => x.GetDateTime("ActivityTime")).Return(DateTime.Now);
            dataReader.Stub(x => x.GetString("BlogUrl")).Return("");
            dataReader.Stub(x => x.GetInt32("PostID")).Return(1);
            dataReader.Stub(x => x.GetString("DnaUrl")).Return("h2g2");
            dataReader.Stub(x => x.GetInt32("ForumID")).Return(1);
            dataReader.Stub(x => x.GetInt32("ThreadID")).Return(1);
            dataReader.Stub(x => x.GetString("ObjectUri")).Return(ObjectUri);
            dataReader.Stub(x => x.GetString("ObjectTitle")).Return("ObjectTitle");
            dataReader.Stub(x => x.GetString("Body")).Return("textbody");
            dataReader.Stub(x => x.GetInt32("rating")).Return(0);
            dataReader.Stub(x => x.GetInt32("MaxRating")).Return(0);
            dataReader.Stub(x => x.GetString("ObjectUriFormat")).Return(ObjectUriFormat);
            dataReader.Stub(x => x.GetString("ContentPermaUrl")).Return("");
            dataReader.Stub(x => x.GetString("CustomActivityType")).Return(CustomActivityType);
            

            return dataReader;
        }
    }
}
