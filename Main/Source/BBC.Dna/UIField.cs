using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;


namespace BBC.Dna
{
    /// <summary>
    /// Class to store info on an UIField
    /// </summary>
    public class UIField : DnaInputComponent
    {
        /// <summary>
        /// UIField Types
        /// </summary>
        public enum UIFieldType
        {
            /// <summary>
            /// Unknown type
            /// </summary>
            Unknown,
            /// <summary>
            /// Number type
            /// </summary>
            Number,
            /// <summary>
            /// String type
            /// </summary>
            String,
            /// <summary>
            /// Date type
            /// </summary>
            Date,
            /// <summary>
            /// Bool type
            /// </summary>
            Bool,
            /// <summary>
            /// File type
            /// </summary>
            File
        }

        /// <summary>
        /// UIField Permissions Level
        /// </summary>
        public enum UIFieldPermissions
        {
            /// <summary>
            /// Standard user access
            /// </summary>
            Standard,
            /// <summary>
            /// Editor type
            /// </summary>
            Editor,
            /// <summary>
            /// SuperUser type
            /// </summary>
            SuperUser
        }
 
        int _UIFieldID = 0;
        string _name = String.Empty;
        string _label = String.Empty;
        UIFieldType _type = UIFieldType.Unknown;
        string _description = String.Empty;
        bool _isKeyPhrase = false;
        string _keyPhraseNamespace = String.Empty;
        bool _required = false;
        string _defaultValue = String.Empty;
        bool _escape = false;
        bool _rawInput = false;
        bool _includeInGuideEntry = false;
        bool _validateEmpty = false;
        bool _validateNotEqualTo = false;
        bool _validateParsesOK = false;
        string _notEqualToValue = String.Empty;
        bool _validateCustom = false;
        int _step = 0;
        UIFieldPermissions _permissions = UIFieldPermissions.Standard;

        string _valueRaw = String.Empty;
        string _valueEscaped = String.Empty;
        string _validationStatus = String.Empty;
        ProfanityFilter.FilterState _profanityFilterState = ProfanityFilter.FilterState.Pass;

        string _valueString = String.Empty;
        int _valueInt = 0;
        double _valueDouble = 0.0;
        DateTime _valueDateTime = DateTime.MinValue;
        bool _valueBool = false;

        XmlElement _UIField;

        XmlElement _errorXML;
            
            /// <summary>
        /// Constructor for the UIField Component
        /// </summary>
        /// <param name="context"></param>
        public UIField(IInputContext context)
            : base(context)
        {
            RootElement.RemoveAll();
            _UIField = AddElementTag(RootElement, "UIFIELD");
            _errorXML = AddElementTag(RootElement, "UIFIELDERRORS");
        }

        /// <summary>
        /// Accessor for UIFieldID
        /// </summary>
        public int UIFieldID
        {
            get { return _UIFieldID; }
            set { _UIFieldID = value; }
        }
        /// <summary>
        /// Accessor for Name
        /// </summary>
        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }
        /// <summary>
        /// Accessor for Label
        /// </summary>
        public string Label
        {
            get { return _label; }
            set { _label = value; }
        }
        /// <summary>
        /// Accessor for Type
        /// </summary>
        public UIFieldType Type
        {
            get { return _type; }
            set { _type = value; }
        }
        /// <summary>
        /// Accessor for Description
        /// </summary>
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }
        /// <summary>
        /// Accessor for IsKeyPhrase
        /// </summary>
        public bool IsKeyPhrase
        {
            get { return _isKeyPhrase; }
            set { _isKeyPhrase = value; }
        }

        /// <summary>
        /// Accessor for KeyPhraseNamespace
        /// </summary>
        public string KeyPhraseNamespace
        {
            get { return _keyPhraseNamespace; }
            set { _keyPhraseNamespace = value; }
        }
        
        /// <summary>
        /// Accessor for Required
        /// </summary>
        public bool Required
        {
            get { return _required; }
            set { _required = value; }
        }
        /// <summary>
        /// Accessor for DefaultValue
        /// </summary>
        public string DefaultValue
        {
            get { return _defaultValue; }
            set { _defaultValue = value; }
        }
        /// <summary>
        /// Accessor for Escape
        /// </summary>
        public bool Escape
        {
            get { return _escape; }
            set { _escape = value; }
        }
        /// <summary>
        /// Accessor for RawInput
        /// </summary>
        public bool RawInput
        {
            get { return _rawInput; }
            set { _rawInput = value; }
        }
        /// <summary>
        /// Accessor for IncludeInGuideEntry
        /// </summary>
        public bool IncludeInGuideEntry
        {
            get { return _includeInGuideEntry; }
            set { _includeInGuideEntry = value; }
        }
        /// <summary>
        /// Accessor for ValidateEmpty
        /// </summary>
        public bool ValidateEmpty
        {
            get { return _validateEmpty; }
            set { _validateEmpty = value; }
        }
        /// <summary>
        /// Accessor for ValidateNotEqualTo
        /// </summary>
        public bool ValidateNotEqualTo
        {
            get { return _validateNotEqualTo; }
            set { _validateNotEqualTo = value; }
        }
        /// <summary>
        /// Accessor for ValidateParsesOK
        /// </summary>
        public bool ValidateParsesOK
        {
            get { return _validateParsesOK; }
            set { _validateParsesOK = value; }
        }
        /// <summary>
        /// Accessor for NotEqualToValue
        /// </summary>
        public string NotEqualToValue
        {
            get { return _notEqualToValue; }
            set { _notEqualToValue = value; }
        }
        /// <summary>
        /// Accessor for ValidateCustom
        /// </summary>
        public bool ValidateCustom
        {
            get { return _validateCustom; }
            set { _validateCustom = value; }
        }
        /// <summary>
        /// Accessor for Step
        /// </summary>
        public int Step
        {
            get { return _step; }
            set { _step = value; }
        }
        /// <summary>
        /// Accessor for UIFieldPermissions
        /// </summary>
        public UIFieldPermissions Permissions
        {
            get { return _permissions; }
            set { _permissions = value; }
        }



        /// <summary>
        /// Accessor for RawValue
        /// </summary>
        public string RawValue
        {
            get { return _valueRaw; }
            set { _valueRaw = value; }
        }
        /// <summary>
        /// Accessor for EscapedValue
        /// </summary>
        public string EscapedValue
        {
            get { return _valueEscaped; }
            set { _valueEscaped = value; }
        }

        /// <summary>
        /// Accessor for ProfanityFilterState
        /// </summary>
        public ProfanityFilter.FilterState ProfanityFilterState
        {
            get { return _profanityFilterState; }
            set { _profanityFilterState = value; }
        }

        /// <summary>
        /// Accessor for ValueString
        /// </summary>
        public string ValueString
        {
            get { return _valueString; }
            set { _valueString = value; }
        }
        /// <summary>
        /// Accessor for ValueInt
        /// </summary>
        public int ValueInt
        {
            get { return _valueInt; }
            set { _valueInt = value; }
        }
        /// <summary>
        /// Accessor for ValueDouble
        /// </summary>
        public double ValueDouble
        {
            get { return _valueDouble; }
            set { _valueDouble = value; }
        }
        /// <summary>
        /// Accessor for ValueDateTime
        /// </summary>
        public DateTime ValueDateTime
        {
            get { return _valueDateTime; }
            set { _valueDateTime = value; }
        }
        /// <summary>
        /// Accessor for ValueBool
        /// </summary>
        public bool ValueBool
        {
            get { return _valueBool; }
            set { _valueBool = value; }
        }
       





        /// <summary>
        /// Accessor for getting the XML
        /// </summary>
        public XmlElement XML
        {
            get
            {
                return GenerateXML();
            }
        }

        private XmlElement GenerateXML()
        {
            RootElement.RemoveAll();
            _UIField.RemoveAll();
            AddAttribute(_UIField, "UIFIELDID", _UIFieldID);
            AddAttribute(_UIField, "ISKEYPHRASE", _isKeyPhrase);
            AddAttribute(_UIField, "REQUIRED", _required);
            AddAttribute(_UIField, "ESCAPE", _escape);
            AddAttribute(_UIField, "RAWINPUT", _rawInput);
            AddAttribute(_UIField, "INCLUDEINGUIDEENTRY", _includeInGuideEntry);
            AddAttribute(_UIField, "VALIDATEEMPTY", _validateEmpty);
            AddAttribute(_UIField, "VALIDATENOTEQUALTO", _validateNotEqualTo);
            AddAttribute(_UIField, "VALIDATEPARSESOK", _validateParsesOK);
            AddAttribute(_UIField, "VALIDATECUSTOM", _validateCustom);
            AddAttribute(_UIField, "STEP", _step);

            AddTextElement(_UIField, "NAME", _name);
            AddTextElement(_UIField, "LABEL", _label);
            AddTextElement(_UIField, "TYPE", _type.ToString());
            AddTextElement(_UIField, "DESCRIPTION", _description);
            AddTextElement(_UIField, "KEYPHRASENAMESPACE", _keyPhraseNamespace);
            AddTextElement(_UIField, "DEFAULTVALUE", _defaultValue);
            AddTextElement(_UIField, "NOTEQUALTOVALUE", _notEqualToValue);

            AddTextElement(_UIField, "VALUERAW", _valueRaw);
            AddTextElement(_UIField, "VALUEESCAPED", _valueEscaped);
            AddTextElement(_UIField, "VALIDATATIONSTATUS", _validationStatus);
            AddTextElement(_UIField, "PERMISSIONS", _permissions.ToString());

            if (_errorXML != null)
            {
                if (_errorXML.HasChildNodes)
                {
                    _UIField.AppendChild(_errorXML);
                }
                XmlElement oldErrornode = (XmlElement) RootElement.SelectSingleNode("UIFIELDERRORS");
                if (oldErrornode != null)
                {
                    RootElement.RemoveChild(oldErrornode);
                }
            }

            return _UIField;
        }

        /// <summary>
        /// Loads the field from the database
        /// </summary>
        /// <param name="dataReader">dataReader with the field info</param>
        public void LoadFieldFromDatabase(IDnaDataReader dataReader)
        {
            _UIFieldID = dataReader.GetInt32NullAsZero("UIFieldID");
            _name = dataReader.GetStringNullAsEmpty("Name");
            _label = dataReader.GetStringNullAsEmpty("Label");

            _type = (UIFieldType)Enum.Parse(typeof(UIFieldType), dataReader.GetStringNullAsEmpty("Type"));

            _description = dataReader.GetStringNullAsEmpty("Description");
            _isKeyPhrase = dataReader.GetBoolean("IsKeyPhrase");
            _keyPhraseNamespace = dataReader.GetStringNullAsEmpty("KeyPhraseNamespace");
            _required = dataReader.GetBoolean("Required");
            _defaultValue = dataReader.GetStringNullAsEmpty("DefaultValue");
            _escape = dataReader.GetBoolean("Escape");
            _rawInput = dataReader.GetBoolean("RawInput");
            _includeInGuideEntry = dataReader.GetBoolean("IncludeInGuideEntry");
            _validateEmpty = dataReader.GetBoolean("ValidateEmpty");
            _validateNotEqualTo = dataReader.GetBoolean("ValidateNotEqualTo");
            _validateParsesOK = dataReader.GetBoolean("ValidateParsesOK");
            _notEqualToValue = dataReader.GetStringNullAsEmpty("NotEqualToValue");
            _validateCustom = dataReader.GetBoolean("ValidateCustom");
            _step = dataReader.GetInt32NullAsZero("Step");

            _permissions = (UIFieldPermissions)Enum.Parse(typeof(UIFieldPermissions), dataReader.GetStringNullAsEmpty("Permissions"));
        }

        /// <summary>
        /// Loads a field with data from an UIField XML element
        /// </summary>
        /// <param name="field">Xml element containing the field data in the uifield xml format</param>
        internal void LoadFieldFromXml(XmlElement field)
        {
            Int32.TryParse(field.GetAttribute("UIFIELDID"), out _UIFieldID);
            Int32.TryParse(field.GetAttribute("STEP"), out _step);

            _isKeyPhrase = (field.GetAttribute("ISKEYPHRASE") == "1");
            _required = (field.GetAttribute("REQUIRED") == "1");
            _escape = (field.GetAttribute("ESCAPE") == "1");
            _rawInput = (field.GetAttribute("RAWINPUT") == "1");
            _includeInGuideEntry = (field.GetAttribute("INCLUDEINGUIDEENTRY") == "1");
            _validateEmpty = (field.GetAttribute("VALIDATEEMPTY") == "1");
            _validateNotEqualTo = (field.GetAttribute("VALIDATENOTEQUALTO") == "1");
            _validateParsesOK = (field.GetAttribute("VALIDATEPARSESOK") == "1");
            _validateCustom = (field.GetAttribute("VALIDATECUSTOM") == "1");

            _name = field.SelectSingleNode("NAME").InnerText;
            _label = field.SelectSingleNode("LABEL").InnerText;
            try
            {
                _type = (UIFieldType)Enum.Parse(typeof(UIFieldType), field.SelectSingleNode("TYPE").InnerText);
            }
            catch (Exception ex)
            {
                AddErrorXml("UIField Type Error", "UIFieldType not known or incorrect." + ex.Message, _errorXML);
                _type = UIFieldType.Unknown;
            }
            _description = field.SelectSingleNode("DESCRIPTION").InnerText;
            _keyPhraseNamespace = field.SelectSingleNode("KEYPHRASENAMESPACE").InnerText;
            _defaultValue = field.SelectSingleNode("DEFAULTVALUE").InnerText;
            _notEqualToValue = field.SelectSingleNode("NOTEQUALTOVALUE").InnerText;
            try
            {
                _permissions = (UIFieldPermissions)Enum.Parse(typeof(UIFieldPermissions), field.SelectSingleNode("PERMISSIONS").InnerText);
            }
            catch (Exception ex)
            {
                AddErrorXml("UIFieldPermissions Error", "UIFieldPermissions not known or incorrect." + ex.Message, _errorXML);
                _permissions = UIFieldPermissions.Standard;
            }
        }

        /// <summary>
        /// Validate fields
        /// </summary>
        /// <returns>true if valid false if not</returns>
        public bool Validate()
        {
            bool isValid = true;
            if (_validateEmpty && _valueRaw.Length == 0)
            {
                AddErrorXml("Empty field", "This field cannot be empty.", _errorXML);
                isValid = false;
            }
            if (_validateNotEqualTo && _valueRaw == _notEqualToValue)
            {
                AddErrorXml("Not Equal To", "This field cannot be equal to the given value.", _errorXML);
                isValid = false;
            }
            if (_validateParsesOK && ParseValue(_valueRaw))
            {
                isValid = false;
            }
            if (_required && (_valueRaw == String.Empty))
            {
                AddErrorXml("Required Field Not Present", "This field must be passed a value.", _errorXML);
                isValid = false;
            }
            if (HasProfanities(_valueRaw))
            {
                isValid = false;
            }

            if(InputContext.GetSiteOptionValueBool("General", "IsURLFiltered") && !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsNotable))
            {
                URLFilter filter = new URLFilter(InputContext);
                List<string> nonAllowedURLs = new List<string>();
                if (filter.CheckForURLs(_valueRaw, nonAllowedURLs) == URLFilter.FilterState.Fail)
                {
                    string errorMessage = "A Non-Allowed url has been found. The following URL(s) were found :- ";
                    foreach(string URL in nonAllowedURLs)
                    {
                        errorMessage += URL + " , ";
                    }
                    errorMessage += "these are not in the allowed URL list for this site. ";
                    AddErrorXml("Non Allowed URL", errorMessage, _errorXML);
                    isValid = false;
                }
            }

            if (InputContext.GetSiteOptionValueBool("Forum", "EmailAddressFilter") && !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsNotable))
            {
                if (EmailAddressFilter.CheckForEmailAddresses(_valueRaw))
                {
                    AddErrorXml("Non Allowed Email address", "An Email address has been found.", _errorXML);
                    isValid = false;
                }
            }

            FillValues();

            return isValid;
        }

        private void FillValues()
        {
            if (_escape)
            {
                _valueEscaped = StringUtils.EscapeAllXml(_valueRaw);
            }

            _valueString = _valueRaw;

            try
            {
                Int32.TryParse(_valueRaw, out _valueInt);
            }
            catch (System.ArgumentException)
            {
                _valueInt = 0;
            }

            try
            {
                Double.TryParse(_valueRaw, out _valueDouble);
            }
            catch (System.ArgumentException)
            {
                _valueDouble = 0;
            }

            try
            {
                DateTime.TryParse(_valueRaw, out _valueDateTime);
            }
            catch (System.ArgumentException)
            {
                _valueDateTime = DateTime.MinValue;
            }

            try
            {
                if (_valueRaw.ToLower() == "true" || _valueRaw == "1")
                {
                    _valueBool = true;
                }
                else
                {
                    _valueBool = false;
                }
            }
            catch (System.ArgumentException)
            {
                _valueBool = false;
            }
        }

        /// <summary>
        /// Checks that the string as xml parses OK
        /// </summary>
        /// <param name="value">The string to check</param>
        /// <returns>Whether the string parses to an xml document</returns>
        private bool ParseValue(string value)
        {
            string toCheck = "<CHECK>" + value + "</CHECK>";
            XmlDocument docToParse = new XmlDocument();
            try
            {
                docToParse.LoadXml(toCheck);
                return true;
            }
            catch (XmlException parseError)
            {
                AddErrorXml("Not Parsing OK", "This field must parse correctly." + parseError.Message, _errorXML);
                return false;
            }
        }
        /// <summary>
        /// Checks that the string parses without any profanities
        /// </summary>
        /// <param name="value">The string to check</param>
        /// <returns>Whether the string parses without any profanities</returns>
        private bool HasProfanities(string value)
        {
            string matchingProfanity;
            
            ProfanityFilter.FilterState profanityState = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, value, out matchingProfanity);
            _profanityFilterState = profanityState;

            if (profanityState != ProfanityFilter.FilterState.FailBlock)
            {
                return false;
            }
            else
            {
                AddErrorXml("Profanity Error", "This field contains a blocking profanity. The profanity is " + matchingProfanity + ". Profanity Filter State = " + profanityState.ToString(), _errorXML);
                return true;
            }
        }
    }
}
