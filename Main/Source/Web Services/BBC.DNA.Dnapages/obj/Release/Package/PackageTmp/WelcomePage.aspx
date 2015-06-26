<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WelcomePage.aspx.cs" Inherits="BBC.DNA.Dnapages.WelcomePage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DNA Welcome Page</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
// <!CDATA[

// ]]>
</script>
</head>
<body>
    <form id="form2" runat="server">
    <div>
    
    </div>
    Site Description :
    <asp:Label ID="SiteDescription" runat="server" Text="{description}"></asp:Label>
    <br />
    Site Url Name :
    <asp:Label ID="SiteURLName" runat="server" Text="{name}"></asp:Label>
    <br />
    Site ID :
    <asp:Label ID="SiteID" runat="server" Text="{id}"></asp:Label>
    <br />
    <br />
    Login Name :
    <asp:Label ID="UserLoginName" runat="server" Text="{loginname}"></asp:Label>
    <br />
    Display Name :
    <asp:Label ID="UserDisplayName" runat="server" Text="{displayname}"></asp:Label>
    <br />
    DNA User ID :
    <asp:Label ID="UserID" runat="server" Text="{dnauserid}"></asp:Label>
    <br />
    <br />
    <asp:PlaceHolder ID="SuperUserStatus" runat="server"></asp:PlaceHolder>
    <br />
    <asp:PlaceHolder ID="EditorSiteList" runat="server"></asp:PlaceHolder>
    <br />
    </form>
</body>
</html>
