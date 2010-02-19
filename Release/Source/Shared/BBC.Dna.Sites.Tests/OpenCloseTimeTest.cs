using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Sites;
using System;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for OpenCloseTimeTest and is intended
    ///to contain all OpenCloseTimeTest Unit Tests
    ///</summary>
    [TestClass]
    public class OpenCloseTimeTest
    {
        //Note: db code which contains c++ values has sunday = 1, monday =0 - c# has sunday =0, monday =1... so plus 1

        /// <summary>
        ///A test for OpenCloseTime Constructor
        ///</summary>
        [TestMethod]
        public void OpenCloseTimeConstructorTest()
        {
            var target = new OpenCloseTime();
            int dayOfWeek = 1; 
            int hour = 1; 
            int minute = 1; 
            int closed = 1; 
            target = new OpenCloseTime(dayOfWeek, hour, minute, closed);
            Assert.AreEqual(dayOfWeek, target.DayOfWeek);
        }

        /// <summary>
        ///A test for OpenCloseTime Constructor
        ///</summary>
        [TestMethod()]
        public void OpenCloseTimeConstructor_CopyOther_ReturnsSameObject()
        {
            int dayOfWeek = 1;
            int hour = 1;
            int minute = 1;
            int closed = 1;
            var other = new OpenCloseTime(dayOfWeek, hour, minute, closed);

            OpenCloseTime target = new OpenCloseTime(other);
            Assert.AreEqual(other.DayOfWeek, target.DayOfWeek);
        }

        /// <summary>
        ///A test for HasAlreadyHappened
        ///</summary>
        [TestMethod()]
        public void HasAlreadyHappened_EventBefore_ReturnsTrue()
        {
            DateTime before = DateTime.Now.AddHours(-1);
            OpenCloseTime target = new OpenCloseTime((int)before.DayOfWeek +1 , before.Hour, before.Minute, 0);
            DateTime date = DateTime.Now; 
            Assert.IsTrue(target.HasAlreadyHappened(date));
        }

        /// <summary>
        ///A test for HasAlreadyHappened
        ///</summary>
        [TestMethod()]
        public void HasAlreadyHappened_EventAfter_ReturnsFalse()
        {
            DateTime before = DateTime.Now.AddMinutes(30);
            var target = new OpenCloseTime((int)before.DayOfWeek + 1, before.Hour, before.Minute, 0);
            DateTime date = DateTime.Now;
            Assert.IsFalse(target.HasAlreadyHappened(date));
        }

        /// <summary>
        ///A test for HasAlreadyHappened
        ///</summary>
        [TestMethod()]
        public void HasAlreadyHappened_EventInAnHour_ReturnsFalse()
        {
            DateTime before = DateTime.Now.AddHours(1);
            var target = new OpenCloseTime((int)before.DayOfWeek + 1, before.Hour, before.Minute, 0);
            DateTime date = DateTime.Now;
            Assert.IsFalse(target.HasAlreadyHappened(date));
        }

        /// <summary>
        ///A test for HasAlreadyHappened
        ///</summary>
        [TestMethod()]
        public void HasAlreadyHappened_EventTomorrow_ReturnsFalse()
        {
            DateTime before = DateTime.Now.AddDays(1);
            var target = new OpenCloseTime((int)before.DayOfWeek + 1, before.Hour, before.Minute, 0);
            DateTime date = DateTime.Now;
            Assert.IsFalse(target.HasAlreadyHappened(date));
        }
    }
}