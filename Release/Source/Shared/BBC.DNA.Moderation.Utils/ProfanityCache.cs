using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Moderation.Utils
{
    [Serializable]
    public class ProfanityCache
    {
        public ProfanityCache()
        {
            //New structure to add the profanity list for a particular mod class
            ProfanityClasses = new Dictionary<int, ProfanityPair>();
        }

        /// <summary>
        /// The main, static data structure to hold the profanities
        /// It's a dictionary which maps a pair of word lists to each moderation class
        /// </summary>
        public Dictionary<int, ProfanityPair> ProfanityClasses;

    }

    /// <summary>
    /// This keyvalue pair contains both the id and the value of the term
    /// </summary>
    [Serializable]
    public class ProfanityPair
    {
        #region private prop(s)

        private List<KeyValuePair<int, string>> _termList = null;
        private List<KeyValuePair<int, string>> _referList = null;

        #endregion


        #region cons(s)

        public ProfanityPair()
        {
            ProfanityList = new List<KeyValuePair<int, string>>();
            ReferList = new List<KeyValuePair<int, string>>();
        }

        #endregion


        #region public prop(s)

        public List<KeyValuePair<int, string>> ProfanityList
        {
            get
            {
                return _termList;
            }
            set
            {
                _termList = value;
            }
        }

        public List<KeyValuePair<int, string>> ReferList
        {
            get
            {
                return _referList;
            }
            set
            {
                _referList = value;
            }
        }

        #endregion
    }
}
