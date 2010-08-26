using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Comment CommentBoxForum List - A derived DnaComponent object
    /// </summary>
    public class CommentForumList : DnaInputComponent
    {
        private const string _docDnaShow = @"The number of comment forums to show.";
        private const string _docDnaSkip = "The number of comment forums to skip";

        /// <summary>
        /// Default constructor for the CommentForumList component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public CommentForumList(IInputContext context) : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            TryUpdateCommentForum();

            TryGetCommentForumList();

            RootElement.AppendChild(ImportNode(InputContext.ViewingUser.GetSitesThisUserIsEditorOfXML()));
        }
         /// <summary>
        /// Method called to update the statuses of any of the comment forums. 
        /// </summary>
        private bool TryUpdateCommentForum()
        {
            string action = String.Empty;
            if (InputContext.TryGetParamString("dnaaction", ref action, "Action to take on this request. 'update' is the only action currently recognised"))
            {
                if (action == "update")
                {
                    string newCloseDateParam = String.Empty;
                    object newCloseDate = null;
                    int newModStatus = 0;
                    int newCanWrite = 0;
                    string uid = String.Empty;

                    string docUid = "The uid of the given comment forum.";
                    bool uidExists = false;
                    uidExists = InputContext.DoesParamExist("dnauid", docUid);
                    if (uidExists)
                    {
                        InputContext.TryGetParamString("dnauid", ref uid, docUid);
                        if (uid == String.Empty)
                        {
                            return AddErrorXml("invalidparameters", "blank unique id provided", null);
                        }
                    }
                    else
                    {
                        //Cannot continue.
                        return AddErrorXml("invalidparameters", "No unique id provided", null);
                    }

                    string docNewForumCloseDate = "The new CommentBoxForum Close Date for the given comment forum.";
                    bool newNewForumCloseDateExists = false;
                    newNewForumCloseDateExists = InputContext.DoesParamExist("dnanewforumclosedate", docNewForumCloseDate);
                    if (newNewForumCloseDateExists)
                    {
                        InputContext.TryGetParamString("dnanewforumclosedate", ref newCloseDateParam, docNewForumCloseDate);
                        // Try to parse the date
                        try
                        {
                            // Set the closing date from the value - The format of the date is YYYYMMDD.
                            newCloseDate = new DateTime(Convert.ToInt32(newCloseDateParam.Substring(0, 4)), Convert.ToInt32(newCloseDateParam.Substring(4, 2).TrimStart('0')), Convert.ToInt32(newCloseDateParam.Substring(6, 2).TrimStart('0')));
                        }
                        catch (Exception ex)
                        {
                            return AddErrorXml("invalidparameters", "Invalid date format given for forumclosedate. " + ex.Message, null);
                        }
                    }

                    string docNewModStatus = "The new Moderation Status for the given comment forum.";
                    bool newModStatusExists = false;
                    newModStatusExists = InputContext.DoesParamExist("dnanewmodstatus", docNewModStatus);
                    if (newModStatusExists)
                    {
                        string dnaNewModStatus = InputContext.GetParamStringOrEmpty("dnanewmodstatus", docNewModStatus);
                        if (dnaNewModStatus == "reactive")
                        {
                            newModStatus = 1;
                        }
                        else if (dnaNewModStatus == "postmod")
                        {
                            newModStatus = 2;
                        }
                        else if (dnaNewModStatus == "premod")
                        {
                            newModStatus = 3;
                        }
                        else
                        {
                            return AddErrorXml("invalidparameters", "Illegal New Moderation Status setting (" + dnaNewModStatus + ")", null);
                        }
                    }
                    int fastModStatus = 0;
                    bool newFastModStatusExists = InputContext.DoesParamExist("dnafastmod", "");
                    if (newFastModStatusExists)
                    {
                        var fastModVal = InputContext.GetParamStringOrEmpty("dnafastmod", "");
                        if (fastModVal.ToUpper() == "ENABLED")
                        {
                            fastModStatus = 1;
                        }
                        else
                        {
                            fastModStatus = 0;
                        }
                    }

                    string docNewCanWrite = "The new Open Close Status for the given comment forum.";
                    bool newNewCanWriteExists = false;
                    newNewCanWriteExists = InputContext.DoesParamExist("dnanewcanwrite", docNewCanWrite);
                    if (newNewCanWriteExists)
                    {
                        newCanWrite = InputContext.GetParamIntOrZero("dnanewcanwrite", docNewCanWrite);
                    }

                    if (newNewForumCloseDateExists || newModStatusExists || newNewCanWriteExists || newFastModStatusExists)
                    {

                        using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updatecommentforumstatus"))
                        {
                            dataReader.AddParameter("uid", uid);

                            if (newNewForumCloseDateExists && newCloseDate != null)
                            {
                                dataReader.AddParameter("forumclosedate", newCloseDate);
                            }
                            else
                            {
                                dataReader.AddParameter("forumclosedate", DBNull.Value);
                            }

                            if (newModStatusExists)
                            {
                                dataReader.AddParameter("modstatus", newModStatus);
                            }
                            else
                            {
                                dataReader.AddParameter("modstatus", DBNull.Value);
                            }
                            if (newNewCanWriteExists)
                            {
                                dataReader.AddParameter("canwrite", newCanWrite);
                            }
                            else
                            {
                                dataReader.AddParameter("canwrite", DBNull.Value);
                            }
                            if (newFastModStatusExists)
                            {
                                dataReader.AddParameter("fastmod", fastModStatus);
                            }
                            else
                            {
                                dataReader.AddParameter("fastmod", DBNull.Value);
                            }
                            dataReader.Execute();
                        }
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// Method called to try and get the comment forum list. 
        /// </summary>
        private void TryGetCommentForumList()
        {
            CommentForumListBuilder commentForumListBuilder = new CommentForumListBuilder(InputContext);
            commentForumListBuilder.TryGetCommentForumList();
            //RootElement.AppendChild(ImportNode(commentForumListBuilder.RootElement.FirstChild));
            AddInside(RootElement, commentForumListBuilder);
        }
    }
}
