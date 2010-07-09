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
            ProfanityClasses = new Dictionary<int, ProfanityPair>();
        }

        /// <summary>
        /// The main, static data structure to hold the profanities
        /// It's a dictionary which maps a pair of word lists to each moderation class
        /// </summary>
        public Dictionary<int, ProfanityPair> ProfanityClasses;

    }

    [Serializable]
    public class ProfanityPair
    {
        public ProfanityPair()
        {
            ProfanityList = new List<string>();
            ReferList = new List<string>();

        }
        

        public List<string> ProfanityList
        {
            get;
            set;
        }

        public List<string> ReferList
        {
            get;
            set;
        }
    }
}
