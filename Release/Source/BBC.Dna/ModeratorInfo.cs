using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Class for Moderator Info
    /// </summary>
    public class ModeratorInfo : DnaInputComponent
    {
        /// <summary>
        /// Default construtor
        /// </summary>
        /// <param name="context">The inputcontext to create the object from</param>
        public ModeratorInfo(IInputContext context)
            : base(context)
        {
            _moderatorClasses.Clear();
        }


        private List<int> _moderatorClasses = new List<int>();

        /// <summary>
        /// Accessor for moderation classes
        /// </summary>
        public List<int> ModeratorClasses
        {
            get { return _moderatorClasses; }
            set { _moderatorClasses = value; }
        }

        /// <summary>
        /// Function to get the XML representation of the Moderator Info
        /// </summary>
        /// <param name="userID">userID.</param>
        public void GetModeratorInfo(int userID)
        {
            XmlElement moderator = AddElementTag(RootElement, "MODERATOR");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoderatorinfo"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        int isModerator = dataReader.GetInt32NullAsZero("IsModerator");
                        AddAttribute(moderator, "ISMODERATOR", isModerator);

                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, userID, moderator);

                        int curClassID = 0;
                        int curSiteID = 0;

                        XmlElement classBuilder = AddElementTag(moderator, "CLASSES");
                        XmlElement siteBuilder = AddElementTag(moderator, "SITES");

                        do
                        {
                            int classID = dataReader.GetInt32NullAsZero("SiteClassID");
                            int siteID = dataReader.GetInt32NullAsZero("SiteID");

                            bool isNullClassID = dataReader.IsDBNull("SiteClassID");
                            bool isNullSiteID = dataReader.IsDBNull("SiteID");

                            if (!isNullClassID && curClassID != classID)
                            {
                                AddIntElement(classBuilder, "CLASSID", classID);
                                curClassID = classID;
                                _moderatorClasses.Add(classID);
                            }

                            if (!isNullSiteID && curSiteID != siteID)
                            {
                                XmlElement site = AddElementTag(siteBuilder, "SITE");
                                if (isNullClassID)
                                {
                                    AddAttribute(site, "SITEID", siteID);
                                }
                                else
                                {
                                    AddAttribute(site, "SITEID", siteID);
                                    AddAttribute(site, "CLASSID", classID);
                                }
                                curSiteID = siteID;
                            }
                        } while (dataReader.Read());
                    }
                }
            }
        }
    }
}
