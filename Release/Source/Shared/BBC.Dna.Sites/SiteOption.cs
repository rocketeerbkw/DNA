using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// Encapsulates a SiteOption
    /// </summary>
    public class SiteOption
    {
        private int _siteId;
        private string _section;
        private string _name;
        private SiteOptionType _type;
        private string _description;

        // The different types it can holde
        private int _valueInt;
        private bool _valueBool;
        private string _valueString;

        /// <summary>
        /// The types of SiteOption you can have
        /// </summary>
        public enum SiteOptionType
        {
            /// <summary>
            /// Type Int
            /// </summary>
            Int = 0,

            /// <summary>
            /// Type Bool
            /// </summary>
            Bool = 1,

            /// <summary>
            /// Type String
            /// </summary>
            String = 2
        }

        /// <summary>
        /// The type of this site option 
        /// </summary>
        public SiteOptionType Type
        {
            get { return _type; }
        }

        /// <summary>
        /// Creates a SiteOption 
        /// </summary>
        /// <param name="siteId">site ID</param>
        /// <param name="section">section name</param>
        /// <param name="name">name of option</param>
        /// <param name="value">value of option</param>
        /// <param name="type">type of option</param>
        /// <param name="description"></param>
        public SiteOption(int siteId, string section, string name, string value, SiteOptionType type, string description)
        {
	        _siteId = siteId;
	        _section = section;
	        _name = name;
	        _type = type;
	        _description = description;

            // Use the Get methods to validate the type, knowing that they'll throw an exception if not
            switch (type)
            {
                case SiteOptionType.Int:
                    SetValueInt(int.Parse(value)); 
                    break;

                case SiteOptionType.Bool: 
                    int i = int.Parse(value);
                    if (i == 0)
                    {
                        SetValueBool(false);
                    }
                    else if (i == 1)
                    {
                        SetValueBool(true);
                    }
                    else
                    {
                        throw new SiteOptionInvalidTypeException("Value is not a bool");
                    }
                    break;

                case SiteOptionType.String:
                    SetValueString(value);
                    break;

                default: throw new SiteOptionInvalidTypeException("Unknown type");
            }
        }

        /// <summary>
        /// Returns the site ID of this site option
        /// </summary>
        /// <returns>the site ID</returns>
        public int SiteId
        { 
            get { return _siteId; } 
        }

        /// <summary>
        /// Returns the section name of this site option
        /// </summary>
        /// <returns>the section name</returns>
        public string Section
        {
            get { return _section; }
        }

        /// <summary>
        /// Returns the name of this site option
        /// </summary>
        /// <returns>the name</returns>
        public string Name
        {
            get { return _name; }
        }

        /// <summary>
        /// Returns the descriptions of this site option
        /// </summary>
        /// <returns>the description</returns>
        public string Description
        {
            get { return _description; }
        }

        /// <summary>
        /// Is this option applied to a specific site, or is it a global default?
        /// This property will give you the answer
        /// </summary>
        public bool IsGlobal
        {
            get { return SiteId == 0; }
        }

        /// <summary>
        /// Returns the int representation of this site option
        /// </summary>
        /// <returns>the int value</returns>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public int GetValueInt()
        {
            if (IsTypeInt())
            {
                return _valueInt;
            }

            throw new SiteOptionInvalidTypeException("Value is not an int");
        }

        /// <summary>
        /// Returns the bool representation of this site option
        /// </summary>
        /// <returns>the bool value</returns>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public bool GetValueBool()
        {
            if (IsTypeBool())
            {
                return _valueBool;
            }

            throw new SiteOptionInvalidTypeException("Value is not a bool");
        }

        /// <summary>
        /// Returns the String representation of this site option
        /// </summary>
        /// <returns>the string value</returns>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public string GetValueString()
        {
            if (IsTypeString())
            {
                return _valueString;
            }

            throw new SiteOptionInvalidTypeException("Value is not a string");
        }

        /// <summary>
        /// Returns true if the type of this site option is an int
        /// </summary>
        /// <returns>true if it's an int type, false otherwise</returns>
	    public bool IsTypeInt()
        {
            return _type == SiteOptionType.Int;
        }

        /// <summary>
        /// Returns true if the type of this site option is a bool
        /// </summary>
        /// <returns>true if it's an bool type, false otherwise</returns>
        public bool IsTypeBool()
        {
            return _type == SiteOptionType.Bool;
        }

        /// <summary>
        /// Returns true if the type of this site option is a string
        /// </summary>
        /// <returns>true if it's an string type, false otherwise</returns>
        public bool IsTypeString()
        {
            return _type == SiteOptionType.String;
        }

        /// <summary>
        /// Sets the value to the given int
        /// </summary>
        /// <param name="value">The new value</param>
        public void SetValueInt(int value)
        {
            if (IsTypeInt())
            {
                _valueInt = value;
            }
            else
            {
                throw new SiteOptionInvalidTypeException("Type is not an int");
            }
        }

        /// <summary>
        /// Sets the value to the given bool
        /// </summary>
        /// <param name="value">The new value</param>
        public void SetValueBool(bool value)
        {
            if (IsTypeBool())
            {
                _valueBool = value;
            }
            else
            {
                throw new SiteOptionInvalidTypeException("Type is not a bool");
            }
        }

        /// <summary>
        /// Sets the value to the given string
        /// </summary>
        /// <param name="value">The new value</param>
        public void SetValueString(string value)
        {
            if (IsTypeString())
            {
                _valueString = value;
            }
            else
            {
                throw new SiteOptionInvalidTypeException("Type is not a string");
            }
        }

        /// <summary>
        /// DO NOT USE!
        /// </summary>
        /// <returns></returns>
        public string GetRawValue()
        {
            switch (_type)
            {
                case SiteOptionType.Int:
                    return _valueInt.ToString();
                case SiteOptionType.Bool:
                    if (_valueBool)
                    {
                        return "1";
                    }
                    else
                    {
                        return "0";
                    }
                case SiteOptionType.String:
                    return _valueString;

                default: throw new SiteOptionInvalidTypeException("Unknown type");
            }
        }

        /// <summary>
        /// Creates a new SiteOption with exactly the same values as the default on passed in,
        /// except the site id is set to the value you pass in separately
        /// </summary>
        /// <param name="defaultSiteOption">The one to copy</param>
        /// <param name="siteId">The site id to use</param>
        /// <returns></returns>
        public static SiteOption CreateFromDefault(SiteOption defaultSiteOption, int siteId)
        {
            SiteOption newSiteOption = new SiteOption(
                                            siteId,
                                            defaultSiteOption._section,
                                            defaultSiteOption._name,
                                            defaultSiteOption.GetRawValue(),
                                            defaultSiteOption._type,
                                            defaultSiteOption._description);

            return newSiteOption;
        }
    }
}
