using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for URLFilterTests.
    /// </summary>
    [TestClass]
    public class URLFilterTests
    {
        /// <summary>
        /// Check if some text contains some URLs.
        /// </summary>
        [TestMethod]
        public void CheckifContainsUrls()
        {
            Console.WriteLine("Before CheckifContainsUrls");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = DnaMockery.CreateDatabaseInputContext();
            DnaMockery.SetDefaultDiagnostics(mockedInputContext);
            DnaMockery.SetDefaultAllowedURLs(mockedInputContext);
                     
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            // Create the stored procedure reader for the UITemplate object
            using (IDnaDataReader reader = mockedInputContext.CreateDnaDataReader("getallallowedurls"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getallallowedurls").Will(Return.Value(reader));

                User user = new User(mockedInputContext);
                Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
                Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

                URLFilter urlFilter = new URLFilter(mockedInputContext);
                List<string> URLMatches = new List<string>();

                URLFilter.FilterState state = urlFilter.CheckForURLs("Here is a url http://www.bbc.co.uk ", URLMatches);

                Assert.IsTrue(URLFilter.FilterState.Pass == state, "Catching a valid url address");
                
                state = urlFilter.CheckForURLs("Check a plain url  www.bbc.co.uk ", URLMatches);

                Assert.IsTrue(URLFilter.FilterState.Pass == state, "Catching a valid url address");

                state = urlFilter.CheckForURLs("http://www.bbc.co.uk ", URLMatches);

                Assert.IsTrue(URLFilter.FilterState.Pass == state, "Catching a valid url address");

                state = urlFilter.CheckForURLs("http://www.bbc.co.uk/cbbc", URLMatches);

                Assert.IsTrue(URLFilter.FilterState.Pass == state, "Catching a valid url address");

                state = urlFilter.CheckForURLs("http://www.dodgyporn.co.uk/", URLMatches);

                Assert.IsTrue(URLFilter.FilterState.Fail == state, "Not Catching the url address");

                state = urlFilter.CheckForURLs("Here is a bit of text with an / but no url address", URLMatches);

                Assert.IsTrue(URLFilter.FilterState.Pass == state, "Catching  a non existant url address");
            }
            
            Console.WriteLine("After CheckifContainsUrls");
        }
 
    }
}