using System;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;
using BBC.Dna.Page;
using BBC.Dna;

public partial class TypedArticlePage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public TypedArticlePage()
    {
        UseDotNetRendering = true;
        SetDnaXmlDataSource = true;
    }

    /// <summary>
    /// Sets the type of the page
    /// </summary>
    public override string PageType
    {
        get { return "TYPEDARTICLE"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // See if we're wanting .net rendering?
        Context.Items["VirtualUrl"] = "NewTypedArticle";

        // Add the typed article object to the page
        AddComponent(new TypedArticle(_basePage));
    }

    /// <summary>
    /// Check to see if we need to update anything after the process request
    /// </summary>
    public override void OnPostProcessRequest()
    {
        // Only do the following if we're doing dotnet rendering
        if (UseDotNetRendering)
        {
            //UpdateASPXControls();
        }
    }

    /// <summary>
    /// Set the page so any user can use it
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.Any; }
    }
}
