using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Utils;
using Tests;
using System.IO;
//using System.Web.Script.Serialization;
using BBC.Dna.Objects;

namespace TestUtils
{
    public class Serializer
    {
        public static XmlDocument SerializeToXml(object data)
        {
            XmlDocument xml = new XmlDocument();
            using (StringWriterWithEncoding writer = new StringWriterWithEncoding(Encoding.UTF8))
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UTF8Encoding(false);
                settings.Indent = true;
                settings.OmitXmlDeclaration = true;
                using (XmlWriter xWriter = XmlWriter.Create(writer, settings))
                {
                    System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(data.GetType());
                    x.Serialize(xWriter, data);
                    xWriter.Flush();
                    xml.LoadXml(Entities.GetEntities() + writer.ToString());
                }
            }
            return xml;
        }

        //public static string SerializeToJson(object data)
        //{
        //    JavaScriptSerializer serializer = new JavaScriptSerializer();
        //    return serializer.Serialize(data);

        //}

        public static void ValidateObjectToSchema(object obj, string schemaName)
        {
            XmlDocument xml = Serializer.SerializeToXml(obj);
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, schemaName);
            validator.Validate();
        }
    }
}
