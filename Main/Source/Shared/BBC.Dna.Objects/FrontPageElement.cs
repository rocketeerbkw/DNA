using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "FRONTPAGEELEMENT")]
    public class FrontPageElement
    {
       
        /// <summary>
        /// Creates the topic from the filled in TopicElement object
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public BaseResult CreateFrontPageElement(IDnaDataReaderCreator readerCreator, int siteId, int userId)
        {
            using (var reader = readerCreator.CreateDnaDataReader("createtopicelement"))
            {
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("userid", userId);
                reader.AddParameter("ElementStatus", StatusElement);
                
                reader.Execute();

                if (reader.Read())
                {
                    Elementid = reader.GetInt32NullAsZero("TopicElementID");
                    Editkey = reader.GetGuid("editkey");
                    return new Result("CreateFrontPageElement", "Created Successfully");
                }
                else
                {
                    return new Error("CreateFrontPageElement", "Unable to create new topic element");
                }
            }
            

        }

       /// <summary>
        /// Updates the frontpage elements attributes of the topic
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public BaseResult UpdateFrontPageElements(IDnaDataReaderCreator readerCreator, int userId, int topicId)
        {
            //updatetopicelement	@topicelementid int, @topicid int = NULL, @templatetype int = NULL, @textboxtype int = NULL,
            //@textbordertype int = NULL, @frontpageposition int = NULL, @elementstatus int = NULL, @elementlinkid int = NULL,
            //@title varchar(256) = NULL, @text text = NULL, @imagename varchar(256) = NULL,
            //@applytemplatetoallinsite int = 0, @imagewidth int = NULL, @imageheight int = NULL,
            //@imagealttext varchar(256) = NULL,  @editorid INT, @editkey uniqueidentifier
            using (var reader = readerCreator.CreateDnaDataReader("updatetopicelement"))
            {
                reader.AddParameter("topicelementid", Elementid);
                reader.AddParameter("topicid", topicId);
                reader.AddParameter("templatetype", TemplateElement);
                reader.AddParameter("frontpageposition", Position);
                reader.AddParameter("elementstatus", StatusElement);
                reader.AddParameter("elementlinkid", Elementid);
                reader.AddParameter("title", Title);
                reader.AddParameter("text", Text);
                reader.AddParameter("imagename", ImageName);
                reader.AddParameter("imagealttext", ImageAltText);
                reader.AddParameter("editorid", userId);
                reader.AddParameter("editkey", Editkey);
                reader.Execute();

                if (reader.Read())
                {
                    //SELECT 'ValidID' = 1,'NewEditKey' = @NewEditKey
                    if (reader.GetInt32NullAsZero("ValidID") == 1)
                    {
                        Editkey = reader.GetGuid("NewEditKey");
                    }
                    else
                    {
                        return new Error("UpdateFrontPageElements", "Unable to update - invalid edit key");
                    }

                }
                else
                {
                    return new Error("UpdateFrontPageElements", "Unable to update");
                }
                return new Result("UpdateFrontPageElements", "Update successful");
            }


        }

        /// <summary>
        /// 
        /// </summary>
        public FrontPageElement()
        {
            Status = TopicStatus.Preview;
        }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "ELEMENTID")]
        public int Elementid
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlIgnore]
        public FrontPageTemplate Template { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "TEMPLATE")]
        public int TemplateElement
        {
            get
            {
                if (Template == FrontPageTemplate.UnDefined)
                {
                    if (!String.IsNullOrEmpty(ImageName))
                    {//has image so change type
                        return (int)FrontPageTemplate.ImageAboveText;
                    }
                    return (int)FrontPageTemplate.TextOnly;
                }
                return (int)Template;
            }
            set
            {
                Template = (FrontPageTemplate)value;
                if (Template != FrontPageTemplate.TextOnly && Template != FrontPageTemplate.ImageAboveText)
                {
                    Template = FrontPageTemplate.UnDefined;
                }
            }
        }

        /// <remarks/>
        [XmlElement(Order = 3, ElementName = "POSITION")]
        public int Position { get; set; }

        /// <remarks/>
        [XmlElement(Order = 4, ElementName = "TITLE")]
        public string Title { get; set; }

        /// <remarks/>
        [XmlElement(Order = 5, ElementName = "TEXT")]
        public string Text { get; set; }

        /// <remarks/>
        [XmlElement(Order = 6, ElementName = "IMAGENAME")]
        public string ImageName { get; set; }

        /// <remarks/>
        [XmlElement(Order = 7, ElementName = "IMAGEALTTEXT")]
        public string ImageAltText { get; set; }

        /// <remarks/>
        [XmlElement(Order = 8, ElementName = "EDITKEY")]
        public Guid Editkey { get; set; }

        /// <remarks/>
        [XmlIgnore]
        public TopicStatus Status { get; set; }

        /// <remarks/>
        [XmlElement(Order = 9, ElementName = "STATUS")]
        public int StatusElement 
        {
            get { return (int)Status; }
            set { }
        
        }
        
    }
}
