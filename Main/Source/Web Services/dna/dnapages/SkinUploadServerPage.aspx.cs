using System;
using System.IO;
using System.Web;
using System.Net;
using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;
using System.Xml;

public partial class SkinUploadServerPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Constructor for the Skin Upload Server Page
    /// </summary>
    public SkinUploadServerPage()
    {
        UseDotNetRendering = false;
    }

    /// <summary>
    /// Page type for this page
    /// </summary>
    public override string PageType
    {
        get { return "SKINUPLOADSERVER"; }
    }

    /// <summary>
    /// A page just for the administrators of the box
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.EditorAndAbove;
        }
    }

    public override void OnPageLoad()
    {
        AppContext.TheAppContext.Diagnostics.WriteToLog("SKINUPLOAD", "Start");
        AppContext.TheAppContext.Diagnostics.WriteToLog("SKINUPLOAD-UploadIP", Request.GetParamStringOrEmpty("__ip__", "Client IP Address"));

        string baseSkinPath = AppContext.TheAppContext.Config.GetSkinRootFolder();
        AppContext.TheAppContext.Diagnostics.WriteToLog("SKINUPLOAD-baseskinpath", baseSkinPath);

        string skinStubPath = Request.QueryString["skinstubpath"];
        AppContext.TheAppContext.Diagnostics.WriteToLog("SKINUPLOAD-skinstubpath", skinStubPath);

        string responseXml = String.Empty;
        responseXml = @"<SKINUPLOADSERVER>";

        string fullSkinPath = baseSkinPath + skinStubPath;
        responseXml += "<SKINSSAVED><PATH>" + fullSkinPath + "</PATH>";

        if (!Directory.Exists(fullSkinPath))
        {
            Directory.CreateDirectory(fullSkinPath);
        }

        foreach (string f in Request.Files.AllKeys)
        {
            HttpPostedFile file = Request.Files[f];

            file.SaveAs(fullSkinPath + "\\" + file.FileName);
            responseXml += "<FILENAME>" + file.FileName + "</FILENAME>";
            AppContext.TheAppContext.Diagnostics.WriteToLog("SKINUPLOAD-upload", file.FileName + " - TO -" + fullSkinPath);
        }
        responseXml += "</SKINSSAVED>";

        responseXml += "</SKINUPLOADSERVER>";
        XmlDocument uploadedResponse = new XmlDocument();
        uploadedResponse.LoadXml(responseXml);
        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(uploadedResponse.FirstChild, true));
        
        AppContext.TheAppContext.Diagnostics.WriteToLog("SKINUPLOAD", "Finish");
    }
}
