<%@ Page Language="C#" AutoEventWireup="true" Inherits="ArticleHistoryPage" Codebehind="ArticleHistoryPage.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>DNA - Article History Page</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1
        {
            height: 29px;
            width: 73px;
        }
        .style2
        {
            width: 73px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" defaultbutton="Search" >
    <div>
        &nbsp;
        <asp:Image ID="Image1" runat="server" Height="48px" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg"
            Style="z-index: 114; left: 12px; position: absolute; top: 2px" Width="179px" />
        <br />
        <br />
        <br />
        <asp:Label ID="lblTitle" runat="server" Text="DNA - Article History Page" Width="440px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label><br />
        <asp:Label ID="lblError" runat="server" Height="27px" Width="632px"></asp:Label><br />
        <asp:Label ID="lblEntryError" runat="server" Width="248px"></asp:Label>
        <table cellspacing="6" style="width: 634px">
        <tr><td class="style1">
        <asp:Label ID="lblSearchParams" runat="server" Font-Bold="True" Text="Search Details"></asp:Label>
        </td>
        <td style="width: 227px; height: 29px">
        <asp:TextBox ID="txtEntry" runat="server" Width="367px"></asp:TextBox>
        </td>
        <td style="width: 153px; height: 29px">
            <asp:Button ID="Search" runat="server" OnClick="Search_Click"
                        Text="Search for article" Width="150px" /></td></tr>
        </table>
        <asp:Label ID="lblArticleSubject" runat="server" Font-Bold="True" 
            Font-Names="Times New Roman" Font-Size="X-Large" Text="Article Subject"></asp:Label>
        <br/>
        <br />
        <asp:Table ID="tblResults" runat="server" Height="180px" Width="640px">
        </asp:Table>
        <asp:Label ID="Count" runat="server" Text="" Width="288px"></asp:Label></div>
    </form>
</body>
</html>
