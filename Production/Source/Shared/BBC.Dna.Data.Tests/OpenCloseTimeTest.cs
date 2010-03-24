using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace BBC.Dna.Data.Tests
{
    
    
    /// <summary>
    ///This is a test class for OpenCloseTimeTest and is intended
    ///to contain all OpenCloseTimeTest Unit Tests
    ///</summary>
    [TestClass()]
    public class OpenCloseTimeTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for HasAlreadyHappened
        ///</summary>
        [TestMethod, Ignore]
        public void HasAlreadyHappened_MinusHourPassed_ReturnedTrue()
        {
            DateTime now = DateTime.Now;
            OpenCloseTime target = new OpenCloseTime((int)now.DayOfWeek +1, now.Hour, now.Minute, 0);
            DateTime date = now.AddHours(-1);
            bool expected = true; 
            bool actual;
            actual = target.HasAlreadyHappened(date);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for HasAlreadyHappened
        ///</summary>
        [TestMethod, Ignore]
        public void HasAlreadyHappened_PlusHourPassed_ReturnedFalse()
        {
            OpenCloseTime target = new OpenCloseTime();
            DateTime now = DateTime.Now;
            target = new OpenCloseTime((int)now.DayOfWeek +1, now.Hour, now.Minute,0);
            DateTime date = now.AddHours(+1);
            bool expected = false;
            bool actual;
            actual = target.HasAlreadyHappened(date);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for OpenCloseTime Constructor
        ///</summary>
        [TestMethod()]
        public void OpenCloseTimeConstructor_ValidValues_ReturnsCorrectlySetObj()
        {
            int dayOfWeek = 1; // TODO: Initialize to an appropriate value
            int hour = 1; // TODO: Initialize to an appropriate value
            int minute =1; // TODO: Initialize to an appropriate value
            int closed = 1; // TODO: Initialize to an appropriate value
            OpenCloseTime target = new OpenCloseTime(dayOfWeek, hour, minute, closed);
            Assert.AreEqual(1, target.DayOfWeek);
            Assert.AreEqual(1, target.Hour);
            Assert.AreEqual(1, target.Minute);
            Assert.AreEqual(1, target.Closed);
        }

        /// <summary>
        ///A test for OpenCloseTime Constructor
        ///</summary>
        [TestMethod()]
        public void OpenCloseTimeConstructor_ValidObject_ReturnsCopy()
        {
            OpenCloseTime other = new OpenCloseTime(1, 1, 1, 1);
            OpenCloseTime target = new OpenCloseTime(other);
            Assert.AreEqual(other.Closed, target.Closed);
            Assert.AreEqual(other.Minute, target.Minute);
            Assert.AreEqual(other.Hour, target.Hour);
            Assert.AreEqual(other.DayOfWeek, target.DayOfWeek);
        }
    }
}
