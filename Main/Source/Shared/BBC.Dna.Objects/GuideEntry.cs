using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects
{

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "GUIDE")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "GUIDE")]
    public partial class GuideEntry
    {

        /// <summary>
        /// Creates the guide entry from the given text and relvant attributes
        /// </summary>
        /// <param name="xml"></param>
        /// <param name="hiddenStatus"></param>
        /// <param name="style"></param>
        /// <param name="editing"></param>
        /// <returns></returns>
        static public XmlElement CreateGuideEntry(string text, int hiddenStatus, GuideEntryStyle style)
        {

            XmlDocument doc = new XmlDocument();
            if (hiddenStatus > 0)
            {
                doc.LoadXml("<GUIDE><BODY>This article has been hidden pending moderation</BODY></GUIDE>");
            }
            else
            {

                switch (style)
                {
                    case GuideEntryStyle.GuideML:
                        doc.LoadXml(Entities.GetEntities() + text);
                        break;

                    case GuideEntryStyle.PlainText:
                        doc.LoadXml("<GUIDE><BODY>" + StringUtils.PlainTextToGuideML(text) + "</BODY></GUIDE>");
                        break;

                    case GuideEntryStyle.Html:
                        doc.LoadXml("<GUIDE><BODY><PASSTHROUGH><![CDATA[" + text + "]]></PASSTHROUGH></BODY></GUIDE>");
                        break;

                    default:
                        goto case GuideEntryStyle.GuideML;//null styles are generally guideml...
                    //throw new NotImplementedException("Don't know what type of entry we've got here!");
                }


            }

            return doc.DocumentElement;
        }
    }

    public enum GuideEntryStyle
    {
        GuideML = 1,
        PlainText = 2,
        Html = 3
    }
}
