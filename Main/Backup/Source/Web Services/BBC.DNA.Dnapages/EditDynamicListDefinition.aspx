<%@ Page Language="C#" AutoEventWireup="true" Inherits="EditDynamicListDefinition" Codebehind="EditDynamicListDefinition.aspx.cs" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>
<%@ PreviousPageType VirtualPath="~/DynamicListAdmin.aspx"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Edit Dynamic Lists</title>
    <link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
</head>
<body>  
    <dna:form id="form1" runat="server">
    <div>
        <table>
        <tr><td colspan="4">
        <asp:CustomValidator ID="CustomValidator" runat="server" ErrorMessage="Insufficient permissions - Editor Status Required" Style="z-index: 107; left: 0px; position: relative; top: 0px;" Width="432px"></asp:CustomValidator>
        <asp:RangeValidator ID="RatingValidator" runat="server" ControlToValidate="txtRating" ErrorMessage="Enter a rating > 0 or leave blank," style="z-index: 117; position: relative; left: 32px; top: 0px;" MaximumValue="999999" MinimumValue="0"></asp:RangeValidator>
        <asp:CustomValidator ID="DateValidator" runat="server" ErrorMessage="CustomValidator" style="z-index: 118; position: relative">Date Updated should be more recent than Date Created.</asp:CustomValidator>
        <asp:CustomValidator ID="ArticleTypeValidator" runat="server" ErrorMessage="Please enter a valid article type for the selected object." style="z-index: 129; position: relative"></asp:CustomValidator>
        <asp:CustomValidator ID="UIDValidator" runat="server" ErrorMessage="UID filter only appropriate for Comment Forums." style="z-index: 129; position: relative"></asp:CustomValidator>
        </td></tr>
        <tr><td style="width: 352px" colspan="2">
            <asp:Label ID="Label1" runat="server" Text="List Name" style="z-index: 100; position: relative" Width="136px"></asp:Label></td>
            <td style="width: 588px" colspan="2">
            <asp:TextBox ID="txtName" runat="server" Width="240px" style="z-index: 101; position: relative" Height="22px" ToolTip="Enter a Unique name to identify Dynamic List"></asp:TextBox></td>
        </tr><tr><td colspan="4">
            <asp:RequiredFieldValidator ID="NameReqValidator" runat="server" ControlToValidate="txtName" ErrorMessage="Please Enter a unique name." style="z-index: 102; position: relative" Width="320px"></asp:RequiredFieldValidator>  
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtName" Display="Dynamic" ErrorMessage="Characters A-Z, a-z and 0-9 only" Style="z-index: 145; position: relative" ValidationExpression="\w+" Width="464px"></asp:RegularExpressionValidator>
        </td></tr>
        <tr><td style="width: 352px" colspan="2">
        <asp:Label ID="Label2" runat="server" Text="Object" style="z-index: 103; position: relative" Width="144px"></asp:Label></td>
       <td style="width: 588px" colspan="2"><asp:DropDownList ID="cmbType" runat="server" Width="240px" style="z-index: 104; position: relative" Height="22px" ToolTip="Select type of data "></asp:DropDownList></td>
        </tr>
        <tr><td colspan="2">
        <asp:Label ID="Label3" runat="server" Text="Sort Order" style="z-index: 105; position: relative" Width="144px"></asp:Label>
       </td><td colspan="2">
       <asp:DropDownList ID="cmbSort" runat="server" Width="240px" style="z-index: 106; position: relative" Height="22px" ToolTip="Choose the sort order of the data">
        </asp:DropDownList>
        </td></tr>
        <tr>
        <td style="width: 291px">
        <asp:Label ID="Label4" runat="server" Text="Average Rating Greater Than" style="z-index: 108; position: relative" Height="24px" Width="240px"></asp:Label>
        </td><td style="width: 257px">
        <asp:TextBox ID="txtRating" runat="server" style="z-index: 109; position: relative;" Height="22px" Width="184px" ToolTip="Filter on User Poll - Average Rating"></asp:TextBox>
        </td><td style="width: 330px">
        <asp:Label ID="Label5" runat="server" Text="Significance Greater than" style="z-index: 110; position: relative" Width="176px"></asp:Label>&nbsp; &nbsp; &nbsp;
        </td><td style="width: 595px">
        <asp:TextBox ID="txtSignificance" runat="server" Width="176px" style="z-index: 111; position: relative;" Height="22px" ToolTip="Select a Zeitgeist significance > 0 "></asp:TextBox>
        <asp:RangeValidator ID="SignificanceValidator" runat="server" ControlToValidate="txtSignificance"
            ErrorMessage="RangeValidator" style="z-index: 112; position: relative" MaximumValue="999999" MinimumValue="0">Enter a significance > 0</asp:RangeValidator>
        </td></tr>
        <tr><td>
        <asp:Label ID="Label6" runat="server" Text="Vote Count Greater Than" Height="24px" Width="328px" style="z-index: 113; position: relative"></asp:Label>&nbsp;
        </td><td>
        <asp:TextBox ID="txtVoteCount" runat="server" style="z-index: 128; position: relative" Height="22px" Width="184px" ToolTip="Filter on Vote Count"></asp:TextBox>
        </td><td>
        <asp:Label ID="Label20" runat="server" Text="Bookmark Count Greater Than" Height="24px" Width="264px" style="z-index: 113; position: relative"></asp:Label>&nbsp;
        </td><td>
        <asp:TextBox ID="txtBookmarkCount" runat="server" style="z-index: 128; position: relative" Height="22px" Width="184px" ToolTip="Filter on Bookmark Count"></asp:TextBox>
        </td></tr>
        <tr><td>
        <asp:Label ID="Label7" runat="server" Text="Date Created (Days Old)" style="z-index: 115; position: relative" Width="328px"></asp:Label>
        </td><td>
        <asp:TextBox ID="txtDateCreated" runat="server" style="z-index: 114; position: relative" Height="22px" Width="184px" ToolTip="Filter on Date Created in days relative to current date."></asp:TextBox>
        </td><td>
        <asp:Label ID="Label11" runat="server" Text="Date Updated (Days old)" style="z-index: 127; position: relative" Width="256px"></asp:Label>
        </td><td>
        <asp:TextBox ID="txtLastUpdated" runat="server" style="z-index: 116; position: relative" Height="22px" Width="184px" ToolTip="Filter on last updated in days relative to current date"></asp:TextBox>
        </td></tr>
        <tr><td>
        <asp:Label ID="Label8" runat="server" Text="Article Type" style="z-index: 119; position: relative" Width="328px"></asp:Label>
        </td><td>
        <asp:TextBox ID="txtArticleType" runat="server" style="z-index: 120; position: relative" Height="22px" Width="184px" ToolTip="Filter on Article Type ( 0 - 1000 ) for articles, ( 1000 - 2000 ) for clubs"></asp:TextBox>
        </td><td>
        <asp:Label ID="Label9" runat="server" Text="Article Status" style="z-index: 121; position: relative" Width="264px"></asp:Label>
        </td><td>
        <asp:DropDownList ID="cmbStatus" runat="server" style="z-index: 122; position: relative" Height="22px" Width="184px" ToolTip="Filter on article status">
        </asp:DropDownList>
        </td></tr>
        <tr>
        <td>
        <asp:Label ID="Label10" runat="server" Text="Thread Type" style="z-index: 123; position: relative;" Width="328px"></asp:Label>
        </td><td>
        <asp:TextBox ID="txtThreadType" runat="server" style="z-index: 124; position: relative" Height="22px" Width="184px" ToolTip="Enter a Thread Type Id eg Notice=2 , Event=3"></asp:TextBox>
        </td><td>
        <asp:Label ID="Label12" runat="server" Text="Event Date not older than" style="z-index: 125; position: relative" Width="256px"></asp:Label>
        </td><td>
        <asp:TextBox ID="txtEventDate" runat="server" style="z-index: 126; position: relative;" Height="22px" Width="176px" ToolTip="Filter for Thread Type Event"></asp:TextBox><br />
        </td></tr>
        <tr><td><asp:Label ID="LblUID" runat="server" Text="Comment Forum UID Prefix" style="z-index: 123; position: relative;" Width="328px"></asp:Label></td>
        <td><asp:TextBox ID="txtCommentForumUIDPrefix" runat="server" Height="22px" Width="176px" /></td></tr>
        <tr>
        <td>
        <asp:Label ID="Label15" runat="server" Style="z-index: 136; position: relative" Text="Article Date Range Start" Width="149px"></asp:Label>
        </td><td>
        <table id="tblStartCalender" style="z-index: 151; position: relative; width: 184px;" cellspacing="0" cellpadding="0" border="0">
        <tr>
        <td align="left" bgcolor="#cccccc" style="height: 19px"> <asp:DropDownList ID="cmbStartMonth" Font-Size="8pt" runat="server" OnSelectedIndexChanged="cmbStartMonth_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList></td>
        <td align="right" bgcolor="#cccccc" style="height: 19px; width: 245px;"> <asp:DropDownList ID="cmbStartYear" Font-Size="8pt" runat="server" OnSelectedIndexChanged="cmbStartYear_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList></td></tr>
        <tr><td colspan="2">
        <asp:Calendar ID="CalStartDate" runat="server" BackColor="White" BorderColor="#999999" Width="99%" Height="97%"
            CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt"
            ForeColor="Black" Style="z-index: 147;"  ShowTitle="False" OnSelectionChanged="CalStartDate_SelectionChanged" ToolTip="Additional date filtering if article has date range specified">
            <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
            <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
            <SelectorStyle BackColor="#CCCCCC" />
            <WeekendDayStyle BackColor="#FFFFCC" />
            <OtherMonthDayStyle ForeColor="Gray" />
            <NextPrevStyle VerticalAlign="Bottom" />
            <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
            <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
        </asp:Calendar>
        </td></tr>
        <tr><td><asp:Label ID="lblStartDate" runat="server" Font-Size="8pt" Text="No Start Date"/></td><td align="right"><asp:Button ID="btnClearStartDate" runat="server" Text="clear" Font-Size="8pt" OnClick="btnClearStartDate_Click" /></td></tr>
        </table>
        </td><td>
         <asp:Label ID="Label16" runat="server" Style="z-index: 138; position: relative" Text="Article Date Range End" Width="132px"></asp:Label>
        </td><td>
         <table id="tblEndCalender" style="z-index: 152; position: relative; width: 184px;" cellspacing="0" cellpadding="0" border="0">
        <tr>
        <td align="left" bgcolor="#cccccc" style="height: 19px"> <asp:DropDownList ID="cmbEndMonth" Font-Size="8pt" runat="server" OnSelectedIndexChanged="cmbEndMonth_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList></td>
        <td align="right" bgcolor="#cccccc" style="height: 19px; width: 245px;"> <asp:DropDownList ID="cmbEndYear" Font-Size="8pt" runat="server" OnSelectedIndexChanged="cmbEndYear_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList></td></tr>
        <tr><td colspan="2">
        <asp:Calendar ID="CalEndDate" runat="server" BackColor="White" BorderColor="#999999"
            CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt"
            ForeColor="Black" Style="z-index: 148;" 
            Width="184px" ShowTitle="False" OnSelectionChanged="CalEndDate_SelectionChanged" ToolTip="Additional filtering if article has a date range specified.">
            <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
            <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
            <SelectorStyle BackColor="#CCCCCC" />
            <WeekendDayStyle BackColor="#FFFFCC" />
            <OtherMonthDayStyle ForeColor="Gray" />
            <NextPrevStyle VerticalAlign="Bottom" />
            <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
            <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
        </asp:Calendar>
        </td></tr>
        <tr><td style="height: 20px"><asp:Label ID="lblEndDate" runat="server" Font-Size="8pt" Text="No End Date"/></td><td align="right" style="height: 20px"><asp:Button ID="btnClearEndDate" runat="server" Text="clear" Font-Size="8pt" OnClick="btnClearEndDate_Click"/></td></tr></table>
        </td>
        </tr>
        <tr><td>
        <asp:Label ID="Label13" runat="server" Text="Key Phrases" style="z-index: 130; position: relative"></asp:Label>
        </td><td>
        <asp:ListBox ID="lstKeyPhrases" runat="server" Height="152px" Width="184px" style="z-index: 131; position: relative"></asp:ListBox>
        </td><td>
        <asp:Label ID="Label18" runat="server" Style="z-index: 148; position: relative" Text="Phrase" Width="88px"></asp:Label>
        <asp:TextBox ID="txtKeyPhrases" runat="server" style="z-index: 132; position: relative" ToolTip="Add a keyphrase filter" Width="152px"></asp:TextBox>
        <asp:Label ID="Label17" runat="server" Style="z-index: 147; position: relative" Text="NameSpace" Width="88px"></asp:Label>
        <asp:DropDownList ID="cmbNameSpaces" runat="server" Style="z-index: 133; position: relative" Width="160px">
        </asp:DropDownList>
         <asp:CustomValidator ID="valKeyPhrases" runat="server" ErrorMessage="Unable to parse phrase and namespace."
             Style="z-index: 153; position: relative" Width="224px"></asp:CustomValidator> 
        </td><td>
        <asp:Button ID="btnAddKeyPhrase"
            runat="server" Text="Add" OnClick="btnAddKeyPhrase_Click" Width="97px" style="z-index: 134; position: relative;" Height="27px" /><br />
            <asp:Button ID="btnRemoveKeyPhrase" runat="server" Text="Remove" OnClick="btnRemoveKeyPhrase_Click" style="z-index: 135; position: relative" Height="27px" Width="97px" /> 
        </td></tr>
        <tr><td>
        <asp:Label ID="Label14" runat="server" Text="Categories" style="z-index: 137; position: relative"></asp:Label>&nbsp;&nbsp;&nbsp;
       </td><td>
         <asp:ListBox ID="lstCategories" runat="server" Height="96px" Width="184px" style="z-index: 146; position: relative"></asp:ListBox>
         </td><td>
         <asp:Label ID="Label19" runat="server" Style="z-index: 149; position: relative" Text="CategoryId" Width="104px"></asp:Label>
         <asp:TextBox ID="txtAddCategory" runat="server" style="z-index: 139; position: relative" ToolTip="Enter a category id to filter on specified category nodes." Width="144px"></asp:TextBox>
          <asp:RangeValidator ID="CategoryValidator" runat="server" ControlToValidate="txtAddCategory"
            ErrorMessage="RangeValidator" MaximumValue="999999" MinimumValue="0" Type="Integer" style="z-index: 142; position: relative">Enter Category Id</asp:RangeValidator>
        </td><td>
        <asp:Button ID="btnAddCategory" runat="server" Text="Add" OnClick="btnAddCategory_Click" Width="97px" style="z-index: 140; position: relative" Height="27px" /><br />
        <asp:Button ID="btnRemoveCategory" runat="server" Text="Remove" OnClick="btnRemoveCategory_Click" style="z-index: 141; position: relative" Height="27px" Width="97px" />
        </td></tr>
        <tr>
        <td colspan="4" align="right">
        <asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_Click" Text="Cancel" Width="97px" style="z-index: 144; position: relative" Height="27px" />
        <asp:Button ID="btnUpdate" runat="server" OnClick="btnUpdate_Click" Text="Update" Width="97px" style="z-index: 143; position: relative" Height="27px" />
        </td></tr>
        </table>
        </div>
    </dna:form>
</body>
</html>
