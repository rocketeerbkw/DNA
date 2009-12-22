<%@ Page Language="C#" AutoEventWireup="true" Inherits="MoveThreadPage" Codebehind="MoveThreadPage.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna"%>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>DNA - Move Moderated Thread</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
// <!CDATA[

// ]]>
</script>
</head>
<body>
    <dna:form id="form1" runat="server">
        <br /><asp:Image ID="Image2" runat="server" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg" /><br /><br />
        <asp:Label ID="namespacelable" runat="server" Height="26px" Text="Move Thread" Width="100%" Font-Bold="True" Font-Size="X-Large"></asp:Label><br /><br />    
        <asp:PlaceHolder ID="MessagePH" runat="server" EnableViewState="false" Visible="false">
            <asp:Label ID="MessageText" runat="server" Text='' EnableViewState="false" Visible="false" ForeColor="Red" Font-Bold="true"></asp:Label><br /><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="GetDetailsPlaceHolder" runat="server" EnableViewState="false" Visible="False" />
        <asp:PlaceHolder ID="ThreadDetails" runat="server" EnableViewState="false">
            <table>
                <tr>
                    <td >
                        <asp:Label ID="lbThreadSubject" runat="server" Text="Thread Subject:" Width="170"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbThreadSubject" runat="server" EnableViewState="false" Width="300"/>
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="lbThreadID" runat="server" Text="Thread ID:" Width="170"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbThreadID" runat="server" EnableViewState="false" Width="300" />
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="lbNewForumTitle" runat="server" Text="Current Forum :" Width="170"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbNewForumTitle" runat="server" EnableViewState="false" Width="300" />
                    </td>
                </tr>
                <tr>
                    <td >
                        <asp:Label ID="NewForumID" runat="server" Text="Current Forum ID:" Width="170"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbNewForumID" runat="server" EnableViewState="false" Width="300" />
                    </td>
                </tr>
            </table>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="MoveThreadDetails" runat="server" Visible="false" EnableViewState="false">
            <table>
                <tr>
                    <td >
                        <asp:Label ID="lbOldForumTitle" runat="server" Text="Old Forum :" Width="170"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbOldForumTitle" runat="server" EnableViewState="false" Width="300"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbOldForumID" runat="server" Text="Old Forum ID:" Width="170"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="OldForumID" runat="server" EnableViewState="false" Width="300" />
                    </td>
                </tr>
            </table><br />
            <asp:Button Text="Undo Change" runat="server" ID="Undo" EnableViewState="false"/><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="MoveToDetails" runat="server" EnableViewState="false">
            <table>
                <tr>
                    <td valign="top">
                        <asp:Label ID="PostToLabel" Text="Post: " runat="server" ></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="PostContent" runat="server" Columns="50" Rows="3" TextMode="MultiLine"></asp:TextBox><br />
                    </td>
                </tr>
            </table>
            <br /><asp:Label ID="Lable5" runat="server" Text="Move to"></asp:Label> 
            <asp:TextBox ID="MoveToForumIDTB" runat="server" EnableViewState="false" Visible="false"></asp:TextBox>&nbsp;
            <asp:DropDownList ID="MoveToForumID" runat="server" EnableViewState="false">
            </asp:DropDownList>&nbsp;
            <asp:Button ID="Move" runat="server" Text="Move Thread" EnableViewState="false"/><br /><br />
        </asp:PlaceHolder>
        <asp:HiddenField runat="server" ID="dotnet" Value="1" EnableViewState="false"/>
        <asp:HiddenField runat="server" ID="ThreadID" Value="0" EnableViewState="false"/>
        <asp:HiddenField runat="server" ID="ThreadModID" Value="0" EnableViewState="false"/>
    </dna:form>
</body>
</html>
