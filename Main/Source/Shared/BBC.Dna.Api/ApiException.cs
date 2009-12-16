using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;

namespace BBC.Dna.Api
{
    public class ApiException : DnaException
    {
        public ErrorType type = ErrorType.Unknown;

        /// <summary>
        /// 
        /// </summary>
        public ApiException()
            : base()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public ApiException(string message)
            : base(message)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public ApiException(string message, ErrorType errorType)
            : base(message)
        {
            type = errorType;
        }

        /// <summary>
        /// 
        /// </summary>
        public ApiException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        public static ApiException GetError(ErrorType type)
        {
            return GetError(type, null);
        }
        public static ApiException GetError(ErrorType type, Exception innerException)
        {
            ApiException _error = new ApiException() { type = ErrorType.Unknown };
            switch (type)
            {
                case ErrorType.MissingUserCredentials: _error = new ApiException("Missing user credentials.", innerException);break;
                case ErrorType.FailedTermsAndConditions: _error = new ApiException("Failed terms and conditions.", innerException); break;
                case ErrorType.MissingEditorCredentials: _error = new ApiException("Missing editor credentials.", innerException); break;
                case ErrorType.UserIsBanned: _error = new ApiException("User is banned.", innerException); break;
                case ErrorType.SiteIsClosed: _error = new ApiException("Site is closed.", innerException); break;
                case ErrorType.EmptyText: _error = new ApiException("Text is null or blank.", innerException); break;
                case ErrorType.ExceededTextLimit: _error = new ApiException("Text exceeds maximum character limit.", innerException); break;
                case ErrorType.XmlFailedParse: _error = new ApiException("The xml provided failed to parse correctly.", innerException); break;
                case ErrorType.ProfanityFoundInText: _error = new ApiException("Profanity filter triggered error.", innerException); break;
                case ErrorType.ForumUnknown: _error = new ApiException("Forum is unknown and cannot be added to.", innerException); break;
                case ErrorType.ForumClosed: _error = new ApiException("Forum is closed and cannot be added to.", innerException); break;
                case ErrorType.ForumReadOnly: _error = new ApiException("Forum is readonly and cannot be added to.", innerException); break;
                case ErrorType.InvalidForumUid: _error = new ApiException("Forum uid is empty, null or exceeds 255 characters.", innerException); break;
                case ErrorType.InvalidForumParentUri: _error = new ApiException("Forum parent uri is empty, null or not from a bbc.co.uk domain.", innerException); break;
                case ErrorType.InvalidForumTitle: _error = new ApiException("Forum title uri is empty or null.", innerException); break;
                case ErrorType.UnknownSite: _error = new ApiException("Site reference is unknown.", innerException); break;
                case ErrorType.MultipleRatingByUser: _error = new ApiException("User has already rated this content.", innerException); break;
                case ErrorType.RatingExceedsMaximumAllowed: _error = new ApiException("Rating exceeds allowed maximum.", innerException); break;
                case ErrorType.InvalidProcessPreModState: _error = new ApiException("Ratings not possible in pre-moderation with 'ProcessPreMod' site option set.", innerException); break;
                case ErrorType.InvalidModerationStatus: _error = new ApiException("The ModerationServiceGroup is not valid.", innerException); break;
                case ErrorType.InvalidForumClosedDate: _error = new ApiException("The closed date is not valid.", innerException); break;
                case ErrorType.UnknownFormat: _error = new ApiException("The requested format is not implemented or unknown.", innerException); break;
                case ErrorType.InvalidUserId: _error = new ApiException("User must be a integer", innerException); break;
                case ErrorType.InvalidRatingValue: _error = new ApiException("The rating object must be between 0 and 255", innerException); break;
                case ErrorType.InvalidThreadID: _error = new ApiException("The threadID must be of valid type.", innerException); break;
                case ErrorType.InvalidPostStyle: _error = new ApiException("The postStyle must be of valid type.", innerException); break;
                case ErrorType.CommentNotFound: _error = new ApiException("The comment with the given id could not be found.", innerException); break;
                default: _error = new ApiException("Unknow error has occurred.", innerException); break; 
            }
            _error.type = type;
            return _error;
        }
    }

    public enum ErrorType
    {
        Ok,
        Unknown,
        MissingUserCredentials,
        FailedTermsAndConditions,
        MissingEditorCredentials,
        UserIsBanned,
        SiteIsClosed,
        EmptyText,
        ExceededTextLimit,
        XmlFailedParse,
        ProfanityFoundInText,
        ForumUnknown,
        ForumClosed,
        ForumReadOnly,
        InvalidForumUid,
        InvalidForumParentUri,
        InvalidForumTitle,
        InvalidForumClosedDate,
        UnknownSite,
        MultipleRatingByUser,
        RatingExceedsMaximumAllowed,
        InvalidProcessPreModState,
        InvalidModerationStatus,
        UnknownFormat,
        InvalidUserId,
        InvalidRatingValue,
        InvalidPostStyle,
        InvalidThreadID,
        CommentNotFound

    }


}
