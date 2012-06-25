using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;

namespace BBC.Dna.SocialAPI
{
    [Serializable]
    [CollectionDataContract(Name = "profiles", Namespace = "")]
    public class BuzzTwitterProfiles : List<BuzzTwitterProfile>
    {
        
    }
}
