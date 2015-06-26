using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Test the XML against the schema.
    /// Sanity check the results.
    /// </summary>
    [TestClass]
    public class MemberDetailsAdminPageTests
    {
        [TestMethod]
        public void TestMemberDetailsAdminPage()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;

            string requestURL = "MemberDetails?skin=purexml&userid=" + request.CurrentUserID.ToString();
            request.RequestPage(requestURL);

            XmlDocument doc = request.GetLastResponseAsXML();
            
            //Validate XML
            DnaXmlValidator validator = new DnaXmlValidator(doc.InnerXml, "H2G2MemberDetailsAdmin.xsd");
            validator.Validate();

            //Check at least the user specified is included in the alternate identites.
            XmlNode node = doc.SelectSingleNode("H2G2/MEMBERDETAILSLIST/MEMBERDETAILS/USER[USERID='" + Convert.ToString(request.CurrentUserID) + "']");
            Assert.IsNotNull(node);
        }
    }
}
