using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class to store the Phrase Details
    /// </summary>
    public class Phrase : DnaComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public Phrase()
        {
        }

        /// <summary>
        /// Overloaded constructor
        /// </summary>
        /// <param name="phrase">The phrase for this phase</param>
        /// <param name="nameSpace">The namespace the phase will live in</param>
        public Phrase(string phrase, string nameSpace)
        {
            _phrase = phrase;
            _nameSpace = nameSpace;
        }

        private const string _token = @" ";

        string _nameSpace = String.Empty;
        string _phrase = String.Empty;

        /// <summary>
        /// Accessor for the NameSpace
        /// </summary>
        public string NameSpace
        {
            get { return _nameSpace; }
            set { _nameSpace = value; }
        }

        /// <summary>
        /// Accessor for the Phrase
        /// </summary>
        public string PhraseName
        {
            get { return _phrase; }
            set { _phrase = value; }
        }

        /// <summary>
        /// Accessor for the Phrase
        /// </summary>
        public virtual XmlElement AddPhraseXml(XmlElement parent)
        {
            XmlElement phrase = CreateElement("PHRASE");
            AddTextTag(phrase, "NAMESPACE", NameSpace);

            //If phrase contains token then quote.
            string URLPhrase = _phrase;
            if (_phrase.Contains(_token))
            {
                URLPhrase = "\"" + _phrase + "\"";
            }

            AddXmlTextTag(phrase, "NAME", _phrase);

            AddXmlTextTag(phrase, "TERM", URLPhrase);

            if (parent != null)
            {
                parent.AppendChild(parent.OwnerDocument.ImportNode(phrase, true));
            }
            return phrase;
        }
    }
}
