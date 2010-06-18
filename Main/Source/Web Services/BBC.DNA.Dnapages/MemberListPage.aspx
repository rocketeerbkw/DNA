<%@ Page Language="C#" AutoEventWireup="true" Inherits="MemberListPage" Codebehind="MemberListPage.aspx.cs" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DNA - Member List Page</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <dna:form id="form1" runat="server" defaultbutton="Search" >
    <div>
        &nbsp;
        <asp:Image ID="Image1" runat="server" Height="48px" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg"
            Style="z-index: 114; left: 12px; position: absolute; top: 2px" Width="179px" />
        <br />
        <br />
        <br />
        <asp:Label ID="lblTitle" runat="server" Text="DNA - Member List Page" Width="440px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label><br />
        <asp:Label ID="lblError" runat="server" Height="27px" Width="632px"></asp:Label><br />
        <asp:Label ID="lblEntryError" runat="server" Width="248px"></asp:Label>
        <table cellspacing="6" style="width: 634px">
        <tr><td style="width: 73px; height: 29px">
        <asp:Label ID="lblSearchParams" runat="server" Font-Bold="True" Text="Search Details"></asp:Label>
        </td>
        <td style="width: 227px; height: 29px">
        <asp:TextBox ID="txtEntry" runat="server" Width="367px"></asp:TextBox>
        </td>
        <td style="width: 153px; height: 29px"><asp:Button ID="Search" runat="server" OnClick="Search_Click"
                        Text="Search for Users" Width="150px" /></td></tr>
        <tr><td style="width: 73px">
        <asp:Label ID="lblSearchBy" Font-Bold="True" runat="server" Height="35px" Text="Search by" Width="64px"></asp:Label>
        </td><td colspan="2">
        <asp:RadioButtonList ID="rdSearchType" runat="server" Height="67px" Font-Size="X-Small" RepeatColumns="2" Width="310px">
            <asp:ListItem Selected="True">User ID</asp:ListItem>
            <asp:ListItem>Email</asp:ListItem>
            <asp:ListItem>User Name</asp:ListItem>
            <asp:ListItem>IP Address</asp:ListItem>
            <asp:ListItem>BBCUID</asp:ListItem>
            <asp:ListItem>Login Name</asp:ListItem>
        </asp:RadioButtonList>
        </td></tr>
        </table>
        <br/>
        <div style="padding:10px; float:left">
            <asp:Label ID="lblAction" runat="server" Font-Bold="True" Text="Moderation Action"/><br />
            <asp:DropDownList
                ID="UserStatusDescription" runat="server" SelectedValue='<%# Eval("UserStatusDescription") %>' OnSelectedIndexChanged="UserStatusDescription_SelectedIndexChanged" AutoPostBack="True" CausesValidation="True">
                <asp:ListItem Selected="True" Value="Standard">Standard</asp:ListItem>
                <asp:ListItem Value="Premoderate">Premoderate</asp:ListItem>
                <asp:ListItem Value="Postmoderate">Postmoderate</asp:ListItem>
                <asp:ListItem Value="Restricted">Banned</asp:ListItem>
            </asp:DropDownList>&nbsp;
            <asp:DropDownList ID="Duration" runat="server" Enabled="True" SelectedValue='<%# Bind("PrefStatusDuration") %>'>
                <asp:ListItem Selected="True" Value="0">no limit</asp:ListItem>
                <asp:ListItem Value="1440">1 day</asp:ListItem>
                <asp:ListItem Value="10080">1 week</asp:ListItem>
                <asp:ListItem Value="20160">2 weeks</asp:ListItem>
                <asp:ListItem Value="40320">1 month</asp:ListItem>
            </asp:DropDownList>&nbsp;
            <asp:Button ID="ApplyAction" runat="server" OnClick="ApplyAction_Click"
                Text="Apply action to marked accounts" Height="24px" />
        </div>
        
        <div style="padding:10px;float:right">
            <p>
            <asp:Button ID="ApplyNickNameReset" runat="server" OnClick="ApplyResetUserName_Click"
            Text="Reset Username to marked accounts" Height="24px" />
            </p>
        </div>
        <br />
        <asp:Table ID="tblResults" runat="server" Height="180px" Width="640px">
        </asp:Table>
        <asp:Label ID="Count" runat="server" Text="" Width="288px"></asp:Label></div>
    </dna:form>
</body>
</html>
