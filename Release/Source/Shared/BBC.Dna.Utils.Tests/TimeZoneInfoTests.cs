using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using BBC.Dna;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// 
    /// </summary>
    [TestClass]
    public class TimeZoneInfoTests
    {
        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void TestLocalTimeConversion()
        {
            // CultureInfo info = new CultureInfo("en-GB", true);
            // System.Threading.Thread.CurrentThread.CurrentCulture = info;

            BBC.Dna.Utils.TimeZoneInfo tz = BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo();

            //Check Past GMT
            DateTime utc = new DateTime(2007, 1, 1, 10, 0, 0);
            DateTime lt = tz.ConvertUtcToTimeZone(utc);
            Assert.AreEqual(utc.Hour, lt.Hour, "GMT & local times match");

            // Check past BST 
            utc = new DateTime(2007, 5, 1, 10, 0, 0);
            lt = tz.ConvertUtcToTimeZone(utc);
            Assert.AreEqual(utc.Hour + 1, lt.Hour, "BST & local times match");

            //Check Future GMT
            utc = new DateTime(2009, 1, 1, 10, 0, 0);
            lt = tz.ConvertUtcToTimeZone(utc);
            Assert.AreEqual(utc.Hour, lt.Hour, "GMT & local times match");

            //Check Future BST
            utc = new DateTime(2009, 8, 1, 10, 0, 0);
            lt = tz.ConvertUtcToTimeZone(utc);
            Assert.AreEqual(utc.Hour+1, lt.Hour, "BST & local times match");
        }
    }
}
