namespace BBC.Dna
{
    /// <summary>
    /// Class to store all Mod Home parameters
    /// </summary>
    public class ModHomeParameters
    {
        /// <remarks name="owner">Owner id</remarks>
        /// <remarks name="siteID">Site id to run against</remarks>
        /// <remarks name="fastMod">to fast mod</remarks>
        /// <remarks name="notfastMod">or not fast mod</remarks>
        /// <remarks name="modclassid">mod class id</remarks>

        int _ownerID = 0;
        /// <summary>
        /// Accessor
        /// </summary>
        public int OwnerID
        {
            get { return _ownerID; }
            set { _ownerID = value; }
        }
        int _siteID = 0;
        /// <summary>
        /// Accessor
        /// </summary>
        public int SiteID
        {
            get { return _siteID; }
            set { _siteID = value; }
        }

        int _fastMod = 0;
        /// <summary>
        /// Accessor
        /// </summary>
        public int FastMod
        {
            get { return _fastMod; }
            set { _fastMod = value; }
        }
        int _notFastMod = 0;
        /// <summary>
        /// Accessor
        /// </summary>
        public int NotFastMod
        {
            get { return _notFastMod; }
            set { _notFastMod = value; }
        }

        int _modClassID = 0;
        /// <summary>
        /// Accessor
        /// </summary>
        public int ModClassID
        {
            get { return _modClassID; }
            set { _modClassID = value; }
        }

        bool _unlockForums = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockForums
        {
            get { return _unlockForums; }
            set { _unlockForums = value; }
        }
        bool _unlockForumReferrals = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockForumReferrals
        {
            get { return _unlockForumReferrals; }
            set { _unlockForumReferrals = value; }
        }
        bool _unlockUserPosts = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockUserPosts
        {
            get { return _unlockUserPosts; }
            set { _unlockUserPosts = value; }
        }
        bool _unlockSitePosts = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockSitePosts
        {
            get { return _unlockSitePosts; }
            set { _unlockSitePosts = value; }
        }
        bool _unlockAllPosts = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockAllPosts
        {
            get { return _unlockAllPosts; }
            set { _unlockAllPosts = value; }
        }
        bool _unlockArticles = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockArticles
        {
            get { return _unlockArticles; }
            set { _unlockArticles = value; }
        }
        bool _unlockArticleReferrals = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockArticleReferrals
        {
            get { return _unlockArticleReferrals; }
            set { _unlockArticleReferrals = value; }
        }
        bool _unlockGeneral = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockGeneral
        {
            get { return _unlockGeneral; }
            set { _unlockGeneral = value; }
        }
        bool _unlockGeneralReferrals = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockGeneralReferrals
        {
            get { return _unlockGeneralReferrals; }
            set { _unlockGeneralReferrals = value; }
        }
        bool _unlockNicknames = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockNicknames
        {
            get { return _unlockNicknames; }
            set { _unlockNicknames = value; }
        }
        bool _unlockAll = false;
        /// <summary>
        /// Accessor
        /// </summary>
        public bool UnlockAll
        {
            get { return _unlockAll; }
            set { _unlockAll = value; }
        }

    }
}
