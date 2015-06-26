using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SiteOptionInvalidTypeExceptionTest and is intended
    ///to contain all SiteOptionInvalidTypeExceptionTest Unit Tests
    ///</summary>
    [TestClass]
    public class SiteOptionInvalidTypeExceptionTest
    {
        
        /// <summary>
        ///A test for SiteOptionInvalidTypeException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionInvalidTypeExceptionConstructorTest()
        {

            try
            {
                throw new SiteOptionInvalidTypeException();
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for SiteOptionInvalidTypeException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionInvalidTypeExceptionConstructor_WithMessage()
        {
            string message = string.Empty; 
            try
            {
                throw new SiteOptionInvalidTypeException(message);
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for SiteOptionInvalidTypeException Constructor
        ///</summary>
        [TestMethod]
        public void SiteOptionInvalidTypeExceptionConstructor_WithMessageInner()
        {
            string message = string.Empty; 
            Exception inner = null;
            try
            {
                throw new SiteOptionInvalidTypeException(message, inner);
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }
    }
}