using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// Class for the Category List Page parameters
    /// </summary>
    public class CategoryListPageParameters
    {
        /// <summary>
        /// Enumeration for the viewModes
        /// </summary>
	    public enum eCatListViewMode
	    {
            /// <summary>
            /// Node view
            /// </summary>
		    CLVM_NODES,
            /// <summary>
            /// List View
            /// </summary>
		    CLVM_LISTS
	    };
#region Private Fields

        private int _userID = 0;
        private string _GUID = String.Empty;
        private int _nodeID = 0;
        private string _command = String.Empty;
        private string _description = String.Empty;
        private int _listWidth = 0;


        private ArrayList _nodeList = new ArrayList();

        private eCatListViewMode _viewMode = eCatListViewMode.CLVM_LISTS;
#endregion

#region Accessors

        /// <summary>
        /// Accessor for ListWidth
        /// </summary>
        public int ListWidth
        {
            get { return _listWidth; }
            set { _listWidth = value; }
        }

        /// <summary>
        /// Accessor for NodeList
        /// </summary>
        public ArrayList NodeList
        {
            get { return _nodeList; }
            set { _nodeList = value; }
        }

        /// <summary>
        /// Accessor for Description
        /// </summary>
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }

        /// <summary>
        /// Accessor for ViewMode
        /// </summary>
        public eCatListViewMode ViewMode
        {
            get { return _viewMode; }
            set { _viewMode = value; }
        }
        /// <summary>
        /// Accessor for GUID
        /// </summary>
        public string GUID
        {
            get { return _GUID; }
            set { _GUID = value; }
        }
        /// <summary>
        /// Accessor for Command
        /// </summary>
        public string Command
        {
            get { return _command; }
            set { _command = value; }
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
        /// Accessor for NodeID
        /// </summary>
        public int NodeID
        {
            get { return _nodeID; }
            set { _nodeID = value; }
        }
#endregion
    }
}
