using System;
using System.Collections.Generic;
using System.Xml;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.Xml.Serialization;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// The Site class holds all the data regarding a Site
    /// </summary>
    [Serializable]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "DIVISION")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "DIVISION")]
    [DataContract(Name = "division")]
    public class Division
    {
        [XmlAttribute(AttributeName = "ID")]
        public short id
        {
            get;
            set;
        }

        [XmlAttribute(AttributeName = "NAME")]
        public string Name
        {
            get;
            set;
        }
    }

    [XmlTypeAttribute(AnonymousType = true, TypeName = "DIVISIONS")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "DIVISIONS")]
    [DataContract(Name = "divisions")]
    public class Divisions
    {
        public Divisions()
        {
            divisions = new List<Division>();
        }

        [XmlArray (ElementName="DIVISIONS")]
        [XmlArrayItem( ElementName="DIVISION")]
        public List<Division> divisions
        {
            get;
            set;
        }

        /// <summary>
        /// Generates all divisions
        /// </summary>
        /// <param name="creator"></param>
        /// <returns></returns>
        public static Divisions GetDivisions(IDnaDataReaderCreator creator)
        {
            var divisions = new Divisions();
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getbbcdivisions"))
            {
                dataReader.Execute();

                while (dataReader.Read())
                {
                    var division = new Division();
                    division.id = dataReader.GetInt16("bbcdivisionid");
                    division.Name = dataReader.GetStringNullAsEmpty("bbcdivisionname");
                    divisions.divisions.Add(division);
                }
            }
            return divisions;
        }
    }

    
}