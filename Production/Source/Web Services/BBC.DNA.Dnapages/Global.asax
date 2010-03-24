<%@ Application Language="C#" %>

<script runat="server">
   
    void Application_Start(object sender, EventArgs e) 
    {
        // Uncomment this line to debug application start-up
        //System.Diagnostics.Debugger.Break();

        try
        {
            string rootPath = Server.MapPath(@"\");
            BBC.Dna.AppContext.OnDnaStartup(rootPath);
        }
        catch (Exception ex)
        {
            System.IO.StreamWriter sw = new System.IO.StreamWriter(Server.MapPath(@"\") + "OnDnaStartup-Errors.txt");
            sw.Write(ex.Message);
            sw.Close();
            
            throw;
        }
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown
    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs
    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started
    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }

    protected void Application_BeginRequest(object sender, EventArgs e)
    {
    }


    protected void Application_EndRequest(object sender, EventArgs e)
    {
    }
       
</script>
