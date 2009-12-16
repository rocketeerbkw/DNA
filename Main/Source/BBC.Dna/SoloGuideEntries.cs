using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// SoloGuideEntries - A derived DnaComponent object
    /// </summary>
    public class SoloGuideEntries : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of Users to skip.";
        private const string _docDnaShow = @"The number of Users to show.";
        private const string _docDnaAction = @"Action to perform just check solo entries for now.";
        private const string _docDnaUserID = @"User ID of the solo entries count to check and update.";

        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the SoloGuideEntries component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SoloGuideEntries(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();

            int skip = 0;
            int show = 0;
            string action = String.Empty;
            int userID = 0;
            int oldGroupID = 0;
            int newGroupID = 0;
            int refreshGroups = 0;


            TryGetPageParams(ref skip, ref show, ref action, ref userID);

            TryActionSoloGuideEntries(action, userID, ref oldGroupID, ref newGroupID, ref refreshGroups);

            TryGetSoloGuideEntriesXml(skip, show, action, userID, oldGroupID, newGroupID, refreshGroups);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="action"></param>
        /// <param name="userID"></param>
        /// <param name="oldGroupID"></param>
        /// <param name="newGroupID"></param>
        /// <param name="refreshGroups"></param>
        private void TryActionSoloGuideEntries(string action, int userID, ref int oldGroupID, ref int newGroupID, ref int refreshGroups)
        {
            if (action == "checkgroups" && userID > 0 && (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser))
            {
                int count = 0;
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getuserssologuideentrycount"))
                {
                    dataReader.AddParameter("userid", userID);
                    dataReader.AddIntOutputParameter("count");
                    dataReader.Execute();
                    if (dataReader.HasRows)
                    {
                        while (dataReader.Read())
                        {
                        }
                    }
                    dataReader.TryGetIntOutputParameter("count", out count);
                }
                if (count > 0)
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updateprolificscribegroup"))
                    {
                        dataReader.AddParameter("userid", userID);
                        dataReader.AddParameter("solocount", count);
                        dataReader.AddIntOutputParameter("oldgroupid");
                        dataReader.AddIntOutputParameter("newgroupid");
                        dataReader.AddIntOutputParameter("refreshgroups");
                        dataReader.Execute();
                        if (dataReader.HasRows)
                        {
                            if (dataReader.Read())
                            {
                            }
                        }
                        dataReader.NextResult();
                        dataReader.TryGetIntOutputParameter("oldgroupid", out oldGroupID);
                        dataReader.TryGetIntOutputParameter("newgroupid", out newGroupID);
                        dataReader.TryGetIntOutputParameter("refreshgroups", out refreshGroups);
                    }
                }
                if (refreshGroups == 1)
                {
                    InputContext.SendSignal("action=recache-groups&userid=" + userID.ToString());
                }
            }

        }

        /// <summary>
        /// Gets params from the request and validates input params.
        /// </summary>
        /// <param name="skip">Number of items to skip</param>
        /// <param name="show">Number of items to show</param>
        /// <param name="action">Number of items to skip</param>
        /// <param name="userID">User ID</param>
        private void TryGetPageParams(ref int skip, ref int show, ref string action, ref int userID)
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
            action = InputContext.GetParamStringOrEmpty("action", _docDnaAction);
            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
        }

        /// <summary>
        /// Function to get the XML representation of the Solo Guide Entries results
        /// </summary>
        /// <param name="skip">Number of items to skip</param>
        /// <param name="show">Number of items to show</param>
        /// <param name="action">Number of items to skip</param>
        /// <param name="userID">User ID</param>
        /// <param name="oldGroupID"></param>
        /// <param name="newGroupID"></param>
        /// <param name="refreshGroups"></param>
        public void GetSoloGuideEntriesXml(int skip, int show, string action, int userID, int oldGroupID, int newGroupID, int refreshGroups)
        {
            TryGetSoloGuideEntriesXml(skip, show, action, userID, oldGroupID, newGroupID, refreshGroups);
        }

        /// <summary>
        /// Calls the correct stored procedure given the inputs selected
        /// </summary>
        /// <param name="skip">Number of items to skip</param>
        /// <param name="show">Number of items to show</param>
        /// <param name="action">Number of items to skip</param>
        /// <param name="userID">User ID</param>
        /// <param name="oldGroupID"></param>
        /// <param name="newGroupID"></param>
        /// <param name="refreshGroups"></param>
        private void TryGetSoloGuideEntriesXml(int skip, int show, string action, int userID, int oldGroupID, int newGroupID, int refreshGroups)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getsologuideentriescountuserlist"))
            {
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", show + 1);
                dataReader.Execute();

                GenerateSoloGuideEntriesXml(dataReader, skip, show, action, userID, oldGroupID, newGroupID, refreshGroups);
            }
        }

        /// <summary>
        /// With the returned data set generate the XML for the Solo Guide Entries page
        /// </summary>
        /// <param name="dataReader">Data set to turn into XML</param>
        /// <param name="skip">Number of items to skip</param>
        /// <param name="show">Number of items to show</param>
        /// <param name="action">Number of items to skip</param>
        /// <param name="userID">User ID</param>
        /// <param name="oldGroupID"></param>
        /// <param name="newGroupID"></param>
        /// <param name="refreshGroups"></param>
        private void GenerateSoloGuideEntriesXml(IDnaDataReader dataReader, int skip, int show, string action, int userID, int oldGroupID, int newGroupID, int refreshGroups)
        {
            int count = 0;

            XmlElement soloGuideEntriesUserList = AddElementTag(RootElement, "SOLOGUIDEENTRIES");
            AddAttribute(soloGuideEntriesUserList, "SKIP", skip);
            AddAttribute(soloGuideEntriesUserList, "SHOW", show);
            
            XmlElement actionXml = AddElementTag(soloGuideEntriesUserList, "ACTION");
            AddTextTag(actionXml, "ACTION", action);
            AddIntElement(actionXml, "USERID", userID);
            AddIntElement(actionXml, "OLDGROUPID", oldGroupID);
            AddIntElement(actionXml, "NEWGROUPID", newGroupID);
            AddIntElement(actionXml, "REFRESHGROUPS", refreshGroups);

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    XmlElement users = AddElementTag(soloGuideEntriesUserList, "SOLOUSERS");

                    do
                    {
                        int soloUserID = dataReader.GetInt32NullAsZero("UserID");
                        XmlElement soloEditedEntryUser = AddElementTag(users, "SOLOUSER");
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, soloUserID, soloEditedEntryUser);
                        AddIntElement(soloEditedEntryUser, "ENTRY-COUNT", dataReader.GetInt32NullAsZero("Count"));

                        count++;

                    } while (count < show && dataReader.Read());
                    if (dataReader.Read())
                    {
                        AddAttribute(soloGuideEntriesUserList, "MORE", 1);
                    }
                }
            }

            AddAttribute(soloGuideEntriesUserList, "COUNT", count);
        }
    }
}
