#region

using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Xml.Schema;
using System.Xml.Serialization;
using System.Collections.ObjectModel;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;

#endregion

namespace BBC.Dna.Moderation
{
    /// <remarks />
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "TERMADMIN")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "TERMSFILTERADMIN")]
    public class TermsFilterAdmin
    {
        /// <summary>
        /// Constructor
        /// </summary>
        public TermsFilterAdmin()
        {
            TermsList = new TermsList();
            ModerationClasses = new ModerationClassList();
        }

        #region Properties
        /// <remarks />
        [XmlElement(Order = 1, ElementName = "TERMSLIST")]
        public TermsList TermsList { get; set; }

        /// <remarks />
        [XmlElement("MODERATION-CLASSES", Order = 2)]
        public ModerationClassList ModerationClasses { get; set; } 
        #endregion

        /// <summary>
        /// Creates the term admin object
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="modClassId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static TermsFilterAdmin CreateTermAdmin(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager,
            int modClassId, bool ignoreCache)
        {
            var termAdmin = new TermsFilterAdmin() ;
            termAdmin.ModerationClasses = ModerationClassList.GetAllModerationClasses(readerCreator, cacheManager,ignoreCache);

            termAdmin.TermsList = TermsList.GetTermsListByModClassId(readerCreator, cacheManager, modClassId,
                                                                     ignoreCache);
            return termAdmin;
        }
    }
}