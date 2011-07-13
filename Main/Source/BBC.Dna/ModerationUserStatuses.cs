using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// Class for generating User Moderation Statuses XML.
    /// </summary>
    public class ModerationUserStatuses : DnaInputComponent
    {

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerationUserStatuses(IInputContext context)
            : base(context)
        { }

        /// <summary>
        /// Produce User Moderation User Statuses XML from database.
        /// Caching the XML would be a good idea before this is included on lots of moderation pages.
        /// </summary>
        public override void ProcessRequest()
        {
            XmlNode userStatusesXml = AddElementTag(RootElement,"USER-STATUSES");
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getuserstatuses"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    XmlNode userStatusXml = AddElementTag(userStatusesXml,"USER-STATUS");
                    AddAttribute(userStatusXml, "USERSTATUSID", reader.GetInt32NullAsZero("userstatusid"));
                    AddTextTag(userStatusXml, "USERSTATUSDESCRIPTION", reader.GetStringNullAsEmpty("userstatusdescription"));
                }
            }
        }

        /// <summary>
        /// Returns Moderation Status Description Given Status Id.
        /// </summary>
        /// <param name="ModStatusId"></param>
        /// <returns></returns>
        public static String GetDescription(int ModStatusId)
        {
            switch ( ModStatusId )
            {
                case 0:
                    return "STANDARD";
                case 1:
                    return "PREMODERATED";
                case 2:
                    return "POSTMODERATED";
                case 3:
                    return "SENDFORREVIEW";
                case 4:
                    return "RESTRICTED";
                default:
                    return "";
            }
        }
    }
}
