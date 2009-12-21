using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Tests for the OpenCloseTimes Class
    /// </summary>
    [TestClass]
    public class OpenCloseTimeTests
    {
        /// <summary>
        /// Test1CreateOpenCloseTimeClassTest
        /// </summary>
        [TestMethod]
        public void Test1CreateOpenCloseTimeClassTest()
        {
            Console.WriteLine("Test1CreateOpenCloseTimeClassTest");
            OpenCloseTime testOpenCloseTime = new OpenCloseTime();

            Assert.IsNotNull(testOpenCloseTime, "OpenCloseTime object created.");

        }
        /// <summary>
        /// Test2AssignOpenCloseTimeDayOfWeek
        /// </summary>
        [TestMethod]
        public void Test2AssignOpenCloseTimeDayOfWeek()
        {
            Console.WriteLine("Test2AssignOpenCloseTimeDayOfWeek");
            OpenCloseTime testOpenCloseTime = new OpenCloseTime();
            testOpenCloseTime.DayOfWeek = (int) DayOfWeek.Monday;

            Assert.AreEqual(testOpenCloseTime.DayOfWeek, (int) DayOfWeek.Monday);
        }

        /// <summary>
        /// Test3AssignOpenCloseTimeHour
        /// </summary>
        [TestMethod]
        public void Test3AssignOpenCloseTimeHour()
        {
            Console.WriteLine("Test3AssignOpenCloseTimeHour");
            OpenCloseTime testOpenCloseTime = new OpenCloseTime();
            testOpenCloseTime.Hour = 15;

            Assert.AreEqual(testOpenCloseTime.Hour, 15);
        }

        /// <summary>
        /// Test4AssignOpenCloseTimeMinute
        /// </summary>
        [TestMethod]
        public void Test4AssignOpenCloseTimeMinute()
        {
            Console.WriteLine("Test4AssignOpenCloseTimeMinute");
            OpenCloseTime testOpenCloseTime = new OpenCloseTime();
            testOpenCloseTime.Minute = 35;

            Assert.AreEqual(testOpenCloseTime.Minute, 35);
        }

        /// <summary>
        /// Test5AssignOpenCloseTimeClosed
        /// </summary>
        [TestMethod]
        public void Test5AssignOpenCloseTimeClosed()
        {
            Console.WriteLine("Test5AssignOpenCloseTimeClosed");
            OpenCloseTime testOpenCloseTime = new OpenCloseTime();
            testOpenCloseTime.Closed = 0;

            Assert.AreEqual(testOpenCloseTime.Closed, 0);
        }

        /// <summary>
        /// Test5CreateOpenCloseTimeWithInitialValues
        /// </summary>
        [TestMethod]
        public void Test5CreateOpenCloseTimeWithInitialValues()
        {
            Console.WriteLine("Test5CreateOpenCloseTimeWithInitialValues");
            OpenCloseTime testOpenCloseTime = new OpenCloseTime(1, 15, 35, 0);

            Assert.AreEqual(testOpenCloseTime.DayOfWeek, 1);
            Assert.AreEqual(testOpenCloseTime.Hour, 15);
            Assert.AreEqual(testOpenCloseTime.Minute, 35);
            Assert.AreEqual(testOpenCloseTime.Closed, 0);
       }

        /// <summary>
        /// Test6CreateOpenCloseTimeFromOpenCloseTime
        /// </summary>
        [TestMethod]
        public void Test6CreateOpenCloseTimeFromOpenCloseTime()
        {
            Console.WriteLine("Test6CreateOpenCloseTimeFromOpenCloseTime");
            OpenCloseTime testOpenCloseTime1 = new OpenCloseTime(7, 5, 59, 1);
            OpenCloseTime testOpenCloseTime2 = new OpenCloseTime(testOpenCloseTime1);

            Assert.AreEqual(testOpenCloseTime2.DayOfWeek, 7);
            Assert.AreEqual(testOpenCloseTime2.Hour, 5);
            Assert.AreEqual(testOpenCloseTime2.Minute, 59);
            Assert.AreEqual(testOpenCloseTime2.Closed, 1);
        }
    }
}
