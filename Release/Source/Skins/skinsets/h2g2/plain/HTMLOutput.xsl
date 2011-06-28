<?xml version='1.0' encoding='iso-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
				exclude-result-prefixes="msxsl local s dt">
<xsl:import href="../../../base/cssbase.xsl"/>
<xsl:import href="../../../base/text.xsl"/>

<xsl:variable name="sso_serviceid_path">h2g2_plain</xsl:variable>
<xsl:variable name="sso_serviceid_link">h2g2</xsl:variable>
<xsl:variable name="scopename"></xsl:variable>
<xsl:variable name="sitename">h2g2</xsl:variable>
<xsl:variable name="sitedisplayname">h2g2</xsl:variable>
<xsl:variable name="root">/dna/h2g2/plain/</xsl:variable>
<xsl:variable name="imagesource"><xsl:value-of select="$foreignserver"/>/h2g2/skins/dev/images/</xsl:variable>
<xsl:variable name="smileysource">
<xsl:choose>
<xsl:when test="/H2G2/VIEWING-USER/USER/SITEPREFERENCES/BLOB[@VALUE='blue']"><xsl:value-of select="$foreignserver"/>/h2g2/skins/Classic/images/Smilies/</xsl:when>
<xsl:otherwise><xsl:value-of select="$foreignserver"/>/h2g2/skins/Alabaster/images/Smilies/</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="skinname">plain</xsl:variable>

<xsl:variable name="toolbar_width">730</xsl:variable>
<xsl:variable name="showtreegadget">0</xsl:variable>
  <xsl:variable name="bbcpage_variant"/>

<xsl:variable name="mainfontcolour">#000000</xsl:variable>
<xsl:variable name="boxfontcolour">#000000</xsl:variable> <!-- light blue -->
<xsl:variable name="journalfontsize">2</xsl:variable>

<!-- name and researcher ID as displayed on the homepage boxout-->
<xsl:variable name="homepagedetailscolour">blue</xsl:variable>
<xsl:variable name="headercolour">#000000</xsl:variable>
<!-- page background colour -->
<xsl:variable name="bgcolour">#EEEEEE</xsl:variable>
<!-- colour of the button bar tablecell -->
<xsl:variable name="buttonbarbgcolour">#BBBBBB</xsl:variable>
<!-- colours of links -->
<xsl:variable name="alinkcolour">#4444FF</xsl:variable>
<xsl:variable name="linkcolour">#0000FF</xsl:variable>
<xsl:variable name="vlinkcolour">#00FF00</xsl:variable>
<!-- colour of title in top fives box -->
<xsl:variable name="topfivetitle">green</xsl:variable>
<!-- colour of header text in forum -->
<xsl:variable name="forumheader">#AAAAAA</xsl:variable>
<!-- colour of header for referenced researchers -->
<xsl:variable name="refresearchers">blue</xsl:variable>
<!-- colour of header for referenced sites -->
<xsl:variable name="refsites">blue</xsl:variable>
<xsl:variable name="topbar">green</xsl:variable>
<!-- colour of the [3 members] bit on categorisation pages -->
<xsl:variable name="memberscolour">#FFFF44</xsl:variable>
<!-- colour of an empty category -->
<xsl:variable name="emptycatcolour"><xsl:value-of select="$memberscolour"/></xsl:variable>
<!-- colour of an full category -->
<xsl:variable name="fullcatcolour"><xsl:value-of select="$memberscolour"/></xsl:variable>
<!-- colour of an article in a category -->
<xsl:variable name="catarticlecolour"></xsl:variable>

<xsl:variable name="blobbackground">
<xsl:choose>
<xsl:when test="string-length(/H2G2/VIEWING-USER/USER/SITEPREFERENCES/BLOB/@VALUE) &gt; 0"><xsl:value-of select="/H2G2/VIEWING-USER/USER/SITEPREFERENCES/BLOB/@VALUE"/></xsl:when>
<xsl:otherwise>white</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="picturebordercolour">green</xsl:variable>
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
<xsl:variable name="catboxbg"></xsl:variable>
<!-- title colour -->
<xsl:variable name="catboxtitle">black</xsl:variable>
<!-- main link colour -->
<xsl:variable name="catboxmain">blue</xsl:variable>
<!-- sub link colour -->
<xsl:variable name="catboxsublink">red</xsl:variable>
<!-- other link colour -->
<xsl:variable name="catboxotherlink">green</xsl:variable>
<xsl:variable name="catboxlinecolour">black</xsl:variable>

<xsl:variable name="horizdividers">black</xsl:variable>
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
<xsl:variable name="fontface">Verdana, Arial, Helvetica, sans-serif</xsl:variable>
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


<xsl:variable name="skinlist">
<SKINDEFINITION>
	<NAME>Alabaster</NAME>
	<DESCRIPTION>Alabaster</DESCRIPTION>
</SKINDEFINITION>
<SKINDEFINITION>
	<NAME>Classic</NAME>
	<DESCRIPTION>Classic GOO</DESCRIPTION>
</SKINDEFINITION>
<SKINDEFINITION>
	<NAME>brunel</NAME>
	<DESCRIPTION>Brunel</DESCRIPTION>
</SKINDEFINITION>
<SKINDEFINITION>
	<NAME>plain</NAME>
	<DESCRIPTION>Plain</DESCRIPTION>
</SKINDEFINITION>
</xsl:variable>

<xsl:template name='primary-template'>
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html 
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:text>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<xsl:call-template name="insert-header"/>
<body>
<!-- top navigation / banner space -->
<!--<xsl:call-template name="bbcitoolbar"/>-->

<div id="header">
<div id="leftheader">
<FONT class="bbcpageToplefttd" 
            face="arial, helvetica, sans-serif" size="1">
			<xsl:apply-templates mode="maindate" select="DATE"/>
			<BR/><A class="bbcpageTopleftlink" 
            href="http://www.bbc.co.uk/cgi-bin/education/betsie/parser.pl" 
            style="TEXT-DECORATION: underline">Text 
      only</A></FONT>
</div>
<div id="rightheader">
<div class="bannerimg"/> 
</div>
</div>
<!--
<div id="main">
  <div id="centerRight">
    <div id ="center">
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
      <p>Center Contents</p>
    </div>
    <div id="right">
      <p>Right Contents</p>
    </div>
  </div>
  <div id="left">
    <p>Left Contents</p>
  </div>
  <div id="footer">
    <p>Footer Contents</p>
  </div>
</div>
-->
<!--
<table border="0" cellpadding="0" cellspacing="0" width="730">
<tr><td valign="top" align="left" width="110">
	<table align="left" border="0" cellpadding="0" cellspacing="0" width="110" style="MARGIN: 0px" >
		<tr>
			<td width="8"><img src="{$imagesource}t.gif" width="8" height="1"/>
			</td>
			<td>
				<xsl:call-template name="navbar"/>
			</td>
			<td width="8"><img src="{$imagesource}t.gif" width="8" height="1"/>
			</td>
		</tr>
	</table>
</td>
<td valign="top" align="left" width="480">
<xsl:call-template name="insert-subject"/>
<xsl:call-template name="insert-mainbody"/>
</td>
<td valign="top" align="left" width="140">
<table border="0" cellpadding="0" cellspacing="0" width="110">
<xsl:call-template name="insert-sidebar"/>
</table>
</td>
</tr>
</table>
-->
<div id="bodysection">
<table class="bodytable">
<tr class="bodyrow">
<td valign="top" class="leftcolumn">
<xsl:call-template name="navbar"/>
</td>
<td valign="top" class="centrecolumn">
<!--	<xsl:call-template name="sso_statusbar"/> -->
	<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL and /H2G2[@TYPE='ARTICLE']">
		<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="articlepage"/><br/>
	</xsl:if>
<xsl:call-template name="insert-subject"/>
<xsl:call-template name="insert-mainbody"/>
</td>
<td valign="top" class="rightcolumn">
<xsl:call-template name="insert-sidebar"/>
</td>
</tr>
<tr><td colspan="3" class="footer">
<div class="copyrightnotice"><a href="/terms/"><font size="1" face="Arial,Helvetica,sans-serif"><xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text> BBC MMII</font></a></div>
<div class="terms"><a href="/terms/"><font size="1" face="Arial,Helvetica,sans-serif">Terms &amp; Conditions</font></a> | <a href="/privacy/"><font size="1" face="Arial,Helvetica,sans-serif">Privacy</font></a></div>
</td></tr>
</table>
</div>
</body>
</html>
</xsl:template>
<xsl:template match="CRUMBTRAILS" mode="articlepage">
	<xsl:apply-templates select="CRUMBTRAIL" mode="articlepage"/>
</xsl:template>
<xsl:template match="CRUMBTRAIL" mode="articlepage">
	<xsl:apply-templates select="ANCESTOR[position() &gt; 1]" mode="articlepage"/>
	<br/>
</xsl:template>
<xsl:template match="ANCESTOR" mode="articlepage">
	<font xsl:use-attribute-sets="mainfont" size="1">
		<a href="C{NODEID}">
			<xsl:value-of select="NAME"/>
		</a>
		<xsl:if test="not(position() = last())">
			<xsl:text> / </xsl:text>
		</xsl:if>
	</font>
</xsl:template>
<xsl:template match="xxxxxH2G2[@TYPE='FORUMFRAME']">
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
<div class="navbar">
	<xsl:choose>
		<xsl:when test="PAGEUI/REGISTER[@VISIBLE=1]">
			<a target="_top" href="{$registerlink}">
				
				<xsl:value-of select="$alt_register"/>
			</a><br/>
			<a target="_top" href="{$signinlink}">
				<xsl:value-of select="$alt_login"/>
			</a><br/>
<!--
<form METHOD="post" ACTION="{$foreignserver}/cgi-perl/signon/mainscript.pl">
<input TYPE="hidden" NAME="service" VALUE="h2g2"/><input TYPE="hidden" NAME="c_login" VALUE="login"/>
<input TYPE="hidden" NAME="ptrt" VALUE="http://local.bbc.co.uk/dna/h2g2/plain/SSO"/>
<p>Username: <input TYPE="text" size="10" NAME="username"/></p>
<p>Password: <input TYPE="password" size="10" NAME="password"/></p>
<p><input TYPE="submit" name="submit" value="Login"/></p>
</form>
-->
			<a target="_top" href="{$root}"><xsl:value-of select="$alt_frontpage"/></a><br/>
		</xsl:when>
		<xsl:otherwise>
			<a target="_top" href="{$root}"><xsl:value-of select="$alt_frontpage"/></a><br/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="PAGEUI/MYHOME[@VISIBLE=1]">
		<a target="_top" >
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_myhome"/></xsl:attribute>
			<xsl:value-of select="$alt_myspace"/>
		</a><br/>
		<a target="_h2g2conv" onClick="popupwindow('{$root}MP{VIEWING-USER/USER/USERID}?s_type=pop&amp;s_upto=&amp;s_target=conversation','Conversations','scrollbars=1,resizable=1,width=140,height=400');return false;" href="{$root}MP{VIEWING-USER/USER/USERID}?s_type=pop">
			My Conversations
		</a><br/>
	</xsl:if>
<!--
	<a target="_top" href="{$root}Read" ><xsl:value-of select="$alt_read"/></a><br/>
	<a target="_top" href="{$root}Talk"><xsl:value-of select="$alt_talk"/></a><br/>
	<a target="_top" href="{$root}Contribute"><xsl:value-of select="$alt_contribute"/></a><br/>
-->
	<xsl:if test="PAGEUI/DONTPANIC[@VISIBLE=1]">
		<a target="_top">
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_dontpanic"/></xsl:attribute>
			<xsl:value-of select="$alt_help"/>
		</a><br/>
	</xsl:if>
	<a target="_top" href="{$root}Feedback" ><xsl:value-of select="$alt_feedbackforum"/></a><br/>
	<a href="javascript:popusers('{$root}online');"><xsl:value-of select="$alt_whosonline"/></a><br/>
	<xsl:if test="PAGEUI/MYDETAILS[@VISIBLE=1]">
		<a target="_top">
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_mydetails"/></xsl:attribute>
			<xsl:value-of select="$alt_preferences"/>
		</a><br/>
	</xsl:if>
	<xsl:if test="PAGEUI/LOGOUT[@VISIBLE=1]">
		<a target="_top" >
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_logout"/></xsl:attribute>
			<xsl:value-of select="$alt_logout"/>
		</a><br/>
	</xsl:if>
	<div class="searchbox">
	<form method="GET" action="{$root}Search" target="_top">
		<input type="hidden" name="searchtype" value="goosearch"/>
		<input type="text" name="searchstring" value="" size="10" />
		<input type="submit" name="dosearch" value="search"/>
	</form>
	</div>
</div>
</xsl:template>

<xsl:template name="FRONTPAGE_SIDEBAR">
	<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION"/>
	<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME != 'LeastViewed' or @NAME != 'LeastViewed']" />
</xsl:template>

<xsl:template match="TOP-FIVE">
<xsl:variable name="topfivenumtoshow">
<xsl:choose>
<xsl:when test="@NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser'">5</xsl:when>
<xsl:otherwise>100</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<div xsl:use-attribute-sets="topfivetitle">
<xsl:value-of select="TITLE" /></div>
	<div class="topfivelist">
<xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt;= $topfivenumtoshow]|TOP-FIVE-FORUM[position() &lt;= $topfivenumtoshow]"/>
</div>
</xsl:template>

<xsl:variable name="cssstylesheet_path">
<xsl:choose>
<xsl:when test="string-length(/H2G2/VIEWING-USER/USER/SITEPREFERENCES/PLAINCSS/@VALUE) &gt; 0">
<xsl:value-of select="/H2G2/VIEWING-USER/USER/SITEPREFERENCES/PLAINCSS/@VALUE"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$foreignserver"/>/h2g2/skins/style.css</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:template name="insert-headelements">
<link rel="StyleSheet" href="{$cssstylesheet_path}" type="text/css" />
<META NAME="robots" CONTENT="{$robotsetting}"/>
<STYLE type="text/css">
.bbcpageShadow {
	BACKGROUND: url(/images/bg.gif) #666666
}
.bbcpageShadowLeft {
	BACKGROUND: url(/images/bg.gif) #999999 repeat-y
}
.bbcpageBar {
	BACKGROUND: url(/images/v.gif) #999999 repeat-y
}
.bbcpageBar2 {
	BACKGROUND: url(/images/v.gif?) #999999 repeat-y
}
.bbcpageSearchL {
	BACKGROUND: url(/images/sl.gif) #666666 no-repeat
}
.bbcpageSearch {
	BACKGROUND: url(/images/st.gif) #666666 repeat-x
}
.bbcpageSearch2 {
	BACKGROUND: url(/images/st.gif?) #666666 repeat-x
}
.bbcpageSearchR {
	BACKGROUND: url(/images/sr.gif) #999999 no-repeat
}
.bbcpageBlack {
	BACKGROUND-COLOR: #000000
}
.bbcpageGrey {
	BACKGROUND: #999999
}
.bbcpageGreyT {
	BACKGROUND: url(/images/t.gif) #999999
}
.bbcpageWhite {
	COLOR: #ffffff; FONT-FAMILY: tahoma,arial,helvetica,sans-serif; TEXT-DECORATION: none
}
A.bbcpageWhite {
	COLOR: #ffffff; FONT-FAMILY: tahoma,arial,helvetica,sans-serif; TEXT-DECORATION: none
}
A.bbcpageWhite:link {
	COLOR: #ffffff; FONT-FAMILY: tahoma,arial,helvetica,sans-serif; TEXT-DECORATION: none
}
A.bbcpageWhite:hover {
	COLOR: #ffffff; FONT-FAMILY: tahoma,arial,helvetica,sans-serif; TEXT-DECORATION: none
}
A.bbcpageWhite:visited {
	COLOR: #ffffff; FONT-FAMILY: tahoma,arial,helvetica,sans-serif; TEXT-DECORATION: none
}
</STYLE>
		<script language="JavaScript">
<xsl:comment>
function popusers(link)
{
	popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
}

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}
</xsl:comment>
</script>

</xsl:template>

<xsl:template match="FORUMTHREADPOSTS/POST">
	<xsl:param name="ptype" select="'frame'"/>
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<TBODY>
			<TR>
				<TD width="100%" COLSPAN="2">
					<HR size="2"/>
				</TD>
				<TD nowrap="1">
					<span xsl:use-attribute-sets="forumsubfont">
						<xsl:apply-templates select="@POSTID" mode="CreateAnchor"/>
						<xsl:choose>
							<xsl:when test="@PREVINDEX">
								<xsl:apply-templates select="@PREVINDEX" mode="multiposts"/>		
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_prev"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> | </xsl:text>
						<xsl:choose>
							<xsl:when test="@NEXTINDEX">
								<xsl:apply-templates select="@NEXTINDEX" mode="multiposts"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_next"/>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</TD>
			</TR>
			<TR>
				<TD ALIGN="left">
					<span xsl:use-attribute-sets="forumsubjectlabel">
						<xsl:value-of select="$m_fsubject"/>
					</span> 
					<span xsl:use-attribute-sets="forumsubject">
							<xsl:call-template name="postsubject"/>
					</span>
					<br/>
					<FONT xsl:use-attribute-sets="forumpostedlabel">
						<xsl:value-of select="$m_posted"/><xsl:apply-templates select="DATEPOSTED/DATE"/>
					</FONT>
					<xsl:if test="not(@HIDDEN &gt; 0)">
						<span xsl:use-attribute-sets="forumpostedlabel">
							<xsl:value-of select="$m_by"/>
						</span>
						<span xsl:use-attribute-sets="forumposted">
							<xsl:apply-templates select="USER/USERNAME" mode="multiposts"/>
						</span>
						<xsl:if test="USER[USERID=/H2G2/ONLINEUSERS/USER/USERID]"><span class="onlinemarker">*</span></xsl:if>
					</xsl:if>
<!--
					<br/>
					<select name="modit">
					<option value="0">Choose a rating</option>
					<option value="+1">Funny</option>
					<option value="+1">Interesting</option>
					<option value="+1">Accurate</option>
					<option value="+1">Enlightening</option>
					<option value="-1">Moronic</option>
					<option value="-1">Swearing</option>
					<option value="-1">Unpleasant</option>
					<option value="-1">Off topic</option>
					<option value="-1">Moronic</option>
					</select>
					<input type="button" name="mod" value="Rate"/>
					<br/>
-->
					<xsl:if test="@INREPLYTO">
						<br/>
						<span xsl:use-attribute-sets="forumsmall">
							<xsl:value-of select="$m_inreplyto"/>
							<xsl:apply-templates select="@INREPLYTO" mode="multiposts"/>
						</span>
					</xsl:if>
					<xsl:if test="@INREPLYTO|@PREVSIBLING|@NEXTSIBLING">
						<br/>
					</xsl:if>
				</TD>
				<TD align="right" valign="top">
				</TD>
				<TD nowrap="1" ALIGN="center" valign="top">
					<span class="postnumber">
						<xsl:apply-templates select="." mode="postnumber"/>
						<br/>
					</span>
					<xsl:if test="$showtreegadget=1">
						<xsl:call-template name="showtreegadget">
							<xsl:with-param name="ptype" select="$ptype"/>
						</xsl:call-template>
					</xsl:if>
				</TD>
			</TR>
		</TBODY>
	</table>
	<br/>
	<span class="postbody">
		<xsl:call-template name="showpostbody"/>
	</span>
	<br/><br/>
	<table width="100%">
		<tr>
			<td align="left">
				<span xsl:use-attribute-sets="forumtitlefont">
					<xsl:apply-templates select="@POSTID" mode="ReplyToPost"/>
					<br/>
					<xsl:if test="@FIRSTCHILD">
						<span class="readreply"><br/>
							<xsl:value-of select="$m_readthe"/>
							<xsl:apply-templates select="@FIRSTCHILD" mode="multiposts"/>
						</span>
					</xsl:if>
				</span>
			</td>
			<td align="right">
				<xsl:if test="$test_EditorOrModerator">
					<span class="smallfont">
						<xsl:apply-templates  select="@POSTID" mode="moderation"/>
					</span>
				</xsl:if>
				<xsl:if test="@HIDDEN=0">
					<xsl:apply-templates select="@HIDDEN" mode="multiposts"/>
				</xsl:if>
				<xsl:if test="$test_EditorOrModerator">
					<span class="smallfont">
						<xsl:text> </xsl:text><xsl:apply-templates select="@POSTID" mode="editpost"/>
					</span>
				</xsl:if>
			</td>
		</tr>
	</table>
</xsl:template>


</xsl:stylesheet>