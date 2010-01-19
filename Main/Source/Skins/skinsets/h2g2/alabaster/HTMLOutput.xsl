<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:fxslDefaultGT="f:fxslDefaultGT" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base.xsl"/>
	<xsl:import href="../../../base/text.xsl"/>
	<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO8859-1"/>
	<xsl:variable name="toolbar_searchcolour">#447777</xsl:variable>
	<xsl:variable name="root">/dna/h2g2/alabaster/</xsl:variable>
	<xsl:variable name="sso_assets_path">/h2g2/sso/h2g2_alabaster_resources</xsl:variable>
	<xsl:variable name="sso_serviceid_link">h2g2</xsl:variable>
	<xsl:variable name="frontpageurl">
		<xsl:value-of select="$root"/>
	</xsl:variable>
	<xsl:variable name="showtreegadget">
		<xsl:choose>
			<xsl:when test="number(/H2G2/VIEWING-USER/USER/USER-MODE) = 1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="imagesource">
		<xsl:value-of select="$foreignserver"/>/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="imagesource2">
		<xsl:value-of select="$foreignserver"/>/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="skingraphics">
		<xsl:value-of select="$imagesource"/>
	</xsl:variable>
	<xsl:variable name="smileysource">
		<xsl:value-of select="$imagesource"/>Smilies/</xsl:variable>
	<xsl:variable name="skinname">Alabaster</xsl:variable>
	<xsl:variable name="mainfontcolour">#000000</xsl:variable>
	<xsl:variable name="headercolour">#FF6600</xsl:variable>
	<xsl:variable name="bgcolour">#FFFFFF</xsl:variable>
	<xsl:variable name="alinkcolour">#66CC00</xsl:variable>
	<xsl:variable name="linkcolour">#009999</xsl:variable>
	<xsl:variable name="vlinkcolour">#004488</xsl:variable>
	<xsl:variable name="boxoutcolour">#CCFFFF</xsl:variable>
	<xsl:variable name="pullquotecolour">#BB3300</xsl:variable>
	<xsl:variable name="welcomecolour">black</xsl:variable>
	<!-- font details -->
	<xsl:variable name="fontsize">2</xsl:variable>
	<xsl:variable name="fontface">Arial, Helvetica, sans-serif</xsl:variable>
	<xsl:variable name="ftfontsize">2</xsl:variable>
	<xsl:variable name="bbcpage_variant"/>
	<!-- colours for links in forum threads page -->
	<!--
<xsl:variable name="ftfontcolour">#000000</xsl:variable>
<xsl:variable name="ftbgcolour">#99CCCC</xsl:variable>
<xsl:variable name="ftbgcolour2">#98BCCD</xsl:variable>
<xsl:variable name="ftbgcolourlight">#CCFFFF</xsl:variable>
<xsl:variable name="ftalinkcolour">#333333</xsl:variable>
<xsl:variable name="ftlinkcolour">#000000</xsl:variable>
<xsl:variable name="ftvlinkcolour">#883333</xsl:variable>
<xsl:variable name="ftcurrentcolour">#FF0000</xsl:variable>
<xsl:variable name="ftNewSubjectColour">#CC0000</xsl:variable>
-->
	<xsl:variable name="ftfontcolour">#000000</xsl:variable>
	<xsl:variable name="ftbgcolour">#99CCCC</xsl:variable>
	<xsl:variable name="ftbgcolour2">#99CCCC</xsl:variable>
	<xsl:variable name="ftbgcolourlight">#CCFFFF</xsl:variable>
	<xsl:variable name="ftalinkcolour">#333333</xsl:variable>
	<xsl:variable name="ftlinkcolour">#000000</xsl:variable>
	<xsl:variable name="ftvlinkcolour">#336666</xsl:variable>
	<xsl:variable name="ftcurrentcolour">#000000</xsl:variable>
	<xsl:variable name="ftCurrentBGColour">#99CCCC</xsl:variable>
	<xsl:variable name="ftNewSubjectColour">#000000</xsl:variable>
	<xsl:variable name="forumsourcelink">#FF6600</xsl:variable>
	<xsl:variable name="catboxbg">#CCFFFF</xsl:variable>
	<xsl:variable name="catboxlinecolour">
		<xsl:value-of select="$catboxbg"/>
	</xsl:variable>
	<xsl:variable name="catboxmain">black</xsl:variable>
	<xsl:variable name="catboxtitle">#006600</xsl:variable>
	<xsl:variable name="catboxsublink">
		<xsl:value-of select="$linkcolour"/>
	</xsl:variable>
	<xsl:variable name="catboxotherlink">
		<xsl:value-of select="$linkcolour"/>
	</xsl:variable>
	<xsl:variable name="catfontheadersize">5</xsl:variable>
	<xsl:variable name="catfontheadercolour">black</xsl:variable>
	<xsl:attribute-set name="mENTRYLINK_UI" use-attribute-sets="mainfont">
		<xsl:attribute name="size">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSERLINK_UI" use-attribute-sets="mainfont">
		<xsl:attribute name="size">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mEXTERNALLINK_BBCSitesUI" use-attribute-sets="mainfont">
		<xsl:attribute name="size">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mEXTERNALLINK_NONBBCSitesUI" use-attribute-sets="mainfont">
		<xsl:attribute name="size">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="catboxsublink">
		<xsl:attribute name="font"><xsl:value-of select="$fontface"/></xsl:attribute>
		<xsl:attribute name="size">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nUserEditMasthead" use-attribute-sets="linkatt">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('EditPage','','<xsl:value-of select="$imagesource"/>buttons/editpage_ro.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="maForumID_AddThread" use-attribute-sets="linkatt">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('Image1','','<xsl:value-of select="$imagesource"/>buttons/discussthis_ro.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nPeopleTalking" use-attribute-sets="mainfont">
		<xsl:attribute name="size">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSERID_UserName_Name" use-attribute-sets="forumposted">
		<xsl:attribute name="color"><xsl:value-of select="$headercolour"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="nClickAddJournal">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('addjourn','','<xsl:value-of select="$imagesource"/>buttons/addjournal_ro.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="maPOSTID_DiscussJournalEntry">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
	</xsl:attribute-set>
	<!--xsl:attribute-set name="fNEWREGISTER">
	<xsl:attribute name="onsubmit">postData()</xsl:attribute>
</xsl:attribute-set-->
	<!-- colour of the [3 members] bit on categorisation pages -->
	<xsl:variable name="memberscolour">black</xsl:variable>
	<!-- colour of an empty category -->
	<xsl:variable name="emptycatcolour"/>
	<!-- colour of an full category -->
	<xsl:variable name="fullcatcolour"/>
	<!-- colour of an article in a category -->
	<xsl:variable name="catarticlecolour"/>
	<!-- Categorisation styles -->
	<xsl:variable name="catdecoration">underline ! important</xsl:variable>
	<xsl:variable name="catcolour"/>
	<xsl:variable name="artdecoration">underline ! important</xsl:variable>
	<xsl:variable name="artcolour"/>
	<xsl:variable name="hovcatdecoration">underline ! important</xsl:variable>
	<xsl:variable name="hovcatcolour"/>
	<xsl:variable name="hovartdecoration">underline ! important</xsl:variable>
	<xsl:variable name="hovartcolour"/>
	<!--
<xsl:attribute-set name="ArticleEditLinkAttr">
Author:		Igor Loboda
Purpose:	Used to specify attributes for <A> tag for Edit Entry link
-->
	<xsl:attribute-set name="ArticleEditLinkAttr" use-attribute-sets="linkatt">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('EditPage','','<xsl:value-of select="$imagesource"/>buttons/editentry_ro.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mH2G2ID_RemoveSelf" use-attribute-sets="linkatt">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('RemoveSelf','','<xsl:value-of select="$imagesource"/>buttons/remove_my_name_ro.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<!--
<xsl:attribute-set name="RetToEditorsLinkAttr">
Author:		Igor Loboda
Purpose:	Used to specify attributes for <A> tag for Return to Editors link
-->
	<xsl:attribute-set name="RetToEditorsLinkAttr" use-attribute-sets="linkatt">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('ReturnToEditors','','<xsl:value-of select="$imagesource"/>buttons/returntoeditors_ro.gif',1)</xsl:attribute>
		<xsl:attribute name="onClick">popupwindow('<xsl:value-of select="/H2G2/PAGEUI/ENTRY-SUBBED/@LINKHINT"/>','SubbedEntry','resizable=1,scrollbars=1,width=375,height=300');return false;</xsl:attribute>
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
	<xsl:attribute-set name="maFORUMID_THREADS_MAINBODY">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('NewConversation','','<xsl:value-of select="$imagesource"/>buttons/newconversation_ro.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:variable name="m_friendsblockdivider"/>
	<xsl:variable name="subbadges">
		<GROUPBADGE NAME="SUBS">
			<a href="{$root}SubEditors">
				<img border="0" SRC="{$imagesource}n_subeditor.gif" width="75" height="166"/>
			</a>
			<br/>
		</GROUPBADGE>
		<GROUPBADGE NAME="ACES">
			<a href="{$root}Aces">
				<img border="0" SRC="{$imagesource}n_ace.gif" width="75" height="166"/>
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
			<a href="{$root}SectionHeads">
				<img border="0" SRC="{$imagesource}section_head.gif" />
			</a>
			<br/>
		</GROUPBADGE>
		<GROUPBADGE NAME="GURUS">
			<a href="{$root}Gurus">
				<img border="0" src="{$imagesource}n_guru.gif" width="75" height="166"/>
			</a>
			<br/>
		</GROUPBADGE>
		<GROUPBADGE NAME="SCOUTS">
			<a href="{$root}Scouts">
				<img border="0" SRC="{$imagesource}n_scout.gif" width="75" height="166"/>
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
				<img border="0" src="{$imagesource}w_translator1.gif" width="51" height="113"/>
			</a>
			<br/>
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
		<GROUPBADGE NAME="FORMERSTAFF">
			<img border="0" src="{$imagesource}n_formerstaff.gif" width="75" height="166"/>
			<br/>
		</GROUPBADGE>
		<GROUPBADGE NAME="BBCTESTER">
			<img border="0" src="{$imagesource}n_bbctester.gif" width="75" height="166"/>
			<br/>
		</GROUPBADGE>
    <GROUPBADGE NAME="SCAVENGER">
      <a href="{$root}Scavengers">
        <img border="0" src="{$imagesource}n_scavenger.gif" alt="scavenger" width="75" height="166"/>
      </a>
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
	<xsl:variable name="m_replytothispost">
		<br/>
		<img src="{$imagesource}buttons/reply.gif" border="0" alt="{$alt_reply}"/>
	</xsl:variable>
	<!--
	template: <H2G2>
	This is the primary match for all H2G2 elements, unless one of the specific
	matches on the TYPE attribute catch it first. This is the main template
	for general pages, and has a lot of conditional stuff which might be
	better off in a more specialised stylesheet.
-->
	<xsl:template name="primary-template">
		<html>
			<!-- do the HEAD part of the HTML including all JavaScript and other meta stuff -->
			<xsl:call-template name="insert-header"/>
			<!--
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">h2g2 : <xsl:value-of select="ARTICLE/SUBJECT"/> : A<xsl:value-of select="ARTICLE/ARTICLEINFO/H2G2ID"/></xsl:with-param>
		</xsl:apply-templates>
		-->
			<body xsl:use-attribute-sets="mainbodytag" onLoad="MM_preloadImages('{$imagesource}logo_ro.gif', '{$imagesource}regnav/frontpage_ro.gif', '{$imagesource}regnav/frontpage2_ro.gif','{$imagesource}buttons/editentry_ro.gif','{$imagesource}regnav/preferences_ro.gif','{$imagesource}buttons/reply_ro.gif','{$imagesource}regnav/help_ro.gif','{$imagesource}regnav/read_ro.gif','{$imagesource}regnav/talk_ro.gif','{$imagesource}regnav/contribute_ro.gif','{$imagesource}regnav/feedback_ro.gif','{$imagesource}regnav/whosonline_ro.gif','{$imagesource}regnav/shop_ro.gif','{$imagesource}regnav/logout_ro.gif','{$imagesource}regnav/aboutus_ro.gif','{$imagesource}regnav/register_ro.gif','{$imagesource}regnav/myspace_ro.gif')">
				<xsl:call-template name="bbcitoolbar"/>
				<xsl:comment>Time taken: <xsl:value-of select="/H2G2/TIMEFORPAGE"/>
				</xsl:comment>
				<font xsl:use-attribute-sets="mainfont">
					<!-- do the top navigation bar -->
					<xsl:apply-templates mode="TopNavigationBar" select="."/>
					<!-- start of entire article (subject, body, forum, entry data) -->
					<table width="100%" cellpadding="2" cellspacing="2" border="0">
						<tr valign="top">
							<td>
								<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr valign="top">
										<xsl:call-template name="insert-strapline"/>
									</tr>
									<tr valign="top">
										<td rowspan="2">&nbsp;</td>
										<td rowspan="2">
											<xsl:call-template name="insert-leftcol"/>
										</td>
										<td rowspan="2">
											<table cellpadding="0" cellspacing="0" border="0" width="100%">
												<tr>
													<td width="5" rowspan="2">
														<img src="{$imagesource}blank.gif" width="5" height="1"/>
													</td>
													<td valign="top">
														<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL and /H2G2[@TYPE='ARTICLE']">
															<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="articlepage"/>
															<br/>
														</xsl:if>
														<!-- do the subject heading -->
														<xsl:call-template name="insert-subject"/>
														<!--
												<xsl:call-template name="SUBJECTHEADER">
													<xsl:with-param name="text"><xsl:value-of select="ARTICLE/SUBJECT"/></xsl:with-param>
												</xsl:call-template>
												-->
													</td>
													<td width="5" rowspan="2">
														<img src="{$imagesource}blank.gif" width="5" height="1"/>
													</td>
												</tr>
												<!-- end of article subject -->
												<!-- start of article content -->
												<tr>
													<td>
														<font xsl:use-attribute-sets="mainfont">
															<xsl:comment>start.mainbody</xsl:comment>
															<xsl:call-template name="insert-mainbody"/>
															<xsl:comment>end.mainbody</xsl:comment>
														</font>
													</td>
												</tr>
											</table>
										</td>
										<!-- do entry data sidebar -->
										<td width="180" valign="top">
											<img src="{$imagesource}blank.gif" width="180" height="1"/>
											<br/>
											<xsl:call-template name="insert-sidebar"/>
											<!--<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO"/>-->
										</td>
										<!-- end of entry data sidebar -->
									</tr>
									<tr>
										<td width="180" valign="bottom">
											<img src="{$imagesource}blank.gif" width="180" height="1"/>
											<br/>
											<xsl:call-template name="insert-bottomsidebar"/>
											<!--<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO"/>-->
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!-- end of entire article (subject, body, forum, entry data) -->
					<!-- do the bottom navigation bar -->
					<xsl:call-template name="BottomNavigationBar"/>
					<!-- place the complaints text and link -->
					<p align="center">
						<xsl:call-template name="m_pagebottomcomplaint"/>
					</p>
					<!-- do the copyright notice -->
					<!--xsl:call-template name="CopyrightNotice"/-->
					<xsl:call-template name="barley_footer"/>
				</font>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
					<xsl:comment>#if expr="$pulse_go = 1" </xsl:comment>
					<font size="2">
						<xsl:comment>#include virtual="/includes/blq/include/pulse/panel.sssi"</xsl:comment>
					</font>
					<xsl:comment>#endif </xsl:comment>
				</xsl:if>
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
	<xsl:template match="CRUMBTRAIL" mode="string">
		<xsl:for-each select="ANCESTOR/NAME">
			<xsl:value-of select="."/>
		</xsl:for-each>
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
	<!--
<xsl:template match="H2G2[@TYPE='SUBSCRIBE']">
<xsl:call-template name="popsubscribe"/>
</xsl:template>
-->
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
		<table width="100%" cellpadding="3" cellspacing="0" border="0">
			<tr>
				<td colspan="2">
					<div align="left" class="browse">
						<p class="browse">
							<font size="2" face="Arial, Helvetica, sans-serif">
								<b>
									<font size="3">
										<xsl:value-of select="$m_userdata"/>
									</font>
									<br/>
									<font size="1">
										<br/>
										<xsl:value-of select="$m_researcher"/>
									</font>
									<xsl:text> </xsl:text>
								</b>
								<font size="1">
									<xsl:value-of select="USER/USERID"/>
								</font>
								<b>
									<font size="1">
										<br/>
									</font>
									<font size="1">
										<xsl:value-of select="$m_namecolon"/>
										<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="showonline">
											<xsl:with-param name="symbol">
												<img src="{$imagesource}online.gif" alt="Online Now"/>
											</xsl:with-param>
										</xsl:apply-templates>
										<xsl:value-of select="USER/USERNAME"/>
									</font>
								</b>
								<b>
									<font size="1">
										<br/>
									</font>
									<!-- put in a link to InspectUser for editors -->
									<xsl:if test="$test_IsEditor">
										<font face="{$fontface}" size="1">
											<xsl:apply-templates select="USER/USERID" mode="Inspect"/>
											<br/>
											<a href="{$root}ModerationHistory?h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Moderation History</a>
											<br/>
										</font>
									</xsl:if>
									
									
									<font size="1">
										<img src="{$imagesource}tiny.gif" alt="" width="1" height="11"/>
										<xsl:choose>
											<xsl:when test="msxsl:node-set($lastpostbyusersort)/DATE">
												<xsl:value-of select="$m_myconvslastposted"/>
												<xsl:value-of select="$lastpostbyuser"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:copy-of select="$m_norecentpostings"/>
											</xsl:otherwise>
										</xsl:choose>
										<br/>
									</font>
									<xsl:if test="$test_CanEditMasthead">
										<font size="1">
											<br/>
											<nobr>
												<xsl:call-template name="UserEditMasthead">
													<xsl:with-param name="img">
														<img src="{$imagesource}buttons/editpage.gif" width="64" height="15" hspace="0" vspace="0" border="0" name="EditPage" alt="{$alt_editthispage}"/>
													</xsl:with-param>
												</xsl:call-template>
												<br/>
											</nobr>
											<br/>
										</font>
									</xsl:if>
									<xsl:if test="$ownerisviewer=0 and $registered=1">
										<a href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}">
										Add to Friends
									</a>
									</xsl:if>
								</b>
							</font>
						</p>
					</div>
				</td>
			</tr>
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
		<html>
			<HEAD>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<title>h2g2</title>
				<script language="JavaScript"><![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

// stop hiding -->
			]]></script>
				<STYLE type="text/css">
					<xsl:comment>
	DIV.browse A {  text-decoration: none; color: black}
	DIV.browse A:hover   { text-decoration: underline ! important; color: blue}
	DIV.number A {  text-decoration: underline; color: #006666}
	DIV.browsenoline A { text-decoration: none }
	</xsl:comment>
				</STYLE>
			</HEAD>
			<body onLoad="MM_preloadImages('{$imagesource}buttons/newconversation_ro.gif','{$imagesource}buttons/arrowleft_ro_blue.gif','{$imagesource}buttons/arrowright_ro_blue.gif','{$imagesource}buttons/arrowbegin_ro_blue.gif','{$imagesource}buttons/arrowend_ro_blue.gif')" bgcolor="{$ftbgcolourlight}" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" link="{$ftlinkcolour}" vlink="{$ftvlinkcolour}" alink="{$ftalinkcolour}">
				<FONT color="black" face="{$fontface}" size="{$ftfontsize}">
					<div align="center">
						<a name="conversations">
							<b>
								<xsl:value-of select="$m_otherconv"/>
							</b>
						</a>
					</div>
					<xsl:apply-templates select="FORUMTHREADS"/>
					<!--				<br />
				<xsl:if test="FORUMTHREADS/@MORE">
						<A>
							<xsl:attribute name="HREF">/FFO<xsl:value-of select="FORUMTHREADS/@FORUMID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADS/@SKIPTO) + number(FORUMTHREADS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT" /></xsl:attribute>
								Click here for more conversations
						</A>
						<br />
				</xsl:if>
				<xsl:if test="FORUMTHREADS[@SKIPTO > 0]">
					<A>
						<xsl:attribute name="HREF">/FFO<xsl:value-of select="FORUMTHREADS/@FORUMID" />&amp;skip=<xsl:value-of select='number(FORUMTHREADS/@SKIPTO) - number(FORUMTHREADS/@COUNT)' />&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT" /></xsl:attribute>
						Click here for more recent conversations
					</A>
					<br />
				</xsl:if>
-->
					<!--xsl:call-template name="newconversationbutton"/-->
					<xsl:if test="$test_AllowNewConversationBtn">
						<xsl:apply-templates select="FORUMTHREADS/@FORUMID" mode="THREADS_MAINBODY_UI"/>
					</xsl:if>
				</FONT>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="m_notforreviewbutton">
		<FONT xsl:use-attribute-sets="mainfont" size="1">
			<b>
				<xsl:value-of select="$alt_notforreview"/>
			</b>
		</FONT>
	</xsl:template>
	<xsl:template name="m_submitforreviewbutton">
		<img src="{$imagesource}buttons/submit_for_review.gif" border="0" name="SubmitToReviewForum" alt="{$alt_submittoreviewforum}">
			<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
			<xsl:attribute name="onMouseOver">MM_swapImage('SubmitToReviewForum','','<xsl:value-of select="$imagesource"/>buttons/submit_for_review_ro.gif',1)</xsl:attribute>
		</img>
	</xsl:template>
	<xsl:template name="m_recommendentrybutton">
		<img src="{$imagesource}buttons/recommendentry.gif" width="99" height="15" hspace="0" vspace="0" border="0" name="RecommendEntry" alt="{$alt_recommendthisentry}">
			<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
			<xsl:attribute name="onMouseOver">MM_swapImage('RecommendEntry','','<xsl:value-of select="$imagesource"/>buttons/recommendentry_ro.gif',1)</xsl:attribute>
		</img>
	</xsl:template>
	<xsl:template match="@FORUMID" mode="THREADS_MAINBODY_UI">
		<p align="center">
		&nbsp;
		<xsl:apply-templates select="." mode="THREADS_MAINBODY">
				<xsl:with-param name="img">
					<img src="{$imagesource}buttons/newconversation.gif" border="0" name="NewConversation" alt="{$alt_newconversation}"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</p>
		<br/>
	</xsl:template>
	<xsl:template match='H2G2[@TYPE="FRAMESOURCE"]'>
		<html>
			<title>h2g2</title>
			<body bgcolor="{$bgcolour}" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
				<!--		<FONT face="arial, helvetica, sans-serif" SIZE="2">-->
				<xsl:apply-templates select="FORUMSOURCE"/>
				<!--		</FONT>-->
			</body>
		</html>
	</xsl:template>
	<xsl:template match='H2G2[@TYPE="FRAMETHREADS"]'>
		<html>
			<HEAD>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<TITLE>h2g2</TITLE>
				<script language="JavaScript"><![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

// stop hiding -->
			]]></script>
				<STYLE type="text/css">
					<xsl:comment>
	DIV.browse A {  text-decoration: none; color: black}
	DIV.browse A:hover   { text-decoration: underline ! important; color: blue}
	DIV.number A {  text-decoration: underline; color: #006666}
	DIV.browsenoline A { text-decoration: none }
	</xsl:comment>
				</STYLE>
			</HEAD>
			<body onLoad="MM_preloadImages('{$imagesource}buttons/newconversation_ro.gif','{$imagesource}buttons/arrowleft_ro_blue.gif','{$imagesource}buttons/arrowright_ro_blue.gif','{$imagesource}buttons/arrowbegin_ro_blue.gif','{$imagesource}buttons/arrowend_ro_blue.gif')" bgcolor="{$ftbgcolourlight}" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" link="{$ftlinkcolour}" vlink="{$ftvlinkcolour}" alink="{$ftalinkcolour}">
				<!--		<body bgcolor="#000066" text="#CCFFFF" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0"  link="#FFFF66" vlink="#FF9900" alink="#FFFF99">-->
				<!--<DIV align="center"><FONT color="black" face="arial, helvetica, sans-serif" size="2"> 
						<xsl:choose>
							<xsl:when test="FORUMTHREADS/@JOURNALOWNER">
								<xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
									<A>
										<xsl:attribute name="HREF">/AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
										<xsl:attribute name="TARGET">_top</xsl:attribute>
										<img src="{$imagesource}buttons/newconversation.gif" border="0" alt="Click here to start a new conversation" vspace="3"/>
									</A>
									<br/>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
									<A>
										<xsl:attribute name="HREF">/AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
										<xsl:attribute name="TARGET">_top</xsl:attribute>
										<img src="{$imagesource}buttons/newconversation.gif" border="0" alt="Click here to start a new conversation" vspace="3"/>
									</A>
									<br/>
							</xsl:otherwise>
						</xsl:choose>
[ <A href="#conversations">view other conversations</A> ]</FONT> </DIV>-->
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="SUBSCRIBE-RESULT"/>
					<div align="center">
						<font color="#003333" face="arial, helvetica, sans-serif" size="2">
							<b>
								<xsl:value-of select="$m_currentconv"/>
							</b>
						</font>
					</div>
					<!-- the older/oldest/newer/newest navigation -->
					<xsl:variable name="Skip">
						<xsl:value-of select="FORUMTHREADHEADERS/@SKIPTO"/>
					</xsl:variable>
					<xsl:variable name="Show">20</xsl:variable>
					<xsl:variable name="PostRange">
						<xsl:value-of select="number($Skip)+1"/>-<xsl:value-of select="number($Skip) + number($Show)"/>
					</xsl:variable>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<img src="{$imagesource}blank.gif" width="1" height="2"/>
							</td>
						</tr>
						<tr>
							<td align="center">
								<xsl:call-template name="messagenavbuttons"/>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$imagesource}blank.gif" width="1" height="2"/>
							</td>
						</tr>
						<tr>
							<td align="center" valign="top">
								<xsl:call-template name="forumpostblocks">
									<xsl:with-param name="thread" select="FORUMTHREADHEADERS/@THREADID"/>
									<xsl:with-param name="forum" select="FORUMTHREADHEADERS/@FORUMID"/>
									<xsl:with-param name="skip" select="0"/>
									<xsl:with-param name="show" select="FORUMTHREADHEADERS/@COUNT"/>
									<xsl:with-param name="total" select="FORUMTHREADHEADERS/@TOTALPOSTCOUNT"/>
									<xsl:with-param name="this" select="FORUMTHREADHEADERS/@SKIPTO"/>
									<xsl:with-param name="url">F</xsl:with-param>
									<xsl:with-param name="splitevery">400</xsl:with-param>
									<xsl:with-param name="objectname">
										<xsl:value-of select="$m_postings"/>
									</xsl:with-param>
									<xsl:with-param name="target">_top</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<img src="{$imagesource}blank.gif" width="1" height="3"/>
							</td>
						</tr>
					</table>
					<!-- the older/oldest navigation 
<xsl:if test="FORUMTHREADHEADERS[@SKIPTO > 0]">
  <TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#99cccc" bordercolorlight="#000000" bordercolordark="#000000">
    <TR align="center" bgcolor="#006666"> 
      <TD nowrap="1" colspan="4"><A 
href="/FLR{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip=0&amp;show={FORUMTHREADHEADERS/@COUNT}" 
target="twosides"><IMG src="{$imagesource}blank.gif" width="80" height="20" border="0" alt="Show Start of Conversation"/><IMG alt="Show Start of Conversation" border="0" 
src="{$imagesource}buttons/rewind.gif" width="20" height="18" hspace="0" vspace="2"/><IMG src="{$imagesource}blank.gif" width="80" height="20" border="0" alt="Show Start of Conversation"/></A></TD>
    </TR>
    <TR align="left"> 
      <TD nowrap="1" bgcolor="#FFFFFF" colspan="4"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
    </TR>
    <TR align="center" bgcolor="#4A9797"> 
      <TD nowrap="1" colspan="4"> <A 
href="/FLR{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip={number(FORUMTHREADHEADERS/@SKIPTO)-number(FORUMTHREADHEADERS/@COUNT)}&amp;show={FORUMTHREADHEADERS/@COUNT}"
target="twosides"><IMG src="{$imagesource}blank.gif" width="81" height="18" border="0" alt="Show Older Postings"/><IMG alt="Show Older Postings" border="0" 
src="{$imagesource}buttons/reverse.gif" width="19" height="12" vspace="3"/><IMG src="{$imagesource}blank.gif" width="80" height="18" border="0" alt="Show Older Postings"/></A></TD>
    </TR>
   
  </TABLE>  
</xsl:if>
end of older/oldest navigation -->
					<font color="black" face="arial, helvetica, sans-serif" size="2">
						<xsl:choose>
							<xsl:when test="FORUMTHREADS">
								<xsl:apply-templates mode="many" select="FORUMTHREADHEADERS"/>
								<!-- the newer/newest navigation 
<xsl:if test="FORUMTHREADHEADERS[@MORE > 0]">
  <TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#99cccc" bordercolorlight="#000000" bordercolordark="#000000">
    <TR align="center" bgcolor="#4A9797"> 
      <TD nowrap="1" colspan="4"> <A 
href="/FLR{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;skip={number(FORUMTHREADHEADERS/@SKIPTO)+number(FORUMTHREADHEADERS/@COUNT)}&amp;show={FORUMTHREADHEADERS/@COUNT}"
target="twosides"><IMG src="{$imagesource}blank.gif" width="81" height="18" border="0" alt="Show Newer Postings"/><IMG alt="Show Newer Postings" border="0" 
src="{$imagesource}buttons/play.gif" width="19" height="12" vspace="3"/><IMG src="{$imagesource}blank.gif" width="80" height="18" border="0" alt="Show Newer Postings"/></A></TD>
    </TR>
    <TR align="left"> 
      <TD nowrap="1" bgcolor="#FFFFFF" colspan="4"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
    </TR>
    <TR align="center" bgcolor="#006666"> 
      <TD nowrap="1" colspan="4"><A 
href="/FLR{FORUMTHREADHEADERS/@FORUMID}?thread={FORUMTHREADHEADERS/@THREADID}&amp;latest=1" 
target="twosides"><IMG src="{$imagesource}blank.gif" width="80" height="20" border="0" alt="Show Latest Postings"/><IMG alt="Show Latest Postings" border="0" 
src="{$imagesource}buttons/fforward.gif" width="20" height="18" hspace="0" vspace="2"/><IMG src="{$imagesource}blank.gif" width="80" height="20" border="0" alt="Show Latest Postings"/></A></TD>
    </TR>
    <TR align="left"> 
      <TD nowrap="1" bgcolor="#FFFFFF" colspan="4"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
    </TR>
   
  </TABLE>
</xsl:if>
end of newer/newest navigation -->
								<br/>
								<div align="center">
									<font color="black" face="arial, helvetica, sans-serif" size="2">
										<xsl:choose>
											<xsl:when test="FORUMTHREADS/@JOURNALOWNER">
												<xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
													<a onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('NewConversation','','{$imagesource}buttons/newconversation_ro.gif',1)">
														<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/></xsl:attribute>
														<xsl:attribute name="TARGET">_top</xsl:attribute>
														<img src="{$imagesource}buttons/newconversation.gif" border="0" alt="{$alt_newconversation}" name="NewConversation"/>
													</a>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<a onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('NewConversation','','{$imagesource}buttons/newconversation_ro.gif',1)">
													<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/></xsl:attribute>
													<xsl:attribute name="TARGET">_top</xsl:attribute>
													<img src="{$imagesource}buttons/newconversation.gif" border="0" alt="{$alt_newconversation}" name="NewConversation"/>
												</a>
											</xsl:otherwise>
										</xsl:choose>
										<br/>
										<br/>
										<xsl:call-template name="subscribethread"/>
										<hr/>
										<a name="conversations">
											<b>
												<xsl:value-of select="$m_otherconv"/>
											</b>
										</a>
									</font>
								</div>
								<xsl:apply-templates select="FORUMTHREADS"/>
							</xsl:when>
						</xsl:choose>
						<!-- start of new conversation button -->
						<xsl:choose>
							<xsl:when test="FORUMTHREADS/@JOURNALOWNER">
								<xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
									<p align="center">
									&nbsp;
									<a onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('NewConversation2','','{$imagesource}buttons/newconversation_ro.gif',1)">
											<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/></xsl:attribute>
											<xsl:attribute name="TARGET">_top</xsl:attribute>
											<img src="{$imagesource}buttons/newconversation.gif" border="0" name="NewConversation2" alt="{$alt_newconversation}"/>
										</a>
									</p>
									<br/>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<p align="center">
								&nbsp;
								<a onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('NewConversation2','','{$imagesource}buttons/newconversation_ro.gif',1)">
										<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID"/></xsl:attribute>
										<xsl:attribute name="TARGET">_top</xsl:attribute>
										<img src="{$imagesource}buttons/newconversation.gif" border="0" name="NewConversation2" alt="{$alt_newconversation}"/>
									</a>
								</p>
								<br/>
							</xsl:otherwise>
						</xsl:choose>
						<!-- end of new conversation button -->
						<DIV ALIGN="CENTER">
							<xsl:call-template name="subscribeforum"/>
						</DIV>
					</font>
				</font>
			</body>
		</html>
	</xsl:template>
	<xsl:attribute-set name="as_skiptobeginning">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('ArrowBegin1','','<xsl:value-of select="$imagesource"/>buttons/arrowbegin_ro_blue.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="as_skiptoprevious">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('ArrowLeft1','','<xsl:value-of select="$imagesource"/>buttons/arrowleft_ro_blue.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="as_skiptonext">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('ArrowRight1','','<xsl:value-of select="$imagesource"/>buttons/arrowright_ro_blue.gif',1)</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="as_skiptoend">
		<xsl:attribute name="onMouseOut">MM_swapImgRestore()</xsl:attribute>
		<xsl:attribute name="onMouseOver">MM_swapImage('ArrowEnd1','','<xsl:value-of select="$imagesource"/>buttons/arrowend_ro_blue.gif',1)</xsl:attribute>
	</xsl:attribute-set>
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
		<xsl:apply-templates select="FORUMTHREADHEADERS/@SKIPTO | FORUMTHREADPOSTS/@SKIPTO" mode="navbuttons">
			<xsl:with-param name="URL" select="'F'"/>
			<xsl:with-param name="skiptobeginning">
				<img src="{$imagesource}buttons/arrowbegin_blue.gif" width="18" height="15" border="0" alt="{$alt_showoldest}" name="ArrowBegin1"/>
			</xsl:with-param>
			<xsl:with-param name="skiptoprevious">
				<img src="{$imagesource}buttons/arrowleft_blue.gif" width="18" height="15" border="0" name="ArrowLeft1" alt="{$prevrange}"/>
			</xsl:with-param>
			<xsl:with-param name="skiptobeginningfaded">
				<img src="{$imagesource}buttons/arrowbegin_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_atstartofconv}"/>
			</xsl:with-param>
			<xsl:with-param name="skiptopreviousfaded">
				<img src="{$imagesource}buttons/arrowleft_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_noolderpost}"/>
			</xsl:with-param>
			<xsl:with-param name="skiptonext">
				<img src="{$imagesource}buttons/arrowright_blue.gif" width="18" height="15" border="0" name="ArrowRight1" alt="{$nextrange}"/>
			</xsl:with-param>
			<xsl:with-param name="skiptoend">
				<img src="{$imagesource}buttons/arrowend_blue.gif" width="18" height="15" border="0" alt="{$alt_showlatestpost}" name="ArrowEnd1"/>
			</xsl:with-param>
			<xsl:with-param name="skiptonextfaded">
				<img src="{$imagesource}buttons/arrowright_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_nonewerpost}"/>
			</xsl:with-param>
			<xsl:with-param name="skiptoendfaded">
				<img src="{$imagesource}buttons/arrowend_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_alreadyendconv}"/>
			</xsl:with-param>
			<xsl:with-param name="attributes">
				<attribute name="target" value="_top"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<br/>
	</xsl:template>
	<xsl:template match='H2G2[@TYPE="ONLINE"]'>
		<xsl:apply-templates select="ONLINEUSERS"/>
	</xsl:template>
	<!--
	template for messageframe => this is the frame on the right of a
	forum page that displays the actual contents of the posts
-->
	<xsl:template match='H2G2[@TYPE="MESSAGEFRAME"]'>
		<html>
			<head>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<title>h2g2</title>
				<script language="JavaScript"><![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
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

function popusers(link)
{
	popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
}

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

// stop hiding -->
			]]></script>
				<STYLE type="text/css">
					<xsl:comment>
DIV.browse A {  text-decoration: none}
</xsl:comment>
				</STYLE>
			</head>
			<body bgcolor="{$bgcolour}" onLoad="MM_preloadImages('{$imagesource}buttons/arrowup_ro_blue.gif','{$imagesource}buttons/arrowdown_ro_blue.gif','{$imagesource}buttons/reply_ro.gif')" leftmargin="2" topmargin="0" marginwidth="0" marginheight="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
				<!--		<body bgcolor="#000066" text="#FFFFFF" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="#FFFF66" vlink="#FF9900" alink="#FFFF99">-->
				<font face="arial, helvetica, sans-serif" size="2">
					<!--
				<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#99cccc" bordercolorlight="#000000" bordercolordark="#000000">
  <TR align="left" bgcolor="#006666"> 
    <TD nowrap="1"> 
      <DIV align="center" class="browse"><A 
href="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip=0&amp;show={FORUMTHREADPOSTS/@COUNT}" 
target="twosides"><IMG src="{$imagesource}blank.gif" width="141" height="14" border="0" alt="Show Start of Conversation" align="absmiddle" vspace="0" hspace="0"/><IMG alt="Show Start of Conversation" border="0" 
src="{$imagesource}buttons/rewind.gif" width="20" height="18" hspace="0" vspace="1" align="absmiddle"/> 
        <IMG src="{$imagesource}blank.gif" width="140" height="14" border="0" alt="Show Start of Conversation" align="absmiddle" hspace="0" vspace="0"/><FONT size="1" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><BR/>
        jump to start of conversation</FONT></A></DIV>
    </TD>
  </TR>
  <TR align="left"> 
    <TD nowrap="1" bgcolor="#FFFFFF"><IMG src="FFM615_files/blank.gif" width="1" height="1"/></TD>
  </TR>
  <TR align="left" bgcolor="#4A9797"> 
    <TD nowrap="1"> 
      <DIV align="center" class="browse"><A 
href="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" 
target="twosides"><IMG src="{$imagesource}blank.gif" width="110" height="12" border="0" align="absmiddle" alt="Show Older Postings"/><IMG alt="Show Older Postings" border="0" 
src="{$imagesource}buttons/reverse.gif" width="19" height="12" vspace="3" align="absmiddle"/><IMG src="{$imagesource}blank.gif" width="110" height="12" border="0" align="absmiddle" alt="Show Older Postings"/> 
        <FONT size="1" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><BR/>
        earlier posts</FONT></A></DIV>
    </TD>
  </TR>
  <TBODY> </TBODY> 
</TABLE>
				</xsl:if>
-->
					<xsl:apply-templates select="FORUMTHREADPOSTS">
						<xsl:with-param name="ptype" select="'frame'"/>
					</xsl:apply-templates>
					<!--
<xsl:if test="FORUMTHREADPOSTS/@MORE">
<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#99cccc" bordercolorlight="#000000" bordercolordark="#000000">
  <TR align="left" bgcolor="#4A9797"> 
    <TD nowrap="1"> 
      <DIV align="center" class="browse"><A 
href="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;skip={number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)}&amp;show={FORUMTHREADPOSTS/@COUNT}" 
target="twosides"><IMG src="{$imagesource}blank.gif" width="110" height="12" border="0" align="absmiddle" alt="Show Newer Postings"/><IMG alt="Show Newer Postings" border="0" 
src="{$imagesource}buttons/play.gif" width="19" height="12" vspace="3" align="absmiddle"/><IMG src="{$imagesource}blank.gif" width="110" height="12" border="0" align="absmiddle" alt="Show Newer Postings"/> 
        <FONT size="1" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><BR/>
        later posts</FONT></A></DIV>
    </TD>
  </TR>
  <TR align="left"> 
    <TD nowrap="1" bgcolor="#FFFFFF"><IMG src="FFM615_files/blank.gif" width="1" height="1"/></TD>
  </TR>
  <TR align="left" bgcolor="#006666"> 
    <TD nowrap="1"> 
      <DIV align="center" class="browse"><A 
href="/FLR{FORUMTHREADPOSTS/@FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}&amp;latest=1" 
target="twosides"><IMG src="{$imagesource}blank.gif" width="141" height="14" border="0" alt="Show Latest Postings" align="absmiddle" vspace="0" hspace="0"/><IMG alt="Show Latest Postings" border="0" 
src="{$imagesource}buttons/fforward.gif" width="20" height="18" hspace="0" vspace="1" align="absmiddle"/> 
        <IMG src="{$imagesource}blank.gif" width="140" height="14" border="0" alt="Show Latest Postings" align="absmiddle" hspace="0" vspace="0"/><FONT size="1" color="#FFFFFF" face="Arial, Helvetica, sans-serif"><BR/>
        jump to most recent posts</FONT></A></DIV>
    </TD>
  </TR>
</TABLE>
</xsl:if>
-->
					<br/>
					<br/>
					<br/>
					<xsl:call-template name="m_forumpostingsdisclaimer"/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
					<br/>
				</font>
			</body>
		</html>
	</xsl:template>
	<!--
	template: <H2G2 TYPE="FORUMFRAME">
	This template calls the FORUMFRAME template to create the frameset
-->
	<xsl:template match='H2G2[@TYPE="FORUMFRAME"]'>
		<html>
			<HEAD>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<TITLE>
					<xsl:value-of select="$m_forumtitle"/>
				</TITLE>
			</HEAD>
			<xsl:apply-templates select="FORUMFRAME"/>
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
	<!--
	this skin does not need the left hand buttons frame
	TODO: there must be a better/more general way of specifying these frames?
-->
	<xsl:template match="FORUMFRAME">
		<FRAMESET ROWS="173,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="0">
			<FRAME>
				<xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFU<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;post=<xsl:value-of select="@POST"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/></xsl:attribute>
				<xsl:attribute name="NAME">toprow</xsl:attribute>
				<xsl:attribute name="MARGINHEIGHT">0</xsl:attribute>
				<xsl:attribute name="MARGINWIDTH">0</xsl:attribute>
				<xsl:attribute name="LEFTMARGIN">0</xsl:attribute>
				<xsl:attribute name="TOPMARGIN">0</xsl:attribute>
				<xsl:attribute name="SCROLLING">no</xsl:attribute>
			</FRAME>
			<FRAMESET ROWS="25,100%">
				<FRAME>
					<xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFS<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;post=<xsl:value-of select="@POST"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/></xsl:attribute>
					<xsl:attribute name="SCROLLING">no</xsl:attribute>
				</FRAME>
				<FRAME>
					<xsl:attribute name="SRC"><xsl:value-of select="$root"/>FLR<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;<xsl:if test="@POST &gt; 0">post=<xsl:value-of select="@POST"/>&amp;</xsl:if>skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/></xsl:attribute>
					<xsl:attribute name="NAME">twosides</xsl:attribute>
					<xsl:attribute name="ID">twosides</xsl:attribute>
				</FRAME>
			</FRAMESET>
		</FRAMESET>
	</xsl:template>
	<xsl:template match="FORUMFRAME[@SUBSET='TWOSIDES']">
		<FRAMESET COLS="35%,65%">
			<FRAME SCROLLING="YES">
				<xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFT<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;<xsl:if test="@POST &gt; 0">post=<xsl:value-of select="@POST"/>&amp;</xsl:if>skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/></xsl:attribute>
				<xsl:attribute name="NAME">threads</xsl:attribute>
				<xsl:attribute name="ID">threads</xsl:attribute>
			</FRAME>
			<FRAME>
				<xsl:attribute name="SRC"><xsl:value-of select="$root"/>FFM<xsl:value-of select="@FORUM"/>?thread=<xsl:value-of select="@THREAD"/>&amp;<!--<xsl:if test=".[@POST &gt; 0]">post=<xsl:value-of select="@POST" />&amp;</xsl:if>-->skip=<xsl:value-of select="@SKIP"/>&amp;show=<xsl:value-of select="@SHOW"/>#p<xsl:value-of select="@POST"/></xsl:attribute>
				<xsl:attribute name="NAME">messages</xsl:attribute>
				<xsl:attribute name="ID">frmmess</xsl:attribute>
			</FRAME>
		</FRAMESET>
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
			<title>
				<xsl:value-of select="$title"/>
			</title>
			<script language="JavaScript"><![CDATA[
<!-- hide this script from non-javascript-enabled browsers

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
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

function popusers(link)
{
	popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
}

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

function popmailwin(x, y) {popupWin = window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');popupWin.focus();}
// stop hiding -->
			]]></script>
			<script type="text/javascript" language="JavaScript">
				<xsl:comment>//
				function confirm_logout() {
					if (confirm('<xsl:value-of select="$m_confirmlogout"/>')) {
						window.location = '<xsl:value-of select="$root"/>Logout';
					}
				}
		
			//</xsl:comment>
			</script>
			<!--xsl:if test="/H2G2[@TYPE='NEWREGISTER']/NEWREGISTER[@COMMAND='normal']">
			<xsl:call-template name="retain_register_details_JS"/>
		</xsl:if-->
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
		  <xsl:comment>#set var="bbcpage_survey" value="yes" </xsl:comment>
			<xsl:comment>#set var="bbcpage_surveysite" value="h2g2" </xsl:comment>
		</xsl:if>
		<xsl:call-template name="toolbarcss"/>
			<style type="text/css">
				<xsl:comment>
DIV.bannerbar a {   color: #CCFFFF}
DIV.browse a { color: #006666}
DIV.top5bar a {  color: #006666}

DIV.ModerationTools A { color: blue}
DIV.ModerationTools A.active { color: red}
DIV.ModerationTools A.visited { color: darkblue}
DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
			</xsl:comment>
			</style>
		</head>
	</xsl:template>
	<xsl:template mode="TopNavigationBar" match="H2G2">
		<!-- start of top navigation bar -->
		<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
			<xsl:comment> // hide from old browsers
function mainSites(x)
  { if (x != "") { top.location=x; } }
//</xsl:comment>
		</SCRIPT>
		<span class="browse"></span>
		<div class="bannerbar">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#669999">
				<tr>
					<td valign="top" rowspan="2">
						<a target="_top" href="{$root}">
							<img src="{$imagesource}logo.gif" name="h2g2logo" alt="{$alt_frontpage}" border="0"/>
						</a>
					</td>
					<td width="100%" valign="middle" bgcolor="#669999" align="top">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr bgcolor="#669999">
								<td valign="bottom" bgcolor="#669999">
									<!--<xsl:choose>
								<xsl:when test="//ADVERTS">
								<xsl:apply-templates select="//ADVERTS"/>
								</xsl:when>
								<xsl:otherwise>
								<a target="_top" href="adlink"><img src="smallad" width="200" height="60" vspace="7" hspace="0" border="0"/></a>
								</xsl:otherwise>
								</xsl:choose>
								-->
									<img src="{$imagesource}blank.gif" width="11" height="1" hspace="0"/>
									<xsl:apply-templates select="PAGEUI/BANNER[@NAME='main']"/>
									<br/>
									<img src="{$imagesource}blank.gif" width="680" height="1"/>
								</td>
							</tr>
							<tr bgcolor="#669999">
								<td valign="bottom">
							</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td valign="middle">
						<table width="100%">
							<tr>
								<!-- start of Guide browser -->
								<td nowrap="1" class="bannerbar">
									<img src="{$imagesource}blank.gif" width="11" height="1" hspace="0"/>
									<font size="1" face="Arial, Helvetica, sans-serif" color="#CCFFFF">
										<xsl:call-template name="m_lifelink"/>
												| <xsl:call-template name="m_universelink"/>
												| <xsl:call-template name="m_everythinglink"/> 
												| <xsl:call-template name="m_searchlink"/>
									</font>
								</td>
								<!-- end of Guide browser -->
								<!-- start of search form -->
								<form method="GET" action="{$root}Search" target="_top">
									<td nowrap="1" width="100%">
										<font face="Arial, Helvetica, sans-serif" size="2">
											<input type="text" name="searchstring" value="" title="{$alt_keywords}"/>
											<input type="hidden" name="searchtype" value="goosearch"/>
													&nbsp;
													<input type="submit" name="dosearch" value="{$alt_searchbutton}" title="{$alt_searchtheguide}"/>
											<!--													<input type="image" name="dosearch" value="Search" title="Search The Guide" src="{$imagesource}buttons/search.gif"/>-->
										</font>
									</td>
								</form>
								<!-- end of search form -->
							</tr>
						</table>
					</td>
				</tr>
				<!--			<tr> 
				<td colspan="2" background="{$imagesource}headerbar.gif"><img src="{$imagesource}headerbar.gif" width="1" height="4" border="0" vspace="0" hspace="0"/></td>
			</tr>
-->
				<TR>
					<td colspan="2">
						<img border="0" src="{$imagesource}blank.gif" width="1" height="5"/>
					</td>
				</TR>
				<tr>
					<xsl:call-template name="navbar">
						<xsl:with-param name="whichone">Top</xsl:with-param>
					</xsl:call-template>
				</tr>
			</table>
		</div>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
		<td rowspan="2" width="8"><img border="0" src="{$imagesource}blank.gif" width="8" height="1"/></td>
		<td><img border="0" src="{$imagesource}blank.gif" width="1" height="5"/></td>
		<td rowspan="2" width="4"><img border="0" src="{$imagesource}blank.gif" width="4" height="1"/></td>
		</tr>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
						<xsl:call-template name="sso_statusbar"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="identity_statusbar">
							<xsl:with-param name="h2g2class">id_alabaster</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		</table>
		<!-- end of top navigation bar -->
	</xsl:template>
	<xsl:template name="BottomNavigationBar">
		<!-- start of bottom navigation bar -->
		<br/>
		<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#669999">
			<tr>
				<xsl:call-template name="navbar">
					<xsl:with-param name="whichone">bottom</xsl:with-param>
				</xsl:call-template>
			</tr>
			<tr>
				<td colspan="2" background="{$imagesource}headerbar.gif">
					<img src="{$imagesource}headerbar.gif" width="1" height="4" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
		<!-- end of bottom navigation bar -->
	</xsl:template>
	<!--
	template for TOPFRAME - the frame at the top of the page in a forum
	listing which contains the navigation bar
-->
	<xsl:template match='H2G2[@TYPE="TOPFRAME"]'>
		<html>
			<!-- do the HEAD part of the HTML including all JavaScript and other meta stuff -->
			<xsl:apply-templates mode="header" select=".">
				<xsl:with-param name="title">
					<xsl:value-of select="$m_forumtitle"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<body bgcolor="{$bgcolour}" onLoad="MM_preloadImages('{$imagesource}logo_ro.gif', '{$imagesource}regnav/frontpage_ro.gif', '{$imagesource}regnav/frontpage2_ro.gif','{$imagesource}buttons/editentry_ro.gif','{$imagesource}regnav/preferences_ro.gif','{$imagesource}buttons/reply_ro.gif','{$imagesource}regnav/help_ro.gif','{$imagesource}regnav/read_ro.gif','{$imagesource}regnav/talk_ro.gif','{$imagesource}regnav/contribute_ro.gif','{$imagesource}regnav/feedback_ro.gif','{$imagesource}regnav/whosonline_ro.gif','{$imagesource}regnav/shop_ro.gif','{$imagesource}regnav/logout_ro.gif','{$imagesource}regnav/aboutus_ro.gif','{$imagesource}regnav/register_ro.gif','{$imagesource}regnav/myspace_ro.gif')" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
				<!--<META http-equiv="REFRESH" content="90"/>-->
				<!-- do the top navigation bar -->
				<xsl:call-template name="bbcitoolbar"/>
				<xsl:apply-templates mode="TopNavigationBar" select="."/>
				<P>&nbsp;</P>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="HEADER">
		<xsl:if test="@ANCHOR">
			<a name="{@ANCHOR}"/>
		</xsl:if>
		<!--	<br clear="all"/>-->
		<p>
			<font face="Arial, Helvetica, sans-serif" size="2">
				<b>
					<font color="{$headercolour}" size="4">
						<xsl:apply-templates/>
					</font>
					<!--			<font color="#FF6600" size="3"><br/></font>-->
				</b>
			</font>
			<!--	<br/>-->
		</p>
	</xsl:template>
	<!-- TODO: why are these two header templates so different in the goo? -->
	<xsl:template name="HEADER">
		<xsl:param name="text">?????</xsl:param>
		<!--	<br clear="all"/>-->
		<p>
			<font face="Arial, Helvetica, sans-serif" size="2">
				<b>
					<font color="{$headercolour}" size="4">
						<xsl:value-of select="$text"/>
					</font>
					<!--			<font color="#FF6600" size="3"><br/></font>-->
				</b>
			</font>
			<!--	<br/>-->
		</p>
	</xsl:template>
	<!--
	The subject/heading style used for article subjects
-->
	<xsl:template name="SUBJECTHEADER">
		<xsl:param name="text">?????</xsl:param>
		<font face="Arial, Helvetica, sans-serif" size="5" color="#006666">
			<b>
				<xsl:value-of select="$text"/>
			</b>
		</font>
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td background="{$imagesource}headerbar.gif" width="100%">
					<img src="{$imagesource}headerbar.gif" width="300" height="4"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	The style used for displaying the article body
-->
	<xsl:template match="GUIDE/BODY">
		<font face="Arial, Helvetica, sans-serif" size="2">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="SUBHEADER">
		<xsl:if test="@ANCHOR">
			<a name="{@ANCHOR}"/>
		</xsl:if>
		<p>
			<font face="Arial, Helvetica, sans-serif" size="2" color="{$headercolour}">
				<b>
					<xsl:apply-templates/>
				</b>
			</font>
		</p>
	</xsl:template>
	<xsl:template name="SUBHEADER">
		<xsl:param name="text">?????</xsl:param>
		<p>
			<font face="Arial, Helvetica, sans-serif" size="2" color="{$headercolour}">
				<b>
					<xsl:value-of select="$text"/>
				</b>
			</font>
		</p>
	</xsl:template>
	<xsl:template match="ARTICLEINFO">
		<!-- start of entry data sidebar -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5">
					<img width="5" height="5" src="{$imagesource}box_tl.gif" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_t.gif" width="100%">
					<img src="{$imagesource}box_t.gif" width="1" height="5" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_tr.gif" width="6" height="5" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
			<tr>
				<td background="{$imagesource}box_l.gif">
					<img src="{$imagesource}box_l.gif" width="5" height="1" border="0" vspace="0" hspace="0"/>
				</td>
				<td width="100%" bgcolor="#CCFFFF">
					<table width="100%" cellpadding="3" cellspacing="0" border="0">
						<tr>
							<td colspan="2">
								<div align="left" class="browse">
									<font size="2" face="Arial, Helvetica, sans-serif">
										<b>
											<font size="3">
												<xsl:value-of select="$m_entrydata"/>
											</font>
											<font size="1">
												<br/>
											</font>
										</b>
										<font size="1">
											<xsl:apply-templates select="H2G2ID" mode="notLinkTextBold"/>
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="STATUS/@TYPE"/>
											<b>
												<br/>
												<br/>
											</b>
										</font>
										<!-- do page authors -->
										<xsl:apply-templates select="PAGEAUTHOR"/>
										<!-- do entry date -->
										<br/>
										<br/>
										<font face="Arial, Helvetica, sans-serif" size="1">
											<xsl:call-template name="ArticleInfoDate"/>
										</font>
									</font>
									<xsl:if test="$test_IsEditor">
										<br/>
										<br/>
										<font size="1" face="Arial, Helvetica, sans-serif">
											<xsl:apply-templates select="H2G2ID" mode="CategoriseLink"/>
										</font>
									</xsl:if>
									<!-- Inser link to remove current user from
									the list of researcers -->
									<xsl:if test="$test_MayRemoveFromResearchers">
										<br/>
										<br/>
										<font size="1" face="Arial, Helvetica, sans-serif">
											<xsl:apply-templates select="H2G2ID" mode="RemoveSelf">
												<xsl:with-param name="img">
													<img src="{$imagesource}buttons/remove_my_name.gif" width="97" height="15" hspace="0" vspace="0" border="0" name="RemoveSelf" alt="{$alt_RemoveSelf}"/>
												</xsl:with-param>
											</xsl:apply-templates>
										</font>
									</xsl:if>
									<xsl:apply-templates select="SUBMITTABLE"/>
									<!-- put the edit page button in the side bar if specified in the page UI -->
									<xsl:if test="$test_ShowEditLink">
										<br/>
										<br/>
										<font size="1">
											<nobr>
												<xsl:apply-templates select="/H2G2/PAGEUI/EDITPAGE/@VISIBLE" mode="EditEntry">
													<xsl:with-param name="img">
														<img src="{$imagesource}buttons/editentry.gif" width="64" height="15" hspace="0" vspace="0" border="0" name="EditPage" alt="{$alt_editthisentry}"/>
													</xsl:with-param>
												</xsl:apply-templates>
											</nobr>
										</font>
									</xsl:if>
									<!-- put the recommend entry button in the side bar if the article knows it can be recommended or the user is an editor and the status is 3 -->
									<xsl:if test="not($ownerisviewer=1 and /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='SCOUTS')">
										<!-- don`t apply templates if the user is a scout and owns the article  -->
										<xsl:call-template name="RecommendEntry"/>
									</xsl:if>
									<!-- put the entry subbed button in the side bar if specified in the page UI -->
									<xsl:if test="$test_ShowEntrySubbedLink">
										<font size="1">
											<br/>
											<br/>
											<nobr>
												<xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="RetToEditors">
													<xsl:with-param name="img">
														<img src="{$imagesource}buttons/returntoeditors.gif" width="94" height="15" hspace="0" vspace="0" border="0" name="ReturnToEditors" alt="{$alt_thisentrysubbed}"/>
													</xsl:with-param>
												</xsl:apply-templates>
											</nobr>
										</font>
									</xsl:if>
									<br/>
									<br/>
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
									<!-- do references -->
									<xsl:apply-templates select="REFERENCES"/>
									<!-- put in the complaint text and link -->
									
									<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CREDITS[../../ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP/@NAME='Editor']"/>
									<br/>
									<br/>
									<xsl:call-template name="m_entrysidebarcomplaint"/>
								</div>
							</td>
						</tr>
					</table>
				</td>
				<td background="{$imagesource}box_r.gif">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}box_bl.gif" width="5" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_b.gif">
					<img src="{$imagesource}box_b.gif" width="1" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_br.gif" width="6" height="6" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="SUBJECT">
		<!--
	<table border="0" width="100%" cellspacing="0" cellpadding="0">
		<tr> 
			<td rowspan="3" align="right" width="13"><img src="http://www2.h2g2.com/images/layout/greencircle_L.gif" width="13" height="24"/></td>
			<td bgcolor="#cccccc" width="80%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
			<td bgcolor="#cccccc" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
		</tr>
		<tr> 
			<td bgcolor="#99cccc"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
			<td bgcolor="#99cccc" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
		</tr>
		<tr> 
			<td bgcolor="#006699"><font face="Arial, Helvetica, sans-serif" color="#ffffff"><b>
			<NOBR>
-->
		<xsl:value-of select="."/>
		<!--
			</NOBR>
			</b></font></td>
			<td width="100%"><img src="http://www2.h2g2.com/images/layout/wave1.gif" width="48" height="22"/></td>
		</tr>
	</table>
-->
	</xsl:template>
	<!--
<xsl:template name="SUBJECT">
<xsl:param name="subject">abcde</xsl:param>
     <table border="0" width="100%" cellspacing="0" cellpadding="0">
         <tr> 
          <td rowspan="3" align="right" width="13"><img src="http://www2.h2g2.com/images/layout/greencircle_L.gif" width="13" height="24"/></td>
          <td bgcolor="#cccccc" width="80%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="#cccccc" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td bgcolor="#99cccc"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
          <td bgcolor="#99cccc" width="100%"><img src="{$imagesource}blank.gif" width="1" height="1"/></td>
        </tr>
        <tr> 
          <td bgcolor="#006699"><font face="Arial, Helvetica, sans-serif" color="#ffff00" size="4"><b>
<xsl:value-of select="$subject"/>
</b></font></td>
          <td width="100%"><img src="http://www2.h2g2.com/images/layout/wave1.gif" width="48" height="22"/></td>
        </tr>
</table>
</xsl:template>
-->
	<xsl:template match="FRONTPAGE">
		<xsl:choose>
			<xsl:when test="$fpregistered=1">
				<!-- registered user -->
				<xsl:apply-templates select="MAIN-SECTIONS/EDITORIAL|MAIN-SECTIONS/REGISTERED">
					<xsl:sort select="*/PRIORITY" data-type="number" order="ascending"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="MAIN-SECTIONS/EDITORIAL|MAIN-SECTIONS/UNREGISTERED">
					<xsl:sort select="*/PRIORITY" data-type="number" order="ascending"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EDITORIAL-ITEM">
		<xsl:choose>
			<xsl:when test="$fpregistered=1 and @TYPE='UNREGISTERED' or $fpregistered=0 and @TYPE='REGISTERED'"/>
			<xsl:otherwise>
				<table width="100%" cellpadding="0" cellspacing="0" BORDER="0">
					<tr>
						<td align="left" valign="top">
							<xsl:if test="@TYPE!='REGISTERED' and @TYPE!='UNREGISTERED'">
								<!--<a><xsl:attribute name="name"><xsl:value-of select="SUBJECT"/></xsl:attribute></a>-->
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@COLUMN=2">
									<xsl:call-template name="SUBHEADER">
										<xsl:with-param name="text">
											<xsl:value-of select="SUBJECT"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="HEADER">
										<xsl:with-param name="text">
											<xsl:value-of select="SUBJECT"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<!--					<td>&nbsp;</td>-->
					</tr>
					<tr>
						<td>
							<xsl:apply-templates mode="frontpage" select="BODY"/>
						</td>
						<!--					<td>&nbsp;</td>-->
					</tr>
					<xsl:if test="MORE">
						<tr>
							<td align="right">
								<font xsl:use-attribute-sets="frontpagefont">
									<b>
										<a href="{$root}{MORE/@H2G2}">More&gt;&gt;</a>
									</b>
								</font>
							</td>
						</tr>
					</xsl:if>
				</table>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	template for TOP-FIVES sidebar section
	currently only works within the context of a frontpage - can this be changed if necessary?
-->
	<xsl:template match="TOP-FIVES">
		<div class="top5bar">
			<table width="100%" bgcolor="#99CCCC" cellspacing="0" cellpadding="1" border="0">
				<tr bgcolor="#003333" background="{$imagesource}top5bar.gif">
					<td colspan="3">
						<img src="{$imagesource}blank.gif" width="1" height="1"/>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<img src="{$imagesource}blank.gif" width="1" height="8"/>
					</td>
				</tr>
				<!-- build the list of todays selections from the editorial items 
			<tr>
				<td nowrap="1" bgcolor="#669999">&nbsp;</td>
				<td nowrap="1" bgcolor="#669999"><b><font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">
					Today's Selection</font></b></td>
				<td nowrap="1" bgcolor="#669999">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3"><img src="{$imagesource}blank.gif" width="1" height="8"/></td>
			</tr>
			<xsl:for-each select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@TYPE!='REGISTERED' and @TYPE!='UNREGISTERED']"
				order-by="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM/PRIORITY">
				<tr>
					<td>&nbsp;</td>
					<td>
						<font face="Arial, Helvetica, sans-serif" size="1" color="#006666">
							<a><xsl:attribute name="href">#<xsl:value-of select="SUBJECT"/></xsl:attribute><xsl:value-of select="SUBJECT"/></a>
						</font>
					</td>
					<td>&nbsp;</td>
				</tr>
			</xsl:for-each>
			<tr>
				<td colspan="3"><img src="{$imagesource}blank.gif" width="1" height="8"/></td>
			</tr>
			<! end of Todays Selections -->
				<!-- apply templates for each of the top five tags -->
				<!--xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser')]"/-->
				<xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') or (@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') and (@NAME = /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE)] | /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/TOP-FIVE"/>
				<!-- Apply templates to either the user-generated TOP-FIVEs or the autogenerated ones that has a matching AUTO-TOP-FIVE element or the ones in the GuideML on the frontpage -->
				<!--xsl:for-each select="TOP-FIVE">
		<xsl:value-of select="not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser')"/>
		<xsl:value-of select="@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser' and @NAME"/>
		<xsl:value-of select="@NAME"/>
		<xsl:value-of select=" /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/TOP-FIVE"/>
		<xsl:value-of select="not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') or (@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser' and @NAME = /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/TOP-FIVE)"/><br/>
	</xsl:for-each-->
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="TOP-FIVE">
		<tr>
			<td nowrap="1" bgcolor="#669999">&nbsp;</td>
			<td nowrap="1" bgcolor="#669999">
				<b>
					<font size="2" face="Arial, Helvetica, sans-serif" color="#FFFFFF">
						<xsl:value-of select="TITLE"/>
					</font>
				</b>
			</td>
			<td nowrap="1" bgcolor="#669999">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<img src="{$imagesource}blank.gif" width="1" height="8"/>
			</td>
		</tr>
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
		<tr>
			<td colspan="3">
				<img src="{$imagesource}blank.gif" width="1" height="8"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="TOP-FIVE-ARTICLE">
		<tr>
			<td>&nbsp;</td>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="1" color="#006666">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
						<xsl:value-of select="SUBJECT"/>
					</a>
				</font>
			</td>
			<td>&nbsp;</td>
		</tr>
	</xsl:template>
	<xsl:template match="TOP-FIVE-ITEM">
		<tr>
			<td>&nbsp;</td>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="1" color="#006666">
					<a href="{ADDRESS}">
						<xsl:value-of select="SUBJECT"/>
					</a>
				</font>
			</td>
			<td>&nbsp;</td>
		</tr>
	</xsl:template>
	<xsl:template match="TOP-FIVE-FORUM">
		<tr>
			<td>&nbsp;</td>
			<td>
				<font face="Arial, Helvetica, sans-serif" size="1" color="#006666">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUMID"/></xsl:attribute>
						<xsl:value-of select="SUBJECT"/>
					</a>
				</font>
			</td>
			<td>&nbsp;</td>
		</tr>
	</xsl:template>
	<xsl:template match="FORUMTHREADS">
		<xsl:param name="url" select="'F'"/>
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
				return eval('window.open(\'/MoveThread?cmd=' + command + '?ThreadID=' + threadID + '&amp;DestinationID=F' + forumID + '&amp;mode=POPUP\', \'<xsl:value-of select="$root"/>MoveThread\', \'scrollbars=1,resizable=1,width=300,height=230\')');
			}
		// </xsl:comment>
		</script>
		<!-- start of conversation list navigation -->
		<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<td align="center">
					<xsl:call-template name="threadnavbuttons">
						<xsl:with-param name="URL" select="'FFO'"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td align="center">
					<xsl:call-template name="forumpostblocks">
						<xsl:with-param name="forum" select="@FORUMID"/>
						<xsl:with-param name="skip" select="0"/>
						<xsl:with-param name="show" select="@COUNT"/>
						<xsl:with-param name="total" select="@TOTALTHREADS"/>
						<xsl:with-param name="this" select="@SKIPTO"/>
						<xsl:with-param name="url" select="'FFO'"/>
						<xsl:with-param name="splitevery">400</xsl:with-param>
						<xsl:with-param name="objectname" select="'Conversations'"/>
						<xsl:with-param name="target"></xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
		</table>
		<!--
	<xsl:if test="@SKIPTO != 0">
		<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#99cccc" bordercolorlight="#000000" bordercolordark="#000000">
			<TBODY> 
				<TR align="left"> 
					<TD nowrap="1" bgcolor="#FFFFFF" colspan="4" valign="top"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
				</TR>
				<TR align="left" bgcolor="#4A9797"> 
					<TD nowrap="1" valign="top" colspan="4"> 
						<xsl:variable name="alt">Click here for conversations <xsl:value-of select='number(@SKIPTO) - number(@COUNT) + 1'/> to <xsl:value-of select='number(@SKIPTO)'/></xsl:variable>
						<DIV align="center" class="browsenoline">
							<A href="FFO{@FORUMID}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}"><IMG src="{$imagesource}blank.gif" width="110" height="20" border="0" alt="{$alt}"/>
								<FONT color="#FFFFFF">
									<IMG alt="{$alt}" border="0" width="19" height="12" src="{$imagesource}buttons/reverse.gif" vspace="3"/>
								</FONT>
								<FONT color="#FFFFFF"><IMG src="{$imagesource}blank.gif" width="110" height="20" border="0" alt="{$alt}"/><BR/>
									<FONT face="Arial, Helvetica, sans-serif" size="1">newer conversations</FONT>
								</FONT>
							</A>
						</DIV>
					</TD>
				</TR>
				<TR align="left"> 
					<TD nowrap="1" bgcolor="#FFFFFF" colspan="4" valign="top"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
				</TR>
			</TBODY> 
		</TABLE>
	</xsl:if>
-->
		<!-- end of conversation list navigation -->
		<!-- start of conversations list -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr align="left">
				<td nowrap="nowrap" bgcolor="#FFFFFF" colspan="1">
					<img src="{$imagesource}blank.gif" width="1" height="1"/>
				</td>
			</tr>
			<xsl:for-each select="THREAD">
				<tr>
					<td>
						<table width="100%" cellpadding="2" cellspacing="0" border="0">
							<xsl:variable name="cellbgcolour">
								<xsl:choose>
									<xsl:when test="number(../../FORUMTHREADHEADERS/@THREADID) = number(THREADID)">
										<xsl:value-of select="$ftCurrentBGColour"/>
									</xsl:when>
									<xsl:when test="position() mod 2 = 1">
										<xsl:value-of select="$ftbgcolour"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$ftbgcolour2"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<tr valign="top">
								<!--						<tr>-->
								<td bgcolor="{$cellbgcolour}" width="100%">
									<font size="2">
										<xsl:element name="A">
											<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;skip=0&amp;show=20</xsl:attribute>
											<xsl:attribute name="TARGET"><xsl:value-of select="$target"/></xsl:attribute>
											<xsl:choose>
												<xsl:when test="number(../../FORUMTHREADHEADERS/@THREADID) = number(THREADID)">
													<b>
														<font face="{$fontface}" size="{$ftfontsize}" color="{$ftcurrentcolour}">
															<!--<b>-->
															<xsl:choose>
																<xsl:when test="SUBJECT=''">&lt;<xsl:value-of select="$m_nosubject"/>&gt;</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="SUBJECT"/>
																</xsl:otherwise>
															</xsl:choose>
														</font>
													</b>
												</xsl:when>
												<xsl:otherwise>
													<font face="{$fontface}" size="{$ftfontsize}">
														<xsl:choose>
															<xsl:when test="SUBJECT=''">&lt;<xsl:value-of select="$m_nosubject"/>&gt;</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="SUBJECT"/>
															</xsl:otherwise>
														</xsl:choose>
													</font>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</font>
								</td>
								<td bgcolor="{$cellbgcolour}">
									<xsl:if test="$test_IsEditor">
										<font size="1">
											<xsl:text> </xsl:text>
											<xsl:apply-templates select="@THREADID" mode="movethreadgadget"/>
										</font>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td bgcolor="{$cellbgcolour}" width="69%" colspan="2">
									<FONT size="1" face="Arial, Helvetica, sans-serif">
										<xsl:value-of select="$m_lastposting"/>
									</FONT>
									<a href="{$root}{$url}{../@FORUMID}?thread={THREADID}&amp;latest=1" target="{$target}">
										<FONT size="1" face="Arial, Helvetica, sans-serif" color="#006666">
											<xsl:apply-templates select="DATEPOSTED"/>
										</FONT>
										<FONT size="2" face="Arial, Helvetica, sans-serif"> </FONT>
									</a>
								</td>
								<!--
				<td bgcolor="{$cellbgcolour}" align="right" width="31%">
					<FONT size="1" face="Arial, Helvetica, sans-serif"> 
						<A href="{$root}{$url}{../@FORUMID}?thread={THREADID}&amp;latest=1" target="{$target}"><B>Show latest</B></A>
					</FONT>
				</td>
-->
							</tr>
						</table>
					</td>
				</tr>
				<tr align="left">
					<td nowrap="nowrap" bgcolor="#FFFFFF" colspan="1">
						<img src="{$imagesource}blank.gif" width="1" height="1"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<!--
<xsl:if test="@MORE">
<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#99cccc" bordercolorlight="#000000" bordercolordark="#000000">
  <TBODY> 
  <TR align="left"> 
    <TD nowrap="1" bgcolor="#FFFFFF" colspan="4" valign="top"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
  </TR>
  <TR align="left" bgcolor="#4A9797"> 
    <TD nowrap="1" valign="top" colspan="4">
	<xsl:variable name="alt">Click here for conversations <xsl:value-of select='number(@SKIPTO) + number(@COUNT) + 1'/> to <xsl:value-of select='number(@SKIPTO) + number(@COUNT) + number(@COUNT)'/></xsl:variable>
      <DIV align="center" class="browsenoline"><A 
href="/FFO{@FORUMID}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}"><IMG src="{$imagesource}blank.gif" width="110" height="20" border="0" alt="{$alt}"/>
<FONT color="#FFFFFF"><IMG alt="{$alt}" border="0" width="19" height="12" 
src="{$imagesource}buttons/play.gif" vspace="3"/></FONT><FONT color="#FFFFFF"><IMG src="{$imagesource}blank.gif" width="110" height="20" border="0" alt="{$alt}"/><BR/>
        <FONT face="Arial, Helvetica, sans-serif" size="1">older conversations</FONT></FONT></A></DIV>
    </TD>
  </TR>
  <TR align="left"> 
    <TD nowrap="1" bgcolor="#FFFFFF" colspan="4" valign="top"><IMG src="{$imagesource}blank.gif" width="1" height="1"/></TD>
  </TR>
  </TBODY> 
</TABLE>
</xsl:if>
-->
		<!-- end of conversations list -->
	</xsl:template>
	<xsl:template name="navbuttons">
		<xsl:param name="URL">FFO</xsl:param>
		<xsl:param name="ID" select="@FORUMID"/>
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
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right" width="36">
					<xsl:choose>
						<xsl:when test="$Skip != 0">
							<a href="{$root}{$URL}{$ID}?skip=0&amp;show={$Show}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowLeft2a','','{$imagesource}buttons/arrowbegin_ro_blue.gif',1)">
								<img src="{$imagesource}buttons/arrowbegin_blue.gif" width="18" height="15" border="0" name="ArrowLeft2a">
									<xsl:attribute name="alt"><xsl:value-of select="$shownewest"/></xsl:attribute>
								</img>
							</a>
							<xsl:variable name="alt">
								<xsl:value-of select="$showconvs"/>
								<xsl:value-of select="number($Skip) - number($Show) + 1"/>
								<xsl:value-of select="$alt_to"/>
								<xsl:value-of select="number($Skip)"/>
							</xsl:variable>
							<a href="{$root}{$URL}{$ID}?skip={number($Skip) - number($Show)}&amp;show={$Show}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowLeft2','','{$imagesource}buttons/arrowleft_ro_blue.gif',1)">
								<img src="{$imagesource}buttons/arrowleft_blue.gif" width="18" height="15" border="0" name="ArrowLeft2">
									<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
								</img>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<img src="{$imagesource}buttons/arrowbegin_faded_blue.gif" width="18" height="15" border="0" alt="{$alreadynewestconv}"/>
							<img src="{$imagesource}buttons/arrowleft_faded_blue.gif" width="18" height="15" border="0" alt="{$nonewconvs}"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" width="36">
					<xsl:choose>
						<xsl:when test="$More">
							<xsl:variable name="alt">
								<xsl:value-of select="$showconvs"/>
								<xsl:value-of select="number($Skip) + number($Show) + 1"/>
								<xsl:value-of select="$alt_to"/>
								<xsl:value-of select="number($Skip) + number($Show) + number($Show)"/>
							</xsl:variable>
							<a href="{$root}{$URL}{$ID}?skip={number($Skip) + number($Show)}&amp;show={$Show}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowRight2','','{$imagesource}buttons/arrowright_ro_blue.gif',1)">
								<img src="{$imagesource}buttons/arrowright_blue.gif" width="18" height="15" border="0" name="ArrowRight2">
									<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
								</img>
							</a>
							<a href="{$root}{$URL}{$ID}?skip={floor((number($Total)-1) div number($Show)) * number($Show)}&amp;show={$Show}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowRight2a','','{$imagesource}buttons/arrowend_ro_blue.gif',1)">
								<img src="{$imagesource}buttons/arrowend_blue.gif" width="18" height="15" border="0" name="ArrowRight2a">
									<xsl:attribute name="alt"><xsl:value-of select="$showoldestconv"/></xsl:attribute>
								</img>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<img src="{$imagesource}buttons/arrowright_faded_blue.gif" width="18" height="15" border="0" alt="{$noolderconv}"/>
							<img src="{$imagesource}buttons/arrowend_faded_blue.gif" width="18" height="15" border="0" alt="{$showingoldest}"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
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
						<img src="{$imagesource}buttons/arrowbegin_blue.gif" width="18" height="15" border="0" alt="{$alt_rf_shownewest}" name="ArrowBegin1"/>
					</xsl:with-param>
					<xsl:with-param name="skiptoprevious">
						<img src="{$imagesource}buttons/arrowleft_blue.gif" width="18" height="15" border="0" name="ArrowLeft1" alt="{$prevrange}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptobeginningfaded">
						<img src="{$imagesource}buttons/arrowbegin_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_rf_alreadynewestconv}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptopreviousfaded">
						<img src="{$imagesource}buttons/arrowleft_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_rf_nonewconvs}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptonext">
						<img src="{$imagesource}buttons/arrowright_blue.gif" width="18" height="15" border="0" name="ArrowRight1" alt="{$nextrange}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptoend">
						<img src="{$imagesource}buttons/arrowend_blue.gif" width="18" height="15" border="0" alt="{$alt_rf_showoldestconv}" name="ArrowEnd1"/>
					</xsl:with-param>
					<xsl:with-param name="skiptonextfaded">
						<img src="{$imagesource}buttons/arrowright_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_rf_noolderconv}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptoendfaded">
						<img src="{$imagesource}buttons/arrowend_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_rf_showingoldest}"/>
					</xsl:with-param>
					<xsl:with-param name="ExtraParameters">?entry=0&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<br/>
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
						<img src="{$imagesource}buttons/arrowbegin_blue.gif" width="18" height="15" border="0" alt="{$alt_shownewest}" name="ArrowBegin1"/>
					</xsl:with-param>
					<xsl:with-param name="skiptoprevious">
						<img src="{$imagesource}buttons/arrowleft_blue.gif" width="18" height="15" border="0" name="ArrowLeft1" alt="{$prevrange}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptobeginningfaded">
						<img src="{$imagesource}buttons/arrowbegin_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_alreadynewestconv}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptopreviousfaded">
						<img src="{$imagesource}buttons/arrowleft_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_nonewconvs}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptonext">
						<img src="{$imagesource}buttons/arrowright_blue.gif" width="18" height="15" border="0" name="ArrowRight1" alt="{$nextrange}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptoend">
						<img src="{$imagesource}buttons/arrowend_blue.gif" width="18" height="15" border="0" alt="{$alt_showoldestconv}" name="ArrowEnd1"/>
					</xsl:with-param>
					<xsl:with-param name="skiptonextfaded">
						<img src="{$imagesource}buttons/arrowright_faded_blue.gif" width="18" height="15" border="0" alt="{$m_noolderconv}"/>
					</xsl:with-param>
					<xsl:with-param name="skiptoendfaded">
						<img src="{$imagesource}buttons/arrowend_faded_blue.gif" width="18" height="15" border="0" alt="{$alt_showingoldest}"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
		<!--xsl:param name="URL">FFO</xsl:param>
<xsl:param name="ID"><xsl:value-of select="@FORUMID"/></xsl:param>
<xsl:param name="ExtraParameters"/>
<xsl:param name="showconvs"><xsl:value-of select="$alt_showconvs"/></xsl:param>
<xsl:param name="shownewest"><xsl:value-of select="$alt_shownewest"/></xsl:param>
<xsl:param name="alreadynewestconv"><xsl:value-of select="$alt_alreadynewestconv"/></xsl:param>
<xsl:param name="nonewconvs"><xsl:value-of select="$alt_nonewconvs"/></xsl:param>
<xsl:param name="showoldestconv"><xsl:value-of select="$alt_showoldestconv"/></xsl:param>
<xsl:param name="noolderconv"><xsl:value-of select="$m_noolderconv"/></xsl:param>
<xsl:param name="showingoldest"><xsl:value-of select="$alt_showingoldest"/></xsl:param>
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right" width="36">
				<xsl:choose>
					<xsl:when test="@SKIPTO != 0">
						<a href="{$root}{$URL}{$ID}?skip=0&amp;show={@COUNT}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowLeft2a','','{$imagesource}buttons/arrowbegin_ro_blue.gif',1)">
							<img src="{$imagesource}buttons/arrowbegin_blue.gif" width="18" height="15" border="0" name="ArrowLeft2a">
								<xsl:attribute name="alt"><xsl:value-of select="$shownewest"/></xsl:attribute>
							</img>
						</a>
						<xsl:variable name="alt"><xsl:value-of select="$showconvs"/><xsl:value-of select='number(@SKIPTO) - number(@COUNT) + 1'/><xsl:value-of select="$alt_to"/><xsl:value-of select='number(@SKIPTO)'/></xsl:variable>
						<a href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowLeft2','','{$imagesource}buttons/arrowleft_ro_blue.gif',1)">
							<img src="{$imagesource}buttons/arrowleft_blue.gif" width="18" height="15" border="0" name="ArrowLeft2">
								<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
							</img>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}buttons/arrowbegin_faded_blue.gif" width="18" height="15" border="0" alt="{$alreadynewestconv}"/>
						<img src="{$imagesource}buttons/arrowleft_faded_blue.gif" width="18" height="15" border="0" alt="{$nonewconvs}"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td align="left" width="36">
				<xsl:choose>
					<xsl:when test="@MORE">
						<xsl:variable name="alt"><xsl:value-of select="$showconvs"/><xsl:value-of select='number(@SKIPTO) + number(@COUNT) + 1'/><xsl:value-of select="$alt_to"/><xsl:value-of select='number(@SKIPTO) + number(@COUNT) + number(@COUNT)'/></xsl:variable>
						<a href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowRight2','','{$imagesource}buttons/arrowright_ro_blue.gif',1)">
							<img src="{$imagesource}buttons/arrowright_blue.gif" width="18" height="15" border="0" name="ArrowRight2">
								<xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
							</img>
						</a>
						<a href="{$root}{$URL}{$ID}?skip={floor((number(@TOTALTHREADS)-1) div number(@COUNT)) * number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ArrowRight2a','','{$imagesource}buttons/arrowend_ro_blue.gif',1)">
							<img src="{$imagesource}buttons/arrowend_blue.gif" width="18" height="15" border="0" name="ArrowRight2a">
								<xsl:attribute name="alt"><xsl:value-of select="$showoldestconv"/></xsl:attribute>
							</img>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}buttons/arrowright_faded_blue.gif" width="18" height="15" border="0" alt="{$noolderconv}"/>
						<img src="{$imagesource}buttons/arrowend_faded_blue.gif" width="18" height="15" border="0" alt="{$showingoldest}"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</table-->
	</xsl:template>
	<xsl:template match="ARTICLEFORUM/FORUMTHREADS">
		<br clear="all"/>
		<table cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<xsl:apply-templates select="@FORUMID" mode="AddThread">
						<xsl:with-param name="img">
							<img src="{$imagesource}buttons/discussthis.gif" width="98" height="15" border="0" alt="{$alt_discussthis}" name="Image1"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</td>
				<td>&nbsp;&nbsp;</td>
				<xsl:call-template name="PeopleTalking"/>
			</tr>
		</table>
		<xsl:choose>
			<xsl:when test="THREAD">
				<table width="100%" cellpadding="4">
					<tr valign="top">
						<td width="50%">
							<p>
								<font face="Arial, Helvetica, sans-serif" size="1">
									<xsl:for-each select="THREAD[@INDEX mod 2 = 0]">
										<xsl:apply-templates select="@THREADID" mode="LinkOnSubjectAB"/>
										<br/>
									(<xsl:value-of select="$m_lastposting"/>
										<xsl:apply-templates select="@THREADID" mode="LinkOnDatePosted"/>)
									<br/>
										<br/>
									</xsl:for-each>
								</font>
							</p>
						</td>
						<td WIDTH="50%">
							<p>
								<font face="Arial, Helvetica, sans-serif" size="1">
									<xsl:for-each select="THREAD[@INDEX mod 2 = 1]">
										<xsl:apply-templates select="@THREADID" mode="LinkOnSubjectAB"/>
										<br/>
									(<xsl:value-of select="$m_lastposting"/>
										<xsl:apply-templates select="@THREADID" mode="LinkOnDatePosted"/>)
									<br/>
										<br/>
									</xsl:for-each>
								</font>
							</p>
						</td>
					</tr>
				</table>
				<div align="center">
					<font size="2" face="Arial, Helvetica, sans-serif">
						<xsl:apply-templates select="@FORUMID" mode="MoreConv"/>
					</font>
					<br/>
					<xsl:call-template name="subscribearticleforum"/>
					<br/>
				</div>
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td background="{$imagesource}headerbar.gif" width="100%">
							<img src="{$imagesource}headerbar.gif" width="300" height="4"/>
						</td>
					</tr>
				</table>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<div align="center">
					<br/>
					<xsl:call-template name="subscribearticleforum"/>
					<br/>
				</div>
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td background="{$imagesource}headerbar.gif" width="100%">
							<img src="{$imagesource}headerbar.gif" width="300" height="4"/>
						</td>
					</tr>
				</table>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	template for DATE to be displayed without the time
-->
	<xsl:template mode="DATE-ONLY" match="DATE">
		<xsl:choose>
			<xsl:when test="@RELATIVE">
				<xsl:value-of select="@RELATIVE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@DAYNAME"/>&nbsp;<xsl:value-of select="number(@DAY)"/>
				<xsl:choose>
					<xsl:when test="number(@DAY) = 1 or number(@DAY) = 21 or number(@DAY) = 31">st</xsl:when>
					<xsl:when test="number(@DAY) = 2 or number(@DAY) = 22">nd</xsl:when>
					<xsl:when test="number(@DAY) = 3 or number(@DAY) = 23">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>&nbsp;<xsl:value-of select="@MONTHNAME"/>,&nbsp;<xsl:value-of select="@YEAR"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="FORUMPAGE">
		<xsl:apply-templates select="FORUMSOURCE"/>
		<br/>
		<xsl:choose>
			<xsl:when test="FORUMTHREADS">
Here are some more Conversations, starting at number <xsl:value-of select="number(FORUMTHREADS/@SKIPTO)+1"/>.<br/>
				<br/>
				<xsl:apply-templates select="FORUMTHREADS">
					<xsl:with-param name="url" select="'FP'"/>
					<xsl:with-param name="target" select="''"/>
				</xsl:apply-templates>
				<br/>
				<xsl:if test="FORUMTHREADS/@MORE">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADS/@FORUMID"/>?skip=<xsl:value-of select="number(FORUMTHREADS/@SKIPTO) + number(FORUMTHREADS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>Click here for older Conversations</A>
					<br/>
				</xsl:if>
				<xsl:if test="number(FORUMTHREADS/@SKIPTO) > 0">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADS/@FORUMID"/>?skip=<xsl:value-of select="number(FORUMTHREADS/@SKIPTO) - number(FORUMTHREADS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>Click here for newer Conversations</A>
				</xsl:if>
			</xsl:when>
			<xsl:when test="FORUMTHREADPOSTS">
				<A>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>FT<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/></xsl:attribute>
					<xsl:attribute name="TARGET">_top</xsl:attribute>
Click here to return to the list of Conversations
</A>
				<br/>
				<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see older posts
</A>
					<br/>
				</xsl:if>
				<xsl:if test="FORUMTHREADPOSTS/@MORE">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see newer posts
</A>
					<br/>
				</xsl:if>
				<xsl:apply-templates select="FORUMTHREADPOSTS">
					<xsl:with-param name="ptype" select="'page'"/>
				</xsl:apply-templates>
				<br/>
				<xsl:if test="FORUMTHREADPOSTS[@SKIPTO > 0]">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) - number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see older posts
</A>
					<br/>
				</xsl:if>
				<xsl:if test="FORUMTHREADPOSTS/@MORE">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FP<xsl:value-of select="FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADPOSTS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADPOSTS/@SKIPTO) + number(FORUMTHREADPOSTS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADPOSTS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see newer posts
</A>
					<br/>
				</xsl:if>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
				<br/>
			</xsl:when>
			<xsl:when test="FORUMTHREADHEADERS">
				<xsl:apply-templates select="FORUMTHREADHEADERS"/>
				<br/>
				<xsl:if test="FORUMTHREADHEADERS[@SKIPTO > 0]">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FH<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADHEADERS/@SKIPTO) - number(FORUMTHREADHEADERS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see older posts
</A>
					<br/>
				</xsl:if>
				<xsl:if test="FORUMTHREADHEADERS/@MORE">
					<A>
						<xsl:attribute name="href"><xsl:value-of select="$root"/>FH<xsl:value-of select="FORUMTHREADHEADERS/@FORUMID"/>?thread=<xsl:value-of select="FORUMTHREADHEADERS/@THREADID"/>&amp;skip=<xsl:value-of select="number(FORUMTHREADHEADERS/@SKIPTO) + number(FORUMTHREADHEADERS/@COUNT)"/>&amp;show=<xsl:value-of select="FORUMTHREADHEADERS/@COUNT"/></xsl:attribute>
						<xsl:attribute name="TARGET">_top</xsl:attribute>
Click to see newer posts
</A>
					<br/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="lastsubject"></xsl:variable>
	<xsl:template mode="many" match="FORUMTHREADHEADERS">
		<DIV class="browse">
			<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="{$ftbgcolour}" bordercolorlight="#000000" bordercolordark="#000000">
				<TR align="left">
					<TD nowrap="1" bgcolor="#FFFFFF" colspan="4">
						<IMG src="{$imagesource}blank.gif" width="1" height="1"/>
					</TD>
				</TR>
				<xsl:apply-templates mode="many" select="POST"/>
			</TABLE>
		</DIV>
	</xsl:template>
	<xsl:template mode="many" match="FORUMTHREADHEADERS/POST">
		<tr align="left">
			<TD nowrap="1" valign="top">&nbsp;</TD>
			<TD nowrap="1" valign="top" class="number">
				<DIV class="number">
					<FONT size="1" face="Arial, Helvetica, sans-serif">
						<A target="messages" href="{$root}FFM{../@FORUMID}?thread={../@THREADID}&amp;skip={../@SKIPTO}&amp;show={../@COUNT}#p{@POSTID}">
							<xsl:value-of select="position() + number(../@SKIPTO)"/>
						</A>
					</FONT>
				</DIV>
			</TD>
			<TD nowrap="1">&nbsp;&nbsp;</TD>
			<td bgcolor="{$ftbgcolour}" nowrap="1">
				<nobr>
					<font size="2" face="{$fontface}" color="black">
						<xsl:element name="A">
							<xsl:attribute name="href"><xsl:value-of select="$root"/>FFM<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;skip=<xsl:value-of select="../@SKIPTO"/>&amp;show=<xsl:value-of select="../@COUNT"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>
							<xsl:attribute name="TARGET">messages</xsl:attribute>
							<xsl:if test="SUBJECT[@SAME!='1']">
								<b>
									<FONT color="{$ftNewSubjectColour}">
										<xsl:call-template name="postsubject"/>
									</FONT>
								</b>
								<br/>
							</xsl:if>
							<xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
							<FONT face="Arial, Helvetica, sans-serif" size="2">
								<xsl:if test="not(@HIDDEN &gt; 0)">
									<xsl:apply-templates select="USER/USERNAME"/>
								</xsl:if>
			 (<xsl:apply-templates select="DATEPOSTED"/>)</FONT>
						</xsl:element>
					</font>
				</nobr>
				<!--
	<img src="{$imagesource}white.gif" width="100%" height="1"/>
	<br/>
-->
			</td>
		</tr>
		<TR align="left">
			<TD nowrap="1" bgcolor="#FFFFFF" colspan="4" valign="top">
				<IMG src="{$imagesource}blank.gif" width="1" height="1"/>
			</TD>
		</TR>
	</xsl:template>
	<xsl:template mode="single" match="FORUMTHREADHEADERS/POST">
		<xsl:element name="A">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>FSP<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;skip=<xsl:value-of select="../@SKIPTO"/>&amp;show=<xsl:value-of select="../@COUNT"/>&amp;post=<xsl:value-of select="@POSTID"/></xsl:attribute>
			<!--<IMG border="0" src="http://www2.h2g2.com/images/threadicon.gif"/>-->
			<xsl:choose>
				<xsl:when test="SUBJECT[@SAME='1']">
...
</xsl:when>
				<xsl:otherwise>
					<b>
						<xsl:value-of select="SUBJECT"/>
					</b>
				</xsl:otherwise>
			</xsl:choose>
(<xsl:value-of select="USER/USERNAME"/>, <xsl:apply-templates select="DATEPOSTED"/>)
</xsl:element>
		<br/>
	</xsl:template>
	<!--
	template for a post within a thread listing
	i.e. the display of posts on a forum page
-->
	<xsl:template match="FORUMTHREADPOSTS/POST">
		<xsl:param name="ptype" select="'frame'"/>
		<TABLE width="100%" cellpadding="0" cellspacing="0" border="0">
			<!--
			<TD colspan="3" width="100%"><HR/></TD>
-->
			<TR>
				<TD colspan="5" width="100%" bgcolor="#669999">
					<img src="{$imagesource}blank.gif" width="100%" height="1"/>
				</TD>
			</TR>
			<TR>
				<TD colspan="5" width="100%" bgcolor="#99CCCC">
					<img src="{$imagesource}blank.gif" width="100%" height="1"/>
				</TD>
			</TR>
			<TR>
				<TD bgcolor="#CCFFFF" WIDTH="3">
					<IMG SRC="{$imagesource}blank.gif" width="3" height="1"/>
				</TD>
				<TD bgcolor="#CCFFFF" WIDTH="100%">
					<!--			place the anchor for each post at the top by the subject
				this is used for navigating the list of posts	-->
				
						<a name="pi{count(preceding-sibling::POST) + 1 + number(../@SKIPTO)}">
						<a name="p{@POSTID}">
						<font face="Arial, Helvetica, sans-serif" size="2" color="#000000">
							<xsl:value-of select="$m_fsubject"/>
							<b>
								<xsl:call-template name="postsubject"/>
							</b>
							<BR/>
							<xsl:value-of select="$m_posted"/>
							<xsl:apply-templates select="DATEPOSTED/DATE"/>
							<xsl:if test="not(@HIDDEN &gt; 0)">
								<xsl:value-of select="$m_by"/>
								<xsl:apply-templates select="USER" mode="showonline">
									<xsl:with-param name="symbol">
										<img src="{$imagesource}online.gif" alt="Online Now"/>
									</xsl:with-param>
								</xsl:apply-templates>
								<A target="_top">
									<xsl:attribute name="href"><xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/></xsl:attribute>
									<xsl:apply-templates select="USER/USERNAME"/>
								</A>
							</xsl:if>
						</font>
						</a>
					</a>
					<br/>
					<FONT size="1" face="Arial, Helvetica, sans-serif">
						<xsl:if test="@INREPLYTO">
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
									<xsl:value-of select="$m_inreplyto"/>
									<A>
										<xsl:attribute name="href">#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute>
										<xsl:value-of select="$m_thispost"/>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$m_inreplyto"/>
									<A>
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">_top</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@INREPLYTO"/>#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute>
										<xsl:value-of select="$m_thispost"/>
									</A>
								</xsl:otherwise>
							</xsl:choose>
							<IMG src="{$imagesource}blank.gif" width="10" height="15" border="0" align="absmiddle"/>
						</xsl:if>
						<!--
		<xsl:if test="@PREVSIBLING">
			<xsl:choose>
				<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
					[ <A><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>view previous reply</A> ]
				</xsl:when>
				<xsl:otherwise>
					[ <A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@PREVSIBLING" /></xsl:attribute>view previous reply</A> ]
				</xsl:otherwise>
			</xsl:choose>
				<IMG src="{$imagesource}blank.gif" width="10" height="15" border="0" align="absmiddle"/>
		</xsl:if>
		<xsl:if test="@NEXTSIBLING">
			<xsl:choose>
				<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
					[ <A><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />#p<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>view next reply</A> ]
				</xsl:when>
				<xsl:otherwise>
					[ <A><xsl:if test="$ptype='frame'"><xsl:attribute name="target">twosides</xsl:attribute></xsl:if><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;post=<xsl:value-of select="@NEXTSIBLING" /></xsl:attribute>view next reply</A> ]
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
-->
&nbsp;
				</FONT>
				</TD>
				<TD bgcolor="#CCFFFF" align="right" WIDTH="45">
					<xsl:choose>
						<xsl:when test="$showtreegadget=1">
							<TABLE cellpadding="0" cellspacing="0" BORDER="0">
								<TR>
									<TD ROWSPAN="3" align="right" valign="top" width="16" height="33">
										<xsl:choose>
											<xsl:when test="@PREVSIBLING">
												<xsl:choose>
													<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
														<A>
															<xsl:attribute name="href">#p<xsl:value-of select="@PREVSIBLING"/></xsl:attribute>
															<IMG width="16" height="33" SRC="{$imagesource2}buttons/leftsibling2.gif" BORDER="0" alt="{$alt_prevreply}"/>
														</A>
													</xsl:when>
													<xsl:otherwise>
														<A>
															<xsl:if test="$ptype='frame'">
																<xsl:attribute name="target">_top</xsl:attribute>
															</xsl:if>
															<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@PREVSIBLING"/>#p<xsl:value-of select="@PREVSIBLING"/></xsl:attribute>
															<IMG width="16" height="33" SRC="{$imagesource2}buttons/leftsibling2.gif" BORDER="0" alt="{$alt_prevreply}"/>
														</A>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<IMG width="16" height="33" SRC="{$imagesource2}buttons/leftsiblingunsel.gif" BORDER="0" alt="{$alt_noolderreplies}"/>
											</xsl:otherwise>
										</xsl:choose>
									</TD>
									<TD align="right" valign="top" width="13" height="11">
										<xsl:choose>
											<xsl:when test="@INREPLYTO">
												<xsl:choose>
													<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
														<A>
															<xsl:attribute name="href">#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute>
															<IMG SRC="{$imagesource2}buttons/parent2.gif" BORDER="0" width="13" height="11" alt="{$alt_replyingtothis}"/>
														</A>
													</xsl:when>
													<xsl:otherwise>
														<A>
															<xsl:if test="$ptype='frame'">
																<xsl:attribute name="target">_top</xsl:attribute>
															</xsl:if>
															<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@INREPLYTO"/>#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute>
															<IMG SRC="{$imagesource2}buttons/parent2.gif" width="13" height="11" BORDER="0" alt="{$alt_replyingtothis}"/>
														</A>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<IMG SRC="{$imagesource2}buttons/parentunsel.gif" width="13" height="11" BORDER="0" alt="{$alt_notareply}"/>
											</xsl:otherwise>
										</xsl:choose>
									</TD>
									<TD ROWSPAN="3" align="right" valign="top" width="16" height="33">
										<xsl:choose>
											<xsl:when test="@NEXTSIBLING">
												<xsl:choose>
													<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
														<A>
															<xsl:attribute name="href">#p<xsl:value-of select="@NEXTSIBLING"/></xsl:attribute>
															<IMG SRC="{$imagesource2}buttons/rightsibling2.gif" width="16" height="33" BORDER="0" alt="{$alt_nextreply}"/>
														</A>
													</xsl:when>
													<xsl:otherwise>
														<A>
															<xsl:if test="$ptype='frame'">
																<xsl:attribute name="target">_top</xsl:attribute>
															</xsl:if>
															<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@NEXTSIBLING"/>#p<xsl:value-of select="@NEXTSIBLING"/></xsl:attribute>
															<IMG SRC="{$imagesource2}buttons/rightsibling2.gif" width="16" height="33" BORDER="0" alt="{$alt_nextreply}"/>
														</A>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<IMG SRC="{$imagesource2}buttons/rightsiblingunsel.gif" width="16" height="33" BORDER="0" alt="{$alt_nonewerreplies}"/>
											</xsl:otherwise>
										</xsl:choose>
									</TD>
								</TR>
								<TR>
									<TD align="right" valign="top" width="13" height="11">
										<IMG SRC="{$imagesource2}buttons/context2.gif" width="13" height="11" BORDER="0" alt="{$alt_currentpost}"/>
									</TD>
								</TR>
								<TR>
									<TD align="right" valign="top" width="13" height="11">
										<xsl:choose>
											<xsl:when test="@FIRSTCHILD">
												<xsl:choose>
													<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
														<A>
															<xsl:attribute name="href">#p<xsl:value-of select="@FIRSTCHILD"/></xsl:attribute>
															<IMG SRC="{$imagesource2}buttons/firstchild2.gif" width="13" height="11" BORDER="0" alt="{$alt_firstreply}"/>
														</A>
													</xsl:when>
													<xsl:otherwise>
														<A>
															<xsl:if test="$ptype='frame'">
																<xsl:attribute name="target">_top</xsl:attribute>
															</xsl:if>
															<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@FIRSTCHILD"/>#p<xsl:value-of select="@FIRSTCHILD"/></xsl:attribute>
															<IMG SRC="{$imagesource2}buttons/firstchild2.gif" width="13" height="11" BORDER="0" alt="{$alt_firstreply}"/>
														</A>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<IMG SRC="{$imagesource2}buttons/firstchildunsel.gif" width="13" height="11" BORDER="0" alt="{$alt_noreplies}"/>
											</xsl:otherwise>
										</xsl:choose>
									</TD>
								</TR>
							</TABLE>
						</xsl:when>
						<xsl:otherwise>
							<img src="{$imagesource}blank.gif" width="1" height="1"/>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
				<!--<TD bgcolor="#CCFFFF">&nbsp;</TD>-->
				<TD align="right" valign="top" bgcolor="#CCFFFF" nowrap="nowrap">
					<FONT size="1" color="#000000" face="Arial, Helvetica, sans-serif">Posting 
				<xsl:value-of select="position() + number(../@SKIPTO)"/>
						<br/>
						<br/>
					</FONT>
					<xsl:element name="A">
						<!--
					<xsl:attribute name="NAME">p<xsl:value-of select="@POSTID" /></xsl:attribute>
-->
						<!-- each posts images need unique names -->
						<xsl:variable name="imageName">ArrowUp<xsl:value-of select="position()"/>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="@PREVINDEX">
								<xsl:choose>
									<xsl:when test="../POST[@POSTID = current()/@PREVINDEX]">
										<A onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('{$imageName}','','{$imagesource}buttons/arrowup_ro_blue.gif',1)">
											<xsl:attribute name="href"><!--<xsl:value-of select="$root"/>
											<xsl:choose>
												<xsl:when test="$ptype='frame'">FFM</xsl:when>
												<xsl:otherwise>FP</xsl:otherwise>
											</xsl:choose>
											<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />-->#p<xsl:value-of select="@PREVINDEX"/></xsl:attribute>
											<img src="{$imagesource}buttons/arrowup.gif" border="0" alt="{$alt_prevpost}" name="{$imageName}"/>
										</A>
									</xsl:when>
									<xsl:otherwise>
										<A onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('{$imageName}','','{$imagesource}buttons/arrowup_ro_blue.gif',1)">
											<xsl:if test="$ptype='frame'">
												<xsl:attribute name="target">_top</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@PREVINDEX"/>#p<xsl:value-of select="@PREVINDEX"/></xsl:attribute>
											<img src="{$imagesource}buttons/arrowup.gif" border="0" alt="{$alt_prevpost}" name="{$imageName}"/>
										</A>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<img src="{$imagesource}blank.gif" width="18" height="15"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:choose>
						<xsl:when test="@NEXTINDEX">
							<!-- each posts images need unique names -->
							<xsl:variable name="imageName">ArrowDown<xsl:value-of select="position()"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@NEXTINDEX]">
									<A onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('{$imageName}','','{$imagesource}buttons/arrowdown_ro_blue.gif',1)">
										<xsl:attribute name="HREF"><!--<xsl:choose>
											<xsl:when test="$ptype='frame'">FFM</xsl:when>
											<xsl:otherwise>FP</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />-->#p<xsl:value-of select="@NEXTINDEX"/></xsl:attribute>
										<img src="{$imagesource}buttons/arrowdown.gif" border="0" alt="{$alt_nextpost}" name="{$imageName}"/>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<A onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('{$imageName}','','{$imagesource}buttons/arrowdown_ro_blue.gif',1)">
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">_top</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@NEXTINDEX"/>#p<xsl:value-of select="@NEXTINDEX"/></xsl:attribute>
										<img src="{$imagesource}buttons/arrowdown.gif" border="0" alt="{$alt_nextpost}" name="{$imageName}"/>
									</A>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<img src="{$imagesource}blank.gif" width="18" height="15"/>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
				<TD bgcolor="#CCFFFF" width="5">
					<IMG SRC="{$imagesource}blank.gif" width="5" height="1"/>
				</TD>
			</TR>
			<TR>
				<TD COLSPAN="5">
					<font face="Arial, Helvetica, sans-serif" size="2" color="#000000">
						<xsl:call-template name="showpostbody"/>
						<br/>
						<br/>
					</font>
				</TD>
			</TR>
		</TABLE>
		<TABLE WIDTH="100%">
			<TR>
				<TD ALIGN="LEFT">
					<xsl:if test="@HIDDEN=0">
						<xsl:variable name="imageName">Reply<xsl:value-of select="position()"/>
						</xsl:variable>
						<A onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('{$imageName}','','{$imagesource}buttons/reply_ro.gif',1)">
							<xsl:attribute name="href"><xsl:apply-templates select="." mode="sso_post_signin"/></xsl:attribute>
							<xsl:attribute name="TARGET">_top</xsl:attribute>
							<img src="{$imagesource}buttons/reply.gif" border="0" alt="{$alt_reply}" name="{$imageName}"/>
						</A>
					</xsl:if>
					<font face="Arial, Helvetica, sans-serif" size="1">
						<xsl:if test="@FIRSTCHILD">
							<br/>
							<xsl:value-of select="$m_readthe"/>
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
									<A>
										<xsl:attribute name="href"><!--<xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>FP</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID" />?thread=<xsl:value-of select="../@THREADID" />&amp;skip=<xsl:value-of select="../@SKIPTO" />&amp;show=<xsl:value-of select="../@COUNT" />-->#p<xsl:value-of select="@FIRSTCHILD"/></xsl:attribute>
										<xsl:value-of select="$alt_firstreply"/>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<A>
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">_top</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@FIRSTCHILD"/>#p<xsl:value-of select="@FIRSTCHILD"/></xsl:attribute>
										<xsl:value-of select="$alt_firstreply"/>
									</A>
								</xsl:otherwise>
							</xsl:choose>
							<br/>
						</xsl:if>
						<br/>
					</font>
				</TD>
				<TD ALIGN="RIGHT">
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR'">
						<font size="1">
							<a target="_top" href="{$root}ModerationHistory?PostID={@POSTID}">moderation history</a>
						</font>
					</xsl:if>
					<xsl:if test="@HIDDEN=0">
						<xsl:variable name="complainImageName">Complain<xsl:value-of select="position()"/>
						</xsl:variable>
						<a target="ComplaintPopup" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('{$complainImageName}','','{$imagesource}buttons/complain_ro.gif',1)">
              <xsl:attribute name="href">
                /dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;postID=<xsl:value-of select="@POSTID"/>
              </xsl:attribute>
              <xsl:attribute name="onclick">
                popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;postID=<xsl:value-of select="@POSTID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')
              </xsl:attribute>
							<img src="{$imagesource}buttons/complain.gif" border="0" alt="{$alt_complain}" name="{$complainImageName}"/>
						</a>
					</xsl:if>
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR'">
						<xsl:text> </xsl:text>
						<a href="{$root}EditPost?PostID={@POSTID}" target="_top" onClick="javascript:popupwindow('{$root}EditPost?PostID={@POSTID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;">edit</a>
					</xsl:if>
				</TD>
			</TR>
		</TABLE>
	</xsl:template>
	<xsl:template match="REFERENCES/ENTRIES">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<b>
						<font face="Arial, Helvetica, sans-serif" size="2" color="black">
							<xsl:value-of select="$m_refentries"/>
						</font>
					</b>
				</td>
			</tr>
			<xsl:apply-templates select="ENTRYLINK"/>
		</table>
	</xsl:template>
	<xsl:template match="REFERENCES/USERS">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<b>
						<font face="Arial, Helvetica, sans-serif" size="2" color="black">
							<xsl:value-of select="$m_refresearchers"/>
						</font>
					</b>
				</td>
			</tr>
			<xsl:apply-templates select="USERLINK"/>
		</table>
	</xsl:template>
	<xsl:template match="REFERENCES/EXTERNAL" mode="BBCSites">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<b>
						<font face="Arial, Helvetica, sans-serif" size="2" color="black">
							<xsl:value-of select="$m_otherbbcsites"/>
						</font>
					</b>
				</td>
			</tr>
			<xsl:call-template name="ExLinksBBCSites"/>
		</table>
	</xsl:template>
	<xsl:template match="REFERENCES/EXTERNAL" mode="NONBBCSites">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<b>
						<font face="Arial, Helvetica, sans-serif" size="2" color="black">
							<xsl:value-of select="$m_refsites"/>
						</font>
					</b>
				</td>
			</tr>
			<xsl:call-template name="ExLinksNONBBCSites"/>
		</table>
		<br/>
		<font face="{$fontface}" size="1">
			<xsl:value-of select="$m_referencedsitesdisclaimer"/>
		</font>
	</xsl:template>
	<xsl:template match="CREDITS[/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP/NAME='Editor']">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="3" cellspacing="0">
			<tr>
				<td>
					<b>
						<font face="Arial, Helvetica, sans-serif" size="2" color="black">
							<xsl:value-of select="@TITLE"/>
						</font>
					</b>
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
	<xsl:template match="H2G2/JOURNAL">
		<xsl:param name="mymessage"/>
		<table width="100%">
			<tr valign="top">
				<td width="100%" colspan="2">
					<font face="Arial, Helvetica, sans-serif" size="2">
						<b>
							<font size="4">
								<xsl:value-of select="$mymessage"/>
								<xsl:value-of select="$m_journalentries"/>
							</font>
							<!--<img src="{$imagesource}icon_journal.gif" width="45" height="16" hspace="7"/>-->
							<br/>
							<xsl:if test="$test_MayAddToJournal">
								<xsl:call-template name="ClickAddJournal">
									<xsl:with-param name="img">
										<img src="{$imagesource}buttons/addjournal.gif" width="96" height="15" name="addjourn" alt="{$alt_addjournal}" border="0" vspace="3"/>
									</xsl:with-param>
								</xsl:call-template>
								<br/>
							</xsl:if>
							<br/>
						</b>
					</font>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<p>
						<font face="Arial, Helvetica, sans-serif" size="1">
							<br/>
						</font>
					</p>
				</td>
				<td>
					<font face="arial, helvetica, sans-serif" size="2">
						<xsl:choose>
							<xsl:when test="JOURNALPOSTS/POST">
								<!-- owner, full -->
								<xsl:call-template name="JournalFullMsg"/>
								<xsl:apply-templates select="JOURNALPOSTS"/>
								<br/>
								<xsl:if test="JOURNALPOSTS[@MORE=1]">
									<xsl:apply-templates select="JOURNALPOSTS" mode="MoreJournal"/>
									<br/>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<!-- owner empty -->
								<xsl:call-template name="JournalEmptyMsg"/>
							</xsl:otherwise>
						</xsl:choose>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="JOURNALPOSTS/POST">
		<xsl:if test="not(@HIDDEN &gt; 0)">
			<p>
				<font size="3" face="Arial, Helvetica, sans-serif" color="#006666">
					<b>
						<xsl:value-of select="SUBJECT"/>
					</b>
					<br/>
				</font>
				<font size="2" face="Arial, Helvetica, sans-serif">
					<font color="{$headercolour}" size="1">
						<xsl:apply-templates select="DATEPOSTED/DATE"/>
					</font>
					<br/>
					<br/>
				</font>
				<xsl:apply-templates select="TEXT"/>
				<br/>
				<br/>
				<font size="2">
					<xsl:variable name="ImageName">Discuss<xsl:value-of select="position()"/>
					</xsl:variable>
					<table cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td>
								<xsl:apply-templates select="@POSTID" mode="DiscussJournalEntry">
									<xsl:with-param name="attributes">
										<attribute name="onMouseOver" value="MM_swapImage('{$ImageName}','','{$imagesource}buttons/discussthis_ro.gif',1)"/>
									</xsl:with-param>
									<xsl:with-param name="img">
										<img src="{$imagesource}buttons/discussthis.gif" width="98" height="15" border="0" alt="{$alt_discussthis}" name="{$ImageName}"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</td>
							<td>&nbsp;&nbsp;</td>
							<td align="left">
								<font face="Arial, Helvetica, sans-serif" size="1">
								(<font color="#006666">
										<xsl:choose>
											<xsl:when test="number(LASTREPLY/@COUNT) &gt; 1">
												<xsl:apply-templates select="@THREADID" mode="JournalEntryReplies"/>
												<font color="#000000">, <xsl:value-of select="$m_latestreply"/>
												</font>
												<xsl:apply-templates select="@THREADID" mode="JournalLastReply"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$m_noreplies"/>
											</xsl:otherwise>
										</xsl:choose>
									</font>)
								<br/>
									<xsl:if test="$test_MayRemoveJournalPost">
										<xsl:apply-templates select="@THREADID" mode="JournalRemovePost"/>
										<br/>
									</xsl:if>
								</font>
							</td>
						</tr>
					</table>
				</font>
				<br/>
			</p>
			<hr noshade="1" size="1"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="RECENT-ENTRIES">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:choose>
					<xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
						<!-- owner, full -->
						<!--
					<P>This is a list of the most recent Guide Entries you have created. <a href="dontpanic-entries">Click here for more information
					about Guide Entries.</a>
					</P>
					-->
						<xsl:for-each select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
							<xsl:apply-templates select="SITEID" mode="showfrom"/>
							<br/>
							<A>
								<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>A<xsl:value-of select="H2G2-ID"/>
							</A>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:value-of select="SUBJECT"/>
							<br/>
						(<xsl:apply-templates select="DATE-CREATED/DATE"/>)
						<xsl:choose>
								<xsl:when test="STATUS = 7">
									<xsl:value-of select="$m_cancelled"/>
									<xsl:if test="($ownerisviewer = 1)">
										<A>
											<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/>?cmd=undelete</xsl:attribute>(<xsl:value-of select="$m_uncancel"/>)</A>
									</xsl:if>
								</xsl:when>
								<xsl:when test="STATUS > 3 and STATUS != 7">
									<!-- show entry as 'edited' when it is waiting to go official -->
									<xsl:choose>
										<xsl:when test="STATUS = 13 or STATUS = 6">
											<xsl:value-of select="$m_pending"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$m_recommended"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="($ownerisviewer = 1) and (STATUS = 3 or STATUS = 4) and (EDITOR/USER/USERID = $viewerid)">
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								<A>
									<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/></xsl:attribute>edit</A>
							</xsl:if>
							<br/>
							<br/>
						</xsl:for-each>
						<A>
							<xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute>
							<xsl:value-of select="$m_clickmoreentries"/>
						</A>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<!-- owner empty -->
						<xsl:call-template name="m_artownerempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
						<!-- visitor full -->
						<!--
					<P>These are all the Guide Entries this Researcher has created. If you'd like
					to read them, click on the link, and if you want to talk about them, use the
					Discuss button when you get there.</P>
					-->
						<xsl:for-each select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
							<xsl:apply-templates select="SITEID" mode="showfrom"/>
							<br/>
							<A>
								<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>A<xsl:value-of select="H2G2-ID"/>
							</A>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:value-of select="SUBJECT"/>
							<br/>
						(<xsl:apply-templates select="DATE-CREATED/DATE"/>)
						<xsl:choose>
								<xsl:when test="STATUS = 7">
									<xsl:value-of select="$m_cancelled"/>
									<xsl:if test="($ownerisviewer = 1)">
										<A>
											<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/>?cmd=undelete</xsl:attribute>(<xsl:value-of select="$m_uncancel"/>)</A>
									</xsl:if>
								</xsl:when>
								<xsl:when test="STATUS > 3 and STATUS != 7">
									<!-- show entry as 'pending' when it is waiting to go official -->
									<xsl:choose>
										<xsl:when test="STATUS = 6 or STATUS = 13">
											<xsl:value-of select="$m_pending"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$m_recommended"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
							<xsl:if test="($ownerisviewer = 1) and (STATUS = 3 or STATUS = 4)">
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								<A>
									<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/></xsl:attribute>edit</A>
							</xsl:if>
							<br/>
							<br/>
						</xsl:for-each>
						<A>
							<xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute>
							<xsl:value-of select="$m_clickmoreentries"/>
						</A>
						<br/>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<!-- visitor empty -->
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
						<!--
					<P>This is a list of Approved Guide Entries to which you have contributed.
						<a href="A53209">Click here if you want to know what sort of thing the
						Editors are looking for</a>, or <a href="dontpanic-contrib">click here for more information
						about Approved Guide Entries and the editorial process.</a>
					</P>
					-->
						<xsl:for-each select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries]">
							<xsl:apply-templates select="SITEID" mode="showfrom"/>
							<br/>
							<A>
								<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>A<xsl:value-of select="H2G2-ID"/>
							</A>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:value-of select="SUBJECT"/>
							<br/>
						(<xsl:apply-templates select="DATE-CREATED/DATE"/>)
						<br/>
							<br/>
						</xsl:for-each>
						<A>
							<xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1</xsl:attribute>
							<xsl:value-of select="$m_clickmoreedited"/>
						</A>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="m_editownerempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ARTICLE-LIST/ARTICLE">
						<!--
					<P>These are all the Approved Guide Entries to which this Researcher has
						contributed. They obviously read the <A H2G2="A53209">Submissions Guidelines</A> 
						and submitted
						their Entries to the Editors: why don't you too?
					</P>
					-->
						<xsl:for-each select="ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries]">
							<xsl:apply-templates select="SITEID" mode="showfrom"/>
							<br/>
							<A>
								<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>A<xsl:value-of select="H2G2-ID"/>
							</A>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:value-of select="SUBJECT"/>
							<br/>
						(<xsl:apply-templates select="DATE-CREATED/DATE"/>)
						<br/>
							<br/>
						</xsl:for-each>
						<A>
							<xsl:attribute name="href"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1</xsl:attribute>
							<xsl:value-of select="$m_clickmoreedited"/>
						</A>
						<br/>
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
			<B>
				<xsl:value-of select="$m_whatpostlooklike"/>
			</B>
			<br/>
			<TABLE width="100%" cellpadding="0" cellspacing="0" border="0">
				<TR>
					<TD width="100%">
						<HR/>
					</TD>
					<TD width="100%">
						<HR/>
					</TD>
				</TR>
				<TR>
					<TD bgcolor="#CCFFFF">
						<font face="Arial, Helvetica, sans-serif" size="2" color="#000000">
							<xsl:value-of select="$m_fsubject"/>
							<xsl:value-of select="SUBJECT"/>
							<BR/>
						</font>
					</TD>
					<TD bgcolor="#CCFFFF">&nbsp;</TD>
				</TR>
				<TR>
					<TD>
						<font face="Arial, Helvetica, sans-serif" size="2" color="#000000">
							<xsl:apply-templates select="/H2G2/VIEWING-USER/USER/USERID" mode="UserName"/>
						:
						<xsl:apply-templates select="PREVIEWBODY"/>
							<br/>
						</font>
					</TD>
				</TR>
				<TR>
					<TD>
						<font color="#009999" size="1">
							<xsl:value-of select="$m_postedsoon2"/>
						</font>
						<BR/>
					</TD>
					<TD nowrap="1">
					
				</TD>
				</TR>
			</TABLE>
		</xsl:if>
	</xsl:template>
	<xsl:template match="POSTJOURNALFORM">
		<xsl:choose>
			<xsl:when test="WARNING">
				<B>
					<xsl:value-of select="$m_warningcolon"/>
				</B>
				<xsl:value-of select="WARNING"/>
			</xsl:when>
			<xsl:when test="PREVIEWBODY">
				<B>
					<xsl:value-of select="$m_journallooklike"/>
				</B>
				<hr/>
				<!-- TODO: check this rendering is same as actual journal entry -->
				<font size="3" face="Arial, Helvetica, sans-serif" color="#006666">
					<b>
						<xsl:value-of select="SUBJECT"/>
					</b>
					<br/>
				</font>
				<font size="2" face="Arial, Helvetica, sans-serif">
					<font color="{$headercolour}" size="1">
						<xsl:value-of select="$m_soon"/>
					</font>
					<br/>
					<br/>
				</font>
				<xsl:apply-templates select="PREVIEWBODY"/>
				<br/>
				<hr/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_journalintroUI"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="postpremoderationmessage"/>
		<xsl:apply-templates select="." mode="Form"/>
		<br/>
	</xsl:template>
	<!--
	template for CATEGORISATION - does the Guide categories box
-->
	<xsl:template match="CATEGORISATION">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5">
					<img width="5" height="5" src="{$imagesource}box_tl.gif" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_t.gif" width="100%">
					<img src="{$imagesource}box_t.gif" width="1" height="5" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_tr.gif" width="6" height="5" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
			<tr>
				<td background="{$imagesource}box_l.gif">
					<img src="{$imagesource}box_l.gif" width="5" height="1" border="0" vspace="0" hspace="0"/>
				</td>
				<td width="100%" bgcolor="{$catboxbg}">
					<table width="100%" cellpadding="3" cellspacing="0" border="0">
						<!--
					<tr>
						<td colspan="2">
							<div align="left" class="browse">
								<p class="browse">
									<font size="2" face="Arial, Helvetica, sans-serif">
										<b><font color="#006600">Ask h2g2</font></b>
									</font>
								</p>
							</div>
						</td>
					</tr>
-->
						<tr>
							<td>&nbsp;</td>
							<td>
								<p class="browse">
									<xsl:apply-templates select="CATEGORY"/>
								</p>
							</td>
						</tr>
						<!--
					<tr>
						<td colspan="2"><font size="2" face="Arial, Helvetica, sans-serif"><b><font color="#006600">Tell 
							h2g2</font></b></font> </td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<font size="1" face="Arial, Helvetica, sans-serif">
								<xsl:choose>
									<xsl:when test="/H2G2/VIEWING-USER/USER">
										<a href="/UserEdit">Click here</a>
										to add your own entry to the Guide
									</xsl:when>
									<xsl:otherwise>
										<a href="/Register">Click here</a> 
										to register so you can add your own entry to 
										the Guide
									</xsl:otherwise>
								</xsl:choose>
								<br/><br/>
							</font>
						</td>
					</tr>
-->
					</table>
				</td>
				<td background="{$imagesource}box_r.gif">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}box_bl.gif" width="5" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_b.gif">
					<img src="{$imagesource}box_b.gif" width="1" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_br.gif" width="6" height="6" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="CATEGORISATION[CATBLOCK]">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5">
					<img width="5" height="5" src="{$imagesource}box_tl.gif" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_t.gif" width="100%">
					<img src="{$imagesource}box_t.gif" width="1" height="5" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_tr.gif" width="6" height="5" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
			<tr>
				<td background="{$imagesource}box_l.gif">
					<img src="{$imagesource}box_l.gif" width="5" height="1" border="0" vspace="0" hspace="0"/>
				</td>
				<td width="100%" bgcolor="{$catboxbg}">
					<xsl:apply-templates/>
				</td>
				<td background="{$imagesource}box_r.gif">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}box_bl.gif" width="5" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_b.gif">
					<img src="{$imagesource}box_b.gif" width="1" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_br.gif" width="6" height="6" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
	</xsl:template>

<xsl:template name="fpb_thisblock">
<xsl:param name="blocknumber"/>
<xsl:param name="objectname"/>
<xsl:param name="PostRange"/>
				<img src="{$imagesource}buttons/yellow_posting_marker.gif" width="7" height="7" border="0">
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
				<img src="{$imagesource}buttons/green_posting_marker.gif" width="7" height="7" border="0">
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
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="postblockon">
			<xsl:value-of select="$imagesource"/>buttons/yellow_posting_marker.gif</xsl:variable>
		<xsl:variable name="postblockoff">
			<xsl:value-of select="$imagesource"/>buttons/green_posting_marker.gif</xsl:variable>
		<xsl:if test="$skip = 0">
			<font size="1">
				<br/>
			</font>
		</xsl:if>
		<xsl:if test="($skip mod $splitevery) = 0 and ($splitevery &gt; 0) and ($skip != 0)">
			<br/>
		</xsl:if>
		<a>
			<xsl:if test="$target!=''">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/>?<xsl:if test="$thread!=''">thread=<xsl:value-of select="$thread"/>&amp;</xsl:if>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
			<xsl:variable name="PostRange">
				<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="number($this) = number($skip)">
					<img src="{$postblockon}" border="0">
						<xsl:attribute name="alt"><xsl:value-of select="$alt_nowshowing"/><xsl:value-of select="$objectname"/><xsl:text> </xsl:text><xsl:value-of select="$PostRange"/></xsl:attribute>
					</img>
				</xsl:when>
				<xsl:otherwise>
					<img src="{$postblockoff}" border="0">
						<xsl:attribute name="alt"><xsl:value-of select="$alt_show"/><xsl:value-of select="$objectname"/><xsl:text> </xsl:text><xsl:value-of select="$PostRange"/></xsl:attribute>
					</img>
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
				<font size="1">
					<br/>
				</font>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="FRONTPAGE_STRAPLINE">
		<!--
	<td>&nbsp; </td>
	<td colspan="2"><img src="{$imagesource}theearthedition.gif" width="458" height="19"/></td>
	<! show todays date >
	<td valign="middle" nowrap="1">
		<font size="1" face="Arial, Helvetica, sans-serif">
			<xsl:apply-templates mode="DATE-ONLY" select="/H2G2/DATE"/>
		</font>
	</td>
-->
	</xsl:template>
	<xsl:template name="FRONTPAGE_LEFTCOL">
		<xsl:attribute name="width">200</xsl:attribute>
		<xsl:if test="$fpregistered=1">
			<p>
				<nobr>
					<font size="1" face="Arial, Helvetica, sans-serif">
						<img src="{$imagesource}blank.gif" width="200" height="3"/>
						<br/>
						<xsl:call-template name="m_welcomebackuser2line"/>
					</font>
				</nobr>
			</p>
		</xsl:if>
		<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION"/>
		<br/>
		<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN='2']">
			<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="FRONTPAGE_MAINBODY">
		<font face="{$fontface}">
			<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN!='2']">
				<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
			</xsl:apply-templates>
		</font>
	</xsl:template>
	<xsl:template name="SEARCH_LEFTCOL">
</xsl:template>
	<xsl:template name="FRONTPAGE_SIDEBAR">
		<!-- show todays date -->
		<font size="1" face="Arial, Helvetica, sans-serif">
			<xsl:apply-templates mode="DATE-ONLY" select="/H2G2/DATE"/>
		</font>
		<xsl:apply-templates select="/H2G2/TOP-FIVES"/>
	</xsl:template>
	<xsl:template name="SEARCH_SIDEBAR">
		<xsl:call-template name="showcategory"/>
	</xsl:template>
	<xsl:template name="USERPAGE_LEFTCOL">
		<xsl:attribute name="width">150</xsl:attribute>
		<img src="{$imagesource}blank.gif" width="150" height="1"/>
		<table width="100%" cellpadding="4">
			<tr valign="top">
				<td width="50%">
					<font face="Arial, Helvetica, sans-serif" size="2">
						<b>
							<xsl:value-of select="$mymessage"/>
							<xsl:value-of select="$m_mostrecentconv"/>
						</b>
						<!-- <img src="{$imagesource}icon_forum.gif" width="45" height="16" hspace="7"/>-->
					</font>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<p>
						<font face="Arial, Helvetica, sans-serif" size="1">
							<xsl:apply-templates select="RECENT-POSTS"/>
						</font>
					</p>
				</td>
			</tr>
			<tr valign="top">
				<td nowrap="1">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td>
					<font face="Arial, Helvetica, sans-serif" size="2">
						<b>
							<xsl:value-of select="$mymessage"/>
							<xsl:value-of select="$m_recententries"/>
							<!-- <img src="{$imagesource}icon_guide.gif" width="45" height="16" hspace="7"/>-->
							<br/>
							<xsl:if test="$ownerisviewer = 1">
								<a href="{$root}UserEdit" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('addguie1','','{$imagesource}buttons/addguide_ro.gif',1)">
									<img src="{$imagesource}buttons/addguide.gif" width="90" height="15" name="addguie1" alt="{$m_addguideentry}" border="0" vspace="3"/>
								</a>
								<br/>
							</xsl:if>
						</b>
					</font>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<p>
						<font face="Arial, Helvetica, sans-serif" size="1">
							<xsl:apply-templates select="RECENT-ENTRIES"/>
						</font>
					</p>
				</td>
			</tr>
			<tr valign="top">
				<td nowrap="1">&nbsp;</td>
			</tr>
			<tr valign="top">
				<td>
					<font face="Arial, Helvetica, sans-serif" size="2">
						<b>
							<xsl:value-of select="$mymessage"/>
							<xsl:value-of select="$m_mostrecentedited"/>
						</b>
						<!-- <img src="{$imagesource}icon_appguide.gif" width="45" height="16"/>-->
					</font>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<p>
						<font face="Arial, Helvetica, sans-serif" size="1">
							<xsl:apply-templates select="RECENT-APPROVALS"/>
						</font>
					</p>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="USERPAGE_MAINBODY">
		<br/>
		<!-- do the article or give the default message -->
		<xsl:choose>
			<xsl:when test="$test_introarticle">
				<!-- do any error reports before anything else
												 currently just says if there is an error, but could give more info
											-->
				<xsl:if test="ARTICLE/ERROR">
					<p>
						<font face="Arial, Helvetica, sans-serif" size="2">
							<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<xsl:call-template name="m_pserrorowner"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="m_pserrorviewer"/>
								</xsl:otherwise>
							</xsl:choose>
						</font>
					</p>
				</xsl:if>
				<!-- do any intro section if it exists -->
				<xsl:apply-templates select="ARTICLE/GUIDE/INTRO"/>
				<!-- do the body of the article -->
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
						<xsl:apply-templates select="ARTICLE/GUIDE/BODY"/>
						<!-- do the footnotes if any -->
						<xsl:if test=".//FOOTNOTE">
							<blockquote>
								<font size="-1">
									<hr/>
									<xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
								</font>
							</blockquote>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<font face="arial, helvetica, sans-serif" size="2">
							<xsl:call-template name="m_psintroowner"/>
						</font>
					</xsl:when>
					<xsl:otherwise>
						<font face="arial, helvetica, sans-serif" size="2">
							<xsl:call-template name="m_psintroviewer"/>
						</font>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<br/>
		<!-- check we have a forum first -->
		<xsl:if test="ARTICLEFORUM">
			<!-- place the Discuss This Entry header -->
			<xsl:apply-templates select="ARTICLEFORUM/FORUMTHREADS"/>
		</xsl:if>
		<!-- end of discussion/forum postings bit -->
		<xsl:apply-templates select="JOURNAL">
			<xsl:with-param name="mymessage">
				<xsl:value-of select="$mymessage"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<table width="100%">
			<tr valign="top">
				<td width="100%" colspan="2">
					<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}headerbar.gif" width="100%">
								<img src="{$imagesource}headerbar.gif" width="300" height="4"/>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr valign="top">
				<td width="100%" colspan="2">
					<font face="Arial, Helvetica, sans-serif" size="2">
						<br/>
						<b>
							<font size="4">
								<xsl:value-of select="$mymessage"/>Friends</font>
							<!--<img src="{$imagesource}icon_journal.gif" width="45" height="16" hspace="7"/>-->
							<br/>
						</b>
					</font>
				</td>
			</tr>
			<tr valign="top">
				<td>
					<p>
						<font face="Arial, Helvetica, sans-serif" size="1">
							<br/>
						</font>
					</p>
				</td>
				<td>
					<font face="arial, helvetica, sans-serif" size="2">
						<xsl:apply-templates select="WATCHED-USER-LIST"/>
						<xsl:apply-templates select="WATCHING-USER-LIST"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="USERPAGE_SIDEBAR">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5">
					<img width="5" height="5" src="{$imagesource}box_tl.gif" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_t.gif" width="100%">
					<img src="{$imagesource}box_t.gif" width="1" height="5" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_tr.gif" width="6" height="5" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
			<tr>
				<td background="{$imagesource}box_l.gif">
					<img src="{$imagesource}box_l.gif" width="5" height="1" border="0" vspace="0" hspace="0"/>
				</td>
				<td width="100%" bgcolor="{$boxoutcolour}">
					<!-- do the user data sidebar -->
					<xsl:apply-templates select="/H2G2/PAGE-OWNER"/>
					<xsl:apply-templates select="ARTICLE/ARTICLEINFO/REFERENCES"/>
				</td>
				<td background="{$imagesource}box_r.gif">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}box_bl.gif" width="5" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_b.gif">
					<img src="{$imagesource}box_b.gif" width="1" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_br.gif" width="6" height="6" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
		<br/>
	</xsl:template>
	<xsl:template name="displayunregisteredslug">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5">
					<img width="5" height="5" src="{$imagesource}box_tl.gif" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_t.gif" width="100%">
					<img src="{$imagesource}box_t.gif" width="1" height="5" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_tr.gif" width="6" height="5" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
			<tr>
				<td background="{$imagesource}box_l.gif">
					<img src="{$imagesource}box_l.gif" width="5" height="1" border="0" vspace="0" hspace="0"/>
				</td>
				<td width="100%" bgcolor="{$boxoutcolour}">
					<xsl:call-template name="unregisteredslug"/>
				</td>
				<td background="{$imagesource}box_r.gif">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}box_bl.gif" width="5" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_b.gif">
					<img src="{$imagesource}box_b.gif" width="1" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_br.gif" width="6" height="6" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="BOXHOLDER">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="CODE|PRE">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<font size="+1">
				<xsl:apply-templates select="*|text()"/>
			</font>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="navbar">
		<xsl:param name="whichone"/>
		<td colspan="2" background="{$imagesource}navbar.gif">
			<xsl:choose>
				<xsl:when test="PAGEUI/REGISTER[@VISIBLE=1]">
					<!--a target="_top" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Register{$whichone}','','{$imagesource}regnav/register_ro.gif',1)">
						<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_register"/></xsl:attribute>
						<img src="{$imagesource}regnav/register.gif" width="62" height="27" hspace="0" vspace="0" name="Register{$whichone}" alt="{$alt_register}" title="{$m_registertitle}" border="0"/>
					</a-->
					<a target="_top" href="{$frontpageurl}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Frontpage{$whichone}','','{$imagesource}regnav/frontpage2_ro.gif',1)">
						<img src="{$imagesource}regnav/frontpage2.gif" width="71" height="27" vspace="0" hspace="0" border="0" alt="{$alt_frontpage}" title="{$alt_logotext}" name="Frontpage{$whichone}"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a target="_top" href="{$frontpageurl}" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Frontpage{$whichone}','','{$imagesource}regnav/frontpage_ro.gif',1)">
						<img src="{$imagesource}regnav/frontpage.gif" width="75" height="27" vspace="0" hspace="0" border="0" alt="{$alt_frontpage}" title="{$alt_logotext}" name="Frontpage{$whichone}"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
	
			<xsl:if test="PAGEUI/MYHOME[@VISIBLE=1]">
				<a target="_top" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('MyHome{$whichone}','','{$imagesource}regnav/myspace_ro.gif',1)">
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_myhome"/></xsl:attribute>
					<img src="{$imagesource}regnav/myspace.gif" width="65" height="27" vspace="0" hspace="0" alt="{$alt_myspace}" title="{$m_myspacetitle}" name="MyHome{$whichone}" border="0"/>
				</a>
			</xsl:if>
			<a target="_top" href="{$root}Read" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Read{$whichone}','','{$imagesource}regnav/read_ro.gif',1)">
				<img src="{$imagesource}regnav/read.gif" vspace="0" hspace="0" border="0" alt="{$alt_read}" title="{$m_readtitle}" name="Read{$whichone}"/>
			</a>
			<a target="_top" href="{$root}Talk" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Talk{$whichone}','','{$imagesource}regnav/talk_ro.gif',1)">
				<img src="{$imagesource}regnav/talk.gif" vspace="0" hspace="0" border="0" alt="{$alt_talk}" title="{$m_talktitle}" name="Talk{$whichone}"/>
			</a>
			<a target="_top" href="{$root}Contribute" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Contribute{$whichone}','','{$imagesource}regnav/contribute_ro.gif',1)">
				<img src="{$imagesource}regnav/contribute.gif" vspace="0" hspace="0" border="0" alt="{$alt_contribute}" title="{$m_contributetitle}" name="Contribute{$whichone}"/>
			</a>
			<xsl:if test="PAGEUI/DONTPANIC[@VISIBLE=1]">
				<a target="_top" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('DontPanic{$whichone}','','{$imagesource}regnav/help_ro.gif',1)">
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_dontpanic"/></xsl:attribute>
					<img src="{$imagesource}regnav/help.gif" vspace="0" hspace="0" border="0" alt="{$alt_help}" title="{$alt_dontpanic}" name="DontPanic{$whichone}"/>
				</a>
			</xsl:if>
			<a target="_top" href="{$root}Feedback" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Feedback{$whichone}','','{$imagesource}regnav/feedback_ro.gif',1)">
				<img src="{$imagesource}regnav/feedback.gif" width="63" height="27" vspace="0" hspace="0" border="0" alt="{$alt_feedbackforum}" title="{$m_feedbacktitle}" name="Feedback{$whichone}"/>
			</a>
			<a href="javascript:popusers('{$root}online');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('WhosOnLine{$whichone}','','{$imagesource}regnav/whosonline_ro.gif',1)">
				<img src="{$imagesource}regnav/whosonline.gif" width="79" height="27" vspace="0" hspace="0" border="0" alt="{$alt_whosonline}" title="{$m_onlinetitle}" name="WhosOnLine{$whichone}"/>
			</a>
			<!--
					<a target="_top" href="{$root}Shop" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Shop{$whichone}','','{$imagesource}regnav/shop_ro.gif',1)"><img src="{$imagesource}regnav/shop.gif" width="43" height="27" hspace="0" vspace="0" border="0" alt="{$alt_shop}" title="{$m_shoptitle}" name="Shop{$whichone}"/></a>
					<a target="_top" href="{$root}AboutUs" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Company{$whichone}','','{$imagesource}regnav/aboutus_ro.gif',1)"><img src="{$imagesource}regnav/aboutus.gif" width="64" height="27" vspace="0" hspace="0" border="0" alt="{$alt_aboutus}" title="{$m_aboutustitle}" name="Company{$whichone}"/></a>
					-->
			<xsl:if test="PAGEUI/MYDETAILS[@VISIBLE=1]">
				<a target="_top" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Preferences{$whichone}','','{$imagesource}regnav/preferences_ro.gif',1)">
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_mydetails"/></xsl:attribute>
					<img src="{$imagesource}regnav/preferences.gif" width="75" height="27" vspace="0" hspace="0" border="0" alt="{$alt_preferences}" title="{$alt_preferencestitle}" name="Preferences{$whichone}"/>
				</a>
			</xsl:if>
			<!--xsl:if test="PAGEUI/LOGOUT[@VISIBLE=1]">
				<a target="_top" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Logout{$whichone}','','{$imagesource}regnav/logout_ro.gif',1)" onclick="confirm_logout();return false;">
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_logout"/></xsl:attribute>
					<img src="{$imagesource}regnav/logout.gif" width="53" height="27" vspace="0" hspace="0" border="0" alt="{$alt_logout}" title="{$m_logouttitle}" name="Logout{$whichone}"/>
				</a>
			</xsl:if-->
			<!--xsl:if test="PAGEUI/REGISTER[@VISIBLE=1]">
				<a target="_top" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Login{$whichone}','','{$imagesource}regnav/login_ro.gif',1)">
					<xsl:attribute name="href"><xsl:value-of select="$root"/>login</xsl:attribute>
					<img src="{$imagesource}regnav/login.gif" width="48" height="27" hspace="0" vspace="0" name="Login{$whichone}" alt="{$alt_login}" title="{$alt_login}" border="0"/>
				</a>
			</xsl:if-->
		</td>
	</xsl:template>
	<xsl:template match="ADVERTS">
		<xsl:variable name="adcount">
			<xsl:value-of select="round(number(/H2G2/PAGEUI/BANNER[@NAME='small']/@SEED) mod (count(ADVERT)+1))"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$adcount = 0">
				<a target="_top" href="{$root}adlink">
					<img src="smallad" width="200" height="60" vspace="7" hspace="0" border="0"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a target="_top" href="{$root}{ADVERT[position() = $adcount]/@H2G2}">
					<img src="{ADVERT[position() = $adcount]/@SRC}" width="200" height="60" vspace="7" hspace="0" border="0" alt="{ADVERT[position() = $adcount]/@ALT}"/>
				</a>
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
	<xsl:template name="REVIEWFORUM_SIDEBAR">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="5">
					<img width="5" height="5" src="{$imagesource}box_tl.gif" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_t.gif" width="100%">
					<img src="{$imagesource}box_t.gif" width="1" height="5" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_tr.gif" width="6" height="5" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
			<tr>
				<td background="{$imagesource}box_l.gif">
					<img src="{$imagesource}box_l.gif" width="5" height="1" border="0" vspace="0" hspace="0"/>
				</td>
				<td width="100%" bgcolor="#CCFFFF">
					<table width="100%" cellpadding="3" cellspacing="0" border="0">
						<tr>
							<td colspan="2">
								<div align="left" class="browse">
									<font size="1" face="Arial, Helvetica, sans-serif">
										<p class="browse">
											<b>
												<font size="3">
													<xsl:value-of select="$m_reviewforumdatatitle"/>
												</font>
											</b>
										</p>
										<xsl:value-of select="$m_reviewforumdataname"/>
										<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
										<br/>
										<xsl:value-of select="$m_reviewforumdataurl"/>
										<xsl:value-of select="REVIEWFORUM/URLFRIENDLYNAME"/>
										<br/>
										<xsl:choose>
											<xsl:when test="REVIEWFORUM/RECOMMENDABLE=1">
												<xsl:value-of select="$m_reviewforumdata_recommend_yes"/>
												<br/>
												<xsl:value-of select="$m_reviewforumdata_incubate"/>
												<xsl:value-of select="REVIEWFORUM/INCUBATETIME"/> days
										<br/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$m_reviewforumdata_recommend_no"/>
												<br/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
											<xsl:value-of select="$m_reviewforumdata_h2g2id"/>
											<A>
												<xsl:attribute name="HREF">A<xsl:value-of select="REVIEWFORUM/H2G2ID"/></xsl:attribute>A<xsl:value-of select="REVIEWFORUM/H2G2ID"/>
											</A>
											<br/>
											<a>
												<xsl:attribute name="HREF"><xsl:value-of select="$root"/>EditReview?id=<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute>
												<xsl:value-of select="$m_reviewforumdata_edit"/>
											</a>
										</xsl:if>
									</font>
								</div>
							</td>
						</tr>
					</table>
				</td>
				<td background="{$imagesource}box_r.gif">&nbsp;</td>
			</tr>
			<tr>
				<td>
					<img src="{$imagesource}box_bl.gif" width="5" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td background="{$imagesource}box_b.gif">
					<img src="{$imagesource}box_b.gif" width="1" height="6" border="0" vspace="0" hspace="0"/>
				</td>
				<td>
					<img src="{$imagesource}box_br.gif" width="6" height="6" border="0" vspace="0" hspace="0"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="LOGOUT_MAINBODY">
		<blockquote>
			<xsl:call-template name="m_logoutblurb2"/>
		</blockquote>
	</xsl:template>
	<xsl:template match="QUOTE">
		<xsl:choose>
			<xsl:when test="not(parent::QUOTE)">
				<blockquote class="quoteFirst">
					<xsl:choose>
						<xsl:when test="@USERID">
							<xsl:apply-templates/>
							<p class="quotefrom">Quoted <a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;post={../../@INREPLYTO}#p{../../@INREPLYTO}">
							message</a> from 
							
							<xsl:choose>
									<xsl:when test="@USERID = /H2G2/FORUMTHREADPOSTS/POST/USER/USERID">
										<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/POST[USER/USERID = current()/@USERID]/USER/USERNAME"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@USERNAME"/>
									</xsl:otherwise>
								</xsl:choose>
							</p>
							<br/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
							<p class="quotefrom">Quoted from <a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;post={../../@INREPLYTO}#p{../../@INREPLYTO}">
								this message</a>
							</p>
							<br/>
						</xsl:otherwise>
					</xsl:choose>
				</blockquote>
			</xsl:when>
			<xsl:when test="count(ancestor::*) &gt; 6">
				<xsl:choose>
					<xsl:when test="ancestor::POST/@INDEX mod 2 = 0">
						<div class="extraquotes2">
							<xsl:apply-templates select="node()[not(name()='QUOTE')]"/>
						</div>
						<xsl:apply-templates select="*"/>
					</xsl:when>
					<xsl:otherwise>
						<div class="extraquotes">
							<xsl:apply-templates select="node()[not(name()='QUOTE')]"/>
						</div>
						<xsl:apply-templates select="*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<blockquote>
					<xsl:apply-templates/>
				</blockquote>
			</xsl:otherwise>
		</xsl:choose>
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
				<xsl:value-of select="USER/USERNAME"/>
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
