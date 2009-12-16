using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ComingUp Page object
    /// </summary>
    public class ComingUp : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of posts to skip.";
        private const string _docDnaShow = @"The number of posts to show.";
        private const string _docDnaInterval = @"The interval for the report.";
        private const string _docDnaEntryDate = @"Date of the Statistics Report to look at.";

        /// <summary>
        /// Default constructor for the ComingUp component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ComingUp(IInputContext context)
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

            TryGetPageParams(ref skip, ref show);

            TryCreateComingUpXML(skip, show);
        }

        /// <summary>
        /// Functions generates the TryCreateComingUp XML
        /// </summary>
        /// <param name="skip">Number of posts to skip</param>
        /// <param name="show">Number of posts to show</param>
        public void TryCreateComingUpXML(int skip, int show)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            int recordsCount = 0;
            int total = 0;
            int numberToTryandGet = show + 1;

            XmlElement recommendations = AddElementTag(RootElement, "RECOMMENDATIONS");
            AddAttribute(recommendations, "COUNT", show);
            AddAttribute(recommendations, "SKIPTO", skip);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getacceptedentries"))
            {
                dataReader.AddParameter("siteID", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
                    //the one required
                    for (int i = 0; i < skip; i++)
                    {
                        dataReader.Read();
                    }
                    do
                    {
                        string subject = dataReader.GetStringNullAsEmpty("Subject");

                        int guideStatus = dataReader.GetInt32NullAsZero("GuideStatus");
                        int acceptedStatus = dataReader.GetByteNullAsZero("AcceptedStatus");
                        int originalEntryID = dataReader.GetInt32NullAsZero("OriginalEntryID");
                        int originalh2g2ID = dataReader.GetInt32NullAsZero("Originalh2g2ID");
                        int newEntryID = dataReader.GetInt32NullAsZero("EntryID");
                        int newh2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
                        int subEditorID = dataReader.GetInt32NullAsZero("SubEditorID");
                        int scoutID = dataReader.GetInt32NullAsZero("ScoutID");

		                DateTime dateAllocated = DateTime.MinValue;
                        DateTime dateReturned = DateTime.MinValue;
                        bool existsDateAllocated = !dataReader.IsDBNull("DateAllocated");
                        bool existsDateReturned = !dataReader.IsDBNull("DateReturned");
                        if (existsDateAllocated)
		                {
                            dateAllocated = dataReader.GetDateTime("DateAllocated");
		                }
                        if (existsDateReturned)
		                {
                            dateReturned = dataReader.GetDateTime("DateReturned");
		                }

                        XmlElement recommendation = AddElementTag(recommendations, "RECOMMENDATION");
                        AddTextTag(recommendation, "SUBJECT", subject);
                        AddIntElement(recommendation, "ACCEPTEDSTATUS", acceptedStatus);
                        AddIntElement(recommendation, "GUIDESTATUS", guideStatus);

                        XmlElement original = AddElementTag(recommendation, "ORIGINAL");
                        AddIntElement(original, "ENTRYID", originalEntryID);
                        AddIntElement(original, "H2G2ID", originalh2g2ID);

                        XmlElement edited = AddElementTag(recommendation, "EDITED");
                        AddIntElement(edited, "ENTRYID", newEntryID);
                        AddIntElement(edited, "H2G2ID", newh2g2ID);

                        User user = new User(InputContext);
                        user.AddPrefixedUserXMLBlock(dataReader, scoutID, "scout", recommendation);

                        user = new User(InputContext);
                        user.AddPrefixedUserXMLBlock(dataReader, subEditorID, "subeditor", recommendation);

                        if (existsDateAllocated)
		                {
                            AddDateXml(dateAllocated, recommendation, "DATEALLOCATED");
                        }

                        if (existsDateReturned)
                        {
                            AddDateXml(dateReturned, recommendation, "DATERETURNED");
                        }

                        total++;
                        recordsCount++;

                    } while (dataReader.Read());
                }
            }

            AddAttribute(recommendations, "COUNT", recordsCount);
            AddAttribute(recommendations, "TOTAL", total);
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="skip">number of postings to skip</param>
        /// <param name="show">number to show</param>
        private void TryGetPageParams(ref int skip, ref int show)
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
        }
    }
}
