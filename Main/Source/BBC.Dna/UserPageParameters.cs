using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// Class to store all User Page parameters
    /// </summary>
    class UserPageParameters
    {
        int _userID = 0;

        bool _includeUsersGuideEntries = false;
        bool _includeUsersGuideEntriesForums = false;
        bool _includeJournals = false;
        bool _includeRecentPosts = false;
        bool _includeRecentComments = false;
        bool _includeRecentGuideEntries = false;
        bool _includeRecentUploads = false;
        bool _includeRecentArticlesOfSubscribedUsers = false;

        bool _includeWatchInfo = false;
        bool _includeClubs = false;
        bool _includePrivateForums = false;
        bool _includeLinks = false;
        bool _includeTaggedNodes = false;
        bool _includeNoticeboard = false;
        bool _includePostcoder = false;
        bool _includeSiteOptions = false;


        bool _isRegistering = false;

        bool _clip = false;

        bool _private = false;

        string _linkGroup = String.Empty;

        List<KeyValuePair<int, string>> _moveLinks = new List<KeyValuePair<int, string>>();
        bool _linksToMove = false;

        List<KeyValuePair<int, bool>> _linksPrivacy = new List<KeyValuePair<int, bool>>();
        bool _linksPrivacyChange = false;

        List<int> _deleteLinks = new List<int>();
        bool _linksToDelete = false;

        /// <summary>
        /// Accessor for LinksPrivacyChange
        /// </summary>
        public bool LinksPrivacyChange
        {
            get { return _linksPrivacyChange; }
            set { _linksPrivacyChange = value; }
        }
        /// <summary>
        /// Accessor for LinksToMove
        /// </summary>
        public bool LinksToMove
        {
            get { return _linksToMove; }
            set { _linksToMove = value; }
        }
        /// <summary>
        /// Accessor for LinksToDelete
        /// </summary>
        public bool LinksToDelete
        {
            get { return _linksToDelete; }
            set { _linksToDelete = value; }
        }

        /// <summary>
        /// Accessor for the DeleteLinks
        /// </summary>
        public List<int> DeleteLinks
        {
            get { return _deleteLinks; }
            set { _deleteLinks = value; }
        }

        /// <summary>
        /// Accessor for the _LinksPrivacy
        /// </summary>
        public List<KeyValuePair<int, bool>> LinksPrivacy
        {
            get { return _linksPrivacy; }
            set { _linksPrivacy = value; }
        }
       
        /// <summary>
        /// Accessor for the MoveLinksList of linkIDs and newLocations
        /// </summary>
        public List<KeyValuePair<int, string>> MoveLinksList
        {
            get { return _moveLinks; }
            set { _moveLinks = value; }
        }
        /// <summary>
        /// Accessor for LinkGroup
        /// </summary>
        public string LinkGroup
        {
            get { return _linkGroup; }
            set { _linkGroup = value; }
        }

        /// <summary>
        /// Accessor for IncludeWatchInfo
        /// </summary>
        public bool IncludeWatchInfo
        {
            get { return _includeWatchInfo; }
            set { _includeWatchInfo = value; }
        }

        /// <summary>
        /// Accessor for IncludeClubs
        /// </summary>
        public bool IncludeClubs
        {
            get { return _includeClubs; }
            set { _includeClubs = value; }
        }

        /// <summary>
        /// Accessor for IncludePrivateForums
        /// </summary>
        public bool IncludePrivateForums
        {
            get { return _includePrivateForums; }
            set { _includePrivateForums = value; }
        }

        /// <summary>
        /// Accessor for IncludeLinks
        /// </summary>
        public bool IncludeLinks
        {
            get { return _includeLinks; }
            set { _includeLinks = value; }
        }

        /// <summary>
        /// Accessor for IncludeTaggedNodes
        /// </summary>
        public bool IncludeTaggedNodes
        {
            get { return _includeTaggedNodes; }
            set { _includeTaggedNodes = value; }
        }

        /// <summary>
        /// Accessor for IncludeNoticeboard
        /// </summary>
        public bool IncludeNoticeboard
        {
            get { return _includeNoticeboard; }
            set { _includeNoticeboard = value; }
        }

        /// <summary>
        /// Accessor for IncludePostcoder
        /// </summary>
        public bool IncludePostcoder
        {
            get { return _includePostcoder; }
            set { _includePostcoder = value; }
        }

        /// <summary>
        /// Accessor for IncludeSiteOptions
        /// </summary>
        public bool IncludeSiteOptions
        {
            get { return _includeSiteOptions; }
            set { _includeSiteOptions = value; }
        }

        /// <summary>
        /// Accessor for UserID
        /// </summary>
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; }
        }

        /// <summary>
        /// Accessor for Private
        /// </summary>
        public bool Private
        {
            get { return _private; }
            set { _private = value; }
        }

        /// <summary>
        /// Accessor for Clip
        /// </summary>
        public bool Clip
        {
            get { return _clip; }
            set { _clip = value; }
        }

        /// <summary>
        /// Accessor for IsRegistering
        /// </summary>
        public bool IsRegistering
        {
            get { return _isRegistering; }
            set { _isRegistering = value; }
        }
 
       /// <summary>
        /// Accessor for IncludeUsersGuideEntries
        /// </summary>
        public bool IncludeUsersGuideEntries
        {
            get { return _includeUsersGuideEntries; }
            set { _includeUsersGuideEntries = value; }
        }
        /// <summary>
        /// Accessor for IncludeUsersGuideEntriesForums
        /// </summary>
        public bool IncludeUsersGuideEntriesForums
        {
            get { return _includeUsersGuideEntriesForums; }
            set { _includeUsersGuideEntriesForums = value; }
        }
        /// <summary>
        /// Accessor for IncludeJournals
        /// </summary>
        public bool IncludeJournals
        {
            get { return _includeJournals; }
            set { _includeJournals = value; }
        }
        /// <summary>
        /// Accessor for IncludeRecentPosts
        /// </summary>
        public bool IncludeRecentPosts
        {
            get { return _includeRecentPosts; }
            set { _includeRecentPosts = value; }
        }
        /// <summary>
        /// Accessor for IncludeRecentComments
        /// </summary>
        public bool IncludeRecentComments
        {
            get { return _includeRecentComments; }
            set { _includeRecentComments = value; }
        }
        /// <summary>
        /// Accessor for IncludeRecentGuideEntries
        /// </summary>
        public bool IncludeRecentGuideEntries
        {
            get { return _includeRecentGuideEntries; }
            set { _includeRecentGuideEntries = value; }
        }
        /// <summary>
        /// Accessor for IncludeRecentUploads
        /// </summary>
        public bool IncludeRecentUploads
        {
            get { return _includeRecentUploads; }
            set { _includeRecentUploads = value; }
        }
        /// <summary>
        /// Accessor for IncludeRecentArticlesOfSubscribedUsers
        /// </summary>
        public bool IncludeRecentArticlesOfSubscribedUsers
        {
            get { return _includeRecentArticlesOfSubscribedUsers; }
            set { _includeRecentArticlesOfSubscribedUsers = value; }
        }

     }
}
