using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Moderation;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// Functionality for the moderation of external content.
    /// </summary>
    public class ModerateExLinks : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerateExLinks(IInputContext context)
            : base(context)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        public override void ProcessRequest()
        {
            if (InputContext.ViewingUser == null || InputContext.ViewingUser.UserLoggedIn == false)
            {
                AddErrorXml("Unauthorised","Invalid permissions", RootElement);
                return;
            }

            bool alerts = InputContext.GetParamBoolOrFalse("alerts", "Moderation Alerts");
            bool referrals = InputContext.GetParamBoolOrFalse("referrals", "Refered Items");
            bool locked = InputContext.GetParamBoolOrFalse("locked", "Locked Items");
            int modClassId = InputContext.GetParamIntOrZero("modclassid", "Moderation Class Id");
            
            //int show = InputContext.GetParamIntOrZero("show", "Number of Items");
            //if (show == 0)
           // {
           //     show = 10;
           // }

            ProcessSubmission();

            if (InputContext.DoesParamExist("Done", "Done"))
            {
                if (InputContext.DoesParamExist("Redirect", "Redirect"))
                {
                    String redir = InputContext.GetParamStringOrEmpty("redirect", "Redirect");

                    XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                    AddAttribute(redirect, "URL", redir);
                    return;
                }
            }

            int userId = InputContext.ViewingUser.UserID;
            GenerateXml(alerts, referrals, locked, userId, modClassId );

        }

        /// <summary>
        /// Process Form Submission - Record Moderators Decision.
        /// </summary>
        private void ProcessSubmission(  )
        {
            ExternalLinkModeration modLink = new ExternalLinkModeration();

            int count = InputContext.GetParamCountOrZero("modid", "ModerationId");
            for (int i = 0; i < count; ++i)
            {
                int decision = InputContext.GetParamIntOrZero("decision", i, "Moderation Decision");
                int modId = InputContext.GetParamIntOrZero("modid", i, "ModerationId");
                String notes = InputContext.GetParamStringOrEmpty("notes", i, "notes");
                int referTo = InputContext.GetParamIntOrZero("referTo", i, "referTo");

                if (decision == (int)ModeratePosts.Status.Refer && referTo == 0)
                {
                    AddErrorXml("MissingReferTo", "Please specify a referee to refer items to", RootElement);
                }
                else
                {
                    //Insert into mod queue
                    using (IDnaDataReader reader = InputContext.CreateDnaDataReader("moderateexlinks"))
                    {
                        reader.AddParameter("modid", modId);
                        reader.AddParameter("decision", decision);
                        reader.AddParameter("userid", InputContext.ViewingUser.UserID);
                        reader.AddParameter("notes", notes);
                        reader.AddParameter("referTo", referTo);
                        reader.Execute();
                    }
                }
            }

        }

        /// <summary>
        /// Generate XML for Moderate External Links page.
        /// </summary>
        private void GenerateXml(bool alerts, bool referrals, bool locked, int userId, int modClassId )
        {
            XmlElement linkMod = AddElementTag(RootElement, "LINKMODERATION-LIST");
            AddAttribute(linkMod, "MODCLASSID", modClassId);

            if (alerts)
            {
                AddAttribute(linkMod, "ALERTS", 1);
            }
            if (referrals)
            {
                AddAttribute(linkMod, "REFERRALS", 1);
            }
            if (locked)
            {
                AddAttribute(linkMod, "LOCKEDITEMS", 1);
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoderationexlinks"))
            {
                dataReader.AddParameter("modclassid", modClassId);
                dataReader.AddParameter("referrals", referrals);
                dataReader.AddParameter("alerts", alerts);
                dataReader.AddParameter("locked", locked);
                dataReader.AddParameter("userid", userId);

                dataReader.Execute();

                if (!dataReader.HasRows)
                {
                    AddAttribute(linkMod, "COUNT", 0);
                }

                while (dataReader.Read())
                {
                    XmlElement link = AddElementTag(linkMod, "LINKMODERATION");
                    AddAttribute(link, "MODID", dataReader.GetInt32NullAsZero("modid"));
                    AddTextTag(link, "URI", dataReader.GetStringNullAsEmpty("uri"));
                    AddIntElement(link, "SITEID", dataReader.GetInt32NullAsZero("siteid"));

                    String notes = dataReader.GetStringNullAsEmpty("notes");
                    notes = notes.Replace("\r\n", "<BR/>");
                    AddXmlTextTag(link, "NOTES", notes );

                    // Locking User XML.
                    XmlElement lockedXml = AddElementTag(link, "LOCKED");
                    AddDateXml(dataReader.GetDateTime("datelocked"), lockedXml, "DATELOCKED");
                    XmlElement lockedUserXml = AddElementTag(lockedXml, "USER");
                    AddIntElement(lockedUserXml, "USERID", dataReader.GetInt32NullAsZero("lockedby"));
                    AddTextTag(lockedUserXml, "USERNAME", dataReader.GetStringNullAsEmpty("lockedname"));
                    AddTextTag(lockedUserXml, "FIRSTNAMES", dataReader.GetStringNullAsEmpty("lockedfirstnames"));
                    AddTextTag(lockedUserXml, "LASTNAME", dataReader.GetStringNullAsEmpty("lockedlastname"));


                    if ( alerts )
                    {
                        // Complaints XML
                        XmlElement alertsXML = AddElementTag(link, "ALERTS");
                        AddTextTag(alertsXML, "TEXT", dataReader.GetStringNullAsEmpty("complainttext"));
                        AddDateXml(dataReader.GetDateTime("datequeued"), alertsXML, "DATEQUEUED");
                    }

                    if ( referrals ) 
                    {
                        //Referrals XML
                        XmlElement referXml = AddElementTag(link, "REFERRED");
                        XmlElement referUserXml = AddElementTag(referXml, "USER");
                        AddIntElement(referUserXml, "USERID", dataReader.GetInt32NullAsZero("referrerid"));
                        AddTextTag(referUserXml, "USERNAME", dataReader.GetStringNullAsEmpty("referrername"));
                        AddTextTag(referUserXml, "FIRSTNAMES", dataReader.GetStringNullAsEmpty("referrerfirstnames"));
                        AddTextTag(referUserXml, "LASTNAME", dataReader.GetStringNullAsEmpty("referrerlastname"));
                        AddIntElement(referUserXml, "STATUS", dataReader.GetInt32NullAsZero("referrerstatus"));
                        AddDateXml(dataReader.GetDateTime("datereferred"), referXml, "DATEREFERRED");
                    }
                }

            }


        }

    }
}
