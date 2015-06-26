<%@ Page Language="C#" AutoEventWireup="true" Inherits="BannedEmailsPage" EnableViewState="false" Codebehind="BannedEmailsPage.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="App_Code" Namespace="ActionlessForm" TagPrefix="dna"%>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>DNA - Banned Emails</title>
	<link href="/dnaimages/moderation/includes/moderation.css" rel="stylesheet" type="text/css" />
    <link href="/dnaimages/moderation/includes/moderation_only.css" rel="stylesheet" type="text/css" />
<script runat="server" type="text/C#">

    string CalculateSearchTypeURL(string letter, string searchtype)
    {
        string url = "~/BannedEMails?";
        if (searchtype.CompareTo("0") == 0)
        {
            url += "ViewMostRecent=1";
        }
        else if (letter.Length > 0)
        {
            url += "ViewByLetter=" + letter;
        }
        else
        {
            url += "ViewAll=1";
        }

        return url;
    }
    
    string CalculateURL(object letter, object searchtype, object show, object skip, object total, string action)
    {
        string url = CalculateSearchTypeURL(letter.ToString(), searchtype.ToString());
        int showNum = Convert.ToInt32(show);
        int skipNum = Convert.ToInt32(skip);
        int totalNum = Convert.ToInt32(total);
        if (action.CompareTo("previous") == 0)
        {
            if ((skipNum - showNum) < 0)
            {
                skipNum = 0;
            }
            else
            {
                skipNum -= showNum;
            }
        }
        else if (action.CompareTo("next") == 0)
        {
            if ((skipNum + showNum) < totalNum)
            {
                skipNum += showNum;
            }
        }
        else if (action.CompareTo("end") == 0)
        {
            if (showNum > 0)
            {
                skipNum = ((totalNum / showNum) * showNum);
            }
        }
        else
        {
            // Must be home!
            skipNum = 0;
        }
        
        return url += "&show=" + showNum.ToString() + "&skip=" + skipNum.ToString();
    }

    string CalculatePageNum(object total, object show, object skip)
    {
        int totalNum = Convert.ToInt32(total);
        int showNum = Convert.ToInt32(show);
        int skipNum = Convert.ToInt32(skip);
        if (showNum > 0)
        {
            if (totalNum < showNum)
            {
                totalNum = 1;
            }
            else if (totalNum % showNum > 0)
            {
                totalNum = (totalNum / showNum) + 1;
            }
            else
            {
                totalNum = (totalNum / showNum);
            }
        }
        return "Page " + Convert.ToString(totalNum - (totalNum - ((showNum + skipNum) / showNum))) + " of " + totalNum.ToString();
    }

    string CalculateSignInBannedURL(object email)
    {
        string show, skip, letter, searchtype;
        GetSearchValues(out show, out skip, out letter, out searchtype);
        string url = CalculateSearchTypeURL(letter, searchtype);
        url += "&email=" + email.ToString() + "&show=" + show + "&skip=" + skip + "&togglesigninban=1";
        return url;
    }

    string CalculateComplaintBannedURL(object email)
    {
        string show, skip, letter, searchtype;
        GetSearchValues(out show, out skip, out letter, out searchtype);
        string url = CalculateSearchTypeURL(letter, searchtype);
        url += "&email=" + email.ToString() + "&show=" + show + "&skip=" + skip + "&togglecomplaintban=1";
        return url;
    }

    void GetSearchValues(out string show, out string skip, out string searchLetter, out string searchType)
    {
        System.Xml.XmlNode navXml = ((System.Xml.XmlNode)NavigationTop.DataSource);
        show = navXml.SelectSingleNode("//SHOW").InnerText;
        skip = navXml.SelectSingleNode("//SKIP").InnerText;
        searchLetter = navXml.SelectSingleNode("//SEARCHLETTER").InnerText;
        searchType = navXml.SelectSingleNode("//SEARCHTYPE").InnerText;
    }

    string CalculateButtonText(object currentState)
    {
        if (currentState.ToString().CompareTo("1") == 0)
        {
            return "On";
        }
        return "Off";
    }
    
// <!CDATA[

// ]]>
</script>
</head>
<body>
    <dna:form id="BannedEmailsForm" runat="server">
    <br />
    <asp:Image ID="Image2" runat="server" ImageUrl="/dnaimages/moderation/images/dna_logo.jpg" /><br />
    <br />
    <asp:Label ID="namespacelable" runat="server" Height="26px" Text="Banned EMails" Width="100%" Font-Bold="True" Font-Size="X-Large"></asp:Label><br />
    <br />
    <asp:Button ID="AddEmail" runat="server" Text="Add Email"/>
    <asp:TextBox ID="NewEmail" runat="server" Width="232px"></asp:TextBox>
    <asp:CheckBox ID="NewSignInBanned" runat="server" text="Banned from signing in" Checked="true"/>
    <asp:CheckBox ID="NewComplaintBanned" runat="server" text="Banned from complaining" Checked="true"/>
    <br />
    <br />      
    <div>
        <asp:Button ID="btnA" runat="server" Text="A" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=a" %>' EnableViewState="False" />
        <asp:Button ID="btnB" runat="server" Text="B" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=b" %>' EnableViewState="False" />
        <asp:Button ID="btnC" runat="server" Text="C" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=c" %>' EnableViewState="False" />
        <asp:Button ID="btnD" runat="server" Text="D" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=d" %>' EnableViewState="False" />
        <asp:Button ID="btnE" runat="server" Text="E" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=e" %>' EnableViewState="False" />
        <asp:Button ID="btnF" runat="server" Text="F" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=f" %>' EnableViewState="False" />
        <asp:Button ID="btnG" runat="server" Text="G" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=g" %>' EnableViewState="False" />
        <asp:Button ID="btnH" runat="server" Text="H" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=h" %>' EnableViewState="False" />
        <asp:Button ID="btnI" runat="server" Text="I" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=i" %>' EnableViewState="False" />
        <asp:Button ID="btnJ" runat="server" Text="J" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=j" %>' EnableViewState="False" />
        <asp:Button ID="btnK" runat="server" Text="K" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=k" %>' EnableViewState="False" />
        <asp:Button ID="btnL" runat="server" Text="L" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=l" %>' EnableViewState="False" />
        <asp:Button ID="btnM" runat="server" Text="M" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=m" %>' EnableViewState="False" />
        <asp:Button ID="btnN" runat="server" Text="N" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=n" %>' EnableViewState="False" />
        <asp:Button ID="btnO" runat="server" Text="O" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=o" %>' EnableViewState="False" />
        <asp:Button ID="btnP" runat="server" Text="P" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=p" %>' EnableViewState="False" />
        <asp:Button ID="btnQ" runat="server" Text="Q" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=q" %>' EnableViewState="False" />
        <asp:Button ID="btnR" runat="server" Text="R" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=r" %>' EnableViewState="False" />
        <asp:Button ID="btnS" runat="server" Text="S" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=s" %>' EnableViewState="False" />
        <asp:Button ID="btnT" runat="server" Text="T" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=t" %>' EnableViewState="False" />
        <asp:Button ID="btnU" runat="server" Text="U" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=u" %>' EnableViewState="False" />
        <asp:Button ID="btnV" runat="server" Text="V" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=v" %>' EnableViewState="False" />
        <asp:Button ID="btnW" runat="server" Text="W" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=w" %>' EnableViewState="False" />
        <asp:Button ID="btnX" runat="server" Text="X" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=x" %>' EnableViewState="False" />
        <asp:Button ID="btnY" runat="server" Text="Y" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=y" %>' EnableViewState="False" />
        <asp:Button ID="btnZ" runat="server" Text="Z" PostBackUrl='<%# "~/BannedEMails?ViewByLetter=z" %>' EnableViewState="False" />
        <asp:Button ID="btnAll" runat="server" Text="All" PostBackUrl='<%# "~/BannedEMails?ViewAll=1" %>' EnableViewState="False" />
        <asp:Button ID="btnMostRecent" runat="server" Text="Most Recent" PostBackUrl='<%# "~/BannedEMails?ViewMostRecent=1" %>' EnableViewState="False" />
        <br /><br/>
        <asp:FormView runat="server" ID="NavigationTop">
            <ItemTemplate>
                <asp:Button ID="btnFirst" runat="server" Font-Size="X-Small" Text="|<" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"home")%>'/>
                <asp:Button ID="btnPrevious" runat="server" Font-Size="X-Small" Text="<<" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"previous") %>'/>
                <asp:Label ID="lbPage" runat="server" Text='<%# CalculatePageNum(XPath("//TOTALEMAILS"),XPath("//SHOW"),XPath("//SKIP")) %>'></asp:Label>
                <asp:Button ID="btnNext" runat="server" Font-Size="X-Small" Text=">>" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"next") %>'/>
                <asp:Button ID="btnLast" runat="server" Font-Size="X-Small" Text=">|" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"end") %>'/><br />
            </ItemTemplate>
        </asp:FormView>
        <br />
        <asp:GridView ID="BannedEmailsList" runat="server" AutoGenerateColumns="false" CellPadding="2" BorderStyle="None" GridLines="None" DataMember="BANNEDEMAIL">
        <Columns>
            <asp:TemplateField HeaderText="EMail address" HeaderStyle-HorizontalAlign="Left" HeaderStyle-Width="100%">
                <ItemTemplate>
                    <asp:TextBox ID="EmailAddress" runat="server" Text='<%# XPath("./EMAIL") %>' EnableViewState="false" Width="98%" ReadOnly="true"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Sign In Banned" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <asp:Button ID="SignInBanToggle" runat="server" PostBackUrl='<%# CalculateSignInBannedURL(XPath("./ESCAPEDEMAIL")) %>' Text='<%# CalculateButtonText(XPath("./SIGNINBAN")) %>' ForeColor='<%# CalculateButtonText(XPath("./SIGNINBAN")) == "On" ? System.Drawing.Color.Green : System.Drawing.Color.Red %>' EnableViewState="false" Width="60" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Complaint Banned" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <asp:Button ID="ComplaintBanToggle" runat="server" PostBackUrl='<%# CalculateComplaintBannedURL(XPath("./ESCAPEDEMAIL")) %>' Text='<%# CalculateButtonText(XPath("./COMPLAINTBAN")) %>' ForeColor='<%# CalculateButtonText(XPath("./COMPLAINTBAN")) == "On" ? System.Drawing.Color.Green : System.Drawing.Color.Red %>' EnableViewState="false" Width="60"/>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Date Banned" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <asp:Label ID="DateAdded" runat="server" Text='<%# XPath("./DATEADDED/DATE/@RELATIVE") %>' Width="120" ></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Added by" HeaderStyle-HorizontalAlign="Left">
                <ItemTemplate>
                    <asp:HyperLink ID="Editor" runat="server" Text='<%# XPath("./EDITOR") %>' NavigateUrl='<%# "~/U" + XPath("./EDITORID") %>' EnableViewState="false"></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button ID="Remove" runat="server" Text="Remove" PostBackUrl='<%# "~/BannedEMails?Remove=1&email=" + XPath("./ESCAPEDEMAIL").ToString() %>' EnableViewState="false"></asp:Button>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        </asp:GridView>
        <br />
        <asp:FormView runat="server" ID="NavigationBottom">
            <ItemTemplate>
                <asp:Button ID="btnFirst" runat="server" Font-Size="X-Small" Text="|<" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"home")%>'/>
                <asp:Button ID="btnPrevious" runat="server" Font-Size="X-Small" Text="<<" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"previous") %>'/>
                <asp:Label ID="lbPage" runat="server" Text='<%# CalculatePageNum(XPath("//TOTALEMAILS"),XPath("//SHOW"),XPath("//SKIP")) %>'></asp:Label>
                <asp:Button ID="btnNext" runat="server" Font-Size="X-Small" Text=">>" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"next") %>'/>
                <asp:Button ID="btnLast" runat="server" Font-Size="X-Small" Text=">|" PostBackUrl='<%# CalculateURL(XPath("//SEARCHLETTER"),XPath("//SEARCHTYPE"),XPath("//SHOW"),XPath("//SKIP"),XPath("//TOTALEMAILS"),"end") %>'/><br />
            </ItemTemplate>
        </asp:FormView>
    </div>
    </dna:form>
</body>
</html>
