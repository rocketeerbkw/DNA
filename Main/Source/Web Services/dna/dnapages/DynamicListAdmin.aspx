<%@ Page language="c#" Inherits="DynamicListAdmin" CodeFile="DynamicListAdmin.aspx.cs" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Dynamic List Administration</title>
		<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
        <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
  </HEAD>
	<body>
		<dna:form id="Form1" method="post" runat="server">&nbsp;<asp:label id="lblTitle" style="Z-INDEX: 100; LEFT: 24px; POSITION: absolute; TOP: 72px" runat="server"
				Width="744px" Height="32px" Font-Size="Large" Font-Bold="True" BackColor="Transparent" ForeColor="Black">Dynamic List Management for</asp:label>
			<asp:HyperLink id=HyperLinkNewList style="Z-INDEX: 101; LEFT: 24px; POSITION: absolute; TOP: 112px" runat="server" Width="184px" Height="24px" NavigateUrl="EditDynamicListDefinition">Create New List</asp:HyperLink>
            <asp:Label ID="lblError" runat="server" Height="24px" Style="z-index: 102; left: -14px;
                position: relative; top: 144px" Visible="False" Width="584px"></asp:Label>
            <asp:Table ID="tblDynamicLists" runat="server" Height="160px" Style="z-index: 103; left: 0px;
                position: relative; top: 152px" Width="736px" CssClass="postItems">
            </asp:Table>
            <asp:Image ID="Image1" runat="server" Height="48px" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg"
                Style="z-index: 104; left: 32px; position: absolute; top: 8px" Width="179px" />
            <asp:HyperLink ID="HyperLinkReActivate" runat="server" Height="24px" NavigateUrl="~/DynamicListAdmin?reactivatelists=1"
                Style="z-index: 106; left: 272px; position: absolute; top: 112px" Width="304px">ReActivate Lists ( All Sites )</asp:HyperLink>
		</dna:form>
	</body>
</HTML>
