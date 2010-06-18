using System.Runtime.Serialization;
using Dna.SnesIntegration.ActivityProcessor;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SnesActivityProcessorTests
{
    [DataContract]
    class SimpleDataContract
    {
        [DataMember(IsRequired = true)]
        public int A { get; set; }
    }

    [DataContract]
    class StringContract
    {
        [DataMember]
        public string UnicodeString {get; set;}
    }

    /// <summary>
    /// Summary description for StringHelperTests
    /// </summary>
    [TestClass]
    public class StringHelperTests
    {
        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext { get; set; }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void ObjectFromJson_StringIsValidJson_ReturnsSimpleDataContract()
        {
            string json = @"{ ""A"": 1}";

            var obj = json.ObjectFromJson<SimpleDataContract>();

            Assert.IsNotNull(obj);
        }

        [TestMethod]
        public void ObjectFromJson_StringIsInvalidJson_ReturnsNull()
        {
            string notJson = @"here is a random non-json string";
            var obj = notJson.ObjectFromJson<SimpleDataContract>();
            Assert.IsNull(obj);
        }

        [TestMethod]
        public void ObjectFromJson_StringIsValidJsonTypeIsNotDataContract_ReturnsNull()
        {
            string json = @"{""A"":1}";

            var obj = json.ObjectFromJson<string>();
            Assert.IsNull(obj);
        }

        [TestMethod]
        public void ObjectFromJson_StringIsInvalidForDataContract_ReturnsNull()
        {
            string json = @"{""Anything"":""Anything""}";
            var obj = json.ObjectFromJson<SimpleDataContract>();

            Assert.IsNull(obj);
        }

        [TestMethod]
        public void JsonFromObject_UnicodeTestString_Converts()
        {
            var contract = new StringContract {UnicodeString = @"Iñtërnâtiônàlizætiøn <>&!"};

            string json = contract.JsonFromObject<StringContract>();

            Assert.IsTrue(json.Contains(@"Iñtërnâtiônàlizætiøn <>&!"));
        }
    }
}
