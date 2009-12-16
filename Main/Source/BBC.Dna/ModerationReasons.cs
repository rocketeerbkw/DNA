using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Creaetes Moderation Failure Reasons XML.
    /// </summary>
    public class ModerationReasons : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerationReasons(IInputContext context)
            : base(context)
        { 
        }

        /// <summary>
        /// Produce Moderation Reasons XML
        /// </summary>
        public override void ProcessRequest()
        {
            //Gets all moderation resons
            GenerateXml(0);
        }

        /// <summary>
        /// Get Moderation Reasons for a particular class only.
        /// </summary>
        /// <param name="moderationClass"></param>
        /// <returns></returns>
        public XmlElement GenerateXml( int moderationClass )
        {
            XmlElement modReasons = AddElementTag(RootElement, "MOD-REASONS");
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmodreasons"))
            {
                if (moderationClass > 0)
                {
                    dataReader.AddParameter("modclassid", moderationClass);
                    AddAttribute(modReasons, "MODCLASSID", moderationClass);
                }
                dataReader.Execute();
                while (dataReader.Read())
                {
                    XmlElement modReason = AddElementTag(modReasons, "MOD-REASON");
                    AddAttribute(modReason, "REASONID", dataReader.GetInt32NullAsZero("reasonid"));
                    AddAttribute(modReason, "DISPLAYNAME", dataReader.GetStringNullAsEmpty("displayname"));
                    AddAttribute(modReason, "EMAILNAME", dataReader.GetStringNullAsEmpty("emailname"));
                    AddAttribute(modReason, "EDITORSONLY", dataReader.GetTinyIntAsInt("editorsonly"));
                }
            }

            return modReasons;
        }
    }
}
