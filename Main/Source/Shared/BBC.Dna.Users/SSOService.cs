using System;
using System.Collections.Generic;
using System.Text;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// Container object that holds all the info about the current service
    /// </summary>
    public class SSOService
    {
        // Service details
        private string _serviceName = String.Empty;
        private int _serviceId = 0;
        private int _maxAge = 0;
        private int _minAge = 0;
        private bool _ServiceSet = false;

        /// <summary>
        /// Service name property
        /// </summary>
        public string ServiceName
        {
            get { return _serviceName; }
            set { _serviceName = value; }
        }

        /// <summary>
        /// Service ID Property
        /// </summary>
        public int ServiceID
        {
            get { return _serviceId; }
            set { _serviceId = value; }
        }

        /// <summary>
        /// Max age property
        /// </summary>
        public int MaxAge
        {
            get { return _maxAge; }
            set { _maxAge = value; }
        }

        /// <summary>
        /// Min age property
        /// </summary>
        public int MinAge
        {
            get { return _minAge; }
            set { _minAge = value; }
        }

        /// <summary>
        /// Service set property
        /// </summary>
        public bool IsServiceSet
        {
            get { return _ServiceSet; }
            set { _ServiceSet = value; }
        }

        /// <summary>
        /// Used to reset all the user details back to initialised state
        /// </summary>
        public void ResetDetails()
        {
            _serviceName = String.Empty;
            _serviceId = 0;
            _maxAge = 0;
            _minAge = 0;
            _ServiceSet = false;
        }
    }
}
