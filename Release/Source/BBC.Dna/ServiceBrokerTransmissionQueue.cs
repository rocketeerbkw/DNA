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
    public class ServiceBrokerTransmissionQueue : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ServiceBrokerTransmissionQueue(IInputContext context)
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

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("GetServiceBrokerTransmissionQueueInfo"))
            {

                dataReader.Execute();

                XmlNode transmissionQueueNode = RootElement.SelectSingleNode("/DNAROOT/SERVICEBROKERTRANSMISSIONQUEUE");
                if (transmissionQueueNode == null)
                {
                    transmissionQueueNode = AddElementTag(RootElement, "SERVICEBROKERTRANSMISSIONQUEUE");
                }

                while (dataReader.Read())
                {
                    XmlNode messageNode = AddElementTag(transmissionQueueNode, "MESSAGE");

                    AddTextTag(messageNode, "FROM_SERVICE_NAME", dataReader.GetStringNullAsEmpty("FROM_SERVICE_NAME"));
                    AddTextTag(messageNode, "TO_SERVICE_NAME", dataReader.GetStringNullAsEmpty("TO_SERVICE_NAME"));
                    AddTextTag(messageNode, "SERVICE_CONTRACT_NAME", dataReader.GetStringNullAsEmpty("SERVICE_CONTRACT_NAME"));
                    AddTextTag(messageNode, "TRANSMISSION_STATUS", dataReader.GetStringNullAsEmpty("TRANSMISSION_STATUS"));
                }
            }
        }
    }
}
