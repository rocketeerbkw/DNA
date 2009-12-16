using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// Class Provides Email Templates for use by Moderators and Editors.
    /// Templates are provided to cover emails sent to users as a result of common moderation and editorila decsisions.
    /// The users details are lated substituted into the generic email template.
    /// </summary>
    public class EmailTemplate : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        public EmailTemplate(IInputContext context) : base(context)
        { }

        /// <summary>
        /// FetchEmailText - Returns email template subject and body.
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="templateName">Name of template to serve.</param>
        /// <param name="subject">Returned subject</param>
        /// <param name="body">Returned template body.</param>
        public void FetchEmailText( int siteId, string templateName, out string subject, out string body )
        {
            subject = string.Empty;
            body = string.Empty;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchemailtemplate") )
            {
                dataReader.AddParameter("siteid",siteId);
                dataReader.AddParameter("emailName", templateName);
                dataReader.Execute();
                if (dataReader.Read())
                {
                    subject = dataReader.GetString("subject");
                    body = dataReader.GetString("body");
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="insertName"></param>
        /// <param name="insertText"></param>
        /// <returns></returns>
        public bool FetchInsertText(int siteId, String insertName, out String insertText)
        {
            insertText = null;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getemailinsert"))
            {
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("insertname", insertName);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    insertText = dataReader.GetStringNullAsEmpty("inserttext");
                    return true;
                }
            }
            return false;
        }

    }
}
