using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.SocialAPI
{
    [DataContract(Name = "user", Namespace = "")]
    public class TweetUsers : TweetUser
    {
        //Can have a collection as twitter returns multiple users with a comma seperated screenname/id request
    }
}
