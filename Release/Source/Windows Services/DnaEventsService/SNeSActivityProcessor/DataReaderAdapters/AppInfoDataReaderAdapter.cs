using BBC.Dna.Data;

namespace Dna.SnesIntegration.ActivityProcessor.DataReaderAdapters
{
    class AppInfoDataReaderAdapter : DnaApplicationInfo
    {
        public AppInfoDataReaderAdapter(IDnaDataReader dataReader)
        {
            AppId = dataReader.GetString("AppId");
            ApplicationName = dataReader.GetString("AppName");
        }
    }
}