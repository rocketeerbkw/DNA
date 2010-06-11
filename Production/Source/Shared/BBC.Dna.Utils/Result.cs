namespace BBC.Dna.Utils
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "RESULT")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "RESULT")]
    public class Result : BaseResult
    {
        public Result()
        {
        }

        public Result(string type, string message)
        {
            Type = type;
            Message = message;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "MESSAGE")]
        public string Message
        {
            get;
            set;
        }
        public override bool IsError() { return false; }
    }
}
