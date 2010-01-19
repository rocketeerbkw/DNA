using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;
using BBC.Dna.Component;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Holds the ContentSignifAdminBuilder class
    /// </summary>
    public class ContentSignifAdminBuilder : DnaInputComponent
    {
        private const string _docDnaUpdateSiteSettings = @"Whether the action is to update settings.";
        private const string _docDnaDecrementContentSignif = @"Whether the action is to decrement settings.";
        
        /// <summary>
        /// Default Constructor for the ContentSignifAdminBuilder object
        /// </summary>
        public ContentSignifAdminBuilder(IInputContext context)
            : base(context)
        {
        }
        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();

            ContentSignifSettingsParameters parameters = new ContentSignifSettingsParameters();
            TryGetPageParams(ref parameters);
            
            ContentSignifSettings contentSignifSettings = new ContentSignifSettings(InputContext);
            if(parameters.UpdateSiteSettings)
            {
                contentSignifSettings.SetSiteSpecificContentSignifSettings(InputContext.CurrentSite.SiteID, parameters);
            }
            else if (parameters.DecrementContentSignif)
            {
                contentSignifSettings.DecrementContentSignif(InputContext.CurrentSite.SiteID);
            }
            contentSignifSettings.GetSiteSpecificContentSignifSettings(InputContext.CurrentSite.SiteID);

            // Add the sites topic list
            //RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
            // Add site list xml
            //RootElement.AppendChild(ImportNode(InputContext.TheSiteList.GenerateAllSitesXml().FirstChild));

            AddInside(contentSignifSettings);
        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="parameters">Class containing all the Content Signif Settings parameters.</param>
        private void TryGetPageParams(ref ContentSignifSettingsParameters parameters)
        {
            if (InputContext.DoesParamExist("updatesitesettings", _docDnaUpdateSiteSettings))
            {
                parameters.UpdateSiteSettings = true;

                NameValueCollection decrementParams = new NameValueCollection();
                NameValueCollection incrementParams = new NameValueCollection();

                decrementParams = InputContext.GetAllParamsWithPrefix("d_");
                incrementParams = InputContext.GetAllParamsWithPrefix("i_");

                int count = 0;

                count = FillParameters(parameters, decrementParams, count);
                count = FillParameters(parameters, incrementParams, count);
            }
            else if (InputContext.DoesParamExist("decrementcontentsignif", _docDnaDecrementContentSignif))
            {
                parameters.DecrementContentSignif = true;
            }
        }

        private static int FillParameters(ContentSignifSettingsParameters parameters, NameValueCollection collectionParams, int count)
        {
            foreach (string paramname in collectionParams)
            {
                count++;
                switch (count)
                {
                    case 1: parameters.Param1 = paramname + "=" + collectionParams[paramname]; break;
                    case 2: parameters.Param2 = paramname + "=" + collectionParams[paramname]; break;
                    case 3: parameters.Param3 = paramname + "=" + collectionParams[paramname]; break;
                    case 4: parameters.Param4 = paramname + "=" + collectionParams[paramname]; break;
                    case 5: parameters.Param5 = paramname + "=" + collectionParams[paramname]; break;
                    case 6: parameters.Param6 = paramname + "=" + collectionParams[paramname]; break;
                    case 7: parameters.Param7 = paramname + "=" + collectionParams[paramname]; break;
                    case 8: parameters.Param8 = paramname + "=" + collectionParams[paramname]; break;
                    case 9: parameters.Param9 = paramname + "=" + collectionParams[paramname]; break;
                    case 10: parameters.Param10 = paramname + "=" + collectionParams[paramname]; break;
                    case 11: parameters.Param11 = paramname + "=" + collectionParams[paramname]; break;
                    case 12: parameters.Param12 = paramname + "=" + collectionParams[paramname]; break;
                    case 13: parameters.Param13 = paramname + "=" + collectionParams[paramname]; break;
                    case 14: parameters.Param14 = paramname + "=" + collectionParams[paramname]; break;
                    case 15: parameters.Param15 = paramname + "=" + collectionParams[paramname]; break;
                    case 16: parameters.Param16 = paramname + "=" + collectionParams[paramname]; break;
                    case 17: parameters.Param17 = paramname + "=" + collectionParams[paramname]; break;
                    case 18: parameters.Param18 = paramname + "=" + collectionParams[paramname]; break;
                    case 19: parameters.Param19 = paramname + "=" + collectionParams[paramname]; break;
                    case 20: parameters.Param20 = paramname + "=" + collectionParams[paramname]; break;
                    case 21: parameters.Param21 = paramname + "=" + collectionParams[paramname]; break;
                    case 22: parameters.Param22 = paramname + "=" + collectionParams[paramname]; break;
                    case 23: parameters.Param23 = paramname + "=" + collectionParams[paramname]; break;
                    case 24: parameters.Param24 = paramname + "=" + collectionParams[paramname]; break;
                    case 25: parameters.Param25 = paramname + "=" + collectionParams[paramname]; break;
                    case 26: parameters.Param26 = paramname + "=" + collectionParams[paramname]; break;
                    case 27: parameters.Param27 = paramname + "=" + collectionParams[paramname]; break;
                    case 28: parameters.Param28 = paramname + "=" + collectionParams[paramname]; break;
                    case 29: parameters.Param29 = paramname + "=" + collectionParams[paramname]; break;
                    case 30: parameters.Param30 = paramname + "=" + collectionParams[paramname]; break;
                    case 31: parameters.Param31 = paramname + "=" + collectionParams[paramname]; break;
                    case 32: parameters.Param32 = paramname + "=" + collectionParams[paramname]; break;
                    case 33: parameters.Param33 = paramname + "=" + collectionParams[paramname]; break;
                    case 34: parameters.Param34 = paramname + "=" + collectionParams[paramname]; break;
                    case 35: parameters.Param35 = paramname + "=" + collectionParams[paramname]; break;
                }
            }
            return count;
        }
    }
}