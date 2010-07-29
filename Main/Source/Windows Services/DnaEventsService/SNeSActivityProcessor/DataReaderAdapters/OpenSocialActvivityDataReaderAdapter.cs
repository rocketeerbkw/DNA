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

            var appName = dataReader.GetString("DnaUrl") ?? "";
            var baseUriPath = "bbc:dna";
            if (appName.ToUpper() == "IPLAYERTV" || appName.ToUpper() == "IPLAYERRADIO")
            {//TODO: replace this with site wide value
                baseUriPath = "bbc:programme";
            }
            if(!String.IsNullOrEmpty(dataReader.GetString("ObjectUri")))
            {
                ObjectUri = string.Format("{0}:{1}:{2}", baseUriPath, dataReader.GetString("ObjectUri"), dataReader.GetInt32("PostID"));    
            }
            else
            {
                ObjectUri = string.Format("{0}:{1}:{2}:{3}", baseUriPath, dataReader.GetInt32("ForumID"), dataReader.GetInt32("ThreadID"), dataReader.GetInt32("PostID"));    
            }

            
        }
    }
}


