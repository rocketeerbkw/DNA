using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    ///Referee List Tests
    /// </summary>
    [TestClass]
    public class RefereeListTests
    {
        private const string _schemaUri = "RefereeList.xsd";

        /// <summary>
        /// Test that we get a correct list of referees
        /// </summary>
        [TestMethod]
        public void TestGetRefereeList()
        {
            Console.WriteLine("Before RefereeListTests - TestGetRefereeList");
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            User user = new User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            SetupReferees();

            // Create the stored procedure reader for the CommentList object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("FetchRefereeList"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("FetchRefereeList").Will(Return.Value(reader));

                // Create a new RefereeList object and get the list of referees
                RefereeList testRefereeList = new RefereeList(mockedInputContext);
                testRefereeList.ProcessRequest();

                XmlElement xml = testRefereeList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("REFEREE-LIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("REFEREE-LIST/REFEREE/USER[USERID='6']") != null, "The xml is not generated correctly (UserID 6)!!!");
                Assert.IsTrue(xml.SelectSingleNode("REFEREE-LIST/REFEREE/USER[USERID='24']") != null, "The xml is not generated correctly (UserID 24)!!!");

                XmlNode referee = xml.SelectSingleNode("REFEREE-LIST/REFEREE/USER[USERID='6']").ParentNode;
                Assert.IsTrue(referee.SelectSingleNode("SITEID[1]") != null, "The xml is not generated correctly (UserID 6 SiteID 1)!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();

            }
            Console.WriteLine("After RefereeListTests - TestGetRefereeList");
        }


        private void SetupReferees()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("addusertogroups"))
            {
                dataReader.AddParameter("siteid", 1);
                dataReader.AddParameter("userid", 6);
                dataReader.AddParameter("groupname1", "Referee");
                dataReader.Execute();
            }
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("addusertogroups"))
            {
                dataReader.AddParameter("siteid", 2);
                dataReader.AddParameter("userid", 6);
                dataReader.AddParameter("groupname1", "Referee");
                dataReader.Execute();
            }
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("addusertogroups"))
            {
                dataReader.AddParameter("siteid", 1);
                dataReader.AddParameter("userid", 24);
                dataReader.AddParameter("groupname1", "Referee");
                dataReader.Execute();
            }
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("addusertogroups"))
            {
                dataReader.AddParameter("siteid", 2);
                dataReader.AddParameter("userid", 24);
                dataReader.AddParameter("groupname1", "Referee");
                dataReader.Execute();
            }
        }
    }
}
