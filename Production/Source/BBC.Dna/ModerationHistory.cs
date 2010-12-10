using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Class for creating Moderation history Xml.
    /// </summary>
    public class ModerationHistory : DnaInputComponent
    {
         /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerationHistory(IInputContext context)
            : base(context)
        {
        }

         /// <summary>
        /// 
        /// </summary>
        public override void ProcessRequest()
        {
            string reference = InputContext.GetParamStringOrEmpty("reference", "reference");
            int postId = InputContext.GetParamIntOrZero("postid", "postid");
            int h2g2Id = InputContext.GetParamIntOrZero("h2g2id", "h2g2id");
            string exLinkUrl = InputContext.GetParamStringOrEmpty("exlinkurl", "exlinkurl");

            if ( reference != String.Empty )
            {
                ParseModReference(reference, out postId, out h2g2Id);
            }
            
            if ( h2g2Id > 0 )
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("FetchArticleModerationHistory"))
                {
                    reader.AddParameter("h2g2id", h2g2Id);
                    reader.Execute();
                    GenerateXml(reader, h2g2Id, 0, String.Empty);
                }
            }
            else if ( postId > 0 )
            {
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("FetchPostModerationHistory"))
                {
                    reader.AddParameter("postid", postId);
                    reader.Execute();
                    GenerateXml(reader, 0, postId, String.Empty);
                }
            }
            else if ( exLinkUrl != String.Empty )
            {

                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("FetchExLinkModerationHistory"))
                {
                    Uri source;
                    if (Uri.TryCreate(exLinkUrl, UriKind.Absolute, out source))
                    {
                        reader.AddParameter("url", source.ToString() );
                        reader.Execute();
                        GenerateXml(reader, 0, 0, new Uri(exLinkUrl).ToString());
                    }
                }

                // Get the Modertion events history for this url too.
                GenerateExLinkEventHistory(exLinkUrl);
            }
        }

        private void GenerateXml(IDnaDataReader reader, int h2g2Id, int postId, string exLinkUrl)
        {
            XmlElement modHistory = AddElementTag(RootElement, "MODERATION-HISTORY");
            reader.Read();

            if (h2g2Id > 0)
                AddAttribute(modHistory, "H2G2ID", h2g2Id);
            else if (postId > 0)
            {
                AddAttribute(modHistory, "POSTID", postId);
                if ( reader.HasRows )
                {
                    AddAttribute(modHistory, "FORUMID", reader.GetInt32NullAsZero("forumid") );
                    AddAttribute(modHistory, "THREADID", reader.GetInt32NullAsZero("threadid") );
                }
            }
            else if (exLinkUrl != String.Empty)
                AddAttribute(modHistory, "EXLINKURL", exLinkUrl );

            if (reader.HasRows)
            {
                int rowCount = 0;
                do
                {
                    if (rowCount == 0)
                    {
                        AddXmlTextTag(modHistory, "SUBJECT", reader.GetStringNullAsEmpty("subject"));

                        if (reader.DoesFieldExist("authoruserid") && !reader.IsDBNull("authoruserid"))
                        {
                            XmlElement editorNode = AddElementTag(modHistory, "EDITOR");
                            User editor = new User(InputContext);
                            editor.AddPrefixedUserXMLBlock(reader, reader.GetInt32NullAsZero("authoruserid"), "Author", editorNode);
                        }
                    }

                    XmlElement moderation = AddElementTag(modHistory, "MODERATION");
                    AddAttribute(moderation, "MODID", reader.GetInt32NullAsZero("modid"));
                    AddIntElement(moderation, "STATUS", reader.GetInt32NullAsZero("status"));

                    User user = new User(InputContext);

                    if ( !reader.IsDBNull("lockedbyuserid") )
                    {
                        XmlElement locked = AddElementTag(moderation, "LOCKED-BY");
                        user.AddPrefixedUserXMLBlock(reader, reader.GetInt32NullAsZero("LockedBy"), "lockedby", locked);
                    }

                    if (!reader.IsDBNull("referredbyuserid"))
                    {
                        XmlElement referred = AddElementTag(moderation, "REFERRED-BY");
                        user.AddPrefixedUserXMLBlock(reader, reader.GetInt32NullAsZero("referredbyuserid"), "referredby", referred);
                    }

                    XmlElement complaint = AddElementTag(moderation, "COMPLAINT");
                    AddTextElement(complaint, "COMPLAINT-TEXT", reader.GetStringNullAsEmpty("complainttext"));

                    if (reader.DoesFieldExist("complainantuserid") && !reader.IsDBNull("complainantuserid"))
                    {
                        user.AddPrefixedUserXMLBlock(reader, reader.GetInt32NullAsZero("complainantuserid"), "complainant", complaint);
                    }

                    AddTextElement(complaint, "IPADDRESS", reader.GetStringNullAsEmpty("ipaddress"));
                    AddTextElement(complaint, "BBCUID", reader.GetGuidAsStringOrEmpty("bbcuid").ToString());
                    AddTextElement(complaint, "EMAIL-ADDRESS", reader.GetStringNullAsEmpty("correspondenceemail"));

                    AddTextElement(moderation, "NOTES", HtmlUtils.ReplaceCRsWithBRs(reader.GetStringNullAsEmpty("notes")));

                    AddDateXml(reader.GetDateTime("datequeued"), moderation, "DATE-QUEUED");
                    if (!reader.IsDBNull("datelocked"))
                    {
                        AddDateXml(reader.GetDateTime("datelocked"), moderation, "DATE-LOCKED");
                    }

                    if (!reader.IsDBNull("datereferred"))
                    {
                        AddDateXml(reader.GetDateTime("datereferred"), moderation, "DATE-REFERRED");
                    }

                    if (!reader.IsDBNull("datecompleted"))
                    {
                        AddDateXml(reader.GetDateTime("datecompleted"), moderation, "DATE-COMPLETED");
                    }

                    ++rowCount;
                }
                while (reader.Read());
            }
        }

        /// <summary>
        /// Generate Event history XML for the given external link.
        /// </summary>
        /// <param name="url"></param>
        private void GenerateExLinkEventHistory( string url )
        {
            XmlElement eventHistory = AddElementTag(RootElement, "EXLINKMODEVENTHISTORY");
            AddAttribute(eventHistory, "EXLINKURL", url);
            
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("fetchexlinkmoderationeventhistory") )
            {
                reader.AddParameter("url", url);
                reader.Execute();

                XmlElement modEventList = null;
                int modId = -1;
                while (reader.Read())
                {
                    if (reader.GetInt32NullAsZero("modid") != modId)
                    {
                        modId = reader.GetInt32NullAsZero("modId");
                        modEventList = AddElementTag(eventHistory, "EXLINKMODEVENT-LIST");
                        AddAttribute(modEventList, "MODID", modId);
                        AddTextElement(modEventList, "EXLINKCALLBACKURL", reader.GetStringNullAsEmpty("callbackuri"));
                    }

                    XmlElement modEvent = AddElementTag(modEventList, "EXLINKMODEVENT");
                    AddAttribute(modEvent, "REASONID", reader.GetInt32NullAsZero("reasonid"));
                    AddTextElement(modEvent, "NOTES", reader.GetStringNullAsEmpty("notes"));
                    AddDateXml(reader.GetDateTime("timestamp"), modEvent, "TIMESTAMP");
                }
            }
        }

        private bool ParseModReference(string reference, out int postId, out int h2g2Id)
        {
            h2g2Id = 0;
            postId = 0;

            if (reference.StartsWith("A"))
            {
                int modId = Convert.ToInt32(reference.Substring(1));
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetArticleModDetailsFromModID"))
                {
                    reader.AddParameter("modid", modId);
                    reader.Execute();
                    if (reader.Read())
                    {
                        h2g2Id = reader.GetInt32NullAsZero("h2g2id");
                    }
                }
                return h2g2Id > 0;
            }
            else if (reference.StartsWith("P"))
            {
                int modId = Convert.ToInt32(reference.Substring(1));
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetThreadModDetailsFromModID"))
                {
                    reader.AddParameter("modid", modId);
                    reader.Execute();
                    if (reader.Read())
                    {
                        postId = reader.GetInt32NullAsZero("postid");
                    }
                }
                return postId > 0;
            }

            return false;
        }
    }
}
