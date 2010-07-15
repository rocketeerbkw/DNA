using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Tests for EmailFilterTests.
    /// </summary>
    [TestClass]
    public class EmailFilterTests
    {
        /// <summary>
        /// Check if some text contains emails.
        /// </summary>
        [TestMethod]
        public void CheckifContainsEmails()
        {
            Assert.IsTrue(EmailAddressFilter.CheckForEmailAddresses("Here is an email damnyoureyes@yahoo.com"), "Not catching the email address");
            
            Assert.IsFalse(EmailAddressFilter.CheckForEmailAddresses("Here is a bit of text with an @ but no email address"), "Incorrectly catching the email address");
        }
 
    }
}