using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Moderation
{
    [Serializable]
    public class BannedEmailsList
    {

        public BannedEmailsList()
        {
            bannedEmailsList = new Dictionary<string, BannedEmailDetails>();
        }

        public Dictionary<string, BannedEmailDetails> bannedEmailsList 
        {
            get; set;
        }
    }
}
