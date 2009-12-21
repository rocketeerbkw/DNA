<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TypedArticlePage.aspx.cs" Inherits="TypedArticlePage" EnableViewState="false"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna"%>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DNA - Typed Article</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
<script runat="server" type="text/C#">
    private void UpdateASPXControls()
    {
        System.Xml.XmlNode errorNode = _basePage.WholePageBaseXmlNode.SelectSingleNode("//ERROR");
        if (errorNode != null)
        {
            //Message.Text = errorNode.SelectSingleNode(
        }
    }
    
// <!CDATA[
// ]]>
</script>
</head>
<body>
    <dna:form id="TypedArticleForm" runat="server">
        <br />
        <asp:Image ID="DnaImage" runat="server" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg" /><br />
        <br />
        <asp:Label ID="PageTitle" runat="server" Height="26px" Text="Typed Article" Width="100%" Font-Bold="True" Font-Size="X-Large"></asp:Label><br />
        <br />
        <div class="TemplateForm">
            <asp:Label ID="Message" Text="" runat="server" Visible="false"></asp:Label>
        </div>
    </dna:form>
</body>
</html>
