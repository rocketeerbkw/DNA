using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Runtime.Serialization;


namespace BBC.Dna.SocialAPI
{
    [ServiceContract]
    public interface IBuzz
    {
        [OperationContract]
        [WebInvoke(
            UriTemplate = "/users/show.xml?screen_name={username}", Method = "GET")]


        BuzzTwitterProfiles GetProfiles();
    }
}
