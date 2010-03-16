using System;
using System.Runtime.Serialization;
using BBC.Dna.Api;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor.Contracts;

namespace Dna.SnesIntegration.ActivityProcessor.DataReaderAdapters
{
    [DataContract(Name="OpenSocialActivity")]
    class OpenSocialActvivityDataReaderAdapter : OpenSocialActivity
    {
        public OpenSocialActvivityDataReaderAdapter(IDnaDataReader dataReader)
        {
            Body = dataReader.GetString("Body");
            PostedTime = dataReader.GetDateTime("ActivityTime").MillisecondsSinceEpoch();
            DisplayName = dataReader.GetString("displayName");
            ObjectTitle = dataReader.GetString("ObjectTitle");
            ObjectDescription = dataReader.GetString("Body");
            UserName = dataReader.GetString("Username");

            var uri = String.Empty;
            if (!dataReader.IsDBNull("ObjectUri"))
            {
                uri = dataReader.GetString("ObjectUri");
            }
            ObjectUri = new Uri(uri ?? "", UriKind.Relative);    
        }
    }
}


