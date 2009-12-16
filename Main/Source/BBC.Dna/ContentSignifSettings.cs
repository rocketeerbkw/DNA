using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Holds the ContentSignifSettings class
    /// </summary>
    public class ContentSignifSettings : DnaInputComponent
    {
        /// <summary>
        /// Default Constructor for the ContentSignifSettings object
        /// </summary>
        public ContentSignifSettings(IInputContext context)
            : base(context)
        {
        }
       /// <summary>
        /// Gets site specific ContentSignif settings
        /// </summary>
        /// <param name="siteID">SiteID you want SignifContent settings for</param>
        /// <returns>Xml Element containing the signif settings</returns>
        public XmlElement GetSiteSpecificContentSignifSettings(int siteID)
        {
            RootElement.RemoveAll();

            XmlElement signifContentSettings = AddElementTag(RootElement, "CONTENTSIGNIFSETTINGS");
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getsitespecificcontentsignifsettings"))
            {
                dataReader.AddParameter("siteID", siteID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    do
                    {
                        string actionDescription = dataReader.GetStringNullAsEmpty("ACTIONDESC");
                        string itemDescription = dataReader.GetStringNullAsEmpty("ITEMDESC");
                        string settingType = dataReader.GetStringNullAsEmpty("SETTINGTYPE");

                        int actionID = dataReader.GetInt32NullAsZero("ACTIONID");
                        int itemID = dataReader.GetInt32NullAsZero("ITEMID");
                        int value = dataReader.GetInt32NullAsZero("VALUE");

                        XmlElement setting = AddElementTag(signifContentSettings, "SETTING");
                        AddAttribute(setting, "TYPE", StringUtils.EscapeAllXmlForAttribute(settingType));

                        XmlElement action = AddElementTag(setting, "ACTION");
                        AddIntElement(action, "ID", actionID);
                        AddTextTag(action, "DESCRIPTION", actionDescription);

                        XmlElement item = AddElementTag(setting, "ITEM");
                        AddIntElement(item, "ID", itemID);
                        AddTextTag(item, "DESCRIPTION", itemDescription);

                        AddIntElement(setting, "VALUE", value);
                    } while (dataReader.Read());
                }
            }
            return signifContentSettings;
        }

        /// <summary>
        /// Sets the Site Specific Settings for the given site with the parameters
        /// </summary>
        /// <param name="siteID">The site</param>
        /// <param name="parameter">The parameters</param>
        public void SetSiteSpecificContentSignifSettings(int siteID, ContentSignifSettingsParameters parameter)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updatesitespecificcontentsignifsettings"))
            {
                dataReader.AddParameter("siteID", siteID)
                    .AddParameter("param1", parameter.Param1)
                    .AddParameter("param2", parameter.Param2)
                    .AddParameter("param3", parameter.Param3)
                    .AddParameter("param4", parameter.Param4)
                    .AddParameter("param5", parameter.Param5)
                    .AddParameter("param6", parameter.Param6)
                    .AddParameter("param7", parameter.Param7)
                    .AddParameter("param8", parameter.Param8)
                    .AddParameter("param9", parameter.Param9)
                    .AddParameter("param10", parameter.Param10)
                    .AddParameter("param11", parameter.Param11)
                    .AddParameter("param12", parameter.Param12)
                    .AddParameter("param13", parameter.Param13)
                    .AddParameter("param14", parameter.Param14)
                    .AddParameter("param15", parameter.Param15)
                    .AddParameter("param16", parameter.Param16)
                    .AddParameter("param17", parameter.Param17)
                    .AddParameter("param18", parameter.Param18)
                    .AddParameter("param19", parameter.Param19)
                    .AddParameter("param20", parameter.Param20)
                    .AddParameter("param21", parameter.Param21)
                    .AddParameter("param22", parameter.Param22)
                    .AddParameter("param23", parameter.Param23)
                    .AddParameter("param24", parameter.Param24)
                    .AddParameter("param25", parameter.Param25)
                    .AddParameter("param26", parameter.Param26)
                    .AddParameter("param27", parameter.Param27)
                    .AddParameter("param28", parameter.Param28)
                    .AddParameter("param29", parameter.Param29)
                    .AddParameter("param30", parameter.Param30)
                    .AddParameter("param31", parameter.Param31)
                    .AddParameter("param32", parameter.Param32)
                    .AddParameter("param33", parameter.Param33)
                    .AddParameter("param34", parameter.Param34)
                    .AddParameter("param35", parameter.Param35);

                dataReader.Execute();
            }
        }
        /// <summary>
        /// Decrements site's ContentSignif tables.
        /// </summary>
        /// <param name="siteID">Site to use</param>
        public void DecrementContentSignif(int siteID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("ContentSignifSiteDecrement"))
            {
                dataReader.AddParameter("siteID", siteID);
                dataReader.Execute();
            }
        }
    }
}