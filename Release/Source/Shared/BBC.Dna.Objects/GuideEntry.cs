using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Utils;
using BBC.Dna.Api;

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
        static public XmlElement CreateGuideEntry(string text, int hiddenStatus, GuideEntryStyle style, int canRead)
        {

            XmlDocument doc = new XmlDocument();
            if (hiddenStatus > 0 && canRead == 0)
            {
                doc.LoadXml("<GUIDE><BODY>This article has been hidden pending moderation.</BODY></GUIDE>");
            }
            else
            {
                try
                {
                    switch (style)
                    {
                        case GuideEntryStyle.GuideML:
                            text = text.Trim();
                            text = Entities.ReplaceEntitiesWithNumericValues(text);
                            //text = HtmlUtils.ReplaceCRsWithBRs(text);
                            text = HtmlUtils.EscapeNonEscapedAmpersands(text);
                            doc.PreserveWhitespace = true;
                            doc.LoadXml(text);
                            AdjustFootnotes(doc);
                            //doc["GUIDE"]["BODY"].InnerXml = HtmlUtils.ReplaceCRsWithBRs(doc["GUIDE"]["BODY"].InnerXml);
                            break;

                        case GuideEntryStyle.PlainText:
                            doc.LoadXml(StringUtils.PlainTextToGuideML(text));
                            break;

                        case GuideEntryStyle.Html:
                            doc.LoadXml("<GUIDE><BODY><PASSTHROUGH><![CDATA[" + text + "]]></PASSTHROUGH></BODY></GUIDE>");
                            break;

                        default:
                            goto case GuideEntryStyle.GuideML;//null styles are generally guideml...
                        //throw new NotImplementedException("Don't know what type of entry we've got here!");
                    }
                }
                catch (XmlException e)
                {
                    //If something has gone wrong log stuff
                    DnaDiagnostics.Default.WriteExceptionToLog(e);

                    throw new ApiException("GuideML Transform Failed", e);
                }
            }

            return doc.DocumentElement;
        }

        private static void AdjustFootnotes(XmlDocument doc)
        {
            XmlNodeList footnotes = doc.SelectNodes("//FOOTNOTE");
            int index = 1;
            foreach (XmlNode footnote in footnotes)
            {
                ((XmlElement)footnote).SetAttribute("INDEX", index.ToString());
                index++;
            }
        }
    }

    public enum GuideEntryStyle
    {
        GuideML = 1,
        PlainText = 2,
        Html = 3
    }
}
