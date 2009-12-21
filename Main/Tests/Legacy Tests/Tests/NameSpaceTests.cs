using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Name spaces tests
    /// </summary>
    [TestClass]
    public class NameSpaceTests
    {
        /// <summary>
        /// 
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
			SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Test that we can create a new namespace for a site
        /// </summary>
        [TestMethod]
        public void TestCreateNewNameSpaceForSite()
        {
            // Create a new NameSpace object and create a new name space for a test site
            NameSpaceItem newItem = AddNameSpaceToSite(1, "category");

            // Now check the results.
            Assert.IsTrue(newItem.ID > 0, "NameSpaceId is zero! Failed to create new name space.");
        }

        private NameSpaceItem AddNameSpaceToSite(int siteid, string name)
        {
            // Create a new NameSpace object and create a new name space for a test site
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("addnamespacetosite"))
            {
                // Create the namespace object and call the add namespace method
                NameSpaces testNameSpace = new NameSpaces(context);
                return new NameSpaceItem(name, testNameSpace.AddNameSpaceForSite(siteid, name));
            }
        }

        /// <summary>
        /// Test that we get a correct list of namespaces for a given site
        /// </summary>
        [TestMethod]
        public void TestGetNameSpacesForSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the namespace object and call the add namespace method
            NameSpaces testNameSpace = new NameSpaces(context);

            // Create the list of anmespace to add
            List<NameSpaceItem> namespaces = new List<NameSpaceItem>();
            namespaces.Add(AddNameSpaceToSite(1, "category"));
            namespaces.Add(AddNameSpaceToSite(1, "mood"));
            namespaces.Add(AddNameSpaceToSite(1, "people"));
            namespaces.Add(AddNameSpaceToSite(1, "places"));
            foreach (NameSpaceItem name in namespaces)
            {
                // check to make sure the name was added correctly
                Assert.IsTrue(name.ID > 0, "NameSpaceId is zero! Failed to create new name space. namespace being added = " + name.Name);
            }
           
            using (IDnaDataReader reader = context.CreateDnaDataReader("getnamespacesforsite"))
            {
                // Now get all the namespaces for the site and comparte the results with the known values.
                List<NameSpaceItem> foundNameSpaces = testNameSpace.GetNameSpacesForSite(1);
                for (int i = 0; i < foundNameSpaces.Count; i++)
                {
                    Assert.AreEqual(namespaces[i].Name, foundNameSpaces[i].Name, "The namespaces found are not the same as the ones added for Names");
                    Assert.AreEqual(namespaces[i].ID, foundNameSpaces[i].ID, "The namespaces found are not the same as the ones added for IDs");
                }
            }
        }

        /// <summary>
        /// Test tpo make sure we can rename namespaces
        /// </summary>
        [TestMethod]
        public void TestRenameNameSpaceForSite()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the namespace object and call the add namespace method
            NameSpaces testNameSpace = new NameSpaces(context);

            // Create the list of anmespace to add
            List<NameSpaceItem> namespaces = new List<NameSpaceItem>();
            namespaces.Add(AddNameSpaceToSite(1, "category"));
            namespaces.Add(AddNameSpaceToSite(1, "mood"));
            namespaces.Add(AddNameSpaceToSite(1, "people"));
            namespaces.Add(AddNameSpaceToSite(1, "places"));
            foreach (NameSpaceItem name in namespaces)
            {
                // check to make sure the name was added correctly
                Assert.IsTrue(name.ID > 0, "NameSpaceId is zero! Failed to create new name space. namespace being added = " + name.Name);
            }

            // Create the stored procedure reader for the namespace object
            using (IDnaDataReader reader = context.CreateDnaDataReader("renamenamespace"))
            {
                // Now rename one of the namespaces
                NameSpaceItem renamed = new NameSpaceItem(namespaces[1].Name + "-renamed", namespaces[1].ID);
                namespaces.RemoveAt(1);
                namespaces.Insert(1, renamed);
                testNameSpace.RenameNameSpaceForSite(1, namespaces[1].ID, namespaces[1].Name);
            }
                // Now get all the namespaces for the site
            using (IDnaDataReader reader2 = context.CreateDnaDataReader("getnamespacesforsite"))
            {

                // Now get all the namespaces for the site and comparte the results with the known values.
                List<NameSpaceItem> foundNameSpaces = testNameSpace.GetNameSpacesForSite(1);
                for (int i = 0; i < foundNameSpaces.Count; i++)
                {
                    Assert.AreEqual(namespaces[i].Name, foundNameSpaces[i].Name, "The namespaces found are not the same as the ones added for Names");
                    Assert.AreEqual(namespaces[i].ID, foundNameSpaces[i].ID, "The namespaces found are not the same as the ones added for IDs");
                }
            }
        }

        /// <summary>
        /// Test to make sure we get all the phrases for a given namespace.
        /// </summary>
        [TestMethod]
        public void TestGetPhrasesforNameSpace()
        {
            // Create a new NameSpace object and create a new name space for a test site
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the namespace object and call the add namespace method
            NameSpaces testNameSpace = new NameSpaces(context);
            NameSpaceItem newName = AddNameSpaceToSite(1, "category");
            Assert.IsTrue(newName.ID > 0, "NameSpaceId is zero! Failed to create new name space. namespace being added = category");

            // Now add some phrases to the namespace by adding some phrases to an article
            List<string> phrases = new List<string>();
            phrases.Add("funny");
            phrases.Add("sad");
            phrases.Add("random");
            phrases.Add("practical");
            using (IDnaDataReader reader = context.CreateDnaDataReader("addkeyphrasestoarticle"))
            {
                // Add the phrases
                string keyPhrases = "";
                foreach (string phrase in phrases)
                {
                    keyPhrases += phrase + "|";
                }
                keyPhrases = keyPhrases.TrimEnd('|');
                reader.AddParameter("h2g2id", 5176);
                reader.AddParameter("keywords",keyPhrases);
                reader.AddParameter("namespaces", "category|category|category|category");
                reader.Execute();
            }

            List<string> namespacePhrases = GetPhrasesForNameSpace(1, newName.ID, testNameSpace);
            Assert.IsTrue(namespacePhrases.Count == 4, "Get phrases for namespace failed to find all phrases");

            // now compare the phrases with the known values.
            for (int i = 0; i < namespacePhrases.Count; i++)
            {
                Assert.IsTrue(phrases.Exists(delegate(string match) { return match == namespacePhrases[i]; }), "Failed to find known phrase in the found phrases. Phrase = " + namespacePhrases[i]);
            }
        }

        private List<string> GetPhrasesForNameSpace(int siteid, int namespaceid, NameSpaces nameSpace)
        {
            // Now get all the phrases for a given namespace
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getphrasesfornamespace"))
            {
                return nameSpace.GetPhrasesForNameSpaceItem(siteid, namespaceid);
            }
        }

        /// <summary>
        /// Test to make sure that we correctly remove a name space
        /// </summary>
        [TestMethod]
        public void TestRemoveNameSpaceForSite()
        {
            // Create a new NameSpace object and create a new name space for a test site
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the namespace object and call the add namespace method
            NameSpaces testNameSpace = new NameSpaces(context);
            NameSpaceItem newName = AddNameSpaceToSite(1, "category");
            Assert.IsTrue(newName.ID > 0, "NameSpaceId is zero! Failed to create new name space. namespace being added = category");

            // Now add some phrases to the namespace by adding some phrases to an article
            List<string> phrases = new List<string>();
            phrases.Add("funny");
            phrases.Add("sad");
            phrases.Add("random");
            phrases.Add("practical");
            
            using (IDnaDataReader reader = context.CreateDnaDataReader("addkeyphrasestoarticle"))
            {
                // Add the phrases
                string keyPhrases = "";
                foreach (string phrase in phrases)
                {
                    keyPhrases += phrase + "|";
                }
                keyPhrases = keyPhrases.TrimEnd('|');
                reader.AddParameter("h2g2id", 5176);
                reader.AddParameter("keywords", keyPhrases);
                reader.AddParameter("namespaces", "category|category|category|category");
                reader.Execute();
            }

            // Now get all the phrases for a given namespace
            List<string> namespacePhrases = GetPhrasesForNameSpace(1, newName.ID, testNameSpace);
            Assert.IsTrue(namespacePhrases.Count == 4, "Get phrases for namespace failed to find all phrases");

            // now compare the phrases with the known values.
            for (int i = 0; i < namespacePhrases.Count; i++)
            {
                // Check to make sure that we have all the same items in both lists
                Assert.IsTrue(phrases.Exists(delegate(string match) { return match == namespacePhrases[i]; }), "Failed to find known phrase in the found phrases. Phrase = " + namespacePhrases[i]);
            }

            // now remove the namespace and check to make sure that the phrases are removed form the article
            using (IDnaDataReader reader3 = context.CreateDnaDataReader("deletenamespaceandassociatedlinks"))
            {
                testNameSpace.RemoveNameSpaceForSite(1, newName.ID);

                // Now get all the phrases for the namespace we removed.
                NameSpaces testNameSpace2 = new NameSpaces(context);
                namespacePhrases = GetPhrasesForNameSpace(1, newName.ID, testNameSpace2);
                Assert.IsTrue(namespacePhrases.Count == 0, "The number of phrases returned from a remove namespace should be zero!");
            }
        }
    }
}
