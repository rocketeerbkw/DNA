using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Moderation
{
    public enum ModerationRetrievalPolicy
    {
        Standard =0,// split list of normal and fastmod, returned in date ascending order 
        LIFO = 1, //Last in first out
        PriorityFirst =2 //fast mod, then other items
    }
}
