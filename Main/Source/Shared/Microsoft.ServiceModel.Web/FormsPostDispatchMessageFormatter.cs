using System;
using System.Collections.Specialized;
//-----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//-----------------------------------------------------------------------------
using System.Linq;
using System.Net.Mime;
using System.Reflection;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.Xml;

namespace Microsoft.ServiceModel.Web
{
    public class FormsPostDispatchMessageFormatter : IDispatchMessageFormatter
    {
        IDispatchMessageFormatter inner;
        OperationDescription od;
        int nvcIndex = -1;
        QueryStringConverter queryStringConverter;

        public FormsPostDispatchMessageFormatter(OperationDescription od, IDispatchMessageFormatter inner, QueryStringConverter queryStringConverter)
        {
            this.inner = inner;
            this.od = od;
            this.queryStringConverter = queryStringConverter;
            MessageDescription request = null;
            foreach (MessageDescription message in od.Messages)
            {
                if (message.Direction == MessageDirection.Input)
                {
                    request = message;
                    break;
                }
            }
            if (request != null && request.MessageType == null)
            {
                for (int i = 0; i < request.Body.Parts.Count; ++i)
                {
                    if (request.Body.Parts[i].Type == typeof(NameValueCollection))
                    {
                        this.nvcIndex = i;
                        break;
                    }
                }
            }
        }

        public void DeserializeRequest(Message message, object[] parameters)
        {
            if (message == null)
            {
                return;
            }
            if (this.nvcIndex >= 0 && string.Equals(WebOperationContext.Current.IncomingRequest.ContentType, "application/x-www-form-urlencoded", StringComparison.OrdinalIgnoreCase))
            {
                using (XmlDictionaryReader r = message.GetReaderAtBodyContents())
                {
                    r.Quotas.MaxArrayLength = int.MaxValue;
                    r.ReadStartElement("Binary");
                    byte[] buffer = r.ReadContentAsBase64();
                    string queryString = new UTF8Encoding().GetString(buffer);
                    NameValueCollection nvc = HttpUtility.ParseQueryString(queryString);
                    parameters[this.nvcIndex] = nvc;
                }
                // bind the uri template parameters
                UriTemplateMatch match = message.Properties["UriTemplateMatchResults"] as UriTemplateMatch;
                ParameterInfo[] paramInfos = this.od.SyncMethod.GetParameters();
                var binder = CreateParameterBinder(match);
                object[] values = (from p in paramInfos
                                   where p.ParameterType != typeof(NameValueCollection)
                                   select binder(p)).ToArray<Object>();
                int index = 0;
                for (int i = 0; i < paramInfos.Length; ++i)
                {
                    if (i != this.nvcIndex)
                    {
                        parameters[i] = values[index];
                        ++index;
                    }
                }
            }
            else
            {
                try
                {
                    inner.DeserializeRequest(message, parameters);
                }
                catch (InvalidOperationException e)
                {
                    var httpRequestProperties = (HttpRequestMessageProperty)message.Properties["httpRequest"];

                    if (httpRequestProperties != null)
                    {
                        var contentType = httpRequestProperties.Headers["Content-Type"];

                        if (!string.IsNullOrEmpty(contentType) && !ContentTypeIsKnown(contentType))
                        {
                            throw new HttpRequestValidationException(e.Message, e);
                        }
                    }

                    throw;
                }
            }
        }

        private bool ContentTypeIsKnown(string contentType)
        {
            var applicationTypes = typeof(MediaTypeNames.Application);

            var types = applicationTypes.GetFields();

            var match = types.Any(f => Convert.ToString(f.GetValue(types)) == contentType);

            if (match) return true;

            var textTypes = typeof(MediaTypeNames.Text);

            types = textTypes.GetFields();

            return types.Any(f => Convert.ToString(f.GetValue(types)) == contentType);
        }

        public Message SerializeReply(MessageVersion messageVersion, object[] parameters, object result)
        {
            throw new NotSupportedException();
        }

        Func<ParameterInfo, object> CreateParameterBinder(UriTemplateMatch match)
        {
            return delegate(ParameterInfo pi)
            {
                string value = match.BoundVariables[pi.Name];
                if (!string.IsNullOrEmpty(value))
                {
                    return this.queryStringConverter.ConvertStringToValue(value, pi.ParameterType);
                }
                else
                {
                    return pi.RawDefaultValue;
                }
            };
        }

    }
}
