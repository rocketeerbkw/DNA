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
            //New structure to add the profanity list for both the mod class and forum
            ProfanityClasses = new TermClasses();
        }

        /// <summary>
        /// The main, static data structure to hold the profanities
        /// It's a class which maps a pair of word lists to each moderation class and forum
        /// </summary>
        public TermClasses ProfanityClasses;

    }

    /// <summary>
    /// Class that holds two lists of profanities, one based on the modclass and the other based on the forum 
    /// </summary>
    [Serializable]
    public class TermClasses
    {
        #region con(s)

        public TermClasses()
        {
            ModClassProfanities = new Dictionary<int, ProfanityPair>();
            ForumProfanities = new Dictionary<int, ProfanityPair>();
        }

        #endregion

        #region public prop(s)

        /// <summary>
        /// The main, static data structure to hold the profanities
        /// It's a dictionary which maps a pair of word lists to each moderation class
        /// </summary>
        public Dictionary<int, ProfanityPair> ModClassProfanities;

        /// <summary>
        /// The main, static data structure to hold the profanities
        /// It's a dictionary which maps a pair of word lists to each forum
        /// </summary>
        public Dictionary<int, ProfanityPair> ForumProfanities;

        #endregion
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
