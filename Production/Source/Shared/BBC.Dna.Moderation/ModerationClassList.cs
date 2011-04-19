using System.Collections.ObjectModel;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System;
using BBC.Dna.Utils;
using System.Collections.Generic;
using System.Xml.Serialization;
using System.Collections.Specialized;

namespace BBC.Dna.Moderation
{
    public class ModerationClassListCache : SignalBase<ModerationClassList>
    {

        private const string _signalKey = "recache-moderationclasses";


        public ModerationClassListCache(IDnaDataReaderCreator dnaData_readerCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
            : base(dnaData_readerCreator, dnaDiagnostics, caching, _signalKey, ripleyServerAddresses, dotNetServerAddresses)
        {
            InitialiseObject += new InitialiseObjectDelegate(GetAllModerationClassesFromDb);
            HandleSignalObject = new HandleSignalDelegate(HandleSignal);
            GetStatsObject = new GetStatsDelegate(GetModClassStats);
            CheckVersionInCache();
            //register object with main signal helper
            SignalHelper.AddObject(typeof(ModerationClassListCache), this);
        }

        /// <summary>
        /// gets all moderation classes in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public void GetAllModerationClassesFromDb(params object[] args)
        {
            var classes = new ModerationClassList();
            using (var reader = _readerCreator.CreateDnaDataReader("getmoderationclasslist"))
            {
                reader.Execute();
                while(reader.Read())
                {
                    var modClass = new ModerationClass
                                       {
                                           ClassId = reader.GetInt32NullAsZero("ModClassId"),
                                           Description = reader.GetStringNullAsEmpty("Description"),
                                           Name = reader.GetStringNullAsEmpty("name"),
                                           Language = reader.GetStringNullAsEmpty("ClassLanguage"),
                                           ItemRetrievalType = (ModerationRetrievalPolicy)reader.GetTinyIntAsInt("ItemRetrievalType")
                                       };
                    classes.ModClassList.Add(modClass);
                }
            }
            AddToInternalObjects(GetCacheKey(), GetCacheKeyLastUpdate(), classes);
        }

        /// <summary>
        /// Delegate for handling a signal
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        private bool HandleSignal(NameValueCollection args)
        {
            GetAllModerationClassesFromDb();
            return true;
        }

        /// <summary>
        /// Gets stats for classes
        /// </summary>
        /// <returns></returns>
        private NameValueCollection GetModClassStats()
        {
            var values = new NameValueCollection();


            var _object = (ModerationClassList)GetObjectFromCache();
            values.Add("ModClassStats", _object.ModClassList.Count.ToString());
            return values;
        }

        static public ModerationClassList GetObject()
        {
            var obj = SignalHelper.GetObject(typeof(ModerationClassListCache));
            if (obj != null)
            {
                return (ModerationClassList)((ModerationClassListCache)obj).GetCachedObject();
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public ModerationClassList GetObjectFromCache()
        {
            
            return (ModerationClassList)GetCachedObject();
        }

        public void SendSignal()
        {
            base.SendSignals();
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=true, TypeName="MODERATION-CLASSES")]
    [XmlRootAttribute("MODERATION-CLASSES", Namespace="", IsNullable=false)]
    public class ModerationClassList 
    {
        /// <summary>
        /// Constructor
        /// </summary>
        public ModerationClassList()
        {//default to empty list
            ModClassList = new Collection<ModerationClass>();
        }

        [XmlElementAttribute("MODERATION-CLASS", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public Collection<ModerationClass> ModClassList { get; set; }
    }
}
