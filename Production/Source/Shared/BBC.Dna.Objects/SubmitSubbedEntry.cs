using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;
using BBC.Dna.Sites;
using System.Data;
using System.Data.SqlClient;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Objects
{
    [GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "SUBMIT-SUBBED-ENTRY")]
    [DataContract(Name = "submitSubbedEntry")]
    public partial class SubmitSubbedEntry  
    {
        #region Properties

        public SubmitSubbedEntry()
        {
        }

        #endregion

        public static SubmitSubbedEntry ReturnArticle(IDnaDataReaderCreator readerCreator, 
                BBC.Dna.Sites.ISite site,
                int userId,
                bool isEditor,
                int articleId,
                string comments)
        {
            SubmitSubbedEntry submitSubbedEntryResponse = new SubmitSubbedEntry();

            CreateFromh2g2ID(readerCreator, userId, isEditor, articleId, comments);

            int entryId = articleId / 10;

            bool invalidEntry = false;
            bool userNotSub = false;
            bool okay = false;
            int recommendationStatus = 0;
            DateTime dateReturned = DateTime.MinValue;

            //Submit the article
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("SubmitReturnedSubbedEntry"))
            {
                reader.AddParameter("UserID", userId);
                reader.AddParameter("EntryID", entryId);
                if (comments != String.Empty)
                {
                    reader.AddParameter("Comments", comments);
                }

                reader.Execute();
                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {
                    invalidEntry = reader.GetBoolean("InvalidEntry");
                    userNotSub = reader.GetBoolean("UserNotSub");
                    okay = reader.GetBoolean("Success");
                    recommendationStatus = reader.GetInt32NullAsZero("RecommendationStatus");
                    if (reader.DoesFieldExist("DateReturned") && !reader.IsDBNull("DateReturned"))
                    {
                        dateReturned = reader.GetDateTime("DateReturned");
                    }
                }
            }
            if (invalidEntry)
            {
                throw new ApiException("Entry is not in the list of accepted scout recommendations", ErrorType.NotAuthorized);
            }
            else if (userNotSub)
            {
                throw new ApiException("You are not the Sub Editor for this Entry", ErrorType.NotAuthorized);
            }
            else if (recommendationStatus != 2)
            {
                string message = String.Empty;
                switch (recommendationStatus)
                {
                    case 0 :
                    {
                        throw new ApiException("Recommendation has no status", ErrorType.WrongStatus);
                    }
                    case 1 :                    
                    {
                        throw new ApiException("Recommendation has not yet been allocated to a Sub Editor", ErrorType.WrongStatus);
                    }
                    case 3 : 
                    {
                        throw new ApiException("Recommendation has already been submitted on " + dateReturned.ToShortDateString(), ErrorType.WrongStatus);
                    }
                    default: 
                    {
                        throw new ApiException("Recommendation has wrong status", ErrorType.WrongStatus);
                    }
                }
            }
            // something unspecified went wrong
            else if (!okay)
            {
                throw new ApiException("An unspecified error occurred whilst processing the request.", ErrorType.Unknown);
            }

            return submitSubbedEntryResponse;
        }

        private static void CreateFromh2g2ID(IDnaDataReaderCreator readerCreator, int userId, bool isEditor, int articleId, string comments)
        {
            if (!Article.ValidateH2G2ID(articleId))
            {
                throw new ApiException("H2G2ID invalid.", ErrorType.InvalidH2G2Id);
            }

            // now we've checked that the h2g2ID is valid get the entry ID from it
            int entryId = articleId / 10;

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("FetchArticleSummary"))
            {
                reader.AddParameter("EntryID", entryId);
                reader.Execute();

                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {
                    int h2g2ID = reader.GetInt32NullAsZero("h2g2ID");
                    string subject = reader.GetStringNullAsEmpty("Subject");
                    string editorName = reader.GetStringNullAsEmpty("EditorName");
                    int editorID = reader.GetInt32NullAsZero("EditorID");
                    int status = reader.GetInt32NullAsZero("Status");
                    bool isSubCopy = reader.GetBoolean("IsSubCopy");
                    bool hasSubCopy = reader.GetBoolean("HasSubCopy");
                    int subCopyID = reader.GetInt32NullAsZero("SubCopyID");
                    int recommendedByScoutID = reader.GetInt32NullAsZero("RecommendedByScoutID");
                    string recommendedByUserName = reader.GetStringNullAsEmpty("RecommendedByUserName");

                    // check that this entry is a subs copy of a recommended entry
                    if (!isSubCopy)
                    {
                        throw new ApiException("Not Sub-editors draft copy for Edited Entry", ErrorType.WrongStatus);
                    }
                }
            }
        }
    }
}
