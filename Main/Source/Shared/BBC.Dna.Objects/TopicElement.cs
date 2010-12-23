using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "TOPIC_PAGETOPICLISTTOPIC")]
    public class TopicElement : Topic
    {
        /// <summary>
        /// Gets the topic elements from the current reader.
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        static public TopicElement GetTopicFromReader(IDnaDataReader reader)
        {
            var topicEdit = new TopicElement();
            topicEdit.TopicId = reader.GetInt32NullAsZero("topicid");
            topicEdit.H2G2Id = reader.GetInt32NullAsZero("h2g2ID");
            topicEdit.SiteId = reader.GetInt32NullAsZero("SiteID");
            topicEdit.TopicStatus = (TopicStatus)reader.GetInt32NullAsZero("TopicStatus");
            topicEdit.Title = reader.GetStringNullAsEmpty("TITLE");
            topicEdit.ForumId = reader.GetInt32NullAsZero("ForumID");
            topicEdit.Description = reader.GetStringNullAsEmpty("description");
            topicEdit.Position = reader.GetInt32NullAsZero("position");
            topicEdit.TopicLinkId = reader.GetInt32NullAsZero("topiclinkid");
            topicEdit.Createdby = new TopicCreatedDate
              {
                  CreatedDate = new DateElement(reader.GetDateTime("createddate")),
                  Username = reader.GetStringNullAsEmpty("CreatedByUserName"),
                  Userid = reader.GetInt32NullAsZero("CreatedByUserID")
              };

            topicEdit.Updatedby = new TopicLastUpdated()
            {
                LastUpdated = new DateElement(reader.GetDateTime("LastUpdated")),
                Username = reader.GetStringNullAsEmpty("UpdatedByUserName"),
                Userid = reader.GetInt32NullAsZero("UpdatedByUserID")
            };
            topicEdit.Style = reader.GetInt32NullAsZero("style");
            topicEdit.ForumPostCount = reader.GetInt32NullAsZero("forumpostcount");
            topicEdit.FrontPageElement.Elementid = reader.GetInt32NullAsZero("FP_ElementID");
            topicEdit.FrontPageElement.Position = reader.GetInt32NullAsZero("FP_Position");
            topicEdit.FrontPageElement.Title = reader.GetStringNullAsEmpty("FP_Title");
            topicEdit.FrontPageElement.TemplateElement = reader.GetInt32NullAsZero("FP_Template");
            topicEdit.FrontPageElement.Text = reader.GetStringNullAsEmpty("FP_Text");
            topicEdit.FrontPageElement.ImageName = reader.GetStringNullAsEmpty("FP_ImageName");
            topicEdit.FrontPageElement.ImageAltText = reader.GetStringNullAsEmpty("FP_ImageAltText");
            topicEdit.FrontPageElement.ForumPostCount = reader.GetInt32NullAsZero("forumpostcount");
            topicEdit.Fastmod = reader.GetInt32NullAsZero("fastmod");
            topicEdit.Editkey = reader.GetGuid("editkey");
            topicEdit.FrontPageElement.Editkey = reader.GetGuid("FP_EditKey");

            return topicEdit;
        }

        /// <summary>
        /// Makes the topics and related front page elements active/live
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="siteId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        static public BaseResult MakePreviewTopicsActiveForSiteID(IDnaDataReaderCreator readerCreator, int siteId, int userId)
        {
            using (var reader = readerCreator.CreateDnaDataReader("MakePreviewTopicsActiveForSiteID"))
            {
                reader.AddIntReturnValue();
                reader.AddParameter("isiteid", siteId);
                reader.AddParameter("ieditorid", userId);
                reader.Execute();

                int retVal=-1;
                if (!reader.TryGetIntReturnValue(out retVal) || retVal != 0)
                {
                    return new Error("MakePreviewTopicsActiveForSiteID", "Unable to create new topic, error returned " + retVal.ToString());
                }
            }
            using (var reader = readerCreator.CreateDnaDataReader("MakePreviewTopicElementsActive"))
            {
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("editorid", userId);
                reader.Execute();
            }
            return new Result("MakePreviewTopicsActiveForSiteID", "Successful");
        }

        /// <summary>
        /// Creates the topic from the filled in TopicElement object
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public BaseResult CreateTopic(IDnaDataReaderCreator readerCreator, int siteId, int userId)
        {
            FrontPageElement.CreateFrontPageElement(readerCreator, siteId, userId);

            using (var reader = readerCreator.CreateDnaDataReader("createtopic"))
            {
                //@isiteid INT, @ieditorid INT, @stitle VARCHAR(255), @stext VARCHAR(MAX),
                //@itopicstatus INT, @itopiclinkid INT,  @sextrainfo TEXT, @position INT = NULL
                reader.AddParameter("isiteid", siteId);
                reader.AddParameter("ieditorid", userId);
                reader.AddParameter("stitle", Title);
                reader.AddParameter("stext", Description);
                reader.AddParameter("itopicstatus", (int)TopicStatus.Preview);
                reader.AddParameter("itopiclinkid", TopicLinkId);
                reader.AddParameter("sextrainfo", string.Empty);
                reader.AddParameter("position", Position);
                reader.Execute();

                if (reader.Read())
                {
                    TopicId = reader.GetInt32NullAsZero("itopicid");
                }
                else
                {
                    return new Error("CreateTopic", "Unable to create new topic");
                }
            }

            return FrontPageElement.UpdateFrontPageElements(readerCreator, userId, TopicId);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public BaseResult UpdateTopic(IDnaDataReaderCreator readerCreator, int userId)
        {
            /*edittopic 
	        @itopicid INT, 
	        @ieditorid INT, 
	        @stitle VARCHAR(255), 
	        @stext VARCHAR(MAX),  
	        @istyle INT, 
	        @editkey uniqueidentifier*/
            using (var reader = readerCreator.CreateDnaDataReader("edittopic2"))
            {
                //@isiteid INT, @ieditorid INT, @stitle VARCHAR(255), @stext VARCHAR(MAX),
                //@itopicstatus INT, @itopiclinkid INT,  @sextrainfo TEXT, @position INT = NULL
                reader.AddParameter("itopicid", TopicId);
                reader.AddParameter("ieditorid", userId);
                reader.AddParameter("stitle", Title);
                reader.AddParameter("stext", Description);
                reader.AddParameter("istyle", Style);
                reader.AddParameter("position", Position);
                reader.AddParameter("editkey", Editkey);
                reader.Execute();

                if(reader.Read())
                {
                    //SELECT 'ValidEditKey' = 2, 'NewEditKey' = EditKey FROM dbo.topics WITH(NOLOCK) WHERE topicID = @itopicid
                    if (reader.GetInt32NullAsZero("ValidEditKey") == 2)
                    {
                        Editkey = reader.GetGuid("NewEditKey");
                    }
                    else
                    {
                        return new Error("UpdateTopic", "Unable to update - invalid edit key");
                    }

                }
                else
                {
                    return new Error("UpdateTopic", "Unable to update");
                }
            }

            return FrontPageElement.UpdateFrontPageElements(readerCreator, userId, TopicId);

        }

        /// <summary>
        /// 
        /// </summary>
        public TopicElement()
        {
            FrontPageElement = new FrontPageElement();
        }

        /// <remarks/>
        [XmlElement(Order = 8, ElementName = "FASTMOD")]
        public int Fastmod
        {
            get; set;
        }

        [XmlIgnore]
        public string Description
        {
            get; set;
        }
        
        /// <remarks/>
        [XmlElement(Order = 9, ElementName = "DESCRIPTION")]
        public XmlElement DescriptionElement
        {
            get { 
                if(!String.IsNullOrEmpty(Description))
                {
                    try
                    {
                        return GuideEntry.CreateGuideEntry(Description, 0, GuideEntryStyle.GuideML, 1);
                    }
                    catch{}
                }
                return GuideEntry.CreateGuideEntry("<GUIDE><BODY></BODY></GUIDE>", 0, GuideEntryStyle.GuideML, 1);
            }
            set {
                if (value != null && value.SelectSingleNode("/BODY") != null)
                {
                    Description = value.SelectSingleNode("/BODY").InnerXml;
                }
            }
        }

        /// <remarks/>
        [XmlElement(Order = 10, ElementName = "POSITION")]
        public int Position { get; set; }

        /// <remarks/>
        [XmlElement(Order = 11, ElementName = "CREATEDBY")]
        public TopicCreatedDate Createdby { get; set; }

        /// <remarks/>
        [XmlElement(Order = 12, ElementName = "UPDATEDBY")]
        public TopicLastUpdated Updatedby { get; set; }

        /// <remarks/>
        [XmlElement(Order = 13, ElementName = "STYLE")]
        public int Style
        { get; set;
        }

        /// <remarks/>
        [XmlElement(Order = 14, ElementName = "EDITKEY")]
        public Guid Editkey { get; set; }

        /// <remarks/>
        [XmlElement(Order = 15, ElementName = "FRONTPAGEELEMENT")]
        public FrontPageElement FrontPageElement { get; set; }
    }

    public enum FrontPageTemplate
    {
        UnDefined=0,
        TextOnly =1,
        ImageAboveText=2
    }
}