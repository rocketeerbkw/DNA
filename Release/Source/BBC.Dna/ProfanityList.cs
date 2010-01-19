using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using BBC.Dna.Data;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// ProfanityList.
    /// List of profanities for a mod class.
    /// </summary>
    public class ProfanityList : DnaInputComponent
    {

        /// <summary>
        /// Default Constructor for the ProfanityList object
        /// </summary>
        public ProfanityList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Function to return all the profanities
        /// </summary>
        public void GetProfanities()
        {
            string storedProcedureName = @"profanitiesgetall";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.Execute();

                GetProfanityXml(dataReader);
            }

        }

        /// <summary>
        /// Function to get the XML representation of the member list results (from cache if available)
        /// </summary>
        public void GetProfanityXml(IDnaDataReader dataReader)
        {
	        int currentModClassID = 1;
	        int modClassID = 1;

            RootElement.RemoveAll();
            XmlElement profanityLists = AddElementTag(RootElement, "PROFANITY-LISTS");
            if (dataReader.HasRows)
            {
                bool exitOuterLoop = false;
                do
                {
                    bool exitInnerLoop = false;
                    XmlElement profanityList = AddElementTag(profanityLists, "PROFANITY-LIST");
                    modClassID = dataReader.GetInt32NullAsZero("ModClassID");
                    currentModClassID = modClassID;
                    AddAttribute(profanityList, "MODCLASSID", modClassID);

                    do
                    {
                        string profanityText = dataReader.GetStringNullAsEmpty("Profanity");
                        int profanityID = dataReader.GetInt32NullAsZero("ProfanityID");
                        int refer = dataReader.GetInt32NullAsZero("Refer");

                        XmlElement profanity = AddTextTag(profanityList, profanityText, "Profanity");
                        AddAttribute(profanity, "ID", profanityID);
                        AddAttribute(profanity, "REFER", refer);

                        if (!dataReader.Read())
                        {
                            exitOuterLoop = true;
                            exitInnerLoop = true;
                            break;
                        }

                        modClassID = dataReader.GetInt32NullAsZero("ModClassID");
                        if (modClassID != currentModClassID)
                        {
                            exitInnerLoop = true;
                        }
                    }
                    while (!exitInnerLoop);
                } while (!exitOuterLoop);
            }
        }

        /// <summary>
        /// Updates the profanity list
        /// </summary>
        /// <param name="profanityID">Profanity to update</param>
        /// <param name="profanity">Updated profanity</param>
        /// <param name="modClassID">Mod class profanity resides in</param>
        /// <param name="refer">whether the profanity is a refer or block</param>
        public void UpdateProfanity(int profanityID, string profanity, int modClassID, int refer)
        {
            string storedProcedureName = @"profanityupdateprofanity";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("profanityid", profanityID)
                    .AddParameter("profanity", profanity)
                    .AddParameter("modclassid", modClassID)
                    .AddParameter("refer", refer);

                dataReader.Execute();
            }
        }

        /// <summary>
        /// Deletes the given profanity
        /// </summary>
        /// <param name="profanityID">ID of the profanity to delete</param>
        public void DeleteProfanity(int profanityID)
        {
            string storedProcedureName = @"profanitydeleteprofanity";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("profanityid", profanityID);

                dataReader.Execute();
            }
        }
        /// <summary>
        /// Adds a new profanity
        /// </summary>
        /// <param name="profanity">Profanity to add</param>
        /// <param name="modClassID">Particular mod class in question</param>
        /// <param name="refer">whether the profanity is a refer or block</param>
        public void AddProfanity(string profanity, int modClassID, int refer)
        {
            string storedProcedureName = @"profanityaddprofanity";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("profanity", profanity)
                    .AddParameter("modclassid", modClassID)
                    .AddParameter("refer", refer);

                dataReader.Execute();
            }
        }
    }
}