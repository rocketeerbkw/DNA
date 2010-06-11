using System;
using System.CodeDom.Compiler;
using System.Xml.Serialization;

namespace BBC.Dna.Sites
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [XmlType(AnonymousType = true, TypeName = "V2_BOARDS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "V2_BOARDS")]
    public class SiteConfigV2Board
    {
        public SiteConfigV2Board()
        {
            Footer = new SiteConfigV2BoardsFooter();
            Modules = new SiteConfigV2BoardsModules();
            HeaderColour = String.Empty;
            BannerSsi = String.Empty;
            HorizontalNavSsi = String.Empty;
            LeftNavSsi = String.Empty;
            WelcomeMessage = String.Empty;
            AboutMessage = String.Empty;
            OpenclosetimesText = String.Empty;
            TopicLayout = String.Empty;
            CssLocation = String.Empty;
            EmoticonLocation = String.Empty;
        }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "HEADER_COLOUR")]
        public string HeaderColour { get; set; }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "BANNER_SSI")]
        public string BannerSsi { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "HORIZONTAL_NAV_SSI")]
        public string HorizontalNavSsi { get; set; }

        /// <remarks/>
        [XmlElement(Order = 3, ElementName = "LEFT_NAV_SSI")]
        public string LeftNavSsi { get; set; }

        /// <remarks/>
        [XmlElement(Order = 4, ElementName = "WELCOME_MESSAGE")]
        public string WelcomeMessage { get; set; }

        /// <remarks/>
        [XmlElement(Order = 5, ElementName = "ABOUT_MESSAGE")]
        public string AboutMessage { get; set; }

        /// <remarks/>
        [XmlElement(Order = 6, ElementName = "OPENCLOSETIMES_TEXT")]
        public string OpenclosetimesText { get; set; }

        /// <remarks/>
        [XmlElement(Order = 7, ElementName = "FOOTER")]
        public SiteConfigV2BoardsFooter Footer { get; set; }

        /// <remarks/>
        [XmlElement(Order = 8, ElementName = "MODULES")]
        public SiteConfigV2BoardsModules Modules { get; set; }

        /// <remarks/>
        [XmlElement(Order = 9, ElementName = "RECENTDISCUSSIONS")]
        public bool Recentdiscussions { get; set; }

        /// <remarks/>
        [XmlElement(Order = 10, ElementName = "SOCIALTOOLBAR")]
        public bool Socialtoolbar { get; set; }

        /// <remarks/>
        [XmlElement(Order = 11, ElementName = "TOPICLAYOUT")]
        public string TopicLayout { get; set; }

        /// <remarks/>
        [XmlElement(Order = 12, ElementName = "CSS_LOCATION")]
        public string CssLocation { get; set; }

        /// <remarks/>
        [XmlElement(Order = 13, ElementName = "EMOTICON_LOCATION")]
        public string EmoticonLocation { get; set; }
    }
}