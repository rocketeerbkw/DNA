using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace BBC.Dna.Objects
{

    /// <remarks/>
    public partial class ExtraInfoCreator
    {
       
        static public XmlElement CreateExtraInfo(string xml)
        {
            XmlElement el = null;
            try
            {
                //strip the extrainfo tags
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xml);
                el = doc.DocumentElement;
            }
            catch { }

            return el;
        }
    }
}
