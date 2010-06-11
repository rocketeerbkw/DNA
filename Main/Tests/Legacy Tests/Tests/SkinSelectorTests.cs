using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using BBC.Dna;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Test class for getting skins for a resquest.
    /// </summary>
    [TestClass]
    public class SkinSelectorTests
    {
        const string SITE_DEFAULT_SKIN = "site-default-skin";
        const string USER_PREFERRED_SKIN = "users-preferred-skin";
        const string FILTER_DERIVED_SKIN = "filter-derived-skin";
        const string REQUESTED_SKIN = "requested-skin";
        const string INVALID_SKIN = "invalid-skin";
  
        Mockery _mock;
        ISite _site;
        IUser _user;
        IRequest _request;
        SkinSelector _skinSelector;
        IInputContext _inputContext;
        IOutputContext _outputContext;

        /// <summary>
        /// Sets up the field mock objects
        /// </summary>
        [TestInitialize]
        public void SetUp()
        {
            _mock = new Mockery();
            _site = _mock.NewMock<ISite>();
            Stub.On(_site).GetProperty("DefaultSkin").Will(Return.Value(SITE_DEFAULT_SKIN));
            Stub.On(_site).Method("DoesSkinExist").With(SITE_DEFAULT_SKIN).Will(Return.Value(true));
            Stub.On(_site).Method("DoesSkinExist").With(INVALID_SKIN).Will(Return.Value(false));
            Stub.On(_site).Method("DoesSkinExist").With(USER_PREFERRED_SKIN).Will(Return.Value(true));
            Stub.On(_site).Method("DoesSkinExist").With(Is.Null).Will(Return.Value(false));
            Stub.On(_site).Method("DoesSkinExist").With(REQUESTED_SKIN).Will(Return.Value(true));
            Stub.On(_site).Method("DoesSkinExist").With(FILTER_DERIVED_SKIN).Will(Return.Value(true));
            Stub.On(_site).Method("DoesSkinExist").With("xml").Will(Return.Value(true));
            Stub.On(_site).GetProperty("SkinSet").Will(Return.Value("vanilla"));
            
            _user = _mock.NewMock<IUser>();

            _inputContext = _mock.NewMock<IInputContext>();
            Stub.On(_inputContext).GetProperty("CurrentSite").Will(Return.Value(_site));

            _outputContext = _mock.NewMock<IOutputContext>();
            Stub.On(_outputContext).Method("VerifySkinFileExists").Will(Return.Value(true));
    
            _skinSelector = new SkinSelector();
           
            _request = _mock.NewMock<IRequest>();
        }

        /// <summary>
        /// verifies all the mocks created by the mockery have met their expectations.
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            _mock.VerifyAllExpectationsHaveBeenMet();
        }

        /// <summary>
        /// Test that the default skin will be lower cased
        /// </summary>
        [TestMethod]
        public void WillLowerCaseTheDefaultSkin()
        {
            ISite siteWithMixedCaseDefaultSkin = _mock.NewMock<ISite>();
            Stub.On(siteWithMixedCaseDefaultSkin).GetProperty("DefaultSkin").Will(Return.Value("deFAulT-SKIN"));
            Stub.On(siteWithMixedCaseDefaultSkin).Method("DoesSkinExist").With("deFAulT-SKIN").Will(Return.Value(true));
            Stub.On(_inputContext).GetProperty("CurrentSite").Will(Return.Value(siteWithMixedCaseDefaultSkin));
            Stub.On(siteWithMixedCaseDefaultSkin).GetProperty("SkinSet").Will(Return.Value("vanilla"));

            _inputContext = _mock.NewMock<IInputContext>();
            Stub.On(_inputContext).GetProperty("CurrentSite").Will(Return.Value(siteWithMixedCaseDefaultSkin));

            setupRequestToHaveNoSkinSpecifiedOnUrl();
            setupUserAsNotLoggedIn();
           

            _skinSelector.Initialise(_inputContext, _outputContext);
            Assert.AreEqual("default-skin", _skinSelector.SkinName);
        }

        /// <summary>
        /// ?Test the the skin will be defined by the users preferences when no skin specified.
        /// </summary>
        [TestMethod]
        public void WillSelectPreferredSkin()
        {
            setupRequestToHaveNoSkinSpecifiedOnUrl();
            setUserToBeLoggedInWithAPreferredSkin(USER_PREFERRED_SKIN);

            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual(USER_PREFERRED_SKIN, _skinSelector.SkinName);
        }

        /// <summary>
        /// ?Test the the skin will be defined by the users preferences when no skin specified.
        /// </summary>
        [TestMethod]
        public void WillSelectPreferredSkinWithInvalidRequestedSkin()
        {
            setupRequestToHaveNoSkinSpecifiedOnUrl();
            setupRequestToHaveRequestedSkin(INVALID_SKIN);
            setUserToBeLoggedInWithAPreferredSkin(USER_PREFERRED_SKIN);

            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual(USER_PREFERRED_SKIN, _skinSelector.SkinName);
        }


        /// <summary>
        /// Test that the requested skin will be lower cased
        /// </summary>
        [TestMethod]
        public void WillLowerCaseRequestedSkin()
        {
            Stub.On(_site).Method("DoesSkinExist").With("reQUESTed-SKIN").Will(Return.Value(true));
            setupRequestToHaveRequestedSkin("reQUESTed-SKIN");
            setupRequestToHaveNoFilterDerivedSkin();
            setupUserAsNotLoggedIn();

            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual("requested-skin", _skinSelector.SkinName);
        }

        /// <summary>
        /// Test that we will use the next valid skin when the requested skin is invalid for the site.
        /// </summary>
        [TestMethod]
        public void WillSelectRequestedSkin()
        {
            setupUserAsNotLoggedIn();
            setupRequestToHaveNoRequestedSkin();
            setupRequestToHaveFilterDerivedSkin(FILTER_DERIVED_SKIN);

            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual(FILTER_DERIVED_SKIN, _skinSelector.SkinName);
        }

        /// <summary>
        /// ?Test the the skin will be defined by the users preferences when no skin specified.
        /// </summary>
        [TestMethod]
        public void WillSelectRequestedSkinWithPreferredSkin()
        {
            setupRequestToHaveNoRequestedSkin();
            setupRequestToHaveFilterDerivedSkin("filter-derived-skin");
            setUserToBeLoggedInWithAPreferredSkin(USER_PREFERRED_SKIN);

            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual(FILTER_DERIVED_SKIN, _skinSelector.SkinName);
        }

        /// <summary>
        /// Test that the default skin is fetched when no params specified
        /// </summary>
        [TestMethod]
        public void WillSelectSiteDefault()
        {
            setupRequestToHaveNoSkinSpecifiedOnUrl();
            setupUserAsNotLoggedIn();

            _skinSelector.Initialise(_inputContext, _outputContext);
            Assert.AreEqual(SITE_DEFAULT_SKIN, _skinSelector.SkinName);
        }


        /// <summary>
        /// Test that the default skin will be used when the user preferred skin is invalid and no URL Specified skin
        /// </summary>
        [TestMethod]
        public void WillSelectSiteDefaultWithInvalidPreferredSkin()
        {
            setupRequestToHaveNoSkinSpecifiedOnUrl();
            setUserToBeLoggedInWithAPreferredSkin(INVALID_SKIN);

            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual(SITE_DEFAULT_SKIN, _skinSelector.SkinName);
        }

        /// <summary>
        /// Test to make sure the sites default skin is used instead of the users if the users preference is set to 'default'
        /// </summary>
        [TestMethod]
        public void SiteHasDefaultSkinAndUserPreferenceEqualsDefault_ExpectSitesDefaultSkin()
        {
            setUserToBeLoggedInWithAPreferredSkin("default");
            setupRequestToHaveNoRequestedSkin();
            setupRequestToHaveNoFilterDerivedSkin();
            _skinSelector.Initialise(_inputContext, _outputContext);
            Assert.AreEqual(SITE_DEFAULT_SKIN, _skinSelector.SkinName);
        }

        /// <summary>
        /// Test special case for when requested skin is purexml.
        /// </summary>
        [TestMethod]
        public void WhenSkinNameIsPurexmlThenSkinIsAlwaysValid()
        {
            CheckSpecialCaseSkinName("purexml");
        }

        /// <summary>
        /// Test special case for when requested skin is PUREXML.
        /// </summary>
        [TestMethod]
        public void WhenSkinNameIsUppercaseXmlThenSkinIsAlwaysValid()
        {
            CheckSpecialCaseSkinName("XML");
        }

        /// <summary>
        /// Test special case for when requested skin is purexml.
        /// </summary>
        [TestMethod]
        public void WhenSkinNameIsXmlThenSkinIsAlwaysValid()
        {
            CheckSpecialCaseSkinName("xml");
        }

        /// <summary>
        /// Test special case for when requested skin is PUREXML.
        /// </summary>
        [TestMethod]
        public void WhenSkinNameIsUppercasePurexmlThenSkinIsAlwaysValid()
        {
            CheckSpecialCaseSkinName("PUREXML");
        }

        /// <summary>
        /// Tests special case when a skin name ends in -xml
        /// </summary>
        [Ignore]
        public void WhenSkinNameEndsInDashXmlThenWeShouldValidThePrefixPartOfTheSkinName()
        {
            string validSkinNameEndingInXml = FILTER_DERIVED_SKIN + "-xml";
            CheckSpecialCaseSkinName(validSkinNameEndingInXml);
        }

        /// <summary>
        /// Tests special case when a skin name ends in -XML
        /// </summary>
        [Ignore]
        public void WhenSkinNameEndsInDashUppercaseXmlThenWeShouldValidThePrefixPartOfTheSkinName()
        {
            string validSkinNameEndingInXml = FILTER_DERIVED_SKIN + "-XML";
            CheckSpecialCaseSkinName(validSkinNameEndingInXml);
        }

        /// <summary>
        /// test that we get an exception when there's no default skin for the site, and no other skin has been specified
        /// </summary>
        [Ignore, ExpectedException(typeof(DnaException))]
        public void ThrowsAnExceptionWhenTheresNoDefaultSkinForTheSiteAndNoOtherSkinHasBeenSpecified()
        {
            setupRequestToHaveNoSkinSpecifiedOnUrl();
            setupUserAsNotLoggedIn();
            ISite siteWithNoDefaultSkin = _mock.NewMock<ISite>();
            Stub.On(siteWithNoDefaultSkin).GetProperty("DefaultSkin").Will(Return.Value(""));
            string skinName = _skinSelector.SkinName;
        }

        private void CheckSpecialCaseSkinName(string skinName)
        {
            setupRequestToHaveRequestedSkin(skinName);
            setupUserAsNotLoggedIn();
            setupRequestToHaveNoFilterDerivedSkin();

            Stub.On(_outputContext).Method("GetSkinPath").Will(Return.Value(Path.Combine(IIsInitialise.GetIIsInitialise().GetWebSiteRoot("h2g2UnitTesting"), @"Skins/SkinSets/vanilla/default/output.xsl")));
            _skinSelector.Initialise(_inputContext, _outputContext);

            Assert.AreEqual(skinName.ToLower(), _skinSelector.SkinName);
        }

        private void setupUserAsNotLoggedIn()
        {
            Stub.On(_user).GetProperty("UserLoggedIn").Will(Return.Value(false));
            Stub.On(_inputContext).GetProperty("ViewingUser").Will(Return.Value(null));
        }

        private void setupRequestToHaveNoSkinSpecifiedOnUrl()
        {
            Stub.On(_inputContext).Method("DoesParamExist").Will(Return.Value(false));
            Stub.On(_inputContext).Method("GetParamStringOrEmpty").Will(Return.Value(string.Empty));
        }

        private void setupRequestToHaveNoRequestedSkin()
        {
            Stub.On(_inputContext).Method("DoesParamExist").With(Is.EqualTo("skin"), Is.NotNull).Will(Return.Value(false));
            Stub.On(_inputContext).Method("GetParamStringOrEmpty").With(Is.EqualTo("skin"), Is.NotNull).Will(Return.Value(string.Empty));
        }

        private void setupRequestToHaveFilterDerivedSkin(string skin)
        {
            Stub.On(_inputContext).Method("DoesParamExist").With(Is.EqualTo("_sk"), Is.NotNull).Will(Return.Value(true));
            Stub.On(_inputContext).Method("GetParamStringOrEmpty").With(Is.EqualTo("_sk"), Is.NotNull).Will(Return.Value(skin));
        }

        private void setupRequestToHaveRequestedSkin(string skin)
        {
            Stub.On(_inputContext).Method("DoesParamExist").With(Is.EqualTo("skin"), Is.NotNull).Will(Return.Value(true));
            Stub.On(_inputContext).Method("GetParamStringOrEmpty").With(Is.EqualTo("skin"), Is.NotNull).Will(Return.Value(skin));
        }

        private void setUserToBeLoggedInWithAPreferredSkin(string preferredSkin)
        {
            Stub.On(_user).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(_user).GetProperty("PreferredSkin").Will(Return.Value(preferredSkin));
            Stub.On(_inputContext).GetProperty("ViewingUser").Will(Return.Value(_user));
        }

        private void setUserToBeLoggedInWithoutAPreferredSkin()
        {
            Stub.On(_user).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(_user).GetProperty("PreferredSkin").Will(Return.Value(null));
            Stub.On(_inputContext).GetProperty("ViewingUser").Will(Return.Value(_user));
        }

        private void setupRequestToHaveNoFilterDerivedSkin()
        {
            Stub.On(_inputContext).Method("DoesParamExist").With(Is.EqualTo("_sk"), Is.NotNull).Will(Return.Value(false));
            Stub.On(_inputContext).Method("GetParamStringOrEmpty").With(Is.EqualTo("_sk"), Is.NotNull).Will(Return.Value(string.Empty));
        }

    }
}
