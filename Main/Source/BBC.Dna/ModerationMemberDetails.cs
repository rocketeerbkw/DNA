using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Sites;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More User Subscriptions Page object, holds the list of User Subscriptions of a user
    /// </summary>
    public class ModerationMemberDetails : DnaInputComponent
    {

        /// <summary>
        /// Default constructor for the MoreLinks component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ModerationMemberDetails(IInputContext context)
            : base(context)
        {

        }

        private void GenerateAltIdentitiesXml(IDnaDataReader dataReader, XmlNode parentXml)
        {
            int postPassedCount = 0;
            int postFailedCount = 0;
            int postTotalCount = 0;
            int articlePassedCount = 0;
            int articleFailedCount = 0;
            int articleTotalCount = 0;

             // Add Result Data .
            while (dataReader.Read())
            {
                XmlNode memberXml = AddElementTag(parentXml,"MEMBERDETAILS");

                //AddUser XML
                XmlNode userXml = AddElementTag(memberXml, "USER");
                AddIntElement(userXml,"USERID", dataReader.GetInt32NullAsZero("userid"));
                AddTextTag(userXml, "USERNAME", dataReader.GetStringNullAsEmpty("username"));
                AddTextTag(userXml, "LOGINNAME", dataReader.GetStringNullAsEmpty("loginname"));
                AddTextTag(userXml, "EMAIL", dataReader.GetStringNullAsEmpty("email"));
                XmlNode statusXml = AddElementTag(userXml, "STATUS");
                AddAttribute(statusXml, "STATUSID", dataReader.GetInt32NullAsZero("prefstatus"));
                AddIntElement(userXml, "ACTIVE", Convert.ToInt32(dataReader.GetBoolean("active")));

                //Add Site XML.
                int siteId = dataReader.GetInt32NullAsZero("siteid");
                ISite site = InputContext.TheSiteList.GetSite(siteId);
                SiteXmlBuilder siteXmlBuilder = new SiteXmlBuilder(InputContext);
                XmlNode siteXML = siteXmlBuilder.GenerateXml(null, site);
                siteXML = ImportNode(siteXML);
                memberXml.AppendChild(siteXML);

                if (!dataReader.IsDBNull("datejoined"))
                {
                    AddDateXml(dataReader.GetDateTime("datejoined"), memberXml, "DATEJOINED");
                }
                
                //Add Stats XML
                AddIntElement(memberXml, "POSTPASSEDCOUNT", dataReader.GetInt32NullAsZero("postpassedcount"));
                AddIntElement(memberXml, "POSTFAILEDCOUNT", dataReader.GetInt32NullAsZero("postfailedcount"));
                AddIntElement(memberXml, "POSTTOTALCOUNT", dataReader.GetInt32NullAsZero("totalpostcount"));
                AddIntElement(memberXml, "ARTICLEPASSEDCOUNT", dataReader.GetInt32NullAsZero("articlepassedcount"));
                AddIntElement(memberXml, "ARTICLEFAILEDCOUNT", dataReader.GetInt32NullAsZero("articlefailedcount"));
                AddIntElement(memberXml, "ARTICLETOTALCOUNT", dataReader.GetInt32NullAsZero("totalarticlecount"));

                postPassedCount += dataReader.GetInt32NullAsZero("postpassedcount");
                postFailedCount += dataReader.GetInt32NullAsZero("postfailedcount");
                postTotalCount += dataReader.GetInt32NullAsZero("totalpostcount");
                articlePassedCount += dataReader.GetInt32NullAsZero("articlepassedcount");
                articleFailedCount += dataReader.GetInt32NullAsZero("articlefailedcount");
                articleTotalCount += dataReader.GetInt32NullAsZero("totalarticlecount");
            }

            //Add Member Details Summary XML
            XmlNode summaryXml = AddElementTag(parentXml, "SUMMARY");
            AddIntElement(summaryXml, "POSTPASSEDCOUNT", postPassedCount);
            AddIntElement(summaryXml, "POSTFAILEDCOUNT", postFailedCount);
            AddIntElement(summaryXml, "POSTTOTALCOUNT", postTotalCount);
            AddIntElement(summaryXml, "ARTICLEPASSEDCOUNT", articlePassedCount);
            AddIntElement(summaryXml,"ARTICLEFAILEDCOUNT",articleFailedCount);
            AddIntElement(summaryXml, "ARTICLETOTALCOUNT", articleTotalCount);
        }

        private void GenerateEmailAltIdentitiesXml(XmlNode parentXml, int userToFindId )
        { 
            //Get Stats.
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoderationmemberdetails"))
            {
                dataReader.AddParameter("viewinguserid", InputContext.ViewingUser.UserID);
                dataReader.AddParameter("usertofindid", userToFindId);
                dataReader.Execute();

                GenerateAltIdentitiesXml(dataReader, parentXml);
            }  
        }

        private void GenerateBBCUIDAltIdentitiesXml(XmlNode parentXml, int userToFindId)
        {
            //Get Stats.
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoderationmemberdetailsforBBCUID"))
            {
                dataReader.AddParameter("viewinguserid", InputContext.ViewingUser.UserID);
                dataReader.AddParameter("usertofindid", userToFindId);
                dataReader.Execute();

                GenerateAltIdentitiesXml(dataReader, parentXml);
            }
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            if (InputContext.ViewingUser == null )
            {
                AddErrorXml("Invalid Permissions", "Not logged In.", RootElement);
                return;
            }

            XmlNode listXml = AddElementTag(RootElement, "MEMBERDETAILSLIST");
            if (InputContext.DoesParamExist("userid", "User to Find ID"))
            {
                int userToFindId = InputContext.GetParamIntOrZero("userid", "User to Find ID");
                AddAttribute(listXml, "USERID", userToFindId);

                if (InputContext.GetParamIntOrZero("findbbcuidaltidentities", "Instruction to use BBCUID for Alternate Identities" ) == 1)
                    GenerateBBCUIDAltIdentitiesXml(listXml, userToFindId);
                else
                    GenerateEmailAltIdentitiesXml(listXml, userToFindId);
            }
            else
            {
                AddErrorXml("INVALID PARAMETERS", "UserId not provided", RootElement);
            }
        }
    }
}


