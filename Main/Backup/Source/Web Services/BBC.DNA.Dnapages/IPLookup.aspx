<%@ Page Language="C#" AutoEventWireup="true" Inherits="IPLookup" Codebehind="IPLookup.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Lookup IP Address</title>
    <link type="text/css" rel="stylesheet" href="/dnaimages/moderation/includes/moderation.css"/>
    <link type="text/css" rel="stylesheet" href="/dnaimages/moderation/includes/moderation_only.css"/>
</head>
<body style="border-width:0" onload="setupFormAction()">
<script language="javascript" type="text/javascript">
function setupFormAction()
{
    document.forms[0].action = "iplookup";
}
</script>
    <form id="form1" runat="server">
        <asp:Label ID="Message" runat="server"></asp:Label>&nbsp;
        <asp:HiddenField ID="ThreadEntryId" runat="server" />
        <asp:HiddenField ID="ModerationID" runat="server" />
        <br />
    <div>
        <asp:TextBox ID="Reason" runat="server" Height="180px"
            TextMode="MultiLine" Width="340px"></asp:TextBox><br />
        <asp:Button ID="Button1" runat="server" Text="Submit" PostBackUrl="~/IPLookup" OnClick="Button1_Click" /></div>
        
    </form>
</body>
</html>
