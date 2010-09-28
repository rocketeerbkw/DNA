using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Collections.ObjectModel;
using System.Xml;
using System.CodeDom.Compiler;
using System.Xml.Serialization;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// The Insert Types class
    /// </summary>
    [Serializable]
    [XmlType("INSERT-TYPES")]
    public class InsertTypes
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public InsertTypes() { }

        /// <summary>
        /// This method gets all the insert types
        /// </summary>
        /// <returns>An InsertTypes object that contains all the types of inserts</returns>
        public static InsertTypes GetInsertTypes()
        {
            // Create and initialise a new Insert Types object
            InsertTypes insertTypes = new InsertTypes();
            insertTypes.InsertTypesList = new Collection<InsertType>();

            // Now add all the insert types to the collection
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "inserted_text" } );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "content_type"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "add_content_method"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "content_url"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "content_subject"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "content_text"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "reference_number"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "nickname"} );
            insertTypes.InsertTypesList.Add(new InsertType() { Type = "userid" } );

            // Return the new Object
            return insertTypes;
        }

        [XmlElement("TYPE")]
        public Collection<InsertType> InsertTypesList { get; set; }
    }

    /// <summary>
    /// The insert Type class
    /// </summary>
    [Serializable]
    [XmlType(TypeName="TYPE")]
    public class InsertType
    {
        public InsertType() { }

        [XmlText()]
        public string Type { get; set; }
    }
}
