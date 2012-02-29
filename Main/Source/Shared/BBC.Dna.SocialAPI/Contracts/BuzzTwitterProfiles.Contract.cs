using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.SocialAPI
{
    [DataContract(Name = "profiles", Namespace = "")]
    public class BuzzTwitterProfiles : List<BuzzTwitterProfile>
    {
        
    }
}
