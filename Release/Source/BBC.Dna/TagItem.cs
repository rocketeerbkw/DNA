using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    class TagItem : DnaInputComponent
    {
	    // First things first make sure things are clean!
	    //int _itemID = 0;
	    //int _itemType = 0;
	    int _threadID = 0;
        int _siteID = 0;
        int _userID = 0;
        string _subject = String.Empty;

        bool _isInitialised = false;

        /// <summary>
        /// Default Constructor for the TagItem object
        /// </summary>
        public TagItem(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Setup the initial items for the threadID
        /// </summary>
        /// <param name="threadID"></param>
        /// <param name="siteID"></param>
        /// <param name="userID"></param>
        /// <param name="subject"></param>
        /// <param name="getTagLimits"></param>
        /// <returns></returns>
        public bool InitialiseFromThreadId(int threadID, int siteID, int userID, string subject, bool getTagLimits)
        {
            _threadID = threadID;
            _siteID = siteID;
            _userID = userID;

            if (subject == String.Empty)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getthreaddetails"))
                {
                    dataReader.AddParameter("threadid", threadID);
                    dataReader.Execute();

                    // Check to see if we found anything
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        _subject = dataReader.GetStringNullAsEmpty("FirstSubject");
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            else
            {
                _subject = subject;
            }

            XmlElement itemDetails = AddElementTag(RootElement, "ITEM");
            AddAttribute(itemDetails, "ID", threadID);
            AddAttribute(itemDetails, "TYPE", "THREAD");
            AddAttribute(itemDetails, "SUBJECT", StringUtils.EscapeAllXmlForAttribute(_subject));

            _isInitialised = true;

            if (getTagLimits)
            {
                GetTagLimitsForThread();
            }
            return true;
        }

        private void GetTagLimitsForThread()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public bool GetAllNodesTaggedForItem()
        {
            if (_isInitialised)
            {
            }
            return false;
        }
    }
}
