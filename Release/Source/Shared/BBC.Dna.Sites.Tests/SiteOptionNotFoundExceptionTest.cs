using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SiteOptionNotFoundExceptionTest and is intended
    ///to contain all SiteOptionNotFoundExceptionTest Unit Tests
    ///</summary>
    [TestClass]
    public class SiteOptionNotFoundExceptionTest
    {
        
        /// <summary>
        ///A test for SiteOptionNotFoundException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionNotFoundExceptionConstructor_MessageOnly()
        {
            string message = string.Empty; 
            try
            {
                throw new SiteOptionNotFoundException(message);
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }

        /// <summary>
        ///A test for SiteOptionNotFoundException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionNotFoundExceptionConstructor_WithoutText()
        {
            try
            {
                throw new SiteOptionNotFoundException();
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }

        /// <summary>
        ///A test for SiteOptionNotFoundException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionNotFoundExceptionConstructor_WithSiteIdSectionName()
        {
            int siteId = 0; 
            string section = string.Empty; 
            string name = string.Empty;

            try
            {
                throw new SiteOptionNotFoundException(siteId, section, name);
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }

        /// <summary>
        ///A test for SiteOptionNotFoundException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionNotFoundExceptionConstructorTest()
        {
            string message = string.Empty; 
            Exception inner = null;

            try
            {
                throw new SiteOptionNotFoundException(message, inner);
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }
    }
}