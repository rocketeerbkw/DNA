<%@ Page Language="C#" AutoEventWireup="true" Inherits="ModerationClassAdmin" Codebehind="ModerationClassAdmin.aspx.cs" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ModerationClassAdmin</title>
    <link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <dna:form id="modclassform" runat="server">
    <div>
        <asp:Image ID="dnaLogo" runat="server" Height="48px" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg"
            Style="z-index: 100; left: 32px; position: relative; top: 32px" Width="179px" />
            <br />
        <br />
        <br />
        <br />
        <asp:Table ID="tblModerationClasses" runat="server" Height="32px" Style="z-index: 102;
            position: relative;" Width="576px">
        </asp:Table>
        <br />
         <asp:Label ID="Label2" runat="server" Style="z-index: 101; position: relative; left: 0px;" 
         Text="New Moderation Class:" Width="240px"></asp:Label>
         <asp:Label ID="lblError" runat="server" ForeColor="Red" Height="24px" Style="z-index: 111;
            position: relative;" Text="Error" Width="312px"></asp:Label>
        <br />
        <br />
        <asp:Label ID="Label3" runat="server" Style="z-index: 103; position: relative;
            left: 0px; top: 0px;" Text="Name" Width="40px"></asp:Label>&nbsp;&nbsp; &nbsp;
        &nbsp;
         <asp:TextBox ID="txtName" runat="server" Style="z-index: 104;
            position: relative; left: 16px; top: 0px;" Width="448px"></asp:TextBox>
        <br />
        <br />
        <asp:Label ID="Label4" runat="server" Style="z-index: 105; position: relative;
            top: 0px;" Text="Description" Width="88px"></asp:Label>
        <asp:TextBox ID="txtDescription" runat="server" Style="z-index: 106;
            position: relative; left: 8px; top: 0px;" Width="448px"></asp:TextBox>&nbsp;<br />
        <br />
        <asp:Label ID="Label1" runat="server" Style="z-index: 105; position: relative;
            top: 0px;" Text="Language" Width="88px"></asp:Label>
        <asp:TextBox ID="txtLanguage" runat="server" Style="z-index: 106;
            position: relative; left: 8px; top: 0px;" Width="448px" Text="en"></asp:TextBox>&nbsp;<br />
        <br />
        <asp:Label ID="Label5" runat="server" Style="z-index: 105; position: relative;
            top: 0px;" Text="Retrieval Policy" Width="88px"></asp:Label>
        <asp:DropDownList ID="cmbRetrievalPolicy" runat="server"></asp:DropDownList> &nbsp;<br />
        <br />
        <asp:Label ID="Label6" runat="server" Style="z-index: 107; position: relative;
            " Text="Template" Width="96px"></asp:Label>&nbsp;
        <asp:DropDownList ID="cmbTemplate" runat="server" Style="z-index: 108;
            position: relative;" ToolTip="Base new Class on existing Class ( moderators/profanities will be copied to new class )."
            Width="376px">
        </asp:DropDownList>
        <asp:Button ID="btnAddModClass" runat="server" Height="24px" OnClick="btnAddModClass_Click"
            Style="z-index: 109; position: relative; left: 8px; top: 0px;" Text="Add"
            Width="64px" />
    
    </div>
    </dna:form>
</body>
</html>
