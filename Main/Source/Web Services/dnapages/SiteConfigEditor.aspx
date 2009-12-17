<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SiteConfigEditor.aspx.cs" Inherits="SiteConfigEditor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna"%>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DNA - Site Config Editing Page</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
// <!CDATA[

// ]]>
</script>
</head>
<body>
    <dna:form id="form1" runat="server">
        <asp:Image ID="Image2" runat="server" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg" /><br />
        <br />
        <asp:Label ID="lbEditingSite" runat="server" Height="26px" Text="Site Config Editor For" Width="100%" Font-Bold="True" Font-Size="X-Large"></asp:Label><br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Select a section to edit"></asp:Label>
        <asp:DropDownList ID="dlbConfigSections" runat="server" OnSelectedIndexChanged="dlbConfigSections_SelectedIndexChanged" AutoPostBack="True">
        </asp:DropDownList>
        <asp:Button ID="btUpdateSection" runat="server" Text="Update Section" OnClick="btUpdateSection_Click" />
        <asp:Button ID="btRemove" runat="server" Text="Remove Section" OnClick="btRemove_Click" OnClientClick="return confirm('Are you sure want to remove this section?');" /><br /><br />
        <asp:TextBox ID="tbSectionXML" runat="server" Height="300px" Width="100%" Wrap="true" EnableViewState="False" TextMode="MultiLine"></asp:TextBox><br />
        <br />
        <asp:Label ID="Lable2" runat="server" Text="Add new section"></asp:Label>
        <asp:TextBox ID="tbNewSection" runat="server" Height="19px" Width="200px" Wrap="true" EnableViewState="False"></asp:TextBox>
        <asp:Button ID="btAddSection" runat="server" Text="Add Section" OnClick="btAddSection_Click" /><br />
        <br />
        <asp:Button ID="btUpdate" runat="server" Text="Update Config with Section Edits" OnClick="btUpdate_Click" OnClientClick="return confirm('Are you sure want to update the site config with the new changes?');" />
        <br /><br />
        <asp:Label ID="message" runat="server" Text="Add new section"></asp:Label>
        <br /><br />
        <asp:Button ID="reloadPage" runat="server" Text="Reload Page" OnClick="OnReloadPage" OnClientClick="return confirm('Are you sure you want to reload? All edits will be lost if you continue.');"/>
    </dna:form>
</body>
</html>
