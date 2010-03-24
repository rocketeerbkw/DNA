using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Rhino.Mocks;
using System;
using System.Collections.Generic;

namespace BBC.Dna.Sites.Tests
{
    
    
    /// <summary>
    ///This is a test class for SiteOptionListTest and is intended
    ///to contain all SiteOptionListTest Unit Tests
    ///</summary>
    [TestClass()]
    public class SiteOptionListTest
    {
        static public MockRepository mocks = new MockRepository();

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_ReadIsFalse_ReturnsEmptyObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(0, target.GetAllOptions().Count);
            Assert.AreEqual(0, target.GetAllOptionsDictionary().Count);
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_InvalidType_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.AtLeastOnce();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.AtLeastOnce();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return(10);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            try
            {
                target.CreateFromDatabase();
                throw new Exception("CreateFromDatabase should have thrown exception");
            }
            catch (SiteOptionInvalidTypeException)
            {
            }
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_AddsBoolOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = GetBoolSiteOptionMockReader();


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(2, target.GetAllOptions().Count);
            Assert.AreEqual(2, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);
            Assert.IsTrue(target.GetAllOptions()[0].GetValueBool());

            Assert.AreEqual(true, target.GetValueBool(1, "test", "test"));
        }

        static public IDnaDataReader GetBoolSiteOptionMockReader()
        {
            Queue<int> siteIds = new Queue<int>();
            siteIds.Enqueue(1);
            siteIds.Enqueue(0);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();
            reader.Stub(x => x.GetInt32("Type")).Return(1);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1).WhenCalled(x => x.ReturnValue = siteIds.Dequeue());
            reader.Stub(x => x.GetString("description")).Return("test");

            mocks.ReplayAll();
            return reader;
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_AddsStringOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = GetStringSiteOptionMockReader();


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.String, target.GetAllOptions()[0].OptionType);
            Assert.AreEqual("1", target.GetValueString(1, "test","test"));
        }

        static public IDnaDataReader GetStringSiteOptionMockReader()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.String);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("test");

            mocks.ReplayAll();
            return reader;
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_AddsIntOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();
            IDnaDataReader reader = GetIntSiteOptionMockReader();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Int, target.GetAllOptions()[0].OptionType);
            Assert.AreEqual(1, target.GetValueInt(1, "test", "test"));
        }

        static public IDnaDataReader GetIntSiteOptionMockReader()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Int);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("test");
            mocks.ReplayAll();
            return reader;
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_AddsDefaultBoolOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return(1);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);
            Assert.IsTrue(target.GetAllOptions()[0].GetValueBool());

            Assert.AreEqual(true, target.GetValueBool(1, "test", "test"));
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_AddsDefaultStringOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.String);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.String, target.GetAllOptions()[0].OptionType);
            Assert.AreEqual("1", target.GetValueString(1, "test", "test"));
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_AddsDefaultIntOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Int);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Int, target.GetAllOptions()[0].OptionType);
            Assert.AreEqual(1, target.GetValueInt(1, "test", "test"));
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void GetValueBool_NoOptions_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            try
            {
                target.GetValueBool(1, "", "");
                throw new Exception("GetValueBool should have thrown exception");
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }
       
        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void GetValueInt_NoOptions_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            try
            {
                target.GetValueInt(1, "", "");
                throw new Exception("GetValueInt should have thrown exception");
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }

        /// <summary>
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void GetValueString_NoOptions_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            try
            {
                target.GetValueString(1, "", "");
                throw new Exception("GetValueString should have thrown exception");
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }


        /// <summary>
        ///A test for SetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueInt_ChangesOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Int);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);
            
            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Int, target.GetAllOptions()[0].OptionType);

            target.SetValueInt(1, "test", "test", 2);
            Assert.AreEqual(2, target.GetValueInt(1, "test", "test"));
        }

        /// <summary>
        ///A test for SetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueInt_ChangesDefaultOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Int);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Int, target.GetAllOptions()[0].OptionType);

            target.SetValueInt(1, "test", "test", 2);
            Assert.AreEqual(2, target.GetValueInt(1, "test", "test"));
        }

        /// <summary>
        ///A test for SetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueInt_NoOption_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            try
            {
                target.SetValueInt(1, "test", "test", 1);
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }

        /// <summary>
        ///A test for SetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueBool_ChangesOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Bool);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);

            target.SetValueBool(1, "test", "test", false);
            Assert.AreEqual(false, target.GetValueBool(1, "test", "test"));
        }

        /// <summary>
        ///A test for SetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueBool_ChangesDefaultOption_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Bool);
            reader.Stub(x => x.GetString("Value")).Return("0");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);

            target.SetValueBool(1, "test", "test", true);
            Assert.AreEqual(true, target.GetValueBool(1, "test", "test"));
        }

        /// <summary>
        ///A test for SetValueInt
        ///</summary>
        [TestMethod()]
        public void SetValueBool_NoOption_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            try
            {
                target.SetValueBool(1, "test", "test", false);
            }
            catch (SiteOptionNotFoundException)
            {
            }
        }

        /// <summary>
        ///A test for CreateSiteOption
        ///</summary>
        [TestMethod()]
        public void CreateSiteOption_DefaultOption_ReturnsCorrectValue()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Bool);
            reader.Stub(x => x.GetString("Value")).Return("0");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);

            SiteOption actual = target.CreateSiteOption(1, "test", "test");
            Assert.AreEqual(0, actual.SiteId);
        }

        /// <summary>
        ///A test for CreateSiteOption
        ///</summary>
        [TestMethod()]
        public void CreateSiteOption_SiteSpecificOption_ReturnsCorrectValue()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Bool);
            reader.Stub(x => x.GetString("Value")).Return("0");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);

            SiteOption actual = target.CreateSiteOption(1, "test", "test");
            Assert.AreEqual(1, actual.SiteId);
        }

        /// <summary>
        ///A test for CreateSiteOption
        ///</summary>
        [TestMethod()]
        public void CreateSiteOption_NoOption_ThrowsException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);

            try
            {
                SiteOption actual = target.CreateSiteOption(1, "test", "test");
                throw new Exception("CreateSiteOption should not exist");
            }
            catch (SiteOptionNotFoundException)
            { }
        }

        /// <summary>
        ///A test for GetSiteOptionListForSite
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionListForSite_SpecificOption_ReturnsCorrectList()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();
            Queue<int> siteIds = new Queue<int>();
            siteIds.Enqueue(1);
            siteIds.Enqueue(0);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Bool);
            reader.Stub(x => x.GetString("Value")).Return("0");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1).WhenCalled(x => x.ReturnValue= siteIds.Dequeue());
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(2, target.GetAllOptions().Count);
            Assert.AreEqual(2, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);

            List<SiteOption> actual = target.GetSiteOptionListForSite(1);
            Assert.AreEqual(1, actual.Count);
            Assert.AreEqual("test", actual[0].Name);

            
        }

        /// <summary>
        ///A test for GetSiteOptionListForSite
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionListForSite_DefaultOption_ReturnsCorrectList()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Creating list from database")).Repeat.Once();
            diag.Stub(x => x.WriteTimedEventToLog("SiteOptionList", "Created list from database")).Repeat.Once();


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return((int)SiteOption.SiteOptionType.Bool);
            reader.Stub(x => x.GetString("Value")).Return("0");
            reader.Stub(x => x.GetString("Section")).Return("test");
            reader.Stub(x => x.GetString("Name")).Return("test");
            reader.Stub(x => x.GetInt32("SiteID")).Return(0);
            reader.Stub(x => x.GetString("description")).Return("test");


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("setsiteoption")).Return(reader);

            

            mocks.ReplayAll();

            SiteOptionList target = new SiteOptionList(creator, diag);
            target.CreateFromDatabase();
            Assert.AreEqual(1, target.GetAllOptions().Count);
            Assert.AreEqual(1, target.GetAllOptionsDictionary().Count);
            Assert.AreEqual(SiteOption.SiteOptionType.Bool, target.GetAllOptions()[0].OptionType);

            List<SiteOption> actual = target.GetSiteOptionListForSite(1);
            Assert.AreEqual(1, actual.Count);
            Assert.AreEqual("test", actual[0].Name);
            Assert.IsTrue(actual[0].IsGlobal);


        }
    }
}
