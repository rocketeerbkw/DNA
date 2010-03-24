using System;
using System.Collections;
//using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Xml;

using BBC.Dna.Component;
using BBC.Dna.Data;

using System.Configuration;
using System.Web.Configuration;
using BBC.Dna.Utils;


namespace BBC.Dna.DynamicLists
{
    /// <summary>
    /// 
    /// </summary>
    public class DynamicListException : DnaException
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="message"></param>
        public DynamicListException(string message) : base(message) { }
    }

    /// <summary>
    /// 
    /// </summary>
    public class dlistupdatesp : DnaInputComponent
	{
        private Dbo _dbo;

        /// <summary>
        /// 
        /// </summary>
        public dlistupdatesp(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public void Initialise()
        {
            ConnectionStringSettings connectionDetails = InputContext.GetConnectionDetails["updateSP"];
            if (connectionDetails == null)
            {
                throw new DynamicListException("Failed to get updateSP connection settings.");
            }
            _dbo = new Dbo(connectionDetails.ConnectionString);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="message"></param>
		protected void LogEvent( string message)
		{
			try
			{
				/*if ( filename.Length > 0 )
				{
                    string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
                    StreamWriter w = new StreamWriter(path + "\\" + filename,true);
                    DateTime dt = System.DateTime.Now;
                    w.WriteLine(dt.ToString() + "   " + message);
                    w.Close();
				}
				else
				{
					EventLog.WriteEntry(message);
				}*/
			}
			catch(Exception e)
			{
                System.Diagnostics.Debug.Write(e.Message);
			}
		}

        private struct dldata
        {
            public int id;
            public string siteurlname;
            public int publishstate;
            public string name;
            public string sXML;
        };

        /// <summary>
        /// 
        /// </summary>
		public void Process()
		{
            try
            { 
                Queue qdata = new Queue();
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("dynamiclistgetliststopublish"))
                {
                    //int id = InputContext.GetParamIntOrZero("id");
                    //dataReader.AddParameter("@listid", id);
                    dataReader.AddParameter("@siteurlname", InputContext.CurrentSite.SiteName);
                    dataReader.Execute();

                    while ( dataReader.Read() != false)
                    {
                        dldata item;
                        // Get list data
                        item.id = dataReader.GetInt32("Id");
                        item.siteurlname = dataReader.GetString("siteURLName");
                        item.publishstate = dataReader.GetInt32("PublishState");
                        item.name = dataReader.GetString("name");
                        item.sXML = dataReader.GetString("xml");
                        qdata.Enqueue(item);
                    }
                }
                
                //Process dynamic lists.
                foreach ( dldata ddata in qdata )
                {
                    if (ddata.publishstate == 1) // Publish
                    {
                        // Make SQL and updatesp
                        ListDefinition ld = new ListDefinition(ddata.siteurlname, ddata.sXML);

                        // Mark as published and create instance
                       
                         
                        _dbo.RegisterObjectString(ld.ToSQL());
                        using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("dynamiclistsetpublished"))
                        {
                            dataReader.AddParameter("@ID", ddata.id);
                            dataReader.AddParameter("@ListType", ld.xmlType);
                            dataReader.Execute();

                           LogEvent("The Dynamic List '" + ddata.name + "' was succesfully published");
                        }
                        
                    }
                    else if (ddata.publishstate == 3) // UnPublish
                    {
                        // remove instance, mark as unpublished
                       using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("dynamiclistsetunpublished"))
                        {
                            dataReader.AddParameter("@listname",  ddata.name);
                            dataReader.Execute();

                            //Delete sp
                            _dbo.DropObject("dlist" + ddata.name, true);

                            LogEvent("The Dynamic List '" + ddata.name + "' was succesfully unpublished");
                        }
                    }
                }
            }
            catch (Exception e)
            {
                // Database or sqlgen Error
                LogEvent(e.Message);
                throw new DynamicListException("Error publishing dynamic list: " + e.Message);
            }
		}
	}
}
