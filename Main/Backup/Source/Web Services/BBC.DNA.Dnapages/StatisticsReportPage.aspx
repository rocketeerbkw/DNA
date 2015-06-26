<%@ Page Language="C#" AutoEventWireup="true" Inherits="StatisticsReportPage" Codebehind="StatisticsReportPage.aspx.cs" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DNA - Statistics Report</title>
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
        <asp:Label ID="lblTitle" runat="server" Text="DNA - Statistics Report Page" Width="440px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label><br />
        <asp:Label ID="lblError" runat="server" Height="27px" Width="632px"></asp:Label><br />
        <asp:Label ID="lblEntryError" runat="server" Width="248px"></asp:Label>&nbsp;
        <table cellspacing="6" style="width: 631px">
        <tr>
            <td style="width: 73px; height: 130px;">
                <asp:Label ID="lblDate" runat="server" Font-Bold="True" Height="22px" Text="Date"
                Width="71px"></asp:Label>
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
        <tr>
            <td style="width: 73px; height: 29px">
                <asp:Label ID="lblInterval" runat="server" Font-Bold="True" Height="22px" Text="Interval"
                    Width="71px"></asp:Label></td>
            <td style="width: 329px; height: 29px">
                <asp:DropDownList ID="interval" runat="server">
                    <asp:ListItem Value="1">Day</asp:ListItem>
                    <asp:ListItem Value="2">Week</asp:ListItem>
                    <asp:ListItem Value="3">Month</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        </table>
        <asp:Button ID="Search" runat="server" OnClick="Search_Click" Text="Retrieve Statistics"
            Width="226px"></asp:Button>
        <br />
        <asp:Button ID="btnFirst" runat="server" Font-Size="X-Small" Text="|<" OnClick="btnShowFirst"/>
        <asp:Button ID="btnPrevious" runat="server" Font-Size="X-Small" Text="<<" OnClick="btnShowPrevious"/>
        <asp:Label ID="lbPage" runat="server" Text="of #"></asp:Label>
        <asp:Button ID="btnNext" runat="server" Font-Size="X-Small" Text=">>" OnClick="btnShowNext"/>
        <asp:Button ID="btnLast" runat="server" Font-Size="X-Small" Text=">|" OnClick="btnShowLast"/><br />

        <asp:Table ID="tblResults" runat="server" Height="180px" Width="640px">
        </asp:Table>
        <asp:Button ID="btnFirst2" runat="server" Font-Size="X-Small" Text="|<" OnClick="btnShowFirst"/>
        <asp:Button ID="btnPrevious2" runat="server" Font-Size="X-Small" Text="<<" OnClick="btnShowPrevious"/>
        <asp:Label ID="lbPage2" runat="server" Text="of #"></asp:Label>
        <asp:Button ID="btnNext2" runat="server" Font-Size="X-Small" Text=">>" OnClick="btnShowNext"/>
        <asp:Button ID="btnLast2" runat="server" Font-Size="X-Small" Text=">|" OnClick="btnShowLast"/><br />
        <asp:Label ID="Count" runat="server" Text="" Width="288px"></asp:Label></div>
    </dna:form>
</body>
</html>
