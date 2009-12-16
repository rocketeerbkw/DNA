namespace BBC.Dna.Objects
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "FORUMSOURCE")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "FORUMSOURCE")]

    public partial class ForumSourceReviewForum : ForumSource
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(ElementName = "REVIEWFORUM")]
        public ReviewForum ReviewForum
        {
            get;
            set;
        }

       

    }

}
