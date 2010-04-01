<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" version="1.0" exclude-result-prefixes="msxsl local s dt">
  <xsl:import href="../../../base/base.xsl"/>
	<!--ALTERED FOR TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
For Live/DEV: <xsl:import href="../base.xsl"/>
For LOCAL:    <xsl:import href="Q:\h2g2\dna\ref\base.xsl"/>
-->
	<xsl:include href="Skin_AddJournal.xsl"/>
	<xsl:include href="Skin_AddThread.xsl"/>
	<xsl:include href="Skin_AlphaIndex.xsl"/>
	<xsl:include href="Skin_Article.xsl"/>
	<xsl:include href="Skin_ArticleSearch.xsl"/>
	<xsl:include href="Skin_Category.xsl"/>
	<xsl:include href="Skin_EnhEditor.xsl"/>
	<xsl:include href="Skin_Home.xsl"/>
	<xsl:include href="Skin_Journal.xsl"/>
	<xsl:include href="Skin_Logout.xsl"/>
	<xsl:include href="Skin_ManageRoute.xsl"/>
	<xsl:include href="Skin_MoreLinks.xsl"/>
	<xsl:include href="Skin_MoreRoutes.xsl"/>
	<xsl:include href="Skin_MorePages.xsl"/>
	<xsl:include href="Skin_MorePosts.xsl"/>
	<xsl:include href="Skin_MultiPosts.xsl"/>
	<xsl:include href="Skin_PerSpace.xsl"/>
	<xsl:include href="Skin_Registration.xsl"/>
	<xsl:include href="Skin_ReviewForum.xsl"/>
	<xsl:include href="Skin_Search.xsl"/>
	<xsl:include href="Skin_SoloGuideEntries.xsl"/>
	<xsl:include href="Skin_Subscribe.xsl"/>
	<xsl:include href="Skin_Text.xsl"/>
	<xsl:include href="Skin_Threads.xsl"/>
	<xsl:include href="Skin_UserEdit.xsl"/>
  <xsl:include href="Skin_SubscribedArticles.xsl"/>
  <xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO-8859-1" 
  	doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
  <xsl:variable name="sitename">h2g2</xsl:variable>
	<xsl:variable name="root">
		<xsl:choose>
			<xsl:when test="$registered=1">/dna/h2g2/brunel/</xsl:when>
			<xsl:otherwise>/dna/h2g2/</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="bbcpage_variant"/>
<!--  <xsl:variable name="use-maps">0</xsl:variable> -->

  <xsl:variable name="use-maps">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='GURUS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='ACES'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='GUARDIANS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='SUBS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='COMMUNITYARTISTS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='POSTREPORTERS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='UNDERGUIDE'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='SCOUTS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='CURATORS'] or    /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='BBCTESTER'] or   ($superuser = 1)">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

	<xsl:variable name="imagesource">
		<xsl:value-of select="$foreignserver"/>/h2g2/skins/brunel/images/</xsl:variable>
	<xsl:variable name="smileysource">
		<xsl:value-of select="$foreignserver"/>/h2g2/skins/Alabaster/images/Smilies/</xsl:variable>
	<!-- ALTERED FOR TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
For Live:     <xsl:variable name="smileysource"><xsl:value-of select="$imagesource"/>Smilies/</xsl:variable>
For DEV:      <xsl:variable name="smileysource">http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/</xsl:variable>
For LOCAL:    <xsl:variable name="smileysource">http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/</xsl:variable>
For Live:     <xsl:variable name="imagesource">/h2g2/skins/brunel/images/</xsl:variable>
For DEV:      <xsl:variable name="imagesource">http://www.bbc.co.uk/h2g2/skins/brunel/images/</xsl:variable>
For LOCAL:    <xsl:variable name="imagesource">Q:\h2g2\dna\brunel\images\</xsl:variable>
-->
	<xsl:variable name="skinname">brunel</xsl:variable>
	<xsl:variable name="alinkcolour">#ffffcc</xsl:variable>
	<xsl:variable name="linkcolour">#ffffff</xsl:variable>
	<xsl:variable name="vlinkcolour">#ffffff</xsl:variable>
	<xsl:variable name="bgcolour">#000000</xsl:variable>
	<xsl:variable name="catboxbg">#990000</xsl:variable>
	<xsl:variable name="expertmode" select="false()"/>
	<xsl:variable name="framesmode" select="false()"/>
	<xsl:variable name="sso_assets_path">/h2g2/sso/h2g2_resources</xsl:variable>
	<xsl:variable name="sso_serviceid_link">h2g2</xsl:variable>
	<xsl:attribute-set name="linkatt">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="journallinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="guidemllinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="convcontentlinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="usereditlinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="addthreadlinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="reviewforumlinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="convdetailslinks">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="maForumID_AddThread">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_login_noaccnt">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_login_accnt">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_registertodiscuss">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_unregistereduserediterror1">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_unregistereduserediterror2">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_unregistereduserediterror3">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnotregistered1">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnotregistered2">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnotregistered3">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnotregistered4">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnoterms1">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnoterms2">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_cantpostnoterms3">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_submitarticlefirst_text">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_submitarticlelast_text">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum1">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum2">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum3">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_removefromreviewsuccesslink1">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_removefromreviewsuccesslink2">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum3">
		<xsl:attribute name="class">norm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="boxfont" use-attribute-sets="textfont"/>
	<xsl:attribute-set name="mLINK">
		<xsl:attribute name="class"><xsl:choose>
			<xsl:when test="ancestor::CREDITS">norm</xsl:when>
			<xsl:otherwise> pos</xsl:otherwise>
		</xsl:choose></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="RetToEditorsLinkAttr">
		<xsl:attribute name="class">pos</xsl:attribute>
		<xsl:attribute name="onClick">popupwindow('<xsl:value-of select="/H2G2/PAGEUI/ENTRY-SUBBED/@LINKHINT"/>','SubbedEntry','resizable=1,scrollbars=1,width=375,height=300');return false;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mainbodytag">
		<xsl:attribute name="vlink">#CCCCCC</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="captionfont" use-attribute-sets="smallfont">
		<xsl:attribute name="class">postxt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="headerfont">
		<xsl:attribute name="face">arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">6</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xheaderfont">
		<xsl:attribute name="face">arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">4</xsl:attribute>
		<xsl:attribute name="color">#666666</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="textheaderfont">
		<xsl:attribute name="face">Trebuchet MS, arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">4</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
		<xsl:attribute name="class">poshead</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="subheaderfont">
		<xsl:attribute name="face">arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">3</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="textsubheaderfont">
		<xsl:attribute name="face">Trebuchet MS, arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">3</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
		<xsl:attribute name="class">poshead</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="alphaindexfont">
		<xsl:attribute name="face">Trebuchet MS, arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">3</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xsubheaderfont">
		<xsl:attribute name="face">arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">2</xsl:attribute>
		<xsl:attribute name="color">#666666</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="face">arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">2</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="textfont">
		<xsl:attribute name="face">Trebuchet MS, arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">2</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
		<xsl:attribute name="class">postxt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="smallfont">
		<xsl:attribute name="face">verdana, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">1</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nullsmallfont">
		<xsl:attribute name="face">verdana, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">1</xsl:attribute>
		<xsl:attribute name="color">#999999</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="xsmallfont">
		<xsl:attribute name="face">arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">1</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="textsmallfont">
		<xsl:attribute name="face">Trebuchet MS, arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">1</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
		<xsl:attribute name="class">postxt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nu_hr">
		<xsl:attribute name="NOSHADE">NOSHADE</xsl:attribute>
		<xsl:attribute name="SIZE">1</xsl:attribute>
		<xsl:attribute name="COLOR">#999999</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template name="SUBJECTHEADER">
		<xsl:param name="text">?????</xsl:param>
		<font xsl:use-attribute-sets="headerfont">
			<b>
				<xsl:value-of select="$text"/>
			</b>
		</font>
	</xsl:template>
	<xsl:template match="HEADER">
		<xsl:if test="@ANCHOR">
			<a name="{@ANCHOR}"/>
		</xsl:if>
		<p>
			<font xsl:use-attribute-sets="textheaderfont">
				<b>
					<xsl:apply-templates/>
				</b>
			</font>
		</p>
	</xsl:template>
	<xsl:template name="HEADER">
		<xsl:param name="text">?????</xsl:param>
		<p>
			<font xsl:use-attribute-sets="textheaderfont">
				<b>
					<xsl:value-of select="$text"/>
				</b>
			</font>
		</p>
	</xsl:template>
	<xsl:template match="GUIDE/BODY">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="SUBHEADER">
		<xsl:if test="@ANCHOR">
			<a name="{@ANCHOR}"/>
		</xsl:if>
		<p>
			<font xsl:use-attribute-sets="textsubheaderfont">
				<b>
					<xsl:apply-templates/>
				</b>
			</font>
		</p>
	</xsl:template>
	<xsl:template name="SUBHEADER">
		<xsl:param name="text">?????</xsl:param>
		<p>
			<font xsl:use-attribute-sets="textsubheaderfont">
				<b>
					<xsl:value-of select="$text"/>
				</b>
			</font>
		</p>
	</xsl:template>
	<xsl:template match="HR | hr">
		<xsl:copy use-attribute-sets="nu_hr"/>
	</xsl:template>
	<xsl:template match="UL">
		<xsl:copy>
			<xsl:attribute name="TYPE">SQUARE</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="TD">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<font xsl:use-attribute-sets="textfont">
				<xsl:apply-templates select="*|text()"/>
			</font>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="TH">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<font xsl:use-attribute-sets="textsubheaderfont">
				<xsl:apply-templates select="*|text()"/>
			</font>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="A[ancestor::BODY]">
		<a>
			<xsl:attribute name="class">pos</xsl:attribute>
			<!--<xsl:call-template name="dolinkattributes"/>-->
			<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|text()"/>
		</a>
	</xsl:template>
	<xsl:template match="INTRO">
		<xsl:if test="string-length(.) &gt; 0">
			<font xsl:use-attribute-sets="textfont">
				<b>
					<xsl:apply-templates/>
				</b>
			</font>
			<br/>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="WHO-IS-ONLINE">
		<a class="pos" onclick="popusers('{$root}online');return false;" href="{$root}online" target="_blank">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<!-- <xsl:template match="FOOTNOTE">
	<font xsl:use-attribute-sets="textfont">
		<a class="pos">
			<xsl:attribute name="TITLE"><xsl:call-template name="renderfootnotetext"/></xsl:attribute>
			<xsl:attribute name="NAME">back<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:attribute name="HREF">#footnote<xsl:value-of select="@INDEX"/></xsl:attribute>
			<sup><xsl:value-of select="@INDEX" /></sup>
		</a>
	</font>
</xsl:template> -->
	<!-- IL start -->
	<xsl:attribute-set name="mFOOTNOTE">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFOOTNOTE_display">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="asfFOOTNOTE_BottomText" use-attribute-sets="textfont">
</xsl:attribute-set>
	<xsl:attribute-set name="asfINDEX_FOOTNOTE" use-attribute-sets="textfont">
		<xsl:attribute name="color"/>
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<!-- IL end -->
	<!-- <xsl:template mode="display" match="FOOTNOTE">
	<font xsl:use-attribute-sets="textfont">
		<a class="pos">
			<xsl:attribute name="NAME">footnote<xsl:value-of select="@INDEX"/></xsl:attribute>
				<a class="pos">
					<xsl:attribute name="HREF">#back<xsl:value-of select="@INDEX"/></xsl:attribute>
					<sup><xsl:value-of select="@INDEX"/></sup>
				</a>
			<xsl:text> </xsl:text>
			<xsl:apply-templates />
		</a>
	</font>
	<br/>
</xsl:template> -->
	<xsl:template name="show-volunteers">
		<xsl:param name="group"/>
		<xsl:param name="groupname"/>
		<script language="javaScript">
			<xsl:comment>
			var <xsl:value-of select="$groupname"/>newwin="0";
			function go<xsl:value-of select="$groupname"/>(<xsl:value-of select="$groupname"/>newwin){
				<xsl:value-of select="$groupname"/>number=document.<xsl:value-of select="$groupname"/>list.<xsl:value-of select="$groupname"/>.options[document.<xsl:value-of select="$groupname"/>list.<xsl:value-of select="$groupname"/>.selectedIndex].value;
				if(<xsl:value-of select="$groupname"/>number!='0'){
					if(<xsl:value-of select="$groupname"/>newwin=="1")
					window.open('<xsl:value-of select="$root"/>U' + <xsl:value-of select="$groupname"/>number)
					else window.location.href='<xsl:value-of select="$root"/>U' + <xsl:value-of select="$groupname"/>number;
				}
			}
		// </xsl:comment>
		</script>
		<form name="{$groupname}list">
			<table cellspacing="2" cellpadding="3">
				<xsl:if test="TITLE">
					<tr>
						<td align="center">
							<xsl:value-of select="TITLE"/>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td align="center">
						<select name="{$groupname}">
							<xsl:attribute name="SIZE"><xsl:value-of select="@LENGTH"/></xsl:attribute>
							<option value="0">
								<xsl:choose>
									<xsl:when test="FIRSTITEM">
										<xsl:value-of select="FIRSTITEM"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$m_dropdownpleasechooseone"/>
									</xsl:otherwise>
								</xsl:choose>
							</option>
							<option value="0">-----------------</option>
							<xsl:for-each select="msxsl:node-set($group)/LISTITEM">
								<option value="{number(USER/USERID)}">
									<!-- <xsl:value-of select="substring(USER/USERNAME,1,20)"/>
									<xsl:if test="string-length(USER/USERNAME) &gt; 20">...</xsl:if> -->
									<xsl:apply-templates select="USER">
										<xsl:with-param name="stringlimit">20</xsl:with-param>
									</xsl:apply-templates>
								</option>
							</xsl:for-each>
						</select>
						<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
						<xsl:choose>
							<xsl:when test="@TYPE='command'">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>In:
						</xsl:when>
							<xsl:when test="@TYPE='new'">
								<input type="button" value="{$m_govolunteer}" ONCLICK="go{$groupname}(1)"/>
							</xsl:when>
							<xsl:when test="@TYPE='this'">
								<input type="button" value="{$m_govolunteer}" ONCLICK="go{$groupname}(0)"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="button" value="{$m_govolunteer}" ONCLICK="go{$groupname}({$groupname}newwin)"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:choose>
					<xsl:when test="@TYPE='command'">
						<tr>
							<td align="left">
								<input type="button" value="{$m_thiswindow}" ONCLICK="go{$groupname}(0)"/>
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
								<input type="button" value="{$m_newwindow}" ONCLICK="go{$groupname}(1)"/>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td>
								<font xsl:use-attribute-sets="smallfont" class="postxt">
									<input name="win" type="radio" value="0" checked="1" ONCLICK="{$groupname}newwin='0';"/>
									<xsl:value-of select="$m_gadgetusethiswindow"/>
									<input name="win" type="radio" value="1" ONCLICK="{$groupname}newwin='1';"/>
									<xsl:value-of select="$m_gadgetusenewwindow"/>
								</font>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</table>
		</form>
	</xsl:template>
	<xsl:template match="ITEM-LIST">
		<SCRIPT LANGUAGE="javaScript">
			<xsl:comment>
var <xsl:value-of select="@NAME"/>newwin="0";
function go<xsl:value-of select="@NAME"/>(<xsl:value-of select="@NAME"/>newwin){
<xsl:value-of select="@NAME"/>number=document.<xsl:value-of select="@NAME"/>list.<xsl:value-of select="@NAME"/>.options[document.<xsl:value-of select="@NAME"/>list.<xsl:value-of select="@NAME"/>.selectedIndex].value;
if(<xsl:value-of select="@NAME"/>number!='0'){
if(<xsl:value-of select="@NAME"/>newwin=="1")
window.open(<xsl:value-of select="@NAME"/>number)
else window.location.href=<xsl:value-of select="@NAME"/>number;
}
}
// </xsl:comment>
		</SCRIPT>
		<form name="{@NAME}list">
			<table cellspacing="2" cellpadding="3">
				<xsl:if test="TITLE">
					<tr>
						<td align="center">
							<xsl:value-of select="TITLE"/>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td align="center">
						<SELECT name="{@NAME}">
							<xsl:attribute name="SIZE"><xsl:value-of select="@LENGTH"/></xsl:attribute>
							<OPTION value="0">
								<xsl:choose>
									<xsl:when test="FIRSTITEM">
										<xsl:value-of select="FIRSTITEM"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$m_dropdownpleasechooseone"/>
									</xsl:otherwise>
								</xsl:choose>
							</OPTION>
							<OPTION value="0">-----------------</OPTION>
							<xsl:for-each select="ITEM">
								<OPTION value="{@H2G2|@BIO|@HREF}">
									<xsl:value-of select="."/>
								</OPTION>
							</xsl:for-each>
						</SELECT>
						<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
						<xsl:choose>
							<xsl:when test="@TYPE='command'">
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>In:
						</xsl:when>
							<xsl:when test="@TYPE='new'">
								<input type="button" value="{$m_govolunteer}" ONCLICK="go{@NAME}(1)"/>
							</xsl:when>
							<xsl:when test="@TYPE='this'">
								<input type="button" value="{$m_govolunteer}" ONCLICK="go{@NAME}(0)"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="button" value="{$m_govolunteer}" ONCLICK="go{@NAME}({@NAME}newwin)"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:choose>
					<xsl:when test="@TYPE='command'">
						<tr>
							<td align="left">
								<input type="button" value="{$m_thiswindow}" ONCLICK="go{@NAME}(0)"/>
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
								<input type="button" value="{$m_newwindow}" ONCLICK="go{@NAME}(1)"/>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td>
								<font xsl:use-attribute-sets="smallfont" class="postxt">
									<input name="win" type="radio" value="0" checked="1" ONCLICK="{@NAME}newwin='0';"/>
									<xsl:value-of select="$m_gadgetusethiswindow"/>
									<input name="win" type="radio" value="1" ONCLICK="{@NAME}newwin='1';"/>
									<xsl:value-of select="$m_gadgetusenewwindow"/>
								</font>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</table>
		</form>
	</xsl:template>
	<xsl:template mode="DATE-ONLY" match="DATE">
		<xsl:choose>
			<xsl:when test="@RELATIVE">
				<xsl:value-of select="@RELATIVE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@DAYNAME"/>
				<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				<br/>
				<xsl:value-of select="number(@DAY)"/>
				<xsl:choose>
					<xsl:when test="number(@DAY) = 1 or number(@DAY) = 21 or number(@DAY) = 31">st</xsl:when>
					<xsl:when test="number(@DAY) = 2 or number(@DAY) = 22">nd</xsl:when>
					<xsl:when test="number(@DAY) = 3 or number(@DAY) = 23">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>
				<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				<xsl:value-of select="@MONTHNAME"/>
				<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				<xsl:value-of select="@YEAR"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template mode="CREATEDATE" match="DATE">
		<xsl:value-of select="number(@DAY)"/>
		<xsl:choose>
			<xsl:when test="number(@DAY) = 1 or number(@DAY) = 21 or number(@DAY) = 31">st</xsl:when>
			<xsl:when test="number(@DAY) = 2 or number(@DAY) = 22">nd</xsl:when>
			<xsl:when test="number(@DAY) = 3 or number(@DAY) = 23">rd</xsl:when>
			<xsl:otherwise>th</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@MONTHNAME"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@YEAR"/>
	</xsl:template>
	<!-- IL start -->
	<!--xsl:template name="register-mainerror">
<xsl:choose>
	<xsl:when test="@STATUS='NOLOGINNAME'">
	<xsl:value-of select="$m_invalidloginname"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='NOPASSWORD'">
	<xsl:value-of select="$m_invalidpassword"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='UNMATCHEDPASSWORDS'">
	<xsl:value-of select="$m_unmatchedpasswords"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='LOGINFAILED'">
	<xsl:value-of select="$m_loginfailed"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='LOGINUSED'">
	<xsl:value-of select="$m_loginused"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='NOTERMS'">
	<xsl:value-of select="$m_mustagreetoterms"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='HASHFAILED'">
	<xsl:value-of select="$m_problemwithreg"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='NOCONNECTION'">
	There is a problem with your login. It may be because you have no email 
	address set for your BBC account. The best way to fix this is to login 
	into <A CLASS="norm" HREF="http://www.bbc.co.uk/mybbc">myBBC</A> with your h2g2 details, 
	and to click on the 'my profile' link. Here you should enter an email address, 
	and then you should be able to log in to h2g2. If you still have problems, 
	please email the address below.
	<br/>
	</xsl:when>
	<xsl:when test="@STATUS='INVALIDPASSWORD'">
	<xsl:value-of select="$m_invalidbbcpassword"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='INVALIDUSERNAME'">
	<xsl:value-of select="$m_invalidbbcusername"/><br/>
	</xsl:when>
	<xsl:when test="@STATUS='INVALIDEMAIL'">
	The email address you supplied is invalid<br/>
	</xsl:when>
	<xsl:when test="@STATUS='UIDUSED'">
	<xsl:value-of select="$m_uidused"/><br/>
	</xsl:when>
</xsl:choose>
</xsl:template-->
	<!-- IL end -->
	<xsl:template name="insert-title">
		<xsl:choose>
			<xsl:when test="@TYPE='ARTICLE'">
				<xsl:call-template name="ARTICLE_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='REVIEWFORUM'">
				<xsl:call-template name="REVIEWFORUM_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='INDEX'">
				<xsl:call-template name="INDEX_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='USERPAGE'">
				<xsl:call-template name="USERPAGE_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='SEARCH'">
				<xsl:call-template name="SEARCH_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='NEWREGISTER'">
				<xsl:call-template name="NEWREGISTER_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='CATEGORY'">
				<xsl:call-template name="CATEGORY_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='LOGOUT'">
				<xsl:call-template name="LOGOUT_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='MORELINKS'">
				<xsl:call-template name="MORELINKS_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='MOREPOSTS'">
				<xsl:call-template name="MOREPOSTS_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='MOREPAGES'">
				<xsl:call-template name="MOREPAGES_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='JOURNAL'">
				<xsl:call-template name="JOURNAL_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='THREADS'">
				<xsl:call-template name="THREADS_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='MULTIPOSTS'">
				<xsl:call-template name="MULTIPOSTS_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='ADDTHREAD'">
				<xsl:call-template name="ADDTHREAD_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='USEREDIT'">
				<xsl:call-template name="USEREDIT_TITLE"/>
			</xsl:when>
			<xsl:when test="@TYPE='ADDJOURNAL'">
				<xsl:call-template name="ADDJOURNAL_TITLE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="DEFAULT_TITLE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="insert-titledata">
		<xsl:choose>
			<xsl:when test="@TYPE='ARTICLE'">
				<xsl:call-template name="ARTICLE_TITLEDATA"/>
			</xsl:when>
			<xsl:when test="@TYPE='FRONTPAGE'">
				<xsl:call-template name="FRONTPAGE_TITLEDATA"/>
			</xsl:when>
			<xsl:when test="@TYPE='USERPAGE'">
				<xsl:call-template name="USERPAGE_TITLEDATA"/>
			</xsl:when>
			<xsl:when test="@TYPE='CATEGORY'">
				<xsl:call-template name="CATEGORY_TITLEDATA"/>
			</xsl:when>
			<xsl:when test="@TYPE='JOURNAL'">
				<xsl:call-template name="JOURNAL_TITLEDATA"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="DEFAULT_TITLEDATA"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="insert-bar">
		<xsl:choose>
			<xsl:when test="@TYPE='ARTICLE'">
				<xsl:call-template name="ARTICLE_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='REVIEWFORUM'">
				<xsl:call-template name="REVIEWFORUM_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='INDEX'">
				<xsl:call-template name="INDEX_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='SEARCH'">
				<xsl:call-template name="SEARCH_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='NEWREGISTER'">
				<xsl:call-template name="NEWREGISTER_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='CATEGORY'">
				<xsl:call-template name="CATEGORY_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='EDITCATEGORY'">
				<xsl:call-template name="EDITCATEGORY_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='SUBSCRIBE'">
				<xsl:call-template name="SUBSCRIBE_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='LOGOUT'">
				<xsl:call-template name="LOGOUT_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='MORELINKS'">
				<xsl:call-template name="MORELINKS_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='MOREPOSTS'">
				<xsl:call-template name="MOREPOSTS_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='MOREPAGES'">
				<xsl:call-template name="MOREPAGES_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='THREADS'">
				<xsl:call-template name="THREADS_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='MULTIPOSTS'">
				<xsl:call-template name="MULTIPOSTS_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='ADDTHREAD'">
				<xsl:call-template name="ADDTHREAD_BAR"/>
			</xsl:when>
			<xsl:when test="@TYPE='USEREDIT'">
				<xsl:call-template name="USEREDIT_BAR"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="DEFAULT_TITLE">
		<title>
			<xsl:value-of select="$m_frontpagetitle"/>
		</title>
	</xsl:template>
	<xsl:template name="DEFAULT_TITLEDATA">
		<font xsl:use-attribute-sets="smallfont" color="{$colournorm}">
			<b>.</b>
		</font>
		<br clear="ALL"/>
		<img src="{$imagesource}t.gif" width="1" height="8" alt=""/>
		<br clear="ALL"/>
	</xsl:template>
	<xsl:variable name="colourword">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']/ARTICLE/GUIDE/BRUNEL/WORD">
				<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BRUNEL/WORD"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/WORD">
				<xsl:value-of select="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/WORD"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTICLE' and not(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE='9')">blue</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERPAGE' or /H2G2/@TYPE='ADDTHREAD' or /H2G2/@TYPE='EDITCATEGORY' or /H2G2/@TYPE='SUBMITREVIEWFORUM' or /H2G2/@TYPE='ADDJOURNAL' or /H2G2/@TYPE='JOURNAL' or /H2G2/@TYPE='USEREDIT' or /H2G2/@TYPE='USERDETAILS' or /H2G2/@TYPE='RECOMMEND-ENTRY' or /H2G2/@TYPE='THREADS' or /H2G2/@TYPE='MOREPOSTS' or /H2G2/@TYPE='MOREPAGES' or /H2G2/@TYPE='JOURNAL' or /H2G2/@TYPE='MULTIPOSTS'">green</xsl:when>
			<xsl:otherwise>red</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="colourlite">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']/ARTICLE/GUIDE/BRUNEL/LITE">
				<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BRUNEL/LITE"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/LITE">
				<xsl:value-of select="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/LITE"/>
			</xsl:when>
			<xsl:when test="$colourword='blue'">#66ccff</xsl:when>
			<xsl:when test="$colourword='green'">#33FF33</xsl:when>
			<xsl:otherwise>#ff3333</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="colournorm">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']/ARTICLE/GUIDE/BRUNEL/NORM">
				<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BRUNEL/NORM"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/NORM">
				<xsl:value-of select="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/NORM"/>
			</xsl:when>
			<xsl:when test="$colourword='blue'">#006699</xsl:when>
			<xsl:when test="$colourword='green'">#009900</xsl:when>
			<xsl:otherwise>#990000</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="colourdark">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']/ARTICLE/GUIDE/BRUNEL/DARK">
				<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BRUNEL/DARK"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/DARK">
				<xsl:value-of select="/H2G2[@TYPE='FRONTPAGE' or @TYPE='FRONTPAGE-EDITOR']/ARTICLE/FRONTPAGE/BRUNEL/DARK"/>
			</xsl:when>
			<xsl:when test="$colourword='blue'">#003366</xsl:when>
			<xsl:when test="$colourword='green'">#006611</xsl:when>
			<xsl:otherwise>#660000</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="toolbar_searchcolour">
		<xsl:value-of select="$colourdark"/>
	</xsl:variable>
	<xsl:template name="nuskin-header">
		<meta name="version" content="20020806"/>
		<meta name="robots" content="{$robotsetting}"/>
		<meta content="British Broadcasting Corporation" name="author"/>
		<meta content="h2g2 is the unconventional guide to life, the universe and everything, a guide that's written by visitors to the website, creating an organic and evolving encyclopedia of life" name="description"/>
		<meta content="h2g2,Hitchhiker's Guide to the Galaxy,Douglas Adams,DNA" name="keywords"/>
		<style type="text/css">
	</style>
    <style type="text/css" media="screen">
@import '/h2g2/skins/brunel/brunel.css';
</style>
		<script type="text/javascript" language="JavaScript">
			<xsl:comment>
		function popmailwin(x, y) {popupWin = window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');popupWin.focus();}
		function popusers(link) {popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');popupWin.focus();}
		function popupwindow(link, target, parameters) {popupWin = window.open(link,target,parameters);popupWin.focus();}
		//</xsl:comment>
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
		<xsl:if test="/H2G2[@TYPE='NEWREGISTER']/NEWREGISTER[@COMMAND='normal']">
			<xsl:call-template name="retain_register_details_JS"/>
		</xsl:if>
		<xsl:comment>#set var="bbcpage_bgcolor" value="ffffff" </xsl:comment>
		<xsl:comment>#set var="bbcpage_nav" value="yes" </xsl:comment>
		<xsl:comment>#set var="bbcpage_navwidth" value="120" </xsl:comment>
		<xsl:comment>#set var="bbcpage_navgraphic" value="yes" </xsl:comment>
		<xsl:comment>#set var="bbcpage_navgutter" value="no" </xsl:comment>
		<xsl:comment>#set var="bbcpage_contentwidth" value="100%" </xsl:comment>
		<xsl:comment>#set var="bbcpage_contentalign" value="left" </xsl:comment>
		<xsl:comment>#set var="bbcpage_language" value="english" </xsl:comment>
		<xsl:comment>#set var="bbcpage_searchcolour" value="990000" </xsl:comment>
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:comment>#set var="bbcpage_surveysite" value="h2g2" </xsl:comment>
			<xsl:comment>#set var="bbcpage_survey" value="yes"</xsl:comment>
		</xsl:if>
		<xsl:call-template name="toolbarcss"/>
	</xsl:template>
	<xsl:template name="nuskin-logobar">
		<xsl:param name="titledata"/>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
			<tr valign="top">
				<td width="121" bgcolor="#666666" background="{$imagesource}logo_bg.gif" rowspan="2">

				
					<table width="121" cellspacing="0" cellpadding="0" border="0" background="">
						<tr>
							<td colspan="3">
								<img src="{$imagesource}pixel_grey.gif" width="120" height="1" alt="" border="0"/>
							</td>
							<td>
								<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
							</td>
						</tr>
						<tr valign="top">
							<td width="1" bgcolor="#CCCCCC">
								<img src="{$imagesource}t.gif" width="1" height="101" alt=""/>
							</td>
							<td width="118">
								<table width="118" cellspacing="0" cellpadding="6" border="0">
									<tr>
										<td>
											<a href="{$root}">
												<img src="{$imagesource}h2g2_logo.gif" width="106" height="39" alt="h2g2" border="0" vspace="4"/>
											</a>
											<br clear="ALL"/>
										
												<xsl:call-template name="barley_topleft"/>
											
											
											<!--font xsl:use-attribute-sets="xsmallfont" color="#CCCCCC">
												<xsl:apply-templates mode="DATE-ONLY" select="/H2G2/DATE"/>
												<br/>
											</font>
											<a href="http://www.bbc.co.uk/cgi-bin/education/betsie/parser.pl" class="b">
												<font xsl:use-attribute-sets="xsmallfont">
													<xsl:value-of select="$m_barleytext"/>
												</font>
											</a-->
											
										</td>
									</tr>
								</table>
							</td>
							<td width="1" bgcolor="#CCCCCC">
								<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
							</td>
							<td width="1" bgcolor="#000000">
								<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
							</td>
						</tr>
					</table>
				</td>
				<td>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="/H2G2/@TYPE='USERPAGE'">
										<td width="100%">
											<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
												<tr valign="top">
													<td width="1">
														<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
													</td>
													<td width="14">
														<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
														<br clear="all"/>
														<img src="{$imagesource}t.gif" width="1" height="54" alt=""/>
														<br clear="all"/>
														<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
													</td>
													<td width="100%">
														<img src="{$imagesource}t.gif" width="409" height="8" alt=""/>
														<br clear="all"/>
														<xsl:copy-of select="$titledata"/>
														<xsl:call-template name="insert-subject"/>
														<!-- <br />
								<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER/GROUPS"/> -->
													</td>
													<td width="14">
														<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
														<br clear="all"/>
														<img src="{$imagesource}t.gif" width="1" height="54" alt=""/>
														<br clear="all"/>
														<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
													</td>
													<td width="1">
														<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
													</td>
												</tr>
											</table>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td width="100%">
											<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
												<tr valign="top">
													<td width="1">
														<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
													</td>
													<td width="14">
														<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
													</td>
													<td width="100%">
														<img src="{$imagesource}t.gif" width="397" height="8" alt=""/>
														<br clear="ALL"/>
														<xsl:copy-of select="$titledata"/>
														<xsl:call-template name="insert-subject"/>
													</td>
													<td width="12">
														<img src="{$imagesource}t.gif" width="12" height="80" alt=""/>
													</td>
													<td width="14">
														<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
													</td>
													<td width="1">
														<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
													</td>
												</tr>
											</table>
										</td>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<table width="200" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
									<tr valign="top">
										<td width="1" bgcolor="#000000">
											<img src="{$imagesource}t.gif" width="1" height="80" alt=""/>
										</td>
										<td width="14">
											<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
											<br clear="ALL"/>
											<img src="{$imagesource}t.gif" width="14" height="54" alt=""/>
											<br clear="ALL"/>
											<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
										</td>
										<td width="170">
											<table width="170" cellpadding="0" cellspacing="3" border="0">
												<form method="GET" action="{$root}Search" target="_top">
													<tr>
														<td colspan="2">
															<img src="{$imagesource}t.gif" width="164" height="1" alt=""/>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<font xsl:use-attribute-sets="smallfont">
																<b>SEARCH h2g2</b>
															</font>
														</td>
													</tr>
													<tr>
														<td width="124">
															<input type="text" name="searchstring" value="" title="Keywords to Search for" size="14" style="width:120;"/>
															<input type="hidden" name="searchtype" value="goosearch"/>
														</td>
														<td width="34">
															<input type="IMAGE" src="{$imagesource}go_{$colourword}.gif" name="go" value="Go" border="0" alt="Go"/>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<input type="checkbox" name="showapproved" value="1" checked="checked" />
															<font xsl:use-attribute-sets="smallfont">Edited Entries only</font>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<img src="{$imagesource}arrow.gif" width="3" height="5" border="0" hspace="3" vspace="1" name="dosearch" alt="Search h2g2" value="Search h2g2" title="Search the Guide"/>
															<font xsl:use-attribute-sets="smallfont">
																<a href="{$root}Search" class="norm">
																	<b>Advanced Search</b>
																</a>
															</font>
														</td>
													</tr>
												</form>
											</table>
										</td>
										<td width="14">
											<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
											<br clear="ALL"/>
											<img src="{$imagesource}t.gif" width="14" height="54" alt=""/>
											<br clear="ALL"/>
											<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
										</td>
										<td width="1" bgcolor="#000000">
											<img src="{$imagesource}t.gif" width="1" height="80" alt=""/>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="h2g2login">
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
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="/H2G2/@TYPE!='USERPAGE'">
					<tr>
						<td>
							<table width="121" cellspacing="0" cellpadding="0" border="0" background="{$imagesource}logo_bg.gif">
								<tr valign="top">
									<td width="1" bgcolor="#CCCCCC">
										<img src="{$imagesource}t.gif" width="1" height="21" alt=""/>
									</td>
									<td width="6" background="" bgcolor="#666666">
										<img src="{$imagesource}t.gif" width="6" height="1" alt=""/>
									</td>
									<td width="112" background="" bgcolor="#666666">
										<b>
											<xsl:call-template name="barley_homepage"/>
										</b>
										
										<!--a href="http://www.bbc.co.uk/" class="b">
											<font xsl:use-attribute-sets="mainfont">
												<b>
													<xsl:value-of select="$m_barleyhome"/>
												</b>
											</font>
										</a-->
									</td>
									<td width="1" bgcolor="#CCCCCC">
										<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
									</td>
									<td width="1" bgcolor="#000000" background="">
										<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
								<tr>
									<td>
										<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
											<tr>
												<td colspan="6" bgcolor="#000000">
													<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td colspan="5" bgcolor="{$colourlite}">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
												<td bgcolor="{$colourlite}" align="right">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
											</tr>
											<tr valign="middle">
												<td>
													<img src="{$imagesource}pixel_{$colourword}-light.gif" width="1" height="18" alt="" border="0"/>
												</td>
												<td>
													<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="6" hspace="5"/>
												</td>
												<td width="100%">
													<font xsl:use-attribute-sets="xsmallfont">The Guide to <a href="C72" class="norm">Life</a>, <a href="C73" class="norm">The Universe</a> and <a href="C74" class="norm">Everything</a>.</font>
												</td>
												<td>
													<img src="{$imagesource}bars_{$colourword}.gif" width="8" height="18" alt="" border="0" hspace="2"/>
												</td>
												<td align="center">
													<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="6" hspace="5"/>
												</td>
												<td align="right">
													<img src="{$imagesource}pixel_{$colourword}-light.gif" width="1" height="18" alt="" border="0"/>
												</td>
											</tr>
											<tr>
												<td colspan="5" bgcolor="{$colourlite}">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
												<td bgcolor="{$colourlite}" align="right">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
											</tr>
										</table>
									</td>
									<td width="200">
										<table width="200" cellspacing="0" cellpadding="0" border="0" bgcolor="{$colournorm}">
											<tr>
												<td rowspan="4" bgcolor="#000000" width="1">
													<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
												</td>
												<td colspan="6" bgcolor="#000000">
													<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td colspan="5" bgcolor="{$colourlite}">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
												<td bgcolor="{$colourlite}" align="right">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
											</tr>
											<tr>
												<td>
													<img src="{$imagesource}pixel_{$colourword}-light.gif" width="1" height="18" alt="" border="0"/>
												</td>
												<td width="100%">
													<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="6" hspace="5"/>
												</td>
												<td>
										
									</td>
												<td>
													<img src="{$imagesource}bars_{$colourword}.gif" width="8" height="18" alt="" border="0" hspace="2"/>
												</td>
												<td align="center">
													<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="6" hspace="5"/>
												</td>
												<td align="right">
													<img src="{$imagesource}pixel_{$colourword}-light.gif" width="1" height="18" alt="" border="0"/>
												</td>
											</tr>
											<tr>
												<td colspan="5" bgcolor="{$colourlite}">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
												<td bgcolor="{$colourlite}" align="right">
													<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</xsl:when>
			</xsl:choose>
		</table>
	</xsl:template>
	<xsl:template name="nuskin-username">
		<table width="198" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td width="1">
					<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
				</td>
				<td width="196">
					<img src="{$imagesource}t.gif" width="196" height="1" alt=""/>
				</td>
				<td width="1" align="right">
					<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
				</td>
			</tr>
			<tr valign="middle">
				<td bgcolor="#000000">
					<img src="{$imagesource}pixel_white.gif" width="1" height="18" alt="" border="0"/>
				</td>
				<td bgcolor="#000000">
					<font xsl:use-attribute-sets="xsmallfont" color="#FFFFFF">
						<xsl:choose>
							<xsl:when test="$registered=1">
								<xsl:call-template name="m_welcomebackuser"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
								<xsl:value-of select="$m_nologuser"/>
								<a href="Login" class="norm">
									<xsl:value-of select="$m_loginq"/>
								</a> : <a href="Register" class="norm">
									<xsl:value-of select="$m_signupq"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</font>
				</td>
				<td bgcolor="#000000" align="right">
					<img src="{$imagesource}pixel_white.gif" width="1" height="18" alt="" border="0"/>
				</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
				</td>
				<td>
					<img src="{$imagesource}t.gif" width="192" height="1" alt=""/>
				</td>
				<td align="right">
					<img src="{$imagesource}pixel_black.gif" width="1" height="1" alt="" border="0"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="nuskin-homelinkbar">
		<xsl:param name="barcolour">FFFFFF</xsl:param>
		<xsl:param name="bardata"/>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
			<tr valign="top">
				<td width="121" bgcolor="#666666" background="{$imagesource}logo_bg.gif">
					<xsl:choose>
						<xsl:when test="/H2G2/@TYPE='USERPAGE'">
							<table width="121" cellspacing="0" cellpadding="0" border="0" background="">
								<tr valign="top">
									<td width="1" bgcolor="#CCCCCC">
										<img src="{$imagesource}t.gif" width="1" height="48" alt=""/>
									</td>
									<td width="118">
										<table width="118" cellspacing="0" cellpadding="6" border="0">
											<tr>
												<td>
													<a href="http://www.bbc.co.uk/" class="b">
														<font xsl:use-attribute-sets="mainfont">
															<b>
																<xsl:value-of select="$m_barleyhome"/>
															</b>
														</font>
													</a>
												</td>
											</tr>
										</table>
									</td>
									<td width="1" bgcolor="#CCCCCC">
										<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
									</td>
									<td width="1" bgcolor="#000000">
										<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<table width="121" cellspacing="0" cellpadding="0" border="0" background="">
								<tr valign="top">
									<td width="1" bgcolor="#CCCCCC">
										<img src="{$imagesource}t.gif" width="1" height="33" alt=""/>
									</td>
									<td width="118">
										<table width="118" cellspacing="0" cellpadding="6" border="0">
											<tr>
												<td>	
										</td>
											</tr>
										</table>
									</td>
									<td width="1" bgcolor="#CCCCCC">
										<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
									</td>
									<td width="1" bgcolor="#000000">
										<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
							</table>
						</xsl:otherwise>
					</xsl:choose>
					<br clear="ALL"/>
					<img src="{$imagesource}t.gif" width="118" height="1" alt=""/>
				</td>
				<td width="100%">
					<xsl:attribute name="style">background:#<xsl:copy-of select="$barcolour"/></xsl:attribute>
					<xsl:copy-of select="$bardata"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	
  <xsl:template name="nuskin-navdata">
    <ul class="lhnav">
      <li>
        <a href="{$root}">
          <xsl:value-of select="$m_nav_home"/>
        </a>
      </li>
      <li>
        <a href="{$root}dontpanic-tour" class="nav">What is h2g2?</a>
      </li>
          <xsl:if test="$registered=1">
            <li>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$root"/>
                  <xsl:value-of select="$pageui_myhome"/>
                </xsl:attribute>
                <xsl:value-of select="$m_nav_perspace"/>
              </a>
            </li>
            <li>
              <a onclick="popupwindow('{$root}MP{/H2G2/VIEWING-USER/USER/USERID}?skip=&amp;show=&amp;s_type=pop&amp;s_upto=&amp;s_target=conversation','brunelnavconv','width=170,height=400,resizable=yes,scrollbars=yes');return false;" href="{$root}MP{/H2G2/VIEWING-USER/USER/USERID}?s_type=pop&amp;s_target=conversation">My Conversations</a>
            </li>
            <li>
            <a href="{$root}UserDetails">My Preferences</a>
      </li>
          </xsl:if>
      <li>
					<a onclick="popusers('{$root}online');return false;" href="{$root}online?thissite=1" target="_blank">
						<xsl:value-of select="$m_nav_who"/>
					</a>
      </li>
      <li>
        <a href="{$root}UserEdit">
          <xsl:attribute name="href">
            <xsl:call-template name="sso_useredit_signin">
              <xsl:with-param name="type" select="1"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Write an Entry</xsl:text>
        </a>
      </li>
      <xsl:if test="$registered=1">
        <li>
          <a href="{$root}PeerReview">
            <xsl:value-of select="$m_peerreview"/>
          </a>
        </li>
      </xsl:if>
      <li>
        <a href="{$root}Browse">Browse</a>
      </li>
      <li>
        <a href="{$root}Announcements">Announcements</a>
      </li>
      <li>
        <a href="{$root}Feedback">
          <xsl:value-of select="$m_nav_feedbk"/>
        </a>
      </li>
      <li>
        <a href="{$root}dontpanic">
          <xsl:value-of select="$m_nav_help"/>
        </a>
      </li>
      <li>
        <a href="{$root}feeds">RSS Feeds</a>
      </li>
    </ul>
	
	</xsl:template>
	<xsl:template name="nuskin-navholder">
		<td width="121" bgcolor="{$colournorm}">
			<xsl:if test="not(/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='REVIEWFORUM' or /H2G2/@TYPE='INDEX' or /H2G2/@TYPE='SEARCH' or /H2G2/@TYPE='NEWREGISTER' or /H2G2/@TYPE='CATEGORY' or /H2G2/@TYPE='SUBSCRIBE' or /H2G2/@TYPE='LOGOUT' or /H2G2/@TYPE='MOREPOSTS' or /H2G2/@TYPE='MOREPAGES' or /H2G2/@TYPE='THREADS' or /H2G2/@TYPE='MULTIPOSTS' or /H2G2/@TYPE='ADDTHREAD' or /H2G2/@TYPE='USEREDIT')">
				<xsl:choose>
					<xsl:when test="/H2G2/@TYPE='USERPAGE'">
						<table width="121" bgcolor="#666666" cellspacing="0" cellpadding="0" border="0" background="">
							<tr valign="top">
								<td width="1" bgcolor="#CCCCCC">
									<img src="{$imagesource}t.gif" width="1" height="68" alt=""/>
								</td>
								<td width="118">
									<table width="118" cellspacing="0" cellpadding="6" border="0">
										<tr>
											<td>
												<a href="http://www.bbc.co.uk/" class="b">
													<font xsl:use-attribute-sets="mainfont">
														<b>
															<xsl:value-of select="$m_barleyhome"/>
														</b>
													</font>
												</a>
											</td>
										</tr>
									</table>
								</td>
								<td width="1" bgcolor="#CCCCCC">
									<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table width="121" bgcolor="#666666" cellspacing="0" cellpadding="0" border="0" background="">
							<tr valign="top">
								<td width="1" bgcolor="#CCCCCC">
									<img src="{$imagesource}t.gif" width="1" height="53" alt=""/>
								</td>
								<td width="118">
									<table width="118" cellspacing="0" cellpadding="6" border="0">
										<tr>
											<td>	
										</td>
										</tr>
									</table>
								</td>
								<td width="1" bgcolor="#CCCCCC">
									<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
								</td>
								<td width="1" bgcolor="#000000">
									<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
								</td>
							</tr>
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<table width="121" cellspacing="0" cellpadding="0" border="0" background="">
				<tr>
					<td colspan="3">
						<img src="{$imagesource}pixel_grey.gif" width="120" height="1" alt="" border="0"/>
					</td>
					<td width="1" style="background:#000000" rowspan="5">
						<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
					</td>
				</tr>
				<tr valign="top">
					<td width="1" bgcolor="#CCCCCC">
						<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
					</td>
					<td width="118" bgcolor="#000000">
						<xsl:call-template name="nuskin-navdata"/>
					</td>
					<td width="1" bgcolor="#CCCCCC">
						<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<img src="{$imagesource}pixel_grey.gif" width="120" height="1" alt="" border="0"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<img src="{$imagesource}pixel_black.gif" width="120" height="1" alt="" border="0"/>
					</td>
				</tr>
				<tr>
					<td>
						<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
					</td>
					<td>
						<table width="118" cellspacing="0" cellpadding="5" border="0" background="">
							<tr>
								<td>
									<font xsl:use-attribute-sets="mainfont">
										<xsl:call-template name="barley_services"/>
										
										
										
										<!--a href="http://www.bbc.co.uk/feedback/" class="norm">
											<xsl:value-of select="$m_barleycontact"/>
										</a>
										<br/>
										<a href="http://www.bbc.co.uk/help/" class="norm">
											<xsl:value-of select="$m_barleyhelp"/>
										</a>
										<br/>
										<br/>
										<font size="1">
											<xsl:value-of select="$m_barleylikeq"/>
											<br/>
											<a onClick="popmailwin('http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer" class="norm">Send it to a friend!</a>
										</font-->
									</font>
								</td>
							</tr>
						</table>
					</td>
					<td>
						<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
					</td>
				</tr>
			</table>
		</td>
	</xsl:template>
	<xsl:template name="nuskin-dummynav">
		<td width="121" bgcolor="{$colournorm}">
			<img src="{$imagesource}t.gif" width="121" height="1" alt=""/>
		</td>
	</xsl:template>
	<xsl:template name="nuskin-footer">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
			<tr>
				<td width="121" bgcolor="{$colournorm}" rowspan="4">
					<img src="{$imagesource}t.gif" width="121" height="1" alt=""/>
				</td>
				<td>
					<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
				</td>
				<td width="1" bgcolor="#000000" rowspan="4">
					<img src="{$imagesource}t.gif" width="1" height="1" alt=""/>
				</td>
			</tr>
			<tr>
				<td bgcolor="{$colournorm}">
					<img src="{$imagesource}t.gif" width="639" height="1" alt=""/>
				</td>
			</tr>
			<tr valign="top">
				<td bgcolor="{$colourdark}">
					<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td align="left">
								<img src="{$imagesource}rivet_dk{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
							</td>
							<td align="right">
								<img src="{$imagesource}rivet_dk{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
							</td>
						</tr>
					</table>
					<table width="100%" cellspacing="0" cellpadding="14" border="0">
						<tr>
							<td>
								<xsl:call-template name="m_brunelpagebottomcomplaint"/>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td bgcolor="{$colourdark}">
					<img src="{$imagesource}t.gif" width="1" height="10" alt=""/>
				</td>
			</tr>
		</table>
		<script src="http://www.bbc.co.uk/includes/linktrack.js" type="text/javascript"/>
	</xsl:template>
	<xsl:template name="primary-template">
		<html>
			<head>
				<xsl:call-template name="insert-title"/>
				<xsl:call-template name="nuskin-header"/>
				<script type="text/javascript" src="/h2g2/skins/brunel/vescripts.js"/>
			</head>
			<body bgcolor="#000000" text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF" alink="#FFFFCC" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='ARTICLESEARCH'] and $use-maps=1">
						<xsl:attribute name="onload">
							ArticleSearchLoadMap(<xsl:value-of select="/H2G2/ARTICLESEARCH/@LATITUDE"/>,<xsl:value-of select="/H2G2/ARTICLESEARCH/@LONGITUDE"/>,12);return false;
						</xsl:attribute>						
					</xsl:when>
					<xsl:when test="/H2G2[@TYPE='MANAGEROUTE'] and $use-maps=1">
						<xsl:attribute name="onload">
							<xsl:choose>
								<xsl:when test="/H2G2/ROUTEPAGE/ROUTE/@ROUTEID!=0">
									ManageRouteLoadMap(<xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/LOCATIONS/LOCATION/LATITUDE"/>,<xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/LOCATIONS/LOCATION/LONGITUDE"/>,12);return false;
								</xsl:when>
								<xsl:otherwise>
									ManageRouteLoadMap(51.514, -0.229, 12);return false;
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="bbcitoolbar"/>
				<xsl:comment>Time taken: <xsl:value-of select="/H2G2/TIMEFORPAGE"/>
				</xsl:comment>
				<xsl:call-template name="nuskin-logobar">
					<xsl:with-param name="titledata">
						<xsl:call-template name="insert-titledata"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="insert-bar"/>
				<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;" bgcolor="#000000">
					<tr valign="top">
						<xsl:call-template name="nuskin-navholder"/>
						<xsl:choose>
							<xsl:when test="/H2G2[@TYPE='FRONTPAGE'] or /H2G2[@TYPE='FRONTPAGE-EDITOR'] or /H2G2[@TYPE='JOURNAL'] or /H2G2[@TYPE='ADDTHREAD'] or /H2G2[@TYPE='USEREDIT'] or /H2G2[@TYPE='ADDJOURNAL']">
								<xsl:call-template name="insert-mainbody"/>
								<xsl:call-template name="insert-sidebar"/>
							</xsl:when>
							<xsl:when test="/H2G2[@TYPE='ARTICLE'] or /H2G2[@TYPE='REVIEWFORUM'] or /H2G2[@TYPE='SIMPLEPAGE']/ARTICLE/GUIDE or /H2G2[@TYPE='INSPECT-USER']">
								<td width="100%" bgcolor="#000000">
									<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
										<tr>
											<td>
												<img src="{$imagesource}t.gif" width="639" height="1" alt=""/>
											</td>
										</tr>
									</table>
									<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
										<xsl:choose>
											<xsl:when test="/H2G2[@TYPE='INSPECT-USER']">
												<xsl:attribute name="style">background:#000000</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">postable</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<tr valign="top">
											<td width="100%">
												<xsl:call-template name="insert-mainbody"/>
											</td>
											<td width="200" background="{$imagesource}perspace/entrydata_bg.gif">
												<xsl:call-template name="insert-sidebar"/>
											</td>
										</tr>
									</table>
								</td>
							</xsl:when>
							<xsl:when test="/H2G2[@TYPE='INDEX'] or /H2G2[@TYPE='CATEGORY'] or /H2G2[@TYPE='THREADS'] or /H2G2[@TYPE='MULTIPOSTS'] or /H2G2[@TYPE='USERPAGE'] or /H2G2[@TYPE='NEWREGISTER'] or /H2G2[@TYPE='SEARCH'] or /H2G2[@TYPE='WATCHED-USERS']">
								<td width="100%" bgcolor="#000000">
									<xsl:call-template name="insert-mainbody"/>
									<xsl:call-template name="insert-sidebar"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td width="100%" bgcolor="#000000">
									<table width="100%" cellspacing="0" cellpadding="10" border="0" bgcolor="#000000">
										<tr>
											<td>
												<font xsl:use-attribute-sets="mainfont">
													<xsl:call-template name="insert-mainbody"/>
													<xsl:call-template name="insert-sidebar"/>
													<br/>
													<br/>
												</font>
											</td>
										</tr>
									</table>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</table>
				<xsl:if test="/H2G2[@TYPE='ARTICLE']">
					<xsl:call-template name="ARTICLE_MIDDLE"/>
				</xsl:if>
				<xsl:if test="/H2G2[@TYPE='USERPAGE']">
					<xsl:call-template name="USERPAGE_MIDDLE"/>
				</xsl:if>
				<xsl:if test="/H2G2[@TYPE='REVIEWFORUM']">
					<xsl:call-template name="REVIEWFORUM_MIDDLE"/>
				</xsl:if>
				<xsl:call-template name="nuskin-footer"/>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
					<xsl:comment>#if expr='$pulse_go = 1'</xsl:comment>
						<font size="2">
							<xsl:comment>#include virtual="/includes/blq/include/pulse/panel.sssi"</xsl:comment>
						</font>
					<xsl:comment>#endif</xsl:comment>
				</xsl:if>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="BOXHOLDER">
		<xsl:for-each select="BOX">
			<xsl:if test="position() mod 2 = 1">
				<xsl:variable name="pos">
					<xsl:value-of select="position()"/>
				</xsl:variable>
				<br clear="all"/>
				<table border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0" bgcolor="#000000">
					<tr>
						<td bgcolor="{$colournorm}">
							<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
						</td>
						<td bgcolor="{$colournorm}" width="50%">
							<b>
								<font size="1" face="{$buttonfont}" color="#FFFFFF">
									<xsl:value-of select="TITLE"/>
								</font>
							</b>
						</td>
						<td bgcolor="{$colournorm}" width="50%">
							<b>
								<font size="1" face="{$buttonfont}" color="#FFFFFF">
									<xsl:value-of select="../BOX[$pos+1]/TITLE"/>
								</font>
							</b>
						</td>
						<td bgcolor="{$colournorm}">
							<img src="{$imagesource}rivet_{$colourword}.gif" width="4" height="5" alt="" border="0" vspace="4" hspace="5"/>
						</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding="0" vspace="0" hspace="0" bgcolor="#000000">
					<tr>
						<td valign="top" align="left" width="50%" bgcolor="#000000" class="postable">
							<p>
								<br/>
								<font xsl:use-attribute-sets="mainfont" class="postxt">
									<xsl:apply-templates select="TEXT"/>
								</font>
							</p>
						</td>
						<td width="5" bgcolor="#000000" class="postable">
							<img src="{$imagesource}t.gif" width="5" height="1" alt=""/>
						</td>
						<td width="5" bgcolor="#000000" class="postable">
							<img src="{$imagesource}t.gif" width="5" height="1" alt=""/>
						</td>
						<td valign="top" align="left" width="50%" bgcolor="#000000" class="postable">
							<p>
								<br/>
								<font xsl:use-attribute-sets="mainfont" class="postxt">
									<xsl:apply-templates select="../BOX[$pos+1]/TEXT"/>
								</font>
							</p>
						</td>
					</tr>
				</table>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="CODE|PRE">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<font size="+1">
				<xsl:apply-templates select="*|text()"/>
			</font>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="WATCHED-USERS_MAINBODY">
		<xsl:apply-templates select="WATCHED-USER-POSTS" mode="navbuttons"/>
		<table width="100%" cellspacing="0" cellpadding="10" border="0" bgcolor="#000000">
			<xsl:if test="WATCHED-USER-POSTS">
				<xsl:attribute name="class">postable</xsl:attribute>
			</xsl:if>
			<tr>
				<td width="100%">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:if test="WATCHED-USER-POSTS">
							<xsl:attribute name="class">postxt</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="WATCH-USER-RESULT"/>
						<xsl:apply-templates select="WATCHED-USER-LIST"/>
						<xsl:apply-templates select="WATCHING-USER-LIST"/>
						<xsl:apply-templates select="WATCHED-USER-POSTS"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="WATCHED-USER-POSTS">
Here are the journal entries from the friends of <xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" />
		<xsl:text> </xsl:text>
		<br/>
		<xsl:apply-templates select="WATCHED-USER-POST"/>
		<xsl:if test="not(WATCHED-USER-POST)">
There are no entries to display<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="WATCHED-USER-POSTS" mode="navbuttons">
		<table width="100%" cellspacing="0" cellpadding="10" border="0" bgcolor="#000000">
			<tr>
				<td>
					<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tr valign="top">
							<td width="150">
								<xsl:if test="@SKIPTO &gt; 0 or @MORE = 1">
									<font xsl:use-attribute-sets="smallfont">
										<font xsl:use-attribute-sets="nullsmallfont">
											<xsl:call-template name="threadnavbuttons">
												<xsl:with-param name="URL">Watch</xsl:with-param>
												<xsl:with-param name="ID">
													<xsl:value-of select="@USERID"/>
												</xsl:with-param>
												<xsl:with-param name="ExtraParameters">&amp;full=1</xsl:with-param>
											</xsl:call-template>
										</font>
									</font>
								</xsl:if>
								<img src="{$imagesource}t.gif" width="150" height="1" alt=""/>
							</td>
							<td width="50%">
								<xsl:if test="@SKIPTO &gt; 0 or @MORE = 1">
									<xsl:call-template name="forumpostblocks">
										<xsl:with-param name="forum" select="@USERID"/>
										<xsl:with-param name="skip" select="0"/>
										<xsl:with-param name="show" select="@COUNT"/>
										<xsl:with-param name="total" select="@TOTAL"/>
										<xsl:with-param name="this" select="@SKIPTO"/>
										<xsl:with-param name="url">Watch</xsl:with-param>
										<xsl:with-param name="ExtraParameters">&amp;full=1</xsl:with-param>
										<xsl:with-param name="splitevery">800</xsl:with-param>
										<xsl:with-param name="objectname" select="'Entries '"/>
									</xsl:call-template>
								</xsl:if>
							</td>
							<td width="50%" valign="top" align="right">
								<font xsl:use-attribute-sets="nullsmallfont">
									<b>
										<a xsl:use-attribute-sets="mWATCH-USER-POSTS_Back" href="{$root}Watch{@USERID}">Friends List</a>
									</b>
								</font>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:attribute-set name="mUSER_WatchUserPosted">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mWATCH-USER-POSTS_Previous">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mWATCH-USER-POSTS_Next">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<!--<xsl:attribute-set name="mWATCH-USER-POSTS_Back"><xsl:attribute name="class">pos</xsl:attribute></xsl:attribute-set>-->
	<xsl:attribute-set name="mWATCH-USER-POSTS_Replies">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mWATCH-USER-POSTS_LastReply">
		<xsl:attribute name="class">pos</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="zzzzzzzzzzzSITEPREFERENCES" mode="UserDetailsForm">
		<TR>
			<TD align="RIGHT">
				<FONT xsl:use-attribute-sets="mainfont">
						Preference 1:
					</FONT>
			</TD>
			<TD>
				<FONT xsl:use-attribute-sets="mainfont">
					<input name="p_name" value="XYZZY" type="hidden"/>
					<input name="XYZZY" value="{XYZZY/@VALUE}" type="text"/>
				</FONT>
			</TD>
			<TD/>
		</TR>
	</xsl:template>
	<!-- The following can be moved to base as generic: -->
	<!-- 
Retaining input details instructions:
Insert retain_register_details_JS as Javascript on the register page
Add the hidden inputs retain_register_details_HI
to retain terms and conditions checkbox information insert the test check_terms_box under the t & c chockbox
 -->
	<!--
	<xsl:template name="retain_register_details_JS">
	Author:    Tom Whitehouse
	Purpose:	Creates the Javascript used for retaining form fields for an incorrect registration
	Call:		<xsl:call-template name="retain_register_details_JS">
-->
	<xsl:template name="retain_register_details_JS">
		<script language="JavaScript">
			<xsl:comment>//
				function postData() {
					document.register.s_registeremail.value = document.register.email.value;
			
					if (document.register.terms.checked) {
						document.register.s_tandc.value = 1;
					}
				}		
			//</xsl:comment>
		</script>
	</xsl:template>
	<!--
	<xsl:template name="retain_register_details_HI">
	Author:    Tom Whitehouse
	Purpose:	
	Call:		<xsl:call-template name="retain_register_details_HI">
-->
	<xsl:template name="retain_register_details_HI">
		<input type="hidden" name="s_registeremail"/>
		<input type="hidden" name="s_tandc"/>
	</xsl:template>
	<xsl:attribute-set name="iNEWREGISTER_Email">
		<xsl:attribute name="VALUE"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_registeremail']/VALUE"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="fNEWREGISTER">
		<xsl:attribute name="onsubmit">postData()</xsl:attribute>
		<xsl:attribute name="name">register</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template name="check_terms_box">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_tandc']/VALUE='1'">
			<xsl:attribute name="checked">checked</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:variable name="m_textonly">
		<font xsl:use-attribute-sets="xsmallfont">Text only</font>
	</xsl:variable>
	<xsl:attribute-set name="homepage_link">
		<xsl:attribute name="class">b</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="textonly_link">
		<xsl:attribute name="class">b</xsl:attribute>
		<xsl:attribute name="style"/>
	</xsl:attribute-set>
</xsl:stylesheet>
