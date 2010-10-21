﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Common;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Objects;



namespace BBC.Dna.Common.Tests
{
    /// <summary>
    /// Summary description for date
    /// </summary>
    [TestClass]
    public class DateTests
    {

        [TestMethod]
        public void DateAsObject()
        {

            DateTime dateTime = DateTime.Now.AddHours(-7);

            Date date = new Date(dateTime);

            //test local timings
            Assert.AreEqual(date.Local.Hours, dateTime.Hour);
            Assert.AreEqual(date.Local.Minutes, dateTime.Minute);
            Assert.AreEqual(date.Local.Month, dateTime.Month);
            Assert.AreEqual(date.Local.Seconds, dateTime.Second);
            Assert.AreEqual(date.Local.Year, dateTime.Year);
            Assert.AreEqual(date.Local.Sort, dateTime.ToString("yyyyMMddHHmmss"));
            Assert.AreEqual(date.Local.Relative, DnaDateTime.TryGetRelativeValueForPastDate(dateTime));

            //test universal timings
            dateTime = dateTime.ToUniversalTime();
            Assert.AreEqual(date.Hours, dateTime.Hour);
            Assert.AreEqual(date.Minutes, dateTime.Minute);
            Assert.AreEqual(date.Month, dateTime.Month);
            Assert.AreEqual(date.Seconds, dateTime.Second);
            Assert.AreEqual(date.Year, dateTime.Year);
            Assert.AreEqual(date.Sort, dateTime.ToString("yyyyMMddHHmmss"));
            Assert.AreEqual(date.Relative, DnaDateTime.TryGetRelativeValueForPastDate(dateTime));

        }


        
    }
}

