<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SiteSummaryPage.aspx.cs" Inherits="SiteSummaryPage" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Site Summary</title>
    <link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <dna:Form id="form1" runat="server">
    <div>
        <br />
        <asp:Image ID="Image1" runat="server" Height="48px" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg"
            Style="z-index: 114; left: 16px; position: absolute; top: 40px" Width="179px" />
        <br />
        <br />
        <br />
        <br />
        <asp:Label ID="Label1" runat="server" Text="Start Date:" Width="100px"></asp:Label>
        <asp:TextBox ID="txtStartDate" runat="server" Width="120px"></asp:TextBox>
        <asp:Label ID="Label2" runat="server" Text="End Date:" Width="100px"></asp:Label>
        <asp:TextBox ID="TxtEndDate" runat="server" Width="120px"></asp:TextBox>&nbsp;<asp:Button
            ID="btnSubmit" runat="server" Text="Submit" /><br />
        <br />
        <br />
        <asp:GridView ID="SiteSummaryList" runat="server" AutoGenerateColumns="false" CellPadding="2" BorderStyle="None" GridLines="None">
        <Columns>
            <asp:TemplateField HeaderText="" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Width="100%">
                <ItemTemplate>
                    <asp:Label ID="PostTotal" runat="server" Text='<%# XPath("./POSTSUMMARY/POSTTOTAL") %>' Width="120" ></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        </asp:GridView>
        
    
    </div>
    </dna:Form>
</body>
</html>

