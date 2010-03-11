using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace BBC.Dna.Moderation.Utils.Tests
{
    /// <summary>
    /// Summary description for ProfanityFilterTests
    /// </summary>
    [TestClass]
    public class ProfanityFilterTests
    {
        public MockRepository mocks = new MockRepository();
        

        [TestMethod]
        public void InitialiseProfanities_ValidDB_InitObject()
        {
            InitialiseProfanities();
        }

        static public void InitialiseProfanities()
        {
            var mocks = new MockRepository();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.GetInt32("modclassid")).Return(0);
            reader.Stub(x => x.GetStringNullAsEmpty("Profanity")).Return("profanity");
            reader.Stub(x => x.GetByte("Refer")).Return(0);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();
            readerCreator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);
            mocks.ReplayAll();

            ProfanityFilter.InitialiseProfanities(readerCreator, null);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("getallprofanities"));
        }

        static public void InitialiseProfanitiesWithRefer()
        {
            var mocks = new MockRepository();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.GetInt32("modclassid")).Return(0);
            reader.Stub(x => x.GetStringNullAsEmpty("Profanity")).Return("refer");
            reader.Stub(x => x.GetByte("Refer")).Return(1);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();
            readerCreator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);
            mocks.ReplayAll();

            ProfanityFilter.InitialiseProfanities(readerCreator, null);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("getallprofanities"));
        }
    }
}