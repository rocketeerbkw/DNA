using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Data;
using System.Collections.Generic;
namespace BBC.Dna.Moderation
{


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "TERMSLIST")]
    public class TermsList : CachableBase<TermsList>
    {
        /// <summary>
        /// Constructor lists
        /// </summary>
        public TermsList()
        {
            Terms = new List<Term>();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="modClassId"></param>
        public TermsList(int modClassId)
        {
            ModClassId = modClassId;
            Terms = new List<Term>();
        }

        #region Properties
        /// <remarks/>
        [XmlElementAttribute("TERM", Order = 0)]
        public List<Term> Terms { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "MODCLASSID")]
        public int ModClassId { get; set; } 
        #endregion

        public static TermsList GetTermsListByModClassId(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager,
            int modClassId, bool ignoreCache)
        {
            var termsList = new TermsList {ModClassId = modClassId};
            if(!ignoreCache)
            {
                termsList = (TermsList)cacheManager.GetData(termsList.GetCacheKey(modClassId));
                if(termsList != null)
                {
                    return termsList;
                }

            }

            termsList = GetTermsListByModClassIdFromDB(readerCreator, modClassId);
            cacheManager.Add(termsList.GetCacheKey(modClassId), termsList);

            return termsList;
        }

        /// <summary>
        /// Gets the terms list from the db...
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="modClassId"></param>
        /// <returns></returns>
        public static TermsList GetTermsListByModClassIdFromDB(IDnaDataReaderCreator readerCreator,
            int modClassId)
        {
            var termsList = new TermsList { ModClassId = modClassId };

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("gettermsbymodclassid"))
            {
                reader.AddParameter("modClassId", modClassId);
                reader.Execute();
                while(reader.Read())
                {
                    var term = new Term
                                    {
                                        Id = reader.GetInt32NullAsZero("termId"),
                                        Action = (TermAction)reader.GetByteNullAsZero("actionId"),
                                        Value = reader.GetStringNullAsEmpty("term")
                                    };
                    termsList.Terms.Add(term);
                }
            }

            return termsList;
        }


        /// <summary>
        /// not used as its just a inmemory cache
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return true;
        }

        /// <summary>
        /// Updates all terms in the list for the list modclass id
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="reason"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public Error UpdateTermsInDatabase(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager, 
            string reason, int userId)
        {
            if(String.IsNullOrEmpty(reason))
            {
                return new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid reason must be supplied" };
            }
            if (userId == 0)
            {
                return new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid user must be supplied" };
            }
            //get history id first...
            int historyId=0;
            using (var reader = readerCreator.CreateDnaDataReader("addtermsfilterupdate"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("notes", reason);
                reader.Execute();
                while(reader.Read())
                {
                    historyId = reader.GetInt32NullAsZero("historyId");
                }
            }
            if(historyId ==0)
            {
                return new Error {Type = "UpdateTermsInDatabase", ErrorMessage = "Unable to get history id"};
            }

            return UpdateTermsWithHistoryId(readerCreator, cacheManager, historyId);
        }

        /// <summary>
        /// Takes a history id and preforms the update...
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="historyId"></param>
        /// <returns></returns>
        public Error UpdateTermsWithHistoryId(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager, int historyId)
        {
            Error error = null;
            foreach(var term in Terms)
            {
                try
                {
                    term.UpdateTermForModClassId(readerCreator, ModClassId, historyId);
                }
                catch(Exception e)
                {
                    if(error == null)
                    {
                        error = new Error {Type = "UpdateTermForModClassId", ErrorMessage = e.Message};
                    }
                    else
                    {//add the new error
                        error.ErrorMessage += Environment.NewLine + e.Message;
                    }
                }
                
            }
            //refresh cache
            GetTermsListByModClassId(readerCreator, cacheManager, ModClassId, true);
            return error;
        }

        /// <summary>
        /// Filters list by a term
        /// </summary>
        /// <param name="termId"></param>
        public void FilterByTermId(int termId)
        {
            Terms = (Terms.Where(x => x.Id == termId)).ToList();
        }
    }
}
