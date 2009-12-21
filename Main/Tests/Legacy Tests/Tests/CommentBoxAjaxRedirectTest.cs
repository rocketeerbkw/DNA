using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Test Class for UseRedirect Parameter Test
    /// </summary>
    [TestClass]
    public class CommentBoxAjaxRedirectTest
    {
        /// <summary>
        /// Validates CommentBox schema.
        /// Comment Box Schema validation tests are covered with CommentBox functional tests.
        /// </summary>
        [Ignore]
        public void UseRedirectParameterTest()
        {

            Console.WriteLine("Before UseRedirectParameterTest");
            Mockery mock = new Mockery();
            IUser viewingUser = mock.NewMock<IUser>();
            Stub.On(viewingUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(viewingUser).GetProperty("Email").Will(Return.Value("davewil@bbc.co.uk"));
            Stub.On(viewingUser).GetProperty("IsEditor").Will(Return.Value(false));
            Stub.On(viewingUser).GetProperty("IsSuperUser").Will(Return.Value(false));
            Stub.On(viewingUser).GetProperty("IsBanned").Will(Return.Value(false));

            ISite site = mock.NewMock<ISite>();
            Stub.On(site).GetProperty("IsEmergencyClosed").Will(Return.Value(false));
            Stub.On(site).Method("IsSiteScheduledClosed").Will(Return.Value(false));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(viewingUser));
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(site));

            DnaMockery.MockTryGetParamString(context,"dnauid", "this is some unique id blah de blah blah2");
            //Stub.On(context).Method("TryGetParamString").WithAnyArguments().Will(new TryGetParamStringAction("dnauid","this is some unique id blah de blah blah2"));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnauid"), Is.Anything).Will(Return.Value(true));

            DnaMockery.MockTryGetParamString(context,"dnahostpageurl", "http://www.bbc.co.uk/dna/something");
            //Stub.On(context).Method("TryGetParamString").With("dnahostpageurl").Will(new TryGetParamStringAction("dnahostpageurl","http://www.bbc.co.uk/dna/something"));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnahostpageurl"), Is.Anything).Will(Return.Value(true));

            DnaMockery.MockTryGetParamString(context,"dnainitialtitle", "newtitle");
            //Stub.On(context).Method("TryGetParamString").With("dnainitialtitle").Will(new TryGetParamStringAction("dnainitialtitle", "newtitle"));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnainitialtitle"), Is.Anything).Will(Return.Value(true));

            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnaerrortype"),Is.Anything).Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("moduserid"), Is.Anything).Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnainitialmodstatus"), Is.Anything).Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnaforumclosedate"), Is.Anything).Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With(Is.EqualTo("dnaforumduration"), Is.Anything).Will(Return.Value(false));

            Stub.On(context).Method("GetParamIntOrZero").With(Is.EqualTo("dnafrom"), Is.Anything).Will(Return.Value(0));
            Stub.On(context).Method("GetParamIntOrZero").With(Is.EqualTo("dnato"), Is.Anything).Will(Return.Value(0));
            Stub.On(context).Method("GetParamIntOrZero").With(Is.EqualTo("dnashow"), Is.Anything).Will(Return.Value(0));

            
            
            Stub.On(context).Method("GetSiteOptionValueInt").With("CommentForum","DefaultShow").Will(Return.Value(20));
            //inputContext.InitialiseFromFile(@"../../testredirectparams.txt", @"../../userdave.txt");

            CommentBoxForum forum = new CommentBoxForum(context);
            forum.ProcessRequest();


            string forumXml = forum.RootElement.InnerXml;
            DnaXmlValidator validator = new DnaXmlValidator(forumXml, "CommentBox.xsd");
            validator.Validate();
            Console.WriteLine("After UseRedirectParameterTest");
        }
    }
}
