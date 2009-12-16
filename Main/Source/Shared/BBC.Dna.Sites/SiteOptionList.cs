using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Linq;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// A list of all the site options
    /// </summary>
    public class SiteOptionList : Context
    {
        private List<SiteOption> _siteOptionList;
        private Dictionary<string, SiteOption> _siteOptionDictionary;
        /// <summary>
        /// Creates the SiteOptionList
        /// </summary>
        public SiteOptionList(IDnaDiagnostics dnaDiagnostics, string connection)
            : base(dnaDiagnostics, connection)
        {
        }

        /// <summary>
        /// Creates a list of site options by reading them from the database
        /// </summary>
        public void CreateFromDatabase()
        {
            dnaDiagnostics.WriteTimedEventToLog("SiteOptionList", "Creating list from database");

            _siteOptionList = new List<SiteOption>();
            _siteOptionDictionary = new Dictionary<string, SiteOption>();

            int siteId = 0;
            string section;
            string name;
            string value;
            int type = 0;
            string description;

            using (IDnaDataReader dataReader = CreateReader("getallsiteoptions"))
            {
                dataReader.Execute();

                while (dataReader.Read())
                {
                    siteId = dataReader.GetInt32("SiteID");
                    section = dataReader.GetString("Section");
                    name = dataReader.GetString("Name");
                    value = dataReader.GetString("Value");
                    type = dataReader.GetInt32("Type");
                    description = dataReader.GetString("Description");

                    SiteOption.SiteOptionType soType;

                    switch (type)
                    {
                        case 0: soType = SiteOption.SiteOptionType.Int; break;
                        case 1: soType = SiteOption.SiteOptionType.Bool; break;
                        case 2: soType = SiteOption.SiteOptionType.String; break;
                        default: throw new SiteOptionInvalidTypeException("Bad type in database");
                    }

                    SiteOption siteOption = new SiteOption(siteId, section, name, value, soType, description);
                    _siteOptionList.Add(siteOption);

                    string key = GetKey(siteId, section, name);
                    _siteOptionDictionary.Add(key, siteOption);

                }
            }
            dnaDiagnostics.WriteTimedEventToLog("SiteOptionList", "Created list from database");
        }

        private string GetKey( int siteId, string section, string name )
        {
            return Convert.ToString(siteId) + section.ToLower() + name.ToLower();
        }

        protected bool TryFindSiteOption(int siteId, string section, string name, out SiteOption siteOption)
        {
            string key = GetKey(siteId, section, name );
            return _siteOptionDictionary.TryGetValue(key, out siteOption);
        }

        /// <summary>
        /// <para>
        /// Creates a new SiteOption object based on the site option specified
        /// </para>
        /// <para>
        /// If a site option is not available for the given site, the values for "site zero" are given,
        /// i.e. the app-wide default settings for the requested option
        /// </para>
        /// </summary>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <param name="siteId">The site id for this option</param>
        /// <param name="section">Section name of option</param>
        /// <param name="name">Name of option</param>
        /// <returns>New SiteOption containing a copy of the option specified</returns>
        public SiteOption CreateSiteOption(int siteId, string section, string name)
        {
            SiteOption siteOption = null;
            if (TryFindSiteOption(siteId, section, name, out siteOption))
            {
                return SiteOption.CreateFromDefault(siteOption, siteId);
            }

            // If option doesn't exist for the given site, look for default value
            if (TryFindSiteOption(0, section, name, out siteOption))
            {
                return SiteOption.CreateFromDefault(siteOption, 0);
            }

            throw new SiteOptionNotFoundException(siteId, section, name);
        }

        /// <summary>
        /// Returns a list of SiteOptions for the given site.
        /// If a site option is not defined for the given site, a SiteOption with site id of 0 is
        /// given in it's place
        /// </summary>
        /// <param name="siteId">A site id</param>
        /// <returns>List of site options for the given site</returns>
        public List<SiteOption> GetSiteOptionListForSite(int siteId)
        {
            List<SiteOption> list = new List<SiteOption>();

            foreach (SiteOption so in _siteOptionList)
            {
                if (so.SiteId == 0)
                {
                    list.Add(CreateSiteOption(siteId, so.Section, so.Name));
                }
            }

            return list;
        }

        /// <summary>
        /// Gets the int value for the specified option
        /// </summary>
        /// <param name="siteId">site id of the option</param>
        /// <param name="section">section name of option</param>
        /// <param name="name">name of option</param>
        /// <returns>The int value of the option, or Zero</returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public int GetValueInt(int siteId, string section, string name)
        {
            SiteOption siteOption = null;
            if (TryFindSiteOption(siteId, section, name, out siteOption))
            {
                return siteOption.GetValueInt();
            }

            // If option doesn't exist for the given site, look for default value
            if (TryFindSiteOption(0, section, name, out siteOption))
            {
                return siteOption.GetValueInt();
            }

            throw new SiteOptionNotFoundException(siteId, section, name);
        }

        /// <summary>
        /// Gets the bool value for the specified option
        /// </summary>
        /// <param name="siteId">site id of the option</param>
        /// <param name="section">section name of option</param>
        /// <param name="name">name of option</param>
        /// <returns>The bool value of the option, or false</returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public bool GetValueBool(int siteId, string section, string name)
        {
            SiteOption siteOption = null;
            if (TryFindSiteOption(siteId, section, name, out siteOption))
            {
                return siteOption.GetValueBool();
            }

            // If option doesn't exist for the given site, look for default value
            if (TryFindSiteOption(0, section, name, out siteOption))
            {
                return siteOption.GetValueBool();
            }

            throw new SiteOptionNotFoundException(siteId, section, name);
        }

        /// <summary>
        /// Gets the string value for the given site option
        /// </summary>
        /// <param name="siteId">The id of the site you want to get the option for</param>
        /// <param name="section">The section that the option belongs to</param>
        /// <param name="name">The name of the option</param>
        /// <returns>The string value for the requested option</returns>
        public string GetValueString(int siteId, string section, string name)
        {
            SiteOption siteOption = null;
            if (TryFindSiteOption(siteId, section, name, out siteOption))
            {
                return siteOption.GetValueString();
            }

            // If option doesn't exist for the given site, look for default value
            if (TryFindSiteOption(0, section, name, out siteOption))
            {
                return siteOption.GetValueString();
            }

            throw new SiteOptionNotFoundException(siteId, section, name);
        }

        /// <summary>
        /// Sets the int value of the specified option.
        /// It also updates the database with the new value
        /// </summary>
        /// <param name="siteId">Site id of option</param>
        /// <param name="section">Section name of option</param>
        /// <param name="name">name of option</param>
        /// <param name="value">new value of option</param>
        /// <param name="context">The context</param>
        /// <exception cref="SiteOptionNotFoundException">Thrown if the site option doesn't exist</exception>
        public void SetValueInt(int siteId, string section, string name, int value)
        {
            SiteOption siteOption = null;
            if (TryFindSiteOption(siteId, section, name, out siteOption))
            {
                siteOption.SetValueInt(value);
                UpdateSiteOptionInDatabase(siteOption);
            }
            else
            {
                SiteOption siteZeroOption = null;
                if (!TryFindSiteOption(0, section, name, out siteZeroOption))
                {
                    // if the option doesn't exit for site 0, it doesn't exist at all
                    throw new SiteOptionNotFoundException(siteId, section, name);
                }

                SiteOption newSiteOption = SiteOption.CreateFromDefault(siteZeroOption, siteId);
                newSiteOption.SetValueInt(value);
                _siteOptionList.Add(newSiteOption);
                _siteOptionDictionary.Add(GetKey(siteId, section, name), newSiteOption);
                UpdateSiteOptionInDatabase(newSiteOption);
            }
        }


        /// <summary>
        /// Sets the bool value of the specified option.
        /// It also updates the database with the new value
        /// </summary>
        /// <param name="siteId">Site id of option</param>
        /// <param name="section">Section name of option</param>
        /// <param name="name">name of option</param>
        /// <param name="value">new value of option</param>
        /// <param name="context">The context</param>
        /// <exception cref="SiteOptionNotFoundException">Thrown if the site option doesn't exist</exception>
        public void SetValueBool(int siteId, string section, string name, bool value)
        {
            SiteOption siteOption = null;
            if (TryFindSiteOption(siteId, section, name, out siteOption))
            {
                siteOption.SetValueBool(value);
                UpdateSiteOptionInDatabase(siteOption);
            }
            else
            {
                SiteOption siteZeroOption = null;
                if (!TryFindSiteOption(0, section, name, out siteZeroOption))
                {
                    // if the option doesn't exit for site 0, it doesn't exist at all
                    throw new SiteOptionNotFoundException(siteId, section, name);
                }

                SiteOption newSiteOption = SiteOption.CreateFromDefault(siteZeroOption, siteId);
                newSiteOption.SetValueBool(value);
                _siteOptionList.Add(newSiteOption);
                _siteOptionDictionary.Add(GetKey(siteId, section, name), newSiteOption);
                UpdateSiteOptionInDatabase(newSiteOption);
            }
        }

        private void UpdateSiteOptionInDatabase(SiteOption so)
        {
            using (IDnaDataReader dataReader = CreateReader("setsiteoption"))
            {
                string value = string.Empty;

                switch (so.Type)
                {
                    case SiteOption.SiteOptionType.Int: 
                        value = so.GetValueInt().ToString();
                        break;

                    case SiteOption.SiteOptionType.Bool:
                        value = "0";
                        if (so.GetValueBool())
                        {
                            value = "1";
                        }
                        break;

                    case SiteOption.SiteOptionType.String:
                        value = so.GetValueString();
                        break;

                    default: throw new SiteOptionInvalidTypeException("Unknown type: " + so.Type.ToString());
                }

                dataReader.AddParameter("@siteid", so.SiteId);
                dataReader.AddParameter("@section", so.Section);
                dataReader.AddParameter("@name", so.Name);
                dataReader.AddParameter("@value", value);
                dataReader.Execute();
            }
        }
    }
}
