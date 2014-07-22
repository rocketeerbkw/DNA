using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using System.Collections.Generic;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using System.Xml;
using BBC.Dna.Common;
using System;
using BBC.DNA.Moderation.Utils;

namespace BBC.Dna.Moderation.Utils.Tests
{
    /// <summary>
    /// Summary description for ProfanityFilterTests
    /// </summary>
    [TestClass]
    public class ProfanityFilterTests
    {
        private readonly MockRepository _mocks = new MockRepository();

        [TestInitialize]
        public void Setup()
        {
            InitialiseProfanities();

        }

        [TestMethod]
        public void InitialiseProfanities_ValidDB_ReturnsFilledObject()
        {
            var modclassId = new Queue<int>();
            modclassId.Enqueue(1);
            modclassId.Enqueue(2);
            modclassId.Enqueue(2);
            var profanity = new Queue<string>();
            profanity.Enqueue("hello");
            profanity.Enqueue("hello1");
            profanity.Enqueue("hello");
            var refer = new Queue<byte>();
            refer.Enqueue(1);
            refer.Enqueue(0);
            refer.Enqueue(1);

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            reader.Stub(x => x.GetInt32("ModClassID")).Return(0).WhenCalled(x => x.ReturnValue = modclassId.Dequeue());
            reader.Stub(x => x.GetStringNullAsEmpty("Profanity")).Return("").WhenCalled(x => x.ReturnValue = profanity.Dequeue());
            reader.Stub(x => x.GetByte("Refer")).Return(1).WhenCalled(x => x.ReturnValue = refer.Dequeue());


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var profanityObj = new ProfanityFilter(creator, diag, cache, null, null);

            Assert.AreEqual(2, profanityObj.GetObjectFromCache().ProfanityClasses.ModClassProfanities.Keys.Count);
            creator.AssertWasCalled(x => x.CreateDnaDataReader("getallprofanities"));
        }

        [TestMethod]
        public void InitialiseProfanities_EmptyDB_ReturnsEmptyObject()
        {


            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
        

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var profanityObj = new ProfanityFilter(creator, diag, cache, null, null);

            Assert.AreEqual(0, ProfanityFilter.GetObject().GetObjectFromCache().ProfanityClasses.ModClassProfanities.Keys.Count);
            creator.AssertWasCalled(x => x.CreateDnaDataReader("getallprofanities"));
        }

        [TestMethod]
        public void InitialiseProfanities_VersionInCache_ReturnsCachedObj()
        {
            var cacheObj = GetProfanityCacheObject();

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(ProfanityFilter.GetCacheKey())).Return(cacheObj);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var profanityObj = new ProfanityFilter(creator, diag, cache, null, null);

            Assert.AreEqual(cacheObj.ProfanityClasses.ModClassProfanities.Count, ProfanityFilter.GetObject().GetObjectFromCache().ProfanityClasses.ModClassProfanities.Keys.Count);
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("getallprofanities"));
        }

        [TestMethod]
        public void HandleSignal_CorrectSignal_ReturnsValidObject()
        {
            var signalType = "recache-terms";
            var cacheObj = GetProfanityCacheObject();
            var modclassId = new Queue<int>();
            modclassId.Enqueue(1);
            modclassId.Enqueue(2);
            modclassId.Enqueue(2);
            
            var forumId = new Queue<int>();
            forumId.Enqueue(1);
            forumId.Enqueue(2);
            forumId.Enqueue(2);
            
            var profanity = new Queue<string>();
            profanity.Enqueue("hello");
            profanity.Enqueue("hello1");
            profanity.Enqueue("hello");
            var refer = new Queue<byte>();
            refer.Enqueue(1);
            refer.Enqueue(0);
            refer.Enqueue(1);

            var cache = _mocks.DynamicMock<ICacheManager>();
             cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey("LASTUPDATE"))).Return(false).Repeat.Once();
             cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey())).Return(true).Repeat.Once();
             cache.Stub(x => x.GetData(ProfanityFilter.GetCacheKey())).Return(cacheObj).Repeat.Once();

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(3);
            reader.Stub(x => x.GetInt32("ModClassID")).Return(0).WhenCalled(x => x.ReturnValue = modclassId.Dequeue());
            reader.Stub(x => x.GetInt32("ForumID")).Return(0).WhenCalled(x => x.ReturnValue = forumId.Dequeue());
            reader.Stub(x => x.GetStringNullAsEmpty("Profanity")).Return("").WhenCalled(x => x.ReturnValue = profanity.Dequeue());
            reader.Stub(x => x.GetByte("Refer")).Return(1).WhenCalled(x => x.ReturnValue = refer.Dequeue());


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var profanityObj = new ProfanityFilter(creator, diag, cache, null, null);
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("getallprofanities"));
            Assert.AreEqual(cacheObj.ProfanityClasses.ModClassProfanities.Count, ProfanityFilter.GetObject().GetObjectFromCache().ProfanityClasses.ModClassProfanities.Keys.Count);
            Assert.AreEqual(cacheObj.ProfanityClasses.ForumProfanities.Count, ProfanityFilter.GetObject().GetObjectFromCache().ProfanityClasses.ForumProfanities.Keys.Count);

            Assert.IsTrue(profanityObj.HandleSignal(signalType, null));

            creator.AssertWasCalled(x => x.CreateDnaDataReader("getallprofanities"));
            
        }

        /// <summary>
        /// Test checking an empty string
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_TestEmptyString()
        {
            Console.WriteLine("TestEmptyString");
            string matching;
            List<Term> terms = null;
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(1, "", out matching, out terms, 0));
        }

        /// <summary>
        /// Test a simple string passing the profanity check
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_TestSimpleString()
        {
            Console.WriteLine("TestSimpleString");
            string matching;
            List<Term> terms = null;
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(1, "No bad words here. This will pass. [Honestly].", out matching, out terms, 0));
        }

        /// <summary>
        /// Testing various profanity hits and misses
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_CheckForProfanities()
        {
            Console.WriteLine("ReferContent");
            string matching;
            int forumID = 0;
            List<Term> terms = null;
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity Adam Khatib (No idea who that is)", out matching, out terms, forumID), "Matching a referred name");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity adam khatiB (No idea who that is)", out matching, out terms, forumID), "Matching a referred name (mixed up case)");
            Assert.AreEqual("adam khatib", matching, "Wrong matching string returned");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(1, "This contains the profanity Adam Khatib (No idea who that is)", out matching, out terms, forumID), "No match from a different site");

            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.p", out matching, out terms, forumID), "Matching a blocked thing");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity www.mfbb.NET/speakerScorner/speakerscorner/index.p", out matching, out terms, forumID), "Matching a blocked thing (mixed case)");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(3, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching, out terms, forumID), "No match with trailing characters");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(2, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching, out terms, forumID), "No match to mod class with no profanities");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity 84 Fresh yid", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity 84 Fresh", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity yid 84 Fresh", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanities piss Poska Macca", out matching, out terms, forumID), "Matching the referred profanities");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(2, "", out matching, out terms, forumID), "No match with trailing characters");

            //Check punctuation trimming
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "Adam Khatib><!!", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "@@@@Adam Khatib", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity with punctuation in the middle @@@Adam--- !£Khatib><!! (No idea who that is)", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity ####yid@@@@", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "yid@@@@", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "yid!", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, " yid ", out matching, out terms, forumID), "Will either refer or block - probably should block");

            //Test a profanity that includes punctuation
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a f*** test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a f***!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a *ff***!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a *f***f!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
        }

        /// <summary>
        /// Testing DoesTextContain function
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_TestDoesTextContain()
        {
            Console.WriteLine("TestDoesTextContain");
            string testdata = @"This is a little test, which contains some <words> to match up";
            string match;

            List<string> shortlist = new List<string>(new string[] { "aaa", "bbb", "ccc" });
            List<string> ttlist = new List<string>(new string[] { "aaa", "bbb", "ccc", "tt" });
            List<string> tainslist = new List<string>(new string[] { "aaa", "bbb", "ccc", "tains" });
            List<string> contalist = new List<string>(new string[] { "aaa", "bbb", "ccc", "conta" });
            List<string> contalist2 = new List<string>(new string[] { "aaa", "bbb", "ccc", "conta", "" });
            List<string> emptylist = new List<string>(new string[] { });


            bool bMatch = ProfanityFilter.DoesTextContain("", shortlist, false, false, out match);
            Assert.IsFalse(bMatch, "Empty string case failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain("abcde", shortlist, false, false, out match), "Single word matching failed");

            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, shortlist, false, false, out match), "no match failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, ttlist, false, false, out match), "tt match failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, ttlist, true, false, out match), "no match failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, ttlist, false, true, out match), "no match failed");
            Assert.IsTrue(ProfanityFilter.DoesTextContain(testdata, ttlist, true, true, out match), "partial match failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, tainslist, false, true, out match), "trailing match failed");
            Assert.IsTrue(ProfanityFilter.DoesTextContain(testdata, tainslist, true, false, out match), "trailing match failed");
            Assert.IsTrue(ProfanityFilter.DoesTextContain(testdata, contalist, false, true, out match), "leading match failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, contalist, true, false, out match), "leading match failed");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, contalist, true, false, out match), "Test 1 for badly formed delimited string");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, contalist2, true, false, out match), "Test 2 for badly formed delimited string");
            Assert.IsFalse(ProfanityFilter.DoesTextContain(testdata, contalist2, true, false, out match), "Test 3 for badly formed delimited string");
        }

        /// <summary>
        /// Quick list of test cases for Terms filter
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_TermsList()
        {
            Console.WriteLine("Terms filtering");
            string testdata1 = "Hello piss off";
            string testdata2 = "Hi Poska Macca";
            string testdata3 = "Hi poska macca Poska macca";
            string testdata4 = "Hi piss poska Macca piss macca Poska";
            string match;

            List<string> quicklist = new List<string>(new string[] { "piss", "Poska", "Macca" });

            bool isMatch = ProfanityFilter.DoesTextContain(testdata1, quicklist, false, false, out match);
            Assert.AreEqual("piss", match);

            isMatch = ProfanityFilter.DoesTextContain(testdata2, quicklist, false, false, out match);
            Assert.AreEqual("Poska Macca", match);

            isMatch = ProfanityFilter.DoesTextContain(testdata3, quicklist, false, false, out match);
            Assert.AreEqual("Poska", match);
            Assert.AreNotEqual("poska", match);

            isMatch = ProfanityFilter.DoesTextContain(testdata4, quicklist, false, false, out match);
            Assert.AreNotEqual("piss Poska", match);
            Assert.AreEqual("piss Poska Macca", match);
        }

        /// <summary>
        /// Test removing links from text.
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_RemoveLinksFromText()
        {
            string testInput = @"Here is some text. It contains a link, http://www.bbc.co.uk/dna/h2g2/inspectuser?id=324.";

            string testOuput = ProfanityFilter.RemoveLinksFromText(testInput);

            //notice that the . from the end of the URL is captured in the containing regex. This doesn't matter in this instance.
            string expectedResults = @"Here is some text. It contains a link, ";
            Assert.AreEqual(expectedResults, testOuput);
        }

        /// <summary>
        /// Examines the TrimPunctuation method.
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_TestTrimPunctuation()
        {
            string testInput = @"--**&&&*(*&(*&^%^%^&%&^%&%";
            Assert.AreEqual("", ProfanityFilter.TrimPunctuation(testInput));

            testInput = "This is a test &*(&(*&(*&(*&(*&(*&^%&^%&^%^%&^%&^";
            Assert.AreEqual("This is a test ", ProfanityFilter.TrimPunctuation(testInput));

            testInput = "^&*^&*^&^*& £££$££ This is a test ";
            Assert.AreEqual("  This is a test ", ProfanityFilter.TrimPunctuation(testInput));

            testInput = "This is a @ test";
            Assert.AreEqual("This is a  test", ProfanityFilter.TrimPunctuation(testInput));

            testInput = "^&*^&*^1&^*& £££$££ This is a test &*(&(*&(*&(*&(*2&(*&^%&^%&^%^%&^%&^";
            Assert.AreEqual("1  This is a test 2", ProfanityFilter.TrimPunctuation(testInput));
        }

        /// <summary>
        /// Test that a profanity is not detected inside a link within the input text.
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_CheckForProfanitiesWithInputContainingUrls()
        {
            string testInput = @"Here is some text. It contains a link, http://www.bbc.co.uk/dna/h2g2/inspectuser?id=324.";
            List<string> wordList1 = new List<string>(new string[] { "dna" });
            List<string> wordList2 = new List<string>(new string[] { "link" });
            string match;

            Assert.IsTrue(ProfanityFilter.DoesTextContain(testInput, wordList1, false, false, out match));//should trap words in urls
            Assert.IsTrue(ProfanityFilter.DoesTextContain(testInput, wordList2, false, false, out match));
        }

        /// <summary>
        /// Testing various profanity hits and misses
        /// </summary>
        [TestMethod]
        public void CheckForProfanities_CheckForProfanitiesUsingModClassId()
        {
            Console.WriteLine("ReferContent");
            int modclass1 = 3;
            int modclass2 =  2;
            int forumID = 0;
            string matching;
            List<Term> terms = null;
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity Adam Khatib (No idea who that is)", out matching, out terms, forumID), "Matching a referred name");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity adam khatiB (No idea who that is)", out matching, out terms, forumID), "Matching a referred name (mixed up case)");
            Assert.AreEqual("adam khatib", matching, "Wrong matching string returned");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass2, "This contains the profanity Adam Khatib (No idea who that is)", out matching, out terms, forumID), "No match from a different site");

            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.p", out matching, out terms, forumID), "Matching a blocked thing");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.NET/speakerScorner/speakerscorner/index.p", out matching, out terms, forumID), "Matching a blocked thing (mixed case)");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching, out terms, forumID), "No match with trailing characters");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass2, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching, out terms, forumID), "No match to mod class with no profanities");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity 84 Fresh yid", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity 84 Fresh", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity yid 84 Fresh", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass2, "", out matching, out terms, forumID), "No match with trailing characters");

            //Check punctuation trimming
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "Adam Khatib><!!", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "@@@@Adam Khatib", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity with punctuation in the middle @@@Adam--- !£Khatib><!! (No idea who that is)", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity ####yid@@@@", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "yid@@@@", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "yid!", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, " yid ", out matching, out terms, forumID), "Will either refer or block - probably should block");

            //Test a profanity that includes punctuation
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a f*** test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a f***!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a *ff***!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a *f***f!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
        }

        [TestMethod]
        public void CheckForProfanities_CheckForProfanitiesUsingForumId()
        {
            Console.WriteLine("ReferContent");
            int modclass1 = 3;
            int forumID = 1;
            string matching;
            List<Term> terms = null;
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity Adam Khatib (No idea who that is)", out matching, out terms, forumID), "Matching a referred name");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity adam khatiB (No idea who that is)", out matching, out terms, forumID), "Matching a referred name (mixed up case)");
            Assert.AreEqual("adam khatib", matching, "Wrong matching string returned");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity Adam Khatib (No idea who that is)", out matching, out terms, forumID), "No match from a different site");

            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.p", out matching, out terms, forumID), "Matching a blocked thing");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.NET/speakerScorner/speakerscorner/index.p", out matching, out terms, forumID), "Matching a blocked thing (mixed case)");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching, out terms, forumID), "No match with trailing characters");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching, out terms, forumID), "No match to mod class with no profanities but with forum");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity 84 Fresh yid", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity 84 Fresh", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity yid 84 Fresh", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass1, "", out matching, out terms, forumID), "No match with trailing characters");

            //Check punctuation trimming
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "Adam Khatib><!!", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "@@@@Adam Khatib", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity with punctuation in the middle @@@Adam--- !£Khatib><!! (No idea who that is)", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity ####yid@@@@", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "yid@@@@", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "yid!", out matching, out terms, forumID), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, " yid ", out matching, out terms, forumID), "Will either refer or block - probably should block");

            //Test a profanity that includes punctuation
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a f*** test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a f***!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a *ff***!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(modclass1, "This is a *f***f!!!!!!!!! test", out matching, out terms, forumID), "Matching a referred name with punctuation");
        }

        [TestMethod]
        public void CheckForProfanities_CheckForProfanitiesUsingModClassId_ForumID()
        {
            Console.WriteLine("ReferContent");
            int modclass1 = 1;
            int forumID = 1;
            string matching;
            List<Term> terms = null;

            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass1, "This contains the profanity rag head and Celtic Music(No idea who that is)", out matching, out terms, forumID), "Matching a referred name");
            Assert.AreNotEqual("rag head Celtic Music", matching);
            Assert.AreEqual("rag head celtic music", matching); 

        }

        [TestMethod]
        public void CheckForProfanities_ProfanityWith_A_PreceedingLetter()
        {
            Console.WriteLine("Should not ReferContent -  bug fixing");
            var modclass3 = 3;
            var forumId = 1;
            var matching = string.Empty;
            List<Term> terms = null;
            var textToSearch = "Sinvade should pass, as the profanity word is preceeded by S";

            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass3, textToSearch, out matching, out terms, forumId), "Should not match - invade");
            Assert.AreEqual(string.Empty, matching);
        }

        [TestMethod]
        public void CheckForProfanities_ProfanityWith_A_PreceedingNonChar()
        {
            Console.WriteLine("ReferContent -  bug fixing");
            var modclass3 = 3;
            var forumId = 1;
            var matching = string.Empty;
            List<Term> terms = null;
            var textToSearch = ":invade should pass, as the profanity word is preceeded by non letter...";

            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass3, textToSearch, out matching, out terms, forumId), "Should not match - invade");
            Assert.AreEqual("invade", matching);
        }

        [TestMethod]
        public void CheckForProfanities_ProfanityWith_Prefix()
        {
            Console.WriteLine("Should not ReferContent -  bug fixing");
            var modclass3 = 3;
            var forumId = 1;
            var matching = string.Empty;
            List<Term> terms = null;
            var textToSearch = "Prinvade should pass, as the profanity word is preceeded by pr";

            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(modclass3, textToSearch, out matching, out terms, forumId), "Should not match - invade");
            Assert.AreEqual(string.Empty, matching);
        }

        [TestMethod]
        public void CheckForProfanities_ProfanityFound_Success()
        {
            Console.WriteLine("ReferContent -  bug fixing");
            var modclass3 = 3;
            var forumId = 1;
            var matching = string.Empty;
            List<Term> terms = null;
            var textToSearch = "Invade should not pass, is in profanity list.";

            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(modclass3, textToSearch, out matching, out terms, forumId), "matching referred word - invade");
            Assert.AreEqual("invade", matching);
        }

        [TestMethod]
        public void GetTermsStats_GetsValidStats_ReturnsValidObject()
        {
            var cacheObj = GetProfanityCacheObject();

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(ProfanityFilter.GetCacheKey())).Return(cacheObj);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var profanityObj = new ProfanityFilter(creator, diag, cache, null, null);

            var stats = profanityObj.GetStats(typeof(ProfanityFilter));
            Assert.IsNotNull(stats);
            Assert.AreEqual(typeof(ProfanityFilter).AssemblyQualifiedName, stats.Name);
            foreach (var modclass in profanityObj.GetObjectFromCache().ProfanityClasses.ModClassProfanities)
            {
                Assert.AreEqual(modclass.Value.ProfanityList.Count.ToString(), stats.Values["ModClassID_" + modclass.Key.ToString() + "_ProfanityList"]);
                Assert.AreEqual(modclass.Value.ReferList.Count.ToString(), stats.Values["ModClassID_" + modclass.Key.ToString() + "_ReferList"]);
            }

            
            

        }


        /// <summary>
        /// loads xml into a cacheable objecy
        /// </summary>
        /// <returns></returns>
        public static ProfanityCache GetProfanityCacheObject()
        {
            if (profanityCache != null)
            {
                return profanityCache;
            }

            profanityCache = new ProfanityCache();
            var testXml = new XmlDocument();
            testXml.LoadXml(ProfanityTestXml);

            var nodes = testXml.SelectNodes("//profanities/P");
            foreach(XmlNode node in nodes)
            {
                int modClassId = int.Parse(node.Attributes["ModClassID"].Value);
                int refer = int.Parse(node.Attributes["Refer"].Value);

                int forumId = 0;

                if (node.Attributes["ForumID"] != null)
                {
                    forumId = int.Parse(node.Attributes["ForumID"].Value);
                }

                if (!profanityCache.ProfanityClasses.ModClassProfanities.ContainsKey(modClassId))
                {
                    profanityCache.ProfanityClasses.ModClassProfanities.Add(modClassId, new ProfanityPair());
                }

                //Adding the profanities based on the forumID
                if (!profanityCache.ProfanityClasses.ForumProfanities.ContainsKey(forumId))
                {
                    profanityCache.ProfanityClasses.ForumProfanities.Add(forumId, new ProfanityPair());
                }


                if(refer == 1)
                {
                    profanityCache.ProfanityClasses.ModClassProfanities[modClassId].ReferList.Add(new KeyValuePair<int,string> (Convert.ToInt32(node.Attributes["ProfanityID"].Value.ToString()),node.Attributes["Profanity"].Value.ToLower()));
                    profanityCache.ProfanityClasses.ForumProfanities[forumId].ReferList.Add(new KeyValuePair<int, string>(Convert.ToInt32(node.Attributes["ProfanityID"].Value.ToString()), node.Attributes["Profanity"].Value.ToLower()));
                }
                else
                {
                    profanityCache.ProfanityClasses.ModClassProfanities[modClassId].ProfanityList.Add(new KeyValuePair<int, string>(Convert.ToInt32(node.Attributes["ProfanityID"].Value.ToString()), node.Attributes["Profanity"].Value.ToLower()));
                    profanityCache.ProfanityClasses.ForumProfanities[forumId].ProfanityList.Add(new KeyValuePair<int, string>(Convert.ToInt32(node.Attributes["ProfanityID"].Value.ToString()), node.Attributes["Profanity"].Value.ToLower()));
                }

            }
            return profanityCache;
        }

        /// <summary>
        /// copy of created object
        /// </summary>
        private static ProfanityCache profanityCache=null;

        public static ProfanityFilter InitialiseProfanities()
        {
            MockRepository _mocks = new MockRepository();
            var cacheObj = GetProfanityCacheObject();

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(ProfanityFilter.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(ProfanityFilter.GetCacheKey())).Return(cacheObj);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallprofanities")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            return new ProfanityFilter(creator, diag, cache, null, null);
        }

        #region Test XML
        private static string ProfanityTestXml = @"<profanities>
    <P ProfanityID=""2145"" Profanity=""batty boy"" MODCLASSID=""1"" Refer=""1"" ForumID=""1"" />
    <P ProfanityID=""4122"" Profanity=""Beshenivsky"" MODCLASSID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""4143"" Profanity=""Bomb"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4144"" Profanity=""Bombing"" MODCLASSID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""4095"" Profanity=""Bradley John Murdoch"" MODCLASSID=""1"" Refer=""1"" ForumID=""3""  />
    <P ProfanityID=""4096"" Profanity=""Bradley Murdoch"" MODCLASSID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""2142"" Profanity=""cu nt"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""1784"" Profanity=""cunt"" MODCLASSID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""1785"" Profanity=""cunts"" MODCLASSID=""1"" Refer=""1"" ForumID=""3""  />
    <P ProfanityID=""2143"" Profanity=""f uck"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4093"" Profanity=""Falconio"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2144"" Profanity=""fck ing"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2148"" Profanity=""Felching"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3997"" Profanity=""Gina Ford"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4206"" Profanity=""Heather Mills"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4094"" Profanity=""Joanne Lees"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2153"" Profanity=""knob head"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3975"" Profanity=""Lawrence"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3976"" Profanity=""Lawrence's"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3977"" Profanity=""Lawrences"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4222"" Profanity=""Macca"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4083"" Profanity=""maxine carr"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4205"" Profanity=""McCartney"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""1782"" Profanity=""motherfucker"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""1783"" Profanity=""motherfuckers"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4221"" Profanity=""Mucca"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4092"" Profanity=""Peter Falconio"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4134"" Profanity=""rag head"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4133"" Profanity=""raghead"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3973"" Profanity=""Stephen Lawrence’s"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3974"" Profanity=""Stephen Lawrences"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4132"" Profanity=""towel head"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4131"" Profanity=""towelhead"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2147"" Profanity=""tw at"" MODCLASSID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2273"" Profanity=""(ock"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1522"" Profanity=""A$$hole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1524"" Profanity=""A$$hole$"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1523"" Profanity=""A$$holes"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1579"" Profanity=""A+*hole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3512"" Profanity=""a.rse"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1571"" Profanity=""ar$ehole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1525"" Profanity=""Ar$hole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1526"" Profanity=""Ar$holes"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1701"" Profanity=""ar5h0le"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1703"" Profanity=""ar5h0les"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2636"" Profanity=""ars3"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2635"" Profanity=""arse hole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""970"" Profanity=""arseh0le"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""972"" Profanity=""arseh0les"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""917"" Profanity=""arsehol"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""865"" Profanity=""arsehole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""866"" Profanity=""arseholes"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3482"" Profanity=""arsewipe"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""971"" Profanity=""arsh0le"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""867"" Profanity=""arshole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""868"" Profanity=""arsholes"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""869"" Profanity=""ashole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2638"" Profanity=""ass h0le"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2637"" Profanity=""ass hole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""973"" Profanity=""assh0le"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""974"" Profanity=""assh0les"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""870"" Profanity=""asshole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""871"" Profanity=""assholes"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3520"" Profanity=""b.astard"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3511"" Profanity=""b.ollocks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3519"" Profanity=""b.ugger"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1756"" Profanity=""b00tha"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1757"" Profanity=""b00thas"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""875"" Profanity=""b0ll0cks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1531"" Profanity=""B0llocks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3820"" Profanity=""bastards"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3484"" Profanity=""basterd"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2261"" Profanity=""batty&amp;nbsp;boi"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2260"" Profanity=""batty&amp;nbsp;boy"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4079"" Profanity=""bbchidden.blogspot.com"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4147"" Profanity=""Beef curtains"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1749"" Profanity=""bo****ks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1532"" Profanity=""Boll0cks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""872"" Profanity=""bollocks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""490"" Profanity=""bollox"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""492"" Profanity=""bolocks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""491"" Profanity=""bolox"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1755"" Profanity=""bootha"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1754"" Profanity=""boothas"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""925"" Profanity=""Bukkake"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1533"" Profanity=""Bullsh!t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2919"" Profanity=""bum bandit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2634"" Profanity=""bum hole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2923"" Profanity=""bum-bandit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2921"" Profanity=""bumbandit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2633"" Profanity=""bumh0l3"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2631"" Profanity=""bumh0le"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2632"" Profanity=""bumhol3"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2630"" Profanity=""bumhole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1481"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""815"" Profanity=""C**t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""819"" Profanity=""C**t's"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""818"" Profanity=""C**ts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""360"" Profanity=""c.u.n.t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3514"" Profanity=""c.unt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3507"" Profanity=""c.untyb.ollocks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""504"" Profanity=""c00n"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1808"" Profanity=""C0cksucka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1809"" Profanity=""C0cksucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1720"" Profanity=""cnut"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1719"" Profanity=""cnuts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2272"" Profanity=""Co(k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2255"" Profanity=""coc&amp;nbsp;k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1807"" Profanity=""Cocksucka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1806"" Profanity=""Cocksucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1886"" Profanity=""Cok"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""503"" Profanity=""coon"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1974"" Profanity=""cu&amp;nbsp;nt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1975"" Profanity=""cu&amp;nbsp;nts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""358"" Profanity=""Cunt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""362"" Profanity=""Cunt's"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""879"" Profanity=""cunting"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""361"" Profanity=""Cunts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1758"" Profanity=""cvnt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1759"" Profanity=""cvnts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2453"" Profanity=""D**khead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2541"" Profanity=""dick&amp;nbsp;head"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""933"" Profanity=""dickhead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""471"" Profanity=""dumbfuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""472"" Profanity=""dumbfucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2454"" Profanity=""Dxxkhead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1641"" Profanity=""effing"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2778"" Profanity=""F o a d"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2869"" Profanity=""f u c k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2900"" Profanity=""f u c ked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1588"" Profanity=""f###"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1497"" Profanity=""f##k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3525"" Profanity=""f##king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3524"" Profanity=""f#cked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""449"" Profanity=""F$cks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2527"" Profanity=""f&amp;nbsp;cked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1521"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2258"" Profanity=""f&amp;nbsp;uck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2537"" Profanity=""f&amp;nbsp;ucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2532"" Profanity=""f&amp;nbsp;ucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3523"" Profanity=""F'ck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1587"" Profanity=""f***"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1489"" Profanity=""f*****g"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""888"" Profanity=""f****d"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""890"" Profanity=""f***ed"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""991"" Profanity=""f***in"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""939"" Profanity=""f***ing"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""941"" Profanity=""f**k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""855"" Profanity=""f**ked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""859"" Profanity=""f**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""945"" Profanity=""f**kin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""853"" Profanity=""f**king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""857"" Profanity=""f**ks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""467"" Profanity=""f*ck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""856"" Profanity=""f*ked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""860"" Profanity=""f*ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""858"" Profanity=""f*ks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""466"" Profanity=""f*uck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1527"" Profanity=""F*uk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2777"" Profanity=""F-o-a-d"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2775"" Profanity=""F.O.A.D"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2776"" Profanity=""F.O.A.D."" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""431"" Profanity=""f.u.c.k."" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3508"" Profanity=""f.uck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1885"" Profanity=""f@ck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2767"" Profanity=""f@g"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2766"" Profanity=""f@gs"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2828"" Profanity=""f^^k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2829"" Profanity=""f^^ked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2833"" Profanity=""f^^ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2830"" Profanity=""f^^king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2831"" Profanity=""f^ck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2834"" Profanity=""f^cker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2836"" Profanity=""f^cking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2866"" Profanity=""f00k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2299"" Profanity=""Fack"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2307"" Profanity=""Fackin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2318"" Profanity=""facking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""854"" Profanity=""fc*king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4070"" Profanity=""fck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2259"" Profanity=""fck&amp;nbsp;ing"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1748"" Profanity=""fck1ng"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1747"" Profanity=""fcking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4071"" Profanity=""fcks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1792"" Profanity=""fckw1t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1791"" Profanity=""fckwit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""433"" Profanity=""fcuk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""439"" Profanity=""fcuked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""445"" Profanity=""fcuker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""455"" Profanity=""fcukin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""436"" Profanity=""fcuking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""442"" Profanity=""fcuks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2300"" Profanity=""feck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2309"" Profanity=""feckin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2319"" Profanity=""fecking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3486"" Profanity=""fekking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""495"" Profanity=""felch"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""498"" Profanity=""felched"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2263"" Profanity=""Felching"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""494"" Profanity=""feltch"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""497"" Profanity=""feltcher"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""496"" Profanity=""feltching"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2774"" Profanity=""FOAD"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2303"" Profanity=""frig"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2323"" Profanity=""frigging"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2312"" Profanity=""frigin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2322"" Profanity=""friging"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2256"" Profanity=""fu&amp;nbsp;ck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2528"" Profanity=""fu&amp;nbsp;cked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2538"" Profanity=""fu&amp;nbsp;cker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2533"" Profanity=""fu&amp;nbsp;cking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2433"" Profanity=""fu(k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""468"" Profanity=""fu*k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1811"" Profanity=""fu@k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1812"" Profanity=""fu@ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2832"" Profanity=""fu^k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2835"" Profanity=""fu^ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2837"" Profanity=""fu^king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""470"" Profanity=""fuc"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2529"" Profanity=""fuc&amp;nbsp;ked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2539"" Profanity=""fuc&amp;nbsp;ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2534"" Profanity=""fuc&amp;nbsp;king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""430"" Profanity=""fuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2871"" Profanity=""Fùck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""886"" Profanity=""fúck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2865"" Profanity=""Fúçk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2870"" Profanity=""Fûck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2872"" Profanity=""Fück"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2530"" Profanity=""fuck&amp;nbsp;ed"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2535"" Profanity=""fuck&amp;nbsp;ing"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1788"" Profanity=""fuck-wit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2531"" Profanity=""fucke&amp;nbsp;d"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""437"" Profanity=""fucked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""443"" Profanity=""fucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1563"" Profanity=""fuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2536"" Profanity=""fucki&amp;nbsp;ng"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""453"" Profanity=""fuckin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""434"" Profanity=""fucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""881"" Profanity=""fúcking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""463"" Profanity=""fuckk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""440"" Profanity=""fucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2271"" Profanity=""Fuckup"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1790"" Profanity=""fuckw1t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1786"" Profanity=""fuckwit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1794"" Profanity=""fucw1t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1793"" Profanity=""fucwit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3500"" Profanity=""Fudge p@cker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2965"" Profanity=""fudge packer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3501"" Profanity=""Fudge-p@cker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3497"" Profanity=""Fudge-packer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3499"" Profanity=""fudgep@cker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2963"" Profanity=""fudgepacker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3498"" Profanity=""Fudgpacker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""432"" Profanity=""fuk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""465"" Profanity=""fukced"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""438"" Profanity=""fuked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""444"" Profanity=""fuker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""454"" Profanity=""fukin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""435"" Profanity=""fuking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2304"" Profanity=""fukk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""459"" Profanity=""fukked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""461"" Profanity=""fukker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""460"" Profanity=""fukkin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2324"" Profanity=""fukking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""441"" Profanity=""fuks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2002"" Profanity=""fvck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1810"" Profanity=""Fvck-up"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1813"" Profanity=""Fvckup"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1789"" Profanity=""fvckw1t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1787"" Profanity=""fvckwit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1969"" Profanity=""Gypo"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1970"" Profanity=""Gypos"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1968"" Profanity=""Gyppo"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2915"" Profanity=""Gyppos"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4062"" Profanity=""http://excoboard.com/exco/index.php?boardid=19215"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4000"" Profanity=""http://kingsofclay.proboards100.com/index.cgi "" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4223"" Profanity=""http://www.kitbag.com/stores/celtic/products/produ"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3454"" Profanity=""http://www.scots.8k.com"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4090"" Profanity=""http://www.yesitshelpful.com"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4009"" Profanity=""Icebreaker uk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4006"" Profanity=""Icebreakeruk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""816"" Profanity=""K**t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1960"" Profanity=""k@ffir"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1961"" Profanity=""k@ffirs"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1959"" Profanity=""k@fir"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1962"" Profanity=""k@firs"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1963"" Profanity=""Kaf1r"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1964"" Profanity=""Kaff1r"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1956"" Profanity=""Kaffir"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1958"" Profanity=""Kaffirs"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1955"" Profanity=""Kafir"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1957"" Profanity=""Kafirs"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2617"" Profanity=""kafr"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1887"" Profanity=""Khunt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""953"" Profanity=""kike"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4227"" Profanity=""kitbag.com"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2268"" Profanity=""knob&amp;nbsp;head"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2269"" Profanity=""Knobber"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2615"" Profanity=""knobhead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""359"" Profanity=""Kunt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""954"" Profanity=""kyke"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2683"" Profanity=""L m f a o"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2685"" Profanity=""L.m.f.a.o"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2684"" Profanity=""L.m.f.a.o."" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2682"" Profanity=""Lmfa0"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2681"" Profanity=""Lmfao"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3515"" Profanity=""m.inge"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3506"" Profanity=""M.otherf.ucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2913"" Profanity=""M1nge"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3938"" Profanity=""mfbb.net/speakerscorner/speakerscorner/index.php?m"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2823"" Profanity=""Minge"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""825"" Profanity=""mof**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""847"" Profanity=""mof**kers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""386"" Profanity=""mofuccer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""368"" Profanity=""mofucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""408"" Profanity=""mofuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""397"" Profanity=""mofucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""373"" Profanity=""mofukcer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""823"" Profanity=""mohterf**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""841"" Profanity=""mohterf**kers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""824"" Profanity=""mohterf*kcer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""385"" Profanity=""mohterfuccer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""423"" Profanity=""mohterfuccers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""377"" Profanity=""mohterfuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""366"" Profanity=""mohterfucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""406"" Profanity=""mohterfuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""395"" Profanity=""mohterfucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""416"" Profanity=""mohterfucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""378"" Profanity=""mohterfuk"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""367"" Profanity=""mohterfukcer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""407"" Profanity=""mohterfukcers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""396"" Profanity=""mohterfuking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""417"" Profanity=""mohterfuks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""822"" Profanity=""moterf**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""384"" Profanity=""moterfuccer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""376"" Profanity=""moterfuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""365"" Profanity=""moterfucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""405"" Profanity=""moterfuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""394"" Profanity=""moterfucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""415"" Profanity=""moterfucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1805"" Profanity=""motha-fucka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""831"" Profanity=""mothaf**k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""826"" Profanity=""mothaf**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""844"" Profanity=""mothaf**kers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""834"" Profanity=""mothaf**king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""848"" Profanity=""mothaf**ks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""387"" Profanity=""mothafuccer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""380"" Profanity=""mothafuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1804"" Profanity=""Mothafucka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""369"" Profanity=""mothafucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""409"" Profanity=""mothafuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""398"" Profanity=""mothafucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""419"" Profanity=""mothafucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""820"" Profanity=""motherf**ked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""821"" Profanity=""Motherf**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""840"" Profanity=""Motherf**kers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""383"" Profanity=""Motherfuccer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""422"" Profanity=""Motherfuccers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""375"" Profanity=""Motherfuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""363"" Profanity=""motherfucked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""364"" Profanity=""Motherfucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""404"" Profanity=""Motherfuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""393"" Profanity=""Motherfucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""414"" Profanity=""Motherfucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""402"" Profanity=""motherfukkker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""829"" Profanity=""mthaf**ka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""390"" Profanity=""mthafucca"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""429"" Profanity=""mthafuccas"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""372"" Profanity=""mthafucka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""412"" Profanity=""mthafuckas"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""374"" Profanity=""mthafukca"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""413"" Profanity=""mthafukcas"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""401"" Profanity=""muth@fucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""832"" Profanity=""muthaf**k"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""827"" Profanity=""muthaf**ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""845"" Profanity=""muthaf**kers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""835"" Profanity=""muthaf**king"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""849"" Profanity=""muthaf**ks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""388"" Profanity=""muthafuccer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""381"" Profanity=""muthafuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""403"" Profanity=""muthafuck@"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4051"" Profanity=""Muthafucka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""370"" Profanity=""muthafucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""410"" Profanity=""muthafuckers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""399"" Profanity=""muthafucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""420"" Profanity=""muthafucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1884"" Profanity=""Muthafukas"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1972"" Profanity=""N1gger"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1973"" Profanity=""N1ggers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3528"" Profanity=""nig nog"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3527"" Profanity=""nig-nog"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3961"" Profanity=""Nigel Cooke"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""500"" Profanity=""nigga"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""502"" Profanity=""niggaz"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""499"" Profanity=""Nigger"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""501"" Profanity=""niggers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3529"" Profanity=""nignog"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2267"" Profanity=""nob&amp;nbsp;head"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2266"" Profanity=""Nobhead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1671"" Profanity=""p**i"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1668"" Profanity=""p*ki"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3516"" Profanity=""p.iss-flaps"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1669"" Profanity=""p@ki"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1684"" Profanity=""p@kis"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1670"" Profanity=""pak1"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""507"" Profanity=""paki"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1680"" Profanity=""pakis"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1753"" Profanity=""pench0d"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1752"" Profanity=""pench0ds"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1750"" Profanity=""penchod"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1751"" Profanity=""penchods"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3505"" Profanity=""Peter dow"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2327"" Profanity=""phelching"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1881"" Profanity=""Phuck"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1883"" Profanity=""Phucker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2315"" Profanity=""phuckin"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1882"" Profanity=""Phucking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1965"" Profanity=""Phucks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3526"" Profanity=""Piss off"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3517"" Profanity=""Pissflaps"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4148"" Profanity=""Poo stabber"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4150"" Profanity=""Poo stabbers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""515"" Profanity=""poofter"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1890"" Profanity=""Prik"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""758"" Profanity=""raghead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""760"" Profanity=""ragheads"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3509"" Profanity=""s.hit"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2264"" Profanity=""S1ut"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3450"" Profanity=""scots.8k.com"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3504"" Profanity=""Scottish National Standard Bearer"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2917"" Profanity=""shirtlifter"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2925"" Profanity=""shirtlifters"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4149"" Profanity=""Shit stabber"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4151"" Profanity=""Shit stabbers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""510"" Profanity=""spic"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1976"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1977"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s "" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3513"" Profanity=""t.wat"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2452"" Profanity=""t0$$er"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""985"" Profanity=""t0sser"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1767"" Profanity=""t0ssers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""979"" Profanity=""to55er"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1768"" Profanity=""to55ers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1769"" Profanity=""tossers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4135"" Profanity=""towel head"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4136"" Profanity=""towelhead"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2262"" Profanity=""tw&amp;nbsp;at"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4076"" Profanity=""tw@"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""474"" Profanity=""tw@t"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1967"" Profanity=""tw@ts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""473"" Profanity=""twat"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1730"" Profanity=""twats"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1888"" Profanity=""Twunt"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1924"" Profanity=""twunts"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2657"" Profanity=""w anker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3522"" Profanity=""W#nker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3521"" Profanity=""W#nkers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3510"" Profanity=""w.ank"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""957"" Profanity=""w@nker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""958"" Profanity=""w@nkers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""975"" Profanity=""w0g"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""976"" Profanity=""w0gs"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2658"" Profanity=""wa nker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4152"" Profanity=""Wan k er"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4153"" Profanity=""Wan k ers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2659"" Profanity=""wan ker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""475"" Profanity=""wank"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""480"" Profanity=""wank's"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4050"" Profanity=""Wanka"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2661"" Profanity=""wanke r"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""478"" Profanity=""wanked"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""477"" Profanity=""wanker"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""987"" Profanity=""wankers"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""476"" Profanity=""wanking"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""479"" Profanity=""wanks"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""508"" Profanity=""wog"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3937"" Profanity=""www.mfbb.net/speakerscorner/speakerscorner/index.p"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4089"" Profanity=""www.yesitshelpful.com"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2265"" Profanity=""Xxxhole"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1520"" Profanity=""Y*d"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""511"" Profanity=""yid"" MODCLASSID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3999"" Profanity=""84 Fresh"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4037"" Profanity=""Abdul Muneem Patel"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4045"" Profanity=""Abdul Patel"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4030"" Profanity=""Abdula Ahmed Ali"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4041"" Profanity=""Abdula Ali"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4044"" Profanity=""Adam Khatib"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4035"" Profanity=""Adam Osman Khatib"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3496"" Profanity=""Advance tickets"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4034"" Profanity=""Arafat Khan"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""516"" Profanity=""arse"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3966"" Profanity=""askew"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3965"" Profanity=""aspew"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4047"" Profanity=""Assad"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4038"" Profanity=""Assad Sarwar"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2716"" Profanity=""b1tch"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""517"" Profanity=""bastard"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4156"" Profanity=""Belton"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4123"" Profanity=""Beshenivsky"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""520"" Profanity=""bitch"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4145"" Profanity=""Bomb"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4146"" Profanity=""Bombing"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4110"" Profanity=""Bradley John Murdoch"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4111"" Profanity=""Bradley Murdoch"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""921"" Profanity=""bugger"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""523"" Profanity=""c0ck"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3873"" Profanity=""CASH PRIZE"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3874"" Profanity=""cash prizes"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3885"" Profanity=""Celtic Distribution"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3888"" Profanity=""Celtic Music"" MODCLASSID=""3"" Refer=""1"" ForumID=""1"" />
    <P ProfanityID=""549"" Profanity=""clit"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""1714"" Profanity=""cock"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4042"" Profanity=""Cossor"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4031"" Profanity=""Cossor Ali"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""545"" Profanity=""cripple"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""529"" Profanity=""d1ck"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""505"" Profanity=""darkie"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""506"" Profanity=""darky"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""528"" Profanity=""dick"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2758"" Profanity=""door price"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3539"" Profanity=""enter free at"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3536"" Profanity=""ENTRIES CLOSE AT"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2760"" Profanity=""fag"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""541"" Profanity=""fagg0t"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""540"" Profanity=""faggot"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2761"" Profanity=""fags"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4108"" Profanity=""Falconio"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""531"" Profanity=""fanny"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3858"" Profanity=""flange"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2687"" Profanity=""Flyers"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2605"" Profanity=""free ipod"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3899"" Profanity=""Free PS3"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3880"" Profanity=""free xbox"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""547"" Profanity=""gimp"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3995"" Profanity=""Gina Ford"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3850"" Profanity=""Glaxo"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3849"" Profanity=""GlaxoSmithKline"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3878"" Profanity=""greyhoundscene"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2610"" Profanity=""gypsies"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2609"" Profanity=""gypsy"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""544"" Profanity=""h0m0"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""543"" Profanity=""h0mo"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4208"" Profanity=""Heather Mills"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""542"" Profanity=""homo"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3935"" Profanity=""http://onerugbyleague.proboards76.com/index.cgi#ge"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""551"" Profanity=""hun"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""550"" Profanity=""huns"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4039"" Profanity=""Ibrahim Savant"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4130"" Profanity=""invade"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4109"" Profanity=""Joanne Lees"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4004"" Profanity=""kings of clay"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4005"" Profanity=""kingsofclay"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""525"" Profanity=""kn0b"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""524"" Profanity=""knob"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""552"" Profanity=""kraut"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4220"" Profanity=""Macca"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4084"" Profanity=""maxine carr"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4207"" Profanity=""McCartney"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4036"" Profanity=""Mehran Hussain"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4129"" Profanity=""migrate"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4155"" Profanity=""Montana"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4219"" Profanity=""Mucca"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2007"" Profanity=""muncher"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""1889"" Profanity=""Munchers"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2435"" Profanity=""n0b"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2434"" Profanity=""nob"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2943"" Profanity=""ogrish.com"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3993"" Profanity=""Peta"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4107"" Profanity=""Peter Falconio"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""537"" Profanity=""piss"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2013"" Profanity=""poff"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""514"" Profanity=""poof"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4154"" Profanity=""Poska"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""527"" Profanity=""pr1ck"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""526"" Profanity=""prick"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3881"" Profanity=""Proper Ganda "" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3886"" Profanity=""Proper Music People"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3882"" Profanity=""Properganda "" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""1601"" Profanity=""pu$$y"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""530"" Profanity=""pussy"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""539"" Profanity=""queer"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""546"" Profanity=""retard"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4046"" Profanity=""Sarwar"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4048"" Profanity=""Savant"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2270"" Profanity=""Scat"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""1528"" Profanity=""Sh!t"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""959"" Profanity=""sh!te"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""960"" Profanity=""sh!tes"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""535"" Profanity=""sh1t"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""536"" Profanity=""sh1te"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""554"" Profanity=""shag"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""534"" Profanity=""shat"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""533"" Profanity=""shite"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""518"" Profanity=""slag"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""513"" Profanity=""spastic"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4117"" Profanity=""spliff"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4032"" Profanity=""Tanvir Hussain"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2686"" Profanity=""Tickets available"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""538"" Profanity=""turd"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4033"" Profanity=""Umar Islam"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4040"" Profanity=""Waheed Zamen"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""519"" Profanity=""whore"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""3542"" Profanity=""win cash prizes"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""509"" Profanity=""wop"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""4049"" Profanity=""Zamen"" MODCLASSID=""3"" Refer=""1"" />
    <P ProfanityID=""2227"" Profanity=""(ock"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1508"" Profanity=""A$$hole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1510"" Profanity=""A$$hole$"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1509"" Profanity=""A$$holes"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1583"" Profanity=""A+*hole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1573"" Profanity=""ar$ehole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1511"" Profanity=""Ar$hole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1512"" Profanity=""Ar$holes"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1707"" Profanity=""ar5h0l3"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1705"" Profanity=""ar5h0le"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1706"" Profanity=""ar5h0les"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2627"" Profanity=""ars3"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2626"" Profanity=""arse hole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""965"" Profanity=""arseh0le"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""967"" Profanity=""arseh0les"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""135"" Profanity=""arsehol "" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""128"" Profanity=""arsehole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""129"" Profanity=""arseholes"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3476"" Profanity=""arsewipe"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""966"" Profanity=""arsh0le"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""134"" Profanity=""arshole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""131"" Profanity=""arsholes"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""133"" Profanity=""ashole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2629"" Profanity=""ass h0le"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2628"" Profanity=""ass hole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""968"" Profanity=""assh0le"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""969"" Profanity=""assh0les"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""132"" Profanity=""asshole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""130"" Profanity=""assholes"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1743"" Profanity=""b00tha"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1744"" Profanity=""b00thas"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""877"" Profanity=""b0ll0cks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1517"" Profanity=""B0llocks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3818"" Profanity=""bastards"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3480"" Profanity=""basterd"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2215"" Profanity=""batty&amp;nbsp;boi"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2214"" Profanity=""batty&amp;nbsp;boy"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4081"" Profanity=""bbchidden.blogspot.com"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4159"" Profanity=""Beef curtains"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1736"" Profanity=""bo****ks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1518"" Profanity=""Boll0cks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""136"" Profanity=""bollocks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""137"" Profanity=""bollox"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""139"" Profanity=""bolocks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""138"" Profanity=""bolox"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1742"" Profanity=""bootha"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1741"" Profanity=""boothas"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""927"" Profanity=""Bukkake"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1519"" Profanity=""Bullsh!t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2625"" Profanity=""bum hole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2624"" Profanity=""bumh0l3"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2622"" Profanity=""bumh0le"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2623"" Profanity=""bumhol3"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2621"" Profanity=""bumhole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1483"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""766"" Profanity=""C**t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""770"" Profanity=""C**t's"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""769"" Profanity=""C**ts"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""7"" Profanity=""c.u.n.t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""151"" Profanity=""c00n"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1827"" Profanity=""C0cksucka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1828"" Profanity=""C0cksucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2226"" Profanity=""Co(k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2209"" Profanity=""coc&amp;nbsp;k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1826"" Profanity=""Cocksucka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1825"" Profanity=""Cocksucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1919"" Profanity=""Cok"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""150"" Profanity=""coon"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2211"" Profanity=""cu&amp;nbsp;nt"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""5"" Profanity=""Cunt"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""9"" Profanity=""Cunt's"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""884"" Profanity=""cunting"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""8"" Profanity=""Cunts"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1745"" Profanity=""cvnt"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1746"" Profanity=""cvnts"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2461"" Profanity=""D**khead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""152"" Profanity=""darkie"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""153"" Profanity=""darky"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""755"" Profanity=""dickhead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""118"" Profanity=""dumbfuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""119"" Profanity=""dumbfucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2462"" Profanity=""Dxxkhead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1643"" Profanity=""effing"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2785"" Profanity=""F o a d"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2877"" Profanity=""f u c k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2898"" Profanity=""f u c ked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1590"" Profanity=""f###"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1499"" Profanity=""f##k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""96"" Profanity=""F$cks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2559"" Profanity=""f&amp;nbsp;cked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1507"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2212"" Profanity=""f&amp;nbsp;uck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2569"" Profanity=""f&amp;nbsp;ucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2564"" Profanity=""f&amp;nbsp;ucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1589"" Profanity=""f***"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1515"" Profanity=""F*****"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1516"" Profanity=""F******"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1491"" Profanity=""f*****g"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""892"" Profanity=""f****d"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""893"" Profanity=""f***ed"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""993"" Profanity=""f***in"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""937"" Profanity=""f***ing"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""943"" Profanity=""f**k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""806"" Profanity=""f**ked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""810"" Profanity=""f**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""947"" Profanity=""f**kin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""804"" Profanity=""f**king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""808"" Profanity=""f**ks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""114"" Profanity=""f*ck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""807"" Profanity=""f*ked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""811"" Profanity=""f*ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""809"" Profanity=""f*ks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""113"" Profanity=""f*uck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1513"" Profanity=""F*uk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2784"" Profanity=""F-o-a-d"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2782"" Profanity=""F.O.A.D"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2783"" Profanity=""F.O.A.D."" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""78"" Profanity=""f.u.c.k."" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1918"" Profanity=""f@ck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2769"" Profanity=""f@g"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2768"" Profanity=""f@gs"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2826"" Profanity=""f^^k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2838"" Profanity=""f^^ked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2842"" Profanity=""f^^ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2839"" Profanity=""f^^king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2840"" Profanity=""f^ck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2843"" Profanity=""f^cker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2845"" Profanity=""f^cking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2874"" Profanity=""f00k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2330"" Profanity=""Fack"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2338"" Profanity=""Fackin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2349"" Profanity=""facking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""805"" Profanity=""fc*king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4072"" Profanity=""fck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2213"" Profanity=""fck&amp;nbsp;ing"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1735"" Profanity=""fck1ng"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1734"" Profanity=""fcking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4073"" Profanity=""fcks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1820"" Profanity=""fckw1t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1819"" Profanity=""fckwit"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""80"" Profanity=""fcuk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""86"" Profanity=""fcuked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""92"" Profanity=""fcuker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""102"" Profanity=""fcukin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""83"" Profanity=""fcuking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""89"" Profanity=""fcuks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2331"" Profanity=""feck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2340"" Profanity=""feckin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2350"" Profanity=""fecking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3478"" Profanity=""feking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""142"" Profanity=""felch"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""145"" Profanity=""felched"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2432"" Profanity=""felchin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2431"" Profanity=""felchin'"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2217"" Profanity=""Felching"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""141"" Profanity=""feltch"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""144"" Profanity=""feltcher"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""143"" Profanity=""feltching"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2781"" Profanity=""FOAD"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2336"" Profanity=""fook"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2345"" Profanity=""fookin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2356"" Profanity=""fooking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2607"" Profanity=""free ipod"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2342"" Profanity=""frickin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2352"" Profanity=""fricking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2334"" Profanity=""frig"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2348"" Profanity=""friggin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2354"" Profanity=""frigging"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2343"" Profanity=""frigin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2353"" Profanity=""friging"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2210"" Profanity=""fu&amp;nbsp;ck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2560"" Profanity=""fu&amp;nbsp;cked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2570"" Profanity=""fu&amp;nbsp;cker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2565"" Profanity=""fu&amp;nbsp;cking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2436"" Profanity=""fu(k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""115"" Profanity=""fu*k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1830"" Profanity=""fu@k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1831"" Profanity=""fu@ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2841"" Profanity=""fu^k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2844"" Profanity=""fu^ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2846"" Profanity=""fu^king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""117"" Profanity=""fuc"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2561"" Profanity=""fuc&amp;nbsp;ked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2571"" Profanity=""fuc&amp;nbsp;ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2566"" Profanity=""fuc&amp;nbsp;king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""77"" Profanity=""fuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2879"" Profanity=""Fùck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""885"" Profanity=""fúck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2873"" Profanity=""Fúçk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2878"" Profanity=""Fûck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2880"" Profanity=""Fück"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2562"" Profanity=""fuck&amp;nbsp;ed"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2567"" Profanity=""fuck&amp;nbsp;ing"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1816"" Profanity=""fuck-wit"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2563"" Profanity=""fucke&amp;nbsp;d"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""84"" Profanity=""fucked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""90"" Profanity=""fucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1567"" Profanity=""fuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2568"" Profanity=""fucki&amp;nbsp;ng"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""100"" Profanity=""fuckin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""81"" Profanity=""fucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""883"" Profanity=""fúcking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""110"" Profanity=""fuckk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""87"" Profanity=""fucks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2225"" Profanity=""Fuckup"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1818"" Profanity=""fuckw1t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1814"" Profanity=""fuckwit"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1822"" Profanity=""fucw1t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1821"" Profanity=""fucwit"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2953"" Profanity=""fudge packer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2951"" Profanity=""fudgepacker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""79"" Profanity=""fuk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""112"" Profanity=""fukced"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""85"" Profanity=""fuked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""91"" Profanity=""fuker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""101"" Profanity=""fukin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""82"" Profanity=""fuking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2335"" Profanity=""fukk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""106"" Profanity=""fukked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""108"" Profanity=""fukker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""107"" Profanity=""fukkin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2355"" Profanity=""fukking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""88"" Profanity=""fuks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2003"" Profanity=""fvck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1829"" Profanity=""Fvck-up"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1832"" Profanity=""Fvckup"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1817"" Profanity=""fvckw1t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1815"" Profanity=""fvckwit"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3963"" Profanity=""http://directory.myfreebulletinboard.com/category."" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4063"" Profanity=""http://excoboard.com/exco/index.php?boardid=19215"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3816"" Profanity=""http://freespeach.proboards3.com/index.cgi"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4001"" Profanity=""http://kingsofclay.proboards100.com/index.cgi "" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3831"" Profanity=""http://www.globalresearch.ca/index.php?context=vie"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3824"" Profanity=""http://www.infowars.net/Pages/Aug05/020805Aswat.ht"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3826"" Profanity=""http://www.israelnationalnews.com/news.php3?id=853"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4224"" Profanity=""http://www.kitbag.com/stores/celtic/products/produ"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3949"" Profanity=""http://www.mfbb.net/"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3953"" Profanity=""http://www.mfbb.net/?mforum=free"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3957"" Profanity=""http://www.mfbb.net/free-about1306.html"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3955"" Profanity=""http://www.mfbb.net/free-forum-8.html"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3950"" Profanity=""http://www.myfreebulletinboard.com/"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3828"" Profanity=""http://www.prisonplanet.com/archives/london/index."" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3825"" Profanity=""http://www.prisonplanet.com/articles/august2005/02"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3829"" Profanity=""http://www.prisonplanet.com/articles/july2005/0907"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3830"" Profanity=""http://www.prisonplanet.com/articles/july2005/1507"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3832"" Profanity=""http://www.theinsider.org/news/article.asp?id=1425"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3827"" Profanity=""http://www.wtvq.com/servlet/Satellite?c=MGArticle&amp;"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4008"" Profanity=""Icebreaker uk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4007"" Profanity=""Icebreakeruk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""767"" Profanity=""K**t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2097"" Profanity=""k@ffir"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2100"" Profanity=""k@ffirs"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2098"" Profanity=""k@fir"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2099"" Profanity=""k@firs"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2094"" Profanity=""kaffir"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2096"" Profanity=""kaffirs"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2093"" Profanity=""kafir"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2095"" Profanity=""kafirs"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2619"" Profanity=""kafr"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1920"" Profanity=""Khunt"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""955"" Profanity=""kike"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4226"" Profanity=""kitbag.com"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2222"" Profanity=""knob&amp;nbsp;head"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2223"" Profanity=""Knobber"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2613"" Profanity=""knobhead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""6"" Profanity=""Kunt"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""956"" Profanity=""kyke"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2690"" Profanity=""L m f a o"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2692"" Profanity=""L.m.f.a.o"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2691"" Profanity=""L.m.f.a.o."" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2689"" Profanity=""Lmfa0"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2688"" Profanity=""Lmfao"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""776"" Profanity=""mof**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""798"" Profanity=""mof**kers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""33"" Profanity=""mofuccer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""15"" Profanity=""mofucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""55"" Profanity=""mofuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""44"" Profanity=""mofucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""20"" Profanity=""mofukcer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""774"" Profanity=""mohterf**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""792"" Profanity=""mohterf**kers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""775"" Profanity=""mohterf*kcer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""32"" Profanity=""mohterfuccer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""70"" Profanity=""mohterfuccers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""24"" Profanity=""mohterfuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""13"" Profanity=""mohterfucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""53"" Profanity=""mohterfuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""42"" Profanity=""mohterfucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""63"" Profanity=""mohterfucks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""25"" Profanity=""mohterfuk"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""14"" Profanity=""mohterfukcer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""54"" Profanity=""mohterfukcers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""43"" Profanity=""mohterfuking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""64"" Profanity=""mohterfuks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""773"" Profanity=""moterf**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""31"" Profanity=""moterfuccer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""23"" Profanity=""moterfuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""12"" Profanity=""moterfucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""52"" Profanity=""moterfuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""41"" Profanity=""moterfucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""62"" Profanity=""moterfucks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1824"" Profanity=""motha-fucka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""782"" Profanity=""mothaf**k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""777"" Profanity=""mothaf**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""795"" Profanity=""mothaf**kers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""785"" Profanity=""mothaf**king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""799"" Profanity=""mothaf**ks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""34"" Profanity=""mothafuccer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""27"" Profanity=""mothafuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1823"" Profanity=""Mothafucka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""16"" Profanity=""mothafucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""56"" Profanity=""mothafuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""45"" Profanity=""mothafucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""66"" Profanity=""mothafucks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""771"" Profanity=""motherf**ked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""772"" Profanity=""Motherf**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""791"" Profanity=""Motherf**kers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3857"" Profanity=""motherfracking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""30"" Profanity=""Motherfuccer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""69"" Profanity=""Motherfuccers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""22"" Profanity=""Motherfuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""10"" Profanity=""motherfucked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""11"" Profanity=""Motherfucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""51"" Profanity=""Motherfuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""40"" Profanity=""Motherfucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""61"" Profanity=""Motherfucks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""49"" Profanity=""motherfukkker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""780"" Profanity=""mthaf**ka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""37"" Profanity=""mthafucca"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""76"" Profanity=""mthafuccas"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""19"" Profanity=""mthafucka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""59"" Profanity=""mthafuckas"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""21"" Profanity=""mthafukca"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""60"" Profanity=""mthafukcas"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""48"" Profanity=""muth@fucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""783"" Profanity=""muthaf**k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""778"" Profanity=""muthaf**ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""796"" Profanity=""muthaf**kers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""786"" Profanity=""muthaf**king"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""800"" Profanity=""muthaf**ks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""35"" Profanity=""muthafuccer"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""28"" Profanity=""muthafuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""50"" Profanity=""muthafuck@"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4054"" Profanity=""Muthafucka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""17"" Profanity=""muthafucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""57"" Profanity=""muthafuckers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""46"" Profanity=""muthafucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""67"" Profanity=""muthafucks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1917"" Profanity=""Muthafuka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1916"" Profanity=""Muthafukas"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2438"" Profanity=""n0b"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2575"" Profanity=""n0bhead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2587"" Profanity=""Nige&amp;nbsp;Cooke"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3962"" Profanity=""Nigel Cooke"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2588"" Profanity=""Nigel&amp;nbsp;C00k"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2589"" Profanity=""Nigel&amp;nbsp;C00ke"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2590"" Profanity=""Nigel&amp;nbsp;Cook"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2591"" Profanity=""Nigel&amp;nbsp;Cook3"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2592"" Profanity=""Nigel&amp;nbsp;Cooke"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""147"" Profanity=""nigga"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""149"" Profanity=""niggaz"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""146"" Profanity=""Nigger"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""148"" Profanity=""niggers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2437"" Profanity=""nob"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2221"" Profanity=""nob&amp;nbsp;head"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2220"" Profanity=""Nobhead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1667"" Profanity=""p**i"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1664"" Profanity=""p*ki"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1665"" Profanity=""p@ki"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1683"" Profanity=""p@kis"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1666"" Profanity=""pak1"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""154"" Profanity=""paki"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1682"" Profanity=""pakis&#xD;"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1740"" Profanity=""pench0d"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1739"" Profanity=""pench0ds"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1737"" Profanity=""penchod"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1738"" Profanity=""penchods"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2358"" Profanity=""phelching"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1913"" Profanity=""Phuck"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1915"" Profanity=""Phucker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2346"" Profanity=""phuckin"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1914"" Profanity=""Phucking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4160"" Profanity=""Poo stabber"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4162"" Profanity=""Poo stabbers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1923"" Profanity=""Prik"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""762"" Profanity=""raghead"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""764"" Profanity=""ragheads"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2218"" Profanity=""S1ut"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4161"" Profanity=""Shit stabber"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4163"" Profanity=""Shit stabbers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""320"" Profanity=""slut"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""157"" Profanity=""spic"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2460"" Profanity=""t0$$er"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""983"" Profanity=""t0sser"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1764"" Profanity=""t0ssers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""981"" Profanity=""to55er"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1765"" Profanity=""to55ers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""754"" Profanity=""tosser"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1766"" Profanity=""tossers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2216"" Profanity=""tw&amp;nbsp;at"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4077"" Profanity=""tw@"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""121"" Profanity=""tw@t"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""120"" Profanity=""twat"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1716"" Profanity=""twats"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1921"" Profanity=""Twunt"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1926"" Profanity=""twunts"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2662"" Profanity=""w anker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""951"" Profanity=""w*****"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1631"" Profanity=""w******"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""952"" Profanity=""w****r"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""961"" Profanity=""w@nker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""962"" Profanity=""w@nkers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""977"" Profanity=""w0g"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""978"" Profanity=""w0gs"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2663"" Profanity=""wa nker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4164"" Profanity=""Wan k er"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4165"" Profanity=""Wan k ers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2664"" Profanity=""wan ker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""122"" Profanity=""wank"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""127"" Profanity=""wank's"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4053"" Profanity=""Wanka"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2666"" Profanity=""wanke r"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""125"" Profanity=""wanked"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""124"" Profanity=""wanker"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""989"" Profanity=""wankers"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""123"" Profanity=""wanking"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""126"" Profanity=""wanks"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""155"" Profanity=""wog"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3960"" Profanity=""www.mfbb.net"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3952"" Profanity=""www.mfbb.net/"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3954"" Profanity=""www.mfbb.net/?mforum=free"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3958"" Profanity=""www.mfbb.net/free-about1306.html"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3956"" Profanity=""www.mfbb.net/free-forum-8.html"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3959"" Profanity=""www.myfreebulletinboard.com"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3951"" Profanity=""www.myfreebulletinboard.com/"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2219"" Profanity=""Xxxhole"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1505"" Profanity=""y*d"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""158"" Profanity=""yid"" MODCLASSID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4017"" Profanity=""Abdul Muneem Patel"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4025"" Profanity=""Abdul Patel"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4010"" Profanity=""Abdula Ahmed Ali"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4021"" Profanity=""Abdula Ali"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4024"" Profanity=""Adam Khatib"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4015"" Profanity=""Adam Osman Khatib"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4014"" Profanity=""Arafat Khan"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""1479"" Profanity=""arse"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3968"" Profanity=""askew"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3967"" Profanity=""aspew"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4027"" Profanity=""Assad"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4018"" Profanity=""Assad Sarwar"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""950"" Profanity=""b******"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""949"" Profanity=""b*****d"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""929"" Profanity=""b****r"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""323"" Profanity=""b1tch"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4066"" Profanity=""barfly"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""318"" Profanity=""bastard"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4168"" Profanity=""Belton"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4125"" Profanity=""Beshenivsky"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""322"" Profanity=""bitch"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4157"" Profanity=""Bomb"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4158"" Profanity=""Bombing"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4105"" Profanity=""Bradley John Murdoch"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4106"" Profanity=""Bradley Murdoch"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""355"" Profanity=""bugger"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""325"" Profanity=""c0ck"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3893"" Profanity=""Celtic Distribution"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3896"" Profanity=""Celtic Music"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3862"" Profanity=""charlote"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3864"" Profanity=""charlote_host"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3863"" Profanity=""charlotte"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3865"" Profanity=""charlotte_host"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""351"" Profanity=""clit"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3895"" Profanity=""CM/Music By Mail"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""324"" Profanity=""cock"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4022"" Profanity=""Cossor"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4011"" Profanity=""Cossor Ali"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""350"" Profanity=""crap"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""347"" Profanity=""cripple"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""331"" Profanity=""d1ck"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""330"" Profanity=""dick"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2573"" Profanity=""dick head"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3697"" Profanity=""ethnics"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2762"" Profanity=""fag"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""343"" Profanity=""fagg0t"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""342"" Profanity=""faggot"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2763"" Profanity=""fags"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4103"" Profanity=""Falconio"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""333"" Profanity=""fanny"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3859"" Profanity=""flange"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2698"" Profanity=""Flyers"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2332"" Profanity=""freakin"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2351"" Profanity=""freaking"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2333"" Profanity=""frick"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""349"" Profanity=""gimp"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3994"" Profanity=""Gina Ford"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3848"" Profanity=""Glaxo"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3847"" Profanity=""GlaxoSmithKline"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2612"" Profanity=""gypsies"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2611"" Profanity=""gypsy"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""346"" Profanity=""h0m0"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""345"" Profanity=""h0mo"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3902"" Profanity=""Hardingham"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3920"" Profanity=""Heather"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3918"" Profanity=""Heather McCartney"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3917"" Profanity=""Heather Mills"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3919"" Profanity=""Heather Mills McCartney"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""344"" Profanity=""homo"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""353"" Profanity=""hun"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""352"" Profanity=""huns"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4019"" Profanity=""Ibrahim Savant"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4104"" Profanity=""Joanne Lees"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4003"" Profanity=""kings of clay"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4002"" Profanity=""kingsofclay"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""327"" Profanity=""kn0b"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""326"" Profanity=""knob"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""354"" Profanity=""kraut"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3853"" Profanity=""Langham"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3985"" Profanity=""Lawrence"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3986"" Profanity=""Lawrence's"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3987"" Profanity=""Lawrences"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4218"" Profanity=""Macca"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4085"" Profanity=""maxine carr"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4209"" Profanity=""McCartney"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4016"" Profanity=""Mehran Hussain"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4167"" Profanity=""Montana"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4217"" Profanity=""Mucca"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2009"" Profanity=""mucher"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""1922"" Profanity=""Munchers"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3710"" Profanity=""nazi"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3711"" Profanity=""nazis"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3854"" Profanity=""Ore"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4102"" Profanity=""Peter Falconio"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""339"" Profanity=""piss"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2011"" Profanity=""poff"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""316"" Profanity=""poof"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""317"" Profanity=""poofter"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4166"" Profanity=""Poska"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""329"" Profanity=""pr1ck"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""328"" Profanity=""prick"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3889"" Profanity=""Proper Ganda "" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3894"" Profanity=""Proper Music People"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3890"" Profanity=""Properganda "" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""1599"" Profanity=""pu$$y"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""332"" Profanity=""pussy"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""341"" Profanity=""queer"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""348"" Profanity=""retard"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4026"" Profanity=""Sarwar"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4028"" Profanity=""Savant"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2224"" Profanity=""Scat"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""1514"" Profanity=""Sh!t"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""963"" Profanity=""sh!te"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""964"" Profanity=""sh!tes"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""337"" Profanity=""sh1t"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""338"" Profanity=""sh1te"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""356"" Profanity=""shag"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""336"" Profanity=""shat"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""319"" Profanity=""slag"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""315"" Profanity=""spastic"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4118"" Profanity=""spliff"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3983"" Profanity=""Stephen Lawrence’s"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3984"" Profanity=""Stephen Lawrences"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3892"" Profanity=""Steve Kersley"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4012"" Profanity=""Tanvir Hussain"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2693"" Profanity=""Tickets available"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""3891"" Profanity=""Tony Engle"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""340"" Profanity=""turd"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4013"" Profanity=""Umar Islam"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4020"" Profanity=""Waheed Zamen"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""321"" Profanity=""whore"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""156"" Profanity=""wop"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""4029"" Profanity=""Zamen"" MODCLASSID=""4"" Refer=""1"" />
    <P ProfanityID=""2204"" Profanity=""(ock"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1536"" Profanity=""A$$hole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1538"" Profanity=""A$$hole$"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1537"" Profanity=""A$$holes"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1581"" Profanity=""A+*hole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1575"" Profanity=""ar$ehole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1539"" Profanity=""Ar$hole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1540"" Profanity=""Ar$holes"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1710"" Profanity=""ar5h0l3"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1708"" Profanity=""ar5h0le"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1709"" Profanity=""ar5h0les"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2645"" Profanity=""ars3"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1179"" Profanity=""arse"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2644"" Profanity=""arse hole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""995"" Profanity=""arseh0le"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""996"" Profanity=""arseh0les"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""997"" Profanity=""arsehol"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""998"" Profanity=""arsehole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""999"" Profanity=""arseholes"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1000"" Profanity=""arsh0le"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1001"" Profanity=""arshole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1002"" Profanity=""arsholes"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1003"" Profanity=""ashole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2647"" Profanity=""ass h0le"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2646"" Profanity=""ass hole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1004"" Profanity=""assh0le"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1005"" Profanity=""assh0les"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1006"" Profanity=""asshole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1007"" Profanity=""assholes"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1008"" Profanity=""b0ll0cks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1545"" Profanity=""B0llocks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1183"" Profanity=""b1tch"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1184"" Profanity=""bastard"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2192"" Profanity=""batty&amp;nbsp;boi"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2191"" Profanity=""batty&amp;nbsp;boy"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4171"" Profanity=""Beef curtains"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1185"" Profanity=""bitch"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1546"" Profanity=""Boll0cks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1009"" Profanity=""bollocks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1010"" Profanity=""bollox"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1011"" Profanity=""bolocks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1012"" Profanity=""bolox"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1186"" Profanity=""bugger"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1013"" Profanity=""Bukkake"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1547"" Profanity=""Bullsh!t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1238"" Profanity=""Bullshit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2643"" Profanity=""bum hole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2642"" Profanity=""bumh0l3"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2640"" Profanity=""bumh0le"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2641"" Profanity=""bumhol3"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2639"" Profanity=""bumhole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1485"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1014"" Profanity=""C**t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1015"" Profanity=""C**t's"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1016"" Profanity=""C**ts"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1017"" Profanity=""c.u.n.t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1018"" Profanity=""c00n"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1846"" Profanity=""C0cksucka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1847"" Profanity=""C0cksucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1728"" Profanity=""cnut"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1727"" Profanity=""cnuts"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2203"" Profanity=""Co(k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2186"" Profanity=""coc&amp;nbsp;k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1845"" Profanity=""Cocksucka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1844"" Profanity=""Cocksucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1897"" Profanity=""Cok"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1019"" Profanity=""coon"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1190"" Profanity=""crap"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1997"" Profanity=""cu&amp;nbsp;nt"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1998"" Profanity=""cu&amp;nbsp;nts"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1020"" Profanity=""Cunt"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1021"" Profanity=""Cunt's"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1022"" Profanity=""cunting"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1023"" Profanity=""Cunts"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2469"" Profanity=""D**khead"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1024"" Profanity=""darkie"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1025"" Profanity=""darky"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2557"" Profanity=""dick&amp;nbsp;head"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1026"" Profanity=""dickhead"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1027"" Profanity=""dumbfuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1028"" Profanity=""dumbfucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2470"" Profanity=""Dxxkhead"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1645"" Profanity=""effing"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2893"" Profanity=""f u c k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2899"" Profanity=""f u c ked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1592"" Profanity=""f###"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1501"" Profanity=""f##k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1029"" Profanity=""F$cks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2543"" Profanity=""f&amp;nbsp;cked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1535"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2189"" Profanity=""f&amp;nbsp;uck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2553"" Profanity=""f&amp;nbsp;ucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2548"" Profanity=""f&amp;nbsp;ucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1591"" Profanity=""f***"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1543"" Profanity=""F*****"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1544"" Profanity=""F******"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1493"" Profanity=""f*****g"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1030"" Profanity=""f****d"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1031"" Profanity=""f***ed"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1032"" Profanity=""f***ing"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1033"" Profanity=""f**k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1034"" Profanity=""f**ked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1035"" Profanity=""f**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1036"" Profanity=""f**kin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1037"" Profanity=""f**king"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1038"" Profanity=""f**ks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1039"" Profanity=""f*ck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1040"" Profanity=""f*ked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1041"" Profanity=""f*ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1042"" Profanity=""f*ks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1043"" Profanity=""f*uck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1541"" Profanity=""F*uk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1044"" Profanity=""f.u.c.k."" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1896"" Profanity=""f@ck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2890"" Profanity=""f00k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2361"" Profanity=""Fack"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2369"" Profanity=""Fackin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2380"" Profanity=""facking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1194"" Profanity=""fagg0t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1195"" Profanity=""faggot"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1045"" Profanity=""fc*king"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2190"" Profanity=""fck&amp;nbsp;ing"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1839"" Profanity=""fckw1t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1838"" Profanity=""fckwit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1046"" Profanity=""fcuk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1047"" Profanity=""fcuked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1048"" Profanity=""fcuker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1049"" Profanity=""fcukin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1050"" Profanity=""fcuking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1051"" Profanity=""fcuks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2362"" Profanity=""feck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2371"" Profanity=""feckin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2381"" Profanity=""fecking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1052"" Profanity=""felch"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1053"" Profanity=""felched"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2194"" Profanity=""Felching"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1054"" Profanity=""feltch"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1055"" Profanity=""feltcher"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1056"" Profanity=""feltching"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2367"" Profanity=""fook"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2376"" Profanity=""fookin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2387"" Profanity=""fooking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2364"" Profanity=""frick"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2373"" Profanity=""frickin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2383"" Profanity=""fricking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2365"" Profanity=""frig"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2379"" Profanity=""friggin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2385"" Profanity=""frigging"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2374"" Profanity=""frigin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2384"" Profanity=""friging"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2187"" Profanity=""fu&amp;nbsp;ck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2544"" Profanity=""fu&amp;nbsp;cked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2554"" Profanity=""fu&amp;nbsp;cker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2549"" Profanity=""fu&amp;nbsp;cking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2439"" Profanity=""fu(k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1057"" Profanity=""fu*k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1849"" Profanity=""fu@k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1850"" Profanity=""fu@ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1058"" Profanity=""fuc"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2545"" Profanity=""fuc&amp;nbsp;ked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2555"" Profanity=""fuc&amp;nbsp;ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2550"" Profanity=""fuc&amp;nbsp;king"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1059"" Profanity=""fuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2895"" Profanity=""Fùck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1060"" Profanity=""fúck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2889"" Profanity=""Fúçk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2894"" Profanity=""Fûck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2896"" Profanity=""Fück"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2546"" Profanity=""fuck&amp;nbsp;ed"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2551"" Profanity=""fuck&amp;nbsp;ing"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1835"" Profanity=""fuck-wit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2547"" Profanity=""fucke&amp;nbsp;d"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1061"" Profanity=""fucked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1062"" Profanity=""fucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1569"" Profanity=""fuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2552"" Profanity=""fucki&amp;nbsp;ng"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1063"" Profanity=""fuckin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1064"" Profanity=""fucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1065"" Profanity=""fúcking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1066"" Profanity=""fuckk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1067"" Profanity=""fucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2202"" Profanity=""Fuckup"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1837"" Profanity=""fuckw1t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1833"" Profanity=""fuckwit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1841"" Profanity=""fucw1t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1840"" Profanity=""fucwit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2957"" Profanity=""fudge packer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2955"" Profanity=""fudgepacker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1068"" Profanity=""fuk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1069"" Profanity=""fukced"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1070"" Profanity=""fuked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1071"" Profanity=""fuker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1072"" Profanity=""fukin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1073"" Profanity=""fuking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2366"" Profanity=""fukk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1074"" Profanity=""fukked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1075"" Profanity=""fukker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1076"" Profanity=""fukkin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2386"" Profanity=""fukking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1077"" Profanity=""fuks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2001"" Profanity=""Fvck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1848"" Profanity=""Fvck-up"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1851"" Profanity=""Fvckup"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1836"" Profanity=""fvckw1t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1834"" Profanity=""fvckwit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1197"" Profanity=""gimp"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1992"" Profanity=""Gypo"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1993"" Profanity=""Gypos"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1991"" Profanity=""Gyppo"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1994"" Profanity=""Gyppos"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1198"" Profanity=""h0m0"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1199"" Profanity=""h0mo"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1200"" Profanity=""homo"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1078"" Profanity=""K**t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1983"" Profanity=""k@ffir"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1984"" Profanity=""k@ffirs"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1982"" Profanity=""k@fir"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1985"" Profanity=""k@firs"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1986"" Profanity=""Kaf1r"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1987"" Profanity=""Kaff1r"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1979"" Profanity=""Kaffir"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1981"" Profanity=""Kaffirs"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1978"" Profanity=""Kafir"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1980"" Profanity=""Kafirs"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1898"" Profanity=""Khunt"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1079"" Profanity=""kike"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2199"" Profanity=""knob&amp;nbsp;head"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2200"" Profanity=""Knobber"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1080"" Profanity=""Kunt"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1081"" Profanity=""kyke"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2704"" Profanity=""L m f a o"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2706"" Profanity=""L.m.f.a.o"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2705"" Profanity=""L.m.f.a.o."" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2703"" Profanity=""Lmfa0"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2702"" Profanity=""Lmfao"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1082"" Profanity=""mof**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1083"" Profanity=""mof**kers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1084"" Profanity=""mofuccer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1085"" Profanity=""mofucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1086"" Profanity=""mofuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1087"" Profanity=""mofucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1088"" Profanity=""mofukcer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1089"" Profanity=""mohterf**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1090"" Profanity=""mohterf**kers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1091"" Profanity=""mohterf*kcer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1092"" Profanity=""mohterfuccer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1093"" Profanity=""mohterfuccers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1094"" Profanity=""mohterfuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1095"" Profanity=""mohterfucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1096"" Profanity=""mohterfuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1097"" Profanity=""mohterfucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1098"" Profanity=""mohterfucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1099"" Profanity=""mohterfuk"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1100"" Profanity=""mohterfukcer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1101"" Profanity=""mohterfukcers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1102"" Profanity=""mohterfuking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1103"" Profanity=""mohterfuks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1104"" Profanity=""moterf**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1105"" Profanity=""moterfuccer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1106"" Profanity=""moterfuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1107"" Profanity=""moterfucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1108"" Profanity=""moterfuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1109"" Profanity=""moterfucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1110"" Profanity=""moterfucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1843"" Profanity=""motha-fucka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1111"" Profanity=""mothaf**k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1112"" Profanity=""mothaf**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1113"" Profanity=""mothaf**kers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1114"" Profanity=""mothaf**king"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1115"" Profanity=""mothaf**ks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1116"" Profanity=""mothafuccer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1117"" Profanity=""mothafuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1842"" Profanity=""Mothafucka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1118"" Profanity=""mothafucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1119"" Profanity=""mothafuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1120"" Profanity=""mothafucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1121"" Profanity=""mothafucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1122"" Profanity=""motherf**ked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1123"" Profanity=""Motherf**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1124"" Profanity=""Motherf**kers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1125"" Profanity=""Motherfuccer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1126"" Profanity=""Motherfuccers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1127"" Profanity=""Motherfuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1128"" Profanity=""motherfucked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1129"" Profanity=""Motherfucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1130"" Profanity=""Motherfuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1131"" Profanity=""Motherfucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1132"" Profanity=""Motherfucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1133"" Profanity=""motherfukkker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1134"" Profanity=""mthaf**ka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1135"" Profanity=""mthafucca"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1136"" Profanity=""mthafuccas"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1137"" Profanity=""mthafucka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1138"" Profanity=""mthafuckas"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1139"" Profanity=""mthafukca"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1140"" Profanity=""mthafukcas"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1141"" Profanity=""muth@fucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1142"" Profanity=""muthaf**k"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1143"" Profanity=""muthaf**ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1144"" Profanity=""muthaf**kers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1145"" Profanity=""muthaf**king"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1146"" Profanity=""muthaf**ks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1147"" Profanity=""muthafuccer"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1148"" Profanity=""muthafuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1149"" Profanity=""muthafuck@"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4057"" Profanity=""Muthafucka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1150"" Profanity=""muthafucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1151"" Profanity=""muthafuckers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1152"" Profanity=""muthafucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1153"" Profanity=""muthafucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1895"" Profanity=""Muthafuka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1894"" Profanity=""Muthafukas"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2441"" Profanity=""n0b"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1995"" Profanity=""N1gger"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1996"" Profanity=""N1ggers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1154"" Profanity=""nigga"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1155"" Profanity=""niggaz"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1156"" Profanity=""Nigger"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1157"" Profanity=""niggers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2440"" Profanity=""nob"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2198"" Profanity=""nob&amp;nbsp;head"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2197"" Profanity=""Nobhead"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1675"" Profanity=""p**i"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1672"" Profanity=""p*ki"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1673"" Profanity=""p@ki"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1674"" Profanity=""pak1"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1158"" Profanity=""paki"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2389"" Profanity=""phelching"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1891"" Profanity=""Phuck"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1893"" Profanity=""Phucker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2377"" Profanity=""phuckin"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1892"" Profanity=""Phucking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1988"" Profanity=""Phucks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1206"" Profanity=""piss"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4172"" Profanity=""Poo stabber"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4174"" Profanity=""Poo stabbers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1901"" Profanity=""Prik"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1159"" Profanity=""raghead"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1160"" Profanity=""ragheads"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1213"" Profanity=""retard"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2195"" Profanity=""S1ut"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2201"" Profanity=""Scat"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1218"" Profanity=""shag"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1219"" Profanity=""shat"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1220"" Profanity=""shit"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4173"" Profanity=""Shit stabber"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4175"" Profanity=""Shit stabbers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1221"" Profanity=""shite"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1222"" Profanity=""slag"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1162"" Profanity=""spic"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2064"" Profanity=""Sylvestor"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1999"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2000"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2468"" Profanity=""t0$$er"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1779"" Profanity=""t0ssers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1780"" Profanity=""to55ers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1163"" Profanity=""tosser"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1781"" Profanity=""tossers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4137"" Profanity=""towel head"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4138"" Profanity=""towelhead"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1224"" Profanity=""turd"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2193"" Profanity=""tw&amp;nbsp;at"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1164"" Profanity=""tw@t"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1990"" Profanity=""tw@ts"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1165"" Profanity=""twat"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1726"" Profanity=""twats"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1899"" Profanity=""Twunt"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1930"" Profanity=""twunts"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2672"" Profanity=""w anker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1637"" Profanity=""w******"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1226"" Profanity=""w****r"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1166"" Profanity=""w@nker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1167"" Profanity=""w@nkers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1168"" Profanity=""w0g"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1169"" Profanity=""w0gs"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2673"" Profanity=""wa nker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4176"" Profanity=""Wan k er"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4177"" Profanity=""Wan k ers"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2674"" Profanity=""wan ker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1170"" Profanity=""wank"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1171"" Profanity=""wank's"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4056"" Profanity=""Wanka"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2676"" Profanity=""wanke r"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1172"" Profanity=""wanked"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1173"" Profanity=""wanker"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1174"" Profanity=""wanking"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1175"" Profanity=""wanks"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1227"" Profanity=""whore"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1176"" Profanity=""wog"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1177"" Profanity=""wop"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2196"" Profanity=""Xxxhole"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1534"" Profanity=""Y*d"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1178"" Profanity=""yid"" MODCLASSID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1180"" Profanity=""b******"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1181"" Profanity=""b*****d"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1182"" Profanity=""b****r"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4180"" Profanity=""Belton"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4126"" Profanity=""Beshenivsky"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4169"" Profanity=""Bomb"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4170"" Profanity=""Bombing"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1187"" Profanity=""c0ck"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1188"" Profanity=""clit"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1189"" Profanity=""cock"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1191"" Profanity=""cripple"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1192"" Profanity=""d1ck"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1193"" Profanity=""dick"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1196"" Profanity=""fanny"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""3926"" Profanity=""Heather"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1201"" Profanity=""hun"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1202"" Profanity=""huns"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1203"" Profanity=""kn0b"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1204"" Profanity=""knob"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1205"" Profanity=""kraut"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4086"" Profanity=""maxine carr"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4179"" Profanity=""Montana"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1900"" Profanity=""Munchers"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1207"" Profanity=""poof"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1208"" Profanity=""poofter"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4178"" Profanity=""Poska"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1209"" Profanity=""pr1ck"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1210"" Profanity=""prick"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1597"" Profanity=""pu$$y"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1211"" Profanity=""pussy"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1212"" Profanity=""queer"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1542"" Profanity=""Sh!t"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1214"" Profanity=""sh!te"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1215"" Profanity=""sh!tes"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1216"" Profanity=""sh1t"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1217"" Profanity=""sh1te"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1223"" Profanity=""spastic"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""4119"" Profanity=""spliff"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""1225"" Profanity=""w*****"" MODCLASSID=""5"" Refer=""1"" />
    <P ProfanityID=""2181"" Profanity=""(ock"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1550"" Profanity=""A$$hole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1552"" Profanity=""A$$hole$"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1551"" Profanity=""A$$holes"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1585"" Profanity=""A+*hole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1577"" Profanity=""ar$ehole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1553"" Profanity=""Ar$hole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1554"" Profanity=""Ar$holes"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1713"" Profanity=""ar5h0l3"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1711"" Profanity=""ar5h0le"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1712"" Profanity=""ar5h0les"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2654"" Profanity=""ars3"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2653"" Profanity=""arse hole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1247"" Profanity=""arseh0le"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1248"" Profanity=""arseh0les"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1249"" Profanity=""arsehol"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1250"" Profanity=""arsehole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1251"" Profanity=""arseholes"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3488"" Profanity=""arsewipe"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1252"" Profanity=""arsh0le"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1253"" Profanity=""arshole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1254"" Profanity=""arsholes"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1255"" Profanity=""ashole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2656"" Profanity=""ass h0le"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2655"" Profanity=""ass hole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1256"" Profanity=""assh0le"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1257"" Profanity=""assh0les"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1258"" Profanity=""asshole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1259"" Profanity=""assholes"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1260"" Profanity=""b0ll0cks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1559"" Profanity=""B0llocks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2169"" Profanity=""batty&amp;nbsp;boi"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2168"" Profanity=""batty&amp;nbsp;boy"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4183"" Profanity=""Beef curtains"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1560"" Profanity=""Boll0cks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1261"" Profanity=""bollocks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1262"" Profanity=""bollox"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1263"" Profanity=""bolocks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1264"" Profanity=""bolox"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1265"" Profanity=""Bukkake"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1561"" Profanity=""Bullsh!t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2652"" Profanity=""bum hole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2651"" Profanity=""bumh0l3"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2649"" Profanity=""bumh0le"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2650"" Profanity=""bumhol3"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2648"" Profanity=""bumhole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1487"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1266"" Profanity=""C**t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1267"" Profanity=""C**t's"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1268"" Profanity=""C**ts"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1269"" Profanity=""c.u.n.t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1270"" Profanity=""c00n"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1865"" Profanity=""C0cksucka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1866"" Profanity=""C0cksucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2068"" Profanity=""Clohosy"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1724"" Profanity=""cnut"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1723"" Profanity=""cnuts"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2180"" Profanity=""Co(k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2163"" Profanity=""coc&amp;nbsp;k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1864"" Profanity=""Cocksucka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1863"" Profanity=""Cocksucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1908"" Profanity=""Cok"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1271"" Profanity=""coon"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1951"" Profanity=""cu&amp;nbsp;nt"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1952"" Profanity=""cu&amp;nbsp;nts"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1272"" Profanity=""Cunt"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1273"" Profanity=""Cunt's"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1274"" Profanity=""cunting"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1275"" Profanity=""Cunts"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2477"" Profanity=""D**khead"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1276"" Profanity=""darkie"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1277"" Profanity=""darky"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2523"" Profanity=""dick&amp;nbsp;head"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1278"" Profanity=""dickhead"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1279"" Profanity=""dumbfuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1280"" Profanity=""dumbfucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2478"" Profanity=""Dxxkhead"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1647"" Profanity=""effing"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4082"" Profanity=""excoboard.com/exco/index.php?boardid=19215"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2792"" Profanity=""F o a d"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2885"" Profanity=""f u c k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2897"" Profanity=""f u c ked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1594"" Profanity=""f###"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1503"" Profanity=""f##k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1281"" Profanity=""F$cks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2509"" Profanity=""f&amp;nbsp;cked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1549"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2166"" Profanity=""f&amp;nbsp;uck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2519"" Profanity=""f&amp;nbsp;ucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2514"" Profanity=""f&amp;nbsp;ucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1593"" Profanity=""f***"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1557"" Profanity=""F*****"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1558"" Profanity=""F******"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1495"" Profanity=""f*****g"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1282"" Profanity=""f****d"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1283"" Profanity=""f***ed"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1284"" Profanity=""f***ing"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1285"" Profanity=""f**k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1286"" Profanity=""f**ked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1287"" Profanity=""f**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1288"" Profanity=""f**kin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1289"" Profanity=""f**king"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1290"" Profanity=""f**ks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1291"" Profanity=""f*ck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1292"" Profanity=""f*ked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1293"" Profanity=""f*ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1294"" Profanity=""f*ks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1295"" Profanity=""f*uck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1555"" Profanity=""F*uk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2791"" Profanity=""F-o-a-d"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2789"" Profanity=""F.O.A.D"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2790"" Profanity=""F.O.A.D."" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1296"" Profanity=""f.u.c.k."" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1907"" Profanity=""f@ck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2882"" Profanity=""f00k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2392"" Profanity=""Fack"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2400"" Profanity=""Fackin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2411"" Profanity=""facking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1297"" Profanity=""fc*king"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4074"" Profanity=""fck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2167"" Profanity=""fck&amp;nbsp;ing"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4075"" Profanity=""fcks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1858"" Profanity=""fckw1t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1857"" Profanity=""fckwit"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1298"" Profanity=""fcuk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1299"" Profanity=""fcuked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1300"" Profanity=""fcuker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1301"" Profanity=""fcukin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1302"" Profanity=""fcuking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1303"" Profanity=""fcuks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2393"" Profanity=""feck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2402"" Profanity=""feckin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2412"" Profanity=""fecking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1304"" Profanity=""felch"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1305"" Profanity=""felched"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2171"" Profanity=""Felching"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1306"" Profanity=""feltch"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1307"" Profanity=""feltcher"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1308"" Profanity=""feltching"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2788"" Profanity=""FOAD"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2398"" Profanity=""fook"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2407"" Profanity=""fookin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2418"" Profanity=""fooking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2395"" Profanity=""frick"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2404"" Profanity=""frickin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2414"" Profanity=""fricking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2396"" Profanity=""frig"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2410"" Profanity=""friggin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2416"" Profanity=""frigging"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2405"" Profanity=""frigin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2415"" Profanity=""friging"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2164"" Profanity=""fu&amp;nbsp;ck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2510"" Profanity=""fu&amp;nbsp;cked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2520"" Profanity=""fu&amp;nbsp;cker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2515"" Profanity=""fu&amp;nbsp;cking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2442"" Profanity=""fu(k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1309"" Profanity=""fu*k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1868"" Profanity=""fu@k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1869"" Profanity=""fu@ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1310"" Profanity=""fuc"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2511"" Profanity=""fuc&amp;nbsp;ked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2521"" Profanity=""fuc&amp;nbsp;ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2516"" Profanity=""fuc&amp;nbsp;king"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1311"" Profanity=""fuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2887"" Profanity=""Fùck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1312"" Profanity=""fúck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2881"" Profanity=""Fúçk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2886"" Profanity=""Fûck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2888"" Profanity=""Fück"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2512"" Profanity=""fuck&amp;nbsp;ed"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2517"" Profanity=""fuck&amp;nbsp;ing"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1854"" Profanity=""fuck-wit"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2513"" Profanity=""fucke&amp;nbsp;d"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1313"" Profanity=""fucked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1314"" Profanity=""fucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1562"" Profanity=""fuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2518"" Profanity=""fucki&amp;nbsp;ng"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1315"" Profanity=""fuckin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1316"" Profanity=""fucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1317"" Profanity=""fúcking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1318"" Profanity=""fuckk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1319"" Profanity=""fucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2179"" Profanity=""Fuckup"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1856"" Profanity=""fuckw1t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1852"" Profanity=""fuckwit"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1860"" Profanity=""fucw1t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1859"" Profanity=""fucwit"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2961"" Profanity=""fudge packer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2959"" Profanity=""fudgepacker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1320"" Profanity=""fuk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1321"" Profanity=""fukced"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1322"" Profanity=""fuked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1323"" Profanity=""fuker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1324"" Profanity=""fukin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1325"" Profanity=""fuking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2397"" Profanity=""fukk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1326"" Profanity=""fukked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1327"" Profanity=""fukker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1328"" Profanity=""fukkin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2417"" Profanity=""fukking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1329"" Profanity=""fuks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2005"" Profanity=""fvck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1867"" Profanity=""Fvck-up"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1870"" Profanity=""Fvckup"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1855"" Profanity=""fvckw1t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1853"" Profanity=""fvckwit"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1946"" Profanity=""Gypo"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1947"" Profanity=""Gypos"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1945"" Profanity=""Gyppo"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1948"" Profanity=""Gyppos"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4064"" Profanity=""http://excoboard.com/exco/index.php?boardid=19215"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1330"" Profanity=""K**t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1937"" Profanity=""k@ffir"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1938"" Profanity=""k@ffirs"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1936"" Profanity=""k@fir"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1939"" Profanity=""k@firs"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1940"" Profanity=""Kaf1r"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1941"" Profanity=""Kaff1r"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1933"" Profanity=""Kaffir"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1935"" Profanity=""Kaffirs"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1932"" Profanity=""Kafir"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1934"" Profanity=""Kafirs"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1909"" Profanity=""Khunt"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1331"" Profanity=""kike"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2176"" Profanity=""knob&amp;nbsp;head"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2177"" Profanity=""Knobber"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1332"" Profanity=""Kunt"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1333"" Profanity=""kyke"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2696"" Profanity=""L m f a o"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2699"" Profanity=""L.m.f.a.o"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2697"" Profanity=""L.m.f.a.o."" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2695"" Profanity=""Lmfa0"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2694"" Profanity=""Lmfao"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1334"" Profanity=""mof**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1335"" Profanity=""mof**kers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1336"" Profanity=""mofuccer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1337"" Profanity=""mofucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1338"" Profanity=""mofuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1339"" Profanity=""mofucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1340"" Profanity=""mofukcer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1341"" Profanity=""mohterf**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1342"" Profanity=""mohterf**kers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1343"" Profanity=""mohterf*kcer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1344"" Profanity=""mohterfuccer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1345"" Profanity=""mohterfuccers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1346"" Profanity=""mohterfuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1347"" Profanity=""mohterfucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1348"" Profanity=""mohterfuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1349"" Profanity=""mohterfucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1350"" Profanity=""mohterfucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1351"" Profanity=""mohterfuk"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1352"" Profanity=""mohterfukcer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1353"" Profanity=""mohterfukcers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1354"" Profanity=""mohterfuking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1355"" Profanity=""mohterfuks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1356"" Profanity=""moterf**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1357"" Profanity=""moterfuccer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1358"" Profanity=""moterfuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1359"" Profanity=""moterfucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1360"" Profanity=""moterfuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1361"" Profanity=""moterfucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1362"" Profanity=""moterfucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1862"" Profanity=""motha-fucka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1363"" Profanity=""mothaf**k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1364"" Profanity=""mothaf**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1365"" Profanity=""mothaf**kers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1366"" Profanity=""mothaf**king"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1367"" Profanity=""mothaf**ks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1368"" Profanity=""mothafuccer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1369"" Profanity=""mothafuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1861"" Profanity=""Mothafucka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1370"" Profanity=""mothafucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1371"" Profanity=""mothafuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1372"" Profanity=""mothafucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1373"" Profanity=""mothafucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1374"" Profanity=""motherf**ked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1375"" Profanity=""Motherf**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1376"" Profanity=""Motherf**kers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1377"" Profanity=""Motherfuccer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1378"" Profanity=""Motherfuccers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1379"" Profanity=""Motherfuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1380"" Profanity=""motherfucked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1381"" Profanity=""Motherfucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1382"" Profanity=""Motherfuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1383"" Profanity=""Motherfucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1384"" Profanity=""Motherfucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1385"" Profanity=""motherfukkker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1386"" Profanity=""mthaf**ka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1387"" Profanity=""mthafucca"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1388"" Profanity=""mthafuccas"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1389"" Profanity=""mthafucka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1390"" Profanity=""mthafuckas"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1391"" Profanity=""mthafukca"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1392"" Profanity=""mthafukcas"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1393"" Profanity=""muth@fucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1394"" Profanity=""muthaf**k"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1395"" Profanity=""muthaf**ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1396"" Profanity=""muthaf**kers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1397"" Profanity=""muthaf**king"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1398"" Profanity=""muthaf**ks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1399"" Profanity=""muthafuccer"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1400"" Profanity=""muthafuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1401"" Profanity=""muthafuck@"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4060"" Profanity=""Muthafucka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1402"" Profanity=""muthafucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1403"" Profanity=""muthafuckers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1404"" Profanity=""muthafucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1405"" Profanity=""muthafucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1906"" Profanity=""Muthafuka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1905"" Profanity=""Muthafukas"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2444"" Profanity=""n0b"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1949"" Profanity=""N1gger"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1950"" Profanity=""N1ggers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1406"" Profanity=""nigga"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1407"" Profanity=""niggaz"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1408"" Profanity=""Nigger"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1409"" Profanity=""niggers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2443"" Profanity=""nob"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2175"" Profanity=""nob&amp;nbsp;head"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2174"" Profanity=""Nobhead"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1679"" Profanity=""p**i"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1676"" Profanity=""p*ki"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1677"" Profanity=""p@ki"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1678"" Profanity=""pak1"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1410"" Profanity=""paki"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2420"" Profanity=""phelching"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1902"" Profanity=""Phuck"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1904"" Profanity=""Phucker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2408"" Profanity=""phuckin"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1903"" Profanity=""Phucking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1942"" Profanity=""Phucks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4184"" Profanity=""Poo stabber"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4186"" Profanity=""Poo stabbers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1912"" Profanity=""Prik"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1411"" Profanity=""raghead"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1412"" Profanity=""ragheads"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2172"" Profanity=""S1ut"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4185"" Profanity=""Shit stabber"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4187"" Profanity=""Shit stabbers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1413"" Profanity=""slut"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1414"" Profanity=""spic"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1953"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1954"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2476"" Profanity=""t0$$er"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1776"" Profanity=""t0ssers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1777"" Profanity=""to55ers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1415"" Profanity=""tosser"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1778"" Profanity=""tossers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4139"" Profanity=""towel head"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4140"" Profanity=""towelhead"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2170"" Profanity=""tw&amp;nbsp;at"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1416"" Profanity=""tw@t"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1944"" Profanity=""tw@ts"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1417"" Profanity=""twat"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1722"" Profanity=""twats"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1910"" Profanity=""Twunt"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1928"" Profanity=""twunts"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2667"" Profanity=""w anker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1635"" Profanity=""w******"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1418"" Profanity=""w@nker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1419"" Profanity=""w@nkers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1420"" Profanity=""w0g"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1421"" Profanity=""w0gs"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2668"" Profanity=""wa nker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4188"" Profanity=""Wan k er"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4189"" Profanity=""Wan k ers"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2669"" Profanity=""wan ker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1422"" Profanity=""wank"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1423"" Profanity=""wank's"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4059"" Profanity=""Wanka"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2671"" Profanity=""wanke r"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1424"" Profanity=""wanked"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1425"" Profanity=""wanker"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1426"" Profanity=""wanking"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1427"" Profanity=""wanks"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1428"" Profanity=""wog"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1429"" Profanity=""wop"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2173"" Profanity=""Xxxhole"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1548"" Profanity=""Y*d"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1430"" Profanity=""yid"" MODCLASSID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1431"" Profanity=""arse"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1432"" Profanity=""b******"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1433"" Profanity=""b*****d"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1434"" Profanity=""b****r"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1435"" Profanity=""b1tch"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1436"" Profanity=""bastard"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4192"" Profanity=""Belton"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4127"" Profanity=""Beshenivsky"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1437"" Profanity=""bitch"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4181"" Profanity=""Bomb"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4182"" Profanity=""Bombing"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4100"" Profanity=""Bradley John Murdoch"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4101"" Profanity=""Bradley Murdoch"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1438"" Profanity=""bugger"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1439"" Profanity=""c0ck"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1440"" Profanity=""clit"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1441"" Profanity=""cock"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1443"" Profanity=""d1ck"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1444"" Profanity=""dick"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2764"" Profanity=""fag"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1445"" Profanity=""fagg0t"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1446"" Profanity=""faggot"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2765"" Profanity=""fags"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4098"" Profanity=""Falconio"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1447"" Profanity=""fanny"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2701"" Profanity=""Flyers"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2394"" Profanity=""freakin"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2413"" Profanity=""freaking"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1448"" Profanity=""gimp"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2786"" Profanity=""Grunwick"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1449"" Profanity=""h0m0"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1450"" Profanity=""h0mo"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3903"" Profanity=""Hardingham"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3932"" Profanity=""Heather"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3930"" Profanity=""Heather McCartney"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3929"" Profanity=""Heather Mills"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3931"" Profanity=""Heather Mills McCartney"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1451"" Profanity=""homo"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1452"" Profanity=""hun"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1453"" Profanity=""huns"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4099"" Profanity=""Joanne Lees"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1454"" Profanity=""kn0b"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1455"" Profanity=""knob"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1456"" Profanity=""kraut"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3990"" Profanity=""Lawrence"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3991"" Profanity=""Lawrence's"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3992"" Profanity=""Lawrences"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4216"" Profanity=""Macca"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4087"" Profanity=""maxine carr"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4211"" Profanity=""McCartney"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4191"" Profanity=""Montana"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4215"" Profanity=""Mucca"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1911"" Profanity=""Munchers"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4097"" Profanity=""Peter Falconio"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1457"" Profanity=""piss"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1458"" Profanity=""poof"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1459"" Profanity=""poofter"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4190"" Profanity=""Poska"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1460"" Profanity=""pr1ck"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1461"" Profanity=""prick"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1595"" Profanity=""pu$$y"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1462"" Profanity=""pussy"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1463"" Profanity=""queer"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1464"" Profanity=""retard"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2178"" Profanity=""Scat"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1556"" Profanity=""Sh!t"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1465"" Profanity=""sh!te"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1466"" Profanity=""sh!tes"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1467"" Profanity=""sh1t"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1468"" Profanity=""sh1te"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1469"" Profanity=""shag"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1470"" Profanity=""shat"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1471"" Profanity=""shit"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1472"" Profanity=""shite"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1473"" Profanity=""slag"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1474"" Profanity=""spastic"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4120"" Profanity=""spliff"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3988"" Profanity=""Stephen Lawrence’s"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""3989"" Profanity=""Stephen Lawrences"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""2700"" Profanity=""Tickets available"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1475"" Profanity=""turd"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1476"" Profanity=""w*****"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1477"" Profanity=""w****r"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""1478"" Profanity=""whore"" MODCLASSID=""6"" Refer=""1"" />
    <P ProfanityID=""4195"" Profanity=""Beef curtains"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4196"" Profanity=""Poo stabber"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4198"" Profanity=""Poo stabbers"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4197"" Profanity=""Shit stabber"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4199"" Profanity=""Shit stabbers"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4200"" Profanity=""Wan k er"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4201"" Profanity=""Wan k ers"" MODCLASSID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2967"" Profanity=""(ock"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2968"" Profanity=""A$$hole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2969"" Profanity=""A$$hole$"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2970"" Profanity=""A$$holes"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2971"" Profanity=""A+*hole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2972"" Profanity=""ar$ehole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2973"" Profanity=""Ar$hole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2974"" Profanity=""Ar$holes"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2975"" Profanity=""ar5h0le"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2976"" Profanity=""ar5h0les"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2977"" Profanity=""ars3"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2978"" Profanity=""arse"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2979"" Profanity=""arse hole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2980"" Profanity=""arseh0le"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2981"" Profanity=""arseh0les"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2982"" Profanity=""arsehol"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2983"" Profanity=""arsehole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2984"" Profanity=""arseholes"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2985"" Profanity=""arsh0le"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2986"" Profanity=""arshole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2987"" Profanity=""arsholes"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2988"" Profanity=""ashole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2989"" Profanity=""ass h0le"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2990"" Profanity=""ass hole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2991"" Profanity=""assh0le"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2992"" Profanity=""assh0les"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2993"" Profanity=""asshole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2994"" Profanity=""assholes"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2995"" Profanity=""b****r"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2996"" Profanity=""b00tha"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2997"" Profanity=""b00thas"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2998"" Profanity=""b0ll0cks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""2999"" Profanity=""B0llocks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3000"" Profanity=""b1tch"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3001"" Profanity=""bastard"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3002"" Profanity=""batty&amp;nbsp;boi"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3003"" Profanity=""batty&amp;nbsp;boy"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4204"" Profanity=""Belton"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4128"" Profanity=""Beshenivsky"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3004"" Profanity=""bitch"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3005"" Profanity=""bo****ks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3006"" Profanity=""Boll0cks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3007"" Profanity=""bollocks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3008"" Profanity=""bollox"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3009"" Profanity=""bolocks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3010"" Profanity=""bolox"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4193"" Profanity=""Bomb"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4194"" Profanity=""Bombing"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3011"" Profanity=""bootha"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3012"" Profanity=""boothas"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4115"" Profanity=""Bradley John Murdoch"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4116"" Profanity=""Bradley Murdoch"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3013"" Profanity=""bugger"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3014"" Profanity=""Bukkake"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3015"" Profanity=""Bullsh!t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3016"" Profanity=""bum bandit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3017"" Profanity=""bum hole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3018"" Profanity=""bum-bandit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3019"" Profanity=""bumbandit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3020"" Profanity=""bumh0l3"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3021"" Profanity=""bumh0le"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3022"" Profanity=""bumhol3"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3023"" Profanity=""bumhole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3024"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3025"" Profanity=""C**t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3026"" Profanity=""C**t's"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3027"" Profanity=""C**ts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3028"" Profanity=""c.u.n.t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3029"" Profanity=""c00n"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3030"" Profanity=""c0ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3031"" Profanity=""C0cksucka"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3032"" Profanity=""C0cksucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3033"" Profanity=""clit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3034"" Profanity=""cnut"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3035"" Profanity=""cnuts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3036"" Profanity=""Co(k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3037"" Profanity=""coc&amp;nbsp;k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3038"" Profanity=""cock"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3039"" Profanity=""Cocksucka"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3040"" Profanity=""Cocksucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3041"" Profanity=""Cok"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3042"" Profanity=""coon"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3043"" Profanity=""cripple"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3044"" Profanity=""cu&amp;nbsp;nt"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3045"" Profanity=""cu&amp;nbsp;nts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3046"" Profanity=""Cunt"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3047"" Profanity=""Cunt's"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3048"" Profanity=""cunting"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3049"" Profanity=""Cunts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3050"" Profanity=""cvnt"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3051"" Profanity=""cvnts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3052"" Profanity=""D**khead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3053"" Profanity=""d1ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3054"" Profanity=""darkie"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3055"" Profanity=""darky"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3056"" Profanity=""dick"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3057"" Profanity=""dick&amp;nbsp;head"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3058"" Profanity=""dickhead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3059"" Profanity=""door price"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3060"" Profanity=""dumbfuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3061"" Profanity=""dumbfucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3062"" Profanity=""Dxxkhead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3063"" Profanity=""effing"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3064"" Profanity=""F o a d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3065"" Profanity=""f u c k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3066"" Profanity=""f u c ked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3067"" Profanity=""f###"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3068"" Profanity=""f##k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3069"" Profanity=""F$cks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3070"" Profanity=""f&amp;nbsp;cked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3071"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3072"" Profanity=""f&amp;nbsp;uck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3073"" Profanity=""f&amp;nbsp;ucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3074"" Profanity=""f&amp;nbsp;ucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3075"" Profanity=""f***"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3076"" Profanity=""F*****"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3077"" Profanity=""F******"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3078"" Profanity=""f*****g"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3079"" Profanity=""f****d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3080"" Profanity=""f***ed"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3081"" Profanity=""f***in"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3082"" Profanity=""f***ing"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3083"" Profanity=""f**k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3084"" Profanity=""f**ked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3085"" Profanity=""f**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3086"" Profanity=""f**kin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3087"" Profanity=""f**king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3088"" Profanity=""f**ks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3089"" Profanity=""f*ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3090"" Profanity=""f*ked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3091"" Profanity=""f*ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3092"" Profanity=""f*ks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3093"" Profanity=""f*uck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3094"" Profanity=""F*uk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3095"" Profanity=""F-o-a-d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3096"" Profanity=""F.O.A.D"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3097"" Profanity=""F.O.A.D."" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3098"" Profanity=""f.u.c.k."" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3099"" Profanity=""f@ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3100"" Profanity=""f@g"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3101"" Profanity=""f@gs"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3102"" Profanity=""f^^k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3103"" Profanity=""f^^ked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3104"" Profanity=""f^^ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3105"" Profanity=""f^^king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3106"" Profanity=""f^ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3107"" Profanity=""f^cker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3108"" Profanity=""f^cking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3109"" Profanity=""f00k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3110"" Profanity=""Fack"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3111"" Profanity=""Fackin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3112"" Profanity=""facking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3113"" Profanity=""fag"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3114"" Profanity=""fagg0t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3115"" Profanity=""faggot"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3116"" Profanity=""fags"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4113"" Profanity=""Falconio"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3117"" Profanity=""fanny"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3118"" Profanity=""fc*king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3119"" Profanity=""fck&amp;nbsp;ing"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3120"" Profanity=""fck1ng"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3121"" Profanity=""fcking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3122"" Profanity=""fckw1t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3123"" Profanity=""fckwit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3124"" Profanity=""fcuk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3125"" Profanity=""fcuked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3126"" Profanity=""fcuker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3127"" Profanity=""fcukin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3128"" Profanity=""fcuking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3129"" Profanity=""fcuks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3130"" Profanity=""feck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3131"" Profanity=""feckin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3132"" Profanity=""fecking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3133"" Profanity=""felch"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3134"" Profanity=""felched"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3135"" Profanity=""Felching"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3136"" Profanity=""feltch"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3137"" Profanity=""feltcher"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3138"" Profanity=""feltching"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3139"" Profanity=""Flyers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3140"" Profanity=""FOAD"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3141"" Profanity=""fook"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3142"" Profanity=""fookin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3143"" Profanity=""fooking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3144"" Profanity=""freakin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3145"" Profanity=""freaking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3146"" Profanity=""free ipod"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3147"" Profanity=""frick"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3148"" Profanity=""frickin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3149"" Profanity=""fricking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3150"" Profanity=""frig"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3151"" Profanity=""friggin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3152"" Profanity=""frigging"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3153"" Profanity=""frigin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3154"" Profanity=""friging"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3155"" Profanity=""fu&amp;nbsp;ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3156"" Profanity=""fu&amp;nbsp;cked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3157"" Profanity=""fu&amp;nbsp;cker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3158"" Profanity=""fu&amp;nbsp;cking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3159"" Profanity=""fu(k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3160"" Profanity=""fu*k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3161"" Profanity=""fu@k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3162"" Profanity=""fu@ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3163"" Profanity=""fu^k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3164"" Profanity=""fu^ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3165"" Profanity=""fu^king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3166"" Profanity=""fuc"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3167"" Profanity=""fuc&amp;nbsp;ked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3168"" Profanity=""fuc&amp;nbsp;ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3169"" Profanity=""fuc&amp;nbsp;king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3170"" Profanity=""fuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3171"" Profanity=""Fùck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3172"" Profanity=""fúck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3173"" Profanity=""Fúçk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3174"" Profanity=""Fûck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3175"" Profanity=""Fück"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3176"" Profanity=""fuck&amp;nbsp;ed"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3177"" Profanity=""fuck&amp;nbsp;ing"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3178"" Profanity=""fuck-wit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3179"" Profanity=""fucke&amp;nbsp;d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3180"" Profanity=""fucked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3181"" Profanity=""fucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3182"" Profanity=""fuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3183"" Profanity=""fucki&amp;nbsp;ng"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3184"" Profanity=""fuckin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3185"" Profanity=""fucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3186"" Profanity=""fúcking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3187"" Profanity=""fuckk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3188"" Profanity=""fucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3189"" Profanity=""Fuckup"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3190"" Profanity=""fuckw1t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3191"" Profanity=""fuckwit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3192"" Profanity=""fucw1t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3193"" Profanity=""fucwit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3194"" Profanity=""fudge packer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3195"" Profanity=""fudgepacker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3196"" Profanity=""fuk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3197"" Profanity=""fukced"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3198"" Profanity=""fuked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3199"" Profanity=""fuker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3200"" Profanity=""fukin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3201"" Profanity=""fuking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3202"" Profanity=""fukk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3203"" Profanity=""fukked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3204"" Profanity=""fukker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3205"" Profanity=""fukkin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3206"" Profanity=""fukking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3207"" Profanity=""fuks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3208"" Profanity=""fvck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3209"" Profanity=""Fvck-up"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3210"" Profanity=""Fvckup"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3211"" Profanity=""fvckw1t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3212"" Profanity=""fvckwit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3213"" Profanity=""gimp"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3214"" Profanity=""Gypo"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3215"" Profanity=""Gypos"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3216"" Profanity=""Gyppo"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3217"" Profanity=""Gyppos"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3218"" Profanity=""gypsies"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3219"" Profanity=""gypsy"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3220"" Profanity=""h0m0"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3221"" Profanity=""h0mo"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3222"" Profanity=""homo"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3223"" Profanity=""http://jgg.pollhost.com/"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3224"" Profanity=""http://www.ogrish.com/"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3225"" Profanity=""http://www.ogrish.com/archives/2006/march/ogrish-d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3226"" Profanity=""http://www.youtube.com/watch?v=LJhpBRgZScI&amp;search="" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3227"" Profanity=""http://www.youtube.com/watch?v=w7DkSnhKkSk&amp;search="" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3228"" Profanity=""hun"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3229"" Profanity=""huns"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4114"" Profanity=""Joanne Lees"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3230"" Profanity=""K**t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3231"" Profanity=""k@ffir"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3232"" Profanity=""k@ffirs"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3233"" Profanity=""k@fir"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3234"" Profanity=""k@firs"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3235"" Profanity=""Kaf1r"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3236"" Profanity=""Kaff1r"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3237"" Profanity=""Kaffir"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3238"" Profanity=""Kaffirs"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3239"" Profanity=""Kafir"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3240"" Profanity=""Kafirs"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3241"" Profanity=""kafr"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3242"" Profanity=""Khunt"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3243"" Profanity=""kike"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3244"" Profanity=""kn0b"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3245"" Profanity=""knob"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3246"" Profanity=""knob&amp;nbsp;head"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3247"" Profanity=""Knobber"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3248"" Profanity=""knobhead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3249"" Profanity=""kraut"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3250"" Profanity=""Kunt"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3251"" Profanity=""kyke"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3252"" Profanity=""L m f a o"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3253"" Profanity=""L.m.f.a.o"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3254"" Profanity=""L.m.f.a.o."" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3255"" Profanity=""Lmfa0"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3256"" Profanity=""Lmfao"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3257"" Profanity=""M1nge"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4088"" Profanity=""maxine carr"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3258"" Profanity=""Minge"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3259"" Profanity=""mof**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3260"" Profanity=""mof**kers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3261"" Profanity=""mofuccer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3262"" Profanity=""mofucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3263"" Profanity=""mofuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3264"" Profanity=""mofucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3265"" Profanity=""mofukcer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3266"" Profanity=""mohterf**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3267"" Profanity=""mohterf**kers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3268"" Profanity=""mohterf*kcer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3269"" Profanity=""mohterfuccer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3270"" Profanity=""mohterfuccers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3271"" Profanity=""mohterfuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3272"" Profanity=""mohterfucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3273"" Profanity=""mohterfuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3274"" Profanity=""mohterfucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3275"" Profanity=""mohterfucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3276"" Profanity=""mohterfuk"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3277"" Profanity=""mohterfukcer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3278"" Profanity=""mohterfukcers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3279"" Profanity=""mohterfuking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3280"" Profanity=""mohterfuks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4203"" Profanity=""Montana"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3281"" Profanity=""moterf**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3282"" Profanity=""moterfuccer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3283"" Profanity=""moterfuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3284"" Profanity=""moterfucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3285"" Profanity=""moterfuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3286"" Profanity=""moterfucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3287"" Profanity=""moterfucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3288"" Profanity=""motha-fucka"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3289"" Profanity=""mothaf**k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3290"" Profanity=""mothaf**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3291"" Profanity=""mothaf**kers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3292"" Profanity=""mothaf**king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3293"" Profanity=""mothaf**ks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3294"" Profanity=""mothafuccer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3295"" Profanity=""mothafuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3296"" Profanity=""Mothafucka"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3297"" Profanity=""mothafucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3298"" Profanity=""mothafuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3299"" Profanity=""mothafucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3300"" Profanity=""mothafucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3301"" Profanity=""motherf**ked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3302"" Profanity=""Motherf**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3303"" Profanity=""Motherf**kers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3304"" Profanity=""Motherfuccer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3305"" Profanity=""Motherfuccers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3306"" Profanity=""Motherfuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3307"" Profanity=""motherfucked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3308"" Profanity=""Motherfucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3309"" Profanity=""Motherfuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3310"" Profanity=""Motherfucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3311"" Profanity=""Motherfucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3312"" Profanity=""motherfukkker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3313"" Profanity=""mthaf**ka"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3314"" Profanity=""mthafucca"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3315"" Profanity=""mthafuccas"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3316"" Profanity=""mthafucka"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3317"" Profanity=""mthafuckas"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3318"" Profanity=""mthafukca"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3319"" Profanity=""mthafukcas"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3320"" Profanity=""muncher"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3321"" Profanity=""Munchers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3322"" Profanity=""muth@fucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3323"" Profanity=""muthaf**k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3324"" Profanity=""muthaf**ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3325"" Profanity=""muthaf**kers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3326"" Profanity=""muthaf**king"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3327"" Profanity=""muthaf**ks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3328"" Profanity=""muthafuccer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3329"" Profanity=""muthafuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3330"" Profanity=""muthafuck@"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3331"" Profanity=""muthafucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3332"" Profanity=""muthafuckers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3333"" Profanity=""muthafucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3334"" Profanity=""muthafucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3335"" Profanity=""Muthafukas"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3336"" Profanity=""n0b"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3337"" Profanity=""N1gger"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3338"" Profanity=""N1ggers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3339"" Profanity=""Nige&amp;nbsp;Cooke"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3340"" Profanity=""Nigel C00k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3341"" Profanity=""Nigel C00ke"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3342"" Profanity=""Nigel Cook"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3343"" Profanity=""Nigel Cook3"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3344"" Profanity=""Nigel Cooke"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3345"" Profanity=""Nigel&amp;nbsp;C00k"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3346"" Profanity=""Nigel&amp;nbsp;C00ke"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3347"" Profanity=""Nigel&amp;nbsp;Cook"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3348"" Profanity=""Nigel&amp;nbsp;Cook3"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3349"" Profanity=""Nigel&amp;nbsp;Cooke"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3350"" Profanity=""nigga"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3351"" Profanity=""niggaz"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3352"" Profanity=""Nigger"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3353"" Profanity=""niggers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3354"" Profanity=""nob"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3355"" Profanity=""nob&amp;nbsp;head"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3356"" Profanity=""Nobhead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3357"" Profanity=""ogrish"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3358"" Profanity=""ogrish."" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3359"" Profanity=""ogrish.com"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3360"" Profanity=""p**i"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3361"" Profanity=""p*ki"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3362"" Profanity=""p@ki"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3363"" Profanity=""p@kis"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3364"" Profanity=""pak1"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3365"" Profanity=""paki"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3366"" Profanity=""pakis"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3367"" Profanity=""pench0d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3368"" Profanity=""pench0ds"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3369"" Profanity=""penchod"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3370"" Profanity=""penchods"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4112"" Profanity=""Peter Falconio"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3371"" Profanity=""phelching"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3372"" Profanity=""Phuck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3373"" Profanity=""Phucker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3374"" Profanity=""phuckin"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3375"" Profanity=""Phucking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3376"" Profanity=""Phucks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3377"" Profanity=""piss"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3378"" Profanity=""poff"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3379"" Profanity=""poof"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3380"" Profanity=""poofter"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4202"" Profanity=""Poska"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3381"" Profanity=""pr1ck"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3382"" Profanity=""prick"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3383"" Profanity=""Prik"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3384"" Profanity=""pu$$y"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3385"" Profanity=""pussy"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3386"" Profanity=""queer"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3387"" Profanity=""raghead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3388"" Profanity=""ragheads"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3389"" Profanity=""retard"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3390"" Profanity=""S1ut"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3391"" Profanity=""Scat"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3392"" Profanity=""Sh!t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3393"" Profanity=""sh!te"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3394"" Profanity=""sh!tes"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3395"" Profanity=""sh1t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3396"" Profanity=""sh1te"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3397"" Profanity=""shag"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3398"" Profanity=""shat"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3399"" Profanity=""shirtlifter"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3400"" Profanity=""shirtlifters"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3401"" Profanity=""shit"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3402"" Profanity=""shite"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3403"" Profanity=""slag"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3404"" Profanity=""spastic"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3405"" Profanity=""spic"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4121"" Profanity=""spliff"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3406"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3407"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s "" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3408"" Profanity=""t0$$er"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3409"" Profanity=""t0sser"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3410"" Profanity=""t0ssers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3411"" Profanity=""Tickets available"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3412"" Profanity=""to55er"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3413"" Profanity=""to55ers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3414"" Profanity=""tossers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4141"" Profanity=""towel head"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""4142"" Profanity=""towelhead"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3415"" Profanity=""turd"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3416"" Profanity=""tw&amp;nbsp;at"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3417"" Profanity=""tw@t"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3418"" Profanity=""tw@ts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3419"" Profanity=""twat"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3420"" Profanity=""twats"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3421"" Profanity=""Twunt"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3422"" Profanity=""twunts"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3423"" Profanity=""w anker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3424"" Profanity=""w*****"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3425"" Profanity=""w******"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3426"" Profanity=""w@nker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3427"" Profanity=""w@nkers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3428"" Profanity=""w0g"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3429"" Profanity=""w0gs"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3430"" Profanity=""wa nker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3431"" Profanity=""wan ker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3432"" Profanity=""wank"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3433"" Profanity=""wank's"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3434"" Profanity=""wanke r"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3435"" Profanity=""wanked"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3436"" Profanity=""wanker"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3437"" Profanity=""wankers"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3438"" Profanity=""wanking"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3439"" Profanity=""wanks"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3440"" Profanity=""whore"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3441"" Profanity=""wog"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3442"" Profanity=""wop"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3443"" Profanity=""Xxxhole"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3444"" Profanity=""Y*d"" MODCLASSID=""7"" Refer=""1"" />
    <P ProfanityID=""3445"" Profanity=""yid"" MODCLASSID=""7"" Refer=""1"" />
  </profanities>";
        #endregion
    }
}