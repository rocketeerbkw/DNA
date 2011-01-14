using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;
using BBC.Dna.Sites;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class MBFrontPageBuilder : DnaInputComponent
    {


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public MBFrontPageBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Assemble page parts.
            //add topics
            if (InputContext.IsPreviewMode())
            {
                RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetPreviewTopicsXml(AppContext.ReaderCreator)));
            }
            else
            {
                RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
            }
            TopicStatus status = InputContext.IsPreviewMode()? TopicStatus.Preview: TopicStatus.Live;

            FrontPageTopicElementList frontPageTopicElementList = FrontPageTopicElementList.GetFrontPageElementListFromCache(AppContext.ReaderCreator, status, false, CacheFactory.GetCacheManager(),
                InputContext.TheSiteList.GetLastUpdated(), false, InputContext.CurrentSite.SiteID);
            SerialiseAndAppend(frontPageTopicElementList, String.Empty);

            
        }

    }
}