using BBC.Dna.Data;
using System;
namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="PAGEUI")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace="", IsNullable=false, ElementName="PAGEUI")]
    public partial class PageUi
    {
        public PageUi()
        {
            Initialise(0);
        }

        public PageUi(int userId)
        {
            Initialise(userId);
        }

        private void Initialise(int userId)
        {
            SiteHome = new PageUiElement("/", true);
            DontPanic = new PageUiElement("/DONTPANIC", true);
            Search = new PageUiElement("/Search", true);
            if (userId > 0)
            {
                MyHome = new PageUiElement("/U" + userId.ToString(), true);
                Register = new PageUiElement("", true);
                MyDetails = new PageUiElement("/UserDetails", true);
                Logout = new PageUiElement("/Logout", true);

            }
            else
            {
                MyHome = new PageUiElement("", false);
                Register = new PageUiElement("/Register", true);
                MyDetails = new PageUiElement("/UserDetails", false);
                Logout = new PageUiElement("", false);
            }
            EditPage = new PageUiElement("", false);
            RecommendEntry = new PageUiElement("", false);
            EntrySubbed = new PageUiElement("", false);
            Discuss = new PageUiElement("", false);


            // Generate the random number for the banner ad?
            Random rnd = new Random((int)DateTime.Now.Ticks);
            int random = rnd.Next();

            Banners = new System.Collections.Generic.List<PageUiBanner>();
            Banners.Add(new PageUiBanner()
            {
                Name = "main",
                Seed = random,
                Section = "frontpage"
            });
            Banners.Add(new PageUiBanner()
            {
                Name = "small",
                Seed = random,
                Section = "frontpage"
            });

        }

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("DISCUSS", typeof(PageUiElement))]
        public PageUiElement Discuss { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("DONTPANIC", typeof(PageUiElement))]
        public PageUiElement DontPanic { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("EDITPAGE", typeof(PageUiElement))]
        public PageUiElement EditPage { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("ENTRY-SUBBED", typeof(PageUiElement))]
        public PageUiElement EntrySubbed { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("LOGOUT", typeof(PageUiElement))]
        public PageUiElement Logout { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("MYDETAILS", typeof(PageUiElement))]
        public PageUiElement MyDetails { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("MYHOME", typeof(PageUiElement))]
        public PageUiElement MyHome { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("RECOMMEND-ENTRY", typeof(PageUiElement))]
        public PageUiElement RecommendEntry { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("REGISTER", typeof(PageUiElement))]
        public PageUiElement Register { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("SEARCH", typeof(PageUiElement))]
        public PageUiElement Search { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("SITEHOME", typeof(PageUiElement))]
        public PageUiElement SiteHome { get; set; }

        [System.Xml.Serialization.XmlElementAttribute("BANNER", typeof(PageUiBanner))]
        public System.Collections.Generic.List<PageUiBanner> Banners
        {
            get;
            set;
        } 
        #endregion

        static public PageUi GetPageUi(IDnaDataReaderCreator creator, Article guide, BBC.Dna.Objects.User viewingUser)
        {
            PageUi pageUi = new PageUi(viewingUser.UserId);

            // Update the edit link if the user is allowed
            bool editable = false;
            string editableLink = "/UserEdit";
            if (!guide.IsDeleted && guide.HasEditPermission(viewingUser))
            {
                editable = true;
                editableLink += guide.H2g2Id.ToString();
            }

            // Now set the recommended link
            string recommendLink = "RecommendEntry?h2g2ID=" + guide.H2g2Id.ToString() + "&mode=POPUP";
            bool recommendable = guide.ArticleInfo.Status.Type == 3 &&
                                 viewingUser.UserId > 0 &&
                                 (viewingUser.IsEditor || viewingUser.IsScout);

            // If this is a sub editors copy of a recommended entry, and the viewer is
            // the sub editor, then give them a button to say they have finished subbing
            // it and want to return the entry to the editors
            string subbedLink = "SubmitSubbedEntry?h2g2ID=" + guide.ArticleInfo.H2g2Id.ToString() + "&mode=POPUP";
            bool subeditor = viewingUser.UserId > 0 &&
                             (viewingUser.IsEditor || viewingUser.IsSubEditor) &&
                             guide.CheckIsSubEditor(viewingUser, creator);

            // Setup the discuss UI
            string discussLink = "AddThread?forum=" + guide.ArticleInfo.ForumId.ToString() + "&article=" + guide.ArticleInfo.H2g2Id.ToString();
            bool discussable = !guide.IsDeleted &&
                               guide.ArticleInfo.ForumId > 0 &&
                               viewingUser.UserId > 0;

            pageUi.EditPage = new PageUiElement(editableLink, editable);
            pageUi.RecommendEntry = new PageUiElement(recommendLink, recommendable);
            pageUi.EntrySubbed = new PageUiElement(subbedLink, subeditor);
            pageUi.Discuss = new PageUiElement(discussLink, discussable);
            pageUi.SiteHome = new PageUiElement("/", true);
            pageUi.DontPanic = new PageUiElement("/DONTPANIC", true);
            pageUi.Search = new PageUiElement("/Search", true);


            return pageUi;
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="PAGEUIBANNER")]
    public partial class PageUiBanner
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "NAME")]
        public string Name { get; set; }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName="SEED")]
        public int Seed { get; set; }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName="SECTION")]
        public string Section { get; set; }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    public partial class PageUiElement
    {
        public PageUiElement(string linkHint, bool visible)
        {
            LinkHint = linkHint;
            Visibile = (byte)(visible?1:0);
        }

        public PageUiElement() { }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "VISIBLE")]
        public byte Visibile
        {
            get;
            set;
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName="LINKHINT")]
        public string LinkHint{get;set;}
    }
}
