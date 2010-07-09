using System.Collections.ObjectModel;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;

namespace BBC.Dna.Moderation
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="MODERATION-CLASSES")]
    [System.Xml.Serialization.XmlRootAttribute("MODERATION-CLASSES", Namespace="", IsNullable=false)]
    public class ModerationClassList : CachableBase<ModerationClassList>
    {
        /// <summary>
        /// Constructor
        /// </summary>
        public ModerationClassList()
        {//default to empty list
            ModClassList = new Collection<ModerationClass>();
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("MODERATION-CLASS", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public Collection<ModerationClass> ModClassList { get; set; }

        public static ModerationClassList GetAllModerationClasses(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager,
           bool ignoreCache)
        {
            var moderationClassList = new ModerationClassList();
            if (!ignoreCache)
            {
                moderationClassList = (ModerationClassList)cacheManager.GetData(moderationClassList.GetCacheKey());
                if (moderationClassList != null)
                {
                    return moderationClassList;
                }

            }

            moderationClassList = GetAllModerationClassesFromDb(readerCreator);
            cacheManager.Add(moderationClassList.GetCacheKey(), moderationClassList);

            return moderationClassList;
        }
        
        /// <summary>
        /// gets all moderation classes in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static ModerationClassList GetAllModerationClassesFromDb(IDnaDataReaderCreator readerCreator)
        {
            var classes = new ModerationClassList();
            using (var reader = readerCreator.CreateDnaDataReader("getmoderationclasslist"))
            {
                reader.Execute();
                while(reader.Read())
                {
                    var modClass = new ModerationClass
                                       {
                                           ClassId = reader.GetInt32NullAsZero("ModClassId"),
                                           Description = reader.GetStringNullAsEmpty("Description"),
                                           Name = reader.GetStringNullAsEmpty("name")
                                       };
                    classes.ModClassList.Add(modClass);
                }
            }
            return classes;
        }



        /// <summary>
        /// Always true as the cache is loaded at startup
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return true;
        }
    }
}
