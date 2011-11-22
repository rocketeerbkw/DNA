using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Data;
using System.Collections.Generic;
using BBC.Dna.Common;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;

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
            Terms = new List<TermDetails>();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="modClassId"></param>
        public TermsList(int modClassId)
        {
            ModClassId = modClassId;
            Terms = new List<TermDetails>();
        }

        /// <summary>
        /// Overloaded constructor if details from ThreadMod
        /// </summary>
        /// <param name="modClassId"></param>
        public TermsList(int modId, bool isFromThreadMod)
        {
            this.ModClassId = modId;
            Terms = new List<TermDetails>();
        }

        /// <summary>
        /// Overloaded constructor for Forum terms
        /// </summary>
        /// <param name="forumId"></param>
        public TermsList(int forumId, bool isFromThreadMod, bool isForForum)
        {
            this.ForumId = forumId;
            Terms = new List<TermDetails>();
        }


        #region Properties
        /// <remarks/>
        [XmlElementAttribute("TERMDETAILS", Order = 0)]
        public List<TermDetails> Terms { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "MODCLASSID")]
        public int ModClassId { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "FORUMID")]
        public int ForumId { get; set; }
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
                while (reader.Read())
                {
                    var termDetails = new TermDetails

                    {
                        Id = reader.GetInt32NullAsZero("TermID"),
                        Value = reader.GetStringNullAsEmpty("Term"),
                        Reason = reader.GetStringNullAsEmpty("Reason"),
                        UpdatedDate = new DateElement(reader.GetDateTime("UpdatedDate")),
                        UserID = reader.GetInt32NullAsZero("UserID"),
                        UserName = reader.GetStringNullAsEmpty("UserName"),
                        Action = (TermAction)reader.GetByteNullAsZero("actionId")
                    };
                    termsList.Terms.Add(termDetails);
                }
            }

            return termsList;
        }

        /// <summary>
        /// Get the terms list from the ThreadMod table
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="modClassId"></param>
        /// <param name="isFromThreadMod"></param>
        /// <returns></returns>
        public static TermsList GetTermsListByThreadModIdFromThreadModDB(IDnaDataReaderCreator readerCreator,
            int modId, bool isFromThreadMod)
        {
            var termsList = new TermsList(modId, isFromThreadMod);

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("gettermsbymodidfromthreadmod"))
            {
                reader.AddParameter("modId", modId);
                reader.Execute();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        var termDetails = new TermDetails
                        {
                            Id = reader.GetInt32NullAsZero("TermID"),
                            Value = reader.GetStringNullAsEmpty("Term"),
                            Reason = reader.GetStringNullAsEmpty("Reason"),
                            UpdatedDate = new DateElement(reader.GetDateTime("UpdatedDate")),
                            UserID = reader.GetInt32NullAsZero("UserID"),
                            UserName = reader.GetStringNullAsEmpty("UserName"),
                            FromModClass = reader.GetBoolean("FromModClass")
                        };

                        termsList.Terms.Add(termDetails);
                    }
                }
            }

            return termsList;
        }

       

        /// <summary>
        /// Checks the cache and gets the terms from the cache else calls the db method to fetch the terms
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="forumId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static TermsList GetTermsListByForumId(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager,
            int forumId, bool ignoreCache)
        {
            var termsList = new TermsList(forumId, false, true);
            if (!ignoreCache)
            {
                termsList = (TermsList)cacheManager.GetData(termsList.GetCacheKey(forumId));
                if (termsList != null)
                {
                    return termsList;
                }

            }

            termsList = GetTermsListByForumIdFromDB(readerCreator, forumId);
            cacheManager.Add(termsList.GetCacheKey(forumId), termsList);

            return termsList;
        }

        /// <summary>
        /// Gets the terms list from the db...
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="modClassId"></param>
        /// <returns></returns>
        public static TermsList GetTermsListByForumIdFromDB(IDnaDataReaderCreator readerCreator,
            int forumId)
        {
            var termsList = new TermsList(forumId, false, true);

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("gettermsbyforumid"))
            {
                reader.AddParameter("forumId", forumId);
                reader.Execute();
                while (reader.Read())
                {
                    var term = new TermDetails
                    {
                        Id = reader.GetInt32NullAsZero("termId"),
                        Action = (TermAction)reader.GetByteNullAsZero("actionId"),
                        Value = reader.GetStringNullAsEmpty("term"),
                        Reason = reader.GetStringNullAsEmpty("Reason"),
                        UpdatedDate = new DateElement(reader.GetDateTime("UpdatedDate")),
                        UserID = reader.GetInt32NullAsZero("UserID"),
                        UserName = reader.GetStringNullAsEmpty("UserName"),
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
            return false;
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
            string reason, int userId, bool isForModClass)
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

            return UpdateTermsWithHistoryId(readerCreator, cacheManager, historyId, isForModClass);
        }

        /// <summary>
        /// Takes a history id and preforms the update...
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="historyId"></param>
        /// <returns></returns>
        public Error UpdateTermsWithHistoryId(IDnaDataReaderCreator readerCreator, ICacheManager cacheManager, int historyId, bool isForModClass)
        {
            Error error = null;
            foreach (var term in Terms)
            {
                if (true == isForModClass)
                {
                    try
                    {
                        term.UpdateTermForModClassId(readerCreator, ModClassId, historyId);
                    }
                    catch (Exception e)
                    {
                        if (error == null)
                        {
                            error = new Error { Type = "UpdateTermForModClassId", ErrorMessage = e.Message };
                        }
                        else
                        {//add the new error
                            error.ErrorMessage += Environment.NewLine + e.Message;
                        }
                    }
                }
                else
                {
                    try
                    {
                        term.UpdateTermForForumId(readerCreator, ForumId, historyId);
                    }
                    catch (Exception e)
                    {
                        if (error == null)
                        {
                            error = new Error { Type = "UpdateTermForForumId", ErrorMessage = e.Message };
                        }
                        else
                        {//add the new error
                            error.ErrorMessage += Environment.NewLine + e.Message;
                        }
                    }
                }

            }
            //refresh cache
            if (true == isForModClass)
            {
                GetTermsListByModClassId(readerCreator, cacheManager, ModClassId, true);
            }
            else
            {
                GetTermsListByForumId(readerCreator, cacheManager, ForumId, true);
            }
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

        /// <summary>
        /// Sorts list by reputation ascending/descending
        /// </summary>
        /// <param name="sortBy"></param>
        /// <param name="sortDirection"></param>
        public void SortList(SortBy sortBy, SortDirection sortDirection)
        {
            switch (sortBy)
            {
                case SortBy.Created:
                    if (sortDirection == SortDirection.Ascending)
                    {
                        Terms = Terms.OrderBy(x => x.UpdatedDate.Date.DateTime).ToList<TermDetails>();
                    }
                    else
                    {
                        Terms = Terms.OrderByDescending(x => x.UpdatedDate.Date.DateTime).ToList<TermDetails>();
                    }
                    break;

                case SortBy.Term:
                    if (sortDirection == SortDirection.Ascending)
                    {
                        Terms = Terms.OrderBy(x => x.Value).ToList<TermDetails>();
                    }
                    else
                    {
                        Terms = Terms.OrderByDescending(x => x.Value).ToList<TermDetails>();
                    }
                    break;

            }
        }
    }
}
