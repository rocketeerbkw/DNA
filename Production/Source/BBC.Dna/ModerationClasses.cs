using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class for generating User Moderation Classes XML.
    /// </summary>
    public class ModerationClasses : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerationClasses(IInputContext context)
            : base(context)
        { }

        /// <summary>
        /// Produce User Moderation User Statuses XML from database.
        /// Caching the XML would be a good idea before this is included on lots of moderation pages.
        /// </summary>
        public override void ProcessRequest()
        {
            XmlNode userStatusesXml = AddElementTag(RootElement, "MODERATION-CLASSES");
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getmoderationclasslist"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    XmlNode userStatusXml = AddElementTag(userStatusesXml, "MODERATION-CLASS");
                    AddAttribute(userStatusXml, "CLASSID", reader.GetInt32NullAsZero("modclassid"));
                    AddTextTag(userStatusXml, "NAME", reader.GetStringNullAsEmpty("name"));
                    AddTextTag(userStatusXml, "DESCRIPTION", reader.GetStringNullAsEmpty("description"));
                }
            }
        }
    }
}
