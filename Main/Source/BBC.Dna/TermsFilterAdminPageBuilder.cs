
using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;
using System.Threading;
using System.ComponentModel;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class TermsFilterAdminPageBuilder : DnaInputComponent
    {
        private readonly ICacheManager _cache;
        private string _cmd = String.Empty;
        private int _modClassId = 1;
        private bool _ignoreCache;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public TermsFilterAdminPageBuilder(IInputContext context)
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
                SerialiseAndAppend(new Error { Type = "Access Denied", ErrorMessage = "Access denied" }, "");
                return;
            }

            GetQueryParameters();
            BaseResult result = ProcessCommand();
            if (result != null)
            {
                SerialiseAndAppend(result, "");
            }

            //get terms admin object
            TermsFilterAdmin termsAdmin = TermsFilterAdmin.CreateTermAdmin(AppContext.ReaderCreator, _cache, _modClassId, _ignoreCache);
            SerialiseAndAppend(termsAdmin, "");



        }


        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private BaseResult ProcessCommand()
        {
            switch (_cmd.ToUpper())
            {
                case "SHOWUPDATEFORM":
                    return null;//do nothing - this is just for the skins...

                case "UPDATETERM":
                    return UpdateTerm();

                case "REFRESHCACHE":
                    //run in background...
                    //var thread = new Thread(() => AppContext.TheAppContext.SendSignal("action=recache-site"));
                    //thread.IsBackground = true;
                    //thread.Priority = ThreadPriority.Highest;
                    //thread.Start();

                    AppContext.TheAppContext.SendSignal("recache-site");
                    return new Result("SiteRefreshSuccess", "Terms filter refresh initiated.");
            }
            return null;
        }

        /// <summary>
        /// Checks the parameters and updates the term passed in
        /// </summary>
        /// <returns></returns>
        private BaseResult UpdateTerm()
        {
            var modClassId = InputContext.GetParamIntOrZero("modclassid", "Moderation Class ID");
            if (modClassId == 0)
            {
                return new Error { Type = "UPDATETERM", ErrorMessage = "Moderation Class ID cannot be 0." };
            }
            var termText = InputContext.GetParamStringOrEmpty("termtext", "the text of the term");
            if (termText == String.Empty)
            {
                return new Error { Type = "UPDATETERM", ErrorMessage = "Terms text cannot be empty." };
            }
            TermAction termAction;
            try
            {
                termAction = (TermAction)Enum.Parse(typeof(TermAction), InputContext.GetParamStringOrEmpty("termaction", "the action of the term"), true);
            }
            catch (Exception)
            {
                return new Error { Type = "UPDATETERM", ErrorMessage = "Terms action invalid." };
            }
            var termList = new TermsList { ModClassId = modClassId };
            termList.Terms.Add(new Term { Value = termText, Action = termAction });
            Error error = termList.UpdateTermsInDatabase(AppContext.ReaderCreator, _cache, "Update through moderation tools",
                                           InputContext.ViewingUser.UserID);

            if (error == null)
            {
                return new Result("TermsUpdateSuccess", "Terms updated successfully.");
            }
            return error;
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _modClassId = InputContext.GetParamIntOrZero("modclassid", "Moderation Class ID");
            if (_modClassId == 0)
            {//default to the first one...(standard universal)
                _modClassId = 1;
            }
            _cmd = InputContext.GetParamStringOrEmpty("action", "Command string for flow");

#if DEBUG
            _ignoreCache = InputContext.GetParamIntOrZero("ignorecache", "Ignore the cache") == 1;
#endif
        }
    }
}