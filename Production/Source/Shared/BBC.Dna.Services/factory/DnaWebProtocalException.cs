using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.ServiceModel.Web;
using System.Globalization;
using System.IO;
using System.Xml.Linq;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.Xml;
using System.Runtime.Serialization;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using BBC.Dna.Api;

namespace BBC.Dna.Services
{
    public class DnaWebProtocolException : CommunicationException
    {
        DetailWriter detailWriter;

        public HttpStatusCode StatusCode { get; set; }
        public ErrorType ErrorType { get; set; }

        public string StatusDescription { get; set; }

        public bool IsDetailXhtml { get; set; }

        /// <summary>
        /// Throws a new WebProtocalException. Debug builds throw the exception along with the description and inner exception, release builds
        /// only throw the StatusCode.
        /// </summary>
        /// <param name="StatusCode">The status code you want the exception to contain</param>
        /// <param name="statusDescription">The description of the exception</param>
        /// <param name="innerException">The origninal exception you caught if any</param>
        public DnaWebProtocolException(HttpStatusCode statusCode, string statusDescription, Exception innerException)
            
        {
            StatusCode = statusCode;
            StatusDescription = statusDescription;
            if (String.IsNullOrEmpty(statusDescription))
            {
                if(innerException != null)
                {
                    statusDescription = innerException.Message;
                }
                else
                {
                    statusDescription = "";
                }
            }
            

            LogEntry entry = new LogEntry()
            {
                Message = String.Format("{0}-{1}", StatusCode, statusDescription),
                Severity = System.Diagnostics.TraceEventType.Error,
            };

            Logger.Write(entry);


            this.detailWriter = new StringDetailWriter() { Detail = statusDescription, StatusCode = StatusCode, innerException = innerException, ErrorCode = ErrorType.Unknown.ToString() };

        }

        /// <summary>
        /// Throws a new WebProtocalException. Debug builds throw the exception along with the description and inner exception, release builds
        /// only throw the StatusCode.
        /// </summary>
        /// <param name="e">the api exception</param>
        public DnaWebProtocolException(ApiException e)
        {
            ErrorType = e.type;
            switch (e.type)
            {
                case ErrorType.FailedTermsAndConditions: StatusCode = HttpStatusCode.Unauthorized; break;
                case ErrorType.MissingUserCredentials: StatusCode = HttpStatusCode.Unauthorized; break;
                case ErrorType.MissingEditorCredentials: StatusCode = HttpStatusCode.Unauthorized; break;
                case ErrorType.UserIsBanned: StatusCode = HttpStatusCode.Unauthorized; break;
                case ErrorType.SiteIsClosed: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.EmptyText: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.ExceededTextLimit: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.MinCharLimitNotReached: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.XmlFailedParse: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.ProfanityFoundInText: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.ForumUnknown: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.ForumClosed: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.ForumReadOnly: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidForumUid: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidForumParentUri: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidForumTitle: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.UnknownSite: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.MultipleRatingByUser: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.RatingExceedsMaximumAllowed: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidProcessPreModState: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidModerationStatus: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidForumClosedDate: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.UnknownFormat: StatusCode = HttpStatusCode.NotImplemented; break;
                case ErrorType.InvalidUserId: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidRatingValue: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.InvalidPostStyle: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.MissingUserList: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.NotSecure: StatusCode = HttpStatusCode.Unauthorized; break;
                case ErrorType.CommentNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.CategoryNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.MonthSummaryNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.IndexNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.UserNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.ForumOrThreadNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.GuideMLTransformationFailed: StatusCode = HttpStatusCode.InternalServerError; break;
                case ErrorType.ThreadPostNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.ThreadNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.InvalidThreadID: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.ForumIDNotWellFormed: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.MaintenanceMode: StatusCode = HttpStatusCode.ServiceUnavailable; break;  
                case ErrorType.AlreadyLinked: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.ArticleNotFound: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.NoResults: StatusCode = HttpStatusCode.NotFound; break;
                case ErrorType.NotForReview: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.AddIntoReviewForumFailed: StatusCode = HttpStatusCode.InternalServerError; break;
                case ErrorType.InvalidH2G2Id: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.MissingGuideML: StatusCode = HttpStatusCode.BadRequest; break;
                case ErrorType.MissingSubject: StatusCode = HttpStatusCode.BadRequest; break;
                default: StatusCode = HttpStatusCode.InternalServerError; break;
            }

            LogEntry entry = new LogEntry()
            {
                Message = String.Format("{0}-{1}-{2}", StatusCode, e.type, e.Message),
                Severity = System.Diagnostics.TraceEventType.Error,
            };
            Logger.Write(entry);
            
            /*
            WebFormat.format format = WebFormat.format.UNKNOWN;
            string contentType = "";
            WebFormat.getReturnFormat((WebOperationContext.Current.IncomingRequest.ContentType == null ? "" : WebOperationContext.Current.IncomingRequest.ContentType),
            ref contentType, ref format);

            if (format == WebFormat.format.HTML)
            {
                string ptrt = WebFormat.GetPtrtWithResponse(ErrorType.ToString());
                //do response redirect...
                WebOperationContext.Current.OutgoingResponse.Location = ptrt;
                StatusCode = System.Net.HttpStatusCode.MovedPermanently;

            }*/
            this.detailWriter = new StringDetailWriter() { ErrorCode = e.type.ToString(), Detail = e.Message, StatusCode = StatusCode, innerException = e.InnerException };
        }

        public abstract class DetailWriter
        {
            public abstract void WriteDetail(XmlWriter writer);
        }

        internal protected virtual void WriteDetail(XmlWriter writer)
        {
            this.detailWriter.WriteDetail(writer);
        }

        public class StringDetailWriter : DetailWriter
        {
            public string Detail { get; set; }
            public string ErrorCode { get; set; }
            public HttpStatusCode StatusCode { get; set; }
            
            public Exception innerException { get; set; }

            public override void WriteDetail(XmlWriter writer)
            {
                //get web format
                WebFormat.format format = WebFormat.format.UNKNOWN;
                string contentType = "";
                WebFormat.getReturnFormat((WebOperationContext.Current.IncomingRequest.ContentType == null ? "" : WebOperationContext.Current.IncomingRequest.ContentType),
                ref contentType, ref format);

                // Throw with everything
                string innerExceptionStr = "";
#if DEBUG
                if (innerException != null)
                {
                    innerExceptionStr += "Error : " + innerException.Message + "\r\n";
                    innerExceptionStr += "Located : " + innerException.StackTrace + "\r\n\r\n";
                    if (innerException.InnerException != null)
                    {
                        innerExceptionStr += "Inner Exception\r\n";
                        innerExceptionStr += "Error : " + innerException.InnerException.Message + "\r\n";
                        innerExceptionStr += "Located : " + innerException.InnerException.StackTrace + "\r\n";
                    }
                }
#endif

                ErrorData errorData = new ErrorData { Detail = Detail, InnerException = innerExceptionStr, Code=ErrorCode };
                switch(format)
                {
                    case WebFormat.format.JSON:
                        new DataContractJsonSerializer(typeof(ErrorData)).WriteObject(writer, errorData);
                        break;

                    default:
                        string output = StringUtils.SerializeToXml(errorData);
                        XElement element = XElement.Load(new StringReader(output));
                        element.WriteTo(writer);
                        break;
                }
            }

            
        }
    }

    
}
