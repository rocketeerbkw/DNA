using System;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SiteConfigTest and is intended
    ///to contain all SiteConfigTest Unit Tests
    ///</summary>
    [TestClass]
    public class SiteConfigTest
    {
        public MockRepository Mocks = new MockRepository();

        [TestMethod]
        public void GetPreviewSiteConfig_ReturnsV2Config_ReturnsValidObject()
        {
            int siteId = 0;
            var dbConfig = "<SITECONFIG><V2_BOARDS><HEADER_COLOUR>blue</HEADER_COLOUR><BANNER_SSI>/dna-ssi/tset.sssi</BANNER_SSI><HORIZONTAL_NAV_SSI>/dna-ssi/tset.sssi</HORIZONTAL_NAV_SSI><LEFT_NAV_SSI>/dna-ssi/tset.sssi</LEFT_NAV_SSI><WELCOME_MESSAGE>Welcome</WELCOME_MESSAGE><ABOUT_MESSAGE>Welcome</ABOUT_MESSAGE><OPENCLOSETIMES_TEXT>Welcome</OPENCLOSETIMES_TEXT><FOOTER><COLOUR>grey</COLOUR><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></FOOTER><MODULES><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></MODULES><RECENTDISCUSSIONS>true</RECENTDISCUSSIONS><SOCIALTOOLBAR>true</SOCIALTOOLBAR><TOPICLAYOUT>2COLUMN</TOPICLAYOUT><CSS_LOCATION /><EMOTICON_LOCATION /></V2_BOARDS></SITECONFIG>";
            
            
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("config")).Return(dbConfig);
            reader.Stub(x => x.GetGuid("editkey")).Return(Guid.Empty);
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpreviewsiteconfig")).Return(reader);

            Mocks.ReplayAll();
            var actual = SiteConfig.GetPreviewSiteConfig(siteId, readerCreator);
            

            Assert.AreEqual(0, actual.SiteId);
            Assert.AreEqual(Guid.Empty, actual.EditKey);
            Assert.AreEqual("blue", actual.V2Board.HeaderColour);

            
            var actualXml = StringUtils.SerializeToXmlUsingXmlSerialiser(actual.V2Board);
            var expected = "<V2_BOARDS><HEADER_COLOUR>blue</HEADER_COLOUR><BANNER_SSI>/dna-ssi/tset.sssi</BANNER_SSI><HORIZONTAL_NAV_SSI>/dna-ssi/tset.sssi</HORIZONTAL_NAV_SSI><LEFT_NAV_SSI>/dna-ssi/tset.sssi</LEFT_NAV_SSI><WELCOME_MESSAGE>Welcome</WELCOME_MESSAGE><ABOUT_MESSAGE>Welcome</ABOUT_MESSAGE><OPENCLOSETIMES_TEXT>Welcome</OPENCLOSETIMES_TEXT><FOOTER><COLOUR>grey</COLOUR><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></FOOTER><MODULES><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></MODULES><RECENTDISCUSSIONS>true</RECENTDISCUSSIONS><SOCIALTOOLBAR>true</SOCIALTOOLBAR><TOPICLAYOUT>2COLUMN</TOPICLAYOUT><CSS_LOCATION /><EMOTICON_LOCATION /></V2_BOARDS>";
            Assert.AreEqual(expected, actualXml); //the strings are the same - but encoding different...
             
        }

        [TestMethod]
        public void GetPreviewSiteConfig_ReturnsLegacyOnlyConfig_ReturnsValidObject()
        {
            int siteId = 0;
            var dbConfig = "<SITECONFIG><ASSETCOMPLAIN>alert_moderator_button.gif</ASSETCOMPLAIN><ASSETNEW /><BARLEYSEARCHCOLOUR /><BARLEYVARIANT>international</BARLEYVARIANT><BOARDNAME>Points Of View</BOARDNAME><BOARDROOT>mbpointsofview/</BOARDROOT><BOARDSSOLINK>mbpointsofview</BOARDSSOLINK><CODEBANNER><IMG SRC=\"/pov/signon/images/mbbanner.gif\" STYLE=\"margin:0 0 5px 10px;\" WIDTH=\"635\" HEIGHT=\"70\" ALT=\"\" /></CODEBANNER><CSSLOCATION>messageboards.css</CSSLOCATION><EMOTICONLOCATION>0</EMOTICONLOCATION><EXTERNALHOME /><EXTERNALHOMEURL /><EXTEXTBODY>Tell us what your view is.</EXTEXTBODY><EXTEXTPREVIEW /><EXTEXTTITLE>Briefly, what do you want to talk about?</EXTEXTTITLE><FEATURESMILEYS>1</FEATURESMILEYS><IMAGEBANNER>banner.gif</IMAGEBANNER><LINKPATH>1</LINKPATH><NAVCRUMB><BR /></NAVCRUMB><NAVLHN><STYLE TYPE=\"text/css\">  .lhn-container {background: #bfd6f0; width: 125px;}  .lhn-topic {padding: 2px 0px 2px 8px; font-weight;}  .lhn-topic a {text-decoration: none;}  </STYLE>    <P STYLE=\"background:#CFCDBC;padding:0px 0px 0px 8px;\"><A HREF=\"/consumer/tv_and_radio/points_of_view/\" STYLE=\"text-decoration:none;color:#666666;\"> Points of View Homepage</A></P><P STYLE=\"background:#E3E1CC;padding:2px 0px 2px 8px;\"><A HREF=\"http://www.bbc.co.uk/messageboards/newguide/messageboards_a-z.shtml\" STYLE=\"text-decoration:none;color:#666666;\" TARGET=\"_blank\">Other BBC Messageboards</A></P><P STYLE=\"background:#E3E1CC;padding:2px 0px 2px 8px;\"><A HREF=\"http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html\" STYLE=\"text-decoration:none;color:#666666;\" TARGET=\"_blank\">FAQs</A></P><P STYLE=\"background:#E3E1CC;padding:2px 0px 2px 8px;\"><A HREF=\"http://www.bbc.co.uk/messageboards/newguide/popup_welcome.html\" STYLE=\"text-decoration:none;color:#666666;\" TARGET=\"_blank\">Help with Registration</A></P><P STYLE=\"background:#95BBE6;padding:2px 0px 2px 8px; margin: 10px 0px 0px 0px;\"><A HREF=\"/dna/mbpointsofview/\" STYLE=\"text-decoration:none;color:#406284;\">Messageboard</A></P></NAVLHN><PATHDEV>http://www.bbc.co.uk/pov/messageboard/</PATHDEV><PATHLIVE>http://www.bbc.co.uk/pov/messageboard/</PATHLIVE><PATHSSOTYPE /></SITECONFIG>";

            //var expected = "<V2_BOARDS><HEADER_COLOUR>blue</HEADER_COLOUR><BANNER_SSI>/dna-ssi/tset.sssi</BANNER_SSI><HORIZONTAL_NAV_SSI>/dna-ssi/tset.sssi</HORIZONTAL_NAV_SSI><LEFT_NAV_SSI>/dna-ssi/tset.sssi</LEFT_NAV_SSI><WELCOME_MESSAGE>Welcome</WELCOME_MESSAGE><ABOUT_MESSAGE>Welcome</ABOUT_MESSAGE><OPENCLOSETIMES_TEXT>Welcome</OPENCLOSETIMES_TEXT><FOOTER><COLOUR>grey</COLOUR><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></FOOTER><MODULES><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></MODULES><RECENTDISCUSSIONS>true</RECENTDISCUSSIONS><SOCIALTOOLBAR>true</SOCIALTOOLBAR><TOPICLAYOUT>2COLUMN</TOPICLAYOUT></V2_BOARDS>";
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("config")).Return(dbConfig);
            reader.Stub(x => x.GetGuid("editkey")).Return(Guid.Empty);
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpreviewsiteconfig")).Return(reader);

            Mocks.ReplayAll();
            var actual = SiteConfig.GetPreviewSiteConfig(siteId, readerCreator);


            Assert.AreEqual(0, actual.SiteId);
            Assert.AreEqual(Guid.Empty, actual.EditKey);
            //Assert.IsTrue(actual.LegacyElements.);


            string actualXml = StringUtils.SerializeToXmlUsingXmlSerialiser(actual);
            var actualXmlDoc = new XmlDocument();
            actualXmlDoc.LoadXml(actualXml);

            Assert.IsNotNull(actualXmlDoc.SelectSingleNode("//SITECONFIG/ASSETCOMPLAIN"));
            Assert.AreEqual("alert_moderator_button.gif", actualXmlDoc.SelectSingleNode("//SITECONFIG/ASSETCOMPLAIN").InnerText);
        }

        public static SiteConfig GetTestSiteConfigObject()
        {
            var dbConfig = "<SITECONFIG><V2_BOARDS><HEADER_COLOUR>blue</HEADER_COLOUR><BANNER_SSI>/dna-ssi/tset.sssi</BANNER_SSI><HORIZONTAL_NAV_SSI>/dna-ssi/tset.sssi</HORIZONTAL_NAV_SSI><LEFT_NAV_SSI>/dna-ssi/tset.sssi</LEFT_NAV_SSI><WELCOME_MESSAGE>Welcome</WELCOME_MESSAGE><ABOUT_MESSAGE>Welcome</ABOUT_MESSAGE><OPENCLOSETIMES_TEXT>Welcome</OPENCLOSETIMES_TEXT><FOOTER><COLOUR>grey</COLOUR><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></FOOTER><MODULES><LINKS><LINK>http://bbc.co.uk/</LINK><LINK>http://bbc.co.uk/</LINK></LINKS></MODULES><RECENTDISCUSSIONS>true</RECENTDISCUSSIONS><SOCIALTOOLBAR>true</SOCIALTOOLBAR><TOPICLAYOUT>2COLUMN</TOPICLAYOUT></V2_BOARDS><ASSETCOMPLAIN>alert_moderator_button.gif</ASSETCOMPLAIN><ASSETNEW /><BARLEYSEARCHCOLOUR /><BARLEYVARIANT>international</BARLEYVARIANT><BOARDNAME>Points Of View</BOARDNAME><BOARDROOT>mbpointsofview/</BOARDROOT><BOARDSSOLINK>mbpointsofview</BOARDSSOLINK><CODEBANNER><IMG SRC=\"/pov/signon/images/mbbanner.gif\" STYLE=\"margin:0 0 5px 10px;\" WIDTH=\"635\" HEIGHT=\"70\" ALT=\"\" /></CODEBANNER><CSSLOCATION>messageboards.css</CSSLOCATION><EMOTICONLOCATION>0</EMOTICONLOCATION><EXTERNALHOME /><EXTERNALHOMEURL /><EXTEXTBODY>Tell us what your view is.</EXTEXTBODY><EXTEXTPREVIEW /><EXTEXTTITLE>Briefly, what do you want to talk about?</EXTEXTTITLE><FEATURESMILEYS>1</FEATURESMILEYS><IMAGEBANNER>banner.gif</IMAGEBANNER><LINKPATH>1</LINKPATH><NAVCRUMB><BR /></NAVCRUMB><NAVLHN><STYLE TYPE=\"text/css\">  .lhn-container {background: #bfd6f0; width: 125px;}  .lhn-topic {padding: 2px 0px 2px 8px; font-weight;}  .lhn-topic a {text-decoration: none;}  </STYLE>    <P STYLE=\"background:#CFCDBC;padding:0px 0px 0px 8px;\"><A HREF=\"/consumer/tv_and_radio/points_of_view/\" STYLE=\"text-decoration:none;color:#666666;\"> Points of View Homepage</A></P><P STYLE=\"background:#E3E1CC;padding:2px 0px 2px 8px;\"><A HREF=\"http://www.bbc.co.uk/messageboards/newguide/messageboards_a-z.shtml\" STYLE=\"text-decoration:none;color:#666666;\" TARGET=\"_blank\">Other BBC Messageboards</A></P><P STYLE=\"background:#E3E1CC;padding:2px 0px 2px 8px;\"><A HREF=\"http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html\" STYLE=\"text-decoration:none;color:#666666;\" TARGET=\"_blank\">FAQs</A></P><P STYLE=\"background:#E3E1CC;padding:2px 0px 2px 8px;\"><A HREF=\"http://www.bbc.co.uk/messageboards/newguide/popup_welcome.html\" STYLE=\"text-decoration:none;color:#666666;\" TARGET=\"_blank\">Help with Registration</A></P><P STYLE=\"background:#95BBE6;padding:2px 0px 2px 8px; margin: 10px 0px 0px 0px;\"><A HREF=\"/dna/mbpointsofview/\" STYLE=\"text-decoration:none;color:#406284;\">Messageboard</A></P></NAVLHN><PATHDEV>http://www.bbc.co.uk/pov/messageboard/</PATHDEV><PATHLIVE>http://www.bbc.co.uk/pov/messageboard/</PATHLIVE><PATHSSOTYPE /></SITECONFIG>";
            return (SiteConfig)StringUtils.DeserializeObjectUsingXmlSerialiser(dbConfig, typeof (SiteConfig));
        }

        [TestMethod]
        public void UpdateConfig_WithValidKey_ReturnsCorrectObject()
        {
            var siteConfig = GetTestSiteConfigObject();
            var editKey = Guid.NewGuid();
            

            var readerUpdate = Mocks.DynamicMock<IDnaDataReader>();
            readerUpdate.Stub(x => x.Read()).Return(true);
            readerUpdate.Stub(x => x.DoesFieldExist("ValidKey")).Return(true);
            readerUpdate.Stub(x => x.GetInt32NullAsZero("ValidKey")).Return(1);
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("config")).Return(StringUtils.SerializeToXmlUsingXmlSerialiser(siteConfig));
            reader.Stub(x => x.GetGuid("editkey")).Return(editKey);
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpreviewsiteconfig")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("updatepreviewandliveconfig")).Return(readerUpdate);

            Mocks.ReplayAll();

            Assert.AreEqual(Guid.Empty, siteConfig.EditKey);
            var result = (Result)siteConfig.UpdateConfig(readerCreator, true);
            Assert.AreEqual("SiteConfigUpdateSuccess", result.Type);
            Assert.AreEqual(editKey, siteConfig.EditKey);

        }


        [TestMethod]
        public void UpdateConfig_WithInValidKey_ReturnsCorrectObject()
        {
            var siteConfig = GetTestSiteConfigObject();
            var editKey = Guid.NewGuid();

            var readerUpdate = Mocks.DynamicMock<IDnaDataReader>();
            readerUpdate.Stub(x => x.Read()).Return(true);
            readerUpdate.Stub(x => x.DoesFieldExist("ValidKey")).Return(true);
            readerUpdate.Stub(x => x.GetInt32NullAsZero("ValidKey")).Return(0);
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("config")).Return(StringUtils.SerializeToXmlUsingXmlSerialiser(siteConfig));
            reader.Stub(x => x.GetGuid("editkey")).Return(editKey);
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpreviewsiteconfig")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("updatepreviewandliveconfig")).Return(readerUpdate);

            Mocks.ReplayAll();

            Assert.AreEqual(Guid.Empty, siteConfig.EditKey);
            var result = (Error)siteConfig.UpdateConfig(readerCreator, true);
            Assert.AreEqual("SiteConfigUpdateInvalidKey", result.Type);
            Assert.AreEqual(Guid.Empty, siteConfig.EditKey);

        }

        [TestMethod]
        public void UpdatePreviewConfig_WithInValidKey_ReturnsCorrectObject()
        {
            var siteConfig = GetTestSiteConfigObject();
            var editKey = Guid.NewGuid().ToString();

            var readerUpdate = Mocks.DynamicMock<IDnaDataReader>();
            readerUpdate.Stub(x => x.Read()).Return(true);
            readerUpdate.Stub(x => x.DoesFieldExist("ValidKey")).Return(true);
            readerUpdate.Stub(x => x.GetInt32NullAsZero("ValidKey")).Return(0);
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("config")).Return(StringUtils.SerializeToXmlUsingXmlSerialiser(siteConfig));
            reader.Stub(x => x.GetStringNullAsEmpty("editkey")).Return(editKey);
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpreviewsiteconfig")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("updatepreviewsiteconfig")).Return(readerUpdate);

            Mocks.ReplayAll();

            Assert.AreEqual(Guid.Empty, siteConfig.EditKey);
            var result = (Error)siteConfig.UpdateConfig(readerCreator, false);
            Assert.AreEqual("SiteConfigUpdateInvalidKey", result.Type);
            Assert.AreEqual(Guid.Empty, siteConfig.EditKey);

        }



    }
}
