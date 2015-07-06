using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace FunctionalTests
{
    [TestClass]
    public class TwitterProfilePageTests
    {
        [TestMethod]
        public void GivenIamASuperUser_WhenICreateATwitterProfileWithValidData_ThenMyProfileIsCreatedSuccessfully()
        {
            var dnaRequest = new DnaTestURLRequest("moderation");

            dnaRequest.SetCurrentUserSuperUser();

            const string url = "admin/twitterprofile?sitename=&s_sitename=All&profileid=blah&title=blah&commentforumparenturl=blah&users=blah+&searchterms=blah+&moderated=true&action=createupdateprofile&skin=purexml";

            dnaRequest.UseProxyPassing = false;

            dnaRequest.RequestPage(url);

            const string xpath = @"/H2G2/ERROR[@TYPE=""TWITTERPROFILEMANDATORYFIELDSMISSING""]/ERRORMESSAGE";

            var response = dnaRequest.GetLastResponseAsXML();

            Assert.IsNull(response.SelectSingleNode(xpath));
        }

        [TestMethod]
        public void GivenIamASuperUser_WhenICreateATwitterProfile_WithAProfileIdConatiningASpace_ThenIAmShownTheProfileIdSpacesErrorMessage()
        {
            var dnaRequest = new DnaTestURLRequest("moderation");

            dnaRequest.SetCurrentUserSuperUser();

            const string url = "admin/twitterprofile?sitename=&s_sitename=h2g2&profileid=blah blah&title=blah&commentforumparenturl=blah&users=blah+&searchterms=blah+&moderated=true&action=createupdateprofile&skin=purexml";

            dnaRequest.UseProxyPassing = false;

            dnaRequest.RequestPage(url);

            var response = dnaRequest.GetLastResponseAsXML();

            const string xpath = @"/H2G2/ERROR[@TYPE=""TWITTERPROFILEMANDATORYFIELDSMISSING""]/ERRORMESSAGE";

            const string expected = "Profile ID cannot contain spaces";

            var actual = response.SelectSingleNode(xpath).InnerXml;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void GivenIamASuperUser_WhenICreateATwitterProfile_WithABlankProfileId_ThenIAmShownTheMissingProfileIdErrorMessage()
        {
            var dnaRequest = new DnaTestURLRequest("moderation");

            dnaRequest.SetCurrentUserSuperUser();

            const string url = "admin/twitterprofile?sitename=&s_sitename=h2g2&profileid=&title=blah&commentforumparenturl=blah&users=blah+&searchterms=blah+&moderated=true&action=createupdateprofile&skin=purexml";

            dnaRequest.UseProxyPassing = false;

            dnaRequest.RequestPage(url);

            var response = dnaRequest.GetLastResponseAsXML();

            const string xpath = @"/H2G2/ERROR[@TYPE=""TWITTERPROFILEMANDATORYFIELDSMISSING""]/ERRORMESSAGE";

            const string expected = "Please fill in the mandatory fields for creating/updating a profile";

            var actual = response.SelectSingleNode(xpath).InnerXml;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void GivenIamASuperUser_WhenICreateATwitterProfile_WithABlankTitle_ThenIamShownTheMissingTitleErrorMessage()
        {
            var dnaRequest = new DnaTestURLRequest("moderation");

            dnaRequest.SetCurrentUserSuperUser();

            const string url = "admin/twitterprofile?sitename=&s_sitename=h2g2&profileid=blahblah&title=&commentforumparenturl=blah&users=blah+&searchterms=blah+&moderated=true&action=createupdateprofile&skin=purexml";

            dnaRequest.UseProxyPassing = false;

            dnaRequest.RequestPage(url);

            var response = dnaRequest.GetLastResponseAsXML();

            const string xpath = @"/H2G2/ERROR[@TYPE=""TWITTERPROFILEMANDATORYFIELDSMISSING""]/ERRORMESSAGE";

            const string expected = "Please fill in the mandatory fields for creating/updating a profile";

            var actual = response.SelectSingleNode(xpath).InnerXml;

            Assert.AreEqual(expected, actual);
        }
    }
}