using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;


namespace BBC.Dna.SocialAPI
{
    [ServiceContract]
    public interface IBuzz
    {
        [OperationContract]
        [WebInvoke(
            UriTemplate = "/profiles/", Method = "GET", 
                RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]


        BuzzTwitterProfiles GetProfiles();
    }
}
