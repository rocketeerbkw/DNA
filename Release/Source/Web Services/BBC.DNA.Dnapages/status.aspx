<%@ Page Language="C#" AutoEventWireup="true" Inherits="status" CodeBehind="status.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h1>
            <asp:Label ID="lblHostName" runat="server"></asp:Label>
            (DNA Pages)</h1>
    </div>
    <div>
        <asp:Label ID="lbFileInfo" runat="server" Font-Bold="true"></asp:Label>
    </div>
    <br />
    <div>
        <asp:Table ID="tblStats" runat="server">
        </asp:Table>
    </div>
    </form>
</body>
</html>
