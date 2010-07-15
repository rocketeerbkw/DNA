using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using System.Collections.Specialized;

namespace BBC.Dna.Common.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class SignalTests
    {
        private readonly MockRepository _mocks = new MockRepository();

        public SignalTests()
        {
            SignalHelper.ClearObjects();
        }

        [TestMethod]
        public void AddObject_AddObject_ReturnsValidObject()
        {
            var signal = _mocks.DynamicMock<ISignalBase>();
            signal.Stub(x => x.HandleSignal("", null)).Return(false);

            _mocks.ReplayAll();

            SignalHelper.AddObject(typeof(string), signal);

            Assert.IsNotNull(SignalHelper.GetObject(typeof(string)));
            
        }

        [TestMethod]
        public void AddObject_ReAddObject_ReturnsValidObject()
        {
            var signal = _mocks.DynamicMock<ISignalBase>();
            signal.Stub(x => x.HandleSignal("", null)).Return(false);

            _mocks.ReplayAll();

            SignalHelper.AddObject(typeof(string), signal);
            SignalHelper.AddObject(typeof(string), signal);

            Assert.IsNotNull(SignalHelper.GetObject(typeof(string)));

        }

        [TestMethod]
        public void AddObject_AddObjectRequestOtherUnknownObj_ReturnsNull()
        {
            var signal = _mocks.DynamicMock<ISignalBase>();
            signal.Stub(x => x.HandleSignal("", null)).Return(false);

            _mocks.ReplayAll();

            SignalHelper.AddObject(typeof(string), signal);
            Assert.IsNull(SignalHelper.GetObject(typeof(object)));

        }

        [TestMethod]
        public void HandleSignal_SignalHandled_NoException()
        {
            var signalKey = "recache-sites";
            var queryString = new NameValueCollection();
            queryString.Add("action", signalKey);

            var signal = _mocks.DynamicMock<ISignalBase>();
            signal.Stub(x => x.HandleSignal(signalKey, queryString)).Return(true);

            
            _mocks.ReplayAll();

            SignalHelper.AddObject(typeof(string), signal);
            SignalHelper.HandleSignal(queryString);

        }

        [TestMethod]
        public void HandleSignal_SignalNotHandled_Exception()
        {
            var signalKey = "recache-sites";
            var signal = _mocks.DynamicMock<ISignalBase>();
            signal.Stub(x => x.HandleSignal(signalKey, null)).Return(false);

            var queryString = new NameValueCollection();
            queryString.Add("action", signalKey);
            _mocks.ReplayAll();

            SignalHelper.AddObject(typeof(string), signal);
            bool exceptionThrown = false;
            try
            {

                SignalHelper.HandleSignal(queryString);
            }
            catch (Exception e)
            {
                exceptionThrown = true;
                Assert.IsTrue(e.Message.IndexOf(signalKey) >= 0);
            }

            Assert.IsTrue(exceptionThrown);
        }

        [TestMethod]
        public void HandleSignal_SignalNoaction_NothingHappens()
        {
            var signalKey = "recache-sites";
            var signal = _mocks.DynamicMock<ISignalBase>();
            signal.Stub(x => x.HandleSignal(signalKey, null)).Return(false);

            var queryString = new NameValueCollection();
            _mocks.ReplayAll();

            SignalHelper.AddObject(typeof(string), signal);
            SignalHelper.HandleSignal(queryString);
        }
    }
}
