using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the SystemMessageMailbox object
    /// </summary>
    public class SystemMessageMailbox : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of posts to skip.";
        private const string _docDnaShow = @"The number of posts to show.";
        private const string _docDnaUserID = @"The userid for the page if editor or super user.";
        private const string _docDnaCommand = @"The command action if there is one. Delete message is the only action supported.";
        private const string _docDnaMsgID = @"The messageID of the message to Delete";

        /// <summary>
        /// Default constructor for the SystemMessageMailbox component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SystemMessageMailbox(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int skip = 0;
            int show = 0;
            int enteredUserID = 0;
            string command = String.Empty;
            int toDeleteMessageID = 0;

            TryGetPageParams(ref skip, ref show, ref enteredUserID, ref command, ref toDeleteMessageID);

            TryDeleteMessage(command, toDeleteMessageID);

            TryCreateSystemMessageMailboxXML(skip, show, enteredUserID);
        }

        private void TryDeleteMessage(string command, int toDeleteMessageID)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            string action = String.Empty;
            XmlElement commandTag = AddElementTag(RootElement, "CMD");

            if (command == "delete")
            {
                action = "DELETE";
                DeleteSystemMailboxMessage(toDeleteMessageID, commandTag);
            }
            else
            {
                action = "NONE";
            }

            AddAttribute(commandTag, "ACTION", action);
            AddAttribute(commandTag, "RESULT", '1');
        }

        private void DeleteSystemMailboxMessage(int toDeleteMessageID, XmlElement parent)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("deletednasystemmessage"))
            {
                dataReader.AddParameter("msgid", toDeleteMessageID);
                dataReader.Execute();

                // Go through the results adding the data to the XML
                if (dataReader.HasRows && dataReader.Read())
                {
                    do
                    {
                        AddMessageXML(dataReader, parent);

                    } while (dataReader.Read());
                }
            }
        }

        private void AddMessageXML(IDnaDataReader dataReader, XmlElement parent)
        {
            XmlElement message = AddElementTag(parent, "MESSAGE");
            AddAttribute(message, "MSGID", dataReader.GetInt32NullAsZero("MsgID"));
            AddAttribute(message, "SITEID", dataReader.GetInt32NullAsZero("SiteID"));
            AddTextTag(message, "BODY", dataReader.GetStringNullAsEmpty("MESSAGEBODY"));
            AddDateXml(dataReader, message, "DatePosted", "DATEPOSTED");
        }

        /// <summary>
        /// Functions generates the SystemMessageMailbox XML
        /// </summary>
        /// <param name="skip">Number of posts to skip</param>
        /// <param name="show">Number of posts to show</param>
        /// <param name="enteredUserID">Entered User ID, if super user or editor</param>
        public void TryCreateSystemMessageMailboxXML(int skip, int show, int enteredUserID)
        {
            //Must be logged in.
            if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be logged in to view the System Message Mail box.", RootElement);
                return;
            }
            int userID = InputContext.ViewingUser.UserID;

            if (enteredUserID != 0 && (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser))
            {
                userID = enteredUserID;
            }

            int totalCount = 0;

            XmlElement systemMessageMailbox = AddElementTag(RootElement, "SYSTEMMESSAGEMAILBOX");
            AddAttribute(systemMessageMailbox, "USERID", userID);
            AddAttribute(systemMessageMailbox, "SKIPTO", skip);
            AddAttribute(systemMessageMailbox, "SHOW", show);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getuserssystemmessagemailbox"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", show);
                dataReader.Execute();

                // Go through the results adding the data to the XML
                if (dataReader.HasRows && dataReader.Read())
                {
                    totalCount = dataReader.GetInt32NullAsZero("TotalCount");
                    do
                    {
                        AddMessageXML(dataReader, systemMessageMailbox);

                    } while (dataReader.Read());
                }
            }

            AddAttribute(systemMessageMailbox, "TOTALCOUNT", totalCount);
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="skip">number of messages to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="enteredUserID">Entered User ID, if super user or editor</param>
        /// <param name="command">Command action if there is one - Delete message</param>
        /// <param name="toDeleteMessageID">To Delete message ID</param>
        private void TryGetPageParams(ref int skip, ref int show, ref int enteredUserID, ref string command, ref int toDeleteMessageID)
        {
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 0)
            {
                skip = 0;
            }

            enteredUserID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);

            command = InputContext.GetParamStringOrEmpty("cmd", _docDnaCommand);

            toDeleteMessageID = InputContext.GetParamIntOrZero("msgid", _docDnaMsgID);
        }
    }
}
