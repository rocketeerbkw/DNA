<%@ Page Language="C#" AutoEventWireup="true" Inherits="NameSpaceAdminPage" Codebehind="NameSpaceAdminPage.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna"%>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DNA - Namespace Admin Page</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
// <!CDATA[

// ]]>
</script>
</head>
<body>
    <dna:form id="form1" runat="server">
    <div>
        <br />
        <asp:Image ID="Image2" runat="server" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg" /><br />
        <br />
        <asp:Label ID="namespacelable" runat="server" Height="26px" Text="Namespaces for site" Width="550px" Font-Bold="True" Font-Size="X-Large"></asp:Label><br />
        <br />
        <asp:Label ID="txtWarning" runat="server" Visible="False" Text="Warning" Height="1px" Width="100%" EnableViewState="False" ForeColor="Red"></asp:Label><br />
        <asp:Table ID="tblNameSpaces" runat="server" Height="214px" Width="550px" CssClass="postForm">
        </asp:Table>
        <br />
        Create new namespace
        <asp:TextBox ID="tbNewName" runat="server" Width="232px"></asp:TextBox>
        <asp:Button ID="btnCreate" runat="server" OnClick="btnCreate_Click" Text="Create" /><br />
        <br />
        </div>
    </dna:form>
</body>
</html>
