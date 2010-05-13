using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using BBC.Dna.Moderation;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class TermsFilterImportPageBuilder : DnaInputComponent
    {
        private readonly ICacheManager _cache;
        private string _cmd = String.Empty;
        private bool _ignoreCache;
        private int _termId;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public TermsFilterImportPageBuilder(IInputContext context)
            : base(context)
        {
            _ignoreCache = false;

            _cache = CacheFactory.GetCacheManager();
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            if (InputContext.ViewingUser.IsSuperUser == false)
            {
                SerialiseAndAppend(new Error {Type = "Access Denied", ErrorMessage = "Access denied"}, "");
                return;
            }
            GetQueryParameters();
            BaseResult result = ProcessCommand();
            if (result != null)
            {
                SerialiseAndAppend(result, "");
            }

            //get terms associations if required
            if (_termId != 0)
            {
                GetTermActions();
            }

            //get all moderation classes
            ModerationClassList moderationClassList =
                ModerationClassList.GetAllModerationClasses(AppContext.ReaderCreator, _cache, _ignoreCache);
            SerialiseAndAppend(moderationClassList, "");
        }


        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private BaseResult ProcessCommand()
        {
            switch (_cmd.ToUpper())
            {
                case "UPDATETERMS":
                    return UpdateTerms();

                default:
                   
                    break;
            }
            return null;
        }

        /// <summary>
        /// Checks the parameters and updates the term passed in
        /// </summary>
        /// <returns></returns>
        private BaseResult UpdateTerms()
        {
            string reason = InputContext.GetParamStringOrEmpty("reason", "The reason for the change");
            if (reason == string.Empty)
            {
                return new Error {Type = "UPDATETERMMISSINGDESCRIPTION", ErrorMessage = "The import description cannot be empty."};
            }
            string termText = InputContext.GetParamStringOrEmpty("termtext", "the text of the term");
            string[] terms = termText.Split('\n');
            terms = terms.Where(x => x != String.Empty).Distinct().ToArray();
            
            if (terms.Length == 0)
            {
                return new Error
                           {Type = "UPDATETERMMISSINGTERM", ErrorMessage = "Terms text must contain newline delimited terms."};
            }

            var moderationClassList =
                ModerationClassList.GetAllModerationClasses(AppContext.ReaderCreator, _cache, _ignoreCache);


            var termsLists = new TermsLists();
            
            foreach (var modClass in moderationClassList.ModClassList)
            {
                //get all action or just the one for the specific mod class
                string actionParam = string.Format("action_modclassid_all");
                if(!InputContext.DoesParamExist(actionParam, "Modclass action value"))
                {
                    actionParam = string.Format("action_modclassid_{0}", modClass.ClassId);
                    if (!InputContext.DoesParamExist(actionParam, "Modclass action value")) continue;
                }

                //parse term id
                TermAction termAction;
                if(Enum.IsDefined(typeof(TermAction), InputContext.GetParamStringOrEmpty(actionParam, "Modclass action value")))
                {
                    termAction =
                        (TermAction)
                        Enum.Parse(typeof (TermAction),
                                   InputContext.GetParamStringOrEmpty(actionParam, "Modclass action value"));
                }
                else
                {
                    return new Error {Type = "UPDATETERMINVALIDACTION", ErrorMessage = "Terms action invalid."};
                }

                var termsList = new TermsList(modClass.ClassId);
                foreach (var term in terms)
                {
                    termsList.Terms.Add(new Term { Value = term, Action = termAction });
                }
                termsLists.Termslist.Add(termsList);
            }
            BaseResult error = termsLists.UpdateTermsInDatabase(AppContext.ReaderCreator, _cache, reason,
                                                                InputContext.ViewingUser.UserID);

            if (error == null)
            {
                return new Result("TermsUpdateSuccess", String.Format("{0} updated successfully.", terms.Length==1?"Term":"Terms"));
            }
            return error;
        }

        /// <summary>
        /// Finds all the action assoications for a given term
        /// </summary>
        /// <returns></returns>
        private void GetTermActions()
        {
            var moderationClassList =
                ModerationClassList.GetAllModerationClasses(AppContext.ReaderCreator, _cache, _ignoreCache);

            int[] modClassIds = moderationClassList.ModClassList.Select(modClass => modClass.ClassId).ToArray();

            TermsLists termsLists = TermsLists.GetAllTermsLists(AppContext.ReaderCreator, _cache,
                                                                modClassIds, _ignoreCache);


            //this was destroying the cache for some reason
            termsLists = (TermsLists)termsLists.Clone();
            termsLists.FilterListByTermId(_termId);
            if (termsLists.Termslist.Count != 0 && termsLists.Termslist[0].Terms.Count != 0)
            {
                SerialiseAndAppend(termsLists.Termslist[0].Terms[0], "");
                SerialiseAndAppend(termsLists, "");
            }
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _termId = InputContext.GetParamIntOrZero("s_termid", "The id of the term to check");
            _cmd = InputContext.GetParamStringOrEmpty("action", "Command string for flow");

#if DEBUG
            _ignoreCache = InputContext.GetParamIntOrZero("ignorecache", "Ignore the cache") == 1;
#endif
        }
    }
}