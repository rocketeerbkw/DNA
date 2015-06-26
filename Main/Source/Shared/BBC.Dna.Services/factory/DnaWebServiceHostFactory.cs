namespace BBC.Dna.Services
{
    using System;
    using System.ServiceModel;
    using System.ServiceModel.Activation;

    public class DnaWebServiceHostFactory : ServiceHostFactory
    {
        protected override ServiceHost CreateServiceHost(Type serviceType, Uri[] baseAddresses)
        {
            return new DnaWebServiceHost(serviceType, true, baseAddresses);
        }
    }
}