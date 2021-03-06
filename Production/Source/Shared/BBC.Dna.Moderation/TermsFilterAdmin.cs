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

        /// <summary>
        /// Constructor for Terms By Forum
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="isForForum"></param>
        public TermsFilterAdmin(int forumId, bool isForForum)
        {
            TermsList = new TermsList(forumId, false, isForForum);
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
        /// <returns></returns>
        public static TermsFilterAdmin CreateTermAdmin(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager,
            int modClassId)
        {
            var termAdmin = new TermsFilterAdmin() ;
            termAdmin.ModerationClasses = ModerationClassListCache.GetObject();
            termAdmin.TermsList = TermsList.GetTermsListByModClassId(readerCreator, cacheManager, modClassId, true);
            return termAdmin;
        }

        /// <summary>
        /// Creates the forum specific term admin object
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="forumId"></param>
        /// <returns></returns>
        public static TermsFilterAdmin CreateForumTermAdmin(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager,
            int forumId)
        {
            var termAdmin = new TermsFilterAdmin(forumId, true);           
            termAdmin.TermsList = TermsList.GetTermsListByForumId(readerCreator, cacheManager, forumId, true);
            return termAdmin;
        }
    }
}