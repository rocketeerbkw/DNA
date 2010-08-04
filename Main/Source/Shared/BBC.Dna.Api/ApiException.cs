using System;
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
            ApiException error;
            switch (type)
            {
                case ErrorType.MissingUserCredentials:
                    error = new ApiException("Missing user credentials.", innerException);
                    break;
                case ErrorType.FailedTermsAndConditions:
                    error = new ApiException("Failed terms and conditions.", innerException);
                    break;
                case ErrorType.MissingEditorCredentials:
                    error = new ApiException("Missing editor credentials.", innerException);
                    break;
                case ErrorType.UserIsBanned:
                    error = new ApiException("User is banned.", innerException);
                    break;
                case ErrorType.SiteIsClosed:
                    error = new ApiException("Site is closed.", innerException);
                    break;
                case ErrorType.EmptyText:
                    error = new ApiException("Text is null or blank.", innerException);
                    break;
                case ErrorType.ExceededTextLimit:
                    error = new ApiException("Text exceeds maximum character limit.", innerException);
                    break;
                case ErrorType.XmlFailedParse:
                    error = new ApiException("The xml provided failed to parse correctly.", innerException);
                    break;
                case ErrorType.ProfanityFoundInText:
                    error = new ApiException("Profanity filter triggered error.", innerException);
                    break;
                case ErrorType.ForumUnknown:
                    error = new ApiException("Forum is unknown and cannot be added to.", innerException);
                    break;
                case ErrorType.ForumClosed:
                    error = new ApiException("Forum is closed and cannot be added to.", innerException);
                    break;
                case ErrorType.ForumReadOnly:
                    error = new ApiException("Forum is readonly and cannot be added to.", innerException);
                    break;
                case ErrorType.InvalidForumUid:
                    error = new ApiException("Forum uid is empty, null or exceeds 255 characters.", innerException);
                    break;
                case ErrorType.InvalidForumParentUri:
                    error = new ApiException("Forum parent uri is empty, null or not from a bbc.co.uk domain.",
                                              innerException);
                    break;
                case ErrorType.InvalidForumTitle:
                    error = new ApiException("Forum title uri is empty or null.", innerException);
                    break;
                case ErrorType.UnknownSite:
                    error = new ApiException("Site reference is unknown.", innerException);
                    break;
                case ErrorType.MultipleRatingByUser:
                    error = new ApiException("User has already rated this content.", innerException);
                    break;
                case ErrorType.RatingExceedsMaximumAllowed:
                    error = new ApiException("Rating exceeds allowed maximum.", innerException);
                    break;
                case ErrorType.InvalidProcessPreModState:
                    error =
                        new ApiException(
                            "Ratings not possible in pre-moderation with 'ProcessPreMod' site option set.",
                            innerException);
                    break;
                case ErrorType.InvalidModerationStatus:
                    error = new ApiException("The ModerationServiceGroup is not valid.", innerException);
                    break;
                case ErrorType.InvalidForumClosedDate:
                    error = new ApiException("The closed date is not valid.", innerException);
                    break;
                case ErrorType.UnknownFormat:
                    error = new ApiException("The requested format is not implemented or unknown.", innerException);
                    break;
                case ErrorType.InvalidUserId:
                    error = new ApiException("User must be a integer", innerException);
                    break;
                case ErrorType.InvalidRatingValue:
                    error = new ApiException("The rating object must be between 0 and 255", innerException);
                    break;
                case ErrorType.InvalidThreadID:
                    error = new ApiException("The threadID must be of valid type.", innerException);
                    break;
                case ErrorType.InvalidPostStyle:
                    error = new ApiException("The postStyle must be of valid type.", innerException);
                    break;
                case ErrorType.CommentNotFound:
                    error = new ApiException("The comment with the given id could not be found.", innerException);
                    break;
                case ErrorType.MinCharLimitNotReached:
                    error = new ApiException("Text is below the minimum character limit.", innerException);
                    break;

                case ErrorType.MissingUserList:
                    error = new ApiException("No user ids passed in.", innerException);
                    break;
                case ErrorType.NotSecure:
                    error = new ApiException("Not a secure posting.", innerException);
                    break;
                case ErrorType.CategoryNotFound:
                    error = new ApiException("Category not found.", innerException);
                    break;
                case ErrorType.MonthSummaryNotFound:
                    error = new ApiException("Month summary not found.", innerException);
                    break;
                case ErrorType.IndexNotFound:
                    error = new ApiException("Index not found.", innerException);
                    break;
                case ErrorType.UserNotFound:
                    error = new ApiException("User not found.", innerException);
                    break;
                default:
                    error = new ApiException("Unknown error has occurred.", innerException);
                    break;
            }
            error.type = type;
            return error;
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
        CommentNotFound,
        MinCharLimitNotReached,
        MissingUserList,
        NotSecure,
        CategoryNotFound,
        MonthSummaryNotFound,
        IndexNotFound,
        UserNotFound
    }
}