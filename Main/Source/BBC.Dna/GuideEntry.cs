

using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    ///TODO: Replace with BBC.Dna.Objects.Article and GuideEntry
    /// <summary>
    /// The guide entry setup class. Used to help the initialisation of the guideentries.
    /// It has all the setting set to thier defaults.
    /// </summary>
    public class GuideEntrySetup
    {
        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="h2g2ID">The id of the guid entry you want to view</param>
        public GuideEntrySetup(int h2g2ID)
        {
            // Set the fielsds from the params.
            _h2g2ID = h2g2ID;
        }

        // The fields and thier defaults
        private int _h2g2ID = 0;
        private bool _showEntryData = false;
        private bool _showPageAuthors = false;
        private bool _showReferences = false;
        private bool _safeToCache = false;
        private bool _showHidden = false;
        private bool _profanityTriggered = false;
        private bool _nonAllowedURLsTriggered = false;
        private bool _isBeingEdited = false;

        #region Properties
        /// <summary>
        /// The h2g2 ID property
        /// Set this to state whicxh entry to get from the database
        /// </summary>
        public int h2g2ID
        {
            get { return _h2g2ID; }
            set { _h2g2ID = value; }
        }

        /// <summary>
        /// The show entry data property.
        /// Set this to determine whether or not to include entry data in the XML.
        /// </summary>
        public bool ShowEntryData
        {
            get { return _showEntryData; }
            set { _showEntryData = value; }
        }

        /// <summary>
        /// The show page authors property
        /// Set this to determine whether or not to include the page authors in the XML.
        /// </summary>
        public bool ShowPageAuthors
        {
            get { return _showPageAuthors; }
            set { _showPageAuthors = value; }
        }

        /// <summary>
        /// The show References property
        /// Set this to determine whether or not to include References in the XML.
        /// </summary>
        public bool ShowReferences
        {
            get { return _showReferences; }
            set { _showReferences = value; }
        }

        /// <summary>
        /// The safe to cache property
        /// Set this to determine whether or not the guide entry is safe to be cached.
        /// </summary>
        public bool SafeToCache
        {
            get { return _safeToCache; }
            set { _safeToCache = value; }
        }

        /// <summary>
        /// The show hidden property
        /// Set this to determine whether or not to display hidden entries.
        /// </summary>
        public bool ShowHidden
        {
            get { return _showHidden; }
            set { _showHidden = value; }
        }

        /// <summary>
        /// The profanity triggered property
        /// Set this if a profanity was triggered when getting the information from the user.
        /// </summary>
        public bool ProfanityTriggered
        {
            get { return _profanityTriggered; }
            set { _profanityTriggered = value; }
        }

        /// <summary>
        /// The non allowed urls triggered property
        /// Set this if a non allowed url was triggered when getting the information from the user.
        /// </summary>
        public bool NonAllowedURLsTriggered
        {
            get { return _nonAllowedURLsTriggered; }
            set { _nonAllowedURLsTriggered = value; }
        }

        /// <summary>
        /// The being edited property
        /// Set this if the guide entry is in editing mode.
        /// </summary>
        public bool IsBeingEdited
        {
            get { return _isBeingEdited; }
            set { _isBeingEdited = value; }
        }
        #endregion
    }

    /// <summary>
    /// The GuideEntry object
    /// </summary>
    public class GuideEntry : DnaInputComponent
    {
        /// <summary>
        /// Enumeration of Guide Type
        /// </summary>
        public enum GuideEntryType
        {
            /// <summary>
            /// Start of Article Type numbers
            /// </summary>
            TYPEARTICLE = 1,
            /// <summary>
            /// End of ArticleType numbers
            /// </summary>
            TYPEARTICLE_RANGEEND = 1000,

            /// <summary>
            /// Start of Club Type numbers
            /// </summary>
            TYPECLUB = 1001,
            /// <summary>
            /// End of Club Type numbers
            /// </summary>
            TYPECLUB_RANGEEND = 2000,

            /// <summary>
            /// Start of Review Forum Type numbers
            /// </summary>
            TYPEREVIEWFORUM = 2001,
            /// <summary>
            /// End of Review Forum Type numbers
            /// </summary>
            TYPEREVIEWFORUM_RANGEEND = 3000,

            /// <summary>
            /// Start of User Page Type numbers
            /// </summary>
            TYPEUSERPAGE = 3001,
            /// <summary>
            /// End of User Page Type numbers
            /// </summary>
            TYPEUSERPAGE_RANGEEND = 4000,

            /// <summary>
            /// Start of Category page Type numbers
            /// </summary>
            TYPECATEGORYPAGE = 4001,
            /// <summary>
            /// End of Category Page Type numbers
            /// </summary>
            TYPECATEGORYPAGE_RANGEEND = 5000,
        };

        /// <summary>
        /// The default constructor for the guideentry object
        /// </summary>
        /// <param name="context">An object that impliments the IInputContext interface. e.g. basePage</param>
        /// <param name="setup">A guide entry setup object. This has all the flags that state how the guideentry is to be made</param>
        public GuideEntry(IInputContext context, GuideEntrySetup setup)
            : base(context)
        {
            _setup = setup;
            _h2g2ID = _setup.h2g2ID;
        }

        private GuideEntrySetup _setup;
        private string _cachedFileName;
        private int _editor = 0;
        private bool _defaultCanRead = false;
        private bool _defaultCanWrite = false;
        private bool _defaultCanChangePermissions = false;
        private bool _canRead = false;
        private bool _canWrite = false;
        private bool _canChangePermissions = false;
        private int _h2g2ID = 0;
        private int _entryID = 0;
        private int _forumID = 0;
        private int _style = 0;
        private int _status = 0;
        private int _siteID = 0;
        private int _type = 0;
        private int _submittable = 0;
        private float _latitude = 0.0f;
        private float _longitude = 0.0f;
        private int _hiddenStatus = 0;
        private int _originalHiddenStatus = 0;
        private string _subject = String.Empty;
        private string _text = String.Empty;
        private int _moderationStatus = 0;
        private ExtraInfo _extraInfo;
        private DateTime _dateCreated = DateTime.MinValue;
        private DateTime _lastUpdated = DateTime.MinValue;
        private int _preProcessed = 0;
        private int _topicID = 0;
        private int _boardPromoID = 0;
        private DateTime _dateRangeStart = DateTime.MinValue;
        private DateTime _dateRangeEnd = DateTime.MinValue;
        private int _rangeInterval = 0;

        private enum _cacheCheckValues
        {
            CACHEMAGICWORD = unchecked((int)0xDEAFABBA),
            CACHEVERSION = 1
        };

        #region Properties

        /// <summary>
        /// Get property for the h2g2id
        /// </summary>
        public int H2G2ID
        {
            get { return _h2g2ID; }
        }

        /// <summary>
        /// Get property for the guides entry id
        /// </summary>
        public int EntryID
        {
            get { return _entryID; }
        }

        /// <summary>
        /// Get property for the guides status value
        /// </summary>
        public int Status
        {
            get { return _status; }
        }

        /// <summary>
        /// Get property for the guides Style value
        /// </summary>
        public int Style
        {
            get { return _style; }
        }

        /// <summary>
        /// Get property for the guides Type value
        /// </summary>
        public int Type
        {
            get { return _type; }
        }

        /// <summary>
        /// Get property for the guides Submittable value
        /// </summary>
        public int Submittable
        {
            get { return _submittable; }
        }

        /// <summary>
        /// Get property for the guides subject value
        /// </summary>
        public string Subject
        {
            get { return _subject; }
        }

        /// <summary>
        /// Get property for the guide entry forumid
        /// </summary>
        public int ForumID
        {
            get
            {
                XmlNode forumNode = RootElement.SelectSingleNode("//FORUMID");
                if (forumNode != null)
                {
                    return Convert.ToInt32(forumNode.InnerText);
                }
                return 0;
            }
        }

        /// <summary>
        /// Get property for the guide entries author Id
        /// </summary>
        public int AuthorsUserID
        {
            get
            {
                if (_editor == 0)
                {
                    // Try to get the authors user id
                    XmlNode authorID = RootElement.SelectSingleNode("//PAGEAUTHOR/EDITOR/USERID");
                    if (authorID != null)
                    {
                        _editor = Convert.ToInt32(authorID.InnerText);
                    }
                }
                return _editor;
            }
        }

        /// <summary>
        /// Get property that states whether or not the entry is deleted
        /// </summary>
        public bool IsDeleted
        {
            get { return _status == 7; }
        }

        /// <summary>
        /// Get property for the entries longitude value
        /// </summary>
        public float Longitude
        {
            get { return _longitude; }
        }

        /// <summary>
        /// Get property for the entries latitude value
        /// </summary>
        public float Latitude
        {
            get { return _latitude; }
        }

        /// <summary>
        /// Get property to see if the entry is plain text
        /// </summary>
        public bool IsPlainText
        {
            get { return _style == 2; }
        }

        /// <summary>
        /// Get property to see if the entry is GuideML
        /// </summary>
        public bool IsGuideML
        {
            get { return _style == 1; }
        }

        /// <summary>
        /// Get property to see if the entry is HTML
        /// </summary>
        public bool IsHTML
        {
            get { return _style == 3; }
        }

        /// <summary>
        /// The property that states whether or not the entry is Submittable
        /// </summary>
        public bool IsSubmittable
        {
            get { return _submittable == 1; }
        }

        /// <summary>
        /// The can read property
        /// </summary>
        public bool CanRead
        {
            get { return _canRead; }
        }

        /// <summary>
        /// The default state of can read property
        /// </summary>
        public bool DefaultCanRead
        {
            get { return _defaultCanRead; }
        }

        /// <summary>
        /// The can write property
        /// </summary>
        public bool CanWrite
        {
            get { return _canWrite; }
        }

        /// <summary>
        /// The default state of can write property
        /// </summary>
        public bool DefaultCanWrite
        {
            get { return _defaultCanWrite; }
        }

        /// <summary>
        /// The can change permissions property
        /// </summary>
        public bool CanChangePermissions
        {
            get { return _canChangePermissions; }
        }

        /// <summary>
        /// The default state of the can change permissions property
        /// </summary>
        public bool DefaultCanChangepermissions
        {
            get { return _defaultCanChangePermissions; }
        }
        #endregion

        /// <summary>
        /// Initialises the guide entry using the set object
        /// </summary>
        /// <returns>True if ok, false if not</returns>
        public bool Initialise()
        {
            // Reset all the members
            _hiddenStatus = 0;
            _originalHiddenStatus = 0;

            // First, check to make sure we've been given a valid h2g2id
            if (!ValidateH2G2ID())
            {
                // Not a valid h2g2id!!!
                return false;
            }

            // Setup some local fields
            bool safeToCache = true;
            bool failingGracefully = false;

            // Get the entries last updated date
            DateTime expiryDate = DateTime.Now;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("cachegetarticleinfo"))
            {
                reader.AddParameter("h2g2id", _h2g2ID);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    expiryDate = DateTime.Now.Subtract(new TimeSpan(0, 0, (reader.GetInt32("seconds"))));
                }
            }

            // Check to see if we've got a cached version of the entry
            _cachedFileName = "A" + _setup.h2g2ID + "-" + Convert.ToInt32(_setup.ShowEntryData) + "-" + Convert.ToInt32(_setup.ShowPageAuthors) + "-" + Convert.ToInt32(_setup.ShowReferences) + ".txt";
            string cachedEntry = "";
            if (InputContext.FileCacheGetItem("articles", _cachedFileName, ref expiryDate, ref cachedEntry) && cachedEntry.Length > 0)
            {
                // Create the entry from the cache
                CreateFromCacheText(cachedEntry);

                // Update the permissions for the viewing user
                UpdatePermissionsForUser();

                // Nothing else left to do
                return true;
            }
            else
            {
                // Not cached! Have to get it from the database
                GetEntryFromDataBase(ref safeToCache, ref failingGracefully);

                // Make a note of what the original hidden status was
                _originalHiddenStatus = _hiddenStatus;

                // Now see if we're overriding the hidden status
                if (_setup.ShowHidden)
                {
                    _hiddenStatus = 0;
                }

                // Now make a not of the default read, write and permission changing values
                _canRead = _defaultCanRead;
                _canWrite = _defaultCanWrite;
                _canChangePermissions = _defaultCanChangePermissions;
            }

            // TODO: this is a hack to fix NULL style fields in DB
            if (_style == 0)
            {
                _style = 2;
            }

            // Now add the rest of the info to the guide
            if (!failingGracefully)
            {
                // Create the guide entry from the given data
                // Simular to the BuildTreeFromData C++ function
                CreateEntryFromData(_setup.ShowEntryData, _setup.IsBeingEdited, _setup.ShowPageAuthors, _setup.ProfanityTriggered, _setup.NonAllowedURLsTriggered);
            }
            else
            {
                // Let the skins know we had a problem
                XmlNode articleNode = AddElementTag(RootElement, "ARTICLE");
                XmlNode guideNode = AddElementTag(articleNode, "GUIDE");
                XmlNode bodyNode = AddElementTag(guideNode, "BODY");
                AddElementTag(bodyNode, "NOENTRYYET");
                safeToCache = false;
                _status = 0;
            }

            // Check to see if we're a topic, if so add the promo for the entry
            if (_topicID > 0)
            {
            }

            // Check to see if we're ok to cache the guideentry
            if (safeToCache && _status != 7)
            {
            }

            // Update the permissions for the article based on the current viewing user
            UpdatePermissionsForViewingUser();

            // Ok, finished. Return the verdict
            return failingGracefully;
        }

        /// <summary>
        /// This method updates all the canread / canwrite flags based on the viewing user
        /// </summary>
        private void UpdatePermissionsForViewingUser()
        {
            // Check to make sure we've got a logged in user
            if (!InputContext.ViewingUser.UserLoggedIn)
            {
                // Nothing to update
                return;
            }

            // Check to see if we're an editor
            if (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser)
            {
                _canRead = true;
                _canWrite = true;
                _canChangePermissions = true;
            }
            else
            {
                // get the users permissions from the database
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetArticlePermissionsForUser"))
                {
                    reader.AddParameter("h2g2ID", _h2g2ID);
                    reader.AddParameter("UserID", InputContext.ViewingUser.UserID);
                    reader.Execute();

                    // Check to make sure we got something back
                    if (!reader.HasRows || !reader.Read() || reader.IsDBNull("h2g2id"))
                    {
                        // Nothing to do, just return
                        return;
                    }

                    // Update the permissions from the results
                    _canRead = reader.GetInt32("CanRead") > 0;
                    _canWrite = reader.GetInt32("CanWrite") > 0;
                    _canChangePermissions = reader.GetInt32("CanChangePermissions") > 0;

                }
            }

            // Now update the articles can read / write and change permissions
            XmlNode articleNode = RootElement.SelectSingleNode("//ARTICLE");
            if (_canRead)
            {
                articleNode.Attributes["CANREAD"].Value = "1";
            }
            else
            {
                articleNode.Attributes["CANREAD"].Value = "0";
            }

            if (_canWrite)
            {
                articleNode.Attributes["CANWRITE"].Value = "1";
            }
            else
            {
                articleNode.Attributes["CANWRITE"].Value = "0";
            }

            if (_canChangePermissions)
            {
                articleNode.Attributes["CANCHANGEPERMISSIONS"].Value = "1";
            }
            else
            {
                articleNode.Attributes["CANCHANGEPERMISSIONS"].Value = "0";
            }
        }

        /// <summary>
        /// This method is used to create the entry from the given data
        /// </summary>
        /// <param name="showEntryData">Flag to state whether or not to show the entry data</param>
        /// <param name="editing">Flag to state whether or not we are currently editing the entry</param>
        /// <param name="showPageAuthors">Flag to state whether or not to show the page authors</param>
        /// <param name="profanityTriggered">Flag to state whether or not a profanity was triggered</param>
        /// <param name="nonAllowedURLsTriggered">Flag to state whether or not a non allowed URL was found</param>
        private void CreateEntryFromData(bool showEntryData, bool editing, bool showPageAuthors, bool profanityTriggered, bool nonAllowedURLsTriggered)
        {
            string editorName = String.Empty;
            bool showAlternativeEntries = false;
            //int calcCheck = 0;
            //int checkDigit = 0;
            string updatedBody = _text;

            //// all output must be in XML (GuideML) so do conversions now
            //// do appropriate escaping of subject and body before building the tree
            //// these will need to be undone if these sections are extracted from the object

            // TODO - We're currently working to the thinking that we should not be trying to escape XML as the C# XMl code does it for you!
            //if (false)
            //{
            //    throw new NotImplementedException("We're intending not to mess around with escaping in the C# code!!!");
            //    _subject = StringUtils.EscapeAllXml(_subject);
            //}

            if (IsPlainText)
            {
                // plain text must be escaped and converted into xml
                //throw new NotImplementedException("Please write the PlainTextToGuideML() method!");
                updatedBody = PlainTextToGuideML(updatedBody);
            }
            else if (IsGuideML)
            {
                // Check to see if we're dealing with preprocessed articles
                if (_preProcessed > 0)
                {
                    // Now see if we're editing or displaying
                    if (editing)
                    {
                        // REPLACE BRs WITH RETURNS
                        updatedBody.Replace("<BR />", "\r\n");
                    }
                }
                else
                {
                    // NOT Preprocessed, but check to see if we're diplaying ( NOT Editing! )
                    if (!editing)
                    {
                        // TODO - Replace all the returns with BR Tags
                        throw new NotImplementedException("The following should be done after the body has been inserted into the document");
                        //ReplaceLineBreaksWithBreakTagsInTextNodes(updatedBody);
                    }
                }
            }
            else if (IsHTML)
            {
                updatedBody = "<GUIDE><BODY><PASSTHROUGH><![CDATA[" + updatedBody + "]]></PASSTHROUGH></BODY></GUIDE>";
            }
            else
            {
                // this should never happen of course
                throw new NotImplementedException("Don't know what type of entry we've got here!");
            }

            // if h2g2ID is zero then this is a new entry, so don't try to validate its ID
            // => must avoid trying to show alternative entries for a new entry!
            if (_h2g2ID > 0)
            {
                // check if this is a valid h2g2ID
                if (!GuideEntry.ValidateH2G2ID(_h2g2ID))
                {
                    throw new NotImplementedException("Invalid ID we've got here!");
                }
            }

            // Create the XML from the collected data
            XmlNode articleNode = AddElementTag(RootElement, "ARTICLE");
            AddAttribute(articleNode, "CANREAD", _canRead ? 1 : 0);
            AddAttribute(articleNode, "CANWRITE", _canWrite ? 1 : 0);
            AddAttribute(articleNode, "CANCHANGEPERMISSIONS", _canChangePermissions ? 1 : 0);
            AddAttribute(articleNode, "DEFAULTCANREAD", _defaultCanRead ? 1 : 0);
            AddAttribute(articleNode, "DEFAULTCANWRITE", _defaultCanWrite ? 1 : 0);
            AddAttribute(articleNode, "DEFAULTCANCHANGEPERMISSIONS", _defaultCanChangePermissions ? 1 : 0);
            AddAttribute(articleNode, "PROFANITYTRIGGERED", profanityTriggered ? 1 : 0);
            AddAttribute(articleNode, "NONALLOWEDURLSTRIGGERED", nonAllowedURLsTriggered ? 1 : 0);

            // Add the date range start if we have one
            if (_dateRangeStart != DateTime.MinValue)
            {
                AddElementTag(articleNode, "DATERANGESTART").AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, _dateRangeStart));
            }

            // Add the date range end if we have one
            if (_dateRangeEnd != DateTime.MinValue)
            {
                // take a minute from the end date as stored in the database so to match user's expectations. 
                // I.e. If SiteOption InclusiveDateRange is true user will have submitted a date range like 01/09/1980 to 02/09/1980
                // They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00 but for display purposes expect the 
                // end date to be 02/09/1980. 02/09/1980 23:59 is therefore returned.                
                if (InputContext.GetSiteOptionValueInt("GuideEntries", "InclusiveDateRange") == 1)
                {
                    _dateRangeEnd = _dateRangeEnd.AddMinutes(-1.0);
                }
                AddElementTag(articleNode, "DATERANGEEND").AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, _dateRangeEnd));
            }

            // Add the time interval if valid
            if (_rangeInterval != -1)
            {
                AddIntElement(articleNode, "TIMEINTERVAL", _rangeInterval);
            }

            // Now create the article info block
            XmlNode articleInfoNode = AddArticleInfo(showEntryData, showPageAuthors, articleNode);

            // add the subject and body taking note of the hidden flag
            if (_hiddenStatus > 0)
            {
                // Hidden! Tell the user
                AddTextTag(articleNode, "SUBJECT", "Article Pending Moderation");
                XmlNode guideNode = AddElementTag(articleNode, "GUIDE");
                AddTextTag(guideNode, "BODY", "This article has been hidden pending moderation");
            }
            else
            {
                AddTextTag(articleNode, "SUBJECT", _subject);
                XmlDocument xDoc = new XmlDocument();
                string body = Entities.GetEntities() + updatedBody;
                xDoc.LoadXml(body);
                articleNode.AppendChild(ImportNode(xDoc.SelectSingleNode("//GUIDE")));
            }

            // Add the extrainfo objec to the tree taking note of the hidden status
            AddInside(articleNode, _extraInfo);

            if (AppContext.TheAppContext.GetSiteOptionValueBool(InputContext.CurrentSite.SiteID, "GuideEntries", "IncludeBookmarkCount"))
            {
                int bookmarkCount = 0;
                GetBookmarkCount(_h2g2ID, out bookmarkCount);
                AddIntElement(articleNode, "BOOKMARKCOUNT", bookmarkCount);
            }

            // Create the References for the article
            if (_setup.ShowReferences && _hiddenStatus == 0)
            {
                CreateReferences(articleInfoNode);
            }

            // Now see if we need to insert alternative entries?
            if (showAlternativeEntries)
            {
                throw new NotImplementedException("We still need to write the alternative entries code!");
                // TODO - Convert the following and refactor into a new method.
                #region AlternativeEntries
                //            if (bShowAlternativeEntries)
                //            {
                //                // if we enter this part of the code it is because we failed to find the article
                //                // the user was looking for so we can
                //                TDVASSERT(sArticle.IsEmpty(), "Trying to show alternative articles failed because a string reserved for it got tainted.");
                //                // and also
                //                TDVASSERT(!bSuccess, "bSuccess got confused in GuideEntry::Initialise() :( ");

                //                // we'll try to find a bunch of valid entries that they could hae been looking for

                //                // Assume: One digit wrong/one digit missing/one digit added/two digits transposed

                //                int iDifference = iCalcCheck - iCheckDigit;
                //                int iInsertDigit = iDifference;

                //                if (iDifference < 0)
                //                {
                //                    // this digit should be in the range 0 to 9 so if it's gone negative it ought to be 10 more
                //                    iDifference += 10;
                //                }

                //                // start building an invalid article block
                //                sArticle << "<ARTICLE><GUIDE><BODY>";
                //                sArticle << "<INVALIDARTICLE>";
                //                sArticle << "<SUGGESTEDALTERNATIVES>";

                //                int iCount = 0;
                //                for (iCount = 0; iCount < sh2g2ID.GetLength(); iCount++)
                //                {
                //                    // At each position, see what we can do
                //                    // The checksum position must be treated somewhat differently
                //                    // for insertion and substitution
                //                    // transposition will never affect checksumming

                //                    // See what happens if we insert a character before this digit

                //                    // try putting there difference digit into the h2g2id
                //                    CTDVString sProposedh2g2IDWithInsert = "";
                //                    sProposedh2g2IDWithInsert << sh2g2ID.Left(iCount);
                //                    sProposedh2g2IDWithInsert << iDifference;
                //                    sProposedh2g2IDWithInsert << sh2g2ID.Mid(iCount);

                //                    int iProposedh2g2IDWithInsert = atoi(sProposedh2g2IDWithInsert);

                //                    CTDVString sEntrySubject = "";

                //                    if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithInsert, sEntrySubject))
                //                    {
                //                        sArticle << "<LINK H2G2=\"";
                //                        sArticle << iProposedh2g2IDWithInsert;
                //                        sArticle << "\">";

                //                        CXMLObject::EscapeXMLText(&sEntrySubject);					
                //                        sArticle << sEntrySubject;
                //                        sArticle << "</LINK>";
                //                    }

                //                    if (iCount < sh2g2ID.GetLength() -1)
                //                    {
                //                        // We're looking at a non-check digit
                //                        // First correct the wrong digit.
                //                        // my $digit = substr($id,$i,1);

                //                        // make sure we don't get caught out by pants ascii values
                //                        CTDVString sWhichDigit = "";
                //                        sWhichDigit = sh2g2ID.GetAt(iCount);
                //                        int iPotentialDigit = atoi(sWhichDigit);

                //                        iPotentialDigit += iDifference;

                //                        if (iPotentialDigit < 0)
                //                        {
                //                            iPotentialDigit += 10;
                //                        }
                //                        else
                //                        if (iPotentialDigit > 9)
                //                        {
                //                            iPotentialDigit -= 10;
                //                        }

                //                        CTDVString sPotentialDigit = "";
                //                        sPotentialDigit << iPotentialDigit;

                //                        CTDVString sProposedh2g2IDWithSwap = "";
                //                        sProposedh2g2IDWithSwap << sh2g2ID;
                //                        sProposedh2g2IDWithSwap.SetAt(iCount, sPotentialDigit.GetAt(0));

                //                        int iProposedh2g2IDWithSwap = atoi(sProposedh2g2IDWithSwap);

                //                        CTDVString sEntrySubject = "";

                //                        if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithSwap, sEntrySubject))
                //                        {
                //                            sArticle << "<LINK H2G2=\"";
                //                            sArticle << sProposedh2g2IDWithSwap;
                //                            sArticle << "\">";

                //                            CXMLObject::EscapeXMLText(&sEntrySubject);					
                //                            sArticle << sEntrySubject;
                //                            sArticle << "</LINK>";
                //                        }
                //                    }
                //                    else
                //                    {
                //                        // we're looking at a check digit
                //                        // substitute the valid check digit

                //                        CTDVString sProposedh2g2IDWithCheckChanged = "";
                //                        sProposedh2g2IDWithCheckChanged << sh2g2ID;

                //                        CTDVString sCalcCheck = "";
                //                        sCalcCheck << iCalcCheck;
                //                        sProposedh2g2IDWithCheckChanged.SetAt(iCount , sCalcCheck.GetAt(0));

                //                        int iProposedh2g2IDWithCheckChanged = atoi(sProposedh2g2IDWithCheckChanged);

                //                        CTDVString sEntrySubject = "";

                //                        if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithCheckChanged, sEntrySubject))
                //                        {
                //                            sArticle << "<LINK H2G2=\"";
                //                            sArticle << iProposedh2g2IDWithCheckChanged;
                //                            sArticle << "\">";

                //                            CXMLObject::EscapeXMLText(&sEntrySubject);					
                //                            sArticle << sEntrySubject;
                //                            sArticle << "</LINK>";
                //                        }

                //                        // and in case they left off the check digit
                //                        // add a valid one onto the end

                //                        CTDVString sProposedh2g2IDWithCheckAdded = "";
                //                        sProposedh2g2IDWithCheckAdded << sh2g2ID;

                //                        CTDVString sNewEntryID = sh2g2ID;
                //                        int iTestID = atoi(sNewEntryID);
                //                        int iAppropriateDigit = 0;
                //                        int iTempID = iTestID;

                //                        while (iTempID > 0)
                //                        {
                //                            iAppropriateDigit += iTempID % 10;
                //                            iTempID = static_cast<int>(iTempID / 10);
                //                        }
                //                        iAppropriateDigit = iAppropriateDigit % 10;
                //                        iAppropriateDigit = 9 - iAppropriateDigit;

                //                        sProposedh2g2IDWithCheckAdded << iAppropriateDigit;

                //                        int iProposedh2g2IDWithCheckAdded = atoi(sProposedh2g2IDWithCheckAdded);

                //                        // this was already defined in this scope
                //                        sEntrySubject = "";

                //                        if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithCheckAdded, sEntrySubject))
                //                        {
                //                            sArticle << "<LINK H2G2=\"";
                //                            sArticle << iProposedh2g2IDWithCheckAdded;
                //                            sArticle << "\">";

                //                            CXMLObject::EscapeXMLText(&sEntrySubject);
                //                            sArticle << sEntrySubject;
                //                            sArticle << "</LINK>";
                //                        }
                //                    }
                //                }		

                //                sArticle << "</SUGGESTEDALTERNATIVES>";
                //                sArticle << "</INVALIDARTICLE>";
                //                sArticle << "</BODY></GUIDE></ARTICLE>";

                //                // we have something valid to output actually so we can put bSuccess back to true
                //                bSuccess = true;
                //            }

                #endregion
            }
        }

        private string PlainTextToGuideML(string updatedBody)
        {
            string output = StringUtils.PlainTextToGuideML(updatedBody);

            return "<GUIDE><BODY>" + output + "</BODY></GUIDE>";
        }

        private void GetBookmarkCount(int h2g2ID, out int bookmarkCount)
        {
            bookmarkCount = 0;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetBookmarkCount"))
            {
                reader.AddParameter("H2G2ID", h2g2ID);
                reader.Execute();

                if (reader.Read())
                {
                    bookmarkCount = reader.GetInt32NullAsZero("BookmarkCount");
                }
            }
        }

        /// <summary>
        /// This method adds all the article info to the entry
        /// </summary>
        /// <param name="showEntryData">A flag that states whether or not to add the entry data to the XML</param>
        /// <param name="showPageAuthors">A flag to state whether or not to add the authors list to the XML</param>
        /// <param name="parentNode">The node that you want to insert the article info block</param>
        /// <returns>The node that represents the articleinfo block</returns>
        private XmlNode AddArticleInfo(bool showEntryData, bool showPageAuthors, XmlNode parentNode)
        {
            // Now add the article info block
            XmlNode articleInfoNode = AddElementTag(parentNode, "ARTICLEINFO");

            // Check to see if we are needed to add the entry data
            if (showEntryData)
            {
                AddEntryData(articleInfoNode);
            }

            AddIntElement(articleInfoNode, "FORUMID", _forumID);
            AddIntElement(articleInfoNode, "SITEID", _siteID);

            if (_hiddenStatus > 0)
            {
                AddIntElement(articleInfoNode, "HIDDEN", _hiddenStatus);
            }

            XmlNode modNode = AddIntElement(articleInfoNode, "MODERATIONSTATUS", _moderationStatus);
            AddAttribute(modNode, "ID", _h2g2ID);

            // Add the page authors if we've been asked to
            if (showPageAuthors)
            {
                // Create the authors list and add it to the page
                AuthorsList pageAuthors = new AuthorsList(InputContext, AuthorsList.ArticleType.ARTICLE, _h2g2ID, _editor);
                pageAuthors.CreateListForArticle();
                XmlNode authorsNode = AddElementTag(articleInfoNode, "PAGEAUTHOR");
                AddInside(authorsNode, pageAuthors, "//RESEARCHERS");
                AddInside(authorsNode, pageAuthors, "//EDITOR");
            }

            // Add the date created and last update
            XmlNode createdNode = AddElementTag(articleInfoNode, "DATECREATED");
            createdNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, _dateCreated, true));

            XmlNode updatedNode = AddElementTag(articleInfoNode, "LASTUPDATED");
            updatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, _lastUpdated, true));

            // Create the Article crumbtrail
            Category articleCrumbtrail = new Category(InputContext);
            articleCrumbtrail.CreateArticleCrumbtrail(_h2g2ID);
            AddInside(articleInfoNode, articleCrumbtrail, "//CRUMBTRAILS");

            // Insert a related member node and the preprocessed info
            XmlNode relatedMembersNode = AddElementTag(articleInfoNode, "RELATEDMEMBERS");
            AddIntElement(articleInfoNode, "PREPROCESSED", _preProcessed);

            // Create the related clubs
            Category relatedMembers = new Category(InputContext);
            relatedMembers.GetRelatedClubs(_h2g2ID);
            AddInside(relatedMembersNode, relatedMembers, "//RELATEDCLUBS");

            // Create the related articles
            relatedMembers.IncludeStrippedNames = true;
            relatedMembers.GetRelatedArticles(_h2g2ID);
            AddInside(relatedMembersNode, relatedMembers, "//RELATEDARTICLES");

            // Return the new article info node
            return articleInfoNode;
        }

        /// <summary>
        /// Creates the References for the current article. This is done by searching the body text
        /// for links.
        /// </summary>
        /// <param name="articleInfoNode">The node that you want to add the resultant xml block to</param>
        private void CreateReferences(XmlNode articleInfoNode)
        {
            // Create the base node
            XmlNode referenceNode = AddElementTag(articleInfoNode, "REFERENCES");
            XmlNode usersNode = AddElementTag(referenceNode, "USERS");
            XmlNode entriesNode = AddElementTag(referenceNode, "ENTRIES");
            XmlNode externalsNode = AddElementTag(referenceNode, "EXTERNAL");

            // Now go through the body text extracting all References
            XmlNode bodyTextNode = RootElement.SelectSingleNode("//GUIDE/BODY");
            XmlNodeList linkNodes = bodyTextNode.SelectNodes("//LINK");
            List<int> userIDs = new List<int>();
            List<int> articleIDs = new List<int>();
            int uniqueIndex = 0;
            foreach (XmlNode linkNode in linkNodes)
            {
                // Check to see if it's a link we're intrested in
                if (linkNode.Attributes["H2G2"] != null
                    || linkNode.Attributes["DNAID"] != null
                    || linkNode.Attributes["BIO"] != null)
                {
                    // Get the value from the attribute
                    string value = "";
                    if (linkNode.Attributes["H2G2"] != null)
                    {
                        value = linkNode.Attributes["H2G2"].Value;
                    }
                    else if (linkNode.Attributes["DNAID"] != null)
                    {
                        value = linkNode.Attributes["DNAID"].Value;
                    }
                    else if (linkNode.Attributes["BIO"] != null)
                    {
                        value = linkNode.Attributes["BIO"].Value;
                    }

                    // If we've got a value, get the id and add it to the correct list
                    if (value.Length > 0)
                    {
                        string type = value.Substring(0, 1);
                        value = value.Substring(1);
                        int typeID = Convert.ToInt32((value.Split('?'))[0]);

                        if (type.CompareTo("U") == 0)
                        {
                            userIDs.Add(typeID);
                        }
                        else if (type.CompareTo("A") == 0 || type.CompareTo("P") == 0)
                        {
                            articleIDs.Add(typeID);
                        }
                    }
                }
                else if (linkNode.Attributes["HREF"] != null)
                {
                    // Add a unique index attribute, so we can link back to it
                    AddAttribute(linkNode, "UINDEX", uniqueIndex);
                    XmlNode linkReferenceNode = AddElementTag(externalsNode, "EXTERNALLINK");
                    AddAttribute(linkReferenceNode, "UINDEX", uniqueIndex);
                    AddTextTag(linkReferenceNode, "OFFSITE", linkNode.Attributes["HREF"].Value);
                    string title = linkNode.InnerText;
                    if (linkNode.Attributes["TITLE"] != null)
                    {
                        title = linkNode.Attributes["TITLE"].Value;
                    }
                    AddTextTag(linkReferenceNode, "TITLE", title);
                    uniqueIndex++;
                }
            }

            // Keep going untill all IDs have been processed
            while (userIDs.Count > 0)
            {
                // Now add all the user References
                CreateUserReferences(usersNode, userIDs);
            }

            // Now add all the article References
            while (articleIDs.Count > 0)
            {
                CreateArticleReferences(entriesNode, articleIDs);
            }
        }

        private void CreateArticleReferences(XmlNode entriesNode, List<int> articleIDs)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("fetcharticles"))
            {
                // Now add all the user References
                for (int i = 1; i < 90 && articleIDs.Count > 0; i++)
                {
                    reader.AddParameter("id" + i.ToString(), articleIDs[0]);
                    articleIDs.RemoveAt(0);
                }
                reader.Execute();

                while (reader.Read())
                {
                    XmlNode entryLinkNode = AddElementTag(entriesNode, "ENTRYLINK");
                    int h2g2ID = reader.GetInt32("h2g2ID");
                    AddAttribute(entryLinkNode, "H2G2", "A" + h2g2ID.ToString());
                    AddIntElement(entryLinkNode, "H2G2ID", h2g2ID);
                    AddTextTag(entryLinkNode, "SUBJECT", reader.GetString("Subject"));
                }
            }
        }

        private void CreateUserReferences(XmlNode usersNode, List<int> userIDs)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getusernames"))
            {
                for (int i = 1; i < 90 && userIDs.Count > 0; i++)
                {
                    reader.AddParameter("id" + i.ToString(), userIDs[0]);
                    userIDs.RemoveAt(0);
                }
                reader.Execute();

                while (reader.Read())
                {
                    XmlNode userLinkNode = AddElementTag(usersNode, "USERLINK");
                    int userID = reader.GetInt32("UserID");
                    AddAttribute(userLinkNode, "H2G2", "U" + userID.ToString());
                    AddIntElement(userLinkNode, "USERID", userID);
                    AddTextTag(userLinkNode, "USERNAME", reader.GetString("UserName"));
                }
            }
        }

        /// <summary>
        /// Creates the entry's data
        /// </summary>
        /// <param name="parentNode">The node that you want to add the xml to</param>
        private void AddEntryData(XmlNode parentNode)
        {
            // Add the various peices of data to the tree
            AddStatusTag(parentNode, _status);
            AddIntElement(parentNode, "H2G2ID", _h2g2ID);

            // Now the create the Submittable XML
            XmlNode submittableNode = AddElementTag(parentNode, "SUBMITTABLE");

            // See if we're user generated
            if (_status == 3)
            {
                int forumID = 0;
                int threadID = 0;
                int postID = 0;
                int reviewForumID = 0;

                // Fetch the entries review forum details
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("fetchreviewforummemberdetails"))
                {
                    reader.AddParameter("h2g2id", _h2g2ID);
                    reader.Execute();

                    // Make sure we got something back
                    if (reader.HasRows && reader.Read())
                    {
                        forumID = reader.GetInt32("ForumID");
                        threadID = reader.GetInt32("ThreadID");
                        postID = reader.GetInt32("PostID");
                        reviewForumID = reader.GetInt32("ReviewForumID");

                        // Set the type attribute
                        AddAttribute(submittableNode, "TYPE", "IN");

                        // Create the ReviewForum object and insert it into the entry
                        ReviewForum reviewForum = new ReviewForum(InputContext);
                        reviewForum.InitialiseViaReviewForumID(reviewForumID, true);
                        submittableNode.AppendChild(ImportNode(reviewForum.RootElement));

                        // Now insert the rest
                        XmlNode forumNode = AddElementTag(submittableNode, "FORUM");
                        AddAttribute(forumNode, "ID", forumID);
                        XmlNode threadNode = AddElementTag(submittableNode, "THREAD");
                        AddAttribute(threadNode, "ID", threadID);
                        XmlNode postNode = AddElementTag(submittableNode, "POST");
                        AddAttribute(postNode, "ID", postID);
                    }
                    else if (IsSubmittable)
                    {
                        // Set the type attribute
                        AddAttribute(submittableNode, "TYPE", "YES");
                    }
                    else
                    {
                        // Set the type attribute
                        AddAttribute(submittableNode, "TYPE", "NO");
                    }
                }
            }
        }

        /// <summary>
        /// This method works out and inserts the status of the entry into the tree
        /// </summary>
        /// <param name="parentNode">The node you want to insert the status into</param>
        /// <param name="status">The status that you want to represent in the XML</param>
        private void AddStatusTag(XmlNode parentNode, int status)
        {
            // Add the status node and set the type attribute for it
            XmlNode statusNode = AddTextTag(parentNode, "STATUS", GetDescriptionForStatusValue(status));
            AddAttribute(statusNode, "TYPE", status);
        }

        /// <summary>
        /// This method gets the description for a given status value
        /// </summary>
        /// <param name="status">The status value you want to get the description for</param>
        /// <returns>The description for the given status value</returns>
        public static string GetDescriptionForStatusValue(int status)
        {
            // Get the description for the given status value
            string statusType = "";
            switch (status)
            {
                case 0: statusType = "No Status"; break;
                case 1: statusType = "Edited"; break;
                case 2: statusType = "User Entry, Private"; break;
                case 3: statusType = "User Entry, Public"; break;
                case 4: statusType = "Recommended"; break;
                case 5: statusType = "Locked by Editor"; break;
                case 6: statusType = "Awaiting Editing"; break;
                case 7: statusType = "Cancelled"; break;
                case 8: statusType = "User Entry, Staff-locked"; break;
                case 9: statusType = "Key Entry"; break;
                case 10: statusType = "General Page"; break;
                case 11: statusType = "Awaiting Rejection"; break;
                case 12: statusType = "Awaiting Decision"; break;
                case 13: statusType = "Awaiting Approval"; break;
                default: statusType = "Unknown"; break;
            }
            return statusType;
        }

        /// <summary>
        /// This method reads in the entry form the database and sets up all the member fields
        /// </summary>
        /// <param name="safeToCache">A flag to state whether or not this entry is safe to cache. Usually set to false whhen an error occures.</param>
        /// <param name="failingGracefully">A flag that states whether or not this method is failing gracefully.</param>
        private void GetEntryFromDataBase(ref bool safeToCache, ref bool failingGracefully)
        {
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getarticlecomponents2"))
            {
                // Add the entry id and execute
                reader.AddParameter("EntryID", EntryID);
                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    // Fail gracefully
                    XmlNode articleTag = AddElementTag(RootElement, "ARTICLE");
                    XmlNode guideTag = AddElementTag(articleTag, "GUIDE");
                    XmlNode bodyTag = AddElementTag(guideTag, "BODY");
                    AddElementTag(bodyTag, "NOENTRYYET");
                    failingGracefully = true;
                    safeToCache = false;
                }
                else
                {
                    // Go though the results untill we get the main article
                    do
                    {
                        if (reader.GetInt32("IsMainArticle") == 1)
                        {
                            // Now start reading in all the values for the entry
                            _h2g2ID = reader.GetInt32("h2g2ID");
                            _entryID = reader.GetInt32("EntryID");
                            _forumID = reader.GetInt32("ForumID");
                            _status = reader.GetInt32("Status");
                            _style = reader.GetInt32("Style");
                            _editor = reader.GetInt32("Editor");
                            _siteID = reader.GetInt32("SiteID");
                            _submittable = reader.GetTinyIntAsInt("Submittable");
                            _type = reader.GetInt32("Type");
                            if (!reader.IsDBNull("ModerationStatus"))
                            {
                                _moderationStatus = reader.GetTinyIntAsInt("ModerationStatus");
                            }
                            _subject = reader.GetString("subject");
                            _text = reader.GetString("text");
                            string extraInfo = reader.GetString("extrainfo");

                            _extraInfo = new ExtraInfo();
                            _extraInfo.TryCreate(_type, extraInfo);

                            if (reader.IsDBNull("Hidden"))
                            {
                                _hiddenStatus = 0;
                            }
                            else
                            {
                                _hiddenStatus = reader.GetInt32("Hidden");
                            }

                            _dateCreated = reader.GetDateTime("DateCreated");
                            _lastUpdated = reader.GetDateTime("LastUpdated");
                            _preProcessed = reader.GetInt32("PreProcessed");
                            _defaultCanRead = (reader.GetTinyIntAsInt("CanRead") > 0);
                            _defaultCanWrite = (reader.GetTinyIntAsInt("CanWrite") > 0);
                            _defaultCanChangePermissions = (reader.GetTinyIntAsInt("CanChangePermissions") > 0);

                            if (reader.IsDBNull("TopicID"))
                            {
                                _topicID = 0;
                            }
                            else
                            {
                                _topicID = reader.GetInt32("TopicID");
                            }

                            if (reader.IsDBNull("BoardPromoID"))
                            {
                                _boardPromoID = 0;
                            }
                            else
                            {
                                _boardPromoID = reader.GetInt32("BoardPromoID");
                            }

                            if (!reader.IsDBNull("StartDate"))
                            {
                                _dateRangeStart = reader.GetDateTime("StartDate");
                            }

                            if (!reader.IsDBNull("EndDate"))
                            {
                                _dateRangeEnd = reader.GetDateTime("EndDate");
                            }

                            if (reader.IsDBNull("TimeInterval"))
                            {
                                _rangeInterval = -1; // default value
                            }
                            else
                            {
                                _rangeInterval = reader.GetInt32("TimeInterval");
                            }
                        }
                    }
                    while (reader.Read());
                }
            }
        }

        /// <summary>
        /// Validates the h2g2id to make sure it correctly translates to an entry id
        /// </summary>
        /// <remarks>This is the C# version of the C++ IsValidChecksum(...) function.</remarks>
        /// <returns>True if valid, false if not</returns>
        private bool ValidateH2G2ID()
        {
            // Check to make sure we've got at least a two digit number
            if (_h2g2ID < 10)
            {
                return false;
            }

            // First get the check sum value. The last digit of the id
            string checkSumAsString = _setup.h2g2ID.ToString();
            int checkSum = Convert.ToInt32(checkSumAsString.Substring(checkSumAsString.Length - 1, 1));

            // Now get the entry id which is all the digits minus the checksum
            _entryID = Convert.ToInt32(checkSumAsString.Substring(0, checkSumAsString.Length - 1));

            // Now recalculate the check sum
            int testID = _entryID;
            int calculatedCheck = 0;
            while (testID > 0)
            {
                calculatedCheck += testID % 10;
                testID /= 10;
            }
            calculatedCheck = calculatedCheck % 10;
            calculatedCheck = 9 - calculatedCheck;

            // Now return the comparision of the calculated check sum with the one passed in.
            // If they're not the same, it's invalid!
            if (calculatedCheck == checkSum)
            {
                return true;
            }
            else
            {
                _entryID = 0;
                return false;
            }
        }

        /// <summary>
        /// Validates the h2g2id to make sure it correctly translates to an entry id
        /// </summary>
        /// <remarks>This is the C# version of the C++ IsValidChecksum(...) function.</remarks>
        /// <returns>True if valid, false if not</returns>
        public static bool ValidateH2G2ID(int h2g2ID)
        {
            // Check to make sure we've got at least a two digit number
            if (h2g2ID < 10)
            {
                return false;
            }

            // First get the check sum value. The last digit of the id
            string checkSumAsString = h2g2ID.ToString();
            int checkSum = Convert.ToInt32(checkSumAsString.Substring(checkSumAsString.Length - 1, 1));

            // Now get the entry id which is all the digits minus the checksum
            int entryID = Convert.ToInt32(checkSumAsString.Substring(0, checkSumAsString.Length - 1));

            // Now recalculate the check sum
            int testID = entryID;
            int calculatedCheck = 0;
            while (testID > 0)
            {
                calculatedCheck += testID % 10;
                testID /= 10;
            }
            calculatedCheck = calculatedCheck % 10;
            calculatedCheck = 9 - calculatedCheck;

            // Now return the comparision of the calculated check sum with the one passed in.
            // If they're not the same, it's invalid!
            if (calculatedCheck == checkSum)
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// Creates the guide entry from a cached text version.
        /// </summary>
        /// <param name="cachedEntry">The cached entry you want to create from</param>
        private void CreateFromCacheText(string cachedEntry)
        {
            // Get the flags and XML as seperate strings.
            string cachedFlags = cachedEntry.Substring(0, cachedEntry.IndexOf("<") - 1);
            string cachedXML = cachedEntry.Substring(cachedEntry.IndexOf("<"));

            // Sort out the flags
            if (cachedFlags.Length > 0)
            {
                string[] flags = cachedFlags.Split('\n');
                if (flags.Length == 8)
                {
                    // Check the magic word and version
                    bool magicWordMatch = Convert.ToInt32(flags[0]) == (int)_cacheCheckValues.CACHEMAGICWORD;
                    bool magicVersionMatch = Convert.ToInt32(flags[1]) == (int)_cacheCheckValues.CACHEVERSION;
                    if (magicWordMatch && magicVersionMatch)
                    {
                        // Magic word and version are correct, so update the fields
                        _style = Convert.ToInt32(flags[3]);
                        _status = Convert.ToInt32(flags[4]);
                        _siteID = Convert.ToInt32(flags[5]);
                        _submittable = Convert.ToInt32(flags[6]);
                        _type = Convert.ToInt32(flags[7]);
                    }
                }
            }

            // Check to see if we're a deleted article. If so, don't use the cache but the following
            if (_status == 7)
            {
                cachedXML = @"<ARTICLE><ARTICLEINFO><STATUS TYPE='7'>Cancelled</STATUS><H2G2ID>" + _h2g2ID;
                cachedXML += @"</H2G2ID></ARTICLEINFO><SUBJECT>Article Deleted</SUBJECT><GUIDE>
                            <BODY>This Guide Entry has been deleted.</BODY></GUIDE></ARTICLE>";
            }

            // Ok, we've got a cached version, create the XML from the string.
            CreateAndInsertCachedXML(Entities.GetEntities() + cachedXML, "ARTICLE", true);
        }

        /// <summary>
        /// Updates the can read/write permissions depending on the status of the user
        /// </summary>
        /// <remarks>This is the C# version of the C++ ChangeArticleXMLPermissionsForUser(...) function.</remarks>
        private void UpdatePermissionsForUser()
        {
            // check to see if we're a super user or editor
            if (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSubEditor)
            {
                _canRead = true;
                _canWrite = true;
                _canChangePermissions = true;
            }
            else
            {
                // Check the database
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetArticlePermissionsForUser"))
                {
                    // Add the params
                    reader.AddParameter("h2g2Id", _h2g2ID);
                    reader.AddParameter("UserId", InputContext.ViewingUser.UserID);
                    reader.Execute();

                    // Check to make sure we got something back
                    if (!reader.HasRows || !reader.Read() || reader.IsDBNull("h2g2id"))
                    {
                        // Nothing to do, just return
                        return;
                    }

                    // Get the values for the pewrmissions
                    _canRead = reader.GetInt32("canread") > 0;
                    _canWrite = reader.GetInt32("canwrite") > 0;
                    _canChangePermissions = reader.GetInt32("CanChangePermissions") > 0;
                }
            }

            // Find the article node from the tree
            XmlNode articleNode = RootElement.SelectSingleNode("ARTICLE");
            articleNode.Attributes["CANWRITE"].Value = Convert.ToInt32(_canWrite).ToString();
            articleNode.Attributes["CANREAD"].Value = Convert.ToInt32(_canRead).ToString();
            articleNode.Attributes["CANCHANGEPERMISSIONS"].Value = Convert.ToInt32(_canChangePermissions).ToString();
        }

        /// <summary>
        /// Checks to see if a user has edit permissions for the current guide entry
        /// </summary>
        /// <param name="user">The user you want to check against</param>
        /// <returns>True if they are able to edit, false if not</returns>
        public bool HasEditPermission(IUser user)
        {
            // Check to see if we've got special permissions
            bool editable = user.HasSpecialEditPermissions(_h2g2ID);

            // Make sure the h2g2id is valid
            if (!editable && ValidateH2G2ID())
            {
                // Guide Entry is editable if it is a valid article, the user is the same as the
                // editor, and the status of the entry is either 2, 3, 4, or 7 => i.e. it is a
                // user entry that is private or public, or is awaiting consideration or has been
                // deleted
                // only give editors edit permission on all entries on the admin version
                // give moderators edit permission if they have entry locked for moderation

                if (Status == 1 && user.IsGuardian)
                {
                    editable = true;
                }

                // If the user is the editor of the entry and the status is correct, then they can edit
                if (AuthorsUserID == user.UserID)
                {
                    if ((Status > 1 && Status < 5) || Status == 7)
                    {
                        editable = true;
                    }
                }
            }

            return editable;
        }

        /// <summary>
        /// Checks to see the given user is a subeditor for the entry
        /// </summary>
        /// <param name="user">The user you want to check for subeditor status</param>
        /// <returns>True if they are, fasle if not</returns>
        public bool CheckIsSubEditor(IUser user)
        {
            // Check to see if the user has editing permissions
            bool isSubEditor = false;
            if (HasEditPermission(user) && user.UserID > 0)
            {
                // Check the database to see if they are a sub editor
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("checkissubeditor"))
                {
                    reader.AddParameter("userid", user.UserID);
                    reader.AddParameter("entryID", EntryID);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        isSubEditor = reader.GetBoolean("IsSub");
                    }
                }
            }
            // return the verdict
            return isSubEditor;
        }

        /// <summary>
        /// Gets whether the given type number is in the range of the Article Types
        /// </summary>
        /// <param name="articleType"></param>
        /// <returns></returns>
        public static bool IsTypeOfArticle(int articleType)
        {
            return (articleType >= (int)GuideEntry.GuideEntryType.TYPEARTICLE && articleType <= (int)GuideEntry.GuideEntryType.TYPEARTICLE_RANGEEND);
        }
    }
}
