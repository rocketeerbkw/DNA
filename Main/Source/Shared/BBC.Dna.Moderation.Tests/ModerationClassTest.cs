using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Xml;
using TestUtils;
namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for ModerationClassTest and is intended
    ///to contain all ModerationClassTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ModerationClassTest
    {

        /// <summary>
        ///A test for ModerationClass Constructor
        ///</summary>
        [TestMethod()]
        public void ModerationClassXmlSerialization()
        {
            ModerationClass target = GetModClass();
            var expected = "<MODERATION-CLASS xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" CLASSID=\"1\"><NAME>test</NAME><DESCRIPTION>test</DESCRIPTION><ITEMRETRIEVALTYPE>Standard</ITEMRETRIEVALTYPE></MODERATION-CLASS>";

            XmlDocument xml = Serializer.SerializeToXml(target);
            Assert.AreEqual(expected, xml.SelectSingleNode("MODERATION-CLASS").OuterXml);
        }

        public static ModerationClass GetModClass()
        {
            return new ModerationClass() {ClassId = 1, Description = "test", Name = "test"};
        }
    }
}
