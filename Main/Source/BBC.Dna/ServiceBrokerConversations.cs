using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;


namespace BBC.Dna.Component
{
    /// <summary>
    /// Service Broker Conversations
    /// </summary>
    public class ServiceBrokerConversations : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ServiceBrokerConversations(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("GetServiceBrokerConversationInfo"))
            {

                dataReader.Execute();

                if (!dataReader.HasRows)
                {
                    AddErrorXml("GetServiceBrokerConversationInfo", "There are no outstanding service broker conversations.", null);
                    return;
                }

                while (dataReader.Read())
                {
                    XmlNode serviceBrokerConversationsNode = RootElement.SelectSingleNode("/DNAROOT/SERVICEBROKERCONVERSATIONS");
                    if (serviceBrokerConversationsNode == null)
                    {
                        serviceBrokerConversationsNode = AddElementTag(RootElement, "SERVICEBROKERCONVERSATIONS");
                    }

                    XmlNode conversationNode = AddElementTag(serviceBrokerConversationsNode, "CONVERSATION");

                    AddTextTag(conversationNode, "HANDLE", dataReader.GetGuidAsStringOrEmpty("CONVERSATION_HANDLE"));

                    AddTextTag(conversationNode, "IS_INITIATOR", dataReader.GetBoolean("IS_INITIATOR").ToString());
                    AddTextTag(conversationNode, "LOCAL_SERVICE", dataReader.GetStringNullAsEmpty("LOCAL_SERVICE"));
                    AddTextTag(conversationNode, "FAR_SERVICE", dataReader.GetStringNullAsEmpty("FAR_SERVICE"));
                    AddTextTag(conversationNode, "CONTRACT", dataReader.GetStringNullAsEmpty("CONTRACT"));
                    AddTextTag(conversationNode, "STATE_DESC", dataReader.GetStringNullAsEmpty("STATE_DESC"));
                }

                return;
            }
        }
    }
}
