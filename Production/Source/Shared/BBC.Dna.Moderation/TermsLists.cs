using System.Collections.ObjectModel;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Collections.Generic;
using System.Linq;
using BBC.Dna.Objects;


namespace BBC.Dna.Moderation
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="TERMLISTS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace="", IsNullable=false, ElementName="TERMSLISTS")]
    public class TermsLists : CachableBase<TermsLists>
    {
        public TermsLists()
        {
            Termslist = new List<TermsList>();
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("TERMSLIST", Order = 0)]
        public List<TermsList> Termslist
        {
            get; set;
        }

        /// <summary>
        /// Filters list by a term
        /// </summary>
        /// <param name="termId"></param>
        public void FilterListByTermId(int termId)
        {
            TermsLists tempList = new TermsLists();

            foreach (var termsList in Termslist)
            {
                termsList.FilterByTermId(termId);
                if(termsList.Terms.Count !=0)
                {

                    tempList.Termslist.Add(termsList);
                }
            }
            Termslist = tempList.Termslist;
            
        }

        /// <summary>
        /// Gets all modclass lists of terms for a given list of ids
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="modClassIds"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static TermsLists GetAllTermsLists(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager, 
            int[] modClassIds, bool ignoreCache)
        {
            var termsLists = new TermsLists();
            foreach(var id in modClassIds)
            {
                termsLists.Termslist.Add(TermsList.GetTermsListByModClassId(readerCreator, cacheManager, id, ignoreCache));
            }
            return termsLists;
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

            if (reason == string.Empty)
            {
                return new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid reason must be supplied" };
            }
            if (userId == 0)
            {
                return new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid user must be supplied" };
            }

            Error error = null;
            //get history id first...
            int historyId = 0;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addtermsfilterupdate"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("notes", reason);
                reader.Execute();
                while (reader.Read())
                {
                    historyId = reader.GetInt32NullAsZero("historyId");
                }
            }
            if (historyId == 0)
            {
                return new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Unable to get history id" };
            }

            foreach (var lastError in
                Termslist.Select(termsList => termsList.UpdateTermsWithHistoryId(readerCreator, cacheManager, historyId)).Where(lastError => lastError != null))
            {
                if (error == null)
                {
                    error = lastError;
                }
                else
                {//add the new error
                    error.ErrorMessage += "/r/n" + lastError.ErrorMessage;
                }
            }
            
            return error;
        }

        /// <summary>
        /// stub method...
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return false;
        }
    }
}
