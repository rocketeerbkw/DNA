using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Text;
using BBC.Dna;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting; 

/// <summary>
/// Class to fake InputContext when testing ProfileAPI
/// </summary>
class ProfileTestInputContext : TestInputContext
{
    private ConnectionStringSettingsCollection _profileConnectionDetails;

    /// <summary>
    /// Returns hardcoded collection of connection strings. 
    /// </summary>
    /// <returns>ConnectionStringSettingsCollection</returns>
    public override ConnectionStringSettingsCollection GetConnectionDetails
    {
        get
        {
            if (_profileConnectionDetails == null)
            {
                _profileConnectionDetails = new ConnectionStringSettingsCollection();
                _profileConnectionDetails.Add(new ConnectionStringSettings("ProfileRead",  "server=ops-dbdev1.national.core.bbc.co.uk; port=3312; user id=profile; password=crudmeister; database=mdb; pooling=true"));
                _profileConnectionDetails.Add(new ConnectionStringSettings("ProfileWrite", "server=ops-dbdev1.national.core.bbc.co.uk; port=3312; user id=profile; password=crudmeister; database=mdb; pooling=true"));
            }

            return _profileConnectionDetails;
        }
    }
}
