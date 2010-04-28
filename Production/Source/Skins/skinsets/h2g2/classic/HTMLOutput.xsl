<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
				exclude-result-prefixes="msxsl local s dt">

<xsl:import href="../../../base/base.xsl"/>
<xsl:import href="../../../base/text.xsl"/>
<xsl:output method="html" version="4.0" media-type="text/html" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO-8859-1"/>

<xsl:variable  name="toolbar_searchcolour"><xsl:value-of select="$headerbgcolour"/></xsl:variable>
<!--<xsl:variable name="showtreegadget">1</xsl:variable>-->
<xsl:variable name="root">/dna/h2g2/classic/</xsl:variable>
<xsl:variable name="sso_assets_path">/h2g2/sso/h2g2_classic_resources</xsl:variable>
<xsl:variable name="sso_serviceid_link">h2g2</xsl:variable>
<xsl:variable name="imagesource"><xsl:value-of select="$foreignserver"/>/h2g2/skins/Classic/images/</xsl:variable>
<xsl:variable name="imagesource2"><xsl:value-of select="$foreignserver"/>/h2g2/skins/Classic/images/</xsl:variable>
<!--xsl:variable name="root">http://www.bbc.co.uk/dna/h2g2/classic/</xsl:variable>
<xsl:variable name="imagesource">http://www.bbc.co.uk/h2g2/skins/Classic/images/</xsl:variable>
<xsl:variable name="imagesource2">http://www.bbc.co.uk/h2g2/skins/Classic/images/</xsl:variable-->

<xsl:variable name="skingraphics"><xsl:value-of select="$imagesource"/></xsl:variable>
<xsl:variable name="smileysource"><xsl:value-of select="$imagesource2"/>Smilies/</xsl:variable>
<xsl:variable name="skinname">Classic</xsl:variable>

<xsl:variable name="mainfontcolour">#FFFFFF</xsl:variable>
<xsl:variable name="boxfontcolour">#CCFFFF</xsl:variable> <!-- light blue -->

<xsl:variable name="headercolour">#FF6600</xsl:variable>
<xsl:variable name="bgcolour">#000066</xsl:variable>
<xsl:variable name="alinkcolour">#FFFFFF</xsl:variable>
<xsl:variable name="linkcolour">#FFCC99</xsl:variable>
<xsl:variable name="vlinkcolour">#FF9966</xsl:variable>

<xsl:variable name="verticalbarcolour">#99CCCC</xsl:variable>

<xsl:variable name="boxoutcolour">#CCFFFF</xsl:variable>
<xsl:variable name="boxholderfontcolour">#33FFFF</xsl:variable>
<xsl:variable name="boxholderleftcolour">#000099</xsl:variable>
<xsl:variable name="boxholderrightcolour">#006699</xsl:variable>
<xsl:variable name="headertopedgecolour">#CCCCCC</xsl:variable>
<xsl:variable name="headerbgcolour">#006699</xsl:variable>
<xsl:variable name="pullquotecolour">#BB3300</xsl:variable>
<xsl:variable name="welcomecolour">#ff6666</xsl:variable>

<xsl:variable name="topfivetitle">#00ffcc</xsl:variable>
<xsl:variable name="bbcpage_variant"/>
<!-- font details -->
<xsl:variable name="fontsize">2</xsl:variable>
<xsl:variable name="fontface">Arial, Helvetica, sans-serif</xsl:variable>

<xsl:variable name="ftfontsize">2</xsl:variable>

<!-- colours for links in forum threads page -->

<xsl:variable name="ftfontcolour">#000000</xsl:variable>
<xsl:variable name="ftbgcolour">#99CCCC</xsl:variable>
<xsl:variable name="ftbgcolour2">#77BBBB</xsl:variable>
<xsl:variable name="ftbgcoloursel">#000033</xsl:variable>
<xsl:variable name="ftalinkcolour">#333333</xsl:variable>
<xsl:variable name="ftlinkcolour">#000000</xsl:variable>
<xsl:variable name="ftvlinkcolour">#883333</xsl:variable>
<xsl:variable name="ftcurrentcolour">#FF0000</xsl:variable>
<xsl:variable name="forumsourcelink">#FFFF66</xsl:variable>


<xsl:variable name="fttitle">#00FFFF</xsl:variable>

<!-- colour of the [3 members] bit on categorisation pages -->
<xsl:variable name="memberscolour">yellow</xsl:variable>
<!-- colour of an empty category -->
<xsl:variable name="emptycatcolour">#ccaa88</xsl:variable>
<!-- colour of an full category -->
<xsl:variable name="fullcatcolour"><xsl:value-of select="$linkcolour"/></xsl:variable>
<!-- colour of an article in a category -->
<xsl:variable name="catarticlecolour">#EEFFFF</xsl:variable>

<!-- categorisation boxout colours -->
<!-- background colour -->
<xsl:variable name="catboxbg">#000033</xsl:variable>
<!-- title colour -->
<xsl:variable name="catboxtitle">#00ffcc</xsl:variable>
<!-- main link colour -->
<xsl:variable name="catboxmain">#FFFF33</xsl:variable>
<!-- sub link colour -->
<xsl:variable name="catboxsublink">white</xsl:variable>
<!-- other link colour -->
<xsl:variable name="catboxotherlink"><xsl:value-of select="$linkcolour"/></xsl:variable>
<xsl:variable name="catboxlinecolour"><xsl:value-of select="$boxfontcolour"/></xsl:variable>

<xsl:variable name="blobbackground">blue</xsl:variable>

<xsl:variable name="picturebordercolour">white</xsl:variable>

<!-- Categorisation styles -->

<xsl:variable name="catdecoration">underline ! important</xsl:variable>
<xsl:variable name="catcolour"></xsl:variable>
<xsl:variable name="artdecoration">underline ! important</xsl:variable>
<xsl:variable name="artcolour"></xsl:variable>
<xsl:variable name="hovcatdecoration">underline ! important</xsl:variable>
<xsl:variable name="hovcatcolour"></xsl:variable>
<xsl:variable name="hovartdecoration">underline ! important</xsl:variable>
<xsl:variable name="hovartcolour"></xsl:variable>
<xsl:variable name="catfontheadersize">5</xsl:variable>
<xsl:variable name="catfontheadercolour">yellow</xsl:variable>

<xsl:variable name="subbadges">
<GROUPBADGE NAME="SUBS">
	<a href="{$root}SubEditors">
		<img border="0" src="{$imagesource}n_subeditor.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="ACES">
	<a href="{$root}Aces">
		<img border="0" src="{$imagesource}n_ace.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="FIELDRESEARCHERS">
	<a href="{$root}University">
		<img border="0" SRC="{$imagesource}n_fieldresearcher.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="SECTIONHEADS">
	<a href="{$root}SectionHeads"><img border="0" SRC="{$imagesource}section_head.gif"/></a><br/>
</GROUPBADGE>
<GROUPBADGE NAME="GURUS">
	<a href="{$root}Gurus">
		<img border="0" src="{$imagesource}n_guru.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="SCOUTS">
	<a href="{$root}Scouts">
		<img border="0" src="{$imagesource}n_scout.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="COMMUNITYARTISTS">
	<a href="{$root}CommunityArtists">
		<img border="0" src="{$imagesource}n_artist.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="TRANSLATORS">
	<a href="{$root}translators">
		<img border="0" src="{$imagesource}b_translator.gif" width="51" height="113"/>
	</a><br/>
</GROUPBADGE>
<GROUPBADGE NAME="POSTREPORTERS">
	<a href="{$root}ThePost">
		<img border="0" src="{$imagesource}n_postreporter.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="EDITOR">
	<a href="{$root}Team">
		<img border="0" src="{$imagesource}n_staff.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="PHOTOGRAPHER">
	<a href="{$root}Photographers">
		<img border="0" src="{$imagesource}n_photographer.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="UNDERGUIDE">
	<a href="{$root}Underguide">
		<img border="0" src="{$imagesource}n_underguide.gif" width="75" height="166"/>
	</a>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="SCAVENGER">
  <a href="{$root}Scavengers">
    <img border="0" src="{$imagesource}n_scavenger.gif" alt="scavenger" width="75" height="166"/>
  </a>
  <br/>
</GROUPBADGE>
<GROUPBADGE NAME="FORMERSTAFF">
	<img border="0" src="{$imagesource}n_formerstaff.gif" width="75" height="166"/>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="BBCTESTER">
	<img border="0" src="{$imagesource}n_bbctester.gif" width="75" height="166"/>
	<br/>
</GROUPBADGE>

<GROUPBADGE NAME="PROLIFICSCRIBE0">
	<img src="{$imagesource}01_Edited_Entries.jpg" alt="Edited Entry badge" width="75" height="76"/>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="PROLIFICSCRIBE1">
	<img src="{$imagesource}25_Edited_Entries.gif" alt="25 Edited Entries" width="75" height="76"/>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="PROLIFICSCRIBE2">
	<img src="{$imagesource}50_Edited_Entries.gif" alt="50 Edited Entries" width="75" height="76"/>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="PROLIFICSCRIBE3">
	<img src="{$imagesource}75_Edited_Entries.gif" alt="75 Edited Entries" width="75" height="76"/>
	<br/>
</GROUPBADGE>
<GROUPBADGE NAME="PROLIFICSCRIBE4">
	<img src="{$imagesource}100_Edited_Entries.gif" alt="100 Edited Entries" width="75" height="76"/>
	<br/>
</GROUPBADGE>
  <GROUPBADGE NAME="PROLIFICSCRIBE5">
    <img src="{$imagesource}150_Edited_Entries.gif" alt="150 Edited Entries" width="75" height="76"/>
    <br/>
  </GROUPBADGE>
  <GROUPBADGE NAME="PROLIFICSCRIBE6">
    <img src="{$imagesource}200_Edited_Entries.gif" alt="200 Edited Entries" width="75" height="76"/>
    <br/>
  </GROUPBADGE>

</xsl:variable>

<xsl:attribute-set name="journaltitle" use-attribute-sets="mainfont">
	<xsl:attribute name="size">2</xsl:attribute>
	<xsl:attribute name="color"><xsl:value-of select="$boxfontcolour"/></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="frontpagefont" use-attribute-sets="mainfont">
<xsl:attribute name="size">2</xsl:attribute>
<xsl:attribute name="color"><xsl:value-of select="$boxfontcolour"/></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mainbodytag">
<xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolour"/></xsl:attribute>
<xsl:attribute name="text"><xsl:value-of select="$mainfontcolour"/></xsl:attribute>
<xsl:attribute name="MARGINHEIGHT">0</xsl:attribute>
<xsl:attribute name="MARGINWIDTH">0</xsl:attribute>
<xsl:attribute name="TOPMARGIN">0</xsl:attribute>
<xsl:attribute name="LEFTMARGIN">0</xsl:attribute>
<xsl:attribute name="link"><xsl:value-of select="$linkcolour"/></xsl:attribute>
<xsl:attribute name="vlink"><xsl:value-of select="$vlinkcolour"/></xsl:attribute>
<xsl:attribute name="alink"><xsl:value-of select="$alinkcolour"/></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mNEWREGISTER_error_font">
<xsl:attribute name="color">yellow</xsl:attribute>
</xsl:attribute-set>

<!--
<xsl:attribute-set name="RetToEditorsLinkAttr">
Author:		Igor Loboda
Purpose:	Used to specify attributes for <A> tag for Return to Editors link
-->
<xsl:attribute-set name="RetToEditorsLinkAttr">
	<xsl:attribute name="onClick">popupwindow('<xsl:value-of select="/H2G2/PAGEUI/ENTRY-SUBBED/@LINKHINT"/>','SubbedEntry','resizable=1,scrollbars=1,width=375,height=300');return false;</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mUSERID_UserName_Name" use-attribute-sets="forumposted">
	<xsl:attribute name="color"></xsl:attribute>
	<xsl:attribute name="size"></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mPOSTTHREADFORM_Subj" use-attribute-sets="mainfont">
	<xsl:attribute name="size">3</xsl:attribute>
</xsl:attribute-set>


<!--
	template: <H2G2>
	This is the primary match for all H2G2 elements, unless one of the specific
	matches on the TYPE attribute catch it first. This is the main template
	for general pages, and has a lot of conditional stuff which might be
	better off in a more specialised stylesheet.

-->

<xsl:template name='primary-template'>
<html>
<xsl:call-template name="insert-header"/>
<body xsl:use-attribute-sets="mainbodytag">
<xsl:call-template name="bbcitoolbar"/>
<xsl:comment>Time taken: <xsl:value-of select="/H2G2/TIMEFORPAGE"/></xsl:comment>
<xsl:apply-templates mode="map" select="." />
<xsl:apply-templates mode="topgoo" select="." />
<table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
  <tr> 
<xsl:apply-templates mode="buttons" select="." />
<!--    <td align="left" valign="top" rowspan="3">111<img src="{$imagesource}blank.gif" width="20" height="1"/></td>
-->
<!--    <td align="left" valign="top">&nbsp;</td>
-->
    <td align="left" valign="top" width="100%" colspan="6">
		<!--xsl:call-template name="insert-strapline"/--> 
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
		<td width="12"><img src="{$imagesource}blank.gif" alt="" width="12" height="43"/></td><td valign="top">
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
					<xsl:call-template name="sso_statusbar"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="identity_statusbar">
						<xsl:with-param name="h2g2class">id_brunel</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</td></tr> 
		</table>
	</td>
<!--    <td align="left" valign="top">444&nbsp;</td>
    <td align="left" valign="top" colspan="2">555&nbsp;</td>
    <td align="left" valign="top">666&nbsp;</td>
    <td align="left" valign="top">777&nbsp;</td>-->
  </tr>
  <tr>
    <td align="left" valign="top" colspan="2">
   	<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL and /H2G2[@TYPE='ARTICLE']">
   		
		<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="articlepage"/>
		<img src="{$imagesource}tiny.gif" alt="" width="1" height="6"/>
	</xsl:if>

	<xsl:call-template name="insert-subject"/>
	</td>
    <td><img src="{$imagesource}blank.gif" width="23" height="1"/></td>
    <td bgcolor="{$verticalbarcolour}" rowspan="2"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
    <td><img src="{$imagesource}blank.gif" width="10" height="1"/></td>
    <td align="left" valign="top" rowspan="2" width="110">
    	<table cellpadding="0" cellspacing="0" border="0" width="110">
    		<tr>
    			<td>
    				<xsl:call-template name="insert-sidebar"/>
    			</td>
    		</tr>
    	</table>
	
	<img src="{$imagesource}blank.gif" width="110" height="1"/></td>
    <td><img src="{$imagesource}blank.gif" width="15" height="1"/></td>
  </tr>
  <tr> 
<!--    <td align="left" valign="top"><img src="{$imagesource}blank.gif" width="30" height="1"/></td>
-->
    <td align="left" valign="top"><!--here width="100%"-->
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
	<td><xsl:call-template name="insert-bodymargin"/>
	</td>
	<td width="100%">
	<FONT face="arial, helvetica, sans-serif" SIZE="3">
	<xsl:call-template name="insert-mainbody"/>
	</FONT>
<!-- place the complaints text and link -->
<p align="center">
	<xsl:call-template name="m_pagebottomcomplaint"/>
</p>
<!-- do the copyright notice -->
<!--xsl:call-template name="CopyrightNotice"/-->
<xsl:call-template name="barley_footer"/>
	</td>
	</tr>
	</table></td>
    <td colspan="2"><img src="{$imagesource}blank.gif" width="15" height="1"></img></td>
<!--	<td>&nbsp;</td>-->
	<td>&nbsp;</td>
<!--	<td>&nbsp;</td>-->
  </tr>
</table>
</body>
</html>
</xsl:template>
<xsl:template match="CRUMBTRAILS" mode="articlepage">
	<xsl:apply-templates select="CRUMBTRAIL" mode="articlepage">
		<xsl:sort select="ANCESTOR[2]/NAME"/>
		<xsl:sort select="ANCESTOR[3]/NAME"/>
		<xsl:sort select="ANCESTOR[4]/NAME"/>
		<xsl:sort select="ANCESTOR[5]/NAME"/>
		<xsl:sort select="ANCESTOR[6]/NAME"/>
		<!-- To be replaced by generic function that sorts with an unknown number of sort keys. -->
	</xsl:apply-templates>
</xsl:template>
<xsl:template match="CRUMBTRAIL" mode="articlepage">
	<img src="{$imagesource}tiny.gif" alt="" width="25" height="1"/>
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


<xsl:template match="PAGE-OWNER">
	<xsl:variable name="lastpostbyusersort">
		<xsl:for-each select="/H2G2/RECENT-POSTS/POST-LIST/POST/THREAD/LASTUSERPOST/DATEPOSTED/DATE">
			<xsl:sort select="concat(@YEAR, @MONTH, @DAY, @HOURS, @MINUTES, @SECONDS)" order="descending"/>
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="lastpostbyuser">
		<xsl:apply-templates select="msxsl:node-set($lastpostbyusersort)/DATE[1]"/>
	</xsl:variable>
	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="2" color="white">
					<xsl:value-of select="$m_userdata"/>
					<br />
					<br/>
				</font>
			</td>
		</tr>
		<tr valign="top"> 
			<td align="left">
				<font face="Arial, Helvetica, sans-serif" size="1">
					<xsl:value-of select="$m_researcher"/>
				</font>
				
				<font face="Arial, Helvetica, sans-serif" size="1" color="yellow">
					<xsl:value-of select="USER/USERID" />
				</font>
			</td>
		</tr>
		<tr>
			<td align="left" valign="top">
				<font face="Arial, Helvetica, sans-serif" size="1">
					<xsl:value-of select="$m_namecolon"/>
						<xsl:apply-templates select="USER" mode="showonline">
							<xsl:with-param name="symbol">
								<img src="{$imagesource}online.gif" alt="Online Now"/>
							</xsl:with-param>
						</xsl:apply-templates>

					<font color="yellow">
						<xsl:apply-templates select="USER" mode="username" />
					</font>
					<!-- put in a link to InspectUser for editors -->
					<xsl:if test="$test_IsEditor">
						<br/>
						<xsl:apply-templates select="USER/USERID" mode="Inspect"/>
						<br/>
						<a href="{$root}ModerationHistory?h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Moderation History</a>
						<br/>
					</xsl:if>
			
				</font>
			</td>
		</tr>
		<tr valign="top"> 
			<td align="left">
				<font face="Arial, Helvetica, sans-serif" size="1">
					<xsl:choose>
						<xsl:when test="msxsl:node-set($lastpostbyusersort)/DATE">
							<xsl:value-of select="$m_myconvslastposted"/>
							<font color="yellow">
								<xsl:value-of select="$lastpostbyuser"/>
							</font>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$m_norecentpostings"/>
						</xsl:otherwise>
					</xsl:choose>		
				</font>
			</td>
		</tr>

		<xsl:if test="$test_CanEditMasthead">
			<tr>
				<td>
					<nobr>
						<xsl:call-template name="UserEditMasthead">
							<xsl:with-param name="img">
								<img src="{$imagesource}newbuttons/editpage.gif" hspace="0" vspace="0" border="0" name="EditPage" alt="{$m_editpagetbut}" title="{$alt_editthispage}"/>
							</xsl:with-param>
						</xsl:call-template>
					</nobr>
				</td>
			</tr>
		</xsl:if>
								<xsl:if test="$ownerisviewer=0 and $registered=1">
			<tr>
				<td>
									<font size="2">
									<a href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}">
										Add to Friends
									</a>
									</font>
				</td>
			</tr>
								</xsl:if>
	</table>
	<br/>
	<xsl:apply-templates select="USER/GROUPS"/>
	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont" size="1">
					<xsl:call-template name="m_textonlylink"/>
				</font>
			</td>
		</tr>
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont" size="1">
					<xsl:call-template name="m_mailtofriend"/>
				</font>
			</td>
		</tr>
	</table>
	<br/>
	<xsl:call-template name="m_entrysidebarcomplaint"/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MORETHREADSFRAME"]'>
<html><TITLE>h2g2</TITLE>
<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="#FFFF66" vlink="#FF9900" alink="#FFFF99">
<FONT face="arial, helvetica, sans-serif" SIZE="2">
<div align="center">
<FONT face="arial, helvetica, sans-serif" SIZE="2"><b><xsl:value-of select="$m_otherconv"/></b></FONT>
</div>
<xsl:apply-templates select="FORUMTHREADS" />
<!--xsl:call-template name="newconversationbutton"/-->
	<xsl:if test="$test_AllowNewConversationBtn">
		<xsl:apply-templates select="FORUMTHREADS/@FORUMID" mode="THREADS_MAINBODY_UI"/>
	</xsl:if>
</FONT>
</body>
</html>
</xsl:template>

<xsl:template match="@FORUMID" mode="THREADS_MAINBODY_UI">
	<center>
		<xsl:apply-templates select="." mode="THREADS_MAINBODY">
			<xsl:with-param name="img"><img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}" /></xsl:with-param>
		</xsl:apply-templates>
	</center>
</xsl:template>

<xsl:template match='H2G2[@TYPE="FRAMESOURCE"]'>
<html><TITLE>h2g2</TITLE>
<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0"  link="#FFFF66" vlink="#FF9900" alink="#FFFF99">
<FONT face="arial, helvetica, sans-serif" SIZE="2">
<xsl:apply-templates select="FORUMSOURCE"/>
</FONT>
</body>
</html>
</xsl:template>

<xsl:template match='H2G2[@TYPE="FRAMETHREADS"]'>
<html>
<HEAD>
<META NAME="robots" CONTENT="{$robotsetting}"/>
<TITLE>h2g2</TITLE>
<STYLE type="text/css">
<xsl:comment>
DIV.browse A {  text-decoration: none; color: #FFFF33}
DIV.browse A:hover   { text-decoration: underline ! important; color: white}
</xsl:comment>
</STYLE>
</HEAD>
<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0"  link="#FFFF66" vlink="#FF9900" alink="#FFFF99">
<FONT face="arial, helvetica, sans-serif" SIZE="2">
<xsl:apply-templates select="SUBSCRIBE-RESULT"/>
<xsl:choose>
<xsl:when test="FORUMTHREADS">

						<TABLE WIDTH="100%" valign="CENTER"><TR><TD align="CENTER" valign="baseline">
						
						<div align="center">
						<FONT face="arial, helvetica, sans-serif" SIZE="2"><b><xsl:value-of select="$m_currentconv"/></b></FONT>
						</div>
<xsl:call-template name="messagenavbuttons">
<xsl:with-param name="skipto"><xsl:value-of select="FORUMTHREADHEADERS/@SKIPTO"/></xsl:with-param>
<xsl:with-param name="count"><xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/></xsl:with-param>
<xsl:with-param name="forumid"><xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/></xsl:with-param>
<xsl:with-param name="threadid"><xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/></xsl:with-param>
<xsl:with-param name="more"><xsl:value-of select="FORUMTHREADHEADERS/@MORE"/></xsl:with-param>
</xsl:call-template>
						</TD></TR></TABLE>
						<CENTER>
						<xsl:call-template name="forumpostblocks">
							<xsl:with-param name="thread" select="FORUMTHREADHEADERS/@THREADID"/>
							<xsl:with-param name="forum" select="FORUMTHREADHEADERS/@FORUMID"/>
							<xsl:with-param name="skip" select="0"/>
							<xsl:with-param name="show" select="FORUMTHREADHEADERS/@COUNT"/>
							<xsl:with-param name="total" select="FORUMTHREADHEADERS/@TOTALPOSTCOUNT"/>
							<xsl:with-param name="this" select="FORUMTHREADHEADERS/@SKIPTO"/>
						</xsl:call-template>
						</CENTER>
<DIV class="browse">
<table cellspacing="0" cellpadding="0" border="0">
<xsl:apply-templates mode="many" select="FORUMTHREADHEADERS" />
</table>
</DIV>
<!--
<xsl:if test="FORUMTHREADHEADERS[@SKIPTO > 0]">
<A>
<xsl:attribute name="HREF">/FLR<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADHEADERS/@SKIPTO) - number(FORUMTHREADHEADERS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">twosides</xsl:attribute>
Click to see older posts
</A><br />
</xsl:if>

<xsl:if test="FORUMTHREADHEADERS/@MORE">
<A>
<xsl:attribute name="HREF">/FLR<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADHEADERS/@SKIPTO) + number(FORUMTHREADHEADERS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">twosides</xsl:attribute>
Click to see newer posts
</A><br />
</xsl:if>
-->
<xsl:choose>
<xsl:when test="FORUMTHREADS/@JOURNALOWNER">
<xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
<CENTER>
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
<img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}" /></A>
</CENTER>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<CENTER>
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
<img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}" /></A>
</CENTER>
</xsl:otherwise>
</xsl:choose>
<br/>
<CENTER>
<xsl:call-template name="subscribethread"/>
</CENTER>
<hr />
<div align="center">
<FONT face="arial, helvetica, sans-serif" SIZE="2"><b><xsl:value-of select="$m_otherconv"/></b></FONT>
</div>
<xsl:apply-templates select="FORUMTHREADS" />
<br />
<xsl:choose>
<xsl:when test="FORUMTHREADS/@JOURNALOWNER">
<xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
<CENTER>
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
<img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}" /></A>
</CENTER>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<CENTER>
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
<img src="{$imagesource}f_newconversation.gif" border="0" alt="{$alt_newconversation}" /></A>
</CENTER>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
<CENTER>
<xsl:call-template name="subscribeforum"/>
</CENTER>
</FONT>
</body>
</html>
</xsl:template>

<xsl:template name="messagenavbuttons">
<xsl:param name="skipto">0</xsl:param>
<xsl:param name="count">0</xsl:param>
<xsl:param name="forumid">0</xsl:param>
<xsl:param name="threadid">0</xsl:param>
<xsl:param name="more">0</xsl:param>
<xsl:variable name="prevrange">
		<xsl:apply-templates select="FORUMTHREADHEADERS/@SKIPTO | FORUMTHREADPOSTS/@SKIPTO" mode="showprevrange"/>
	</xsl:variable>
	<xsl:variable name="nextrange">
		<xsl:apply-templates select="FORUMTHREADHEADERS/@SKIPTO | FORUMTHREADPOSTS/@SKIPTO" mode="shownextrange"/>
	</xsl:variable>
	<img src="{$imagesource}blank.gif" width="140" height="1"/>
	<br/>
	<xsl:apply-templates select="FORUMTHREADHEADERS/@SKIPTO | FORUMTHREADPOSTS/@SKIPTO" mode="navbuttons">
		<xsl:with-param name="URL" select="'F'"/>
		<xsl:with-param name="skiptobeginning">
			<img src="{$imagesource2}buttons/rewind.gif" width="34" height="32" border="0" alt="{$alt_showoldest}" name="ArrowBegin1"/>
		</xsl:with-param>
		<xsl:with-param name="skiptoprevious">
				<img src="{$imagesource2}buttons/reverse.gif" width="34" height="32" border="0" name="ArrowLeft1" alt="{$prevrange}"/>			
		</xsl:with-param>
		<xsl:with-param name="skiptobeginningfaded">
				<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_atstartofconv}"/>
		</xsl:with-param>
		<xsl:with-param name="skiptopreviousfaded">
			<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_noolderpost}"/>
		</xsl:with-param>
		<xsl:with-param name="skiptonext">
			<img src="{$imagesource2}buttons/play.gif" width="34" height="32" border="0" name="ArrowRight1" alt="{$nextrange}"/>			
		</xsl:with-param>
		<xsl:with-param name="skiptoend">
			<img src="{$imagesource2}buttons/fforward.gif" width="34" height="32" border="0" alt="{$alt_showlatestpost}" name="ArrowEnd1"/>
		</xsl:with-param>
		<xsl:with-param name="skiptonextfaded">
			<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_nonewerpost}"/>	
		</xsl:with-param>
		<xsl:with-param name="skiptoendfaded">
			<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_alreadyendconv}"/>
		</xsl:with-param>
		<xsl:with-param name="attributes">
			<attribute name="target" value="_top"/>
		</xsl:with-param>
	</xsl:apply-templates>
	<br />
</xsl:template>

<xsl:template match='H2G2[@TYPE="ONLINE"]'>
<xsl:apply-templates select="ONLINEUSERS"/>
</xsl:template>


<xsl:template match='H2G2[@TYPE="MESSAGEFRAME"]'>
<html>
	<head>
		<META NAME="robots" CONTENT="{$robotsetting}"/>
		<TITLE>h2g2</TITLE>
		<script language="JavaScript">
		<xsl:comment> hide this script from non-javascript-enabled browsers
		function popupwindow(link, target, parameters) 
		{
			popupWin = window.open(link,target,parameters);
		}

		// stop hiding </xsl:comment>
		</script>
	</head>
<body bgcolor="{$bgcolour}" text="{$mainfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="3" link="#FFFF66" vlink="#FF9900" alink="#FFFF99">
<font face="arial, helvetica, sans-serif" SIZE="3">

<!--<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]|FORUMTHREADPOSTS/@MORE">
<CENTER>
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip=0&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/rewind.gif" border="0" alt="Skip to start of conversation"/>
</A>
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/reverse.gif" border="0" alt="back to older posts"/>
</A>
</xsl:if>

<xsl:if test="FORUMTHREADPOSTS/@MORE">
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/play.gif" border="0" alt="forward to newer posts"/>
</A>
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;latest=1" TARGET="twosides">
<IMG src="{$imagesource2}buttons/fforward.gif" border="0" alt="skip to newest posts"/>
</A>
</xsl:if>
</CENTER>
</xsl:if>
-->

<xsl:apply-templates select="FORUMTHREADPOSTS" >
<xsl:with-param name="ptype" select="'frame'" />
</xsl:apply-templates>
<hr/>
<!--
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]|FORUMTHREADPOSTS/@MORE">
<CENTER>
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip=0&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/rewind.gif" border="0" alt="Skip to start of conversation"/>
</A>
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/reverse.gif" border="0" alt="back to older posts"/>
</A>
</xsl:if>

<xsl:if test="FORUMTHREADPOSTS/@MORE">
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" TARGET="twosides">
<IMG src="{$imagesource2}buttons/play.gif" border="0" alt="forward to newer posts"/>
</A>
<A HREF="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;latest=1" TARGET="twosides">
<IMG src="{$imagesource2}buttons/fforward.gif" border="0" alt="skip to newest posts"/>
</A>
</xsl:if>
</CENTER>
</xsl:if>
-->

<br />
<br />
<br />
<xsl:call-template name="m_forumpostingsdisclaimer"/>
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
</font>
</body></html>
</xsl:template>

<!--
	template: <H2G2 TYPE="FORUMFRAME">
	This template calls the FORUMFRAME template to create the frameset
-->

<xsl:template match='H2G2[@TYPE="FORUMFRAME"]'>
<html><HEAD>
<META NAME="robots" CONTENT="{$robotsetting}"/>
<TITLE><xsl:value-of select="$m_forumtitle"/></TITLE>
</HEAD>
<xsl:apply-templates select="FORUMFRAME" />
</html>
</xsl:template>

<!--
	template: <FORUMFRAME>
	Creates the frameset from the FORUMFRAME information.
	A frameset works by defining the sizes and relative positions of each frame
	on the page. Each frameset is divided either horizontally or vertically, 
	depending on whether it has a ROWS or COLS attribute. This means that
	you often need framesets within framesets - a frameset can contain either
	FRAME elements or more FRAMESET elements.

	Ripley provides the following URLs which can be used to deliver frame-based
	forums (each of which take id, thread, skip, show and post params):
		FFU - The top frame of the page, used simply to display UI
		FFL - The 'left' hand buttons frame. Another stylesheet might not
				need this frame. Does a similar thing to FFU.
		FFS - source of the forum - displays the 'This forum is associated with'
				header
		FFT - the list of headers and threads
		FFM - the actual messages
-->

<xsl:template match="FORUMFRAME">
<FRAMESET ROWS="135,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="0">
	<FRAME><xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFU<xsl:value-of select="@FORUM" />?thread=<xsl:value-of select="@THREAD" />&amp;post=<xsl:value-of select="@POST" />&amp;skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="NAME">toprow</xsl:attribute>
	<xsl:attribute name="MARGINHEIGHT">0</xsl:attribute>
	<xsl:attribute name="MARGINWIDTH">0</xsl:attribute>
	<xsl:attribute name="LEFTMARGIN">0</xsl:attribute>
	<xsl:attribute name="TOPMARGIN">0</xsl:attribute>
	<xsl:attribute name="SCROLLING">no</xsl:attribute>
	</FRAME>
	<FRAMESET COLS="94,*">
		<FRAME><xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFL<xsl:value-of select="@FORUM" />?thread=<xsl:value-of select="@THREAD" />&amp;post=<xsl:value-of select="@POST" />&amp;skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="FRAMEBORDER">NO</xsl:attribute>
	<xsl:attribute name="SCROLLING">NO</xsl:attribute>
	</FRAME>
		<FRAMESET ROWS="25,100%">
			<FRAME><xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFS<xsl:value-of select="@FORUM" />?thread=<xsl:value-of select="@THREAD" />&amp;post=<xsl:value-of select="@POST" />&amp;skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="SCROLLING">no</xsl:attribute>
	</FRAME>
	<FRAME><xsl:attribute name="SRC"><xsl:value-of select="$root"/>FLR<xsl:value-of select="@FORUM" />?thread=<xsl:value-of select="@THREAD" />&amp;<xsl:if test="@POST &gt; 0">post=<xsl:value-of select="@POST" />&amp;</xsl:if>skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="NAME">twosides</xsl:attribute>
	<xsl:attribute name="ID">twosides</xsl:attribute>
	</FRAME>
<!--			<FRAMESET COLS="35%,65%">
				<FRAME><xsl:attribute name="SRC">/FFT<xsl:value-of select="@FORUM" />&amp;thread=<xsl:value-of select="@THREAD" />&amp;<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="NAME">threads</xsl:attribute>
	<xsl:attribute name="ID">threads</xsl:attribute>
	</FRAME>
				<FRAME><xsl:attribute name="SRC">/FFM<xsl:value-of select="@FORUM" />&amp;thread=<xsl:value-of select="@THREAD" />&amp;<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" />#p<xsl:value-of select="@POST" /></xsl:attribute>
	<xsl:attribute name="NAME">messages</xsl:attribute>
	<xsl:attribute name="ID">frmmess</xsl:attribute>
	</FRAME>
			</FRAMESET>
-->		</FRAMESET>
	</FRAMESET>
</FRAMESET>
</xsl:template>

<xsl:template match="FORUMFRAME[@SUBSET='TWOSIDES']">
			<FRAMESET COLS="35%,65%">
				<FRAME><xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFT<xsl:value-of select="@FORUM" />?thread=<xsl:value-of select="@THREAD" />&amp;<xsl:if test="@POST &gt; 0">post=<xsl:value-of select="@POST" />&amp;</xsl:if>skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" /></xsl:attribute>
	<xsl:attribute name="NAME">threads</xsl:attribute>
	<xsl:attribute name="ID">threads</xsl:attribute>
	</FRAME>
				<FRAME><xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFM<xsl:value-of select="@FORUM" />?thread=<xsl:value-of select="@THREAD" />&amp;<!--<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>-->skip=<xsl:value-of select="@SKIP" />&amp;show=<xsl:value-of select="@SHOW" />#p<xsl:value-of select="@POST" /></xsl:attribute>
	<xsl:attribute name="NAME">messages</xsl:attribute>
	<xsl:attribute name="ID">frmmess</xsl:attribute>
	</FRAME>
			</FRAMESET>
</xsl:template>


<xsl:template match='H2G2[@TYPE="SIDEFRAME"]'>
<html>
<xsl:apply-templates mode="header" select=".">
<xsl:with-param name="title">h2g2 buttons</xsl:with-param>
</xsl:apply-templates>
<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">

<xsl:apply-templates mode="map" select="." />
<table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
  <tr> 
<xsl:apply-templates mode="buttons" select="." />
</tr>
</table>
<P>&nbsp;</P>
</body>
</html>
</xsl:template>

<!--
	template: <H2G2> mode=header
	param: title

	We're using modes to encapsulate commonly used bits of the UI. This
	template outputs the <HEAD> section which contains a bunch of javascript
	and stuff. This is used in several places, so it's put here to avoid
	duplication.
-->

<xsl:template mode="header" match="H2G2">
<xsl:param name="title">h2g2</xsl:param>
<head>
<meta name="robots" content="{$robotsetting}" />
<title><xsl:value-of select="$title"/></title>
<script language="JavaScript">
<xsl:comment> hide this script from non-javascript-enabled browsers
if (document.images) {
Igui_01_01 = new Image(85, 93);Igui_01_01.src = '<xsl:value-of select="$imagesource"/>top_logo.jpg';
Igui_01_01o = new Image(85, 93);Igui_01_01o.src = '<xsl:value-of select="$imagesource"/>top_logo_over.jpg';
Igui_01_01h = new Image(85, 93);Igui_01_01h.src = '<xsl:value-of select="$imagesource"/>top_logo_onClick.jpg';
<!--Igui_02_03 = new Image(130, 58);Igui_02_03.src = '<xsl:value-of select="$imagesource"/>top_panic.jpg';-->
<!--Igui_02_03o = new Image(130, 58);Igui_02_03o.src = '<xsl:value-of select="$imagesource"/>top_panic_over.jpg';-->
<!--Igui_02_03h = new Image(130, 58);Igui_02_03h.src = '<xsl:value-of select="$imagesource"/>top_panic_onClick.jpg';-->
<!--Igui_02_04 = new Image(158, 52);Igui_02_04.src = '<xsl:value-of select="$imagesource"/>top_search.jpg';-->
<!--Igui_02_04o = new Image(158, 52);Igui_02_04o.src = '<xsl:value-of select="$imagesource"/>top_search_over.jpg';-->
<!--Igui_02_04h = new Image(158, 52);Igui_02_04h.src = '<xsl:value-of select="$imagesource"/>top_search_onClick.jpg';-->
<!--Igui_06_01 = new Image(85, 37);Igui_06_01.src = '<xsl:value-of select="$imagesource2"/>side_space.jpg';
Igui_06_01o = new Image(85, 37);Igui_06_01o.src = '<xsl:value-of select="$imagesource2"/>side_space_over.jpg';
Igui_06_01h = new Image(85, 37);Igui_06_01h.src = '<xsl:value-of select="$imagesource2"/>side_space_down.jpg';
Igui_06r_01 = new Image(85, 37);Igui_06r_01.src = '<xsl:value-of select="$imagesource"/>side_register.jpg';
Igui_06r_01o = new Image(85, 37);Igui_06r_01o.src = '<xsl:value-of select="$imagesource"/>side_register_over.jpg';
Igui_06r_01h = new Image(85, 37);Igui_06r_01h.src = '<xsl:value-of select="$imagesource"/>side_register_onClick.jpg';
Igui_08_01 = new Image(85, 43);Igui_08_01.src = '<xsl:value-of select="$imagesource"/>side_discuss.jpg';
Igui_08_01o = new Image(85, 43);Igui_08_01o.src = '<xsl:value-of select="$imagesource"/>side_discuss_over.jpg';
Igui_08_01h = new Image(85, 43);Igui_08_01h.src = '<xsl:value-of select="$imagesource"/>side_discuss_onClick.jpg';
Igui_09_01 = new Image(85, 35);Igui_09_01.src = '<xsl:value-of select="$imagesource"/>side_clip.jpg';
Igui_09_01o = new Image(85, 35);Igui_09_01o.src = '<xsl:value-of select="$imagesource"/>side_clip_over.jpg';
Igui_09_01h = new Image(85, 35);Igui_09_01h.src = '<xsl:value-of select="$imagesource"/>side_clip_onClick.jpg';
Igui_10_01 = new Image(85, 46);Igui_10_01.src = '<xsl:value-of select="$imagesource"/>side_submit.jpg';
Igui_10_01o = new Image(85, 46);Igui_10_01o.src = '<xsl:value-of select="$imagesource"/>side_submit_over.jpg';
Igui_10_01h = new Image(85, 46);Igui_10_01h.src = '<xsl:value-of select="$imagesource"/>side_submit_onClick.jpg';
Igui3_07_01 = new Image(85, 52);Igui3_07_01.src = '<xsl:value-of select="$imagesource"/>side_front.jpg';
Igui3_07_01o = new Image(85, 52);Igui3_07_01o.src = '<xsl:value-of select="$imagesource"/>side_front_over.jpg';
Igui3_07_01h = new Image(85, 52);Igui3_07_01h.src = '<xsl:value-of select="$imagesource"/>side_front_onClick.jpg';
Igui3more_04_01 = new Image(85, 35);Igui3more_04_01.src = '<xsl:value-of select="$imagesource"/>side_edit.jpg';
Igui3more_04_01o = new Image(85, 35);Igui3more_04_01o.src = '<xsl:value-of select="$imagesource"/>side_edit_over.jpg';
Igui3more_04_01h = new Image(85, 35);Igui3more_04_01h.src = '<xsl:value-of select="$imagesource"/>side_edit_onClick.jpg';
Igui3more_05_01 = new Image(85, 46);Igui3more_05_01.src = '<xsl:value-of select="$imagesource2"/>side_prefs.jpg';
Igui3more_05_01o = new Image(85, 46);Igui3more_05_01o.src = '<xsl:value-of select="$imagesource2"/>side_prefs_over.jpg';
Igui3more_05_01h = new Image(85, 46);Igui3more_05_01h.src = '<xsl:value-of select="$imagesource2"/>side_prefs_down.jpg';
Igui3more_06_01 = new Image(85, 46);Igui3more_06_01.src = '<xsl:value-of select="$imagesource"/>side_logout.jpg';
Igui3more_06_01o = new Image(85, 46);Igui3more_06_01o.src = '<xsl:value-of select="$imagesource"/>side_logout_over.jpg';
Igui3more_06_01h = new Image(85, 46);Igui3more_06_01h.src = '<xsl:value-of select="$imagesource"/>side_logout_onClick.jpg';-->
<!--Isearch_ro = new Image; Isearch_ro.src = '<xsl:value-of select="$imagesource"/>newbuttons/search_ro.gif';-->
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">myspace</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">read</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">talk</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">contribute</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">whosonline</xsl:with-param></xsl:call-template>
<!--<xsl:call-template name="createpreload"><xsl:with-param name="imgname">aboutus</xsl:with-param></xsl:call-template>-->
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">feedback</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">logout</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">preferences</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">register</xsl:with-param></xsl:call-template>
<!--<xsl:call-template name="createpreload"><xsl:with-param name="imgname">shop</xsl:with-param></xsl:call-template>-->
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">help</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">login</xsl:with-param></xsl:call-template>
<xsl:call-template name="createpreload"><xsl:with-param name="imgname">frontpage</xsl:with-param></xsl:call-template>
}
function di(id,name){
  if (document.images) {document.images[id].src=eval(name+".src"); }
}

// function that displays status bar message

function dm(msgStr) {
  document.returnValue = false;
  if (document.images) { 
     window.status = msgStr;
     document.returnValue = true;
  }
}
var showMsg = navigator.userAgent != "Mozilla/4.0 (compatible; MSIE 4.0; Mac_PowerPC)";
function dmim(msgStr) {
  document.returnValue = false;
  if (showMsg) { 
    window.status = msgStr;
    document.returnValue = true;
  }
}

function popusers(link) {
popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
popupWin.focus();
}

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

function popmailwin(x, y) {popupWin = window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');popupWin.focus();}

// stop hiding </xsl:comment>
</script>
<script type="text/javascript" language="JavaScript">
	<xsl:comment>//
		function confirm_logout() {
			if (confirm('<xsl:value-of select="$m_confirmlogout"/>')) {
				window.location = '<xsl:value-of select="$root"/>Logout';
			}
		}

	//</xsl:comment>
</script>
<xsl:call-template name="toolbarcss"/>
<style type="text/css">
<xsl:comment>
BODY body { font-family: arial, helvetica, sans-serif }
DIV.browse A { color: <xsl:value-of select="$mainfontcolour"/>}
DIV.ModerationTools A { color: blue}
DIV.ModerationTools A.active { color: red}
DIV.ModerationTools A.visited { color: darkblue}
DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
</xsl:comment></style>

</head>
</xsl:template>

<!--
	template: <H2G2> mode = map

	This template outputs the <MAP> elements for the UI. This might be specific
	to the goo UI - I don't know if other UIs need the map stuff.
-->

<xsl:template mode="map" match="H2G2">
<map name="top_panic">
  <area>
  <xsl:attribute name="shape">rect</xsl:attribute>
  <xsl:attribute name="coords">52,6,108,36</xsl:attribute>
  <xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_dontpanic" /></xsl:attribute>
  <xsl:attribute name="onMouseOver">di('Nhelp','Ihelp_ro');dmim('DON\'T PANIC!'); return document.returnValue;</xsl:attribute>
  <xsl:attribute name="onMouseOut">di('Nhelp','Ihelp'); dmim(''); return document.returnValue;</xsl:attribute>
  <xsl:attribute name="onClick">di('Nhelp','Ihelp_down');return true;</xsl:attribute>
  <xsl:attribute name="target">_top</xsl:attribute></area>
</map>
</xsl:template>

<!--
	template: <H2G2> mode = buttons

	This template outputs the buttons according to the state of the PAGEUI
	object. It *must* be contained with a <TR> tag in this UI.
-->

<xsl:template mode="buttons" match="H2G2">
    <td align="left" valign="top" rowspan="3"> 
	<!-- sub renderMainButtons --> 
<!--<img src="{$imagesource}side_front_blank.jpg" width="85" height="52" border="0"></img><br />-->
<xsl:call-template name="buttonchoice">
<xsl:with-param name="test"><xsl:if test="PAGEUI/MYHOME[@VISIBLE = 1]">1</xsl:if></xsl:with-param>
<xsl:with-param name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_myhome"/></xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'myspace'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_myspace"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_myspacetitle"/></xsl:with-param>
<xsl:with-param name="href1"><xsl:value-of select="$root"/></xsl:with-param>
<xsl:with-param name="imgname1"><xsl:value-of select="'frontpage'"/></xsl:with-param>
<xsl:with-param name="message1">Front Page</xsl:with-param>
<xsl:with-param name="title1">frontpage</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$root"/>Read</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'read'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_read"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_readtitle"/></xsl:with-param>
</xsl:call-template>

<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$root"/>Talk</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'talk'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_talk"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_talktitle"/></xsl:with-param>
</xsl:call-template>

<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$root"/>Contribute</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'contribute'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_contribute"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_contributetitle"/></xsl:with-param>
</xsl:call-template>

<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$root"/>Feedback</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'feedback'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_feedbackforum"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_feedbacktitle"/></xsl:with-param>
</xsl:call-template>

<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$root"/>Online</xsl:with-param>
<xsl:with-param name="onclickextra">popusers('<xsl:value-of select="$root"/>Online');</xsl:with-param>
<xsl:with-param name="onclickreturn">false</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'whosonline'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_whosonline"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_onlinetitle"/></xsl:with-param>
<xsl:with-param name="target">popusers</xsl:with-param>
</xsl:call-template>

<!--<xsl:call-template name="button">
<xsl:with-param name="href">Shop</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'shop'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_shop"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_shoptitle"/></xsl:with-param>
</xsl:call-template>

<xsl:call-template name="button">
<xsl:with-param name="href">AboutUs</xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'aboutus'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_aboutus"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_aboutustitle"/></xsl:with-param>
</xsl:call-template>
-->

<!--<xsl:call-template name="button">
<xsl:with-param name="test"><xsl:if test="PAGEUI/DISCUSS[@VISIBLE = 1]">1</xsl:if></xsl:with-param>
<xsl:with-param name="href"><xsl:value-of select="PAGEUI/DISCUSS/@LINKHINT"/></xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'discuss'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_discussthis"/></xsl:with-param>
</xsl:call-template>
-->
<!--
<img name="Ngui_09_01" src="{$imagesource}side_clip.jpg" width="85" height="35" alt="clip" border="0" usemap="#side_clip" ismap="1"></img><br />
<img src="{$imagesource}side_clip_blank.jpg" width="85" height="35" border="0"></img><br />
<img name="Ngui_10_01" src="{$imagesource}side_submit.jpg" width="85" height="46" alt="submit" border="0" usemap="#side_submit" ismap="1"></img><br />
<img src="{$imagesource}side_submit_blank.jpg" width="85" height="46" border="0"></img><br />
-->
<!--<xsl:if test="PAGEUI/EDITPAGE[@VISIBLE = 1]|PAGEUI/MYDETAILS[@VISIBLE = 1]">
<xsl:choose>
<xsl:when test='PAGEUI/EDITPAGE[@VISIBLE = "1"]'>
<a>
<xsl:attribute name="href"><xsl:value-of select="PAGEUI/EDITPAGE/@LINKHINT" /></xsl:attribute>
<xsl:attribute name="target">_top</xsl:attribute>
<xsl:attribute name="onmouseout">di('Ngui3more_04_01','Igui3more_04_01');dm(''); return true;</xsl:attribute>
<xsl:attribute name="onmouseover">di('Ngui3more_04_01','Igui3more_04_01o');dm('<xsl:value-of select="$alt_editthispage"/>'); return true;</xsl:attribute>
<xsl:attribute name="onclick">di('Ngui3more_04_01','Igui3more_04_01h');return true;</xsl:attribute><img name="Ngui3more_04_01" src="{$imagesource}side_edit.jpg" width="85" height="35" alt="{$alt_editthispage}" border="0"></img></a><br />
</xsl:when>
<xsl:otherwise>
<img src="{$imagesource}side_clip_blank.jpg" width="85" height="35" border="0"></img><br />
</xsl:otherwise>
</xsl:choose>
-->
<xsl:call-template name="button">
<xsl:with-param name="test"><xsl:if test="PAGEUI/MYDETAILS[@VISIBLE = 1]">1</xsl:if></xsl:with-param>
<xsl:with-param name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_mydetails"/></xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'preferences'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_preferences"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$alt_preferencestitle"/></xsl:with-param>
</xsl:call-template>
<!--<xsl:choose>
<xsl:when test='PAGEUI/MYDETAILS[@VISIBLE = "1"]'>
<A target="_top"  onmouseout="di('Ngui3more_05_01','Igui3more_05_01');dmim(''); return document.returnValue;" onmouseover="di('Ngui3more_05_01','Igui3more_05_01o');dmim('edit your personal details'); return document.returnValue;" onclick="di('Ngui3more_05_01','Igui3more_05_01h');return true;" >
<xsl:attribute name="HREF"><xsl:value-of select="PAGEUI/MYDETAILS/@LINKHINT"/></xsl:attribute>
<img name="Ngui3more_05_01" src="{$imagesource2}side_prefs.jpg" width="85" height="46" alt="{$alt_preferences}" border="0"></img>
</A>
<br />
</xsl:when>
<xsl:otherwise>
<img src="{$imagesource}side_submit_blank.jpg" width="85" height="46" border="0"></img><br />
</xsl:otherwise>
</xsl:choose>
</xsl:if>
-->
<!--xsl:call-template name="buttonchoice">
<xsl:with-param name="test"><xsl:if test="PAGEUI/LOGOUT[@VISIBLE = 1]">1</xsl:if></xsl:with-param>
<xsl:with-param name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_logout"/></xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="'logout'"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$alt_logout"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$m_logouttitle"/></xsl:with-param>
<xsl:with-param name="onclickextra">confirm_logout();</xsl:with-param>
<xsl:with-param name="onclickreturn">false</xsl:with-param>
<xsl:with-param name="href1"><xsl:value-of select="$root"/>login</xsl:with-param>
<xsl:with-param name="imgname1">login</xsl:with-param>
<xsl:with-param name="message1"><xsl:value-of select="$alt_login"/></xsl:with-param>
<xsl:with-param name="title1">Login</xsl:with-param>

</xsl:call-template-->
<img src="{$imagesource2}newbuttons/blank/logout.jpg" alt="" width="85" height="28" border="0"/>
<br/>

<!--xsl:template name="button">
<xsl:param name="href"/>
<xsl:param name="onclickextra"/>
<xsl:param name="onclickreturn">true</xsl:param>
<xsl:param name="imgname"/>
<xsl:param name="message"/>
<xsl:param name="title"/>
<xsl:param name="test">1</xsl:param>
<xsl:param name="target">_top</xsl:param>
<xsl:choose>
<xsl:when test="number($test) = 1">

<a 
href="{$href}" 
target="{$target}" 
onMouseOver="di('N{$imgname}','I{$imgname}_ro');dm('{$message}');return true;"
onMouseOut="di('N{$imgname}','I{$imgname}');dm('');return true;"
onClick="di('N{$imgname}','I{$imgname}_down');{$onclickextra}return {$onclickreturn};"><img name="N{$imgname}" src="{$imagesource2}newbuttons/{$imgname}.jpg" border="0" alt="{$message}" title="{$title}"></img></a><br />
</xsl:when>
<xsl:otherwise>
<img border="0" src="{$imagesource2}newbuttons/blank/{$imgname}.jpg"/><br/>
</xsl:otherwise>
</xsl:choose>
</xsl:template-->

<!--
<xsl:if test='PAGEUI/LOGOUT[@VISIBLE = "1"]'>
<img src="{$imagesource}side_clip_blank.jpg" width="85" height="35" border="0"></img><br />
<xsl:element name="A"><xsl:attribute name="HREF"><xsl:value-of select="PAGEUI/LOGOUT/@LINKHINT" /></xsl:attribute>
<xsl:attribute name="target">_top</xsl:attribute>
<xsl:attribute name="onMouseOver">di('Ngui3more_06_01','Igui3more_06_01o');dm('<xsl:value-of select="$alt_logout"/>');return true;</xsl:attribute>
<xsl:attribute name="onMouseOut">di('Ngui3more_06_01','Igui3more_06_01');dm('');return true;</xsl:attribute>
<xsl:attribute name="onClick">di('Ngui3more_06_01','Igui3more_06_01h');return true;</xsl:attribute><img name="Ngui3more_06_01" src="{$imagesource}side_logout.jpg" border="0" width="85" height="48" alt="{$alt_logout}"></img></xsl:element><br />
</xsl:if>
-->
<img src="{$imagesource}newbuttons/bottom.jpg" border="0"/><br/>
<!--<img name="Ngui_12_01" src="{$imagesource}side_bottom.jpg" width="66" height="41" border="0"></img> 
      <br />
-->
    </td>
</xsl:template>

<xsl:template mode="buttonsk" match="H2G2">
    <td align="left" valign="top" rowspan="3"> 
	<!-- sub renderMainButtons --> 
<img src="{$imagesource}newbuttons/myspace.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/read.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/talk.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/contribute.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/feedback.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/whosonline.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/shop.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/aboutus.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/preferences.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/logout.gif" border="0" /><br/>
<img src="{$imagesource}newbuttons/bottom.gif" border="0" /><br/>
    </td>
</xsl:template>




<!--
	template: <H2G2> mode = topgoo
	Displays the goo for the top of the page
	TODO: Make it use the PAGEUI stuff
-->

<xsl:template mode="topgoo" match="H2G2">
<table border="0" vspace="0" hspace="0" cellspacing="0" cellpadding="0">
<tr valign="top"> 
<td rowspan="3" width="85"><a href="{$root}" target="_top">
<img name="Ngui_01_01" src="{$imagesource}top_logo.jpg" width="85" height="93" border="0" alt="{$alt_frontpage}"></img></a><img src="{$imagesource}top_underlogo.jpg" width="85" height="42"></img></td>
<td width="522" height="77" colspan="2" valign="top"><img src="{$imagesource}banner_top.jpg" width="522" height="5" border="0" vspace="0" hspace="0"></img><br />
<img src="{$imagesource}banner_left.jpg" width="54" height="60" vspace="0" hspace="0" border="0"></img><xsl:apply-templates select="PAGEUI/BANNER[@NAME='main']"/><br />
<img src="{$imagesource}banner_bottom.jpg" width="522" height="12" vspace="0" hspace="0" border="0"></img></td><td rowspan="2" align="left" valign="top"><img src="{$imagesource}newbuttons/top_copy_blank.jpg" width="52" height="93" border="0"></img></td>
<td rowspan="2" align="left" background="{$imagesource}top_right.jpg" width="1000">&#160;</td>
</tr>
<tr> 
<td valign="top" rowspan="2"><img name="Nhelp" src="{$imagesource}newbuttons/help.jpg" border="0" usemap="#top_panic" ismap="1" align="left" vspace="0" hspace="0" alt="{$alt_help}" title="{$alt_dontpanic}"></img> 
</td>
<td valign="top" align="left"><img name="Ngui_02_05" src="{$imagesource}newbuttons/top_fill.jpg" width="392" height="16" border="0" vspace="0" hspace="0"></img></td>
</tr>
<tr> 
<form method="GET" action="{$root}Search" target="_top">
<td align="left" valign="top" height="42" colspan="3"><table><tr><td><input type="text" name="searchstring" value=""></input>&nbsp;<input type="submit" name="dosearch" id="dosearch" align="top" alt="{$alt_searchtheguide}" value="Search"></input><input type="hidden" name="searchtype" value="goosearch"></input>
&nbsp;</td><td><font xsl:use-attribute-sets="mainfont" size="1">
												<xsl:call-template name="m_lifelink"/>
												| <xsl:call-template name="m_universelink"/>
												| <xsl:call-template name="m_everythinglink"/> 
												| <xsl:call-template name="m_searchlink"/>
</font></td></tr></table>
</td>
</form>
</tr>
</table>
</xsl:template>

<xsl:template match='H2G2[@TYPE="TOPFRAME"]'>
<html>
<xsl:apply-templates mode="header" select="." />
<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
<!--<META http-equiv="REFRESH" content="90"/>-->
<xsl:apply-templates mode="map" select="." />
<xsl:apply-templates mode="topgoo" select="." />
<P>&nbsp;</P>
</body>
</html>
</xsl:template>


<xsl:template mode="frontpage" match="BODY">
<!--<table><tr><td width="36"></td><td>-->
<blockquote><font xsl:use-attribute-sets="frontpagefont">
<xsl:apply-templates />
</font><!--</td><td width="36"></td></tr></table>-->
</blockquote>
</xsl:template>


<xsl:template match="HEADER">
<xsl:if test="@ANCHOR">
	<a name="{@ANCHOR}"/>
</xsl:if>

<br clear="all"/>
     <table border="0" width="100%" cellspacing="0" cellpadding="0">
         <tr> 
          <td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/greencircle_L.gif" width="13" height="24"/></td>
          <td bgcolor="{$headertopedgecolour}" width="80%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$headertopedgecolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td bgcolor="{$verticalbarcolour}"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$verticalbarcolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td nowrap="nowrap" bgcolor="{$headerbgcolour}"><font face="Arial, Helvetica, sans-serif" color="{$mainfontcolour}"><b>
<NOBR><xsl:apply-templates /></NOBR>
</b></font></td>
          <td width="100%"><img src="{$imagesource}layout/wave1.gif" width="48" height="22"/></td>
        </tr>
</table>
</xsl:template>

<xsl:template name="HEADER">
<xsl:param name="text">?????</xsl:param>
<br clear="all"/>
     <table border="0" width="100%" cellspacing="0" cellpadding="0">
         <tr> 
          <td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/greencircle_L.gif" width="13" height="24"/></td>
          <td bgcolor="{$headertopedgecolour}" width="80%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$headertopedgecolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td bgcolor="{$verticalbarcolour}"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$verticalbarcolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td nowrap="nowrap" bgcolor="{$headerbgcolour}"><font face="Arial, Helvetica, sans-serif" color="{$mainfontcolour}"><b>
<NOBR><xsl:value-of select="$text"/></NOBR>
</b></font></td>
          <td width="100%"><img src="{$imagesource}layout/wave1.gif" width="48" height="22"/></td>
        </tr>
</table>
</xsl:template>

<xsl:template name="SUBJECTHEADER">
<xsl:param name="text">?????</xsl:param>
     <table border="0" width="100%" cellspacing="0" cellpadding="0">
         <tr> 
          <td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/greencircle_L.gif" width="13" height="24"/></td>
          <td bgcolor="{$headertopedgecolour}" width="80%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$headertopedgecolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td bgcolor="{$verticalbarcolour}"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$verticalbarcolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td nowrap="nowrap" bgcolor="{$headerbgcolour}"><font face="Arial, Helvetica, sans-serif" color="#ffff00" size="4"><b>
<NOBR><xsl:value-of select="$text"/></NOBR>
</b></font></td>
          <td width="100%"><img src="{$imagesource}layout/wave1.gif" width="48" height="22"/></td>
        </tr>
</table>
</xsl:template>

<xsl:template match="SUBHEADER">
<xsl:if test="@ANCHOR">
	<a name="{@ANCHOR}"/>
</xsl:if>
<p><FONT SIZE="4"><B><xsl:apply-templates /></B></FONT></p>
</xsl:template>

<!-- override text here to fit in Articleinfo box -->

<xsl:template name="m_currentlyinreviewforum">
<FONT face="Arial, Helvetica, sans-serif" size="1">
Currently in: <br/>
</FONT>
</xsl:template>

<xsl:template match="ARTICLEINFO">
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td bgcolor="#FFFFFF"><img src="{$imagesource}blank.gif" width="1" height="1"></img></td></tr>
	</table>

	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="2" color="white">
					<xsl:value-of select="$m_entrydata"/><br />
				</font>
			</td>
		</tr>
		<tr valign="top"> 
			<td align="left">

				<font face="Arial, Helvetica, sans-serif" size="1">
					<xsl:apply-templates select="H2G2ID" mode="notlinkIDBold"/>
				</font>

				<font face="Arial, Helvetica, sans-serif" size="1">
					<b>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="STATUS/@TYPE"/>
					</b>
				</font>

			</td>
		</tr>
		<tr>
			<td align="left" valign="top">
				<xsl:apply-templates select="PAGEAUTHOR"/>
			</td>
		</tr>
		<tr>
			<td align="left" valign="top">
				<font face="Arial, Helvetica, sans-serif" size="1">
					<xsl:call-template name="ArticleInfoDate"/>
				</font>
			</td>
		</tr>

		<xsl:if test="$test_IsEditor">
			<tr>
				<td align="left" valign="top">
					<font face="Arial, Helvetica, sans-serif" size="1">
						<xsl:apply-templates select="H2G2ID" mode="CategoriseLink"/>
					</font>
				</td>
			</tr>
		</xsl:if>

		<!-- Inser link to remove current user from	the list of researcers -->
		<xsl:if test="$test_MayRemoveFromResearchers">
			<tr>
				<td align="left" valign="top">
					<font size="1" face="Arial, Helvetica, sans-serif">
						<xsl:apply-templates select="H2G2ID" mode="RemoveSelf">									
							<xsl:with-param name="img">
								<img src="{$imagesource}newbuttons/remove_my_name.gif" width="140" height="31" hspace="0" vspace="0" border="0" name="RemoveSelf" alt="{$alt_RemoveSelf}"/>
							</xsl:with-param>
						</xsl:apply-templates>
					</font>
				</td>
			</tr>
		</xsl:if>
	</table>

	<table width="100%" cellspacing="0" cellpadding="3">
		<tr>
			<td align="left">
				<!-- do the submittable thing -->
				<FONT face="Arial, Helvetica, sans-serif" size="1">
					<xsl:apply-templates select="SUBMITTABLE">
						<xsl:with-param name="delimiter"/>
					</xsl:apply-templates>
				</FONT>
			</td>
		</tr>
	</table>
	<!-- put the edit page button in the side bar if specified in the page UI -->
	<xsl:if test="$test_ShowEditLink">
		<nobr>
			<xsl:apply-templates select="/H2G2/PAGEUI/EDITPAGE/@VISIBLE" mode="EditEntry">
				<xsl:with-param name="img">
					<img src="{$imagesource}newbuttons/editentry.gif" hspace="0" vspace="0" border="0" name="EditPage" alt="{$alt_editentry}" title="{$alt_editthisentry}"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</nobr>
		<br/>
	</xsl:if>

	<!-- put the recommend entry button in the side bar if specified in the page UI -->
	<xsl:if test="not($ownerisviewer=1 and /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='SCOUTS')">
	<!-- don`t apply templates if the user is a scout and owns the article  -->
		<xsl:call-template name="RecommendEntry">
			<xsl:with-param name="delimiter"/>
		</xsl:call-template>
	</xsl:if>

	<!-- put the entry subbed button in the side bar if specified in the page UI -->
	<xsl:if test="$test_ShowEntrySubbedLink">
		<font size="1">
			<nobr>
				<xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="RetToEditors">
					<xsl:with-param name="img">
						<img src="{$imagesource}newbuttons/returntoeditors.gif" width="140" height="31" hspace="0" vspace="0" border="0" name="ReturnToEditors" alt="{$alt_thisentrysubbed}"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</nobr>
		</font>
	</xsl:if>

	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont" size="1">
					<xsl:call-template name="m_textonlylink"/>
				</font>
			</td>
		</tr>
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont" size="1">
					<xsl:call-template name="m_mailtofriend"/>
				</font>
			</td>
		</tr>
	</table>

	<xsl:apply-templates select="REFERENCES" />
	<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CREDITS[../../ARTICLEINFO/STATUS/@TYPE=1]"/>
	

	<!-- put in the complaint text and link -->
	<br/>
	<xsl:call-template name="m_entrysidebarcomplaint"/>
	<table border="0" width="100%" cellpadding="3" cellspacing="0">
	<tr>
	<td>
	</td>
	</tr>
	</table>
</xsl:template>

<xsl:template match="SUBJECT">
<br clear="all"/>
     <table border="0" width="100%" cellspacing="0" cellpadding="0">
         <tr> 
          <td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/greencircle_L.gif" width="13" height="24"/></td>
          <td bgcolor="{$headertopedgecolour}" width="80%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$headertopedgecolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td bgcolor="{$verticalbarcolour}"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="{$verticalbarcolour}" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td nowrap="nowrap" bgcolor="{$headerbgcolour}"><font face="Arial, Helvetica, sans-serif" color="{$mainfontcolour}"><b>
<NOBR><xsl:value-of select="." /></NOBR>
</b></font></td>
          <td width="100%"><img src="{$imagesource}layout/wave1.gif" width="48" height="22"/></td>
        </tr>
</table>
</xsl:template>

<xsl:template match="FRONTPAGE">
	<xsl:apply-templates select="MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM">
		<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="EDITORIAL-ITEM">
	<xsl:choose>
	<xsl:when test="($fpregistered=1 and @TYPE='UNREGISTERED') or ($fpregistered=0 and @TYPE='REGISTERED')"></xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates select="SUBJECT" />
		<xsl:apply-templates mode="frontpage" select="BODY" />
		<xsl:if test="MORE">
		<p align="right">
							<font xsl:use-attribute-sets="frontpagefont">
							<b><a href="{$root}{MORE/@H2G2}">More&gt;&gt;</a></b>
							</font>
		</p>
		</xsl:if>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="FORUMTHREADS">
<xsl:param name="url" select="'F'" />
<xsl:param name="target">_top</xsl:param>
	<!-- javascript for thread moving popup -->
	<script language="javascript">
		<xsl:comment>
function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}
			function moveThreadPopup(threadID)
			{
				// build a js string to popup a window to move the given thread to the currently selected destination
				var selectObject = 'document.forms.MoveThreadForm' + threadID + '.Select' + threadID;
				var forumID = eval(selectObject + '.options[' + selectObject + '.selectedIndex].value');
				var command = 'Move';

				// don't try to perform the move if we have no sensible destination
				if (forumID == 0)
				{
					command = 'Fetch';
				}
				return eval('window.open(\'/MoveThread?cmd=' + command + '?ThreadID=' + threadID + '&amp;DestinationID=F' + forumID + '&amp;mode=POPUP\', \'MoveThread\', \'scrollbars=1,resizable=1,width=300,height=230\')');
			}
		// </xsl:comment>
	</script>
<div align="CENTER">
<xsl:call-template name="threadnavbuttons">
	<xsl:with-param name="URL" select="'FFO'"/>
</xsl:call-template>
<br/>
<xsl:call-template name="forumpostblocks">
				<xsl:with-param name="forum" select="@FORUMID"/>
				<xsl:with-param name="skip" select="0"/>
				<xsl:with-param name="show" select="@COUNT"/>
				<xsl:with-param name="total" select="@TOTALTHREADS"/>
				<xsl:with-param name="this" select="@SKIPTO"/>
				<xsl:with-param name="url" select="'FFO'"/>
				<xsl:with-param name="objectname" select="'Conversations'"/>
				<xsl:with-param name="target"></xsl:with-param>
			</xsl:call-template>
</div>

<TABLE width="100%" cellpadding="2" cellspacing="0" border="0">
<xsl:for-each select="THREAD">
<xsl:choose>
<xsl:when test='number(../../FORUMTHREADHEADERS/@THREADID) = number(THREADID)'>
  <TR valign="top"> 
    <TD bgColor="{$ftbgcoloursel}" colspan="2"><FONT size="2" face="Arial, Helvetica, sans-serif"><xsl:element name="A">
<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url" /><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;skip=0&amp;show=20</xsl:attribute>
<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
<font color="white">
<B><xsl:apply-templates mode="nosubject" select="SUBJECT"/></B>
</font>
</xsl:element>
</FONT>
</TD>
	<td bgColor="{$ftbgcoloursel}">
								<font size="1">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="@THREADID" mode="movethreadgadget"/>
								</font>
	</td>
</TR>
  <TR>
    <TD bgColor="{$ftbgcoloursel}" width="69%" colspan="3"><FONT size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_lastposting"/>
		<xsl:element name="A">
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url" /><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;latest=1</xsl:attribute>
			<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
			<xsl:apply-templates select="DATEPOSTED"/>
		</xsl:element>
</FONT></TD>
<!--
    <TD bgColor="{$ftbgcoloursel}" align="right" width="31%" NOWRAP="NOWRAP"><FONT size="1" face="Arial, Helvetica, sans-serif"> 
     <xsl:text> (</xsl:text><xsl:element name="A">
			<xsl:attribute name="HREF"><xsl:value-of select="$url" /><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;latest=1</xsl:attribute>
			<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
			<b>Show latest</b>
		</xsl:element>)</FONT></TD>
-->
  </TR>
</xsl:when>
<xsl:otherwise>
  <TR valign="top"> 
    <TD colspan="2"><FONT size="2" face="Arial, Helvetica, sans-serif"><xsl:element name="A">
<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url" /><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;skip=0&amp;show=20</xsl:attribute>
<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
<B><xsl:apply-templates mode="nosubject" select="SUBJECT"/></B>
</xsl:element>
</FONT>
</TD>
	<td>
								<font size="1">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="@THREADID" mode="movethreadgadget"/>
								</font>
	</td>
</TR>
<TR>
	<TD width="69%" colspan="3">
		<FONT size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_lastposting"/>
			<xsl:element name="A">
				<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url" /><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;latest=1</xsl:attribute>
				<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
				<xsl:apply-templates select="DATEPOSTED"/>
			</xsl:element>
		</FONT></TD>
<!--
    <TD align="right" width="31%"><FONT size="1" face="Arial, Helvetica, sans-serif"> 
     <xsl:text> (</xsl:text><xsl:element name="A">
			<xsl:attribute name="HREF"><xsl:value-of select="$url" /><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="THREADID" />&amp;latest=1</xsl:attribute>
			<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
			<b>Show latest</b>
		</xsl:element>)</FONT></TD>
-->
</TR>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</TABLE>

</xsl:template>


<xsl:template name="navbuttons">
	<xsl:param name="URL">FFO</xsl:param>
	<xsl:param name="ID"><xsl:value-of select="@FORUMID"/></xsl:param>
	<xsl:param name="ExtraParameters"/>
	<xsl:param name="showconvs" select="$alt_showitems"/>
	<xsl:param name="shownewest" select="$alt_firstpage"/>
	<xsl:param name="alreadynewestconv" select="$alt_alreadyfirstpage"/>
	<xsl:param name="nonewconvs" select="$alt_nopreviouspage"/>
	<xsl:param name="showoldestconv" select="$alt_lastpage"/>
	<xsl:param name="noolderconv" select="$alt_nonextpage"/>
	<xsl:param name="showingoldest" select="$alt_alreadylastpage"/>
	<xsl:param name="Skip" select="@SKIPTO"/>
	<xsl:param name="Show" select="@COUNT"/>
	<xsl:param name="Total" select="@TOTAL"/>
	<xsl:param name="More" select="@MORE"/>
	<xsl:choose>
		<xsl:when test="$Skip != 0">
			<a href="{$URL}{$ID}?skip=0&amp;show={$Show}{$ExtraParameters}">
				<img width="34" height="32" src="{$imagesource2}buttons/rewind.gif" border="0">
					<xsl:attribute name="alt"><xsl:value-of select="$shownewest"/></xsl:attribute>
				</img>
			</a>
			<xsl:variable name="alt"><xsl:value-of select="$showconvs"/><xsl:value-of select='number($Skip) - number($Show) + 1'/><xsl:value-of select="$alt_to"/><xsl:value-of select='number($Skip)'/></xsl:variable>
			<a href="{$URL}{$ID}?skip={number($Skip) - number($Show)}&amp;show={$Show}{$ExtraParameters}">
				<img width="34" height="32" src="{$imagesource2}buttons/reverse.gif" border="0">
					<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
				</img>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<img width="34" height="32" src="{$imagesource2}buttons/navgrey.gif" border="0" alt="{$alreadynewestconv}"/>
			<img width="34" height="32" src="{$imagesource2}buttons/navgrey.gif" border="0" alt="{$nonewconvs}"/>
		</xsl:otherwise>
	</xsl:choose>

	<xsl:choose>
		<xsl:when test="$More">
			<xsl:variable name="alt"><xsl:value-of select="$showconvs"/><xsl:value-of select='number($Skip) + number($Show) + 1'/><xsl:value-of select="$alt_to"/><xsl:value-of select='number($Skip) + number($Show) + number($Show)'/></xsl:variable>
			<a href="{$URL}{$ID}?skip={number($Skip) + number($Show)}&amp;show={$Show}{$ExtraParameters}">
				<img width="34" height="32" src="{$imagesource2}buttons/play.gif" border="0">
					<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
				</img>
			</a>
			<a href="{$URL}{$ID}?skip={floor((number($Total)-1) div number($Show)) * number($Show)}&amp;show={$Show}{$ExtraParameters}">
				<img width="34" height="32" src="{$imagesource2}buttons/fforward.gif" border="0">
					<xsl:attribute name="alt"><xsl:value-of select="$showoldestconv"/></xsl:attribute>
				</img>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<img width="34" height="32" src="{$imagesource2}buttons/navgrey.gif" border="0" alt="{$noolderconv}"/>
			<img width="34" height="32" src="{$imagesource2}buttons/navgrey.gif" border="0" alt="{$showingoldest}"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="threadnavbuttons">
	<xsl:param name="URL" select="'F'"/>
	<xsl:variable name="var_orderby">
		<xsl:choose>
			<xsl:when test="@ORDERBY=1">dateentered</xsl:when>
			<xsl:when test="@ORDERBY=2">lastposted</xsl:when>
			<xsl:when test="@ORDERBY=3">authorid</xsl:when>
			<xsl:when test="@ORDERBY=4">authorname</xsl:when>
			<xsl:when test="@ORDERBY=5">entry</xsl:when>
			<xsl:when test="@ORDERBY=6">subject</xsl:when>
			<xsl:otherwise>dateentered</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="op_dir">
		<xsl:choose>
			<xsl:when test="@DIR=1">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='REVIEWFORUM'">
			<xsl:variable name="prevrange">
				<xsl:apply-templates select="@SKIPTO" mode="showprevrange">
					<xsl:with-param name="showtext" select="$alt_rf_showconvs"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="nextrange">
				<xsl:apply-templates select="@SKIPTO" mode="shownextrange">
					<xsl:with-param name="showtext" select="$alt_rf_showconvs"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:apply-templates select="@SKIPTO" mode="navbuttons">
				<xsl:with-param name="URL" select="'RF'"/>
				<xsl:with-param name="ID" select="../@ID"/>
				<xsl:with-param name="skiptobeginning">
					<img src="{$imagesource2}buttons/rewind.gif" width="34" height="32" border="0" alt="{$alt_rf_shownewest}" name="ArrowBegin1"/>
				</xsl:with-param>
				<xsl:with-param name="skiptoprevious">
						<img src="{$imagesource2}buttons/reverse.gif" width="34" height="32" border="0" name="ArrowLeft1" alt="{$prevrange}"/>			
				</xsl:with-param>
				<xsl:with-param name="skiptobeginningfaded">
						<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_rf_alreadynewestconv}"/>
				</xsl:with-param>
				<xsl:with-param name="skiptopreviousfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_rf_nonewconvs}"/>
				</xsl:with-param>
				<xsl:with-param name="skiptonext">
					<img src="{$imagesource2}buttons/play.gif" width="34" height="32" border="0" name="ArrowRight1" alt="{$nextrange}"/>			
				</xsl:with-param>
				<xsl:with-param name="skiptoend">
					<img src="{$imagesource2}buttons/fforward.gif" width="34" height="32" border="0" alt="{$alt_rf_showoldestconv}" name="ArrowEnd1"/>
				</xsl:with-param>
				<xsl:with-param name="skiptonextfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_rf_noolderconv}"/>	
				</xsl:with-param>
				<xsl:with-param name="skiptoendfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_rf_showingoldest}"/>
				</xsl:with-param>
				<xsl:with-param name="ExtraParameters">?entry=0&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/></xsl:with-param>
			</xsl:apply-templates>

		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="prevrange">
				<xsl:apply-templates select="@SKIPTO" mode="showprevrange">
					<xsl:with-param name="showtext" select="$alt_showconvs"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="nextrange">
				<xsl:apply-templates select="@SKIPTO" mode="shownextrange">
					<xsl:with-param name="showtext" select="$alt_showconvs"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:apply-templates select="@SKIPTO" mode="navbuttons">
				<xsl:with-param name="URL" select="$URL"/>
				<xsl:with-param name="skiptobeginning">
					<img src="{$imagesource2}buttons/rewind.gif" width="34" height="32" border="0" alt="{$alt_shownewest}" name="ArrowBegin1"/>
				</xsl:with-param>
				<xsl:with-param name="skiptoprevious">
						<img src="{$imagesource2}buttons/reverse.gif" width="34" height="32" border="0" name="ArrowLeft1" alt="{$prevrange}"/>			
				</xsl:with-param>
				<xsl:with-param name="skiptobeginningfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_alreadynewestconv}"/>
				</xsl:with-param>
				<xsl:with-param name="skiptopreviousfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_nonewconvs}"/>
				</xsl:with-param>
				<xsl:with-param name="skiptonext">
					<img src="{$imagesource2}buttons/play.gif" width="34" height="32" border="0" name="ArrowRight1" alt="{$nextrange}"/>			
				</xsl:with-param>
				<xsl:with-param name="skiptoend">
					<img src="{$imagesource2}buttons/fforward.gif" width="34" height="32" border="0" alt="{$alt_showoldestconv}" name="ArrowEnd1"/>
				</xsl:with-param>
				<xsl:with-param name="skiptonextfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$m_noolderconv}"/>	
				</xsl:with-param>
				<xsl:with-param name="skiptoendfaded">
					<img src="{$imagesource2}buttons/navgrey.gif" width="34" height="32" border="0" alt="{$alt_showingoldest}"/>
				</xsl:with-param>
			</xsl:apply-templates>
		
		</xsl:otherwise>
	</xsl:choose>
<br/>
</xsl:template>


<xsl:template match="ARTICLEFORUM/FORUMTHREADS">
	<br clear="all"/>
	<table border="0">
		<tr>
			<td align="left" valign="top">
				<xsl:apply-templates select="@FORUMID" mode="AddThread">
					<xsl:with-param name="img">
						<img src="{$imagesource}newbuttons/discuss.gif" 
							alt="{$alt_discussthis}" title="{$alt_discussthistitle}" 
							border="0"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</td>
			<td>&nbsp;&nbsp;</td>
			<xsl:call-template name="PeopleTalking"/>
		</tr>
	</table>
	<blockquote> 
	<p>
		<font face="Arial, Helvetica, sans-serif" size="2">
			<xsl:choose>
				<xsl:when test="THREAD">
					<xsl:for-each select="THREAD">
						<xsl:apply-templates select="@THREADID" mode="LinkOnSubject"/>
						 (<xsl:value-of select="$m_lastposting"/>
						 <xsl:apply-templates select="@THREADID" mode="LinkOnDatePosted"/>) 
						 <br />
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>

			<xsl:if test="THREAD">
				<br/>
				<xsl:apply-templates select="@FORUMID" mode="MoreConv"/>
				<br/>
			</xsl:if>

			<xsl:call-template name="subscribearticleforum"/>
			<br/>
		</font>
	</p>
	</blockquote>
	<br />
</xsl:template>

<xsl:template match="FORUMPAGE">
<xsl:apply-templates select="FORUMSOURCE" /><br />
<xsl:choose>
<xsl:when test="FORUMTHREADS">
Here are some more Conversations, starting at number <xsl:value-of select="number(FORUMTHREADS/@SKIPTO)+1" />.<br /><br />
<xsl:apply-templates select="FORUMTHREADS">
<xsl:with-param name="url" select="'FP'" />
<xsl:with-param name="target" select="''"/>
</xsl:apply-templates>
<br />
<xsl:if test="FORUMTHREADS/@MORE">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADS/@FORUMID" />?skip=<xsl:value-of select='number(FORUMTHREADS/@SKIPTO) + number(FORUMTHREADS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>Click here for older Conversations</A>
<br />
</xsl:if>
<xsl:if test="number(FORUMTHREADS/@SKIPTO) > 0">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADS/@FORUMID" />?skip=<xsl:value-of select='number(FORUMTHREADS/@SKIPTO) - number(FORUMTHREADS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>Click here for newer Conversations</A>
</xsl:if>
</xsl:when>


<xsl:when test="FORUMTHREADPOSTS">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click here to return to the list of Conversations
</A><br />
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see older posts
</A><br />
</xsl:if>

<xsl:if test="FORUMTHREADPOSTS/@MORE">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see newer posts
</A><br />
</xsl:if>

<xsl:apply-templates select="FORUMTHREADPOSTS" >
<xsl:with-param name="ptype" select="'page'" />
</xsl:apply-templates>
<br />
<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see older posts
</A><br />
</xsl:if>

<xsl:if test="FORUMTHREADPOSTS/@MORE">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see newer posts
</A><br />
</xsl:if>
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
</xsl:when>
<xsl:when test="FORUMTHREADHEADERS">
<xsl:apply-templates select="FORUMTHREADHEADERS"/>
<br />

<xsl:if test="FORUMTHREADHEADERS[@SKIPTO > 0]">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FH<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADHEADERS/@SKIPTO) - number(FORUMTHREADHEADERS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see older posts
</A><br />
</xsl:if>

<xsl:if test="FORUMTHREADHEADERS/@MORE">
<A>
<xsl:attribute name="href"><xsl:value-of select="$root"/>FH<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID" />?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADHEADERS/@SKIPTO) + number(FORUMTHREADHEADERS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT" /></xsl:attribute>
<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see newer posts
</A><br />
</xsl:if>

</xsl:when>


<xsl:otherwise>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<!--
<xsl:template match="FORUMTHREADPOSTS" mode="makelink">
blardy blardy blardy
</xsl:template>
-->

<xsl:template mode="many" match="FORUMTHREADHEADERS/POST">
    <TR align="left"> 
      <!--<TD nowrap="1" valign="top">&nbsp;</TD>-->
      <TD colspan="2" nowrap="1" valign="top"><FONT size="1" face="Arial, Helvetica, sans-serif"> 
        <A target="messages" href="{$root}FFM{../@FORUMID}?thread={../@THREADID}&amp;skip={../@SKIPTO}&amp;show={../@COUNT}#p{@POSTID}">
<xsl:value-of select="position() + number(../@SKIPTO)"/></A></FONT></TD>
      <TD nowrap="1"><DIV class="browse"><FONT face="Arial, Helvetica, sans-serif" size="2"><xsl:element name="A">
<xsl:attribute name="href"><xsl:value-of select="$root"/>FFM<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@POSTID" /></xsl:attribute>
<xsl:attribute name="TARGET">messages</xsl:attribute>
<xsl:choose>
<xsl:when test="position()=1 and number(../@SKIPTO)=0">
<IMG SRC="{$imagesource}threadtop.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:when test="position() =last() and not(number(../@MORE)=1)">
<IMG SRC="{$imagesource}thread.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:when test="position() != 20 or number(../@MORE)=1">
<IMG SRC="{$imagesource}thread2.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:otherwise>
<IMG SRC="{$imagesource}thread.gif" width="13" height="13" border="0"/>
</xsl:otherwise>
</xsl:choose>
<IMG SRC="{$imagesource}threadicon.gif" border="0"/>
<xsl:if test="SUBJECT[@SAME!='1']">
<FONT color="{$mainfontcolour}"><B><xsl:value-of select="SUBJECT" /></B><BR/></FONT>
<xsl:choose>
<xsl:when test="position() != last() or number(../@MORE)=1">
<IMG SRC="{$imagesource}threadline.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:when test="position() = last() and position() = 1 and number(../@SKIPTO)=0">
<IMG SRC="{$imagesource}thread.gif" width="13" height="13" border="0"/>
</xsl:when>
<xsl:otherwise>
<IMG SRC="{$imagesource}threadblank.gif" width="13" height="13" border="0"/></xsl:otherwise>
</xsl:choose><xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text> 
</xsl:if>
		<FONT face="Arial, Helvetica, sans-serif" size="2">
		<xsl:if test="not(@HIDDEN &gt; 0)">
		<xsl:apply-templates select="USER/USERNAME" />
		</xsl:if>
		 (<xsl:apply-templates select="DATEPOSTED" />)</FONT></xsl:element></FONT></DIV></TD>
    </TR>


<!--
<NOBR>
<xsl:element name="A">
<xsl:attribute name="HREF">FFM<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@POSTID" /></xsl:attribute>
<xsl:attribute name="TARGET">messages</xsl:attribute>
<IMG border="0" src="{$imagesource}threadicon.gif"/>
<xsl:choose>
<xsl:when test="SUBJECT[@SAME='1']">
...
</xsl:when>
<xsl:otherwise>
<b><xsl:value-of select="SUBJECT" /></b>
</xsl:otherwise>
</xsl:choose>
(<xsl:apply-templates select="USER/USERNAME" />, <xsl:apply-templates select="DATEPOSTED" />)
</xsl:element>
</NOBR><br />
-->
</xsl:template>

<xsl:template mode="single" match="FORUMTHREADHEADERS/POST">
<xsl:element name="A">
<xsl:attribute name="href"><xsl:value-of select="$root"/>FSP<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />&amp;post=<xsl:value-of select="@POSTID" /></xsl:attribute>
<IMG border="0" src="{$imagesource}threadicon.gif"/>
<xsl:choose>
<xsl:when test="SUBJECT[@SAME='1']">
...
</xsl:when>
<xsl:otherwise>
<b><xsl:value-of select="SUBJECT" /></b>
</xsl:otherwise>
</xsl:choose>
(<xsl:apply-templates select="USER" mode="username" />, <xsl:apply-templates select="DATEPOSTED" />)
</xsl:element>
<br />
</xsl:template>

<xsl:template match="FORUMTHREADPOSTS/POST">
<xsl:param name="ptype" select="'frame'"/>
<TABLE WIDTH="100%" cellspacing="0" cellpadding="0" border="0">
	<TBODY>
	<TR><TD width="100%" COLSPAN="2">
<HR size="2"/></TD>
	<TD nowrap="1">
<a name="pi{count(preceding-sibling::POST) + 1 + number(../@SKIPTO)}">
<A name="p{@POSTID}">
<xsl:choose>
	<xsl:when test="@PREVINDEX">
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@PREVINDEX]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@PREVINDEX" /></xsl:attribute><IMG width="39" height="31" src="{$imagesource}f_backward.gif" border="0" alt="{$alt_prevpost}"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVINDEX" />#p<xsl:value-of select="@PREVINDEX" /></xsl:attribute><IMG width="39" height="31" src="{$imagesource}f_backward.gif" border="0" alt="{$alt_prevpost}"/></A>
</xsl:otherwise>
</xsl:choose>
<!--	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />&amp;thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@PREVINDEX" /></xsl:attribute><IMG src="{$imagesource}f_backward.gif" border="0" alt="Previous message"/></xsl:element>-->
	</xsl:when>
	<xsl:otherwise>
	<IMG width="41" height="31" src="{$imagesource}f_backgrey.gif" border="0" alt="{$alt_noprevpost}"/>
	</xsl:otherwise>
	</xsl:choose>
	</A>
	</a>
	<xsl:choose>
	<xsl:when test="@NEXTINDEX">
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@NEXTINDEX]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@NEXTINDEX" /></xsl:attribute><IMG width="41" height="31" src="{$imagesource}f_forward.gif" border="0" alt="{$alt_nextpost}"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTINDEX" />#p<xsl:value-of select="@NEXTINDEX" /></xsl:attribute><IMG width="41" height="31" src="{$imagesource}f_forward.gif" border="0" alt="{$alt_nextpost}"/></A>
</xsl:otherwise>
</xsl:choose>
<!--	<xsl:element name="A"><xsl:attribute name="HREF"><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />&amp;thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@NEXTINDEX" /></xsl:attribute><IMG src="{$imagesource}f_forward.gif" border="0" alt="Next message"/></xsl:element>-->
	</xsl:when>
	<xsl:otherwise>
	<IMG width="40" height="30" src="{$imagesource}f_forwardgrey.gif" border="0" alt="{$alt_nonextpost}"/>
	</xsl:otherwise>
	</xsl:choose>
	 </TD>
	</TR>
	<TR>
	<TD ALIGN="left"><FONT face="{$fontface}"><FONT COLOR="#00FFFF"><xsl:value-of select="$m_fsubject"/></FONT><B><xsl:call-template name="postsubject"/></B></FONT><br/>
	<FONT face="{$fontface}" color="#00ffff" size="2">
		<xsl:value-of select="$m_posted"/>
		<xsl:apply-templates select="DATEPOSTED/DATE"/>
	</FONT>
	<xsl:if test="not(@HIDDEN &gt; 0)">
		<FONT face="{$fontface}" color="#00ffff" size="2">
			<xsl:value-of select="$m_by"/>
		</FONT>
		<FONT face="{$fontface}" SIZE="2">
			<xsl:apply-templates select="USER" mode="showonline">
				<xsl:with-param name="symbol"><img src="{$imagesource}online.gif" alt="Online Now"/></xsl:with-param>
			</xsl:apply-templates>
			<A><xsl:attribute name="TARGET">_top</xsl:attribute><xsl:attribute name="href"><xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/></xsl:attribute><xsl:apply-templates select="USER/USERNAME"/></A>
		</FONT>
	</xsl:if>
<xsl:if test="@INREPLYTO">
<br/>
<FONT face="{$fontface}" SIZE="1" color="{$fttitle}"><xsl:value-of select="$m_inreplyto"/><xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><xsl:value-of select="$m_thispost"/></A>. 
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@INREPLYTO" />#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><xsl:value-of select="$m_thispost"/></A>. 
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
<A><xsl:attribute name="HREF"><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>previous reply</A>.
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>previous reply</A>.
</xsl:otherwise>
</xsl:choose>
</FONT>
</xsl:if>

<xsl:if test="@NEXTSIBLING">
<FONT SIZE="1" color="{$fttitle}">
<xsl:text> Read the </xsl:text>
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
<A><xsl:attribute name="HREF"><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>next reply</A>.
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="HREF"><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>next reply</A>.
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
	</TD><TD nowrap="1" ALIGN="center" valign="top"><FONT face="Arial, Helvetica, sans-serif" SIZE="1"><xsl:value-of select="$m_postcolon"/><xsl:value-of select="position() + number(../@SKIPTO)"/><br/></FONT>
<xsl:if test="$showtreegadget=1">
	<TABLE cellpadding="0" cellspacing="0" BORDER="0">
	<TR>
	<TD ROWSPAN="3" align="right" valign="top" width="16" height="33"><xsl:choose><xsl:when test="@PREVSIBLING"><xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute><IMG width="16" height="33" SRC="{$imagesource2}buttons/leftsibling2.gif" BORDER="0" alt="{$alt_prevreply}"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVSIBLING" />#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute><IMG width="16" height="33" SRC="{$imagesource2}buttons/leftsibling2.gif" BORDER="0" alt="{$alt_prevreply}"/></A>
</xsl:otherwise>
</xsl:choose>
</xsl:when><xsl:otherwise><IMG width="16" height="33" SRC="{$imagesource2}buttons/leftsiblingunsel.gif" BORDER="0" alt="{$alt_noolderreplies}"/></xsl:otherwise></xsl:choose></TD>
	<TD align="right" valign="top" width="13" height="11"><xsl:choose><xsl:when test="@INREPLYTO"><xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><IMG SRC="{$imagesource2}buttons/parent2.gif" BORDER="0" width="13" height="11" alt="{$alt_replyingtothis}"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@INREPLYTO" />#p<xsl:value-of select="@INREPLYTO" /></xsl:attribute><IMG SRC="{$imagesource2}buttons/parent2.gif" width="13" height="11" BORDER="0" alt="{$alt_replyingtothis}"/></A>
</xsl:otherwise>
</xsl:choose>
</xsl:when><xsl:otherwise><IMG SRC="{$imagesource2}buttons/parentunsel.gif" width="13" height="11" BORDER="0" alt="{$alt_notareply}"/></xsl:otherwise></xsl:choose></TD>
	<TD ROWSPAN="3" align="right" valign="top" width="16" height="33"><xsl:choose><xsl:when test="@NEXTSIBLING"><xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute><IMG SRC="{$imagesource2}buttons/rightsibling2.gif" width="16" height="33" BORDER="0" alt="{$alt_nextreply}"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTSIBLING" />#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute><IMG SRC="{$imagesource2}buttons/rightsibling2.gif" width="16" height="33" BORDER="0" alt="{$alt_nextreply}"/></A>
</xsl:otherwise>
</xsl:choose>
</xsl:when><xsl:otherwise><IMG SRC="{$imagesource2}buttons/rightsiblingunsel.gif" width="16" height="33" BORDER="0" alt="{$alt_nonewerreplies}"/></xsl:otherwise></xsl:choose></TD>
	</TR>
	<TR>
	<TD align="right" valign="top" width="13" height="11"><IMG SRC="{$imagesource2}buttons/context2.gif" width="13" height="11" BORDER="0" alt="{$alt_currentpost}"/></TD>
	</TR>
	<TR>
	<TD align="right" valign="top" width="13" height="11"><xsl:choose><xsl:when test="@FIRSTCHILD"><xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><IMG SRC="{$imagesource2}buttons/firstchild2.gif" width="13" height="11" BORDER="0" alt="{$alt_firstreply}"/></A>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@FIRSTCHILD" />#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><IMG SRC="{$imagesource2}buttons/firstchild2.gif" width="13" height="11" BORDER="0" alt="{$alt_firstreply}"/></A>
</xsl:otherwise>
</xsl:choose>
</xsl:when><xsl:otherwise><IMG SRC="{$imagesource2}buttons/firstchildunsel.gif" width="13" height="11" BORDER="0" alt="{$alt_noreplies}"/></xsl:otherwise></xsl:choose></TD>
	</TR>
	</TABLE>
</xsl:if>
	</TD>
	</TR>
	</TBODY>
	</TABLE>
<br/>
<FONT face="arial, helvetica, sans-serif" size="3">
<xsl:call-template name="showpostbody"/>
</FONT>
<br/><br/>
<TABLE WIDTH="100%">
<TR>
<TD ALIGN="left">
<xsl:if test="@HIDDEN=0">
<A TARGET="_top">
<xsl:attribute name="href">
	<xsl:apply-templates select="." mode="sso_post_signin"/>
</xsl:attribute>
<img src="{$imagesource}f_reply.gif" border="0" alt="{$alt_reply}"/></A>
</xsl:if>
<xsl:if test="@FIRSTCHILD">
<FONT SIZE="1" color="{$fttitle}"><br/>
<xsl:value-of select="$m_readthe"/>
<xsl:choose>
<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
<A><xsl:attribute name="href">#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><xsl:value-of select="$m_firstreplytothis"/></A><br/>
</xsl:when>
<xsl:otherwise>
<A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">_top</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@FIRSTCHILD" />#p<xsl:value-of select="@FIRSTCHILD" /></xsl:attribute><xsl:value-of select="$m_firstreplytothis"/></A><br/>
</xsl:otherwise>
</xsl:choose>
</FONT>
</xsl:if>
</TD>
<TD ALIGN="RIGHT">
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR'">
						<font size="1"><a target="_top" href="{$root}ModerationHistory?PostID={@POSTID}">moderation history</a></font>
					</xsl:if>
<xsl:if test="@HIDDEN=0">
<A>
  <xsl:attribute name="href">
    javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;postID=<xsl:value-of select="@POSTID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')
  </xsl:attribute>
	<img src="{$imagesource}buttons/complain.gif" border="0" alt="{$alt_complain}"/>
</A>
</xsl:if>
<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR'">
	<xsl:text> </xsl:text><a href="{$root}EditPost?PostID={@POSTID}" target="_top" onClick="javascript:popupwindow('{$root}EditPost?PostID={@POSTID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;">edit</a>
</xsl:if>
</TD>
</TR>
</TABLE>

</xsl:template>

<xsl:template match="REFERENCES/ENTRIES">
	<BR/>
	<BR/>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td bgcolor="#ffffff"><img src="{$imagesource}blank.gif" width="1" height="1"></img></td>
		</tr>
	</table>
	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="2" color="#ffaaaa"><xsl:value-of select="$m_refentries"/></font>
			</td>
		</tr>
		<xsl:apply-templates select="ENTRYLINK"/>
	</table>
</xsl:template>

<xsl:template match="REFERENCES/USERS">
	<BR/>
	<BR/>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td bgcolor="#ffffff"><img src="{$imagesource}blank.gif" width="1" height="1"></img></td>
			</tr>
		</table>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<font face="Arial, Helvetica, sans-serif" size="2" color="#ffaaaa"><xsl:value-of select="$m_refresearchers"/></font>
				</td>
			</tr>
			<xsl:apply-templates select="USERLINK"/>
		</table>
</xsl:template>

<xsl:template match="REFERENCES/EXTERNAL" mode="BBCSites">
	<BR/>
	<BR/>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td bgcolor="#ffffff"><img src="{$imagesource}blank.gif" width="1" height="1"></img></td>
		</tr>
	</table>
	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="2" color="#ffaaaa"><xsl:value-of select="$m_otherbbcsites"/></font>
			</td>
		</tr>
		<xsl:call-template name="ExLinksBBCSites"/>
	</table>
</xsl:template>
	<xsl:template match="CREDITS[/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1]">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td bgcolor="#ffffff">
					<img src="{$imagesource}blank.gif" width="1" height="1"></img>
				</td>
			</tr>
		</table>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<font face="Arial, Helvetica, sans-serif" size="2" color="#ffaaaa">
						<xsl:value-of select="@TITLE"/>
					</font>
				</td>
			</tr>
			<xsl:for-each select="LINK">
				<tr>
					<td>
						<font xsl:use-attribute-sets="mEXTERNALLINK_NONBBCSitesUI">
							<xsl:apply-templates select="."/>
						</font>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

<xsl:template match="REFERENCES/EXTERNAL" mode="NONBBCSites">
	<BR/>
	<BR/>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td bgcolor="#ffffff"><img src="{$imagesource}blank.gif" width="1" height="1"></img></td>
		</tr>
	</table>
	<table border="0" width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="2" color="#ffaaaa"><xsl:value-of select="$m_refsites"/></font>
			</td>
		</tr>
		<xsl:call-template name="ExLinksNONBBCSites"/>
	</table>
	<br/>
	<font face="{$fontface}" size="1">
		<xsl:value-of select="$m_referencedsitesdisclaimer"/>
	</font>
	<br/>
</xsl:template>

<xsl:template match="H2G2/JOURNAL">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<xsl:choose>
<xsl:when test="JOURNALPOSTS/POST">
<!-- owner, full -->
<xsl:call-template name="m_journalownerfull"/>
<xsl:apply-templates select="JOURNALPOSTS" />
<br />
<xsl:if test="JOURNALPOSTS[@MORE=1]">
<A><xsl:attribute name="href"><xsl:value-of select="$root"/>MJ<xsl:value-of select="../PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="JOURNALPOSTS/@FORUMID"/>&amp;show=<xsl:value-of select="JOURNALPOSTS/@COUNT"/>&amp;skip=<xsl:value-of select="number(JOURNALPOSTS/@SKIPTO) + number(JOURNALPOSTS/@COUNT)"/></xsl:attribute>
<xsl:value-of select="$m_clickmorejournal"/></A><br/>
</xsl:if>
<br />
<A href="{$root}PostJournal">
<xsl:value-of select="$m_clickaddjournal"/></A><br/>
</xsl:when>
<xsl:otherwise>
<!-- owner empty -->
<xsl:call-template name="m_journalownerempty"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="JOURNALPOSTS/POST">
<!-- viewer, full -->
<xsl:call-template name="m_journalviewerfull"/>
<xsl:apply-templates select="JOURNALPOSTS" />
<br />
<xsl:if test="JOURNALPOSTS[@MORE=1]">
<A><xsl:attribute name="href"><xsl:value-of select="$root"/>MJ<xsl:value-of select="../PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="JOURNALPOSTS/@FORUMID"/>&amp;show=<xsl:value-of select="JOURNALPOSTS/@COUNT"/>&amp;skip=<xsl:value-of select="number(JOURNALPOSTS/@SKIPTO) + number(JOURNALPOSTS/@COUNT)"/></xsl:attribute>
<xsl:value-of select="$m_clickmorejournal"/></A><br/>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<!-- viewer empty -->
<xsl:call-template name="m_journalviewerempty"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="JOURNALPOSTS">
<xsl:apply-templates select="POST"/>
</xsl:template>

<xsl:template match="RECENT-ENTRIES">
	<xsl:choose>
		<xsl:when test="$ownerisviewer = 1">
			<xsl:choose>
				<xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
					<!-- owner, full-->
					<xsl:call-template name="m_artownerfull"/>
					<xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
					<br />
					<A><xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute><xsl:value-of select="$m_clickmoreentries"/></A><br />
					<br/>
					<a href="{$root}useredit"><xsl:value-of select="$m_clicknewentry"/></a>
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
					<xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
					<br />
					<A><xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute><xsl:value-of select="$m_clickmoreentries"/></A><br />
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

<xsl:template match="RECENT-APPROVALS">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<xsl:choose>
<xsl:when test="ARTICLE-LIST/ARTICLE">
<xsl:call-template name="m_editownerfull"/>
<xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries]"/>
<br />
<A><xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1</xsl:attribute><xsl:value-of select="$m_clickmoreedited"/></A><br />
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="m_editownerempty"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="ARTICLE-LIST/ARTICLE">
<xsl:call-template name="m_editviewerfull"/>
<xsl:apply-templates select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries]"/>
<br />
<A><xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1</xsl:attribute><xsl:value-of select="$m_clickmoreedited"/></A><br />
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="m_editviewerempty"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="POSTTHREADFORM" mode="Preview">
	<xsl:if test="$test_PreviewError">
		<B>
			<xsl:apply-templates select="PREVIEWERROR"/>
		</B>
		<BR/>
	</xsl:if>
	<xsl:if test="$test_HasPreviewBody">
		<B><xsl:value-of select="$m_whatpostlooklike"/></B><br />
		<TABLE WIDTH="100%">
			<TR>
				<TD width="100%"><HR/></TD>
				<TD nowrap="1">
					<IMG src="{$imagesource}f_backgrey.gif" border="0" alt="{$alt_noprevpost}"/>
					<IMG src="{$imagesource}f_forwardgrey.gif" border="0" alt="{$alt_nonextpost}"/>
				</TD>
			</TR>
		</TABLE>
		<FONT COLOR="#00FFFF"><xsl:value-of select="$m_postedsoon"/></FONT>
		<xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="UserName"/>
		<BR/>
		<FONT COLOR="#00FFFF"><xsl:value-of select="$m_fsubject"/></FONT> <B><xsl:value-of select="SUBJECT"/></B>
		<BR/>
		<xsl:apply-templates select="PREVIEWBODY" />
		<br/><br/>
	</xsl:if>
</xsl:template>

<xsl:template match="PAGEUI/BANNER">
<A TARGET="_top" HREF="{$bannerurl}"><img src="{$bannersrc}" width="468" height="60" vspace="0" hspace="0" border="0"/></A>
<!--<A TARGET="_h2g2banner"><xsl:attribute name="HREF">http://ad.uk.doubleclick.net/jump/h2g2.com/frontpage;sec=<xsl:value-of select="@SECTION"/>;sz=468x60;ord=<xsl:value-of select="@SEED"/>?</xsl:attribute><IMG name="Ngui_01_03" height="60" width="468" border="0" vspace="0" hspace="0"><xsl:attribute name="SRC">http://ad.uk.doubleclick.net/ad/h2g2.com/frontpage;sec=<xsl:value-of select="@SECTION"/>;sz=468x60;ord=<xsl:value-of select="@SEED"/>?</xsl:attribute></IMG></A>-->
</xsl:template>

<xsl:template match="BOXHOLDER">
<xsl:for-each select="BOX">
<xsl:if test="position() mod 2 = 1">
<xsl:variable name="pos"><xsl:value-of select="position()"/></xsl:variable>
<br clear="all" />
<table border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0">
<tr>
<td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/bluecircle_L.gif" width="13" height="24"/></td>
<td bgcolor="{$headertopedgecolour}" colspan="3" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
<td rowspan="3" width="13"><img src="{$imagesource}layout/greencircle_R.gif" width="13" height="24"/></td>
</tr>
<tr> 
<td bgcolor="{$verticalbarcolour}" colspan="3"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
</tr>
<tr> 
<td bgcolor="{$boxholderleftcolour}"><font face="Arial, Helvetica, sans-serif"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="{$boxholderfontcolour}"><xsl:value-of select="TITLE"/></font></b></font></td>
<td width="24" bgcolor="{$boxholderrightcolour}"><img src="{$imagesource}layout/wave_joined.gif" width="57" height="22"/></td>
<td bgcolor="{$boxholderrightcolour}"><font face="Arial, Helvetica, sans-serif"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="{$boxholderfontcolour}"><xsl:value-of select="../BOX[$pos+1]/TITLE"/></font></b></font></td>
</tr>
        <tr> 
          <td align="right" width="13">&nbsp;</td>
          <td valign="top" align="left" width="50%"> 
            <p><br />
              <font face="Arial, Helvetica, sans-serif" size="2">
			  <xsl:apply-templates select="TEXT" />
			  </font>
			  </p>
          </td>
          <td width="24">&nbsp;</td>
          <td valign="top" align="left" width="50%">
		    <p><br />
              <font face="Arial, Helvetica, sans-serif" size="2">
			  <xsl:apply-templates select="../BOX[$pos+1]/TEXT" /></font></p>
          </td>
          <td width="13">&nbsp;</td>
        </tr>
</table>
</xsl:if>
</xsl:for-each>
</xsl:template>

<xsl:template name="fpb_thisblock">
<xsl:param name="blocknumber"/>
<xsl:param name="objectname"/>
<xsl:param name="PostRange"/>
				<img src="{$imagesource2}buttons/forumselected.gif" width="14" height="14" border="0">
					<xsl:attribute name="alt">
						<xsl:value-of select="$objectname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$PostRange"/>
					</xsl:attribute>
				</img>
</xsl:template>

<xsl:template name="fpb_otherblock">
<xsl:param name="blocknumber"/>
<xsl:param name="objectname"/>
<xsl:param name="PostRange"/>
				<img src="{$imagesource2}buttons/forumunselected.gif" width="14" height="14" border="0">
					<xsl:attribute name="alt">
						<xsl:value-of select="$objectname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$PostRange"/>
					</xsl:attribute>
				</img>
</xsl:template>

<xsl:template name="fpb_start">
				<font size="2"><xsl:text> &lt;&lt; </xsl:text></font>
</xsl:template>

<xsl:template name="fpb_prevset">
				<font size="2"><xsl:text> &lt; </xsl:text></font>
</xsl:template>
<xsl:template name="fpb_nextset">
				<font size="2"><xsl:text> &gt; </xsl:text></font>
</xsl:template>
<xsl:template name="fpb_end">
				<font size="2"><xsl:text> &gt;&gt; </xsl:text></font>
</xsl:template>


<xsl:template name="xxforumpostblocks">
	<xsl:param name="thread"></xsl:param>
	<xsl:param name="forum"></xsl:param>
	<xsl:param name="total"></xsl:param>
	<xsl:param name="show">20</xsl:param>
	<xsl:param name="skip">0</xsl:param>
	<xsl:param name="this">0</xsl:param>
	<xsl:param name="splitevery">0</xsl:param>
	<xsl:param name="url">F</xsl:param>
	<xsl:param name="objectname"><xsl:value-of select="$m_postings"/></xsl:param>
	<xsl:param name="target">_top</xsl:param>
	<xsl:param name="ExtraParameters"/>
<xsl:variable name="postblockon"><xsl:value-of select="$imagesource2"/>buttons/forumselected.gif</xsl:variable>
<xsl:variable name="postblockoff"><xsl:value-of select="$imagesource2"/>buttons/forumunselected.gif</xsl:variable>
<xsl:if test="($skip mod $splitevery) = 0 and ($splitevery &gt; 0) and ($skip != 0)">
<br/>
</xsl:if>

	<a><xsl:if test="$target!=''"><xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/>?<xsl:if test="$thread!=''">thread=<xsl:value-of select="$thread"/>&amp;</xsl:if>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
		<xsl:variable name="PostRange"><xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="number($this) = number($skip)">
				<img src="{$postblockon}" border="0"><xsl:attribute name="alt"><xsl:value-of select="$alt_nowshowing"/><xsl:value-of select="$objectname"/><xsl:text> </xsl:text> <xsl:value-of select="$PostRange"/></xsl:attribute></img>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$postblockoff}" border="0"><xsl:attribute name="alt"><xsl:value-of select="$alt_show"/><xsl:value-of select="$objectname"/><xsl:text> </xsl:text> <xsl:value-of select="$PostRange"/></xsl:attribute></img>
			</xsl:otherwise>
		</xsl:choose>
	</a>
	<img src="{$imagesource}blank.gif" width="2" height="1"/>
	<xsl:choose>

	<xsl:when test="(number($skip) + number($show)) &lt; number($total)">
		<xsl:call-template name="forumpostblocks">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="number($skip) + number($show)"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
			<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	<br/>
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!--

	<xsl:template name="insert-bodymargin">

	Generic:	No
	Purpose:	Depending on the page type, indent the main body by
				inserting a width attribute and a blank gif

-->

<xsl:template name="insert-bodymargin">
<xsl:choose>
	<xsl:when test="@TYPE='FRONTPAGE'">
		<!-- do nothing -->
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="ARTICLE_BODYMARGIN"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="ARTICLE_BODYMARGIN">
<xsl:attribute name="width">25</xsl:attribute><img src="{$imagesource}blank.gif" width="25" height="1"/>
</xsl:template>

<xsl:template name="FRONTPAGE_MAINBODY">
	<!--xsl:if test="$fpregistered=1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<TD align="left" valign="top">
	<font xsl:use-attribute-sets="welcomeback">
	<xsl:call-template name="m_welcomebackuser"/>
	</font>
	</TD>
	</tr>
	</table>
	</xsl:if-->
	<font face="{$fontface}">
		<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM">
			<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
		</xsl:apply-templates>
	</font>
</xsl:template>

<xsl:template name="FRONTPAGE_SIDEBAR">
	<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION"/>
	<xsl:apply-templates select="/H2G2/TOP-FIVES" />
</xsl:template>

<xsl:template name="INFO_MAINBODY">
<font xsl:use-attribute-sets="frontpagefont">
<xsl:apply-templates select="INFO"/>
</font>
</xsl:template>
<xsl:template name="USERPAGE_MAINBODY">
	

	<br/>
	<!-- do any error reports before anything else
		 currently just says if there is an error, but could give more info
	-->
	<xsl:if test="/H2G2/ARTICLE/ERROR">
		<p>
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
<xsl:call-template name="m_pserrorowner"/>
				</xsl:when>
				<xsl:otherwise>
<xsl:call-template name="m_pserrorviewer"/>
				</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:if>

	
	<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTRO" />
	
	<font face="Arial, Helvetica, sans-serif" color="white">
	<xsl:choose>
	<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
	<xsl:call-template name="m_userpagehidden"/>
	</xsl:when>
	<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
	<xsl:call-template name="m_userpagereferred"/>
	</xsl:when>
	<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
	<xsl:call-template name="m_userpagependingpremoderation"/>
	</xsl:when>
	<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
	<xsl:call-template name="m_legacyuserpageawaitingmoderation"/>
	</xsl:when>
	
	<xsl:otherwise>
	<xsl:choose>
		<xsl:when test="$test_introarticle"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" /></xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
<xsl:call-template name="m_psintroowner"/>
				</xsl:when>
				<xsl:otherwise>
					<font face="arial, helvetica, sans-serif" size="2">
<xsl:call-template name="m_psintroviewer"/>
					</font>
				</xsl:otherwise>
			</xsl:choose>
<!--
			<P>This is the Personal Home Page for <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>.
			Unfortunately <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
			hasn't managed to find the time to write his or her own
			Home Page Introduction, but hopefully they soon will.</P>
			<P>By the way, if you've registered but haven't yet written an
			Entry to display as <I>your</I> Home Page Introduction, then this
			is what your Home Page looks like to visitors. You change
			this by going to your Home Page, clicking on the Edit Page
			button, and putting whatever you want as your Home Page Introduction.</P>
-->
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test=".//FOOTNOTE">
	<blockquote>
	<font size="-1">
	<hr />
	<xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
	</font>
	</blockquote>
	</xsl:if>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS" />
<br clear="all" />
<table border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0">
<tr>
<td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/bluecircle_L.gif" width="13" height="24"/></td>
<td bgcolor="{$headertopedgecolour}" colspan="3" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
<td rowspan="3" width="13"><img src="{$imagesource}layout/greencircle_R.gif" width="13" height="24"/></td>
</tr>
<tr> 
<td bgcolor="{$verticalbarcolour}" colspan="3"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
</tr>
<tr> 
<td bgcolor="{$boxholderleftcolour}"><font face="Arial, Helvetica, sans-serif"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="{$boxholderfontcolour}"><xsl:value-of select="$mymessage"/><xsl:value-of select="$m_journalentries"/></font></b></font></td>
<td width="24" bgcolor="{$boxholderrightcolour}"><img src="{$imagesource}layout/wave_joined.gif" width="57" height="22"/></td>
<td bgcolor="{$boxholderrightcolour}"><font face="Arial, Helvetica, sans-serif"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="{$boxholderfontcolour}"><xsl:value-of select="$mymessage"/><xsl:value-of select="$m_mostrecentconv"/></font></b></font></td>
</tr>
        <tr> 
          <td align="right" width="13">&nbsp;</td>
          <td valign="top" align="left" width="50%"> 
            <p><br />
              <font face="Arial, Helvetica, sans-serif" size="2">
			  <!--Welcome to your Journal. <A HREF="/dontpanic-journal">Click here for more information about your journal and what you can do with it</A><br/><br/>-->
			  <xsl:apply-templates select="JOURNAL" />
			  </font>
			  </p>
          </td>
          <td width="24">&nbsp;</td>
          <td valign="top" align="left" width="50%">
         	 <br />
         
		    <p>
              <font face="Arial, Helvetica, sans-serif" size="2">
			  <xsl:apply-templates select="RECENT-POSTS" /></font></p>
          </td>
          <td width="13">&nbsp;</td>
        </tr>
</table>
<br clear="all" />
<table border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0">
<tr>
<td rowspan="3" align="right" width="13"><img src="{$imagesource}layout/bluecircle_L.gif" width="13" height="24"/></td>
<td bgcolor="{$headertopedgecolour}" colspan="3" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
<td rowspan="3" width="13"><img src="{$imagesource}layout/greencircle_R.gif" width="13" height="24"/></td>
</tr>
<tr> 
<td bgcolor="{$verticalbarcolour}" colspan="3"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
</tr>
<tr> 
<td bgcolor="{$boxholderleftcolour}"><font face="Arial, Helvetica, sans-serif"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="{$boxholderfontcolour}"><xsl:value-of select="$mymessage"/><xsl:value-of select="$m_recententries"/></font></b></font></td>
<td width="24" bgcolor="{$boxholderrightcolour}"><img src="{$imagesource}layout/wave_joined.gif" width="57" height="22"/></td>
<td bgcolor="{$boxholderrightcolour}"><font face="Arial, Helvetica, sans-serif"><b><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="{$boxholderfontcolour}"><xsl:value-of select="$mymessage"/><xsl:value-of select="$m_mostrecentedited"/></font></b></font></td>
</tr>
        <tr> 
          <td align="right" width="13">&nbsp;</td>
          <td valign="top" align="left" width="50%"> 
            <p><br />
              <font face="Arial, Helvetica, sans-serif" size="2"><xsl:apply-templates select="RECENT-ENTRIES" /><br /><br /></font>
			  </p>
          </td>
          <td width="24">&nbsp;</td>
          <td valign="top" align="left" width="50%">
		    <p><br />
              <font face="Arial, Helvetica, sans-serif" size="2"><xsl:apply-templates select="RECENT-APPROVALS" /><br /><br /></font></p>
          </td>
          <td width="13">&nbsp;</td>
        </tr>
</table>
<xsl:call-template name="SUBJECTHEADER">
<xsl:with-param name="text">Friends</xsl:with-param>
</xsl:call-template>
<blockquote>
<xsl:apply-templates select="WATCHED-USER-LIST"/>
<xsl:apply-templates select="WATCHING-USER-LIST"/>

</blockquote>
</font>	

</xsl:template>

<xsl:template name="createpreload">
<xsl:param name="imgname">test</xsl:param>
I<xsl:value-of select="$imgname"/> = new Image; I<xsl:value-of select="$imgname"/>.src = '<xsl:value-of select="$imagesource2"/>newbuttons/<xsl:value-of select="$imgname"/>.jpg';<xsl:text>
</xsl:text>I<xsl:value-of select="$imgname"/>_ro = new Image; I<xsl:value-of select="$imgname"/>_ro.src = '<xsl:value-of select="$imagesource2"/>newbuttons/rollover/<xsl:value-of select="$imgname"/>.jpg';<xsl:text>
</xsl:text>I<xsl:value-of select="$imgname"/>_down = new Image; I<xsl:value-of select="$imgname"/>_down.src = '<xsl:value-of select="$imagesource2"/>newbuttons/down/<xsl:value-of select="$imgname"/>.jpg';<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="button">
<xsl:param name="href"/>
<xsl:param name="onclickextra"/>
<xsl:param name="onclickreturn">true</xsl:param>
<xsl:param name="imgname"/>
<xsl:param name="message"/>
<xsl:param name="title"/>
<xsl:param name="test">1</xsl:param>
<xsl:param name="target">_top</xsl:param>
<xsl:choose>
<xsl:when test="number($test) = 1">
<a 
href="{$href}" 
target="{$target}" 
onMouseOver="di('N{$imgname}','I{$imgname}_ro');dm('{$message}');return true;"
onMouseOut="di('N{$imgname}','I{$imgname}');dm('');return true;"
onClick="di('N{$imgname}','I{$imgname}_down');{$onclickextra}return {$onclickreturn};"><img name="N{$imgname}" src="{$imagesource2}newbuttons/{$imgname}.jpg" border="0" alt="{$message}" title="{$title}"></img></a><br />
</xsl:when>
<xsl:otherwise>
<img border="0" src="{$imagesource2}newbuttons/blank/{$imgname}.jpg"/><br/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="buttonchoice">
<xsl:param name="href"/>
<xsl:param name="imgname"/>
<xsl:param name="message"/>
<xsl:param name="title"/>
<xsl:param name="onclickextra"/>
<xsl:param name="onclickreturn"/>
<xsl:param name="href1"/>
<xsl:param name="imgname1"/>
<xsl:param name="message1"/>
<xsl:param name="title1"/>
<xsl:param name="test">1</xsl:param>

<xsl:choose>
<xsl:when test="number($test)=1">
<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$href"/></xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="$imgname"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$message"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$title"/></xsl:with-param>
<xsl:with-param name="onclickextra"><xsl:value-of select="$onclickextra"/></xsl:with-param>
<xsl:with-param name="onclickreturn"><xsl:value-of select="$onclickreturn"/></xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="button">
<xsl:with-param name="href"><xsl:value-of select="$href1"/></xsl:with-param>
<xsl:with-param name="imgname"><xsl:value-of select="$imgname1"/></xsl:with-param>
<xsl:with-param name="message"><xsl:value-of select="$message1"/></xsl:with-param>
<xsl:with-param name="title"><xsl:value-of select="$title1"/></xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<!--
	Templates to force the use of the base stylesheets implementation
-->

<!-- moderation stuff here -->

<xsl:template match='H2G2[@TYPE="FORUM-MODERATION"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATE-HOME"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="USER-COMPLAINT"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="EDIT-POST"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATION-TOP-FRAME"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATION-DISPLAY-FRAME"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATION-FORM-FRAME"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATE-NICKNAMES"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATE-STATS"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="MODERATION-HISTORY"]'>
	<xsl:apply-imports/>
</xsl:template>

<!--
	Internal Tools templates from here on
-->

<!--
	Need this template here due to matching priority in derived stylesheet
	but it simply calls the named template in the base stylesheet and this
	does the actual work.
-->

<xsl:template match='H2G2[@TYPE="RECOMMEND-ENTRY" and @MODE="POPUP"]'>
	<xsl:call-template name="RECOMMEND-ENTRY-POPUP"/>
</xsl:template>


<!--<xsl:template match='H2G2[@TYPE="SUBMIT-SUBBED-ENTRY" and @MODE="POPUP"]'>-->
<xsl:template match='H2G2[@TYPE="SUBMIT-SUBBED-ENTRY"]'>
<!--	<xsl:call-template name="SUBMIT-SUBBED-ENTRY-POPUP"/>-->
	<xsl:call-template name="SUBMIT-SUBBED-ENTRY"/>
</xsl:template>

<!--<xsl:template match='H2G2[@TYPE="PROCESS-RECOMMENDATION" and @MODE="POPUP"]'>-->
<xsl:template match='H2G2[@TYPE="PROCESS-RECOMMENDATION"]'>
	<xsl:apply-imports/>
</xsl:template>

<!--<xsl:template match='H2G2[@TYPE="MOVE-THREAD" and @MODE="POPUP"]'>-->
<xsl:template match='H2G2[@TYPE="MOVE-THREAD"]'>
	<xsl:apply-imports/>
</xsl:template>

<!--
<xsl:template match='H2G2[@TYPE="SUB-ALLOCATION"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match="SUB-ALLOCATION-FORM">
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="SCOUT-RECOMMENDATIONS"]'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match="UNDECIDED-RECOMMENDATIONS">
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='PROCESS-RECOMMENDATION-FORM'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='MOVE-THREAD-FORM'>
	<xsl:apply-imports/>
</xsl:template>

<xsl:template match='H2G2[@TYPE="INSPECT-USER"]'>
	<xsl:apply-imports/>
</xsl:template>
-->

<xsl:template name="m_submitforreviewbutton">
<img src="{$imagesource}newbuttons/submit_for_review.gif" border="0" name="SubmitToReviewForum" alt="{$alt_submittoreviewforum}">
</img>
</xsl:template>

<xsl:template name="m_recommendentrybutton">
<img src="{$imagesource}newbuttons/recommendentry.gif" border="0" name="RecommendEntry" alt="{$alt_recommendthisentry}"/>
<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
<xsl:attribute name="onMouseOver">MM_swapImage('RecommendEntry','','{$imagesource}newbuttons/recommendentry_ro.gif',1)</xsl:attribute>
</xsl:template>

<xsl:template name='REVIEWFORUM_SIDEBAR'>
<table border="0" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td bgcolor="#FFFFFF"><img src="{$imagesource}blank.gif" width="1" height="1"></img></td></tr>
</table>
<table border="0" width="135" cellpadding="3" cellspacing="0">
	<tr><td>
	<font size="2" face="Arial, Helvetica, sans-serif"><b><xsl:value-of select="$m_reviewforumdatatitle"/></b></font>
	</td></tr>															
	
	<tr><td><font size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_reviewforumdataname"/><xsl:value-of select="REVIEWFORUM/FORUMNAME"/></font></td></tr>
	<tr><td><font size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_reviewforumdataurl"/><xsl:value-of select="REVIEWFORUM/URLFRIENDLYNAME"/></font></td></tr> 
	<xsl:choose>
		<xsl:when test="REVIEWFORUM/RECOMMENDABLE=1"><tr><td><font size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_reviewforumdata_recommend_yes"/></font></td></tr>
		<tr><td><font size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_reviewforumdata_incubate"/><xsl:value-of select="REVIEWFORUM/INCUBATETIME"/> days</font></td></tr>
		</xsl:when>
		<xsl:otherwise><tr><td><font size="1" face="Arial, Helvetica, sans-serif"><xsl:value-of select="$m_reviewforumdata_recommend_no"/></font></td></tr></xsl:otherwise>
	</xsl:choose>

	<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
	<tr><td><font size="1" face="Arial, Helvetica, sans-serif">
	<xsl:value-of select="$m_reviewforumdata_h2g2id"/> <A><xsl:attribute name="HREF">A<xsl:value-of select="REVIEWFORUM/H2G2ID"/></xsl:attribute>A<xsl:value-of select="REVIEWFORUM/H2G2ID"/></A>
	</font></td></tr>
	<tr><td><font size="1" face="Arial, Helvetica, sans-serif">
	<a><xsl:attribute name="HREF"><xsl:value-of select="$root"/>EditReview?id=<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute><xsl:value-of select="$m_reviewforumdata_edit"/></a></font>
	</td></tr>
	</xsl:if>
</table>
								
									
</xsl:template>

<xsl:template match="TOP-FIVES">
	<!--xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser')]"/-->
	<xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') or (@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') and (@NAME = /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE)] | /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/TOP-FIVE"/>

</xsl:template>
<xsl:template match="TOP-FIVE-ITEM">
	<li>
		<font xsl:use-attribute-sets="topfiveitem">
			<a href="{ADDRESS}">
				<xsl:value-of select="SUBJECT"/>
			</a>
		</font>
	</li>
</xsl:template>
<xsl:template match="TOP-FIVE">
	<br/>
	<b>
		<font xsl:use-attribute-sets="topfivefont" color="{$topfivetitle}">
			<xsl:value-of select="TITLE" />
		</font>
	</b>
	<!-- here -->
 			<table width="165" border="0" cellspacing="0" cellpadding="0">
    				<tr bgcolor="{$boxfontcolour}"> 
      				<td>
      					<img src="{$imagesource}blank.gif" width="100" height="1"/>
      				</td>
    				</tr>
   				<tr> 
      				<td>
				<UL>
					<xsl:choose>
						<xsl:when test="/H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE[.=current()/@NAME]">
							<xsl:variable name="display" select="/H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE[.=current()/@NAME]/@SHOW + 1"/>
							<!-- Set the number of TOP-FIVE's to display for the auto-generated top-fives -->
							<xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt; $display] | TOP-FIVE-FORUM[position() &lt; $display] | TOP-FIVE-ITEM[position() &lt; $display]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="TOP-FIVE-ARTICLE | TOP-FIVE-FORUM | TOP-FIVE-ITEM"/>
						</xsl:otherwise>
					</xsl:choose>
				</UL>
			</td>
		</tr>
	</table>
	<br/>
</xsl:template>


	<xsl:template name="SOLOGUIDEENTRIES_MAINBODY">
		<!--<xsl:apply-templates select="/H2G2" mode="ml-navbar"/>-->
		<xsl:apply-templates select="/H2G2/ERROR" mode="errormessage"/>
		<xsl:apply-templates select="/H2G2/SOLOGUIDEENTRIES/SOLOUSERS" mode="solousers-table"/>
		<xsl:apply-templates select="/H2G2/SOLOGUIDEENTRIES" mode="previousnext"/>
	</xsl:template>

	<xsl:template match="SOLOGUIDEENTRIES" mode="previousnext">
		<div class="moreusers">
			<xsl:if test="@SKIP &gt; 0">
				<a href="{$root}SOLO?skip={number(@SKIP)-number(@SHOW)}&amp;show={@SHOW}">&lt;&lt; Previous</a>&nbsp;
			</xsl:if>
			<xsl:if test="@MORE=1">
				<a href="{$root}SOLO?skip={number(@SKIP)+number(@SHOW)}&amp;show={@SHOW}">Next &gt;&gt;</a>&nbsp;
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="SOLOUSERS" mode="solousers-table">
		<div class="solousers">
			<table>
				<col class="solo-userid"/>
				<col class="solo-username"/>
				<col class="solo-count"/>
				<col class="solo-check"/>
				<tr>
					<th>User ID</th>
					<th>User Name</th>
					<th>Count</th>
					<xsl:if test="$test_IsEditor">
						<th>Check Groups</th>
					</xsl:if>
				</tr>
				<xsl:apply-templates select="SOLOUSER" mode="solouser-table"/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="H2G2" mode="solo-navbar">
		<ul class="solo-navbar">
			<li>
				<xsl:if test="@TYPE='SOLOGUIDEENTRIES'">
					<xsl:attribute name="class">solo-navselected</xsl:attribute>
				</xsl:if>
				<a href="{$root}SOLO">Solo Guide Entry Counts</a>
			</li>
		</ul>
	</xsl:template>

	<xsl:template match="ERROR" mode="errormessage">
		<p>
			<xsl:value-of select="@TYPE"/> -
			<xsl:value-of select="ERRORMESSAGE"/>
		</p>
	</xsl:template>

	<xsl:template match="SOLOUSER" mode="solouser-table">
		<tr>
			<td>
				<a href="{$root}U{USER/USERID}">
					<xsl:value-of select="USER/USERID"/>
				</a>
			</td>
			<td>
				<xsl:apply-templates select="USER" mode="username" />
			</td>
			<td>
				<xsl:value-of select="ENTRY-COUNT"/>
			</td>
			<xsl:if test="$test_IsEditor">
				<td>
					<a href="{$root}SOLO?action=checkgroups&amp;userid={USER/USERID}">
						Check U<xsl:value-of select="USER/USERID"/>'s Prolific Scribe badge
					</a>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	
</xsl:stylesheet>

