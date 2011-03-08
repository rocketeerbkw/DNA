using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;
using BBC.Dna.Api;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class EditPostPageBuilder : DnaInputComponent
    {
        private readonly Objects.User _viewingUser;
        private int _postId;
        private bool _includeOtherPosts = false;
        private bool _update = false;
        private string _hideReason = string.Empty;//"" = do nothing
        private string _subject = string.Empty;
        private string _text = string.Empty;
        private string _notes = string.Empty;

        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public EditPostPageBuilder(IInputContext context)
            : base(context)
        {
            _viewingUser = InputContext.ViewingUser.ConvertUser();

        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            GetQueryParameters();
            var form = PostEditForm.GetPostEditFormFromPostId(AppContext.ReaderCreator, _viewingUser, _includeOtherPosts, _postId);
            if (form == null)
            {
                AddErrorXml("INVALIDPOSTID", "Invalid post id", null);
                return;
            }

            if (_update)
            {//do updates to post
                try
                {
                    if (form.Hidden == 1)
                    {//only if already hidden
                        if(form.Text != _text || form.Subject != _subject)
                        {//edit text
                            form.EditPost(_viewingUser, _notes, _subject, _text);
                            form.Text = _text;
                            form.Subject = _subject;
                        }
                        else
                        {
                            form.UnHidePost(_viewingUser, _notes);
                        }
                    }
                    else if (!String.IsNullOrEmpty(_hideReason))
                    {//on hide if a reason
                        form.HidePost(_viewingUser, _notes, _hideReason);
                    }
                    else if (form.Text != _text || form.Subject != _subject)
                    {//edit text
                        form.EditPost(_viewingUser, _notes, _subject, _text);
                        form.Text = _text;
                        form.Subject = _subject;
                    }
                }
                catch (ApiException e)
                {
                    AddErrorXml(e.type.ToString(), e.Message, null);
                }

            }
            SerialiseAndAppend(form, String.Empty);
            
        }


        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _postId = InputContext.GetParamIntOrZero("postid", "A post Id");
            _includeOtherPosts = InputContext.DoesParamExist("ListBBCUIDUsers", "List Other Users");
            _update = InputContext.DoesParamExist("Update", "Submit button for update");

            if (InputContext.DoesParamExist("hidePostReason", "Submit button for update"))
            {
                _hideReason = InputContext.GetParamStringOrEmpty("hidePostReason", "reason to hide or -1 for no reason");
            }
            _subject = InputContext.GetParamStringOrEmpty("Subject", "post subject");
            _text = InputContext.GetParamStringOrEmpty("Text", "post Text");
            _notes = InputContext.GetParamStringOrEmpty("notes", "moderators notes");
        }
    }
}