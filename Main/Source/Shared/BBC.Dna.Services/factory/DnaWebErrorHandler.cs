namespace BBC.Dna.Services
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Net;
    using System.Runtime.Serialization;
    using System.ServiceModel;
    using System.ServiceModel.Channels;
    using System.ServiceModel.Dispatcher;
    using System.ServiceModel.Security;
    using System.ServiceModel.Web;
    using System.Threading;
    using System.Web;
    using System.Xml;
    using Microsoft.ServiceModel.Web;
    
    class DnaWebErrorHandler : IErrorHandler
    {
        public bool EnableAspNetCustomErrors { get; set; }

        public bool IncludeExceptionDetailInFaults { get; set; }

        public bool HandleError(Exception error)
        {
            return true;
        }

        public void ProvideFault(Exception error, MessageVersion version, ref Message fault)
        {
            DnaWebProtocolException webError = error as DnaWebProtocolException;
            string errorMessage = error.Message;
            bool badRequest = DetectBadRequest(ref errorMessage);
            if (!badRequest)
            {
                errorMessage = (this.IncludeExceptionDetailInFaults) ? error.Message : "The server encountered an error processing the request. Please see the server logs for more details.";
            }

            if (webError == null)
            {
                if (error is SecurityAccessDeniedException) webError = new DnaWebProtocolException(HttpStatusCode.Unauthorized, errorMessage, error);
                else if (error is ServerTooBusyException) webError = new DnaWebProtocolException(HttpStatusCode.ServiceUnavailable, errorMessage, error);
                else if (error is FaultException)
                {
                    FaultException fe = error as FaultException;
                    if (fe.Code.IsSenderFault)
                    {
                        if (fe.Code.SubCode.Name == "FailedAuthentication")
                        {
                            webError = new DnaWebProtocolException(HttpStatusCode.Unauthorized, fe.Reason.Translations[0].Text, fe);
                        }
                        else
                        {
                            webError = new DnaWebProtocolException(HttpStatusCode.BadRequest, fe.Reason.Translations[0].Text, fe);
                        }
                    }
                    else
                    {
                        webError = new DnaWebProtocolException(HttpStatusCode.InternalServerError, fe.Reason.Translations[0].Text, fe);
                    }
                }
                else
                {
                    if (badRequest)
                    {
                        webError = new DnaWebProtocolException(HttpStatusCode.BadRequest, errorMessage, error);
                    }
                    else
                    {
                        webError = new DnaWebProtocolException(HttpStatusCode.InternalServerError, errorMessage, error);
                    }
                }
            }
            if (version == MessageVersion.None)
            {
                WebMessageFormat format = WebMessageFormat.Xml;
                object dummy;
                if (OperationContext.Current.IncomingMessageProperties.TryGetValue(ResponseWebFormatPropertyAttacher.PropertyName, out dummy))
                {
                    format = (WebMessageFormat) dummy;
                }
                //check for dna format parameter
                WebFormat.format dnaFormat = WebFormat.format.UNKNOWN;
                string contentType = "";
                WebFormat.getReturnFormat((WebOperationContext.Current.IncomingRequest.ContentType == null ? "" : WebOperationContext.Current.IncomingRequest.ContentType),
                ref contentType, ref dnaFormat);
                switch (dnaFormat)
                {
                    case WebFormat.format.JSON: format = WebMessageFormat.Json; break;

                }

                fault = Message.CreateMessage(MessageVersion.None, null, new ErrorBodyWriter() { Error = webError, Format = format });
                HttpResponseMessageProperty prop = new HttpResponseMessageProperty();
                prop.StatusCode = webError.StatusCode;
                prop.StatusDescription = webError.StatusDescription;
                if (format == WebMessageFormat.Json)
                {
                    prop.Headers[HttpResponseHeader.ContentType] = "application/json";
                }
                else if (webError.IsDetailXhtml)
                {
                    prop.Headers[HttpResponseHeader.ContentType] = "text/html";
                }
                fault.Properties[HttpResponseMessageProperty.Name] = prop;
                WebBodyFormatMessageProperty formatProp = new WebBodyFormatMessageProperty((format == WebMessageFormat.Json) ? WebContentFormat.Json : WebContentFormat.Xml);
                fault.Properties[WebBodyFormatMessageProperty.Name] = formatProp;
            }
            if (this.EnableAspNetCustomErrors && HttpContext.Current != null)
            {
                HttpContext.Current.AddError(error);
            }
        }

        /// <summary>
        /// Bad requests are thrown as exception - this function checks the error message and reformats it as a bad request
        /// </summary>
        /// <param name="errorMessage">The exception error message</param>
        /// <returns>True if a bad request is detected</returns>
        private bool DetectBadRequest(ref string errorMessage)
        {
            string errorText = "Inputted data does not meet criteria. ({0})";
            int pos = errorMessage.IndexOf("Expecting element");
            if (pos >= 0)
            {
                errorMessage = String.Format(errorText, errorMessage.Substring(pos, errorMessage.Length - pos));
                return true;
            }
            pos = errorMessage.IndexOf("Invalid enum value");
            if (pos >= 0)
            {
                errorMessage = String.Format(errorText, "Invalid enum value");
                return true;
            }
            pos = errorMessage.IndexOf("There was an error deserializing the object of type");
            if (pos >= 0)
            {
                pos = errorMessage.IndexOf(". ")+1;
                errorMessage = String.Format(errorText, errorMessage.Substring(pos, errorMessage.Length - pos));
                return true;
            }
            return false;
        }

        class ErrorBodyWriter : BodyWriter
        {
            public ErrorBodyWriter()
                : base(true)
            {
            }

            public DnaWebProtocolException Error { get; set; }

            public WebMessageFormat Format { get; set; }

            protected override void OnWriteBodyContents(XmlDictionaryWriter writer)
            {
                Error.WriteDetail(writer);
            }
        }
    }
}
