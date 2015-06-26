//-----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.  All rights reserved.
//-----------------------------------------------------------------------------

namespace Microsoft.ServiceModel.Web
{
    using System;
    using System.ServiceModel;
    using System.ServiceModel.Activation;

    public class WebServiceHost2Factory : ServiceHostFactory
    {
        protected override ServiceHost CreateServiceHost(Type serviceType, Uri[] baseAddresses)
        {
            return new WebServiceHost2(serviceType, true, baseAddresses);
        }
    }
}