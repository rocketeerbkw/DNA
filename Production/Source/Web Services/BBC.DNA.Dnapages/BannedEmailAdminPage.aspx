<%@ Page Language="C#" AutoEventWireup="true" Inherits="BannedEmailAdminPage" Codebehind="BannedEmailAdminPage.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna"%>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DNA - Banned Emails Admin Page</title>
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
        <asp:Label ID="namespacelable" runat="server" Height="26px" Text="Banned EMails" Width="100%" Font-Bold="True" Font-Size="X-Large"></asp:Label><br />
        <br />
        <asp:Button ID="Button1" runat="server" Text="Add Email" OnClick="btnAdd_Click" />
        <asp:TextBox ID="tbNewEmail" runat="server" Width="232px"></asp:TextBox>
        <asp:CheckBox ID="cbNewSignInBanned" runat="server" text="Banned from signing in" Checked="true"/>
        <asp:CheckBox ID="cbNewComplaintBanned" runat="server" text="Banned from complaining" Checked="true"/>
        <br />
        <asp:Literal ID="padding1" runat="server" Visible="False" Text="<BR/>"></asp:Literal><asp:Label ID="lbMessage" runat="server" Text="message" Font-Bold="true"
            Visible="False"></asp:Label><asp:Literal ID="padding2" runat="server" Visible="False" Text="<BR/>"></asp:Literal>
        <asp:Literal ID="Literal1" runat="server" Visible="False" Text="<BR/>"></asp:Literal><asp:Label ID="Label1" runat="server" Text="message" Font-Bold="true"
            Visible="False"></asp:Label><asp:Literal ID="Literal2" runat="server" Visible="False" Text="<BR/>"></asp:Literal>
        <br />
        <asp:Button ID="btnA" runat="server" Text="A" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnB" runat="server" Text="B" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnC" runat="server" Text="C" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnD" runat="server" Text="D" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnE" runat="server" Text="E" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnF" runat="server" Text="F" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnG" runat="server" Text="G" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnH" runat="server" Text="H" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnI" runat="server" Text="I" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnJ" runat="server" Text="J" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnK" runat="server" Text="K" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnL" runat="server" Text="L" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnM" runat="server" Text="M" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnN" runat="server" Text="N" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnO" runat="server" Text="O" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnP" runat="server" Text="P" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnQ" runat="server" Text="Q" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnR" runat="server" Text="R" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnS" runat="server" Text="S" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnT" runat="server" Text="T" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnU" runat="server" Text="U" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnV" runat="server" Text="V" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnW" runat="server" Text="W" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnX" runat="server" Text="X" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnY" runat="server" Text="Y" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnZ" runat="server" Text="Z" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnAll" runat="server" Text="All" OnClick="btnViewByLetter" EnableViewState="False" />
        <asp:Button ID="btnMostRecent" runat="server" Text="Most Recent" OnClick="btnViewMostRecent" />
        <br /><br />
        Show&nbsp;<asp:RadioButton ID="rbFilterAll" runat="server" GroupName="Filter" Text="All" AutoPostBack="true" OnCheckedChanged="rbFilterChanged" Checked="true"/>
        <asp:RadioButton ID="rbFilterSignIn" runat="server" GroupName="Filter" Text="Banned from sign in" AutoPostBack="true" OnCheckedChanged="rbFilterChanged"/>
        <asp:RadioButton ID="rbFilterComplaint" runat="server" GroupName="Filter" Text="Banned from complaint" AutoPostBack="true" OnCheckedChanged="rbFilterChanged"/>
        <br /><br/>
        <asp:Button ID="btnFirst" runat="server" Font-Size="X-Small" Text="|<" OnClick="btnShowFirst"/>
        <asp:Button ID="btnPrevious" runat="server" Font-Size="X-Small" Text="<<" OnClick="btnShowPrevious"/>
        <asp:Label ID="lbPage" runat="server" Text="of #"></asp:Label>
        <asp:Button ID="btnNext" runat="server" Font-Size="X-Small" Text=">>" OnClick="btnShowNext"/>
        <asp:Button ID="btnLast" runat="server" Font-Size="X-Small" Text=">|" OnClick="btnShowLast"/><br />
        <asp:Table ID="tblBannedEmails" runat="server" Height="26px" CssClass="postForm" CellPadding="2" EnableViewState="true">
        </asp:Table>
        <asp:Button ID="btnFirst2" runat="server" Font-Size="X-Small" Text="|<" OnClick="btnShowFirst"/>
        <asp:Button ID="btnPrevious2" runat="server" Font-Size="X-Small" Text="<<" OnClick="btnShowPrevious"/>
        <asp:Label ID="lbPage2" runat="server" Text="of #"></asp:Label>
        <asp:Button ID="btnNext2" runat="server" Font-Size="X-Small" Text=">>" OnClick="btnShowNext"/>
        <asp:Button ID="btnLast2" runat="server" Font-Size="X-Small" Text=">|" OnClick="btnShowLast"/><br />
        <asp:Label ID="lbTotalResults" runat="server" Text="0" Visible="False"></asp:Label>
    </div>
    </dna:form>
</body>
</html>
