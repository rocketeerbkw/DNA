using System.Xml.Serialization;
namespace BBC.Dna.Moderation
{

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=true, TypeName="MODERATION-CLASS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "MODERATION-CLASS")]
    public class ModerationClass
    {
        /// <remarks/>
        [XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0, ElementName="NAME")]
        public string Name { get; set; }

        /// <remarks/>
        [XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1, ElementName="DESCRIPTION")]
        public string Description { get; set; }

        /// <remarks/>
        [XmlElementAttribute(Form = System.Xml.Schema.XmlSchemaForm.Unqualified, Order = 2, ElementName = "LANGUAGE")]
        public string Language { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="CLASSID")]
        public int ClassId { get; set; }
    }
}
