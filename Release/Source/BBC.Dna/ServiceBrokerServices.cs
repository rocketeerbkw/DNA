using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Service Broker Services
    /// </summary>
    public class ServiceBrokerServices : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ServiceBrokerServices(IInputContext context)
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

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("GetServiceBrokerServiceInfo"))
            {

                dataReader.Execute();

                if (!dataReader.HasRows)
                {
                    AddErrorXml("GetServiceBrokerConversationInfo", "There are no service broker services.", null);
                    return;
                }

                while (dataReader.Read())
                {
                    XmlNode serviceBrokerServicesNode = RootElement.SelectSingleNode("/DNAROOT/SERVICEBROKERSERVICES");
                    if (serviceBrokerServicesNode == null)
                    {
                        serviceBrokerServicesNode = AddElementTag(RootElement, "SERVICEBROKERSERVICES");
                    }

                    XmlNode serviceNode = AddElementTag(serviceBrokerServicesNode, "SERVICE");

                    AddTextTag(serviceNode, "NAME", dataReader.GetStringNullAsEmpty("SERVICENAME"));

                    XmlNode queueNode = AddElementTag(serviceNode, "QUEUE");
                    AddTextTag(queueNode, "NAME", dataReader.GetString("QUEUENAME"));
                    AddTextTag(queueNode, "ACTIVATION_PROCEDURE", dataReader.GetStringNullAsEmpty("ACTIVATION_PROCEDURE"));
                    AddTextTag(queueNode, "IS_ACTIVATION_ENABLED", dataReader.GetBoolean("IS_ACTIVATION_ENABLED").ToString());
                    AddTextTag(queueNode, "IS_RECEIVE_ENABLED", dataReader.GetBoolean("IS_RECEIVE_ENABLED").ToString());
                    AddTextTag(queueNode, "IS_ENQUEUE_ENABLED", dataReader.GetBoolean("IS_ENQUEUE_ENABLED").ToString());
                    AddTextTag(queueNode, "IS_RETENTION_ENABLED", dataReader.GetBoolean("IS_RETENTION_ENABLED").ToString()); 
                }

                return;
            }
        }
    }
}
