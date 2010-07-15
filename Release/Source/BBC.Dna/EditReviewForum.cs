using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Sites;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the EditReviewForum object
    /// </summary>
    public class EditReviewForum : DnaInputComponent
    {
        private const string _docDnaID = @"Review Forum ID to update / edit.";

        private const string _docDnaMode = @"Mode.";
        private const string _docDnaAction = @"Action to take.";

        private const string _docDnaName = @"Entered Name";
        private const string _docDnaURL = @"Entered URL";
        private const string _docDnaRecommend = @"Whether to recommend";
        private const string _docDnaIncubate = @"Incubate time";

        private string _editReviewForumMode = "VIEW";

        /// <summary>
        /// Accessor for EditReviewForumMode
        /// </summary>
        public string EditReviewForumMode
        {
            get { return _editReviewForumMode; }
            set { _editReviewForumMode = value; }
        }

        /// <summary>
        /// Default constructor for the EditReviewForum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public EditReviewForum(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            TryCreateEditReviewForumBuilderXML();

        }
    
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        private void TryCreateEditReviewForumBuilderXML()
        {
            int ID = 0;

            string action = "Edit";

            string name = String.Empty;
            string url = String.Empty;
            bool recommendable = false;
            int incubateTime = 0;

            XmlElement editReviewForm = AddElementTag(RootElement, "EDITREFVIEWFORM");
            EditReviewForumForm editReviewForumForm = new EditReviewForumForm(InputContext);

            EditReviewForumMode = InputContext.GetParamStringOrEmpty("mode", _docDnaMode);

            if (InputContext.DoesParamExist("action", _docDnaAction))
            {
                action = InputContext.GetParamStringOrEmpty("action", _docDnaAction);
            }

            if (action == "Update")
            {
                if (InputContext.DoesParamExist("ID", _docDnaID))
                {
                    ID = InputContext.GetParamIntOrZero("ID", _docDnaID);
                }
                else
                {
                    AddErrorXml("BADPARAM", "Edit Review Forum - The parameters are invalid, no Review Forum ID passed in.", editReviewForm);
                    return;
                }

                name = InputContext.GetParamStringOrEmpty("name", _docDnaAction);
                url = InputContext.GetParamStringOrEmpty("url", _docDnaAction);

                if (InputContext.DoesParamExist("recommend", _docDnaRecommend))
                {
                    int recommend = InputContext.GetParamIntOrZero("recommend", _docDnaRecommend);
                    if (recommend == 1)
                    {
                        recommendable = true;
                        incubateTime = InputContext.GetParamIntOrZero("incubate", _docDnaIncubate);
                    }
                    else
                    {
                        recommendable = false;
                    }
                    if (!editReviewForumForm.RequestUpdate(ID, name, url, recommendable, incubateTime, InputContext.CurrentSite.SiteID))
                    {
                        AddErrorXml("UPDATE", "Edit Review Forum - Error occured while updating.", editReviewForm);
                        return;
                    }
                    //sitedata needs to be update for updates
                    AppContext.TheAppContext.TheSiteList.SendSignal(InputContext.CurrentSite.SiteID);
                }
                else
                {
                    AddErrorXml("BADPARAM", "Edit Review Forum - The parameters are invalid, no Recommend parameter passed in.", editReviewForm);
                    return;
                }
            }
            //we should have a blank form and an add button
            else if (action == "AddNew")
            {
                AddElementTag(editReviewForm, "BLANKFORM");
                return;
            }
            else if (action == "DoAddNew")
            {
                name = InputContext.GetParamStringOrEmpty("name", _docDnaAction);
                url = InputContext.GetParamStringOrEmpty("url", _docDnaAction);

                if (InputContext.DoesParamExist("recommend", _docDnaRecommend))
                {
                    int recommend = InputContext.GetParamIntOrZero("recommend", _docDnaRecommend);
                    if (recommend == 1)
                    {
                        recommendable = true;
                        incubateTime = InputContext.GetParamIntOrZero("incubate", _docDnaIncubate);
                    }
                    else
                    {
                        recommendable = false;
                    }
                    if (!editReviewForumForm.DoAddNew(name, url, recommendable, incubateTime, InputContext.CurrentSite.SiteID, InputContext.ViewingUser.UserID))
                    {
                        AddErrorXml("UPDATE", "Edit Review Forum - Error occured while adding.", editReviewForm);
                        return;
                    }
                    //sitedata needs to be update for additions
                    AppContext.TheAppContext.TheSiteList.SendSignal(InputContext.CurrentSite.SiteID);
                }
                else
                {
                    AddErrorXml("BADPARAM", "Edit Review Forum - The parameters are invalid, no Recommend parameter passed in.", editReviewForm);
                    return;
                }
            }
            else //action == "edit"   ---- view???
            {
                if (InputContext.DoesParamExist("ID", _docDnaID))
                {
                    ID = InputContext.GetParamIntOrZero("ID", _docDnaID);
                }
                else
                {
                    AddErrorXml("BADPARAM", "Edit Review Forum - The parameters are invalid, no Review Forum ID passed in.", editReviewForm);
                    return;
                }
                if (!editReviewForumForm.CreateFromDB(ID, InputContext.CurrentSite.SiteID))
                {
                    AddErrorXml("VIEW", "Edit Review Forum - Error occured while creating from database.", editReviewForm);
                    return;
                }
            }
            AddInside(editReviewForm, editReviewForumForm);
        }
    }
}