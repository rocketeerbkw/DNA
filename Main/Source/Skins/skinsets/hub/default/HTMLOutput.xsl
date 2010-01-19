<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY bull "&#8226;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">
<xsl:import href="../../../base/text.xsl"/>
<xsl:import href="../../../base/base.xsl"/>
<xsl:include href="text.xsl"/>
<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO8859-1"/>
<xsl:variable name="sso_assets_path">/h2g2/sso/hub_resources</xsl:variable>
<xsl:variable name="sso_serviceid_link">hub</xsl:variable>
<xsl:variable name="sitename">hub</xsl:variable>
<xsl:variable name="root">/dna/hub/</xsl:variable>
<xsl:variable name="imagesource">http://www.bbc.co.uk/h2g2/skins/hub/images/</xsl:variable>
<xsl:variable name="smileysource">http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/</xsl:variable>
<xsl:variable name="skinname">hub</xsl:variable>
<xsl:variable name="bbcpage_variant"/>
  
<xsl:variable name="toolbar_width">730</xsl:variable>
<xsl:variable name="showtreegadget">0</xsl:variable>

<xsl:variable name="mainfontcolour">black</xsl:variable>
<xsl:variable name="boxfontcolour">white</xsl:variable>
<xsl:variable name="journalfontsize">2</xsl:variable>

<!-- name and researcher ID as displayed on the homepage boxout-->
<xsl:variable name="homepagedetailscolour">black</xsl:variable>
<xsl:variable name="headercolour">black</xsl:variable>
<!-- page background colour -->
<xsl:variable name="bgcolour">white</xsl:variable>
<!-- colour of the button bar tablecell -->
<xsl:variable name="buttonbarbgcolour">#BBBBBB</xsl:variable>
<!-- colours of links -->
<xsl:variable name="alinkcolour">blue</xsl:variable>
<xsl:variable name="linkcolour">blue</xsl:variable>
<xsl:variable name="vlinkcolour">blue</xsl:variable>
<!-- colour of title in top fives box -->
<xsl:variable name="topfivetitle">black</xsl:variable>
<!-- colour of header text in forum -->
<xsl:variable name="forumheader">black</xsl:variable>
<!-- colour of header for referenced researchers -->
<xsl:variable name="refresearchers">black</xsl:variable>
<!-- colour of header for referenced entries -->
<xsl:variable name="refentries">black</xsl:variable>
<!-- colour of header for referenced sites -->
<xsl:variable name="refsites">black</xsl:variable>
<xsl:variable name="topbar">black</xsl:variable>
<!-- colour of the [3 members] bit on categorisation pages -->
<xsl:variable name="memberscolour">black</xsl:variable>
<!-- colour of an empty category -->
<xsl:variable name="emptycatcolour">black</xsl:variable>
<!-- colour of an full category -->
<xsl:variable name="fullcatcolour">blue</xsl:variable>
<!-- colour of an article in a category -->
<xsl:variable name="catarticlecolour"></xsl:variable>

<xsl:variable name="blobbackground">white</xsl:variable>

<xsl:variable name="picturebordercolour">black</xsl:variable>
<xsl:variable name="pictureborderwidth">1</xsl:variable>

<!-- Categorisation styles -->

<xsl:variable name="catdecoration">none</xsl:variable>
<xsl:variable name="catcolour"></xsl:variable>
<xsl:variable name="artdecoration">none</xsl:variable>
<xsl:variable name="artcolour"></xsl:variable>
<xsl:variable name="hovcatdecoration">underline ! important</xsl:variable>
<xsl:variable name="hovcatcolour"></xsl:variable>
<xsl:variable name="hovartdecoration">underline ! important</xsl:variable>
<xsl:variable name="hovartcolour"></xsl:variable>
<xsl:variable name="catfontheadersize">5</xsl:variable>
<xsl:variable name="catfontheadercolour">white</xsl:variable>


<!-- categorisation boxout colours -->
<xsl:variable name="catboxwidth">140</xsl:variable>
<!-- background colour -->
<xsl:variable name="catboxbg">#FFFFBB</xsl:variable>
<!-- title colour -->
<xsl:variable name="catboxtitle">black</xsl:variable>
<!-- main link colour -->
<xsl:variable name="catboxmain">blue</xsl:variable>
<!-- sub link colour -->
<xsl:variable name="catboxsublink">red</xsl:variable>
<!-- other link colour -->
<xsl:variable name="catboxotherlink">green</xsl:variable>
<xsl:variable name="catboxlinecolour">black</xsl:variable>

<xsl:variable name="horizdividers">white</xsl:variable>
<xsl:variable name="verticalbarcolour">#99CCCC</xsl:variable>

<!-- colour of the errors displayed when editing articles-->
<xsl:variable name="xmlerror">#FF0000</xsl:variable>

<xsl:variable name="boxoutcolour">#CCFFFF</xsl:variable>
<xsl:variable name="boxholderfontcolour">#33FFFF</xsl:variable>
<xsl:variable name="boxholderleftcolour">#000099</xsl:variable>
<xsl:variable name="boxholderrightcolour">#006699</xsl:variable>
<xsl:variable name="headertopedgecolour">#CCCCCC</xsl:variable>
<xsl:variable name="headerbgcolour">#006699</xsl:variable>
<xsl:variable name="pullquotecolour">#BB4444</xsl:variable>
<xsl:variable name="welcomecolour">#ff6666</xsl:variable>
<xsl:variable name="CopyrightNoticeColour">#000000</xsl:variable>
<xsl:variable name="WarningMessageColour">red</xsl:variable>

<!-- font details -->
<xsl:variable name="fontsize">2</xsl:variable>
<xsl:variable name="fontface">Arial, Helvetica, sans-serif</xsl:variable>
<xsl:variable name="buttonfont">Verdana, Verdana, Arial, Helvetica, sans-serif</xsl:variable>
<xsl:variable name="ftfontsize">2</xsl:variable>
<xsl:variable name="regmessagesize">1</xsl:variable>
<xsl:variable name="forumtitlesize">2</xsl:variable>
<xsl:variable name="forumsubsize">1</xsl:variable>

<!-- colours for links in forum threads page -->

<xsl:variable name="ftfontcolour">#000000</xsl:variable>
<xsl:variable name="ftbgcolour">#99CCCC</xsl:variable>
<xsl:variable name="ftbgcolour2">#77BBBB</xsl:variable>
<xsl:variable name="ftbgcoloursel">#000033</xsl:variable>
<xsl:variable name="ftalinkcolour">#333333</xsl:variable>
<xsl:variable name="ftlinkcolour">#000000</xsl:variable>
<xsl:variable name="ftvlinkcolour">#883333</xsl:variable>
<xsl:variable name="ftcurrentcolour">#FF0000</xsl:variable>
<xsl:variable name="forumsourcelink"><xsl:value-of select="$linkcolour"/></xsl:variable>

<xsl:variable name="fttitle">#AAAAAA</xsl:variable>

<!-- Other variables -->

<xsl:variable name="pageui_dontpanic">Help</xsl:variable>
<xsl:variable name="alt_help">Knowledge Base</xsl:variable>
<xsl:variable name="pageui_login">Sign in</xsl:variable>
<xsl:variable name="alt_login">Sign in</xsl:variable>
<xsl:variable name="alt_whosonline">Who's Online</xsl:variable>
<xsl:variable name="alt_search">Search</xsl:variable>
<xsl:variable name="alt_frontpage">DNA Hub</xsl:variable>


<xsl:variable name="skinlist">
<SKINDEFINITION>
	<NAME>hub</NAME>
	<DESCRIPTION>DNA Hub</DESCRIPTION>
</SKINDEFINITION>
</xsl:variable>

<xsl:template name='primary-template'>
<html>
<xsl:call-template name="insert-header"/>
<body bgcolor="{$bgcolour}" text="{$mainfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
<!-- top navigation / banner space -->
<xsl:call-template name="bbcitoolbar"/>
<table border="0" cellpadding="0" cellspacing="0" width="730">
  <TBODY>
  <TR>
    <TD class="bbcpageToplefttd" width="150">
      <TABLE border="0" cellPadding="0" cellSpacing="0">
        <TBODY>
        <TR>
          <td width="8"><img src="{$imagesource}t.gif" width="8" height="1"/>
			</td>
	<TD width="134"><IMG alt="" height="1" src="{$imagesource}t.gif" 
            width="134"/><BR clear="all"/><!--FONT class="bbcpageToplefttd" 
            face="arial, helvetica, sans-serif" size="1">
			<xsl:apply-templates mode="maindate" select="DATE"/>
			<BR/><A class="bbcpageTopleftlink" 
            href="http://www.bbc.co.uk/cgi-bin/education/betsie/parser.pl" 
            style="TEXT-DECORATION: underline">Text 
      only</A></FONT-->
      	<xsl:call-template name="barley_topleft"/>
      </TD></TR></TBODY></TABLE></TD>
    <TD vAlign="top" align="left" width="620"><IMG alt="default banner" 
      height="70" src="{$imagesource}hub.gif" width="620"/> 
</TD></TR>
</TBODY>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="730">
<tr><td valign="top" align="left" width="150" rowspan="3">
	<table align="left" border="0" cellpadding="0" cellspacing="0" width="150" style="MARGIN: 0px" >
		<tr>
			<td width="8"><img src="{$imagesource}t.gif" width="8" height="1"/></td>
			<td>
				<font face="arial, helvetica,sans-serif" size="2">
				<xsl:call-template name="barley_homepage"/>
				<!--a href="/">BBC Homepage</a><br /--><br />
				<xsl:call-template name="navbar"/>
				<hr width="50" align="left"/>
				<!--font face="Arial,Helvetica,sans-serif" size="2">
				
				<a href="/feedback/">Contact Us</a><br/><br/>
				<a href="/help/">Help</a><br/><br/>
				<br/>
				<font size="1">Like this page?<br/>
				<a onClick="popupwindow('/cgi-bin/navigation/mailto.pl?GO=1','Mailer','status=no,scrollbars=yes,resizable=yes,width=350,height=400')" href="/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer">Send it to a friend!</a>
				</font>
				</font-->
				<xsl:call-template name="barley_services"/>
				</font>
			</td>
			<td width="8"><img src="{$imagesource}t.gif" width="8" height="1"/>
			</td>
		</tr>
	</table>
</td>
<td colspan="5">
      <!--SSO Status bar-->
      <xsl:call-template name="sso_statusbar"/>
      <!--/SSO Status bar-->
</td>
</tr>
<tr>
	<td  colspan="5"><img src="{$imagesource}t.gif" width="1" height="10"/></td>
</tr>
<tr>
<td valign="top" align="left" width="480">
<img src="{$imagesource}t.gif" width="480" height="1"/><BR/>
<font face="arial, helvetica,sans-serif" size="2">
<xsl:call-template name="insert-subject"/>
<xsl:call-template name="insert-mainbody"/>
<!--div align="center"><br/><a href="/terms/"><font size="1" face="Arial,Helvetica,sans-serif"><xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text> BBC MMIII</font></a></div-->
<div align="center"><a href="/terms/"><!--font size="1" face="Arial,Helvetica,sans-serif">Terms of use</font></a> | <a href="/privacy/"><font size="1" face="Arial,Helvetica,sans-serif">Privacy</font-->
	<xsl:call-template name="barley_footer"/>
</a></div>
<br/>
<br/>
<br/>
</font>
</td>
<td width="5"><img src="{$imagesource}t.gif" width="5" height="1"/></td>
<td width="1" bgcolor="black"><img src="{$imagesource}t.gif" width="1" height="1"/></td>
<td width="5"><img src="{$imagesource}t.gif" width="5" height="1"/></td>
<td valign="top" align="left" width="129">
<table border="0" cellpadding="0" cellspacing="0" width="129">
<td width="129"><xsl:call-template name="insert-sidebar"/></td>
</table>
</td>
</tr>
</table>
</body>
</html>
</xsl:template>

<xsl:template mode="header" match="H2G2">
<xsl:param name="title">h2g2</xsl:param>
<head>
<META NAME="robots" CONTENT="{$robotsetting}"/>
<title><xsl:value-of select="$title"/></title>
<script language="JavaScript">
<xsl:comment> hide this script from non-javascript-enabled browsers

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}
function popusers(link)
{
	popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
}
// stop hiding </xsl:comment>
</script>
<style type="text/css">
<xsl:comment>
DIV.browse A { color: <xsl:value-of select="$mainfontcolour"/>}
</xsl:comment></style>
<xsl:call-template name="toolbarcss"/>
<meta name="keywords" content="community,communities,user-generated content,h2g2"/>
<meta name="description" content="The Hub contains discussion, development and documentation about the BBC engine that builds community websites round user-generated content."/>
</head>
</xsl:template>

<xsl:template match="H2G2[@TYPE='FORUMFRAME']">
	<html>
		<HEAD>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<TITLE><xsl:value-of select="$m_forumtitle"/></TITLE>
		</HEAD>
	<FRAMESET ROWS="*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="0">
		<FRAME>
			<xsl:attribute name="SRC">FT<xsl:value-of select="FORUMFRAME/@FORUM" />?thread=<xsl:value-of select="FORUMFRAME/@REQUESTEDTHREAD" />&amp;post=<xsl:value-of select="FORUMFRAME/@POST" />&amp;skip=<xsl:value-of select="FORUMFRAME/@SKIP" />&amp;show=<xsl:value-of select="FORUMFRAME/@SHOW" /></xsl:attribute>
			<xsl:attribute name="NAME">toprow</xsl:attribute>
			<xsl:attribute name="MARGINHEIGHT">0</xsl:attribute>
			<xsl:attribute name="MARGINWIDTH">0</xsl:attribute>
			<xsl:attribute name="LEFTMARGIN">0</xsl:attribute>
			<xsl:attribute name="TOPMARGIN">0</xsl:attribute>
			<xsl:attribute name="SCROLLING">yes</xsl:attribute>
		</FRAME>
	</FRAMESET>
	</html>
</xsl:template>


<xsl:template mode="maindate" match="DATE">
		<xsl:value-of select="translate(@DAYNAME, 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" /><BR/>
		<xsl:value-of select="number(@DAY)" />
		<xsl:choose>
			<xsl:when test="number(@DAY) = 1 or number(@DAY) = 21 or number(@DAY) = 31">st</xsl:when>
			<xsl:when test="number(@DAY) = 2 or number(@DAY) = 22">nd</xsl:when>
			<xsl:when test="number(@DAY) = 3 or number(@DAY) = 23">rd</xsl:when>
			<xsl:otherwise>th</xsl:otherwise>
		</xsl:choose><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="@MONTHNAME" /><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="@YEAR" />
</xsl:template>

<xsl:template name="navbar">
	<!--<xsl:choose>
		<xsl:when test="PAGEUI/REGISTER[@VISIBLE=1]">
			<a target="_top" class="dnapageWhite">
				<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_register"/></xsl:attribute>
				<xsl:value-of select="$alt_register"/>
			</a><br/>
			<a target="_top" class="dnapageWhite">
				<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_login"/></xsl:attribute>
				<xsl:value-of select="$alt_login"/>
			</a><br/>
			<a target="_top" class="dnapageWhite" href="{$root}"><xsl:value-of select="$alt_frontpage"/></a><br/>
		</xsl:when>
		<xsl:otherwise>-->
			<a target="_top" class="dnapageWhite" href="{$root}"><xsl:value-of select="$alt_frontpage"/></a><br/>
		<!--</xsl:otherwise>
	</xsl:choose>-->
	<xsl:if test="PAGEUI/MYHOME[@VISIBLE=1]">
		<a target="_top" class="dnapageWhite" >
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_myhome"/></xsl:attribute>
			<xsl:value-of select="$alt_myspace"/>
		</a><br/>
		<a target="conversation" class="dnapageWhite" onClick="popupwindow('{$root}MP{VIEWING-USER/USER/USERID}?s_type=pop&amp;s_target=conversation','Conversations','scrollbars=1,resizable=1,width=165,height=400');return false;" href="{$root}MP{VIEWING-USER/USER/USERID}?s_type=pop&amp;s_target=conversation">
			My Conversations
		</a><br/>
	</xsl:if>
	<xsl:if test="PAGEUI/DONTPANIC[@VISIBLE=1]">
		<a target="_top" class="dnapageWhite">
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_dontpanic"/></xsl:attribute>
			<xsl:value-of select="$alt_help"/>
		</a><br/>
	</xsl:if>
	<a target="_top" class="dnapageWhite" href="{$root}Feedback" ><xsl:value-of select="$alt_feedbackforum"/></a><br/>
	<a target="_top" class="dnapageWhite" href="{$root}Search" ><xsl:value-of select="$alt_search"/></a><br/>
	<a target="_hubonline" class="dnapageWhite" onClick="popupwindow('{$root}online','_hubonline','status=1,scrollbars=1,resizable=1,width=165,height=400');return false;" href="{$root}online"><xsl:value-of select="$alt_whosonline"/></a><br/>
	<xsl:if test="PAGEUI/MYDETAILS[@VISIBLE=1]">
		<a target="_top" class="dnapageWhite">
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_mydetails"/></xsl:attribute>
			<xsl:value-of select="$alt_preferences"/>
		</a><br/>
	</xsl:if>
	<xsl:if test="PAGEUI/LOGOUT[@VISIBLE=1]">
		<a target="_top" class="dnapageWhite" >
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_logout"/></xsl:attribute>
			<xsl:value-of select="$alt_logout"/>
		</a><br/>
	</xsl:if>

	<hr width="50" align="left"/>
	<a target="_top" href="/dna/h2g2/">h2g2</a><br/>
	<a target="_top" href="/dna/360/">360</a><br/>
	<!--a target="_top" href="/dna/place-devon/">SoP Devon</a><br/>
	<a target="_top" href="/dna/place-lancashire/">SoP Lancashire</a><br/>
	<a target="_top" href="/dna/place-london/">SoP London</a><br/>
	<a target="_top" href="/dna/place-nireland/">SoP Northern Ireland</a><br/-->
	<a target="_top" href="/dna/ican/">iCan</a><br/>
	<a target="_top" href="/dna/collective/">collective</a><br/>
	<a target="_top" href="/dna/onthefuture/">Book of the Future</a><br/>
	<a target="_top" href="/dna/cult/">Talk Buffy</a><br/>
	<a target="_top" href="/dna/getwriting/">Get Writing</a><br/>
	<a target="_top" href="/dna/ww2/">WW2</a><br/>
	<a target="_top" href="/dna/ptop/">Parent's Music Room</a><br/>

</xsl:template>

<xsl:template name="FRONTPAGE_SIDEBAR">
	<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION"/>
	<xsl:apply-templates select="/H2G2/TOP-FIVES" />
</xsl:template>

<xsl:template match="TOP-FIVE">
<b><font xsl:use-attribute-sets="topfivefont" color="{$topfivetitle}">
<xsl:value-of select="TITLE" /></font></b>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr bgcolor="{$boxfontcolour}"> 
        <td><img src="{$imagesource}blank.gif" width="100" height="1"/></td>
      </tr>
      <tr> 
        <td>
<xsl:apply-templates select="TOP-FIVE-ARTICLE|TOP-FIVE-FORUM"/>
</td></tr></table><br/>
</xsl:template>

<!--

	<xsl:template match="TOP-FIVE-ARTICLE">

	Generic:	No
	Purpose:	Displays one of the top five items

-->

<xsl:template match="TOP-FIVE-ARTICLE">
<font xsl:use-attribute-sets="topfiveitem">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
<xsl:value-of select="SUBJECT"/>
</A>
</font><br/>
<img src="{$imagesource}t.gif" width="8" height="4"/><br/>
</xsl:template>

<!--

	<xsl:template match="TOP-FIVE-FORUM">

	Generic:	No
	Purpose:	Displays one of the top five items

-->

<xsl:template match="TOP-FIVE-FORUM">
<font xsl:use-attribute-sets="topfiveitem">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUMID"/></xsl:attribute>
<xsl:value-of select="SUBJECT"/>
</A>
</font><br/>
<img src="{$imagesource}t.gif" width="8" height="4"/><br/>
</xsl:template>

<!--

	<xsl:template name="SUBJECTHEADER">
	Purpose:	Default way of presenting a SUBJECTHEADER

-->
	<xsl:template name="SUBJECTHEADER">
		<xsl:param name="text">?????</xsl:param>
		<br clear="all"/>
		<font xsl:use-attribute-sets="headerfont">
			<b>
					<xsl:value-of select="$text"/>
			</b>
		</font>
		<br/>
	</xsl:template>

<xsl:template name="MULTIPOSTS_SIDEBAR">
<br/>
<CENTER>
<font xsl:use-attribute-sets="mainfont" size="1">
<xsl:call-template name="sidebarforumnav"/>
</font>
<br/><br/>
<xsl:call-template name="m_forumpostingsdisclaimer"/>
</CENTER>
</xsl:template>


<!--xsl:template name="messagenavbuttons">
<xsl:param name="skipto">0</xsl:param>
<xsl:param name="count">0</xsl:param>
<xsl:param name="forumid">0</xsl:param>
<xsl:param name="threadid">0</xsl:param>
<xsl:param name="more">0</xsl:param>
						<font size="1">
						<xsl:choose>
						<xsl:when test="$skipto &gt; 0">
					<A>
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="$forumid" />?thread=<xsl:value-of select="$threadid" />&amp;skip=<xsl:value-of select='number($skipto) - number($count)' />&amp;show=<xsl:value-of select="$count" /></xsl:attribute>
								Posts <xsl:value-of select="number($skipto) - number($count) + 1"/>-<xsl:value-of select="number($skipto)"/>
							</A>
						</xsl:when>
						<xsl:otherwise>
					<xsl:call-template name="forum_button_reverse"/>
						</xsl:otherwise>
						</xsl:choose>
							<xsl:text> | </xsl:text>
						<xsl:choose>
						<xsl:when test="$more &gt; 0">
							<A>
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="$forumid" />?thread=<xsl:value-of select="$threadid" />&amp;skip=<xsl:value-of select='number($skipto) + number($count)' />&amp;show=<xsl:value-of select="$count" /></xsl:attribute>
								Posts <xsl:value-of select="number($skipto) + number($count) + 1"/>-<xsl:value-of select="number($skipto) + number($count) + number($count)"/>
								</A>
				</xsl:when>
						<xsl:otherwise>
						<xsl:call-template name="forum_button_play"/>
					</xsl:otherwise>
						</xsl:choose>
						</font>
							<br/>
</xsl:template-->

<xsl:template name="forum_button_reverse">
<xsl:value-of select="$m_showolder"/>
</xsl:template>

<xsl:template name="forum_button_play">
<xsl:value-of select="$m_shownewer"/></xsl:template>

<xsl:template match="ARTICLE-EDIT-FORM">
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
		<xsl:apply-imports/>
	</xsl:when>
	<xsl:otherwise>
		<P>Sorry, you can only add or edit Articles on the Hub if you are an Editor.</P>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
<xsl:template name="UserEditMasthead">
	<xsl:if test="$test_IsEditor">
		<xsl:apply-imports/>
	</xsl:if>
</xsl:template>
-->

<!--

	<xsl:template match="RECENT-ENTRIES">

	Generic:	No
	Purpose:	Display the list of recent entries

-->

<xsl:template match="RECENT-ENTRIES">
	<xsl:choose>
		<xsl:when test="$ownerisviewer = 1">
			<xsl:choose>
				<xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
					<!-- owner, full-->
<xsl:call-template name="m_artownerfull"/>
					<xsl:apply-templates select="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
					<br/>
					<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute><xsl:value-of select="$m_clickmoreentries"/></A><br/>
				</xsl:when>
				<xsl:otherwise>
					<!-- owner empty-->
<xsl:call-template name="m_artownerempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
					<!-- visitor full-->
<xsl:call-template name="m_artviewerfull"/>
					<xsl:apply-templates select="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
					<br/>
					<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute><xsl:value-of select="$m_clickmoreentries"/></A><br/>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<!-- visitor empty-->
<xsl:call-template name="m_artviewerempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="ARTICLEINFO/SUBMITTABLE"></xsl:template>

<xsl:template match="ARTICLEINFO/RECOMMENDENTRY"></xsl:template>

<xsl:template name="DISPLAY-RECOMMENDENTRY"></xsl:template>

<!--

	<xsl:template match="FORUMTHREADPOSTS/POST">

	Generic:	No
	Purpose:	Displays a thread post

-->

<xsl:template match="FORUMTHREADPOSTS/POST">
<xsl:param name="ptype" select="'frame'"/>
<TABLE WIDTH="100%" cellspacing="0" cellpadding="0" border="0">
	<TBODY>
	<TR><TD width="100%" COLSPAN="2">
<HR size="2"/></TD>
	<TD nowrap="1">
<FONT xsl:use-attribute-sets="forumsubfont">
<a name="pi{count(preceding-sibling::POST) + 1 + number(../@SKIPTO)}"></a>
<A name="p{@POSTID}">
<xsl:choose>
	<xsl:when test="@PREVINDEX">
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@PREVINDEX]">
<A><xsl:attribute name="HREF">#p<xsl:value-of select="@PREVINDEX" /></xsl:attribute><xsl:value-of select="$m_prev"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVINDEX" />#p<xsl:value-of select="@PREVINDEX" /></xsl:attribute><xsl:value-of select="$m_prev"/></A>
</xsl:otherwise>
</xsl:choose>
<!--	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />&amp;thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@PREVINDEX" /></xsl:attribute><IMG src="{$imagesource}f_backward.gif" border="0" alt="Previous message"/></xsl:element>-->
	</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="$m_prev"/>
	</xsl:otherwise>
	</xsl:choose>
	</A>
 | 	<xsl:choose>
	<xsl:when test="@NEXTINDEX">
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@NEXTINDEX]">
<A><xsl:attribute name="HREF">#p<xsl:value-of select="@NEXTINDEX" /></xsl:attribute><xsl:value-of select="$m_next"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTINDEX" />#p<xsl:value-of select="@NEXTINDEX" /></xsl:attribute><xsl:value-of select="$m_next"/></A>
</xsl:otherwise>
</xsl:choose>
<!--	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />&amp;thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@NEXTINDEX" /></xsl:attribute><IMG src="{$imagesource}f_forward.gif" border="0" alt="Next message"/></xsl:element>-->
	</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="$m_next"/>
	</xsl:otherwise>
	</xsl:choose>
</FONT>
	 </TD>
	</TR>
	<TR>
	<TD ALIGN="left"><FONT xsl:use-attribute-sets="forumsubjectlabel"><xsl:value-of select="$m_fsubject"/></FONT> <FONT xsl:use-attribute-sets="forumsubject"><B><xsl:call-template name="postsubject"/></B></FONT><br/>
	<FONT xsl:use-attribute-sets="forumpostedlabel"><xsl:value-of select="$m_posted"/><xsl:apply-templates select="DATEPOSTED/DATE"/>
	</FONT>
	<xsl:if test="not(@HIDDEN &gt; 0)">
	<FONT xsl:use-attribute-sets="forumpostedlabel">
	<xsl:value-of select="$m_by"/></FONT><FONT xsl:use-attribute-sets="forumposted"><A><xsl:attribute name="TARGET">_top</xsl:attribute><xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/></xsl:attribute><xsl:apply-templates select="USER/USERNAME"/></A></FONT>
	</xsl:if>
<xsl:if test="@INREPLYTO">
<br/>
<FONT xsl:use-attribute-sets="forumsmall"><xsl:value-of select="$m_inreplyto"/><xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><xsl:value-of select="$m_thispost"/></A>. 
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@INREPLYTO" />#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><xsl:value-of select="$m_thispost"/></A>. 
</xsl:otherwise>
</xsl:choose>
</FONT>
</xsl:if>

<!--
<xsl:if test="@PREVSIBLING">
<FONT SIZE="1" color="{$fttitle}">
<xsl:text> Read the </xsl:text>
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>previous reply</A>.
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>previous reply</A>.
</xsl:otherwise>
</xsl:choose>
</FONT>
</xsl:if>

<xsl:if test="@NEXTSIBLING">
<FONT SIZE="1" color="{$fttitle}">
<xsl:text> Read the </xsl:text>
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>next reply</A>.
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>next reply</A>.
</xsl:otherwise>
</xsl:choose>
</FONT>
</xsl:if>
-->

<xsl:if test="@INREPLYTO|@PREVSIBLING|@NEXTSIBLING">
<br/>
</xsl:if>

	</TD>
	<TD align="right" valign="top">
	</TD><TD nowrap="1" ALIGN="center" valign="top"><FONT face="{$fontface}" SIZE="1"><xsl:value-of select="$m_postnumber"/> <xsl:value-of select="position() + number(../@SKIPTO)"/><br/></FONT>
<xsl:if test="$showtreegadget=1">
	<TABLE cellpadding="0" cellspacing="0" BORDER="0">
	<TR>
	<TD xsl:use-attribute-sets="cellstyle"><font xsl:use-attribute-sets="gadgetfont">&nbsp;</font></TD>
	<TD xsl:use-attribute-sets="cellstyle">
	<xsl:choose>
		<xsl:when test="@INREPLYTO">
			<xsl:attribute name="bgcolor">yellow</xsl:attribute>
			<xsl:choose>
				<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
					<A><xsl:attribute name="HREF">#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$alt_replyingtothis"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">^</font></A>
				</xsl:when>
				<xsl:otherwise>
					<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@INREPLYTO" />#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$alt_replyingtothis"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">^</font></A>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<font xsl:use-attribute-sets="gadgetfont"><xsl:text>^</xsl:text></font>
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	<TD xsl:use-attribute-sets="cellstyle"><font xsl:use-attribute-sets="gadgetfont">&nbsp;</font></TD>
	</TR>
	<TR>
	<TD xsl:use-attribute-sets="cellstyle">
	<xsl:choose>
		<xsl:when test="@PREVSIBLING">
			<xsl:attribute name="bgcolor">yellow</xsl:attribute>
			<xsl:choose>
				<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
					<A><xsl:attribute name="HREF">#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$alt_prevreply"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">&lt;</font></A>
				</xsl:when>
				<xsl:otherwise>
					<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVSIBLING" />#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$alt_prevreply"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">&lt;</font></A>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
		<font xsl:use-attribute-sets="gadgetfont"><xsl:text>&lt;</xsl:text></font>
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	<TD xsl:use-attribute-sets="cellstyle"><font xsl:use-attribute-sets="gadgetfont">o</font></TD>
	<TD xsl:use-attribute-sets="cellstyle">
	<xsl:choose>
		<xsl:when test="@NEXTSIBLING">
			<xsl:attribute name="bgcolor">yellow</xsl:attribute>
			<xsl:choose>
				<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
					<A><xsl:attribute name="HREF">#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$alt_nextreply"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">&gt;</font></A>
				</xsl:when>
				<xsl:otherwise>
					<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTSIBLING" />#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$alt_nextreply"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">&gt;</font></A>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<font xsl:use-attribute-sets="gadgetfont"><xsl:text>&gt;</xsl:text></font>
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	</TR>
	<TR>
	<TD xsl:use-attribute-sets="cellstyle"><font xsl:use-attribute-sets="gadgetfont">&nbsp;</font></TD>
	<TD xsl:use-attribute-sets="cellstyle">
	<xsl:choose>
		<xsl:when test="@FIRSTCHILD">
			<xsl:attribute name="bgcolor">yellow</xsl:attribute>
			<xsl:choose>
				<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
					<A><xsl:attribute name="HREF">#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$m_firstreplytothis"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">V</font></A>
				</xsl:when>
				<xsl:otherwise>
					<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@FIRSTCHILD" />#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$m_firstreplytothis"/></xsl:attribute><font xsl:use-attribute-sets="gadgetfont">V</font></A>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<font xsl:use-attribute-sets="gadgetfont"><xsl:text>V</xsl:text></font>
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	<TD xsl:use-attribute-sets="cellstyle"><font xsl:use-attribute-sets="gadgetfont">&nbsp;</font></TD>
	</TR>
	</TABLE>
</xsl:if>
	</TD>
	</TR>
	</TBODY>
	</TABLE>
<br/>
<FONT face="{$fontface}" size="2">
					<xsl:call-template name="showpostbody"/>
</FONT>
<br/><br/>
<table width="100%">
<tr>
<td align="left">
<FONT xsl:use-attribute-sets="forumtitlefont">
<A><xsl:attribute name="HREF"><xsl:value-of select="$root"/>AddThread?inreplyto=<xsl:value-of select="@POSTID"/></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
<xsl:value-of select="$m_replytothispost"/></A><br/>

<xsl:if test="@FIRSTCHILD">
<FONT SIZE="1" color="{$fttitle}"><br/>
<xsl:value-of select="$m_readthe"/>
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
<A><xsl:attribute name="HREF">#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><xsl:value-of select="$m_firstreplytothis"/></A><br/>

					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS[EDITOR or MODERATOR]">
						<font size="1"><a target="_top" href="{$root}ModerationHistory?PostID={@POSTID}">moderation history</a></font>
					</xsl:if>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@FIRSTCHILD" />#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><xsl:value-of select="$m_firstreplytothis"/></A><br/>
</xsl:otherwise>
</xsl:choose>
</FONT>
</xsl:if>
</FONT>
</td>
<td align="right">
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS[EDITOR or MODERATOR]">
						<font size="1"><a target="_top" href="{$root}ModerationHistory?PostID={@POSTID}">moderation history</a></font>
					</xsl:if>
			<xsl:if test="@HIDDEN=0">
					<A href="/dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?s_start=1&amp;postID={@POSTID}" target="ComplaintPopup">
						<xsl:attribute name="onClick">
              javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;postID=<xsl:value-of select="@POSTID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:attribute>
						<img width="18" height="16" src="{$imagesource}buttons/complain.gif" border="0" alt="{$alt_complain}"/>
					</A>
			</xsl:if>
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS[EDITOR or MODERATOR]">
						<xsl:text> </xsl:text><a href="{$root}EditPost?PostID={@POSTID}" target = "_top" onClick="javascript:popupwindow('{$root}EditPost?PostID={@POSTID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;">edit</a>
					</xsl:if>
</td>
</tr>
</table>
</xsl:template>

<!--
	<xsl:template match="@HIDDEN" mode="multiposts">
	Author:		Tom Whitehouse
	Context		Called from POST
	Inputs:		attributes - to override attributes defined in the attribute set for the <a> tag
				embodiment - the text/ image used to embody the user complaint link
	Purpose:	Creates a link to the UserComplaint popup page
-->
	<xsl:template match="@HIDDEN" mode="multiposts">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment">
			<img width="18" height="16" src="{$imagesource}buttons/complain.gif" border="0" alt="{$alt_complain}"/>
		</xsl:param>
		<a href="/dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?s_start=1&amp;postID={../@POSTID}" target="ComplaintPopup" onClick="javascript:popupwindow('UserComplaint?PostID={../@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_multiposts">
			<xsl:call-template name="ApplyAttributes"><xsl:with-param name="attributes" select="$attributes"/></xsl:call-template>
			<xsl:copy-of select="$embodiment"/>	
		</a>
	</xsl:template>

<xsl:template match="HEADER">
<br clear="all"/>
<font xsl:use-attribute-sets="headerfont"><b>
<xsl:apply-templates/>
</b></font>
</xsl:template>


</xsl:stylesheet>