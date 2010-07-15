using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    struct SiteOptionSpec
    {
        public int siteId;
        public string section;
        public string name;
        public string value;
        public int type;
        public string description;

        public void debugOut()
        {
            System.Console.Write(siteId);
            System.Console.Write(" : ");
            System.Console.Write(section);
            System.Console.Write(" : ");
            System.Console.Write(name);
            System.Console.Write(" : ");
            System.Console.Write(value);
            System.Console.Write(" : ");
            System.Console.Write(type);
            System.Console.Write(" : ");
            System.Console.Write(description);
            System.Console.WriteLine("");
        }
    }

    /// <summary>
    /// Tests for the SiteOptionsList and SiteOption class
    /// </summary>
    [TestClass]
    public class SiteOptionListTests : FullInputContext
    {
        /// <summary>
        /// Constructor
        /// <param name="useIdentity"></param>
        /// </summary>
        public SiteOptionListTests(bool useIdentity)
            : base(useIdentity)
        {
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public SiteOptionListTests()
            : base(false)
        {
        }

        private List<SiteOptionSpec> ReadSiteOptionsDirectly()
        {
            List<SiteOptionSpec> list = new List<SiteOptionSpec>();

            using (IDnaDataReader dataReader = CreateDnaDataReader("getallsiteoptions"))
            {
                dataReader.Execute();

                while (dataReader.Read())
                {
                    SiteOptionSpec s = new SiteOptionSpec();
                    s.siteId = dataReader.GetInt32("SiteID");
                    s.section = dataReader.GetString("Section");
                    s.name = dataReader.GetString("Name");
                    s.value = dataReader.GetString("Value");
                    s.type = dataReader.GetInt32("Type");
                    s.description = dataReader.GetString("Description");

                    list.Add(s);
                }
            }

            return list;
        }

        /// <summary>
        /// Tests that the values SiteOptionList reads from the db are the values
        /// it returns with the access methods
        /// </summary>
        [TestMethod]
        public void TestSiteOptionListValues()
        {
            Console.WriteLine("TestSiteOptionListValues");
            List<SiteOptionSpec> list = ReadSiteOptionsDirectly();

            SiteOptionList soList = new SiteOptionList();
            soList.CreateFromDatabase(ReaderCreator, base.dnaDiagnostics);

            foreach (SiteOptionSpec s in list)
            {
                switch (s.type)
                {
                    case 0:
                        int v = soList.GetValueInt(s.siteId, s.section, s.name);
                        Assert.AreEqual(int.Parse(s.value), v);

                        try
                        {
                            soList.GetValueBool(s.siteId, s.section, s.name);
                        }
                        catch (SiteOptionInvalidTypeException ex)
                        {
                            Assert.AreEqual("Value is not a bool", ex.Message);
                        }
                        break;

                    case 1:
                        bool sb = false;
                        switch (s.value)
                        {
                            case "0": sb = false; break;
                            case "1": sb = true; break;
                            default: Assert.Fail("Invalid value for bool type", s.value); break;
                        }

                        bool b = soList.GetValueBool(s.siteId, s.section, s.name);
                        Assert.AreEqual(sb, b);

                        try
                        {
                            soList.GetValueInt(s.siteId, s.section, s.name);
                        }
                        catch (SiteOptionInvalidTypeException ex)
                        {
                            Assert.AreEqual("Value is not an int", ex.Message);
                        }
                        break;

                    case 2:
                        string value = soList.GetValueString(s.siteId, s.section, s.name);
                        Assert.AreEqual(s.value, value);

                        try
                        {
                            soList.GetValueString(s.siteId, s.section, s.name);
                        }
                        catch (SiteOptionInvalidTypeException ex)
                        {
                            Assert.AreEqual("Value is not a string", ex.Message);
                        }
                        break;

                    default:
                        Assert.Fail("Unknown site option type", s.type);
                        break;
                }
            }

            foreach (SiteOptionSpec s in list)
            {
                SiteOption so = soList.CreateSiteOption(s.siteId, s.section, s.name);
                Assert.AreEqual(s.siteId, so.SiteId);
                Assert.AreEqual(s.section, so.Section);
                Assert.AreEqual(s.name, so.Name);
                Assert.AreEqual(s.description, so.Description);

                switch (s.type)
                {
                    case 0:  Assert.AreEqual(SiteOption.SiteOptionType.Int, so.OptionType);  break;
                    case 1: Assert.AreEqual(SiteOption.SiteOptionType.Bool, so.OptionType); break;
                    case 2: Assert.AreEqual(SiteOption.SiteOptionType.String, so.OptionType); break;
                    default: Assert.Fail("Unknown site option type", s.type); break;
                }
            }

            try
            {
                SiteOption so = soList.CreateSiteOption(999, "not", "there");
            }
            catch (SiteOptionNotFoundException ex)
            {
                Assert.AreEqual(999, (int)ex.Data["SiteID"]);
                Assert.AreEqual("not", (string)ex.Data["Section"]);
                Assert.AreEqual("there", (string)ex.Data["Name"]);
            }
        }

        /// <summary>
        /// Tests that the Get methods work correctly.
        /// If you ask for an option for a site and it exists, you get that value
        /// If you ask for an option for a site and it doesn't exist, you should get the site 0 value
        /// </summary>
        [TestMethod]
        public void TestSiteOptionListGetMethods()
        {
            Console.WriteLine("TestSiteOptionListGetMethods");
            List<SiteOptionSpec> list = ReadSiteOptionsDirectly();

            SiteOptionList soList = new SiteOptionList();
            soList.CreateFromDatabase(DnaMockery.CreateDatabaseReaderCreator(), dnaDiagnostics);

            List<SiteOptionSpec> siteZero = new List<SiteOptionSpec>();
            List<SiteOptionSpec> siteNoneZero = new List<SiteOptionSpec>();
            List<SiteOptionSpec> valueDiffFromSiteZero = new List<SiteOptionSpec>();

            foreach (SiteOptionSpec s in list)
            {
                switch (s.siteId)
                {
                    case 0 : siteZero.Add(s);     break;
                    default: siteNoneZero.Add(s); break;
                }
            }

            bool foundDiffInt = false;
            bool foundDiffBool = false;
            bool foundDiffString = false;

            foreach (SiteOptionSpec snz in siteNoneZero)
            {
                foreach (SiteOptionSpec sz in siteZero)
                {
                    if (snz.section == sz.section &&
                        snz.name == sz.name &&
                        snz.value != sz.value)
                    {
                        if (snz.type == 0 && !foundDiffInt)
                        {
                            valueDiffFromSiteZero.Add(snz);
                            foundDiffInt = true;
                        }

                        if (snz.type == 1 && !foundDiffBool)
                        {
                            valueDiffFromSiteZero.Add(snz);
                            foundDiffBool = true;
                        }

                        if (snz.type == 2 && !foundDiffString)
                        {
                            valueDiffFromSiteZero.Add(snz);
                            foundDiffString = true;
                        }
                    }
                }
            }

            foreach (SiteOptionSpec s in valueDiffFromSiteZero)
            {
                if (s.type == 0)
                {
                    int v0   = soList.GetValueInt(0, s.section, s.name);
                    int vs   = soList.GetValueInt(s.siteId, s.section, s.name);
                    int v999 = soList.GetValueInt(999, s.section, s.name);

                    Assert.AreNotEqual(v0, vs, "The value of this site option should be different to site zero");
                    Assert.AreEqual(v0, v999, "Non-existant site should have same value as site zero");
                }

                if (s.type == 1)
                {
                    bool v0 = soList.GetValueBool(0, s.section, s.name);
                    bool vs = soList.GetValueBool(s.siteId, s.section, s.name);
                    bool v999 = soList.GetValueBool(999, s.section, s.name);

                    Assert.AreNotEqual(v0, vs, "The value of this site option should be different to site zero");
                    Assert.AreEqual(v0, v999, "Non-existant site should have same value as site zero");
                }

                if (s.type == 2)
                {
                    string v0 = soList.GetValueString(0, s.section, s.name);
                    string vs = soList.GetValueString(s.siteId, s.section, s.name);
                    string v999 = soList.GetValueString(999, s.section, s.name);

                    Assert.AreNotEqual(v0, vs, "The value of this site option should be different to site zero");
                    Assert.AreEqual(v0, v999, "Non-existant site should have same value as site zero");
                }
            }

            try
            {
                soList.GetValueInt(0, "NotThere", "gone");
            }
            catch (SiteOptionNotFoundException ex)
            {
                Assert.AreEqual(0, (int)ex.Data["SiteID"]);
                Assert.AreEqual("NotThere", (string)ex.Data["Section"]);
                Assert.AreEqual("gone", (string)ex.Data["Name"]);
            }

            try
            {
                soList.GetValueBool(0, "NotThere", "gone");
            }
            catch (SiteOptionNotFoundException ex)
            {
                Assert.AreEqual(0, (int)ex.Data["SiteID"]);
                Assert.AreEqual("NotThere", (string)ex.Data["Section"]);
                Assert.AreEqual("gone", (string)ex.Data["Name"]);
            }

            try
            {
                soList.GetValueString(0, "NotThere", "gone");
            }
            catch (SiteOptionNotFoundException ex)
            {
                Assert.AreEqual(0, (int)ex.Data["SiteID"]);
                Assert.AreEqual("NotThere", (string)ex.Data["Section"]);
                Assert.AreEqual("gone", (string)ex.Data["Name"]);
            }

            List<int> siteIdList = new List<int>();
            foreach (SiteOptionSpec s in valueDiffFromSiteZero)
            {
                int siteId = s.siteId;

                siteIdList.Add(siteId);

                List<SiteOption> siteOptionListForSite = soList.GetSiteOptionListForSite(siteId);
                Assert.AreEqual(siteZero.Count, siteOptionListForSite.Count);

                foreach (SiteOption so in siteOptionListForSite)
                {
                    if (so.Section == s.section && so.Name == s.name && so.SiteId == siteId)
                    {
                        bool valuesDiffer = false;

                        switch (so.OptionType)
                        {
                            case SiteOption.SiteOptionType.Int:
                                int a = soList.GetValueInt(0, so.Section, so.Name);
                                int b = soList.GetValueInt(so.SiteId, so.Section, so.Name);
                                valuesDiffer = (a != b);
                                break;

                            case SiteOption.SiteOptionType.Bool:
                                bool x = soList.GetValueBool(0, so.Section, so.Name);
                                bool y = soList.GetValueBool(so.SiteId, so.Section, so.Name);
                                valuesDiffer = (x != y);
                                break;

                            case SiteOption.SiteOptionType.String:
                                string i = soList.GetValueString(0, so.Section, so.Name);
                                string j = soList.GetValueString(so.SiteId, so.Section, so.Name);
                                valuesDiffer = (i != j);
                                break;

                            default:
                                Assert.Fail("Unknown site option type", so.OptionType);
                                break;
                        }
                        Assert.IsTrue(valuesDiffer, "Values should be different");
                    }
                }
            }
        }

    }
}
