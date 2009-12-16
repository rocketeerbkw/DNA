using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// Class to store all Article Search parameters
    /// </summary>
    public class MediaAssetParameters
    {
        /// <summary>
        /// Enumerates the types of action allowed
        /// </summary>
        public enum MediaAssetAction
        {
            /// <summary>
            /// action = create
            /// </summary>
            create,
            /// <summary>
            /// action = update
            /// </summary>
            update,
            /// <summary>
            /// action = view
            /// </summary>
            view,
            /// <summary>
            /// action = showusersassets
            /// </summary>
            showusersassets,
            /// <summary>
            /// action = showusersarticleswithassets
            /// </summary>
            showusersarticleswithassets,
            /// <summary>
            /// action = showftpuploadqueue
            /// </summary>
            showftpuploadqueue,
            /// <summary>
            /// action = reprocessfaileduploads
            /// </summary>
            reprocessfaileduploads
        }

        int _mediaAssetID = 0;
        int _skip = 0;
        int _show = 0;
        int _contentType = 0;
        MediaAssetAction _action = MediaAssetAction.view;
        int _userid = 0;
        int _h2g2id = 0;
        
        string _sortBy = String.Empty;
        bool _isOwner = false;
        bool _addToLibrary = false;
        bool _updateDataLoaded = false;
        bool _isExternalLink = false;
        bool _isManualUpload = false;
        int _rpmaid = 0;



        /// <summary>
        /// Accessor for MediaAssetID
        /// </summary>
        public int MediaAssetID
        {
            get { return _mediaAssetID; }
            set { _mediaAssetID = value; }
        }

        /// <summary>
        /// Accessor for Action
        /// </summary>
        public MediaAssetAction Action
        {
            get { return _action; }
            set { _action = value; }
        }
        /// <summary>
        /// Accessor for IsOwner
        /// </summary>
        public bool IsOwner
        {
            get { return _isOwner; }
            set { _isOwner = value; }
        }
        /// <summary>
        /// Accessor for Skip
        /// </summary>
        public int Skip
        {
            get { return _skip; }
            set { _skip = value; }
        }
        /// <summary>
        /// Accessor for Show
        /// </summary>
        public int Show
        {
            get { return _show; }
            set { _show = value; }
        }
        /// <summary>
        /// Accessor for SortBy
        /// </summary>
        public string SortBy
        {
            get { return _sortBy; }
            set { _sortBy = value; }
        }
        /// <summary>
        /// Accessor for H2G2ID
        /// </summary>
        public int H2G2ID
        {
            get { return _h2g2id; }
            set { _h2g2id = value; }
        }
        /// <summary>
        /// Accessor for UserID
        /// </summary>
        public int UserID
        {
            get { return _userid; }
            set { _userid = value; }
        }
        /// <summary>
        /// Accessor for ContentType
        /// </summary>
        public int ContentType
        {
            get { return _contentType; }
            set { _contentType = value; }
        }
        /// <summary>
        /// Accessor for AddToLibrary
        /// </summary>
        public bool AddToLibrary
        {
            get { return _addToLibrary; }
            set { _addToLibrary = value; }
        }
        /// <summary>
        /// Accessor for UpdateDataLoaded
        /// </summary>
        public bool UpdateDataLoaded
        {
            get { return _updateDataLoaded; }
            set { _updateDataLoaded = value; }
        }
        /// <summary>
        /// Accessor for IsExternalLink
        /// </summary>
        public bool IsExternalLink
        {
            get { return _isExternalLink; }
            set { _isExternalLink = value; }
        }
        /// <summary>
        /// Accessor for IsManualUpload
        /// </summary>
        public bool IsManualUpload
        {
            get { return _isManualUpload; }
            set { _isManualUpload = value; }
        }
        /// <summary>
        /// Accessor for Rpmaid
        /// </summary>
        public int Rpmaid
        {
            get { return _rpmaid; }
            set { _rpmaid = value; }
        }
    }
}
