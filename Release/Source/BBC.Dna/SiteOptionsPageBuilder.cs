using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Sites;
using System.Xml;
using System.Collections.Specialized;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// The site options page builder class
    /// </summary>
    public class SiteOptionsPageBuilder : DnaInputComponent
    {
        private ISite selectedSite = null;
        List<SiteOption> siteOptions = null;
        string command = "";

        private static int SITEID = 1;
        private static int SECTION = 2;
        private static int NAME = 3;

        /// <summary>
        /// Default constructor of SubArticleStatusBuilder
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SiteOptionsPageBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Process the current request
        /// </summary>
        public override void ProcessRequest()
        {
            if (!InputContext.ViewingUser.IsEditor)
            {
                AddErrorXml("NOTAUTHORISED", "USer does not have the correct priviledges to view this page", RootElement);
                return;
            }

            GetInputParams();

            siteOptions = InputContext.TheSiteList.GetSiteOptionListForSite(selectedSite.SiteID);
            if (null == siteOptions)
            {
                AddErrorXml("SITEOPTIONS", "No site options found", RootElement);
                return;
            }

            ProcessCommand();

            GenerateXML();
        }

        private void ProcessCommand()
        {
            if (command.ToLower().CompareTo("update") == 0)
            {
                if (!UpdateSiteOptions())
                {
                    AddErrorXml("SITEOPTIONS", "Failed to update siteoptions", RootElement);
                }
            }
        }

        private bool UpdateSiteOptions()
        {
            List<SiteOption> updateOptions = GetUpdateOptionsList();
            if (updateOptions.Count > 0)
            {
                SiteOption.UpdateSiteOptions(updateOptions, InputContext.CreateDnaDataReaderCreator());
            }
            return true;
        }

        private List<SiteOption> GetUpdateOptionsList()
        {
            int updateSiteID = 0;

            Dictionary<string, string[]> onOffs = new Dictionary<string, string[]>();
            NameValueCollection siteoptionOnOff = InputContext.GetAllParamsWithPrefix("so_");
            updateSiteID = GetSiteOptionParamValues(siteoptionOnOff, updateSiteID, onOffs);

            Dictionary<string, string[]> values = new Dictionary<string, string[]>();
            NameValueCollection siteoptionValues = InputContext.GetAllParamsWithPrefix("sov_");
            GetSiteOptionParamValues(siteoptionValues, updateSiteID, values);

            RemoveOffStateSiteOptions(onOffs, values);

            List<SiteOption> updatedOptions = new List<SiteOption>();
            if (values.Count > 0 && updateSiteID > 0)
            {
                StringBuilder itemsUpdated = new StringBuilder();
                List<SiteOption> currentSiteOptions = InputContext.TheSiteList.GetSiteOptionListForSite(updateSiteID);
                foreach (SiteOption so in currentSiteOptions)
                {
                    bool optionChanged = false;
                    bool optionRemoved = false;
                    string key = so.Name + "_" + so.Section;
                    if (values.ContainsKey(key))
                    {
                        optionChanged = CheckAndAddOptionForUpdate(updatedOptions, values, so, key);
                    }
                    else
                    {
                        SiteOption.RemoveSiteOptionFromSite(so, selectedSite.SiteID, InputContext.CreateDnaDataReaderCreator());
                        optionRemoved = true;
                    }

                    if (optionChanged)
                    {
                        itemsUpdated.AppendLine("Option Updated : " + key);
                    }

                    if (optionRemoved)
                    {
                        itemsUpdated.AppendLine("Option Removed : " + key);
                    }
                }
                InputContext.TheSiteList.SendSignal(selectedSite.SiteID);
                Site.CreateSiteNotes(updateSiteID, itemsUpdated.ToString(), InputContext.ViewingUser.UserID, InputContext.CreateDnaDataReaderCreator());
            }

            return updatedOptions;
        }

        private bool CheckAndAddOptionForUpdate(List<SiteOption> updatedOptions, Dictionary<string, string[]> values, SiteOption so, string key)
        {
            bool optionChanged = false;
            SiteOption update = SiteOption.CreateFromDefault(so, selectedSite.SiteID);
            if (update.IsTypeBool())
            {
                bool newValue = (String)values[key].GetValue(0) == "1";
                if (update.GetValueBool() != newValue)
                {
                    update.SetValueBool(newValue);
                    updatedOptions.Add(update);
                    optionChanged = true;
                }
            }
            else if (update.IsTypeInt())
            {
                int newValue = 0;
                if (Int32.TryParse((String)values[key].GetValue(0), out newValue))
                {
                    if (update.GetValueInt() != newValue)
                    {
                        update.SetValueInt(newValue);
                        updatedOptions.Add(update);
                        optionChanged = true;
                    }
                }
            }
            else if (update.IsTypeString())
            {
                String newValue = (String)values[key].GetValue(0);
                if (update.GetValueString() != newValue)
                {
                    update.SetValueString(newValue);
                    updatedOptions.Add(update);
                    optionChanged = true;
                }
            }
            return optionChanged;
        }

        private static void RemoveOffStateSiteOptions(Dictionary<string, string[]> onOffs, Dictionary<string, string[]> values)
        {
            foreach (KeyValuePair<string, string[]> onOff in onOffs)
            {
                if (onOff.Value[0] == "0,0" && values.ContainsKey(onOff.Key))
                {
                    values.Remove(onOff.Key);
                }
                else if (onOff.Value[0] == "0,1" && !values.ContainsKey(onOff.Key))
                {
                    // This copes with tuning on a bool siteoption but is in the off state. No value param is ssent through for bool off settings.
                    values.Add(onOff.Key, new string[] { "0" });
                }
            }
        }

        private int GetSiteOptionParamValues(NameValueCollection siteoptionParams, int updateSiteID, Dictionary<string, string[]> values)
        {
            for (int i = 0; i < siteoptionParams.Count; i++)
            {
                string[] optionDetails = siteoptionParams.GetKey(i).Split('_');
                values.Add(optionDetails[NAME] + "_" + optionDetails[SECTION], siteoptionParams.GetValues(i));
                if (updateSiteID == 0)
                {
                    Int32.TryParse(optionDetails[SITEID], out updateSiteID);
                }
                InputContext.Diagnostics.WriteToLog("OPTION-SORT", siteoptionParams.GetKey(i) + "---" + siteoptionParams.GetValues(i)[0]);
            }

            return updateSiteID;
        }

        private void GenerateXML()
        {
            AddEditableSitesXML();
            AddCurrentSiteSiteOptionsXML();
            AddDefaultSiteOptionsListXML();
            AddProcessingSiteXML();
        }

        private void AddDefaultSiteOptionsListXML()
        {
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            RootElement.AppendChild(ImportNode(siteXml.GetSiteOptionListForSiteXml(0, InputContext.TheSiteList, true)));
        }

        private void AddCurrentSiteSiteOptionsXML()
        {
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            RootElement.AppendChild(ImportNode(siteXml.GetSiteOptionListForSiteXml(selectedSite.SiteID, InputContext.TheSiteList, true)));
        }

        private void AddEditableSitesXML()
        {
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            RootElement.AppendChild(ImportNode(siteXml.GenerateSitesForUserAsEditorXml(InputContext.TheSiteList, false, "EDITABLESITES").FirstChild));
        }

        private void AddProcessingSiteXML()
        {
            XmlElement processXml = AddElementTag(RootElement, "PROCESSINGSITE");
            XmlElement processedSiteXML = AddElementTag(processXml, "SITE");
            AddAttribute(processedSiteXML, "ID", selectedSite.SiteID);
            AddTextElement(processedSiteXML, "NAME", selectedSite.SiteName);
            AddTextElement(processedSiteXML, "DESCRIPTION", selectedSite.Description);
            AddTextElement(processedSiteXML, "SHORTNAME", selectedSite.ShortName);
        }

        private void GetInputParams()
        {
            int selectedSiteID = 0;
            if (InputContext.DoesParamExist("siteid", "Requested site ID"))
            {
                selectedSiteID = InputContext.GetParamIntOrZero("siteid", "Requested site ID");
            }
            if (selectedSiteID == 0)
            {
                selectedSiteID = InputContext.CurrentSite.SiteID;
            }
            selectedSite = InputContext.TheSiteList.GetSite(selectedSiteID);
            if (InputContext.DoesParamExist("cmd", "The action for the page"))
            {
                command = InputContext.GetParamStringOrEmpty("cmd", "The action for the page");
            }
        }
    }
}
