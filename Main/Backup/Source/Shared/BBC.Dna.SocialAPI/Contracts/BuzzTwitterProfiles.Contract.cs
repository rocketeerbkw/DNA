using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace BBC.Dna.SocialAPI
{
    [Serializable]
    [CollectionDataContract(Name = "profiles", Namespace = "")]
    public class BuzzTwitterProfiles : List<BuzzTwitterProfile>
    {
        
    }
}
