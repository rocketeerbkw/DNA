using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class SearchThreadPostPageBuilder : DnaInputComponent
    {
        private int _forumId = 0;
        private int _skip =0;
        private const int POSTSTOSHOW = 50;
        private string _searchText = string.Empty;
        private bool _ignoreCache = false;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public SearchThreadPostPageBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            if (InputContext.IsPreviewMode())
            {
                RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetPreviewTopicsXml(AppContext.ReaderCreator)));
            }
            else
            {
                RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
            }

            if (!InputContext.TheSiteList.GetSiteOptionValueBool(InputContext.CurrentSite.SiteID, "Forum", "EnableSearch"))
            {
                AddErrorXml("SearchDisabled", "Search has not been configured for this application.", null);
                return;
            }

            //get the parameters from the querystring
            GetQueryParameters();

            if (String.IsNullOrEmpty(_searchText))
            {
                //AddErrorXml("MissingSearchText", "Please enter some valid search text", null);
                return;
            }
            var searchThreads = SearchThreadPosts.GetSearchThreadPosts(AppContext.ReaderCreator, CacheFactory.GetCacheManager(), InputContext.CurrentSite,
                    _forumId, 0, POSTSTOSHOW, _skip, _searchText, _ignoreCache);
            SerialiseAndAppend(searchThreads, "");

            if (searchThreads.Posts.Count == 0)
            {
                AddErrorXml("NoSearchResultsFound", "No results found, please refine your search.", null);
            }

            

        }


        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _forumId = InputContext.GetParamIntOrZero("ID", "Forum ID");
            if (_forumId == 0)
            {
                _forumId = InputContext.GetParamIntOrZero("forum", "Forum ID");
            }

            
            _skip = InputContext.GetParamIntOrZero("skip", "Number of items to skip to");
            _searchText = InputContext.GetParamStringOrEmpty("searchtext", "text to search");

            
#if DEBUG
            _ignoreCache = InputContext.GetParamIntOrZero("ignorecache", "Ignore the cache") == 1;
#endif
        }
    }
}