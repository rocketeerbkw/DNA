<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MessageBoardStatsPage.aspx.cs" Inherits="MessageBoardStatsPage" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DNA - Message Board Statistics Page</title>
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
        <asp:Label ID="lblTitle" runat="server" Text="DNA - Message Board Statistics Page" Width="550px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label><br />
        <asp:Label ID="lblError" runat="server" Height="27px" Width="632px"></asp:Label><br />
        <asp:Label ID="lblEntryError" runat="server" Width="248px"></asp:Label>&nbsp;
        <table cellspacing="6" style="width: 631px">
            <tr>    
                <td>
                    <asp:Label ID="lblSearchParams" runat="server" Font-Bold="True" Text="Date To Search"></asp:Label>
                </td>
                <td>
                    <asp:Calendar ID="entryDate" runat="server" Font-Size="8pt" Height="156px" Width="229px" BackColor="White" BorderColor="#999999" CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" ForeColor="Black">
                        <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                        <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                        <SelectorStyle BackColor="#CCCCCC" />
                        <WeekendDayStyle BackColor="#FFFFCC" />
                        <OtherMonthDayStyle ForeColor="#808080" />
                        <NextPrevStyle VerticalAlign="Bottom" />
                        <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                        <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                    </asp:Calendar>
                </td>
            </tr>
        </table>
        <asp:Button ID="Search" runat="server" OnClick="Search_Click"
                        Text="Retrieve MessageBoard Statistics" Width="312px" /><br/>
        <br />
        <asp:Label ID="lblModStatsPerTopic" runat="server" Font-Bold="True" Text="Mod Stats Per Topic"></asp:Label>
        <br />
        <asp:Table ID="tblModStatsPerTopic" runat="server" Height="180px" Width="640px"></asp:Table>
        <br />
        <asp:Label ID="lblModStatsTopicTotals" runat="server" Font-Bold="True" Text="Mod Stats Topic Totals"></asp:Label>
        <br />
        <asp:Table ID="tblModStatsTopicTotals" runat="server" Height="180px" Width="640px"></asp:Table>
        <br />
        <asp:Label ID="lblHostsPostsPerTopic" runat="server" Font-Bold="True" Text="Hosts Posts Per Topic"></asp:Label>
        <br />
        <asp:Table ID="tblHostsPostsPerTopic" runat="server" Height="180px" Width="640px"></asp:Table>
        </div>
    </dna:form>
</body>
</html>
