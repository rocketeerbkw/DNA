using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class for creating a list of popular tags for each namespace.
    /// </summary>
    public class PhraseNameSpace : Phrase, IComparable
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="phrase"></param>
        public PhraseNameSpace(string name, string phrase) : base()
        {
            NameSpace = name;
            PhraseName = phrase;
            Count = 1;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="parent"></param>
        /// <returns></returns>
        public override XmlElement AddPhraseXml( XmlElement parent )
        {
            XmlElement element = base.AddPhraseXml(null);
            AddIntElement(element,"COUNT",Count);
            parent.AppendChild(parent.OwnerDocument.ImportNode(element, true));
            return element;
        }

        private int _count;

        /// <summary>
        /// 
        /// </summary>
        public int Count
        {
            get { return _count; }
            set { _count = value; }
        }

        /// <summary>
        /// Orders By Count.
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public int CompareTo(object o)
        {
            return ((PhraseNameSpace)o).Count - Count;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class PopularPhrases : DnaComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public PopularPhrases() : base()
        {
            _phraseNameSpace = new Dictionary<string, List<PhraseNameSpace> >();
        }

        private Dictionary<string,List<PhraseNameSpace> > _phraseNameSpace;
        private int _popularTags = 10;

        /// <summary>
        /// AddPhrase - Adds the phrase and name space to a list under a key for each namespace.
        ///  Groups phrases per namespace and keeps a count of occurrences of each phrase namespace pair.
        /// </summary>
        /// <param name="phrase"></param>
        /// <param name="nspace"></param>
        public void AddPhrase( string phrase, string nspace )
        {
            if ( !_phraseNameSpace.ContainsKey(nspace) )
            {
                _phraseNameSpace.Add(nspace, new List<PhraseNameSpace>());
            }

            List<PhraseNameSpace> phrases = _phraseNameSpace[nspace];
            PhraseNameSpace existing = phrases.Find( delegate(PhraseNameSpace match) { return match.PhraseName == phrase; }); 
            if ( existing != null )
            {
                existing.Count += 1;
            }
            else
            {
                phrases.Add(new PhraseNameSpace(nspace,phrase));
            }
        }

        /// <summary>
        /// Generates the popular tags XML.
        /// </summary>
        /// <returns></returns>
        public XmlElement GenerateXml( )
        {
            XmlElement popularTags = AddElementTag(RootElement, "POPULARPHRASES");
            foreach (KeyValuePair<string,List<PhraseNameSpace> > phraseNameSpace in _phraseNameSpace)
            {
                //Sort By Count.
                phraseNameSpace.Value.Sort();

                int xmlItems = 0;
                foreach ( PhraseNameSpace phrase in phraseNameSpace.Value )
                {
                    if (xmlItems >= _popularTags)
                    {
                        break;
                    }

                    //Add the XML.
                    phrase.AddPhraseXml(popularTags);
                    ++xmlItems;
                }
            }
            return popularTags;
        }
    }
}
