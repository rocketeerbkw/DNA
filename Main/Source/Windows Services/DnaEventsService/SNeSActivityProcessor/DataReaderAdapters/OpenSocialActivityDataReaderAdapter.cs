using System;
using System.Runtime.Serialization;
using BBC.Dna.Api;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using BBC.Dna.Utils;

namespace Dna.SnesIntegration.ActivityProcessor.DataReaderAdapters
{
    [DataContract(Name="OpenSocialActivity")]
    public class OpenSocialActivityDataReaderAdapter : OpenSocialActivity
    {
        

        public OpenSocialActivityDataReaderAdapter(IDnaDataReader dataReader)
        {
            Body = dataReader.GetString("Body");

            PostedTime = dataReader.GetDateTime("ActivityTime").MillisecondsSinceEpoch();
            DisplayName = dataReader.GetString("displayName");
            ObjectTitle = dataReader.GetString("ObjectTitle");
            ObjectDescription =dataReader.GetString("Body");
            UserName = dataReader.GetString("Username");
            var appName = dataReader.GetString("DnaUrl") ?? "";

            ObjectUri = (dataReader.GetString("ObjectUriFormat") ?? "").FormatReplacementStrings(dataReader.GetInt32("ForumID"), 
                dataReader.GetInt32("ThreadID"), dataReader.GetInt32("PostID"), appName, dataReader.GetString("BlogUrl") ?? "", 
                dataReader.GetString("ObjectUri") ?? "");

            ContentPermaUrl = (dataReader.GetString("ContentPermaUrl") ?? "").FormatReplacementStrings(dataReader.GetInt32("ForumID"),
                dataReader.GetInt32("ThreadID"), dataReader.GetInt32("PostID"), appName, dataReader.GetString("BlogUrl") ?? "",
                dataReader.GetString("ObjectUri") ?? "");
                
            CustomActivityType = dataReader.GetString("CustomActivityType") ?? "";

        }

        
    }
}


