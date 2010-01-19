<%@ Page Language="C#" AutoEventWireup="true" Inherits="RestrictedUserListPage" Codebehind="RestrictedUserListPage.aspx.cs" %>
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    <head id="Head1" runat="server">
        <title>DNA - Restricted User List Page</title>
	    <link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
        <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <dna:form id="form1" runat="server" defaultbutton="btnMostRecent" >
        <div>
            <br />
            <asp:Image ID="Image1" runat="server" Height="48px" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg"
                Style="z-index: 114; left: 12px; position: absolute; top: 2px" Width="179px" />
            <br />
            <br />
            <asp:Label ID="lblTitle" runat="server" Text="DNA - Restricted User List Page" Width="453px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label><br />
            <asp:Label ID="lblError" runat="server" Height="27px" Width="548px"></asp:Label>
            <br />
            <table style="width: 853px">
                <tr>
                    <td style="width: 366px; height: 49px">
                        <asp:Label ID="lblSite" runat="server" Text="Site :" Width="85px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label>
                        <asp:DropDownList
                            ID="SiteList" runat="server" EnableViewState=true OnSelectedIndexChanged="SiteList_SelectedIndexChanged" AutoPostBack="True" CausesValidation="True">
                        </asp:DropDownList></td>
                    <td style="height: 49px; width: 448px;" align="center">
                        <br />
                        <asp:Label ID="Status" runat="server" Text="Status :" Width="85px" Font-Bold="True" Font-Names="Times New Roman" Font-Size="XX-Large"></asp:Label>
                        <asp:DropDownList
                            ID="UserStatusTypes" runat="server" EnableViewState=true OnSelectedIndexChanged="UserStatusTypes_SelectedIndexChanged" AutoPostBack="True" CausesValidation="True">
                            <asp:ListItem Value="Premoderated">Premoderated</asp:ListItem>
                            <asp:ListItem Value="Restricted">Banned</asp:ListItem>
                            <asp:ListItem>Both</asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        </td>
                </tr>
            </table>
            <br />
            <asp:Button ID="btnA" runat="server" Text="A" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnB" runat="server" Text="B" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnC" runat="server" Text="C" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnD" runat="server" Text="D" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnE" runat="server" Text="E" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnF" runat="server" Text="F" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnG" runat="server" Text="G" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnH" runat="server" Text="H" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnI" runat="server" Text="I" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnJ" runat="server" Text="J" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnK" runat="server" Text="K" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnL" runat="server" Text="L" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnM" runat="server" Text="M" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnN" runat="server" Text="N" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnO" runat="server" Text="O" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnP" runat="server" Text="P" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnQ" runat="server" Text="Q" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnR" runat="server" Text="R" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnS" runat="server" Text="S" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnT" runat="server" Text="T" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnU" runat="server" Text="U" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnV" runat="server" Text="V" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnW" runat="server" Text="W" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnX" runat="server" Text="X" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnY" runat="server" Text="Y" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnZ" runat="server" Text="Z" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnAll" runat="server" Text="All" OnClick="ViewByLetter" EnableViewState="False" />
            <asp:Button ID="btnMostRecent" runat="server" Text="Most Recent" OnClick="ViewMostRecent" />
            <br /><br />
            <asp:Button ID="btnFirst" runat="server" Font-Size="X-Small" Text="|<" OnClick="ShowFirst"/>
            <asp:Button ID="btnPrevious" runat="server" Font-Size="X-Small" Text="<<" OnClick="ShowPrevious"/>
            <asp:Label ID="lbPage" runat="server" Text="of #"></asp:Label>
            <asp:Button ID="btnNext" runat="server" Font-Size="X-Small" Text=">>" OnClick="ShowNext"/>
            <asp:Button ID="btnLast" runat="server" Font-Size="X-Small" Text=">|" OnClick="ShowLast"/><br />
            <asp:Table ID="tblResults" runat="server" Height="180px" Width="640px">
            </asp:Table>
            <asp:Button ID="btnFirst2" runat="server" Font-Size="X-Small" Text="|<" OnClick="ShowFirst"/>
            <asp:Button ID="btnPrevious2" runat="server" Font-Size="X-Small" Text="<<" OnClick="ShowPrevious"/>
            <asp:Label ID="lbPage2" runat="server" Text="of #"></asp:Label>
            <asp:Button ID="btnNext2" runat="server" Font-Size="X-Small" Text=">>" OnClick="ShowNext"/>
            <asp:Button ID="btnLast2" runat="server" Font-Size="X-Small" Text=">|" OnClick="ShowLast"/><br />
            <asp:Label ID="Count" runat="server" Text="" Visible="False"></asp:Label>
            <asp:Label ID="lbTotalResults" runat="server" Text="" Visible="False"></asp:Label>
            <asp:Label ID="CountAndTotal" runat="server" Text=""></asp:Label>
        </div>
        </dna:form>
    </body>
</html>
