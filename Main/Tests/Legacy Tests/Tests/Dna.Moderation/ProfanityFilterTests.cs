using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Moderation.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace Tests
{
	/// <summary>
	/// Class for testing the profanity filter
	/// </summary>
	[TestClass]
	public class ProfanityFilterTests
	{
		/// <summary>
		/// Setup data for profanity filter
		/// </summary>
		[TestInitialize]
		public void InitialiseProfanityTests()
		{
			ProfanityFilter.ClearTestData();
            ProfanityFilter.InitialiseTestData(@"../../Dna.Moderation/ProfanityData.xml", @"../../Dna.Moderation/ProfanityData.xsd");
		}

		/// <summary>
		/// Test checking an empty string
		/// </summary>
		[TestMethod]
		public void TestEmptyString()
		{
            Console.WriteLine("TestEmptyString");
            string matching;
			Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(1,"", out matching));
		}

		/// <summary>
		/// Test a simple string passing the profanity check
		/// </summary>
		[TestMethod]
		public void TestSimpleString()
		{
            Console.WriteLine("TestSimpleString");
            string matching;
			Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(1,"No bad words here. This will pass. [Honestly].", out matching));
		}

		/// <summary>
		/// Testing various profanity hits and misses
		/// </summary>
		[TestMethod]
		public void CheckForProfanities()
		{
            Console.WriteLine("ReferContent");
            string matching;
			Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity Adam Khatib (No idea who that is)", out matching), "Matching a referred name");
			Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity adam khatiB (No idea who that is)", out matching), "Matching a referred name (mixed up case)");
			Assert.AreEqual("adam khatib", matching, "Wrong matching string returned");
			Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(1, "This contains the profanity Adam Khatib (No idea who that is)",out matching),"No match from a different site");
			
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.p", out matching), "Matching a blocked thing");
			Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity www.mfbb.NET/speakerScorner/speakerscorner/index.p", out matching), "Matching a blocked thing (mixed case)");
			Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(3, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching), "No match with trailing characters");
			Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(2, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching), "No match to mod class with no profanities");
			Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity 84 Fresh yid", out matching), "Will either refer or block - probably should block");
			Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity 84 Fresh", out matching), "Will either refer or block - probably should block");
			Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity yid 84 Fresh", out matching), "Will either refer or block - probably should block");
			Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(2, "", out matching), "No match with trailing characters");

            //Check punctuation trimming
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "Adam Khatib><!!", out matching), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "@@@@Adam Khatib", out matching), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(3, "This contains the profanity with punctuation in the middle @@@Adam--- !£Khatib><!! (No idea who that is)", out matching), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This contains the profanity ####yid@@@@", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "yid@@@@", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "yid!", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, " yid ", out matching), "Will either refer or block - probably should block");
            
            //Test a profanity that includes punctuation
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a f*** test", out matching), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a f***!!!!!!!!! test", out matching), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a *ff***!!!!!!!!! test", out matching), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(3, "This is a *f***f!!!!!!!!! test", out matching), "Matching a referred name with punctuation");
        }

		/// <summary>
		/// Testing DoesTextContain function
		/// </summary>
		[TestMethod]
		public void TestDoesTextContain()
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
        /// Test removing links from text.
        /// </summary>
        [TestMethod]
        public void RemoveLinksFromText()
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
        public void TestTrimPunctuation()
        {
            string testInput = @"--**&&&*(*&(*&^%^%^&%&^%&%";
            Assert.AreEqual("",ProfanityFilter.TrimPunctuation(testInput));

            testInput = "This is a test &*(&(*&(*&(*&(*&(*&^%&^%&^%^%&^%&^";
            Assert.AreEqual("This is a test ", ProfanityFilter.TrimPunctuation(testInput));

            testInput = "^&*^&*^&^*& £££$££ This is a test ";
            Assert.AreEqual("  This is a test ", ProfanityFilter.TrimPunctuation(testInput));

            testInput = "This is a @ test";
            Assert.AreEqual("This is a  test", ProfanityFilter.TrimPunctuation(testInput));
        }

        /// <summary>
        /// Test that a profanity is not detected inside a link within the input text.
        /// </summary>
        [Ignore]
        public void CheckForProfanitiesWithInputContainingUrls()
        {
            string testInput = @"Here is some text. It contains a link, http://www.bbc.co.uk/dna/h2g2/inspectuser?id=324.";
            List<string> wordList1 = new List<string>(new string[] { "dna" } );
            List<string> wordList2 = new List<string>(new string[] { "link" });
            string match;

            Assert.IsFalse(ProfanityFilter.DoesTextContain(testInput, wordList1, false, false, out match));
            Assert.IsTrue(ProfanityFilter.DoesTextContain(testInput, wordList2, false, false, out match));
        }

        /// <summary>
        /// Testing various profanity hits and misses
        /// </summary>
        [TestMethod]
        public void CheckForProfanitiesUsingUrlName()
        {
            Console.WriteLine("ReferContent");
            string sitename3 = "h2g2";//modclass 3
            string sitename2 = "360";//modclass 2
            string sitename1 = "dev";//modclass 2
            
            string matching;
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity Adam Khatib (No idea who that is)", out matching), "Matching a referred name");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity adam khatiB (No idea who that is)", out matching), "Matching a referred name (mixed up case)");
            Assert.AreEqual("adam khatib", matching, "Wrong matching string returned");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(sitename1, "This contains the profanity Adam Khatib (No idea who that is)", out matching), "No match from a different site");

            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.p", out matching), "Matching a blocked thing");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity www.mfbb.NET/speakerScorner/speakerscorner/index.p", out matching), "Matching a blocked thing (mixed case)");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching), "No match with trailing characters");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(sitename2,"This contains the profanity www.mfbb.net/speakerscorner/speakerscorner/index.php", out matching), "No match to mod class with no profanities");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity 84 Fresh yid", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity 84 Fresh", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity yid 84 Fresh", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.Pass == ProfanityFilter.CheckForProfanities(sitename2,"", out matching), "No match with trailing characters");

            //Check punctuation trimming
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(sitename3, "Adam Khatib><!!", out matching), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(sitename3, "@@@@Adam Khatib", out matching), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailRefer == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity with punctuation in the middle @@@Adam--- !£Khatib><!! (No idea who that is)", out matching), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This contains the profanity ####yid@@@@", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "yid@@@@", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "yid!", out matching), "Will either refer or block - probably should block");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, " yid ", out matching), "Will either refer or block - probably should block");

            //Test a profanity that includes punctuation
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This is a f*** test", out matching), "Matching a referred name with punctuation");
            Assert.IsTrue(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This is a f***!!!!!!!!! test", out matching), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This is a *ff***!!!!!!!!! test", out matching), "Matching a referred name with punctuation");
            Assert.IsFalse(ProfanityFilter.FilterState.FailBlock == ProfanityFilter.CheckForProfanities(sitename3, "This is a *f***f!!!!!!!!! test", out matching), "Matching a referred name with punctuation");
        }
	}
}
