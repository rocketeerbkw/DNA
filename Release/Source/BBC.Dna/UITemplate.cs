using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;


namespace BBC.Dna
{
    /// <summary>
    /// Class to store info on an UITemplate
    /// </summary>
    public class UITemplate : DnaInputComponent
    {
        int _UITemplateID = 0;
        string _name = String.Empty;
        Guid _builderGUID = Guid.Empty;
        bool _hasErrors = false;
        ProfanityFilter.FilterState _profanityFilterState = ProfanityFilter.FilterState.Pass;

        int _uiFieldCount = 0;

        private Dictionary<string, UIField> _uiFieldData = new Dictionary<string, UIField>();

        /// <summary>
        /// Constructor for the Template object
        /// </summary>
        /// <param name="context"></param>
        public UITemplate(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Accessor for UITemplateID
        /// </summary>
        public int UITemplateID
        {
            get { return _UITemplateID; }
            set { _UITemplateID = value; }
        }
        /// <summary>
        /// Accessor for Builder
        /// </summary>
        public Guid BuilderGUID
        {
            get { return _builderGUID; }
            set { _builderGUID = value; }
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
        /// Accessor for HasErrors
        /// </summary>
        public bool HasErrors
        {
            get { return _hasErrors; }
            set { _hasErrors = value; }
        }

        /// <summary>
        /// Accessor for _uiFieldData
        /// </summary>
        public Dictionary<string, UIField> UIFields
        {
            get { return _uiFieldData; }
            set { _uiFieldData = value; }
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
        /// Function that loads the Template from the database
        /// </summary>
        public void LoadTemplate()
        {
            _hasErrors = false;
            GetTemplateDataFromDB();
            GenerateTemplateXML();
        }
        /// <summary>
        /// For the given template XML structure save the data to the DB
        /// </summary>
        /// <param name="templateXML"></param>
        public void SaveTemplate(XmlElement templateXML)
        {
            _hasErrors = false;
            StoreTemplateDataFromXML(templateXML, true);
            GenerateTemplateXML();
        }

        /// <summary>
        /// From the internal structure create the Template Xml and update or create the new template field in the DB
        /// </summary>
        public void StoreTemplateData()
        {
            _hasErrors = false;
            GenerateTemplateXML();
            CreateUpdateTemplateData();
            GenerateTemplateXML();
        }

        /// <summary>
        /// Adds a given field to the internal field data
        /// </summary>
        /// <param name="uiField"></param>
        public void AddField(UIField uiField)
        {
            _uiFieldData.Add(uiField.Name, uiField);
        }

        /// <summary>
        /// Validate the complete template
        /// </summary>
        /// <returns>Returns true if everything is valid false if not</returns>
        public bool Validate()
        {
            _profanityFilterState = ProfanityFilter.FilterState.Pass;

            bool isValid = true;
            foreach (UIField field in _uiFieldData.Values)
            {
                bool isFieldValid = true;
                isFieldValid = field.Validate();

                if (field.ProfanityFilterState == ProfanityFilter.FilterState.FailRefer && _profanityFilterState != ProfanityFilter.FilterState.FailBlock)
                {
                    _profanityFilterState = ProfanityFilter.FilterState.FailRefer;
                }
                else if(field.ProfanityFilterState == ProfanityFilter.FilterState.FailBlock)
                {
                    _profanityFilterState = ProfanityFilter.FilterState.FailBlock;
                }

                if (isValid && !isFieldValid)
                {
                    isValid = false;
                }
            }
            GenerateTemplateXML();
            return isValid;
        }

        /// <summary>
        /// Attempts to fill the template
        /// </summary>
        /// <param name="fieldList"></param>
        public void ProcessParameters(List<KeyValuePair<string, string>> fieldList)
        {
            foreach (KeyValuePair<string, string> field in fieldList)
            {
                foreach (UIField uiField in _uiFieldData.Values)
                {
                    if (field.Key.ToLower() == uiField.Name.ToLower())
                    {
                        uiField.RawValue = field.Value;
                        break;
                    }
                }
            }
        }



//********************************************************************************************
// Private functions
//********************************************************************************************

        /// <summary>
        /// Function that loads the Template from the database
        /// </summary>
        private void GetTemplateDataFromDB()
        {
            string storedProcedureName = "getuitemplate";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("uitemplateid", _UITemplateID);
                dataReader.Execute();
                ReadTemplateData(dataReader);
            }
        }

        /// <summary>
        /// Method that reads the datareader and extracts the template and field info
        /// </summary>
        /// <param name="dataReader"></param>
        private void ReadTemplateData(IDnaDataReader dataReader)
        {
            if (dataReader.HasRows)
            {
                //Clear existing field data List ready for new set
                _uiFieldData.Clear();
                if (dataReader.Read())
                {
                    _name = dataReader.GetStringNullAsEmpty("TemplateName");
                    _UITemplateID = dataReader.GetInt32NullAsZero("UITemplateID");
                    _builderGUID = dataReader.GetGuid("BuilderGUID");

                    if (dataReader.NextResult())
                    {
                        while (dataReader.Read())
                        {
                            UIField uiField = new UIField(InputContext);
                            uiField.LoadFieldFromDatabase(dataReader);
                            _uiFieldData.Add(uiField.Name, uiField);
                        }
                    }
                }
            }
            else
            {
                AddErrorXml("ReadTemplateData", "No template data returned, invalid UI Template ID.", null);
                _hasErrors = true;
            }
        }

        /// <summary>
        /// Creates or updates the template data to the db
        /// </summary>
        private void CreateUpdateTemplateData()
        {
            if (UITemplateID == 0)
            {
                CreateTemplateData();
            }
            else
            {
                UpdateTemplateData();
            }
        }

        /// <summary>
        /// Loads the internal fields from a given templateXML element
        /// </summary>
        /// <param name="templateXML">The template data XMLElement </param>
        /// <param name="isTemplateFormat">Whether the data is a straight match to the internal format</param>
        private void StoreTemplateDataFromXML(XmlElement templateXML, bool isTemplateFormat)
        {
            if (isTemplateFormat)
            {
                RootElement.RemoveAll();
                RootElement.AppendChild(ImportNode(templateXML));

                XmlNode templateIDElement = RootElement.SelectSingleNode("./UITEMPLATE/@UITEMPLATEID");
                if (templateIDElement != null)
                {
                    int tmpUITemplateID;
                    Int32.TryParse(templateIDElement.InnerText, out tmpUITemplateID);
                    UITemplateID = tmpUITemplateID;
                }
                XmlNode builderGUIDElement = RootElement.SelectSingleNode("./UITEMPLATE/BUILDERGUID");
                if (builderGUIDElement != null)
                {
                    BuilderGUID = new Guid(builderGUIDElement.InnerText);
                }

                XmlNode nameElement = RootElement.SelectSingleNode("./UITEMPLATE/NAME");
                if (nameElement != null)
                {
                    Name = nameElement.InnerText;
                }

                _uiFieldData.Clear();
                foreach (XmlElement field in RootElement.SelectNodes("./UITEMPLATE/UIFIELDS/UIFIELD"))
                {
                    UIField uiField = new UIField(InputContext);
                    uiField.LoadFieldFromXml(field);
                    _uiFieldData.Add(uiField.Name, uiField);
                }
            }
            else
            {
                FillTemplateData(templateXML);
            }
            CreateUpdateTemplateData();
        }

        /// <summary>
        /// Loads the internal fields from a given templateXML element
        /// </summary>
        /// <param name="templateXML"></param>
        private void FillTemplateData(XmlElement templateXML)
        {
            TransformTemplateData(templateXML);
            StoreTemplateData();
        }

        /// <summary>
        /// Function that takes the incoming Field format and converts it to out format
        /// </summary>
        /// <param name="templateXML"></param>
        private void TransformTemplateData(XmlElement templateXML)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// Creates the Template in the DB
        /// </summary>
        private void CreateTemplateData()
        {
            string storedProcedureName = "createuitemplate";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("uitemplatexml", RootElement.FirstChild.OuterXml);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    ReadTemplateData(dataReader);
                }
                else
                {
                    AddErrorXml("TryCreateUpdateRoute", "Failed to Create the UI Template, no UI Template ID returned", null);
                    _hasErrors = true;
                }
            }
        }

        /// <summary>
        /// Updates the templatedata in the database
        /// </summary>
        private void UpdateTemplateData()
        {
            if (UITemplateID > 0)
            {
                //Formulate the simple XML structure to pass to the Storedprocedure
                string storedProcedureName = "updateuitemplate";

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
                {
                    dataReader.AddParameter("uitemplateid", UITemplateID);
                    dataReader.AddParameter("uitemplatexml", RootElement.FirstChild.OuterXml);
                    dataReader.Execute();
                    ReadTemplateData(dataReader);
                }
            }
            else
            {
                AddErrorXml("UpdateTemplateData", "Trying to update invalid UI Template ID.", null);
                _hasErrors = true;
            }
        }

        /// <summary>
        /// Creates the XML from the internal object
        /// </summary>
        private void GenerateTemplateXML()
        {
            if (!HasErrors)
            {
                int uiFieldcount = 0;
                RootElement.RemoveAll();

                XmlElement templateXML = AddElementTag(RootElement, "UITEMPLATE");

                AddAttribute(templateXML, "UITEMPLATEID", _UITemplateID);
                AddTextElement(templateXML, "NAME", _name);
                AddTextElement(templateXML, "BUILDERGUID", _builderGUID.ToString());

                XmlElement uiFields = AddElementTag(templateXML, "UIFIELDS");
                foreach (UIField uiField in _uiFieldData.Values)
                {
                    uiFields.AppendChild(ImportNode(uiField.XML));
                    uiFieldcount++;
                }
                //AddAttribute(uiFields, "FIELDCOUNT", uiFieldcount);
                _uiFieldCount = uiFieldcount;
            }
        }
    }
}
