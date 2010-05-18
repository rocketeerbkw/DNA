<%@ Page Language="C#" AutoEventWireup="true" Inherits="System.Web.UI.Page" %>
<script runat="server">
    public string uid = "";
    public string siteName = "";
    public string title = "";
    public string parentUrl = "";
    public int itemsPerPage = 20;
    public int printEnv = 0;
    
    protected override void OnLoad(EventArgs e)
    {
        uid = Request.QueryString["uid"];
        siteName = Request.QueryString["sitename"];
        title = Request["title"];
        parentUrl = Request["parentUrl"];

        if (String.IsNullOrEmpty(uid) && Request.Cookies["uid"] != null)
        {
            uid = Request.Cookies["uid"].Value;
        }

        if (String.IsNullOrEmpty(siteName) && Request.Cookies["siteName"] != null)
        {
            siteName = Request.Cookies["siteName"].Value;
        }

        if (String.IsNullOrEmpty(title) && Request.Cookies["title"] != null)
        {
            title = Request.Cookies["title"].Value;
        }

        if (String.IsNullOrEmpty(parentUrl) && Request.Cookies["parentUrl"] != null)
        {
            parentUrl = Request.Cookies["parentUrl"].Value;
        }

        if (Request.Cookies["itemsPerPage"] != null && !Int32.TryParse(Request.Cookies["itemsPerPage"].Value, out itemsPerPage))
        {
            itemsPerPage = 20;
        }

        Int32.TryParse(Request["printenv"], out printEnv);
        
        if(IsPostBack)
        {
            title = txtTitle.Text;
            parentUrl = txtParentUrl.Text;
            if (!Int32.TryParse(txtItemsPerPage.Text, out itemsPerPage))
            {
                itemsPerPage = 20;
            }
        }
        else
        {

            txtTitle.Text = title;
            txtParentUrl.Text = parentUrl;
            txtItemsPerPage.Text = itemsPerPage.ToString();
        }


        AddCookie("uid", uid);
        AddCookie("siteName", siteName);
        AddCookie("title", title);
        AddCookie("parentUrl", parentUrl);
        AddCookie("itemsPerPage", itemsPerPage.ToString());
        
        base.OnLoad(e);
    }

    private void AddCookie(string name, string value)
    {
        HttpCookie cookie = new HttpCookie(name, value);
        cookie.Expires = DateTime.Now.AddHours(1);
        Response.Cookies.Add(cookie);
    }

</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Comment Box SSI Test Harness</title>
    <link rel="stylesheet" href="http://www.bbc.co.uk/blogs/mt-static/themes/bbc/css/main.css" type="text/css" />
    <link rel="stylesheet" href="http://www.bbc.co.uk/blogs/mt-static/themes/bbc/css/colours.css" type="text/css" />

    <%
        Response.Write("<!--#set var=\"blq_identity\" value=\"on\" -->\r\n" +
                       "<!--#include virtual=\"/includes/blq/include/blq_head.sssi\" -->\r\n" +
                       "<!--#include virtual=\"/dnaimages/components/commentbox/head/1.1/javascript.sssi\" -->");
     %>
     <!-- DNA Comments -->
<link rel="stylesheet" media="screen" href="http://www.bbc.co.uk/blogs/mt-static/themes/bbc/css/dna_comments.css" type="text/css" />
<!-- /DNA Comments -->

<link rel="stylesheet" href="http://www.bbc.co.uk/blogs/bbcinternet/localstyles.css" type="text/css" />
   
</head>
<body>
<%Response.Write("<!--#include virtual=\"/includes/blq/include/blq_body_first.sssi\" -->\r\n");%>

    <form id="form1" runat="server">
    <div>
        <table>
        <tr>
            <td>Uid :</td>
            <td><%= uid %></td>
        </tr>
        <tr>
            <td>Site Name :</td>
            <td><%= siteName %></td>
        </tr>
        <tr>
            <td>Title :</td>
            <td><asp:TextBox ID="txtTitle" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Parent Url :</td>
            <td><asp:TextBox ID="txtParentUrl" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Items per page :</td>
            <td><asp:TextBox ID="txtItemsPerPage" runat="server"></asp:TextBox></td>
        </tr>
        </table>
        <asp:button CausesValidation="true" ID="butSubmit" Text="Update" runat="server" />
    </div>
    
    </form>

<div style="width: 600px">
Comment SSI:<br />
    <%
        Response.Write("<!--#set var=\"dna.commentbox.servicename\" value=\"" + siteName + "\" -->\r\n" +
            "<!--#set var=\"dna.commentbox.dnauid\" value=\"" + uid + "\" -->\r\n" +
            "<!--#set var=\"dna.commentbox.title\" value=\"" + HttpUtility.UrlEncode(title) + "\" -->\r\n" +
            "<!--#set var=\"dna.commentbox.amountPerPage\" value=\"" + itemsPerPage + "\" -->\r\n" +
            "<!--#set var=\"dna.commentbox.commentProfileUrl\" value=\"http://www.bbc.co.uk/\" -->\r\n" +
            "<!--#set var=\"printenv\" value=\"1\" -->\r\n" +
            "<!--#include virtual=\"/dnaimages/components/commentbox/commentbox.sssi\"-->");
        
        /*int page =0;
        int dnafrom =0;
        int dnato =itemsPerPage;
        if(!String.IsNullOrEmpty(Request["page"]) && Int32.TryParse(Request["page"], out page))
        {
            dnafrom = page*itemsPerPage;
            dnato = (page++)*itemsPerPage;
            
        }
        if(!String.IsNullOrEmpty(Request["dnafrom"]) && Int32.TryParse(Request["dnafrom"], out dnafrom))
        {
        }

        if (!String.IsNullOrEmpty(Request["dnato"]) && Int32.TryParse(Request["dnato"], out dnato))
        {
        }
        
        Response.Write("<!--#set var=\"dna.commentbox.listRangeStart\" value=\"" + dnafrom + "\" -->\r\n" +
                "<!--#set var=\"dna.commentbox.listRangeEnd\" value=\"" + dnato + "\" -->\r\n");
         * */
        
    %>    
    </div>
    End of comment SSI<br />
    <%Response.Write("<!--#include virtual=\"/includes/blq/include/blq_body_last.sssi\" -->\r\n");%>
</body>
</html>
