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
    <P ProfanityID=""2145"" Profanity=""batty boy"" ModClassID=""1"" Refer=""1"" ForumID=""1"" />
    <P ProfanityID=""4122"" Profanity=""Beshenivsky"" ModClassID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""4143"" Profanity=""Bomb"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4144"" Profanity=""Bombing"" ModClassID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""4095"" Profanity=""Bradley John Murdoch"" ModClassID=""1"" Refer=""1"" ForumID=""3""  />
    <P ProfanityID=""4096"" Profanity=""Bradley Murdoch"" ModClassID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""2142"" Profanity=""cu nt"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""1784"" Profanity=""cunt"" ModClassID=""1"" Refer=""1"" ForumID=""2""  />
    <P ProfanityID=""1785"" Profanity=""cunts"" ModClassID=""1"" Refer=""1"" ForumID=""3""  />
    <P ProfanityID=""2143"" Profanity=""f uck"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4093"" Profanity=""Falconio"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2144"" Profanity=""fck ing"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2148"" Profanity=""Felching"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3997"" Profanity=""Gina Ford"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4206"" Profanity=""Heather Mills"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4094"" Profanity=""Joanne Lees"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2153"" Profanity=""knob head"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3975"" Profanity=""Lawrence"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3976"" Profanity=""Lawrence's"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3977"" Profanity=""Lawrences"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4222"" Profanity=""Macca"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4083"" Profanity=""maxine carr"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4205"" Profanity=""McCartney"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""1782"" Profanity=""motherfucker"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""1783"" Profanity=""motherfuckers"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4221"" Profanity=""Mucca"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4092"" Profanity=""Peter Falconio"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4134"" Profanity=""rag head"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4133"" Profanity=""raghead"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3973"" Profanity=""Stephen Lawrence’s"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""3974"" Profanity=""Stephen Lawrences"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4132"" Profanity=""towel head"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""4131"" Profanity=""towelhead"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2147"" Profanity=""tw at"" ModClassID=""1"" Refer=""1"" ForumID=""1""  />
    <P ProfanityID=""2273"" Profanity=""(ock"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1522"" Profanity=""A$$hole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1524"" Profanity=""A$$hole$"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1523"" Profanity=""A$$holes"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1579"" Profanity=""A+*hole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3512"" Profanity=""a.rse"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1571"" Profanity=""ar$ehole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1525"" Profanity=""Ar$hole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1526"" Profanity=""Ar$holes"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1701"" Profanity=""ar5h0le"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1703"" Profanity=""ar5h0les"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2636"" Profanity=""ars3"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2635"" Profanity=""arse hole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""970"" Profanity=""arseh0le"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""972"" Profanity=""arseh0les"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""917"" Profanity=""arsehol"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""865"" Profanity=""arsehole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""866"" Profanity=""arseholes"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3482"" Profanity=""arsewipe"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""971"" Profanity=""arsh0le"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""867"" Profanity=""arshole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""868"" Profanity=""arsholes"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""869"" Profanity=""ashole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2638"" Profanity=""ass h0le"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2637"" Profanity=""ass hole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""973"" Profanity=""assh0le"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""974"" Profanity=""assh0les"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""870"" Profanity=""asshole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""871"" Profanity=""assholes"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3520"" Profanity=""b.astard"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3511"" Profanity=""b.ollocks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3519"" Profanity=""b.ugger"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1756"" Profanity=""b00tha"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1757"" Profanity=""b00thas"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""875"" Profanity=""b0ll0cks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1531"" Profanity=""B0llocks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3820"" Profanity=""bastards"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3484"" Profanity=""basterd"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2261"" Profanity=""batty&amp;nbsp;boi"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2260"" Profanity=""batty&amp;nbsp;boy"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4079"" Profanity=""bbchidden.blogspot.com"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4147"" Profanity=""Beef curtains"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1749"" Profanity=""bo****ks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1532"" Profanity=""Boll0cks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""872"" Profanity=""bollocks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""490"" Profanity=""bollox"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""492"" Profanity=""bolocks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""491"" Profanity=""bolox"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1755"" Profanity=""bootha"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1754"" Profanity=""boothas"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""925"" Profanity=""Bukkake"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1533"" Profanity=""Bullsh!t"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2919"" Profanity=""bum bandit"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2634"" Profanity=""bum hole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2923"" Profanity=""bum-bandit"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2921"" Profanity=""bumbandit"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2633"" Profanity=""bumh0l3"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2631"" Profanity=""bumh0le"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2632"" Profanity=""bumhol3"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2630"" Profanity=""bumhole"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1481"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""815"" Profanity=""C**t"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""819"" Profanity=""C**t's"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""818"" Profanity=""C**ts"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""360"" Profanity=""c.u.n.t"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3514"" Profanity=""c.unt"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3507"" Profanity=""c.untyb.ollocks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""504"" Profanity=""c00n"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1808"" Profanity=""C0cksucka"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1809"" Profanity=""C0cksucker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1720"" Profanity=""cnut"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1719"" Profanity=""cnuts"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2272"" Profanity=""Co(k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2255"" Profanity=""coc&amp;nbsp;k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1807"" Profanity=""Cocksucka"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1806"" Profanity=""Cocksucker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1886"" Profanity=""Cok"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""503"" Profanity=""coon"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1974"" Profanity=""cu&amp;nbsp;nt"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1975"" Profanity=""cu&amp;nbsp;nts"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""358"" Profanity=""Cunt"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""362"" Profanity=""Cunt's"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""879"" Profanity=""cunting"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""361"" Profanity=""Cunts"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1758"" Profanity=""cvnt"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1759"" Profanity=""cvnts"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2453"" Profanity=""D**khead"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2541"" Profanity=""dick&amp;nbsp;head"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""933"" Profanity=""dickhead"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""471"" Profanity=""dumbfuck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""472"" Profanity=""dumbfucker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2454"" Profanity=""Dxxkhead"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1641"" Profanity=""effing"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2778"" Profanity=""F o a d"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2869"" Profanity=""f u c k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2900"" Profanity=""f u c ked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1588"" Profanity=""f###"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1497"" Profanity=""f##k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3525"" Profanity=""f##king"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3524"" Profanity=""f#cked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""449"" Profanity=""F$cks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2527"" Profanity=""f&amp;nbsp;cked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1521"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2258"" Profanity=""f&amp;nbsp;uck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2537"" Profanity=""f&amp;nbsp;ucker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2532"" Profanity=""f&amp;nbsp;ucking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3523"" Profanity=""F'ck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1587"" Profanity=""f***"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1489"" Profanity=""f*****g"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""888"" Profanity=""f****d"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""890"" Profanity=""f***ed"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""991"" Profanity=""f***in"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""939"" Profanity=""f***ing"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""941"" Profanity=""f**k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""855"" Profanity=""f**ked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""859"" Profanity=""f**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""945"" Profanity=""f**kin"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""853"" Profanity=""f**king"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""857"" Profanity=""f**ks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""467"" Profanity=""f*ck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""856"" Profanity=""f*ked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""860"" Profanity=""f*ker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""858"" Profanity=""f*ks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""466"" Profanity=""f*uck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1527"" Profanity=""F*uk"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2777"" Profanity=""F-o-a-d"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2775"" Profanity=""F.O.A.D"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2776"" Profanity=""F.O.A.D."" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""431"" Profanity=""f.u.c.k."" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3508"" Profanity=""f.uck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1885"" Profanity=""f@ck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2767"" Profanity=""f@g"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2766"" Profanity=""f@gs"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2828"" Profanity=""f^^k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2829"" Profanity=""f^^ked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2833"" Profanity=""f^^ker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2830"" Profanity=""f^^king"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2831"" Profanity=""f^ck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2834"" Profanity=""f^cker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2836"" Profanity=""f^cking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2866"" Profanity=""f00k"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2299"" Profanity=""Fack"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2307"" Profanity=""Fackin"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2318"" Profanity=""facking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""854"" Profanity=""fc*king"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4070"" Profanity=""fck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2259"" Profanity=""fck&amp;nbsp;ing"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1748"" Profanity=""fck1ng"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1747"" Profanity=""fcking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""4071"" Profanity=""fcks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1792"" Profanity=""fckw1t"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""1791"" Profanity=""fckwit"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""433"" Profanity=""fcuk"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""439"" Profanity=""fcuked"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""445"" Profanity=""fcuker"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""455"" Profanity=""fcukin"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""436"" Profanity=""fcuking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""442"" Profanity=""fcuks"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2300"" Profanity=""feck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2309"" Profanity=""feckin"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2319"" Profanity=""fecking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""3486"" Profanity=""fekking"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""495"" Profanity=""felch"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""498"" Profanity=""felched"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2263"" Profanity=""Felching"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""494"" Profanity=""feltch"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""497"" Profanity=""feltcher"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""496"" Profanity=""feltching"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2774"" Profanity=""FOAD"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2303"" Profanity=""frig"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2323"" Profanity=""frigging"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2312"" Profanity=""frigin"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2322"" Profanity=""friging"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2256"" Profanity=""fu&amp;nbsp;ck"" ModClassID=""3"" Refer=""0"" ForumID=""1""  />
    <P ProfanityID=""2528"" Profanity=""fu&amp;nbsp;cked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2538"" Profanity=""fu&amp;nbsp;cker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2533"" Profanity=""fu&amp;nbsp;cking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2433"" Profanity=""fu(k"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""468"" Profanity=""fu*k"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1811"" Profanity=""fu@k"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1812"" Profanity=""fu@ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2832"" Profanity=""fu^k"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2835"" Profanity=""fu^ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2837"" Profanity=""fu^king"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""470"" Profanity=""fuc"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2529"" Profanity=""fuc&amp;nbsp;ked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2539"" Profanity=""fuc&amp;nbsp;ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2534"" Profanity=""fuc&amp;nbsp;king"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""430"" Profanity=""fuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2871"" Profanity=""Fùck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""886"" Profanity=""fúck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2865"" Profanity=""Fúçk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2870"" Profanity=""Fûck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2872"" Profanity=""Fück"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2530"" Profanity=""fuck&amp;nbsp;ed"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2535"" Profanity=""fuck&amp;nbsp;ing"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1788"" Profanity=""fuck-wit"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2531"" Profanity=""fucke&amp;nbsp;d"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""437"" Profanity=""fucked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""443"" Profanity=""fucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1563"" Profanity=""fuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2536"" Profanity=""fucki&amp;nbsp;ng"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""453"" Profanity=""fuckin"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""434"" Profanity=""fucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""881"" Profanity=""fúcking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""463"" Profanity=""fuckk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""440"" Profanity=""fucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2271"" Profanity=""Fuckup"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1790"" Profanity=""fuckw1t"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1786"" Profanity=""fuckwit"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1794"" Profanity=""fucw1t"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1793"" Profanity=""fucwit"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3500"" Profanity=""Fudge p@cker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2965"" Profanity=""fudge packer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3501"" Profanity=""Fudge-p@cker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3497"" Profanity=""Fudge-packer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3499"" Profanity=""fudgep@cker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2963"" Profanity=""fudgepacker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3498"" Profanity=""Fudgpacker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""432"" Profanity=""fuk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""465"" Profanity=""fukced"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""438"" Profanity=""fuked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""444"" Profanity=""fuker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""454"" Profanity=""fukin"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""435"" Profanity=""fuking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2304"" Profanity=""fukk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""459"" Profanity=""fukked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""461"" Profanity=""fukker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""460"" Profanity=""fukkin"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2324"" Profanity=""fukking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""441"" Profanity=""fuks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2002"" Profanity=""fvck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1810"" Profanity=""Fvck-up"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1813"" Profanity=""Fvckup"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1789"" Profanity=""fvckw1t"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1787"" Profanity=""fvckwit"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1969"" Profanity=""Gypo"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1970"" Profanity=""Gypos"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1968"" Profanity=""Gyppo"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2915"" Profanity=""Gyppos"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4062"" Profanity=""http://excoboard.com/exco/index.php?boardid=19215"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4000"" Profanity=""http://kingsofclay.proboards100.com/index.cgi "" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4223"" Profanity=""http://www.kitbag.com/stores/celtic/products/produ"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3454"" Profanity=""http://www.scots.8k.com"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4090"" Profanity=""http://www.yesitshelpful.com"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4009"" Profanity=""Icebreaker uk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4006"" Profanity=""Icebreakeruk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""816"" Profanity=""K**t"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1960"" Profanity=""k@ffir"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1961"" Profanity=""k@ffirs"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1959"" Profanity=""k@fir"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1962"" Profanity=""k@firs"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1963"" Profanity=""Kaf1r"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1964"" Profanity=""Kaff1r"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1956"" Profanity=""Kaffir"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1958"" Profanity=""Kaffirs"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1955"" Profanity=""Kafir"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1957"" Profanity=""Kafirs"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2617"" Profanity=""kafr"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1887"" Profanity=""Khunt"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""953"" Profanity=""kike"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4227"" Profanity=""kitbag.com"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2268"" Profanity=""knob&amp;nbsp;head"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2269"" Profanity=""Knobber"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2615"" Profanity=""knobhead"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""359"" Profanity=""Kunt"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""954"" Profanity=""kyke"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2683"" Profanity=""L m f a o"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2685"" Profanity=""L.m.f.a.o"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2684"" Profanity=""L.m.f.a.o."" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2682"" Profanity=""Lmfa0"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2681"" Profanity=""Lmfao"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3515"" Profanity=""m.inge"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3506"" Profanity=""M.otherf.ucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2913"" Profanity=""M1nge"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3938"" Profanity=""mfbb.net/speakerscorner/speakerscorner/index.php?m"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2823"" Profanity=""Minge"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""825"" Profanity=""mof**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""847"" Profanity=""mof**kers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""386"" Profanity=""mofuccer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""368"" Profanity=""mofucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""408"" Profanity=""mofuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""397"" Profanity=""mofucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""373"" Profanity=""mofukcer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""823"" Profanity=""mohterf**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""841"" Profanity=""mohterf**kers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""824"" Profanity=""mohterf*kcer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""385"" Profanity=""mohterfuccer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""423"" Profanity=""mohterfuccers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""377"" Profanity=""mohterfuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""366"" Profanity=""mohterfucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""406"" Profanity=""mohterfuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""395"" Profanity=""mohterfucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""416"" Profanity=""mohterfucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""378"" Profanity=""mohterfuk"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""367"" Profanity=""mohterfukcer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""407"" Profanity=""mohterfukcers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""396"" Profanity=""mohterfuking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""417"" Profanity=""mohterfuks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""822"" Profanity=""moterf**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""384"" Profanity=""moterfuccer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""376"" Profanity=""moterfuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""365"" Profanity=""moterfucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""405"" Profanity=""moterfuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""394"" Profanity=""moterfucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""415"" Profanity=""moterfucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1805"" Profanity=""motha-fucka"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""831"" Profanity=""mothaf**k"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""826"" Profanity=""mothaf**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""844"" Profanity=""mothaf**kers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""834"" Profanity=""mothaf**king"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""848"" Profanity=""mothaf**ks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""387"" Profanity=""mothafuccer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""380"" Profanity=""mothafuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1804"" Profanity=""Mothafucka"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""369"" Profanity=""mothafucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""409"" Profanity=""mothafuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""398"" Profanity=""mothafucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""419"" Profanity=""mothafucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""820"" Profanity=""motherf**ked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""821"" Profanity=""Motherf**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""840"" Profanity=""Motherf**kers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""383"" Profanity=""Motherfuccer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""422"" Profanity=""Motherfuccers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""375"" Profanity=""Motherfuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""363"" Profanity=""motherfucked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""364"" Profanity=""Motherfucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""404"" Profanity=""Motherfuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""393"" Profanity=""Motherfucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""414"" Profanity=""Motherfucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""402"" Profanity=""motherfukkker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""829"" Profanity=""mthaf**ka"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""390"" Profanity=""mthafucca"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""429"" Profanity=""mthafuccas"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""372"" Profanity=""mthafucka"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""412"" Profanity=""mthafuckas"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""374"" Profanity=""mthafukca"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""413"" Profanity=""mthafukcas"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""401"" Profanity=""muth@fucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""832"" Profanity=""muthaf**k"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""827"" Profanity=""muthaf**ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""845"" Profanity=""muthaf**kers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""835"" Profanity=""muthaf**king"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""849"" Profanity=""muthaf**ks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""388"" Profanity=""muthafuccer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""381"" Profanity=""muthafuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""403"" Profanity=""muthafuck@"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4051"" Profanity=""Muthafucka"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""370"" Profanity=""muthafucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""410"" Profanity=""muthafuckers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""399"" Profanity=""muthafucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""420"" Profanity=""muthafucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1884"" Profanity=""Muthafukas"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1972"" Profanity=""N1gger"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1973"" Profanity=""N1ggers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3528"" Profanity=""nig nog"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3527"" Profanity=""nig-nog"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3961"" Profanity=""Nigel Cooke"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""500"" Profanity=""nigga"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""502"" Profanity=""niggaz"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""499"" Profanity=""Nigger"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""501"" Profanity=""niggers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3529"" Profanity=""nignog"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2267"" Profanity=""nob&amp;nbsp;head"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2266"" Profanity=""Nobhead"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1671"" Profanity=""p**i"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1668"" Profanity=""p*ki"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3516"" Profanity=""p.iss-flaps"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1669"" Profanity=""p@ki"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1684"" Profanity=""p@kis"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1670"" Profanity=""pak1"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""507"" Profanity=""paki"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1680"" Profanity=""pakis"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1753"" Profanity=""pench0d"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1752"" Profanity=""pench0ds"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1750"" Profanity=""penchod"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1751"" Profanity=""penchods"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3505"" Profanity=""Peter dow"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2327"" Profanity=""phelching"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1881"" Profanity=""Phuck"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1883"" Profanity=""Phucker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2315"" Profanity=""phuckin"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1882"" Profanity=""Phucking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1965"" Profanity=""Phucks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3526"" Profanity=""Piss off"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3517"" Profanity=""Pissflaps"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4148"" Profanity=""Poo stabber"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4150"" Profanity=""Poo stabbers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""515"" Profanity=""poofter"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1890"" Profanity=""Prik"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""758"" Profanity=""raghead"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""760"" Profanity=""ragheads"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3509"" Profanity=""s.hit"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2264"" Profanity=""S1ut"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3450"" Profanity=""scots.8k.com"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3504"" Profanity=""Scottish National Standard Bearer"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2917"" Profanity=""shirtlifter"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2925"" Profanity=""shirtlifters"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4149"" Profanity=""Shit stabber"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4151"" Profanity=""Shit stabbers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""510"" Profanity=""spic"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1976"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1977"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s "" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3513"" Profanity=""t.wat"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2452"" Profanity=""t0$$er"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""985"" Profanity=""t0sser"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1767"" Profanity=""t0ssers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""979"" Profanity=""to55er"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1768"" Profanity=""to55ers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1769"" Profanity=""tossers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4135"" Profanity=""towel head"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4136"" Profanity=""towelhead"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2262"" Profanity=""tw&amp;nbsp;at"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4076"" Profanity=""tw@"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""474"" Profanity=""tw@t"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1967"" Profanity=""tw@ts"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""473"" Profanity=""twat"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1730"" Profanity=""twats"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1888"" Profanity=""Twunt"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1924"" Profanity=""twunts"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2657"" Profanity=""w anker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3522"" Profanity=""W#nker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3521"" Profanity=""W#nkers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3510"" Profanity=""w.ank"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""957"" Profanity=""w@nker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""958"" Profanity=""w@nkers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""975"" Profanity=""w0g"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""976"" Profanity=""w0gs"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2658"" Profanity=""wa nker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4152"" Profanity=""Wan k er"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4153"" Profanity=""Wan k ers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2659"" Profanity=""wan ker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""475"" Profanity=""wank"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""480"" Profanity=""wank's"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4050"" Profanity=""Wanka"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2661"" Profanity=""wanke r"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""478"" Profanity=""wanked"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""477"" Profanity=""wanker"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""987"" Profanity=""wankers"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""476"" Profanity=""wanking"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""479"" Profanity=""wanks"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""508"" Profanity=""wog"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3937"" Profanity=""www.mfbb.net/speakerscorner/speakerscorner/index.p"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4089"" Profanity=""www.yesitshelpful.com"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2265"" Profanity=""Xxxhole"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1520"" Profanity=""Y*d"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""511"" Profanity=""yid"" ModClassID=""3"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3999"" Profanity=""84 Fresh"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4037"" Profanity=""Abdul Muneem Patel"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4045"" Profanity=""Abdul Patel"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4030"" Profanity=""Abdula Ahmed Ali"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4041"" Profanity=""Abdula Ali"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4044"" Profanity=""Adam Khatib"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4035"" Profanity=""Adam Osman Khatib"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3496"" Profanity=""Advance tickets"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4034"" Profanity=""Arafat Khan"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""516"" Profanity=""arse"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3966"" Profanity=""askew"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3965"" Profanity=""aspew"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4047"" Profanity=""Assad"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4038"" Profanity=""Assad Sarwar"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2716"" Profanity=""b1tch"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""517"" Profanity=""bastard"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4156"" Profanity=""Belton"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4123"" Profanity=""Beshenivsky"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""520"" Profanity=""bitch"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4145"" Profanity=""Bomb"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4146"" Profanity=""Bombing"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4110"" Profanity=""Bradley John Murdoch"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4111"" Profanity=""Bradley Murdoch"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""921"" Profanity=""bugger"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""523"" Profanity=""c0ck"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3873"" Profanity=""CASH PRIZE"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3874"" Profanity=""cash prizes"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3885"" Profanity=""Celtic Distribution"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3888"" Profanity=""Celtic Music"" ModClassID=""3"" Refer=""1"" ForumID=""1"" />
    <P ProfanityID=""549"" Profanity=""clit"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""1714"" Profanity=""cock"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4042"" Profanity=""Cossor"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4031"" Profanity=""Cossor Ali"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""545"" Profanity=""cripple"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""529"" Profanity=""d1ck"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""505"" Profanity=""darkie"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""506"" Profanity=""darky"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""528"" Profanity=""dick"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2758"" Profanity=""door price"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3539"" Profanity=""enter free at"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3536"" Profanity=""ENTRIES CLOSE AT"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2760"" Profanity=""fag"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""541"" Profanity=""fagg0t"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""540"" Profanity=""faggot"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2761"" Profanity=""fags"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4108"" Profanity=""Falconio"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""531"" Profanity=""fanny"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3858"" Profanity=""flange"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2687"" Profanity=""Flyers"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2605"" Profanity=""free ipod"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3899"" Profanity=""Free PS3"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3880"" Profanity=""free xbox"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""547"" Profanity=""gimp"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3995"" Profanity=""Gina Ford"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3850"" Profanity=""Glaxo"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3849"" Profanity=""GlaxoSmithKline"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3878"" Profanity=""greyhoundscene"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2610"" Profanity=""gypsies"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2609"" Profanity=""gypsy"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""544"" Profanity=""h0m0"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""543"" Profanity=""h0mo"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4208"" Profanity=""Heather Mills"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""542"" Profanity=""homo"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3935"" Profanity=""http://onerugbyleague.proboards76.com/index.cgi#ge"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""551"" Profanity=""hun"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""550"" Profanity=""huns"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4039"" Profanity=""Ibrahim Savant"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4130"" Profanity=""invade"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4109"" Profanity=""Joanne Lees"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4004"" Profanity=""kings of clay"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4005"" Profanity=""kingsofclay"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""525"" Profanity=""kn0b"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""524"" Profanity=""knob"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""552"" Profanity=""kraut"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4220"" Profanity=""Macca"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4084"" Profanity=""maxine carr"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4207"" Profanity=""McCartney"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4036"" Profanity=""Mehran Hussain"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4129"" Profanity=""migrate"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4155"" Profanity=""Montana"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4219"" Profanity=""Mucca"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2007"" Profanity=""muncher"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""1889"" Profanity=""Munchers"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2435"" Profanity=""n0b"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2434"" Profanity=""nob"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2943"" Profanity=""ogrish.com"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3993"" Profanity=""Peta"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4107"" Profanity=""Peter Falconio"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""537"" Profanity=""piss"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2013"" Profanity=""poff"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""514"" Profanity=""poof"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4154"" Profanity=""Poska"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""527"" Profanity=""pr1ck"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""526"" Profanity=""prick"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3881"" Profanity=""Proper Ganda "" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3886"" Profanity=""Proper Music People"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3882"" Profanity=""Properganda "" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""1601"" Profanity=""pu$$y"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""530"" Profanity=""pussy"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""539"" Profanity=""queer"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""546"" Profanity=""retard"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4046"" Profanity=""Sarwar"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4048"" Profanity=""Savant"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2270"" Profanity=""Scat"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""1528"" Profanity=""Sh!t"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""959"" Profanity=""sh!te"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""960"" Profanity=""sh!tes"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""535"" Profanity=""sh1t"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""536"" Profanity=""sh1te"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""554"" Profanity=""shag"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""534"" Profanity=""shat"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""533"" Profanity=""shite"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""518"" Profanity=""slag"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""513"" Profanity=""spastic"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4117"" Profanity=""spliff"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4032"" Profanity=""Tanvir Hussain"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2686"" Profanity=""Tickets available"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""538"" Profanity=""turd"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4033"" Profanity=""Umar Islam"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4040"" Profanity=""Waheed Zamen"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""519"" Profanity=""whore"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""3542"" Profanity=""win cash prizes"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""509"" Profanity=""wop"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""4049"" Profanity=""Zamen"" ModClassID=""3"" Refer=""1"" />
    <P ProfanityID=""2227"" Profanity=""(ock"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1508"" Profanity=""A$$hole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1510"" Profanity=""A$$hole$"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1509"" Profanity=""A$$holes"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1583"" Profanity=""A+*hole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1573"" Profanity=""ar$ehole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1511"" Profanity=""Ar$hole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1512"" Profanity=""Ar$holes"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1707"" Profanity=""ar5h0l3"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1705"" Profanity=""ar5h0le"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1706"" Profanity=""ar5h0les"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2627"" Profanity=""ars3"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2626"" Profanity=""arse hole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""965"" Profanity=""arseh0le"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""967"" Profanity=""arseh0les"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""135"" Profanity=""arsehol "" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""128"" Profanity=""arsehole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""129"" Profanity=""arseholes"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3476"" Profanity=""arsewipe"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""966"" Profanity=""arsh0le"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""134"" Profanity=""arshole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""131"" Profanity=""arsholes"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""133"" Profanity=""ashole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2629"" Profanity=""ass h0le"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2628"" Profanity=""ass hole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""968"" Profanity=""assh0le"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""969"" Profanity=""assh0les"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""132"" Profanity=""asshole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""130"" Profanity=""assholes"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1743"" Profanity=""b00tha"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1744"" Profanity=""b00thas"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""877"" Profanity=""b0ll0cks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1517"" Profanity=""B0llocks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3818"" Profanity=""bastards"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3480"" Profanity=""basterd"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2215"" Profanity=""batty&amp;nbsp;boi"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2214"" Profanity=""batty&amp;nbsp;boy"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4081"" Profanity=""bbchidden.blogspot.com"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4159"" Profanity=""Beef curtains"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1736"" Profanity=""bo****ks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1518"" Profanity=""Boll0cks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""136"" Profanity=""bollocks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""137"" Profanity=""bollox"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""139"" Profanity=""bolocks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""138"" Profanity=""bolox"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1742"" Profanity=""bootha"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1741"" Profanity=""boothas"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""927"" Profanity=""Bukkake"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1519"" Profanity=""Bullsh!t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2625"" Profanity=""bum hole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2624"" Profanity=""bumh0l3"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2622"" Profanity=""bumh0le"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2623"" Profanity=""bumhol3"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2621"" Profanity=""bumhole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1483"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""766"" Profanity=""C**t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""770"" Profanity=""C**t's"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""769"" Profanity=""C**ts"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""7"" Profanity=""c.u.n.t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""151"" Profanity=""c00n"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1827"" Profanity=""C0cksucka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1828"" Profanity=""C0cksucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2226"" Profanity=""Co(k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2209"" Profanity=""coc&amp;nbsp;k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1826"" Profanity=""Cocksucka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1825"" Profanity=""Cocksucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1919"" Profanity=""Cok"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""150"" Profanity=""coon"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2211"" Profanity=""cu&amp;nbsp;nt"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""5"" Profanity=""Cunt"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""9"" Profanity=""Cunt's"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""884"" Profanity=""cunting"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""8"" Profanity=""Cunts"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1745"" Profanity=""cvnt"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1746"" Profanity=""cvnts"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2461"" Profanity=""D**khead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""152"" Profanity=""darkie"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""153"" Profanity=""darky"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""755"" Profanity=""dickhead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""118"" Profanity=""dumbfuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""119"" Profanity=""dumbfucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2462"" Profanity=""Dxxkhead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1643"" Profanity=""effing"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2785"" Profanity=""F o a d"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2877"" Profanity=""f u c k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2898"" Profanity=""f u c ked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1590"" Profanity=""f###"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1499"" Profanity=""f##k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""96"" Profanity=""F$cks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2559"" Profanity=""f&amp;nbsp;cked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1507"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2212"" Profanity=""f&amp;nbsp;uck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2569"" Profanity=""f&amp;nbsp;ucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2564"" Profanity=""f&amp;nbsp;ucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1589"" Profanity=""f***"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1515"" Profanity=""F*****"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1516"" Profanity=""F******"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1491"" Profanity=""f*****g"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""892"" Profanity=""f****d"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""893"" Profanity=""f***ed"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""993"" Profanity=""f***in"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""937"" Profanity=""f***ing"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""943"" Profanity=""f**k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""806"" Profanity=""f**ked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""810"" Profanity=""f**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""947"" Profanity=""f**kin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""804"" Profanity=""f**king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""808"" Profanity=""f**ks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""114"" Profanity=""f*ck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""807"" Profanity=""f*ked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""811"" Profanity=""f*ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""809"" Profanity=""f*ks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""113"" Profanity=""f*uck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1513"" Profanity=""F*uk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2784"" Profanity=""F-o-a-d"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2782"" Profanity=""F.O.A.D"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2783"" Profanity=""F.O.A.D."" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""78"" Profanity=""f.u.c.k."" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1918"" Profanity=""f@ck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2769"" Profanity=""f@g"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2768"" Profanity=""f@gs"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2826"" Profanity=""f^^k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2838"" Profanity=""f^^ked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2842"" Profanity=""f^^ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2839"" Profanity=""f^^king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2840"" Profanity=""f^ck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2843"" Profanity=""f^cker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2845"" Profanity=""f^cking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2874"" Profanity=""f00k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2330"" Profanity=""Fack"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2338"" Profanity=""Fackin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2349"" Profanity=""facking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""805"" Profanity=""fc*king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4072"" Profanity=""fck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2213"" Profanity=""fck&amp;nbsp;ing"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1735"" Profanity=""fck1ng"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1734"" Profanity=""fcking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4073"" Profanity=""fcks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1820"" Profanity=""fckw1t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1819"" Profanity=""fckwit"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""80"" Profanity=""fcuk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""86"" Profanity=""fcuked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""92"" Profanity=""fcuker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""102"" Profanity=""fcukin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""83"" Profanity=""fcuking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""89"" Profanity=""fcuks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2331"" Profanity=""feck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2340"" Profanity=""feckin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2350"" Profanity=""fecking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3478"" Profanity=""feking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""142"" Profanity=""felch"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""145"" Profanity=""felched"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2432"" Profanity=""felchin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2431"" Profanity=""felchin'"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2217"" Profanity=""Felching"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""141"" Profanity=""feltch"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""144"" Profanity=""feltcher"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""143"" Profanity=""feltching"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2781"" Profanity=""FOAD"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2336"" Profanity=""fook"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2345"" Profanity=""fookin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2356"" Profanity=""fooking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2607"" Profanity=""free ipod"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2342"" Profanity=""frickin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2352"" Profanity=""fricking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2334"" Profanity=""frig"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2348"" Profanity=""friggin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2354"" Profanity=""frigging"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2343"" Profanity=""frigin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2353"" Profanity=""friging"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2210"" Profanity=""fu&amp;nbsp;ck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2560"" Profanity=""fu&amp;nbsp;cked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2570"" Profanity=""fu&amp;nbsp;cker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2565"" Profanity=""fu&amp;nbsp;cking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2436"" Profanity=""fu(k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""115"" Profanity=""fu*k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1830"" Profanity=""fu@k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1831"" Profanity=""fu@ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2841"" Profanity=""fu^k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2844"" Profanity=""fu^ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2846"" Profanity=""fu^king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""117"" Profanity=""fuc"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2561"" Profanity=""fuc&amp;nbsp;ked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2571"" Profanity=""fuc&amp;nbsp;ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2566"" Profanity=""fuc&amp;nbsp;king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""77"" Profanity=""fuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2879"" Profanity=""Fùck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""885"" Profanity=""fúck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2873"" Profanity=""Fúçk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2878"" Profanity=""Fûck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2880"" Profanity=""Fück"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2562"" Profanity=""fuck&amp;nbsp;ed"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2567"" Profanity=""fuck&amp;nbsp;ing"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1816"" Profanity=""fuck-wit"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2563"" Profanity=""fucke&amp;nbsp;d"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""84"" Profanity=""fucked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""90"" Profanity=""fucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1567"" Profanity=""fuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2568"" Profanity=""fucki&amp;nbsp;ng"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""100"" Profanity=""fuckin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""81"" Profanity=""fucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""883"" Profanity=""fúcking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""110"" Profanity=""fuckk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""87"" Profanity=""fucks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2225"" Profanity=""Fuckup"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1818"" Profanity=""fuckw1t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1814"" Profanity=""fuckwit"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1822"" Profanity=""fucw1t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1821"" Profanity=""fucwit"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2953"" Profanity=""fudge packer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2951"" Profanity=""fudgepacker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""79"" Profanity=""fuk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""112"" Profanity=""fukced"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""85"" Profanity=""fuked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""91"" Profanity=""fuker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""101"" Profanity=""fukin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""82"" Profanity=""fuking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2335"" Profanity=""fukk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""106"" Profanity=""fukked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""108"" Profanity=""fukker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""107"" Profanity=""fukkin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2355"" Profanity=""fukking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""88"" Profanity=""fuks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2003"" Profanity=""fvck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1829"" Profanity=""Fvck-up"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1832"" Profanity=""Fvckup"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1817"" Profanity=""fvckw1t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1815"" Profanity=""fvckwit"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3963"" Profanity=""http://directory.myfreebulletinboard.com/category."" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4063"" Profanity=""http://excoboard.com/exco/index.php?boardid=19215"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3816"" Profanity=""http://freespeach.proboards3.com/index.cgi"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4001"" Profanity=""http://kingsofclay.proboards100.com/index.cgi "" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3831"" Profanity=""http://www.globalresearch.ca/index.php?context=vie"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3824"" Profanity=""http://www.infowars.net/Pages/Aug05/020805Aswat.ht"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3826"" Profanity=""http://www.israelnationalnews.com/news.php3?id=853"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4224"" Profanity=""http://www.kitbag.com/stores/celtic/products/produ"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3949"" Profanity=""http://www.mfbb.net/"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3953"" Profanity=""http://www.mfbb.net/?mforum=free"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3957"" Profanity=""http://www.mfbb.net/free-about1306.html"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3955"" Profanity=""http://www.mfbb.net/free-forum-8.html"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3950"" Profanity=""http://www.myfreebulletinboard.com/"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3828"" Profanity=""http://www.prisonplanet.com/archives/london/index."" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3825"" Profanity=""http://www.prisonplanet.com/articles/august2005/02"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3829"" Profanity=""http://www.prisonplanet.com/articles/july2005/0907"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3830"" Profanity=""http://www.prisonplanet.com/articles/july2005/1507"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3832"" Profanity=""http://www.theinsider.org/news/article.asp?id=1425"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3827"" Profanity=""http://www.wtvq.com/servlet/Satellite?c=MGArticle&amp;"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4008"" Profanity=""Icebreaker uk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4007"" Profanity=""Icebreakeruk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""767"" Profanity=""K**t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2097"" Profanity=""k@ffir"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2100"" Profanity=""k@ffirs"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2098"" Profanity=""k@fir"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2099"" Profanity=""k@firs"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2094"" Profanity=""kaffir"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2096"" Profanity=""kaffirs"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2093"" Profanity=""kafir"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2095"" Profanity=""kafirs"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2619"" Profanity=""kafr"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1920"" Profanity=""Khunt"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""955"" Profanity=""kike"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4226"" Profanity=""kitbag.com"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2222"" Profanity=""knob&amp;nbsp;head"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2223"" Profanity=""Knobber"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2613"" Profanity=""knobhead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""6"" Profanity=""Kunt"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""956"" Profanity=""kyke"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2690"" Profanity=""L m f a o"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2692"" Profanity=""L.m.f.a.o"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2691"" Profanity=""L.m.f.a.o."" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2689"" Profanity=""Lmfa0"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2688"" Profanity=""Lmfao"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""776"" Profanity=""mof**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""798"" Profanity=""mof**kers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""33"" Profanity=""mofuccer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""15"" Profanity=""mofucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""55"" Profanity=""mofuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""44"" Profanity=""mofucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""20"" Profanity=""mofukcer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""774"" Profanity=""mohterf**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""792"" Profanity=""mohterf**kers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""775"" Profanity=""mohterf*kcer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""32"" Profanity=""mohterfuccer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""70"" Profanity=""mohterfuccers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""24"" Profanity=""mohterfuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""13"" Profanity=""mohterfucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""53"" Profanity=""mohterfuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""42"" Profanity=""mohterfucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""63"" Profanity=""mohterfucks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""25"" Profanity=""mohterfuk"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""14"" Profanity=""mohterfukcer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""54"" Profanity=""mohterfukcers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""43"" Profanity=""mohterfuking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""64"" Profanity=""mohterfuks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""773"" Profanity=""moterf**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""31"" Profanity=""moterfuccer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""23"" Profanity=""moterfuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""12"" Profanity=""moterfucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""52"" Profanity=""moterfuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""41"" Profanity=""moterfucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""62"" Profanity=""moterfucks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1824"" Profanity=""motha-fucka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""782"" Profanity=""mothaf**k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""777"" Profanity=""mothaf**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""795"" Profanity=""mothaf**kers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""785"" Profanity=""mothaf**king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""799"" Profanity=""mothaf**ks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""34"" Profanity=""mothafuccer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""27"" Profanity=""mothafuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1823"" Profanity=""Mothafucka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""16"" Profanity=""mothafucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""56"" Profanity=""mothafuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""45"" Profanity=""mothafucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""66"" Profanity=""mothafucks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""771"" Profanity=""motherf**ked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""772"" Profanity=""Motherf**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""791"" Profanity=""Motherf**kers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3857"" Profanity=""motherfracking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""30"" Profanity=""Motherfuccer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""69"" Profanity=""Motherfuccers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""22"" Profanity=""Motherfuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""10"" Profanity=""motherfucked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""11"" Profanity=""Motherfucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""51"" Profanity=""Motherfuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""40"" Profanity=""Motherfucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""61"" Profanity=""Motherfucks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""49"" Profanity=""motherfukkker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""780"" Profanity=""mthaf**ka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""37"" Profanity=""mthafucca"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""76"" Profanity=""mthafuccas"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""19"" Profanity=""mthafucka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""59"" Profanity=""mthafuckas"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""21"" Profanity=""mthafukca"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""60"" Profanity=""mthafukcas"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""48"" Profanity=""muth@fucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""783"" Profanity=""muthaf**k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""778"" Profanity=""muthaf**ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""796"" Profanity=""muthaf**kers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""786"" Profanity=""muthaf**king"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""800"" Profanity=""muthaf**ks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""35"" Profanity=""muthafuccer"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""28"" Profanity=""muthafuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""50"" Profanity=""muthafuck@"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4054"" Profanity=""Muthafucka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""17"" Profanity=""muthafucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""57"" Profanity=""muthafuckers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""46"" Profanity=""muthafucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""67"" Profanity=""muthafucks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1917"" Profanity=""Muthafuka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1916"" Profanity=""Muthafukas"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2438"" Profanity=""n0b"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2575"" Profanity=""n0bhead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2587"" Profanity=""Nige&amp;nbsp;Cooke"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3962"" Profanity=""Nigel Cooke"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2588"" Profanity=""Nigel&amp;nbsp;C00k"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2589"" Profanity=""Nigel&amp;nbsp;C00ke"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2590"" Profanity=""Nigel&amp;nbsp;Cook"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2591"" Profanity=""Nigel&amp;nbsp;Cook3"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2592"" Profanity=""Nigel&amp;nbsp;Cooke"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""147"" Profanity=""nigga"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""149"" Profanity=""niggaz"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""146"" Profanity=""Nigger"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""148"" Profanity=""niggers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2437"" Profanity=""nob"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2221"" Profanity=""nob&amp;nbsp;head"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2220"" Profanity=""Nobhead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1667"" Profanity=""p**i"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1664"" Profanity=""p*ki"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1665"" Profanity=""p@ki"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1683"" Profanity=""p@kis"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1666"" Profanity=""pak1"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""154"" Profanity=""paki"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1682"" Profanity=""pakis&#xD;"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1740"" Profanity=""pench0d"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1739"" Profanity=""pench0ds"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1737"" Profanity=""penchod"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1738"" Profanity=""penchods"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2358"" Profanity=""phelching"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1913"" Profanity=""Phuck"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1915"" Profanity=""Phucker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2346"" Profanity=""phuckin"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1914"" Profanity=""Phucking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4160"" Profanity=""Poo stabber"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4162"" Profanity=""Poo stabbers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1923"" Profanity=""Prik"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""762"" Profanity=""raghead"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""764"" Profanity=""ragheads"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2218"" Profanity=""S1ut"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4161"" Profanity=""Shit stabber"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4163"" Profanity=""Shit stabbers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""320"" Profanity=""slut"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""157"" Profanity=""spic"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2460"" Profanity=""t0$$er"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""983"" Profanity=""t0sser"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1764"" Profanity=""t0ssers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""981"" Profanity=""to55er"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1765"" Profanity=""to55ers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""754"" Profanity=""tosser"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1766"" Profanity=""tossers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2216"" Profanity=""tw&amp;nbsp;at"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4077"" Profanity=""tw@"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""121"" Profanity=""tw@t"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""120"" Profanity=""twat"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1716"" Profanity=""twats"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1921"" Profanity=""Twunt"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1926"" Profanity=""twunts"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2662"" Profanity=""w anker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""951"" Profanity=""w*****"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1631"" Profanity=""w******"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""952"" Profanity=""w****r"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""961"" Profanity=""w@nker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""962"" Profanity=""w@nkers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""977"" Profanity=""w0g"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""978"" Profanity=""w0gs"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2663"" Profanity=""wa nker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4164"" Profanity=""Wan k er"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4165"" Profanity=""Wan k ers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2664"" Profanity=""wan ker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""122"" Profanity=""wank"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""127"" Profanity=""wank's"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4053"" Profanity=""Wanka"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2666"" Profanity=""wanke r"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""125"" Profanity=""wanked"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""124"" Profanity=""wanker"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""989"" Profanity=""wankers"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""123"" Profanity=""wanking"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""126"" Profanity=""wanks"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""155"" Profanity=""wog"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3960"" Profanity=""www.mfbb.net"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3952"" Profanity=""www.mfbb.net/"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3954"" Profanity=""www.mfbb.net/?mforum=free"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3958"" Profanity=""www.mfbb.net/free-about1306.html"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3956"" Profanity=""www.mfbb.net/free-forum-8.html"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3959"" Profanity=""www.myfreebulletinboard.com"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3951"" Profanity=""www.myfreebulletinboard.com/"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2219"" Profanity=""Xxxhole"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1505"" Profanity=""y*d"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""158"" Profanity=""yid"" ModClassID=""4"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4017"" Profanity=""Abdul Muneem Patel"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4025"" Profanity=""Abdul Patel"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4010"" Profanity=""Abdula Ahmed Ali"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4021"" Profanity=""Abdula Ali"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4024"" Profanity=""Adam Khatib"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4015"" Profanity=""Adam Osman Khatib"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4014"" Profanity=""Arafat Khan"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""1479"" Profanity=""arse"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3968"" Profanity=""askew"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3967"" Profanity=""aspew"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4027"" Profanity=""Assad"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4018"" Profanity=""Assad Sarwar"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""950"" Profanity=""b******"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""949"" Profanity=""b*****d"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""929"" Profanity=""b****r"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""323"" Profanity=""b1tch"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4066"" Profanity=""barfly"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""318"" Profanity=""bastard"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4168"" Profanity=""Belton"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4125"" Profanity=""Beshenivsky"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""322"" Profanity=""bitch"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4157"" Profanity=""Bomb"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4158"" Profanity=""Bombing"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4105"" Profanity=""Bradley John Murdoch"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4106"" Profanity=""Bradley Murdoch"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""355"" Profanity=""bugger"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""325"" Profanity=""c0ck"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3893"" Profanity=""Celtic Distribution"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3896"" Profanity=""Celtic Music"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3862"" Profanity=""charlote"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3864"" Profanity=""charlote_host"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3863"" Profanity=""charlotte"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3865"" Profanity=""charlotte_host"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""351"" Profanity=""clit"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3895"" Profanity=""CM/Music By Mail"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""324"" Profanity=""cock"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4022"" Profanity=""Cossor"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4011"" Profanity=""Cossor Ali"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""350"" Profanity=""crap"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""347"" Profanity=""cripple"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""331"" Profanity=""d1ck"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""330"" Profanity=""dick"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2573"" Profanity=""dick head"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3697"" Profanity=""ethnics"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2762"" Profanity=""fag"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""343"" Profanity=""fagg0t"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""342"" Profanity=""faggot"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2763"" Profanity=""fags"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4103"" Profanity=""Falconio"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""333"" Profanity=""fanny"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3859"" Profanity=""flange"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2698"" Profanity=""Flyers"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2332"" Profanity=""freakin"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2351"" Profanity=""freaking"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2333"" Profanity=""frick"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""349"" Profanity=""gimp"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3994"" Profanity=""Gina Ford"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3848"" Profanity=""Glaxo"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3847"" Profanity=""GlaxoSmithKline"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2612"" Profanity=""gypsies"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2611"" Profanity=""gypsy"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""346"" Profanity=""h0m0"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""345"" Profanity=""h0mo"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3902"" Profanity=""Hardingham"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3920"" Profanity=""Heather"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3918"" Profanity=""Heather McCartney"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3917"" Profanity=""Heather Mills"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3919"" Profanity=""Heather Mills McCartney"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""344"" Profanity=""homo"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""353"" Profanity=""hun"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""352"" Profanity=""huns"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4019"" Profanity=""Ibrahim Savant"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4104"" Profanity=""Joanne Lees"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4003"" Profanity=""kings of clay"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4002"" Profanity=""kingsofclay"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""327"" Profanity=""kn0b"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""326"" Profanity=""knob"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""354"" Profanity=""kraut"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3853"" Profanity=""Langham"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3985"" Profanity=""Lawrence"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3986"" Profanity=""Lawrence's"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3987"" Profanity=""Lawrences"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4218"" Profanity=""Macca"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4085"" Profanity=""maxine carr"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4209"" Profanity=""McCartney"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4016"" Profanity=""Mehran Hussain"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4167"" Profanity=""Montana"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4217"" Profanity=""Mucca"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2009"" Profanity=""mucher"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""1922"" Profanity=""Munchers"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3710"" Profanity=""nazi"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3711"" Profanity=""nazis"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3854"" Profanity=""Ore"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4102"" Profanity=""Peter Falconio"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""339"" Profanity=""piss"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2011"" Profanity=""poff"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""316"" Profanity=""poof"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""317"" Profanity=""poofter"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4166"" Profanity=""Poska"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""329"" Profanity=""pr1ck"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""328"" Profanity=""prick"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3889"" Profanity=""Proper Ganda "" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3894"" Profanity=""Proper Music People"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3890"" Profanity=""Properganda "" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""1599"" Profanity=""pu$$y"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""332"" Profanity=""pussy"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""341"" Profanity=""queer"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""348"" Profanity=""retard"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4026"" Profanity=""Sarwar"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4028"" Profanity=""Savant"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2224"" Profanity=""Scat"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""1514"" Profanity=""Sh!t"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""963"" Profanity=""sh!te"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""964"" Profanity=""sh!tes"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""337"" Profanity=""sh1t"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""338"" Profanity=""sh1te"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""356"" Profanity=""shag"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""336"" Profanity=""shat"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""319"" Profanity=""slag"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""315"" Profanity=""spastic"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4118"" Profanity=""spliff"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3983"" Profanity=""Stephen Lawrence’s"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3984"" Profanity=""Stephen Lawrences"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3892"" Profanity=""Steve Kersley"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4012"" Profanity=""Tanvir Hussain"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2693"" Profanity=""Tickets available"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""3891"" Profanity=""Tony Engle"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""340"" Profanity=""turd"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4013"" Profanity=""Umar Islam"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4020"" Profanity=""Waheed Zamen"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""321"" Profanity=""whore"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""156"" Profanity=""wop"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""4029"" Profanity=""Zamen"" ModClassID=""4"" Refer=""1"" />
    <P ProfanityID=""2204"" Profanity=""(ock"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1536"" Profanity=""A$$hole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1538"" Profanity=""A$$hole$"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1537"" Profanity=""A$$holes"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1581"" Profanity=""A+*hole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1575"" Profanity=""ar$ehole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1539"" Profanity=""Ar$hole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1540"" Profanity=""Ar$holes"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1710"" Profanity=""ar5h0l3"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1708"" Profanity=""ar5h0le"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1709"" Profanity=""ar5h0les"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2645"" Profanity=""ars3"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1179"" Profanity=""arse"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2644"" Profanity=""arse hole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""995"" Profanity=""arseh0le"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""996"" Profanity=""arseh0les"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""997"" Profanity=""arsehol"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""998"" Profanity=""arsehole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""999"" Profanity=""arseholes"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1000"" Profanity=""arsh0le"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1001"" Profanity=""arshole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1002"" Profanity=""arsholes"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1003"" Profanity=""ashole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2647"" Profanity=""ass h0le"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2646"" Profanity=""ass hole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1004"" Profanity=""assh0le"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1005"" Profanity=""assh0les"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1006"" Profanity=""asshole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1007"" Profanity=""assholes"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1008"" Profanity=""b0ll0cks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1545"" Profanity=""B0llocks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1183"" Profanity=""b1tch"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1184"" Profanity=""bastard"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2192"" Profanity=""batty&amp;nbsp;boi"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2191"" Profanity=""batty&amp;nbsp;boy"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4171"" Profanity=""Beef curtains"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1185"" Profanity=""bitch"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1546"" Profanity=""Boll0cks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1009"" Profanity=""bollocks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1010"" Profanity=""bollox"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1011"" Profanity=""bolocks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1012"" Profanity=""bolox"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1186"" Profanity=""bugger"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1013"" Profanity=""Bukkake"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1547"" Profanity=""Bullsh!t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1238"" Profanity=""Bullshit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2643"" Profanity=""bum hole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2642"" Profanity=""bumh0l3"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2640"" Profanity=""bumh0le"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2641"" Profanity=""bumhol3"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2639"" Profanity=""bumhole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1485"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1014"" Profanity=""C**t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1015"" Profanity=""C**t's"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1016"" Profanity=""C**ts"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1017"" Profanity=""c.u.n.t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1018"" Profanity=""c00n"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1846"" Profanity=""C0cksucka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1847"" Profanity=""C0cksucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1728"" Profanity=""cnut"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1727"" Profanity=""cnuts"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2203"" Profanity=""Co(k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2186"" Profanity=""coc&amp;nbsp;k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1845"" Profanity=""Cocksucka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1844"" Profanity=""Cocksucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1897"" Profanity=""Cok"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1019"" Profanity=""coon"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1190"" Profanity=""crap"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1997"" Profanity=""cu&amp;nbsp;nt"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1998"" Profanity=""cu&amp;nbsp;nts"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1020"" Profanity=""Cunt"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1021"" Profanity=""Cunt's"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1022"" Profanity=""cunting"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1023"" Profanity=""Cunts"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2469"" Profanity=""D**khead"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1024"" Profanity=""darkie"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1025"" Profanity=""darky"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2557"" Profanity=""dick&amp;nbsp;head"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1026"" Profanity=""dickhead"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1027"" Profanity=""dumbfuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1028"" Profanity=""dumbfucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2470"" Profanity=""Dxxkhead"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1645"" Profanity=""effing"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2893"" Profanity=""f u c k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2899"" Profanity=""f u c ked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1592"" Profanity=""f###"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1501"" Profanity=""f##k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1029"" Profanity=""F$cks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2543"" Profanity=""f&amp;nbsp;cked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1535"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2189"" Profanity=""f&amp;nbsp;uck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2553"" Profanity=""f&amp;nbsp;ucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2548"" Profanity=""f&amp;nbsp;ucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1591"" Profanity=""f***"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1543"" Profanity=""F*****"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1544"" Profanity=""F******"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1493"" Profanity=""f*****g"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1030"" Profanity=""f****d"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1031"" Profanity=""f***ed"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1032"" Profanity=""f***ing"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1033"" Profanity=""f**k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1034"" Profanity=""f**ked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1035"" Profanity=""f**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1036"" Profanity=""f**kin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1037"" Profanity=""f**king"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1038"" Profanity=""f**ks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1039"" Profanity=""f*ck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1040"" Profanity=""f*ked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1041"" Profanity=""f*ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1042"" Profanity=""f*ks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1043"" Profanity=""f*uck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1541"" Profanity=""F*uk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1044"" Profanity=""f.u.c.k."" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1896"" Profanity=""f@ck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2890"" Profanity=""f00k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2361"" Profanity=""Fack"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2369"" Profanity=""Fackin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2380"" Profanity=""facking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1194"" Profanity=""fagg0t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1195"" Profanity=""faggot"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1045"" Profanity=""fc*king"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2190"" Profanity=""fck&amp;nbsp;ing"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1839"" Profanity=""fckw1t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1838"" Profanity=""fckwit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1046"" Profanity=""fcuk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1047"" Profanity=""fcuked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1048"" Profanity=""fcuker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1049"" Profanity=""fcukin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1050"" Profanity=""fcuking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1051"" Profanity=""fcuks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2362"" Profanity=""feck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2371"" Profanity=""feckin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2381"" Profanity=""fecking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1052"" Profanity=""felch"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1053"" Profanity=""felched"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2194"" Profanity=""Felching"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1054"" Profanity=""feltch"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1055"" Profanity=""feltcher"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1056"" Profanity=""feltching"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2367"" Profanity=""fook"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2376"" Profanity=""fookin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2387"" Profanity=""fooking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2364"" Profanity=""frick"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2373"" Profanity=""frickin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2383"" Profanity=""fricking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2365"" Profanity=""frig"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2379"" Profanity=""friggin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2385"" Profanity=""frigging"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2374"" Profanity=""frigin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2384"" Profanity=""friging"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2187"" Profanity=""fu&amp;nbsp;ck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2544"" Profanity=""fu&amp;nbsp;cked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2554"" Profanity=""fu&amp;nbsp;cker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2549"" Profanity=""fu&amp;nbsp;cking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2439"" Profanity=""fu(k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1057"" Profanity=""fu*k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1849"" Profanity=""fu@k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1850"" Profanity=""fu@ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1058"" Profanity=""fuc"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2545"" Profanity=""fuc&amp;nbsp;ked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2555"" Profanity=""fuc&amp;nbsp;ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2550"" Profanity=""fuc&amp;nbsp;king"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1059"" Profanity=""fuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2895"" Profanity=""Fùck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1060"" Profanity=""fúck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2889"" Profanity=""Fúçk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2894"" Profanity=""Fûck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2896"" Profanity=""Fück"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2546"" Profanity=""fuck&amp;nbsp;ed"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2551"" Profanity=""fuck&amp;nbsp;ing"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1835"" Profanity=""fuck-wit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2547"" Profanity=""fucke&amp;nbsp;d"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1061"" Profanity=""fucked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1062"" Profanity=""fucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1569"" Profanity=""fuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2552"" Profanity=""fucki&amp;nbsp;ng"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1063"" Profanity=""fuckin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1064"" Profanity=""fucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1065"" Profanity=""fúcking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1066"" Profanity=""fuckk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1067"" Profanity=""fucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2202"" Profanity=""Fuckup"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1837"" Profanity=""fuckw1t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1833"" Profanity=""fuckwit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1841"" Profanity=""fucw1t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1840"" Profanity=""fucwit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2957"" Profanity=""fudge packer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2955"" Profanity=""fudgepacker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1068"" Profanity=""fuk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1069"" Profanity=""fukced"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1070"" Profanity=""fuked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1071"" Profanity=""fuker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1072"" Profanity=""fukin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1073"" Profanity=""fuking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2366"" Profanity=""fukk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1074"" Profanity=""fukked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1075"" Profanity=""fukker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1076"" Profanity=""fukkin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2386"" Profanity=""fukking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1077"" Profanity=""fuks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2001"" Profanity=""Fvck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1848"" Profanity=""Fvck-up"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1851"" Profanity=""Fvckup"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1836"" Profanity=""fvckw1t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1834"" Profanity=""fvckwit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1197"" Profanity=""gimp"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1992"" Profanity=""Gypo"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1993"" Profanity=""Gypos"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1991"" Profanity=""Gyppo"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1994"" Profanity=""Gyppos"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1198"" Profanity=""h0m0"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1199"" Profanity=""h0mo"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1200"" Profanity=""homo"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1078"" Profanity=""K**t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1983"" Profanity=""k@ffir"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1984"" Profanity=""k@ffirs"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1982"" Profanity=""k@fir"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1985"" Profanity=""k@firs"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1986"" Profanity=""Kaf1r"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1987"" Profanity=""Kaff1r"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1979"" Profanity=""Kaffir"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1981"" Profanity=""Kaffirs"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1978"" Profanity=""Kafir"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1980"" Profanity=""Kafirs"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1898"" Profanity=""Khunt"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1079"" Profanity=""kike"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2199"" Profanity=""knob&amp;nbsp;head"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2200"" Profanity=""Knobber"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1080"" Profanity=""Kunt"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1081"" Profanity=""kyke"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2704"" Profanity=""L m f a o"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2706"" Profanity=""L.m.f.a.o"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2705"" Profanity=""L.m.f.a.o."" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2703"" Profanity=""Lmfa0"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2702"" Profanity=""Lmfao"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1082"" Profanity=""mof**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1083"" Profanity=""mof**kers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1084"" Profanity=""mofuccer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1085"" Profanity=""mofucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1086"" Profanity=""mofuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1087"" Profanity=""mofucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1088"" Profanity=""mofukcer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1089"" Profanity=""mohterf**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1090"" Profanity=""mohterf**kers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1091"" Profanity=""mohterf*kcer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1092"" Profanity=""mohterfuccer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1093"" Profanity=""mohterfuccers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1094"" Profanity=""mohterfuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1095"" Profanity=""mohterfucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1096"" Profanity=""mohterfuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1097"" Profanity=""mohterfucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1098"" Profanity=""mohterfucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1099"" Profanity=""mohterfuk"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1100"" Profanity=""mohterfukcer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1101"" Profanity=""mohterfukcers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1102"" Profanity=""mohterfuking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1103"" Profanity=""mohterfuks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1104"" Profanity=""moterf**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1105"" Profanity=""moterfuccer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1106"" Profanity=""moterfuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1107"" Profanity=""moterfucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1108"" Profanity=""moterfuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1109"" Profanity=""moterfucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1110"" Profanity=""moterfucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1843"" Profanity=""motha-fucka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1111"" Profanity=""mothaf**k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1112"" Profanity=""mothaf**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1113"" Profanity=""mothaf**kers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1114"" Profanity=""mothaf**king"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1115"" Profanity=""mothaf**ks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1116"" Profanity=""mothafuccer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1117"" Profanity=""mothafuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1842"" Profanity=""Mothafucka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1118"" Profanity=""mothafucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1119"" Profanity=""mothafuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1120"" Profanity=""mothafucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1121"" Profanity=""mothafucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1122"" Profanity=""motherf**ked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1123"" Profanity=""Motherf**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1124"" Profanity=""Motherf**kers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1125"" Profanity=""Motherfuccer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1126"" Profanity=""Motherfuccers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1127"" Profanity=""Motherfuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1128"" Profanity=""motherfucked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1129"" Profanity=""Motherfucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1130"" Profanity=""Motherfuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1131"" Profanity=""Motherfucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1132"" Profanity=""Motherfucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1133"" Profanity=""motherfukkker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1134"" Profanity=""mthaf**ka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1135"" Profanity=""mthafucca"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1136"" Profanity=""mthafuccas"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1137"" Profanity=""mthafucka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1138"" Profanity=""mthafuckas"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1139"" Profanity=""mthafukca"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1140"" Profanity=""mthafukcas"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1141"" Profanity=""muth@fucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1142"" Profanity=""muthaf**k"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1143"" Profanity=""muthaf**ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1144"" Profanity=""muthaf**kers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1145"" Profanity=""muthaf**king"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1146"" Profanity=""muthaf**ks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1147"" Profanity=""muthafuccer"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1148"" Profanity=""muthafuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1149"" Profanity=""muthafuck@"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4057"" Profanity=""Muthafucka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1150"" Profanity=""muthafucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1151"" Profanity=""muthafuckers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1152"" Profanity=""muthafucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1153"" Profanity=""muthafucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1895"" Profanity=""Muthafuka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1894"" Profanity=""Muthafukas"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2441"" Profanity=""n0b"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1995"" Profanity=""N1gger"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1996"" Profanity=""N1ggers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1154"" Profanity=""nigga"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1155"" Profanity=""niggaz"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1156"" Profanity=""Nigger"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1157"" Profanity=""niggers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2440"" Profanity=""nob"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2198"" Profanity=""nob&amp;nbsp;head"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2197"" Profanity=""Nobhead"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1675"" Profanity=""p**i"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1672"" Profanity=""p*ki"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1673"" Profanity=""p@ki"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1674"" Profanity=""pak1"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1158"" Profanity=""paki"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2389"" Profanity=""phelching"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1891"" Profanity=""Phuck"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1893"" Profanity=""Phucker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2377"" Profanity=""phuckin"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1892"" Profanity=""Phucking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1988"" Profanity=""Phucks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1206"" Profanity=""piss"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4172"" Profanity=""Poo stabber"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4174"" Profanity=""Poo stabbers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1901"" Profanity=""Prik"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1159"" Profanity=""raghead"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1160"" Profanity=""ragheads"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1213"" Profanity=""retard"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2195"" Profanity=""S1ut"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2201"" Profanity=""Scat"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1218"" Profanity=""shag"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1219"" Profanity=""shat"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1220"" Profanity=""shit"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4173"" Profanity=""Shit stabber"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4175"" Profanity=""Shit stabbers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1221"" Profanity=""shite"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1222"" Profanity=""slag"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1162"" Profanity=""spic"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2064"" Profanity=""Sylvestor"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1999"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2000"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2468"" Profanity=""t0$$er"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1779"" Profanity=""t0ssers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1780"" Profanity=""to55ers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1163"" Profanity=""tosser"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1781"" Profanity=""tossers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4137"" Profanity=""towel head"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4138"" Profanity=""towelhead"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1224"" Profanity=""turd"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2193"" Profanity=""tw&amp;nbsp;at"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1164"" Profanity=""tw@t"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1990"" Profanity=""tw@ts"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1165"" Profanity=""twat"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1726"" Profanity=""twats"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1899"" Profanity=""Twunt"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1930"" Profanity=""twunts"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2672"" Profanity=""w anker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1637"" Profanity=""w******"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1226"" Profanity=""w****r"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1166"" Profanity=""w@nker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1167"" Profanity=""w@nkers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1168"" Profanity=""w0g"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1169"" Profanity=""w0gs"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2673"" Profanity=""wa nker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4176"" Profanity=""Wan k er"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4177"" Profanity=""Wan k ers"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2674"" Profanity=""wan ker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1170"" Profanity=""wank"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1171"" Profanity=""wank's"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4056"" Profanity=""Wanka"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2676"" Profanity=""wanke r"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1172"" Profanity=""wanked"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1173"" Profanity=""wanker"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1174"" Profanity=""wanking"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1175"" Profanity=""wanks"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1227"" Profanity=""whore"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1176"" Profanity=""wog"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1177"" Profanity=""wop"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2196"" Profanity=""Xxxhole"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1534"" Profanity=""Y*d"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1178"" Profanity=""yid"" ModClassID=""5"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1180"" Profanity=""b******"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1181"" Profanity=""b*****d"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1182"" Profanity=""b****r"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4180"" Profanity=""Belton"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4126"" Profanity=""Beshenivsky"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4169"" Profanity=""Bomb"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4170"" Profanity=""Bombing"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1187"" Profanity=""c0ck"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1188"" Profanity=""clit"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1189"" Profanity=""cock"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1191"" Profanity=""cripple"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1192"" Profanity=""d1ck"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1193"" Profanity=""dick"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1196"" Profanity=""fanny"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""3926"" Profanity=""Heather"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1201"" Profanity=""hun"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1202"" Profanity=""huns"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1203"" Profanity=""kn0b"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1204"" Profanity=""knob"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1205"" Profanity=""kraut"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4086"" Profanity=""maxine carr"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4179"" Profanity=""Montana"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1900"" Profanity=""Munchers"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1207"" Profanity=""poof"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1208"" Profanity=""poofter"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4178"" Profanity=""Poska"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1209"" Profanity=""pr1ck"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1210"" Profanity=""prick"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1597"" Profanity=""pu$$y"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1211"" Profanity=""pussy"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1212"" Profanity=""queer"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1542"" Profanity=""Sh!t"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1214"" Profanity=""sh!te"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1215"" Profanity=""sh!tes"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1216"" Profanity=""sh1t"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1217"" Profanity=""sh1te"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1223"" Profanity=""spastic"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""4119"" Profanity=""spliff"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""1225"" Profanity=""w*****"" ModClassID=""5"" Refer=""1"" />
    <P ProfanityID=""2181"" Profanity=""(ock"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1550"" Profanity=""A$$hole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1552"" Profanity=""A$$hole$"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1551"" Profanity=""A$$holes"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1585"" Profanity=""A+*hole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1577"" Profanity=""ar$ehole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1553"" Profanity=""Ar$hole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1554"" Profanity=""Ar$holes"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1713"" Profanity=""ar5h0l3"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1711"" Profanity=""ar5h0le"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1712"" Profanity=""ar5h0les"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2654"" Profanity=""ars3"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2653"" Profanity=""arse hole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1247"" Profanity=""arseh0le"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1248"" Profanity=""arseh0les"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1249"" Profanity=""arsehol"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1250"" Profanity=""arsehole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1251"" Profanity=""arseholes"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""3488"" Profanity=""arsewipe"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1252"" Profanity=""arsh0le"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1253"" Profanity=""arshole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1254"" Profanity=""arsholes"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1255"" Profanity=""ashole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2656"" Profanity=""ass h0le"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2655"" Profanity=""ass hole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1256"" Profanity=""assh0le"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1257"" Profanity=""assh0les"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1258"" Profanity=""asshole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1259"" Profanity=""assholes"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1260"" Profanity=""b0ll0cks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1559"" Profanity=""B0llocks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2169"" Profanity=""batty&amp;nbsp;boi"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2168"" Profanity=""batty&amp;nbsp;boy"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4183"" Profanity=""Beef curtains"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1560"" Profanity=""Boll0cks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1261"" Profanity=""bollocks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1262"" Profanity=""bollox"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1263"" Profanity=""bolocks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1264"" Profanity=""bolox"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1265"" Profanity=""Bukkake"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1561"" Profanity=""Bullsh!t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2652"" Profanity=""bum hole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2651"" Profanity=""bumh0l3"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2649"" Profanity=""bumh0le"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2650"" Profanity=""bumhol3"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2648"" Profanity=""bumhole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1487"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1266"" Profanity=""C**t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1267"" Profanity=""C**t's"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1268"" Profanity=""C**ts"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1269"" Profanity=""c.u.n.t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1270"" Profanity=""c00n"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1865"" Profanity=""C0cksucka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1866"" Profanity=""C0cksucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2068"" Profanity=""Clohosy"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1724"" Profanity=""cnut"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1723"" Profanity=""cnuts"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2180"" Profanity=""Co(k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2163"" Profanity=""coc&amp;nbsp;k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1864"" Profanity=""Cocksucka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1863"" Profanity=""Cocksucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1908"" Profanity=""Cok"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1271"" Profanity=""coon"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1951"" Profanity=""cu&amp;nbsp;nt"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1952"" Profanity=""cu&amp;nbsp;nts"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1272"" Profanity=""Cunt"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1273"" Profanity=""Cunt's"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1274"" Profanity=""cunting"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1275"" Profanity=""Cunts"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2477"" Profanity=""D**khead"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1276"" Profanity=""darkie"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1277"" Profanity=""darky"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2523"" Profanity=""dick&amp;nbsp;head"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1278"" Profanity=""dickhead"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1279"" Profanity=""dumbfuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1280"" Profanity=""dumbfucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2478"" Profanity=""Dxxkhead"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1647"" Profanity=""effing"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4082"" Profanity=""excoboard.com/exco/index.php?boardid=19215"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2792"" Profanity=""F o a d"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2885"" Profanity=""f u c k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2897"" Profanity=""f u c ked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1594"" Profanity=""f###"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1503"" Profanity=""f##k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1281"" Profanity=""F$cks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2509"" Profanity=""f&amp;nbsp;cked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1549"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2166"" Profanity=""f&amp;nbsp;uck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2519"" Profanity=""f&amp;nbsp;ucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2514"" Profanity=""f&amp;nbsp;ucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1593"" Profanity=""f***"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1557"" Profanity=""F*****"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1558"" Profanity=""F******"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1495"" Profanity=""f*****g"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1282"" Profanity=""f****d"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1283"" Profanity=""f***ed"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1284"" Profanity=""f***ing"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1285"" Profanity=""f**k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1286"" Profanity=""f**ked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1287"" Profanity=""f**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1288"" Profanity=""f**kin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1289"" Profanity=""f**king"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1290"" Profanity=""f**ks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1291"" Profanity=""f*ck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1292"" Profanity=""f*ked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1293"" Profanity=""f*ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1294"" Profanity=""f*ks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1295"" Profanity=""f*uck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1555"" Profanity=""F*uk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2791"" Profanity=""F-o-a-d"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2789"" Profanity=""F.O.A.D"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2790"" Profanity=""F.O.A.D."" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1296"" Profanity=""f.u.c.k."" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1907"" Profanity=""f@ck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2882"" Profanity=""f00k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2392"" Profanity=""Fack"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2400"" Profanity=""Fackin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2411"" Profanity=""facking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1297"" Profanity=""fc*king"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4074"" Profanity=""fck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2167"" Profanity=""fck&amp;nbsp;ing"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4075"" Profanity=""fcks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1858"" Profanity=""fckw1t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1857"" Profanity=""fckwit"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1298"" Profanity=""fcuk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1299"" Profanity=""fcuked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1300"" Profanity=""fcuker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1301"" Profanity=""fcukin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1302"" Profanity=""fcuking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1303"" Profanity=""fcuks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2393"" Profanity=""feck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2402"" Profanity=""feckin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2412"" Profanity=""fecking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1304"" Profanity=""felch"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1305"" Profanity=""felched"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2171"" Profanity=""Felching"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1306"" Profanity=""feltch"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1307"" Profanity=""feltcher"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1308"" Profanity=""feltching"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2788"" Profanity=""FOAD"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2398"" Profanity=""fook"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2407"" Profanity=""fookin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2418"" Profanity=""fooking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2395"" Profanity=""frick"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2404"" Profanity=""frickin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2414"" Profanity=""fricking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2396"" Profanity=""frig"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2410"" Profanity=""friggin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2416"" Profanity=""frigging"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2405"" Profanity=""frigin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2415"" Profanity=""friging"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2164"" Profanity=""fu&amp;nbsp;ck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2510"" Profanity=""fu&amp;nbsp;cked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2520"" Profanity=""fu&amp;nbsp;cker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2515"" Profanity=""fu&amp;nbsp;cking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2442"" Profanity=""fu(k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1309"" Profanity=""fu*k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1868"" Profanity=""fu@k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1869"" Profanity=""fu@ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1310"" Profanity=""fuc"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2511"" Profanity=""fuc&amp;nbsp;ked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2521"" Profanity=""fuc&amp;nbsp;ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2516"" Profanity=""fuc&amp;nbsp;king"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1311"" Profanity=""fuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2887"" Profanity=""Fùck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1312"" Profanity=""fúck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2881"" Profanity=""Fúçk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2886"" Profanity=""Fûck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2888"" Profanity=""Fück"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2512"" Profanity=""fuck&amp;nbsp;ed"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2517"" Profanity=""fuck&amp;nbsp;ing"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1854"" Profanity=""fuck-wit"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2513"" Profanity=""fucke&amp;nbsp;d"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1313"" Profanity=""fucked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1314"" Profanity=""fucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1562"" Profanity=""fuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2518"" Profanity=""fucki&amp;nbsp;ng"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1315"" Profanity=""fuckin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1316"" Profanity=""fucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1317"" Profanity=""fúcking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1318"" Profanity=""fuckk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1319"" Profanity=""fucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2179"" Profanity=""Fuckup"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1856"" Profanity=""fuckw1t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1852"" Profanity=""fuckwit"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1860"" Profanity=""fucw1t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1859"" Profanity=""fucwit"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2961"" Profanity=""fudge packer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2959"" Profanity=""fudgepacker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1320"" Profanity=""fuk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1321"" Profanity=""fukced"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1322"" Profanity=""fuked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1323"" Profanity=""fuker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1324"" Profanity=""fukin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1325"" Profanity=""fuking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2397"" Profanity=""fukk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1326"" Profanity=""fukked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1327"" Profanity=""fukker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1328"" Profanity=""fukkin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2417"" Profanity=""fukking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1329"" Profanity=""fuks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2005"" Profanity=""fvck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1867"" Profanity=""Fvck-up"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1870"" Profanity=""Fvckup"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1855"" Profanity=""fvckw1t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1853"" Profanity=""fvckwit"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1946"" Profanity=""Gypo"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1947"" Profanity=""Gypos"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1945"" Profanity=""Gyppo"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1948"" Profanity=""Gyppos"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4064"" Profanity=""http://excoboard.com/exco/index.php?boardid=19215"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1330"" Profanity=""K**t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1937"" Profanity=""k@ffir"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1938"" Profanity=""k@ffirs"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1936"" Profanity=""k@fir"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1939"" Profanity=""k@firs"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1940"" Profanity=""Kaf1r"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1941"" Profanity=""Kaff1r"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1933"" Profanity=""Kaffir"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1935"" Profanity=""Kaffirs"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1932"" Profanity=""Kafir"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1934"" Profanity=""Kafirs"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1909"" Profanity=""Khunt"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1331"" Profanity=""kike"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2176"" Profanity=""knob&amp;nbsp;head"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2177"" Profanity=""Knobber"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1332"" Profanity=""Kunt"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1333"" Profanity=""kyke"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2696"" Profanity=""L m f a o"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2699"" Profanity=""L.m.f.a.o"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2697"" Profanity=""L.m.f.a.o."" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2695"" Profanity=""Lmfa0"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2694"" Profanity=""Lmfao"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1334"" Profanity=""mof**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1335"" Profanity=""mof**kers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1336"" Profanity=""mofuccer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1337"" Profanity=""mofucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1338"" Profanity=""mofuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1339"" Profanity=""mofucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1340"" Profanity=""mofukcer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1341"" Profanity=""mohterf**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1342"" Profanity=""mohterf**kers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1343"" Profanity=""mohterf*kcer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1344"" Profanity=""mohterfuccer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1345"" Profanity=""mohterfuccers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1346"" Profanity=""mohterfuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1347"" Profanity=""mohterfucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1348"" Profanity=""mohterfuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1349"" Profanity=""mohterfucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1350"" Profanity=""mohterfucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1351"" Profanity=""mohterfuk"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1352"" Profanity=""mohterfukcer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1353"" Profanity=""mohterfukcers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1354"" Profanity=""mohterfuking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1355"" Profanity=""mohterfuks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1356"" Profanity=""moterf**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1357"" Profanity=""moterfuccer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1358"" Profanity=""moterfuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1359"" Profanity=""moterfucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1360"" Profanity=""moterfuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1361"" Profanity=""moterfucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1362"" Profanity=""moterfucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1862"" Profanity=""motha-fucka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1363"" Profanity=""mothaf**k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1364"" Profanity=""mothaf**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1365"" Profanity=""mothaf**kers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1366"" Profanity=""mothaf**king"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1367"" Profanity=""mothaf**ks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1368"" Profanity=""mothafuccer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1369"" Profanity=""mothafuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1861"" Profanity=""Mothafucka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1370"" Profanity=""mothafucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1371"" Profanity=""mothafuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1372"" Profanity=""mothafucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1373"" Profanity=""mothafucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1374"" Profanity=""motherf**ked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1375"" Profanity=""Motherf**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1376"" Profanity=""Motherf**kers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1377"" Profanity=""Motherfuccer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1378"" Profanity=""Motherfuccers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1379"" Profanity=""Motherfuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1380"" Profanity=""motherfucked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1381"" Profanity=""Motherfucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1382"" Profanity=""Motherfuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1383"" Profanity=""Motherfucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1384"" Profanity=""Motherfucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1385"" Profanity=""motherfukkker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1386"" Profanity=""mthaf**ka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1387"" Profanity=""mthafucca"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1388"" Profanity=""mthafuccas"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1389"" Profanity=""mthafucka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1390"" Profanity=""mthafuckas"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1391"" Profanity=""mthafukca"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1392"" Profanity=""mthafukcas"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1393"" Profanity=""muth@fucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1394"" Profanity=""muthaf**k"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1395"" Profanity=""muthaf**ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1396"" Profanity=""muthaf**kers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1397"" Profanity=""muthaf**king"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1398"" Profanity=""muthaf**ks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1399"" Profanity=""muthafuccer"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1400"" Profanity=""muthafuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1401"" Profanity=""muthafuck@"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4060"" Profanity=""Muthafucka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1402"" Profanity=""muthafucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1403"" Profanity=""muthafuckers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1404"" Profanity=""muthafucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1405"" Profanity=""muthafucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1906"" Profanity=""Muthafuka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1905"" Profanity=""Muthafukas"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2444"" Profanity=""n0b"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1949"" Profanity=""N1gger"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1950"" Profanity=""N1ggers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1406"" Profanity=""nigga"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1407"" Profanity=""niggaz"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1408"" Profanity=""Nigger"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1409"" Profanity=""niggers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2443"" Profanity=""nob"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2175"" Profanity=""nob&amp;nbsp;head"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2174"" Profanity=""Nobhead"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1679"" Profanity=""p**i"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1676"" Profanity=""p*ki"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1677"" Profanity=""p@ki"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1678"" Profanity=""pak1"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1410"" Profanity=""paki"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2420"" Profanity=""phelching"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1902"" Profanity=""Phuck"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1904"" Profanity=""Phucker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2408"" Profanity=""phuckin"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1903"" Profanity=""Phucking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1942"" Profanity=""Phucks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4184"" Profanity=""Poo stabber"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4186"" Profanity=""Poo stabbers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1912"" Profanity=""Prik"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1411"" Profanity=""raghead"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1412"" Profanity=""ragheads"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2172"" Profanity=""S1ut"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4185"" Profanity=""Shit stabber"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4187"" Profanity=""Shit stabbers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1413"" Profanity=""slut"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1414"" Profanity=""spic"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1953"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1954"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2476"" Profanity=""t0$$er"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1776"" Profanity=""t0ssers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1777"" Profanity=""to55ers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1415"" Profanity=""tosser"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1778"" Profanity=""tossers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4139"" Profanity=""towel head"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4140"" Profanity=""towelhead"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2170"" Profanity=""tw&amp;nbsp;at"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1416"" Profanity=""tw@t"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1944"" Profanity=""tw@ts"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1417"" Profanity=""twat"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1722"" Profanity=""twats"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1910"" Profanity=""Twunt"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1928"" Profanity=""twunts"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2667"" Profanity=""w anker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1635"" Profanity=""w******"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1418"" Profanity=""w@nker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1419"" Profanity=""w@nkers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1420"" Profanity=""w0g"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1421"" Profanity=""w0gs"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2668"" Profanity=""wa nker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4188"" Profanity=""Wan k er"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4189"" Profanity=""Wan k ers"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2669"" Profanity=""wan ker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1422"" Profanity=""wank"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1423"" Profanity=""wank's"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4059"" Profanity=""Wanka"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2671"" Profanity=""wanke r"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1424"" Profanity=""wanked"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1425"" Profanity=""wanker"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1426"" Profanity=""wanking"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1427"" Profanity=""wanks"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1428"" Profanity=""wog"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1429"" Profanity=""wop"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2173"" Profanity=""Xxxhole"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1548"" Profanity=""Y*d"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1430"" Profanity=""yid"" ModClassID=""6"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""1431"" Profanity=""arse"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1432"" Profanity=""b******"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1433"" Profanity=""b*****d"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1434"" Profanity=""b****r"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1435"" Profanity=""b1tch"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1436"" Profanity=""bastard"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4192"" Profanity=""Belton"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4127"" Profanity=""Beshenivsky"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1437"" Profanity=""bitch"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4181"" Profanity=""Bomb"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4182"" Profanity=""Bombing"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4100"" Profanity=""Bradley John Murdoch"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4101"" Profanity=""Bradley Murdoch"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1438"" Profanity=""bugger"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1439"" Profanity=""c0ck"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1440"" Profanity=""clit"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1441"" Profanity=""cock"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1443"" Profanity=""d1ck"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1444"" Profanity=""dick"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2764"" Profanity=""fag"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1445"" Profanity=""fagg0t"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1446"" Profanity=""faggot"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2765"" Profanity=""fags"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4098"" Profanity=""Falconio"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1447"" Profanity=""fanny"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2701"" Profanity=""Flyers"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2394"" Profanity=""freakin"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2413"" Profanity=""freaking"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1448"" Profanity=""gimp"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2786"" Profanity=""Grunwick"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1449"" Profanity=""h0m0"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1450"" Profanity=""h0mo"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3903"" Profanity=""Hardingham"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3932"" Profanity=""Heather"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3930"" Profanity=""Heather McCartney"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3929"" Profanity=""Heather Mills"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3931"" Profanity=""Heather Mills McCartney"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1451"" Profanity=""homo"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1452"" Profanity=""hun"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1453"" Profanity=""huns"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4099"" Profanity=""Joanne Lees"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1454"" Profanity=""kn0b"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1455"" Profanity=""knob"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1456"" Profanity=""kraut"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3990"" Profanity=""Lawrence"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3991"" Profanity=""Lawrence's"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3992"" Profanity=""Lawrences"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4216"" Profanity=""Macca"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4087"" Profanity=""maxine carr"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4211"" Profanity=""McCartney"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4191"" Profanity=""Montana"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4215"" Profanity=""Mucca"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1911"" Profanity=""Munchers"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4097"" Profanity=""Peter Falconio"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1457"" Profanity=""piss"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1458"" Profanity=""poof"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1459"" Profanity=""poofter"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4190"" Profanity=""Poska"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1460"" Profanity=""pr1ck"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1461"" Profanity=""prick"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1595"" Profanity=""pu$$y"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1462"" Profanity=""pussy"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1463"" Profanity=""queer"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1464"" Profanity=""retard"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2178"" Profanity=""Scat"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1556"" Profanity=""Sh!t"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1465"" Profanity=""sh!te"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1466"" Profanity=""sh!tes"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1467"" Profanity=""sh1t"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1468"" Profanity=""sh1te"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1469"" Profanity=""shag"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1470"" Profanity=""shat"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1471"" Profanity=""shit"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1472"" Profanity=""shite"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1473"" Profanity=""slag"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1474"" Profanity=""spastic"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4120"" Profanity=""spliff"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3988"" Profanity=""Stephen Lawrence’s"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""3989"" Profanity=""Stephen Lawrences"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""2700"" Profanity=""Tickets available"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1475"" Profanity=""turd"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1476"" Profanity=""w*****"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1477"" Profanity=""w****r"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""1478"" Profanity=""whore"" ModClassID=""6"" Refer=""1"" />
    <P ProfanityID=""4195"" Profanity=""Beef curtains"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4196"" Profanity=""Poo stabber"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4198"" Profanity=""Poo stabbers"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4197"" Profanity=""Shit stabber"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4199"" Profanity=""Shit stabbers"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4200"" Profanity=""Wan k er"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""4201"" Profanity=""Wan k ers"" ModClassID=""7"" Refer=""0"" ForumID=""1"" />
    <P ProfanityID=""2967"" Profanity=""(ock"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2968"" Profanity=""A$$hole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2969"" Profanity=""A$$hole$"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2970"" Profanity=""A$$holes"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2971"" Profanity=""A+*hole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2972"" Profanity=""ar$ehole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2973"" Profanity=""Ar$hole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2974"" Profanity=""Ar$holes"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2975"" Profanity=""ar5h0le"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2976"" Profanity=""ar5h0les"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2977"" Profanity=""ars3"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2978"" Profanity=""arse"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2979"" Profanity=""arse hole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2980"" Profanity=""arseh0le"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2981"" Profanity=""arseh0les"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2982"" Profanity=""arsehol"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2983"" Profanity=""arsehole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2984"" Profanity=""arseholes"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2985"" Profanity=""arsh0le"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2986"" Profanity=""arshole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2987"" Profanity=""arsholes"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2988"" Profanity=""ashole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2989"" Profanity=""ass h0le"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2990"" Profanity=""ass hole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2991"" Profanity=""assh0le"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2992"" Profanity=""assh0les"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2993"" Profanity=""asshole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2994"" Profanity=""assholes"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2995"" Profanity=""b****r"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2996"" Profanity=""b00tha"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2997"" Profanity=""b00thas"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2998"" Profanity=""b0ll0cks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""2999"" Profanity=""B0llocks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3000"" Profanity=""b1tch"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3001"" Profanity=""bastard"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3002"" Profanity=""batty&amp;nbsp;boi"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3003"" Profanity=""batty&amp;nbsp;boy"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4204"" Profanity=""Belton"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4128"" Profanity=""Beshenivsky"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3004"" Profanity=""bitch"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3005"" Profanity=""bo****ks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3006"" Profanity=""Boll0cks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3007"" Profanity=""bollocks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3008"" Profanity=""bollox"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3009"" Profanity=""bolocks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3010"" Profanity=""bolox"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4193"" Profanity=""Bomb"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4194"" Profanity=""Bombing"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3011"" Profanity=""bootha"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3012"" Profanity=""boothas"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4115"" Profanity=""Bradley John Murdoch"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4116"" Profanity=""Bradley Murdoch"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3013"" Profanity=""bugger"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3014"" Profanity=""Bukkake"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3015"" Profanity=""Bullsh!t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3016"" Profanity=""bum bandit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3017"" Profanity=""bum hole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3018"" Profanity=""bum-bandit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3019"" Profanity=""bumbandit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3020"" Profanity=""bumh0l3"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3021"" Profanity=""bumh0le"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3022"" Profanity=""bumhol3"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3023"" Profanity=""bumhole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3024"" Profanity=""C&amp;nbsp;u&amp;nbsp;n&amp;nbsp;t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3025"" Profanity=""C**t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3026"" Profanity=""C**t's"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3027"" Profanity=""C**ts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3028"" Profanity=""c.u.n.t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3029"" Profanity=""c00n"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3030"" Profanity=""c0ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3031"" Profanity=""C0cksucka"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3032"" Profanity=""C0cksucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3033"" Profanity=""clit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3034"" Profanity=""cnut"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3035"" Profanity=""cnuts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3036"" Profanity=""Co(k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3037"" Profanity=""coc&amp;nbsp;k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3038"" Profanity=""cock"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3039"" Profanity=""Cocksucka"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3040"" Profanity=""Cocksucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3041"" Profanity=""Cok"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3042"" Profanity=""coon"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3043"" Profanity=""cripple"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3044"" Profanity=""cu&amp;nbsp;nt"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3045"" Profanity=""cu&amp;nbsp;nts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3046"" Profanity=""Cunt"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3047"" Profanity=""Cunt's"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3048"" Profanity=""cunting"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3049"" Profanity=""Cunts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3050"" Profanity=""cvnt"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3051"" Profanity=""cvnts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3052"" Profanity=""D**khead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3053"" Profanity=""d1ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3054"" Profanity=""darkie"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3055"" Profanity=""darky"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3056"" Profanity=""dick"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3057"" Profanity=""dick&amp;nbsp;head"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3058"" Profanity=""dickhead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3059"" Profanity=""door price"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3060"" Profanity=""dumbfuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3061"" Profanity=""dumbfucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3062"" Profanity=""Dxxkhead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3063"" Profanity=""effing"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3064"" Profanity=""F o a d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3065"" Profanity=""f u c k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3066"" Profanity=""f u c ked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3067"" Profanity=""f###"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3068"" Profanity=""f##k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3069"" Profanity=""F$cks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3070"" Profanity=""f&amp;nbsp;cked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3071"" Profanity=""f&amp;nbsp;u&amp;nbsp;c&amp;nbsp;k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3072"" Profanity=""f&amp;nbsp;uck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3073"" Profanity=""f&amp;nbsp;ucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3074"" Profanity=""f&amp;nbsp;ucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3075"" Profanity=""f***"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3076"" Profanity=""F*****"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3077"" Profanity=""F******"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3078"" Profanity=""f*****g"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3079"" Profanity=""f****d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3080"" Profanity=""f***ed"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3081"" Profanity=""f***in"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3082"" Profanity=""f***ing"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3083"" Profanity=""f**k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3084"" Profanity=""f**ked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3085"" Profanity=""f**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3086"" Profanity=""f**kin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3087"" Profanity=""f**king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3088"" Profanity=""f**ks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3089"" Profanity=""f*ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3090"" Profanity=""f*ked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3091"" Profanity=""f*ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3092"" Profanity=""f*ks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3093"" Profanity=""f*uck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3094"" Profanity=""F*uk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3095"" Profanity=""F-o-a-d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3096"" Profanity=""F.O.A.D"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3097"" Profanity=""F.O.A.D."" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3098"" Profanity=""f.u.c.k."" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3099"" Profanity=""f@ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3100"" Profanity=""f@g"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3101"" Profanity=""f@gs"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3102"" Profanity=""f^^k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3103"" Profanity=""f^^ked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3104"" Profanity=""f^^ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3105"" Profanity=""f^^king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3106"" Profanity=""f^ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3107"" Profanity=""f^cker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3108"" Profanity=""f^cking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3109"" Profanity=""f00k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3110"" Profanity=""Fack"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3111"" Profanity=""Fackin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3112"" Profanity=""facking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3113"" Profanity=""fag"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3114"" Profanity=""fagg0t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3115"" Profanity=""faggot"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3116"" Profanity=""fags"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4113"" Profanity=""Falconio"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3117"" Profanity=""fanny"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3118"" Profanity=""fc*king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3119"" Profanity=""fck&amp;nbsp;ing"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3120"" Profanity=""fck1ng"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3121"" Profanity=""fcking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3122"" Profanity=""fckw1t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3123"" Profanity=""fckwit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3124"" Profanity=""fcuk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3125"" Profanity=""fcuked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3126"" Profanity=""fcuker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3127"" Profanity=""fcukin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3128"" Profanity=""fcuking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3129"" Profanity=""fcuks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3130"" Profanity=""feck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3131"" Profanity=""feckin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3132"" Profanity=""fecking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3133"" Profanity=""felch"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3134"" Profanity=""felched"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3135"" Profanity=""Felching"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3136"" Profanity=""feltch"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3137"" Profanity=""feltcher"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3138"" Profanity=""feltching"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3139"" Profanity=""Flyers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3140"" Profanity=""FOAD"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3141"" Profanity=""fook"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3142"" Profanity=""fookin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3143"" Profanity=""fooking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3144"" Profanity=""freakin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3145"" Profanity=""freaking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3146"" Profanity=""free ipod"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3147"" Profanity=""frick"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3148"" Profanity=""frickin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3149"" Profanity=""fricking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3150"" Profanity=""frig"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3151"" Profanity=""friggin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3152"" Profanity=""frigging"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3153"" Profanity=""frigin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3154"" Profanity=""friging"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3155"" Profanity=""fu&amp;nbsp;ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3156"" Profanity=""fu&amp;nbsp;cked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3157"" Profanity=""fu&amp;nbsp;cker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3158"" Profanity=""fu&amp;nbsp;cking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3159"" Profanity=""fu(k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3160"" Profanity=""fu*k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3161"" Profanity=""fu@k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3162"" Profanity=""fu@ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3163"" Profanity=""fu^k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3164"" Profanity=""fu^ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3165"" Profanity=""fu^king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3166"" Profanity=""fuc"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3167"" Profanity=""fuc&amp;nbsp;ked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3168"" Profanity=""fuc&amp;nbsp;ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3169"" Profanity=""fuc&amp;nbsp;king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3170"" Profanity=""fuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3171"" Profanity=""Fùck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3172"" Profanity=""fúck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3173"" Profanity=""Fúçk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3174"" Profanity=""Fûck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3175"" Profanity=""Fück"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3176"" Profanity=""fuck&amp;nbsp;ed"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3177"" Profanity=""fuck&amp;nbsp;ing"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3178"" Profanity=""fuck-wit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3179"" Profanity=""fucke&amp;nbsp;d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3180"" Profanity=""fucked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3181"" Profanity=""fucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3182"" Profanity=""fuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3183"" Profanity=""fucki&amp;nbsp;ng"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3184"" Profanity=""fuckin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3185"" Profanity=""fucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3186"" Profanity=""fúcking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3187"" Profanity=""fuckk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3188"" Profanity=""fucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3189"" Profanity=""Fuckup"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3190"" Profanity=""fuckw1t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3191"" Profanity=""fuckwit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3192"" Profanity=""fucw1t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3193"" Profanity=""fucwit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3194"" Profanity=""fudge packer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3195"" Profanity=""fudgepacker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3196"" Profanity=""fuk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3197"" Profanity=""fukced"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3198"" Profanity=""fuked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3199"" Profanity=""fuker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3200"" Profanity=""fukin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3201"" Profanity=""fuking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3202"" Profanity=""fukk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3203"" Profanity=""fukked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3204"" Profanity=""fukker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3205"" Profanity=""fukkin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3206"" Profanity=""fukking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3207"" Profanity=""fuks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3208"" Profanity=""fvck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3209"" Profanity=""Fvck-up"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3210"" Profanity=""Fvckup"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3211"" Profanity=""fvckw1t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3212"" Profanity=""fvckwit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3213"" Profanity=""gimp"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3214"" Profanity=""Gypo"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3215"" Profanity=""Gypos"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3216"" Profanity=""Gyppo"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3217"" Profanity=""Gyppos"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3218"" Profanity=""gypsies"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3219"" Profanity=""gypsy"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3220"" Profanity=""h0m0"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3221"" Profanity=""h0mo"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3222"" Profanity=""homo"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3223"" Profanity=""http://jgg.pollhost.com/"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3224"" Profanity=""http://www.ogrish.com/"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3225"" Profanity=""http://www.ogrish.com/archives/2006/march/ogrish-d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3226"" Profanity=""http://www.youtube.com/watch?v=LJhpBRgZScI&amp;search="" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3227"" Profanity=""http://www.youtube.com/watch?v=w7DkSnhKkSk&amp;search="" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3228"" Profanity=""hun"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3229"" Profanity=""huns"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4114"" Profanity=""Joanne Lees"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3230"" Profanity=""K**t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3231"" Profanity=""k@ffir"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3232"" Profanity=""k@ffirs"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3233"" Profanity=""k@fir"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3234"" Profanity=""k@firs"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3235"" Profanity=""Kaf1r"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3236"" Profanity=""Kaff1r"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3237"" Profanity=""Kaffir"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3238"" Profanity=""Kaffirs"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3239"" Profanity=""Kafir"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3240"" Profanity=""Kafirs"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3241"" Profanity=""kafr"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3242"" Profanity=""Khunt"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3243"" Profanity=""kike"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3244"" Profanity=""kn0b"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3245"" Profanity=""knob"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3246"" Profanity=""knob&amp;nbsp;head"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3247"" Profanity=""Knobber"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3248"" Profanity=""knobhead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3249"" Profanity=""kraut"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3250"" Profanity=""Kunt"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3251"" Profanity=""kyke"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3252"" Profanity=""L m f a o"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3253"" Profanity=""L.m.f.a.o"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3254"" Profanity=""L.m.f.a.o."" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3255"" Profanity=""Lmfa0"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3256"" Profanity=""Lmfao"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3257"" Profanity=""M1nge"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4088"" Profanity=""maxine carr"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3258"" Profanity=""Minge"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3259"" Profanity=""mof**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3260"" Profanity=""mof**kers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3261"" Profanity=""mofuccer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3262"" Profanity=""mofucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3263"" Profanity=""mofuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3264"" Profanity=""mofucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3265"" Profanity=""mofukcer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3266"" Profanity=""mohterf**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3267"" Profanity=""mohterf**kers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3268"" Profanity=""mohterf*kcer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3269"" Profanity=""mohterfuccer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3270"" Profanity=""mohterfuccers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3271"" Profanity=""mohterfuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3272"" Profanity=""mohterfucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3273"" Profanity=""mohterfuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3274"" Profanity=""mohterfucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3275"" Profanity=""mohterfucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3276"" Profanity=""mohterfuk"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3277"" Profanity=""mohterfukcer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3278"" Profanity=""mohterfukcers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3279"" Profanity=""mohterfuking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3280"" Profanity=""mohterfuks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4203"" Profanity=""Montana"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3281"" Profanity=""moterf**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3282"" Profanity=""moterfuccer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3283"" Profanity=""moterfuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3284"" Profanity=""moterfucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3285"" Profanity=""moterfuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3286"" Profanity=""moterfucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3287"" Profanity=""moterfucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3288"" Profanity=""motha-fucka"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3289"" Profanity=""mothaf**k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3290"" Profanity=""mothaf**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3291"" Profanity=""mothaf**kers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3292"" Profanity=""mothaf**king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3293"" Profanity=""mothaf**ks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3294"" Profanity=""mothafuccer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3295"" Profanity=""mothafuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3296"" Profanity=""Mothafucka"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3297"" Profanity=""mothafucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3298"" Profanity=""mothafuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3299"" Profanity=""mothafucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3300"" Profanity=""mothafucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3301"" Profanity=""motherf**ked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3302"" Profanity=""Motherf**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3303"" Profanity=""Motherf**kers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3304"" Profanity=""Motherfuccer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3305"" Profanity=""Motherfuccers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3306"" Profanity=""Motherfuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3307"" Profanity=""motherfucked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3308"" Profanity=""Motherfucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3309"" Profanity=""Motherfuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3310"" Profanity=""Motherfucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3311"" Profanity=""Motherfucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3312"" Profanity=""motherfukkker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3313"" Profanity=""mthaf**ka"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3314"" Profanity=""mthafucca"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3315"" Profanity=""mthafuccas"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3316"" Profanity=""mthafucka"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3317"" Profanity=""mthafuckas"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3318"" Profanity=""mthafukca"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3319"" Profanity=""mthafukcas"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3320"" Profanity=""muncher"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3321"" Profanity=""Munchers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3322"" Profanity=""muth@fucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3323"" Profanity=""muthaf**k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3324"" Profanity=""muthaf**ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3325"" Profanity=""muthaf**kers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3326"" Profanity=""muthaf**king"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3327"" Profanity=""muthaf**ks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3328"" Profanity=""muthafuccer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3329"" Profanity=""muthafuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3330"" Profanity=""muthafuck@"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3331"" Profanity=""muthafucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3332"" Profanity=""muthafuckers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3333"" Profanity=""muthafucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3334"" Profanity=""muthafucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3335"" Profanity=""Muthafukas"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3336"" Profanity=""n0b"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3337"" Profanity=""N1gger"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3338"" Profanity=""N1ggers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3339"" Profanity=""Nige&amp;nbsp;Cooke"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3340"" Profanity=""Nigel C00k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3341"" Profanity=""Nigel C00ke"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3342"" Profanity=""Nigel Cook"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3343"" Profanity=""Nigel Cook3"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3344"" Profanity=""Nigel Cooke"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3345"" Profanity=""Nigel&amp;nbsp;C00k"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3346"" Profanity=""Nigel&amp;nbsp;C00ke"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3347"" Profanity=""Nigel&amp;nbsp;Cook"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3348"" Profanity=""Nigel&amp;nbsp;Cook3"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3349"" Profanity=""Nigel&amp;nbsp;Cooke"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3350"" Profanity=""nigga"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3351"" Profanity=""niggaz"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3352"" Profanity=""Nigger"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3353"" Profanity=""niggers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3354"" Profanity=""nob"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3355"" Profanity=""nob&amp;nbsp;head"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3356"" Profanity=""Nobhead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3357"" Profanity=""ogrish"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3358"" Profanity=""ogrish."" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3359"" Profanity=""ogrish.com"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3360"" Profanity=""p**i"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3361"" Profanity=""p*ki"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3362"" Profanity=""p@ki"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3363"" Profanity=""p@kis"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3364"" Profanity=""pak1"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3365"" Profanity=""paki"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3366"" Profanity=""pakis"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3367"" Profanity=""pench0d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3368"" Profanity=""pench0ds"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3369"" Profanity=""penchod"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3370"" Profanity=""penchods"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4112"" Profanity=""Peter Falconio"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3371"" Profanity=""phelching"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3372"" Profanity=""Phuck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3373"" Profanity=""Phucker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3374"" Profanity=""phuckin"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3375"" Profanity=""Phucking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3376"" Profanity=""Phucks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3377"" Profanity=""piss"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3378"" Profanity=""poff"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3379"" Profanity=""poof"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3380"" Profanity=""poofter"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4202"" Profanity=""Poska"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3381"" Profanity=""pr1ck"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3382"" Profanity=""prick"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3383"" Profanity=""Prik"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3384"" Profanity=""pu$$y"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3385"" Profanity=""pussy"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3386"" Profanity=""queer"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3387"" Profanity=""raghead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3388"" Profanity=""ragheads"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3389"" Profanity=""retard"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3390"" Profanity=""S1ut"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3391"" Profanity=""Scat"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3392"" Profanity=""Sh!t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3393"" Profanity=""sh!te"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3394"" Profanity=""sh!tes"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3395"" Profanity=""sh1t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3396"" Profanity=""sh1te"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3397"" Profanity=""shag"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3398"" Profanity=""shat"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3399"" Profanity=""shirtlifter"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3400"" Profanity=""shirtlifters"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3401"" Profanity=""shit"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3402"" Profanity=""shite"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3403"" Profanity=""slag"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3404"" Profanity=""spastic"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3405"" Profanity=""spic"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4121"" Profanity=""spliff"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3406"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3407"" Profanity=""t&amp;nbsp;w&amp;nbsp;a&amp;nbsp;t&amp;nbsp;s "" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3408"" Profanity=""t0$$er"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3409"" Profanity=""t0sser"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3410"" Profanity=""t0ssers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3411"" Profanity=""Tickets available"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3412"" Profanity=""to55er"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3413"" Profanity=""to55ers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3414"" Profanity=""tossers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4141"" Profanity=""towel head"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""4142"" Profanity=""towelhead"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3415"" Profanity=""turd"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3416"" Profanity=""tw&amp;nbsp;at"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3417"" Profanity=""tw@t"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3418"" Profanity=""tw@ts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3419"" Profanity=""twat"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3420"" Profanity=""twats"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3421"" Profanity=""Twunt"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3422"" Profanity=""twunts"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3423"" Profanity=""w anker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3424"" Profanity=""w*****"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3425"" Profanity=""w******"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3426"" Profanity=""w@nker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3427"" Profanity=""w@nkers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3428"" Profanity=""w0g"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3429"" Profanity=""w0gs"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3430"" Profanity=""wa nker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3431"" Profanity=""wan ker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3432"" Profanity=""wank"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3433"" Profanity=""wank's"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3434"" Profanity=""wanke r"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3435"" Profanity=""wanked"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3436"" Profanity=""wanker"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3437"" Profanity=""wankers"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3438"" Profanity=""wanking"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3439"" Profanity=""wanks"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3440"" Profanity=""whore"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3441"" Profanity=""wog"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3442"" Profanity=""wop"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3443"" Profanity=""Xxxhole"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3444"" Profanity=""Y*d"" ModClassID=""7"" Refer=""1"" />
    <P ProfanityID=""3445"" Profanity=""yid"" ModClassID=""7"" Refer=""1"" />
  </profanities>";
        #endregion
    }
}