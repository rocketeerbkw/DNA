using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    //define some aliases
    using OptionAttributes = Dictionary<string, string>;
    using Options = Dictionary<int, Dictionary<string, string>>;
    using Results = Dictionary<Poll.UserStatus, Dictionary<int, Dictionary<string, string>>>;

    /// <summary>
    /// Results of poll
    /// </summary>
    public class PollResults : DnaComponent
    {
        private Results _results;
        
        /// <summary>
        /// Constructor
        /// </summary>
        public PollResults()
        {
            _results = new Results();
        }

        /// <summary>
        /// Populates poll's results
        /// </summary>
        /// <param name="userStatus">User status (e.g. anonymous; signed-in)</param>
        /// <param name="response">Response index</param>
        /// <param name="key">Attribute name</param>
        /// <param name="value">Attribute value</param>
        /// <remarks>Collection later used by the code which generates xml. Attribute keys and values will end up as &lt;OPTION&gt; element xml attributes (key="value")</remarks>
		public void Add(Poll.UserStatus userStatus, int response, string key, string value)
        {
            Options pollOptions;
            bool exists = _results.TryGetValue(userStatus, out pollOptions); 
            if (!exists)
            {
                pollOptions = new Options();
                _results.Add(userStatus, pollOptions); 
            }

            OptionAttributes optionAttributes;
            exists = pollOptions.TryGetValue(response, out optionAttributes);
            if (!exists)
            {
                optionAttributes = new OptionAttributes();
                pollOptions.Add(response, optionAttributes); 
            }

            // If key does not exist then new key/value pair added.
            optionAttributes[key] = value; 
        }

        /// <summary>
        /// Gets Xml of Poll's results
        /// </summary>
        /// <returns>XmlElement containing poll's results.</returns>
        public XmlElement GetXml()
        {
            XmlElement resultXml = (XmlElement) AddElementTag(RootElement, "OPTION-LIST");

            foreach (Poll.UserStatus userStatus in _results.Keys)
            {
                XmlElement userStatusXml = (XmlElement) AddElementTag(resultXml, "USERSTATUS"); 
                AddAttribute(userStatusXml, "type", Enum.Format(typeof(Poll.UserStatus), userStatus, "d")); 

                Options options;
                _results.TryGetValue(userStatus, out options); 
                foreach (OptionAttributes optionAttribute in options.Values)
                {
                    XmlElement optionXml = (XmlElement)AddElementTag(userStatusXml, "OPTION");
                    string attributeValue; 
                    foreach (string attributeKey in optionAttribute.Keys)
                    {
                        AddAttribute(optionXml, "index", attributeKey);
                        optionAttribute.TryGetValue(attributeKey.ToString(), out attributeValue); // TODO - check if this is the right value - shoudl it be a count figure?
                        AddAttribute(optionXml, "count", attributeValue); 
                    }
                }
            }

            return resultXml; 
        }
    }
}
