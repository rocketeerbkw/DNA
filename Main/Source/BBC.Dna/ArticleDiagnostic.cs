using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ArticleDiagnostic Page object
    /// </summary>
    public class ArticleDiagnostic : DnaInputComponent
    {
        private const string _docDnaH2G2ID = @"H2G2 ID to diagnose.";
        private const string _docDnaUserID = @"User ID to diagnose, if no H2G2 ID given.";
        
        /// <summary>
        /// Default constructor for the ArticleDiagnostic component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ArticleDiagnostic(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int H2G2ID = 0;

            TryGetPageParams(ref H2G2ID);

            TryCreateArticleDiagnosticXML(H2G2ID);
        }

        /// <summary>
        /// Functions generates the TryCreateArticleDiagnosticXML XML
        /// </summary>
        /// <param name="H2G2ID">H2G2 ID of the article to diagnose</param>
        public void TryCreateArticleDiagnosticXML(int H2G2ID)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            int status = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getstatusfromh2g2id"))
            {
                dataReader.AddParameter("H2G2ID", H2G2ID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    status = dataReader.GetInt32NullAsZero("status");
                }
            }
            if (status != 7 && status != 0)
            {
                XmlElement guide = AddElementTag(RootElement, "GUIDE");
                XmlElement body = AddElementTag(guide, "BODY");
                AddTextTag(body, "SUBHEADER", "Analysing page...");

                ParsePageFromErrors();

            }
            else
            {
                OutputSimplePage();
            }
        }

        private void OutputSimplePage()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        private void ParsePageFromErrors()
        {
            throw new Exception("The method or operation is not implemented.");
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="H2G2ID">H2G2 ID of the article to diagnose</param>
        private void TryGetPageParams(ref int H2G2ID)
        {
            H2G2ID = InputContext.GetParamIntOrZero("h2g2ID", _docDnaH2G2ID);
	        if (H2G2ID == 0)
	        {
                int userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
		        User user = new User(InputContext);
		        user.CreateUser(userID);
                H2G2ID = user.Masthead;
	        }
        }
    }
}