using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;


namespace BBC.Dna.Component
{
    /// <summary>
    /// Class to store the RefereeList Details
    /// </summary>
    public class RefereeList : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the RefereeList component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public RefereeList(IInputContext context)
            : base(context)

        {
        }

        /// <summary>
        /// 
        /// </summary>
        public override void ProcessRequest()
        {
            FetchTheList();
        }

        /// <summary>
        /// Fetches the list
        /// </summary>
        private void FetchTheList()
        {
            XmlElement refereeList = AddElementTag(RootElement, "REFEREE-LIST");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchRefereeList"))
            {
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    int userID = 0;
                    int siteID = 0;
                    int prevUserID = -1;
                    XmlElement referee = AddElementTag(refereeList, "REFEREE");
                    do
                    {
                        userID = dataReader.GetInt32NullAsZero("UserID");
                        siteID = dataReader.GetInt32NullAsZero("SiteID");
                        string userName = dataReader.GetStringNullAsEmpty("UserName");

                        if (userID != prevUserID)
                        {
                            if (prevUserID != -1)
                            {
                                referee = AddElementTag(refereeList, "REFEREE");
                            }

                            XmlElement user = AddElementTag(referee, "USER");
                            AddIntElement(user, "USERID", userID);
                            AddTextTag(user, "USERNAME", userName);
                            prevUserID = userID;
                        }
                        AddIntElement(referee,"SITEID", siteID);
                    }
                    while (dataReader.Read());
                }
            }
        }
    }
}