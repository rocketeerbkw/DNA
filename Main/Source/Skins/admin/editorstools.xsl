<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:include href="admin-artcheckpage.xsl"/>
  <xsl:include href="admin-commentforumlist.xsl"/>
	<xsl:include href="admin-diagnosepage.xsl"/>
	<xsl:include href="admin-edit-postpage.xsl"/>
	<xsl:include href="admin-editreviewpage.xsl"/>
	<xsl:include href="admin-forum-moderationpage.xsl"/>
	<xsl:include href="admin-frontpage_editorpage.xsl"/>
	<xsl:include href="admin-group-managementpage.xsl"/>
	<xsl:include href="admin-image-moderationpage.xsl"/>
	<xsl:include href="admin-inspectuserpage.xsl"/>
	<xsl:include href="admin-keyarticle-editorpage.xsl"/>
	<xsl:include href="admin-moderate-homepage.xsl"/>
	<xsl:include href="admin-moderate-nicknamespage.xsl"/>
	<xsl:include href="admin-moderate-statspage.xsl"/>
	<xsl:include href="admin-moderation-billingpage.xsl"/>
	<!--<xsl:include href="admin-moderate-manage-fast-mod.xsl"/>-->
	<xsl:include href="admin-moderation-form-framepage.xsl"/>
	<xsl:include href="admin-moderation-historypage.xsl"/>
	<xsl:include href="admin-moderationstatuspage.xsl"/>
	<xsl:include href="admin-moderation-top-framepage.xsl"/>
	<xsl:include href="admin-move-threadpage.xsl"/>
	<xsl:include href="admin-newmod-assetmoderationpage.xsl"/>
	<xsl:include href="admin-newmod-distressmessageadminpage.xsl"/>
	<xsl:include href="admin-newmod-managefastmod.xsl"/>
	<xsl:include href="admin-newmod-nicknamemoderationpage.xsl"/>
	<xsl:include href="admin-newmod-postmoderationpage.xsl"/>
  <xsl:include href="admin-newmod-linksmoderationpage.xsl"/>
	<xsl:include href="admin-newmod-usershomepage.xsl"/>
	<xsl:include href="admin-newmod-userdetailspage.xsl"/>
  <xsl:include href="admin-newmod-sitesummary.xsl"/>
  <xsl:include href="admin-newmod-memberdetails.xsl"/>
  <xsl:include href="admin-newmod-sitemanager.xsl"/>
  <xsl:include href="admin-process-recommendationspage.xsl"/>
  <xsl:include href="admin-redirectpage.xsl"/>
  <xsl:include href="admin-scout-recommendationspage.xsl"/>
  <xsl:include href="admin-shareandenjoypage.xsl"/>
  <xsl:include href="admin-siteadminpage.xsl"/>
  <xsl:include href="admin-siteoptions.xsl"/>
  <xsl:include href="admin-statuspage.xsl"/>
  <xsl:include href="admin-sub-allocationpage.xsl"/>
  <xsl:include href="admin-subbed-article-statuspage.xsl"/>
  <xsl:include href="admin-tagitem_editorpage.xsl"/>
  <xsl:include href="admin-topfive-editorpage.xsl"/>
  <xsl:include href="admin-urlfilteradmin.xsl"/>
  <xsl:include href="admin-userstatisticspage.xsl"/>
  <xsl:include href="admin-contentsignifpage.xsl"/>
  <xsl:include href="admin-moderatormanagementpage.xsl"/>
  <xsl:include href="admin-moderationemailpage.xsl"/>
  <xsl:include href="admin-profanityadminpage.xsl"/>
  
  <!-- ************************************************** -->
	<!-- Seperating out the admin pages from the ordinary primary-template -->
	<!-- ************************************************** -->
	<!-- ************************************************** -->
  <xsl:variable name="asset-root">
    <xsl:choose>
      <xsl:when test="contains(/H2G2/SERVERNAME, 'OPS-DNA')">
        <xsl:text>/dnaimages/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>/dnaimages/</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
	<xsl:template name="admin-template">
		<html>
			<xsl:call-template name="insert-header"/>
			<body>
				<xsl:call-template name="insert-mainbody"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="newmod-template">
		<html>
			<head>
				<title>
					<xsl:value-of select="$m_pagetitlestart"/>
					<xsl:choose>
						<xsl:when test="/H2G2/@TYPE = 'DISTRESSMESSAGESADMIN'">
							<xsl:text>Distress Message Admin</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'MANAGE-FAST-MOD'">
							<xsl:text>Manage Fast Mod</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'MEDIAASSET-MODERATION'">
							<xsl:text>Media Assets</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'NICKNAME-MODERATION'">
							<xsl:text>Nicknames</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'POST-MODERATION'">
							<xsl:text>Posts</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'USERS-HOMEPAGE'">
							<xsl:text>Users</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'USER-DETAILS-PAGE'">
							<xsl:text>User Details</xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE = 'ARTICLE'">
							<xsl:text>Article</xsl:text>
						</xsl:when>
            <xsl:when test="/H2G2/@TYPE = 'SITESUMMARY'">
              <xsl:text>Site Summary</xsl:text>
            </xsl:when>
            <xsl:when test="/H2G2/@TYPE = 'LINKS-MODERATION'">
              <xsl:text>External Links</xsl:text>
            </xsl:when>
					</xsl:choose>
				</title>
				<link type="text/css" rel="stylesheet" href="{$asset-root}moderation/includes/moderation.css"/>
				<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login.css"/>
				<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login2.css"/>
				<xsl:choose>
					<xsl:when test="/H2G2/@TYPE = 'USERS-HOMEPAGE' or /H2G2/@TYPE = 'USER-DETAILS-PAGE' or /H2G2/@TYPE = 'NICKNAME-MODERATION' or /H2G2/@TYPE = 'DISTRESSMESSAGESADMIN'">
						<link type="text/css" rel="stylesheet" href="{$asset-root}moderation/includes/members.css"/>
					</xsl:when>
					<xsl:when test="/H2G2/@TYPE = 'MANAGE-FAST-MOD'">
						<link type="text/css" rel="stylesheet" href="{$asset-root}moderation/includes/managefastmod.css"/>
					</xsl:when>
				</xsl:choose>
				<script type="text/javascript" src="{$asset-root}moderation/includes/moderation.js"/>
				<xsl:if test="/H2G2/@TYPE = 'POST-MODERATION'">
					<script type="text/javascript" src="{$asset-root}moderation/includes/moderation_posts.js"/>
				</xsl:if>
			</head>
			<body>
				<xsl:choose>
					<xsl:when test="/H2G2/@TYPE = 'USER-DETAILS-PAGE'">
						<xsl:attribute name="onload">durationChange()</xsl:attribute>
					</xsl:when>
					<!--<xsl:when test="/H2G2/@TYPE = 'POST-MODERATION' or /H2G2/@TYPE = 'MEDIAASSET-MODERATION' ">
						<xsl:attribute name="onload">initialiseForm()</xsl:attribute>
					</xsl:when>-->
				</xsl:choose>
				<xsl:call-template name="sso_statusbar-admin"/>
				<h1>
					<img src="{$asset-root}moderation/images/dna_logo.jpg" width="179" height="48" alt="DNA"/>
				</h1>
				<ul id="siteNavigation">
					<li>
						<xsl:attribute name="class"><xsl:choose><xsl:when test="/H2G2/@TYPE = 'POST-MODERATION'">selected</xsl:when><xsl:when test="/H2G2/@TYPE = 'MEDIA-MODERATION'">selected</xsl:when><xsl:when test="/H2G2/@TYPE = 'NICKNAME-MODERATION'">selected</xsl:when><xsl:when test="/H2G2/@TYPE = 'MANAGE-FAST-MOD'">selected</xsl:when><xsl:when test="/H2G2/@TYPE = 'DISTRESSMESSAGESADMIN'">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
						<a href="moderate?newstyle=1&amp;fastmod=0&amp;notfastmod=0">Main</a>
					</li>
					<!--<li>
						<a href="#">My History</a>
					</li>
					<li class="selected">
						<a href="#">All Histories</a>
					</li>-->
					<xsl:if test="$test_IsEditor">
						<li>
							<xsl:attribute name="class"><xsl:choose><xsl:when test="/H2G2/@TYPE = 'USERS-HOMEPAGE' or /H2G2/@TYPE = 'USER-DETAILS-PAGE'">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
							<!--<a href="members?show=10&amp;skip=0&amp;direction=0&amp;sortedon=nickname&amp;siteid=1&amp;s_classview=1">Members</a>-->
							<a href="memberlist">
								<xsl:text>Members</xsl:text>
							</a>
						</li>
					</xsl:if>
				</ul>
				<xsl:call-template name="insert-mainbody"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="DATE" mode="mod-system-format">
		<xsl:value-of select="@HOURS"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="@MINUTES"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@DAYNAME"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="@DAY"/>
		<xsl:choose>
			<xsl:when test="@DAY = '1' or @DAY = '21' or @DAY = '31'">
				<xsl:text>st</xsl:text>
			</xsl:when>
			<xsl:when test="@DAY = '2' or @DAY = '22'">
				<xsl:text>nd</xsl:text>
			</xsl:when>
			<xsl:when test="@DAY = '3' or @DAY = '23'">
				<xsl:text>rd</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>th</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@MONTHNAME"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@YEAR"/>
	</xsl:template>
	<!-- ************************************************** -->
	<!-- Seperating out the admin pages from the ordinary primary-template -->
	<!-- ************************************************** -->
	<!-- ************************************************** -->
	<xsl:variable name="mainfontcolour">#000000</xsl:variable>
	<xsl:variable name="boxfontcolour">#000000</xsl:variable>
	<!-- light blue -->
	<!-- number of category members beyond which the display will split into two columns -->
	<xsl:variable name="catcolcount">16</xsl:variable>
	<xsl:variable name="fontsize">2</xsl:variable>
	<xsl:variable name="fontface">Arial, Helvetica, sans-serif</xsl:variable>
	<xsl:variable name="catfontheadersize">5</xsl:variable>
	<xsl:variable name="catfontheadercolour">blue</xsl:variable>
	<xsl:variable name="forumsourcelink">green</xsl:variable>
	<xsl:variable name="WarningMessageColour">red</xsl:variable>
	<!-- colour of the errors displayed when editing articles-->
	<xsl:variable name="xmlerror">#FF0000</xsl:variable>
	<xsl:variable name="alinkcolour">#FF00FF</xsl:variable>
	<xsl:variable name="linkcolour">#0000BB</xsl:variable>
	<xsl:variable name="vlinkcolour">#880088</xsl:variable>
	<xsl:variable name="bgcolour">#FFFFFF</xsl:variable>
	<!--

	<xsl:attribute-set name="catfontheader" use-attribute-sets="catfont">

	Purpose:	Header font on categorisation page

-->
	<xsl:attribute-set name="catfontheader" use-attribute-sets="catfont"/>
	<xsl:attribute-set name="catfont" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="forumsourcelink" use-attribute-sets="forumsource"/>
	<xsl:attribute-set name="forumsource" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="WarningMessageFont" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="xmlerrorfont" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="body"/>
	<!--

	<xsl:attribute-set name="headerfont" use-attribute-sets="mainfont">

	Purpose:	Font style for headers

-->
	<xsl:attribute-set name="headerfont" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="forumblockson" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="forumblocksoff" use-attribute-sets="mainfont"/>
	<!--

	<xsl:template name="HEADER">
	Purpose:	Default way of presenting a HEADER element

-->
	<xsl:template name="HEADER">
		<xsl:param name="text">?????</xsl:param>
		<br clear="all"/>
		<font xsl:use-attribute-sets="headerfont">
			<b>
				<NOBR>
					<xsl:value-of select="$text"/>
				</NOBR>
			</b>
		</font>
		<br/>
	</xsl:template>
	<!--

	<xsl:template name="forumpostblocks">

	Generic:	No
	Purpose:	Show one item per block

-->
	<xsl:template name="forumpostblocks">
		<xsl:param name="attributes"/>
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="blocklimit">20</xsl:param>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="limit">
			<xsl:value-of select="number($blocklimit) * $show"/>
		</xsl:variable>
		<xsl:variable name="lower">
			<xsl:choose>
				<xsl:when test="$limit = 0">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(floor($this div $limit))*$limit"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="upper">
			<xsl:choose>
				<xsl:when test="$limit = 0">
					<xsl:value-of select="$total + $show"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$lower + $limit"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="forumpostblocks_first">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="$lower"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
			<xsl:with-param name="limit" select="$limit"/>
			<xsl:with-param name="lower" select="$lower"/>
			<xsl:with-param name="upper" select="$upper"/>
			<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
			<!--<xsl:with-param name="blocklimit" select="$blocklimit"/>-->
		</xsl:call-template>
		<xsl:call-template name="forumpostblocks_previous">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="$lower"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
			<xsl:with-param name="limit" select="$limit"/>
			<xsl:with-param name="lower" select="$lower"/>
			<xsl:with-param name="upper" select="$upper"/>
			<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
			<!--<xsl:with-param name="blocklimit" select="$blocklimit"/>-->
		</xsl:call-template>
		<xsl:call-template name="forumpostblocks_loop">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="$lower"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
			<xsl:with-param name="limit" select="$limit"/>
			<xsl:with-param name="lower" select="$lower"/>
			<xsl:with-param name="upper" select="$upper"/>
			<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
			<!--<xsl:with-param name="blocklimit" select="$blocklimit"/>-->
		</xsl:call-template>
		<xsl:if test="$splitevery &gt; 0">
			<br/>
		</xsl:if>
		<xsl:call-template name="forumpostblocks_next">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="$lower"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
			<xsl:with-param name="limit" select="$limit"/>
			<xsl:with-param name="lower" select="$lower"/>
			<xsl:with-param name="upper" select="$upper"/>
			<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
			<!--<xsl:with-param name="blocklimit" select="$blocklimit"/>-->
		</xsl:call-template>
		<xsl:call-template name="forumpostblocks_last">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="$lower"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
			<xsl:with-param name="limit" select="$limit"/>
			<xsl:with-param name="lower" select="$lower"/>
			<xsl:with-param name="upper" select="$upper"/>
			<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
			<!--<xsl:with-param name="blocklimit" select="$blocklimit"/>-->
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="forumpostblocks_first">
		<xsl:param name="attributes"/>
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="limit"/>
		<xsl:param name="lower"/>
		<xsl:param name="upper"/>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="PostRange">
			<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
		</xsl:variable>
		<xsl:if test="$lower &gt; 0">
			<xsl:call-template name="fpb_beforefirst"/>
			<a>
				<xsl:if test="$target!=''">
					<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose><xsl:when test="$thread!=''">?thread=<xsl:value-of select="$thread"/>&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>skip=0&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
				<xsl:attribute name="TITLE"><xsl:value-of select="$alt_show"/>First <xsl:value-of select="$objectname"/></xsl:attribute>
				<xsl:call-template name="fpb_start"/>
			</a>
			<xsl:call-template name="fpb_afterfirst"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="forumpostblocks_previous">
		<xsl:param name="attributes"/>
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="limit"/>
		<xsl:param name="lower"/>
		<xsl:param name="upper"/>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="PostRange">
			<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
		</xsl:variable>
		<xsl:if test="$lower &gt; 0">
			<xsl:call-template name="fpb_beforeprev"/>
			<a>
				<xsl:if test="$target!=''">
					<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose><xsl:when test="$thread!=''">?thread=<xsl:value-of select="$thread"/>&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>skip=<xsl:value-of select="$lower - $show"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
				<xsl:attribute name="TITLE"><xsl:value-of select="$alt_show"/>More <xsl:value-of select="$objectname"/></xsl:attribute>
				<xsl:call-template name="fpb_prevset"/>
			</a>
			<xsl:call-template name="fpb_afterprev"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="forumpostblocks_next">
		<xsl:param name="attributes"/>
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="limit"/>
		<xsl:param name="lower"/>
		<xsl:param name="upper"/>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="PostRange">
			<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
		</xsl:variable>
		<xsl:if test="(number($upper) + number($show)) &lt; number($total)">
			<xsl:call-template name="fpb_beforenext"/>
			<a>
				<xsl:if test="$target!=''">
					<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose><xsl:when test="$thread!=''">?thread=<xsl:value-of select="$thread"/>&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>skip=<xsl:value-of select="$upper"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
				<xsl:attribute name="TITLE"><xsl:value-of select="$alt_show"/>More <xsl:value-of select="$objectname"/></xsl:attribute>
				<xsl:call-template name="fpb_nextset"/>
			</a>
			<xsl:call-template name="fpb_afternext"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="forumpostblocks_last">
		<xsl:param name="attributes"/>
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="limit"/>
		<xsl:param name="lower"/>
		<xsl:param name="upper"/>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="PostRange">
			<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
		</xsl:variable>
		<xsl:variable name="lastpage">
			<xsl:value-of select="(floor((number($total)-1) div $show))*$show"/>
		</xsl:variable>
		<xsl:if test="(number($upper) + number($show)) &lt; number($total)">
			<xsl:call-template name="fpb_beforelast"/>
			<a>
				<xsl:if test="$target!=''">
					<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose><xsl:when test="$thread!=''">?thread=<xsl:value-of select="$thread"/>&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>skip=<xsl:value-of select="$lastpage"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
				<xsl:attribute name="TITLE"><xsl:value-of select="$alt_show"/>Last <xsl:value-of select="$objectname"/></xsl:attribute>
				<xsl:call-template name="fpb_end"/>
			</a>
		</xsl:if>
		<xsl:call-template name="fpb_afterlast"/>
	</xsl:template>
	<xsl:template name="fpb_beforefirst"/>
	<xsl:template name="fpb_afterfirst"/>
	<xsl:template name="fpb_beforeprev"/>
	<xsl:template name="fpb_afterprev"/>
	<xsl:template name="fpb_beforenext"/>
	<xsl:template name="fpb_afternext"/>
	<xsl:template name="fpb_beforelast"/>
	<xsl:template name="fpb_afterlast"/>
	<xsl:template name="forumpostblocks_loop">
		<xsl:param name="attributes"/>
		<xsl:param name="thread"/>
		<xsl:param name="forum"/>
		<xsl:param name="total"/>
		<xsl:param name="show">20</xsl:param>
		<xsl:param name="skip">0</xsl:param>
		<xsl:param name="this">0</xsl:param>
		<xsl:param name="url">F</xsl:param>
		<xsl:param name="limit"/>
		<xsl:param name="lower"/>
		<xsl:param name="upper"/>
		<xsl:param name="splitevery">0</xsl:param>
		<xsl:param name="objectname">
			<xsl:value-of select="$m_postings"/>
		</xsl:param>
		<xsl:param name="target">_top</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:variable name="postblockon">
			<xsl:value-of select="$imagesource2"/>buttons/forumselected.gif</xsl:variable>
		<xsl:variable name="postblockoff">
			<xsl:value-of select="$imagesource2"/>buttons/forumunselected.gif</xsl:variable>
		<xsl:variable name="actualskip">
			<xsl:choose>
				<xsl:when test="$skip=-1">
					<xsl:value-of select="$lower"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$skip"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="(number($skip) > 0) or ((number($skip)) &lt; number($total))">
			<!--
<xsl:if test="$skip = 0">
<font size="1"><br/></font>
</xsl:if>
-->
			<xsl:variable name="PostRange">
				<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$skip &gt;= $lower and $skip &lt; $total">
					<xsl:if test="($skip mod $splitevery) = 0 and ($splitevery &gt; 0) and ($skip != 0)">
						<br/>
					</xsl:if>
					<a xsl:use-attribute-sets="nforumpostblocks">
						<xsl:call-template name="ApplyAttributes">
							<xsl:with-param name="attributes" select="$attributes"/>
						</xsl:call-template>
						<xsl:if test="$target!=''">
							<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
						</xsl:if>
						<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:value-of select="$forum"/><xsl:choose><xsl:when test="$thread!=''">?thread=<xsl:value-of select="$thread"/>&amp;</xsl:when><xsl:otherwise>?</xsl:otherwise></xsl:choose>skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/><xsl:value-of select="$ExtraParameters"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="number($this) = number($skip)">
								<xsl:attribute name="TITLE"><xsl:value-of select="$alt_nowshowing"/><xsl:value-of select="$objectname"/><xsl:text> </xsl:text><xsl:value-of select="$PostRange"/></xsl:attribute>
								<xsl:call-template name="fpb_thisblock">
									<xsl:with-param name="blocknumber" select="number($skip div $show + 1)"/>
									<xsl:with-param name="PostRange" select="$PostRange"/>
									<xsl:with-param name="objectname" select="$objectname"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="TITLE"><xsl:value-of select="$alt_show"/><xsl:value-of select="$objectname"/><xsl:text> </xsl:text><xsl:value-of select="$PostRange"/></xsl:attribute>
								<xsl:call-template name="fpb_otherblock">
									<xsl:with-param name="blocknumber" select="number($skip div $show + 1)"/>
									<xsl:with-param name="PostRange" select="$PostRange"/>
									<xsl:with-param name="objectname" select="$objectname"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</a>
					<img src="{$imagesource}blank.gif" width="2" height="1"/>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="(number($skip) + number($show)) &lt; number($upper)">
					<xsl:call-template name="forumpostblocks_loop">
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
						<xsl:with-param name="limit" select="$limit"/>
						<xsl:with-param name="lower" select="$lower"/>
						<xsl:with-param name="upper" select="$upper"/>
						<xsl:with-param name="ExtraParameters" select="$ExtraParameters"/>
						<!--<xsl:with-param name="blocklimit" select="$blocklimit"/>-->
					</xsl:call-template>
				</xsl:when>
				<!--
	<xsl:otherwise>
	<br/>
	<font size="1"><br/></font>
	</xsl:otherwise>
-->
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fpb_start">
		<font xsl:use-attribute-sets="forumblocksoff">[start]</font>
	</xsl:template>
	<xsl:template name="fpb_prevset">
		<font xsl:use-attribute-sets="forumblocksoff">&lt;&lt;</font>
	</xsl:template>
	<xsl:template name="fpb_nextset">
		<font xsl:use-attribute-sets="forumblocksoff">&gt;&gt;</font>
	</xsl:template>
	<xsl:template name="fpb_end">
		<font xsl:use-attribute-sets="forumblocksoff">[end]</font>
	</xsl:template>
	<xsl:template name="fpb_thisblock">
		<xsl:param name="blocknumber"/>
		<xsl:param name="objectname"/>
		<xsl:param name="PostRange"/>
		<font xsl:use-attribute-sets="forumblockson">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$blocknumber"/>
			<xsl:text> </xsl:text>
		</font>
	</xsl:template>
	<xsl:template name="fpb_otherblock">
		<xsl:param name="blocknumber"/>
		<xsl:param name="objectname"/>
		<xsl:param name="PostRange"/>
		<font xsl:use-attribute-sets="forumblocksoff">
			<xsl:text> </xsl:text>
			<xsl:value-of select="$blocknumber"/>
			<xsl:text> </xsl:text>
		</font>
	</xsl:template>
	<xsl:template name="navbuttons">
		<xsl:param name="URL"/>
		<xsl:param name="ID"/>
		<xsl:param name="ExtraParameters"/>
		<xsl:param name="shownewest">
			<xsl:value-of select="$m_newest"/>
		</xsl:param>
		<xsl:param name="showoldestconv">
			<xsl:value-of select="$m_oldest"/>
		</xsl:param>
		<xsl:param name="Previous" select="$m_newer"/>
		<xsl:param name="Next" select="$m_older"/>
		<xsl:param name="Skip" select="@SKIPTO"/>
		<xsl:param name="Show" select="@COUNT"/>
		<xsl:param name="Total" select="@TOTAL"/>
		<br/>
		<xsl:choose>
			<xsl:when test="$Skip != 0">
				<xsl:variable name="alt">[ <xsl:value-of select="number($Skip) - number($Show) + 1"/>-<xsl:value-of select="number($Skip)"/> ]</xsl:variable>
				<a href="{$root}{$URL}{$ID}?skip=0&amp;show={$Show}{$ExtraParameters}">[ <xsl:value-of select="$shownewest"/> ]</a>
				<a href="{$root}{$URL}{$ID}?skip={number($Skip) - number($Show)}&amp;show={$Show}{$ExtraParameters}">
					<xsl:value-of select="$alt"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
		[ <xsl:value-of select="$shownewest"/> ]
		[ <xsl:value-of select="$Previous"/> ]
	</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="@MORE">
				<xsl:variable name="alt">[ <xsl:value-of select="number($Skip) + number($Show) + 1"/>-<xsl:value-of select="number($Skip) + number($Show) + number($Show)"/> ]</xsl:variable>
				<a href="{$root}{$URL}{$ID}?skip={number($Skip) + number($Show)}&amp;show={$Show}{$ExtraParameters}">
					<xsl:value-of select="$alt"/>
				</a>
				<a href="{$root}{$URL}{$ID}?skip={floor((number($Total)-1) div number($Show)) * number($Show)}&amp;show={$Show}{$ExtraParameters}">[ <xsl:value-of select="$showoldestconv"/> ]</a>
			</xsl:when>
			<xsl:otherwise>
		[ <xsl:value-of select="$Next"/> ]
		[ <xsl:value-of select="$showoldestconv"/> ]
	</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="threadnavbuttons">
		<!-- this is deprecated - please use match="@SKIPTO" mode="navbuttons" - TW -->
		<xsl:param name="URL">FFO</xsl:param>
		<xsl:param name="ID">
			<xsl:value-of select="@FORUMID"/>
		</xsl:param>
		<xsl:param name="ExtraParameters"/>
		<xsl:if test="(number(@SKIPTO) != 0) or (@MORE)">
			<br/>
			<xsl:choose>
				<xsl:when test="@SKIPTO != 0">
					<!--
		<a href="{$root}{$URL}{$ID}?skip=0&amp;show={@COUNT}{$ExtraParameters}">
			
				[ <xsl:value-of select="$m_newest"/> ]
		</a>
-->
					<xsl:variable name="alt">[ <xsl:value-of select="number(@SKIPTO) - number(@COUNT) + 1"/>-<xsl:value-of select="number(@SKIPTO)"/> ]</xsl:variable>
					<a href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
						<xsl:value-of select="$alt"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<!--
		[ <xsl:value-of select="$m_newest"/> ]
-->
		[ <xsl:value-of select="$m_newer"/> ]
	</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@MORE">
					<xsl:variable name="alt">[ <xsl:value-of select="number(@SKIPTO) + number(@COUNT) + 1"/>-<xsl:value-of select="number(@SKIPTO) + number(@COUNT) + number(@COUNT)"/> ]</xsl:variable>
					<a href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
						<xsl:value-of select="$alt"/>
					</a>
					<!--
		<a href="{$root}{$URL}{$ID}?skip={floor((number(@TOTALTHREADS)-1) div number(@COUNT)) * number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
				[ <xsl:value-of select="$m_oldest"/> ]
		</a>
-->
				</xsl:when>
				<xsl:otherwise>
		[ <xsl:value-of select="$m_older"/> ]
<!--
		[ <xsl:value-of select="$m_oldest"/> ]
-->
				</xsl:otherwise>
			</xsl:choose>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="INTERNAL-TOOLS-NAVIGATION">
		<br/>
		<br/>
		<table border="0" width="100%" cellpadding="2" cellspacing="4">
			<tr>
				<td>&nbsp;</td>
				<td>
					<nobr>
						<font xsl:use-attribute-sets="mainfont" size="3">
							<b>Tools Available:</b>
						</font>
					</nobr>
				</td>
			</tr>
			<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
				<tr colspan="2">
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<b>Editor Tools</b>
							</font>
						</nobr>
					</td>
				</tr>
        <xsl:if test="/H2G2/@TYPE!='INSPECT-USER'">
          <tr>
            <td>&nbsp;</td>
            <td>
              <nobr>
                <font xsl:use-attribute-sets="mainfont">
                  <a href="{$root}InspectUser" target="_top">Inspect User</a>
                </font>
              </nobr>
            </td>
          </tr>
        </xsl:if>
				<xsl:if test="/H2G2/@TYPE!='GROUP-MANAGEMENT'">
					<tr>
						<td>&nbsp;</td>
						<td>
							<nobr>
								<font xsl:use-attribute-sets="mainfont">
									<a href="{$root}ManageGroups" target="_top">Group Management</a>
								</font>
							</nobr>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}editor.cgi" target="_top">Entry Editor</a>
							</font>
						</nobr>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}edithome.cgi" target="_top">Editor Homepage</a>
							</font>
						</nobr>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}editqueue.cgi" target="_top">Waiting to Go Live</a>
							</font>
						</nobr>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}editfrontpageraw.cgi" target="_top">Edit Front Page</a>
							</font>
						</nobr>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}catpage.cgi" target="_top">Categorisation</a>
							</font>
						</nobr>
					</td>
				</tr>
				<tr colspan="2">
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<b>Peer Review</b>
							</font>
						</nobr>
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE!='SCOUT-RECOMMENDATIONS'">
					<tr>
						<td>&nbsp;</td>
						<td>
							<nobr>
								<font xsl:use-attribute-sets="mainfont">
									<a href="{$root}ScoutRecommendations" target="_top">Scout Recommendations</a>
								</font>
							</nobr>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="/H2G2/@TYPE!='SUB-ALLOCATION'">
					<tr>
						<td>&nbsp;</td>
						<td>
							<nobr>
								<font xsl:use-attribute-sets="mainfont">
									<a href="{$root}AllocateSubs" target="_top">Allocate Subs</a>
								</font>
							</nobr>
						</td>
					</tr>
				</xsl:if>
				<tr colspan="2">
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<b>Moderation</b>
							</font>
						</nobr>
					</td>
				</tr>
        <tr>
          <td>&nbsp;</td>
          <td>
            <nobr>
              <font xsl:use-attribute-sets="mainfont">
                <a href="{$root}MemberList?UserID={//INSPECT-USER-FORM/USER/USERID}" target="_top">Moderate User</a>
              </font>
            </nobr>
          </td>
        </tr>
        <xsl:if test="/H2G2/@TYPE!='MODERATE-HOME'">
					<tr>
						<td>&nbsp;</td>
						<td>
							<nobr>
								<font xsl:use-attribute-sets="mainfont">
									<a href="{$rootbase}moderation/Moderate?newstyle=1" target="_top">Moderation Home Page</a>
								</font>
							</nobr>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="/H2G2/@TYPE!='MODERATE-STATS'">
					<tr>
						<td>&nbsp;</td>
						<td>
							<nobr>
								<font xsl:use-attribute-sets="mainfont">
									<a href="{$root}ModerateStats" target="_top">Moderation Stats Page</a>
								</font>
							</nobr>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}ModerationHistory" target="_top">Moderation History</a>
							</font>
						</nobr>
					</td>
				</tr>
				<tr colspan="2">
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<b>Miscellaneous</b>
							</font>
						</nobr>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<nobr>
							<font xsl:use-attribute-sets="mainfont">
								<a href="{$root}MoveThread" target="_top">Move Thread</a>
							</font>
						</nobr>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td>&nbsp;</td>
				<td>
					<nobr>
						<font xsl:use-attribute-sets="mainfont">
							<a href="{$root}RandomEntry" target="_top">Random Entry</a>
						</font>
					</nobr>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<nobr>
						<font xsl:use-attribute-sets="mainfont">
							<a href="{$root}RandomNormalEntry" target="_top">Random Normal Entry</a>
						</font>
					</nobr>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<nobr>
						<font xsl:use-attribute-sets="mainfont">
							<a href="{$root}RandomRecommendedEntry" target="_top">Random Recommended Entry</a>
						</font>
					</nobr>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<nobr>
						<font xsl:use-attribute-sets="mainfont">
							<a href="{$root}RandomEditedEntry" target="_top">Random Edited Entry</a>
						</font>
					</nobr>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
		<script language="JavaScript"><![CDATA[
<!-- hide this script from non-javascript-enabled browsers
function IsEmpty(str)
{
	for (var i = 0; i < str.length; i++)
	{
		var ch = str.charCodeAt(i);
		if (ch > 32)
		{
			return false;
		}
	}

	return true;
}

function checkArticleModerationForm()
{
	if ((ArticleModerationForm.Decision.value == 4 
			|| ArticleModerationForm.Decision.value == 6))
	{
		if (ArticleModerationForm.EmailType.selectedIndex == 0)
		{
			alert('You must select a reason when failing content');
			return false;
		}
		else
		if (ArticleModerationForm.EmailType.value == 'URLInsert')
		{
			//if failed with the URL reason - custom email field should be filled
			if (IsEmpty(ArticleModerationForm.CustomEmailText.value))
			{
				alert('Custom Email box should be filled if URL is selected as failure reason');
				ArticleModerationForm.CustomEmailText.focus();
				return false;
			}
		}
	}
	else if (ArticleModerationForm.EmailType.options[ArticleModerationForm.EmailType.selectedIndex].value == 'Custom' &&
			 ArticleModerationForm.CustomEmailText.value == '')
	{
		alert('You must specify the content for a custom email.');
		return false;
	}
	else
	if (ArticleModerationForm.Decision.value == 2) //refer to
	{ 
		if (IsEmpty(ArticleModerationForm.notes.value))
		{
			alert('Notes box should be filled if the article is referred');
			ArticleModerationForm.notes.focus();
			return false;
		}
	}

	return true;
}
// stop hiding -->
		]]></script>
		<a name="moderatesection"/>
		<b>Moderate this Entry</b>
    <br/>
		<xsl:if test="/H2G2/ARTICLE/ERROR[@TYPE='XML-PARSE-ERROR']">
			<b>XML Parsing Error in article</b>
			<br/>
		Please fail this entry and continue moderating.
		</xsl:if>
		<!-- first show any error messages -->
		<xsl:if test="ERROR">
			<font face="Arial" size="2" color="red">
				<xsl:for-each select="ERROR">
					<b>
						<xsl:value-of select="."/>
					</b>
				</xsl:for-each>
				<br/>
			</font>
		</xsl:if>
		<!-- show any other messages -->
		<xsl:if test="MESSAGE">
			<font face="Arial" size="2" color="black">
				<xsl:choose>
					<xsl:when test="MESSAGE/@TYPE = 'NONE-LOCKED'">
						<b>You currently have no entries of this type allocated to you for moderation. Select a type and click 'Process' to be 
					allocated the next entry of that type waiting to be moderated.</b>
						<br/>
					</xsl:when>
					<xsl:when test="MESSAGE/@TYPE = 'EMPTY-QUEUE'">
						<b>Currently there are no entries of the specified type awaiting moderation.</b>
						<br/>
					</xsl:when>
					<xsl:when test="MESSAGE/@TYPE = 'NO-ARTICLE'">
						<b>You have no entry allocated to you for moderation currently. Click on 'Process' below 
					to be allocated the next entry requiring moderation.</b>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<b>
							<xsl:value-of select="MESSAGE"/>
						</b>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</font>
		</xsl:if>
		<!-- if the article is actually part of a club, show the club-specific data -->
		<xsl:if test="/H2G2/CLUBINFO">
			<br/>
			<table bgColor="lightblue">
				<tr>
					<td colspan="2">
						<b>Club related information</b>
					</td>
				</tr>
				<tr>
					<td>Club name:</td>
					<td>
						<xsl:value-of select="/H2G2/CLUBINFO/NAME"/>
					</td>
				</tr>
				<tr>
					<td>Club description:</td>
					<td>
						<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION"/>
					</td>
				</tr>
				<tr>
					<td>Club location:</td>
					<td>
						<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/LOCATION"/>
					</td>
				</tr>
			</table>
		</xsl:if>
		<!-- if the article has extra information in it then display it -->
    <table>
      <tr>
        <td>
          Author : <a target="_blank" href="{$rootbase}moderation/MemberDetails?userid={/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
                  <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/>
                  </a>
        </td>
        <td>
          <xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS" mode="user_groups"/>
        </td>
      </tr>
    </table>
		<xsl:if test="/H2G2/ARTICLE/GUIDE/*[not(self::BODY)]">
			<br/>
			<table bgColor="white">
        <tr>
          <td>
            <b>Other information</b>
          </td>
        </tr>
				<xsl:for-each select="/H2G2/ARTICLE/GUIDE/*[not(self::BODY)]">
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="substring(.,1,7) = 'http://'">
									<a href="{.}">
										<xsl:value-of select="."/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
		<form action="{$root}ModerateArticle" method="POST" name="ArticleModerationForm" onSubmit="return checkArticleModerationForm()">
			<input type="hidden" name="h2g2ID">
				<xsl:attribute name="value"><xsl:value-of select="ARTICLE/H2G2-ID"/></xsl:attribute>
			</input>
			<input type="hidden" name="ModID">
				<xsl:attribute name="value"><xsl:value-of select="ARTICLE/MODERATION-ID"/></xsl:attribute>
			</input>
			<!-- Add Media Asset Info if this exists-->
			<xsl:if test="/H2G2/MEDIAASSETINFO">
				<input type="hidden" name="MimeType">
					<xsl:attribute name="value"><xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE"/></xsl:attribute>
				</input>
				<input type="hidden" name="MediaAssetID">
					<xsl:attribute name="value"><xsl:value-of select="/H2G2/MEDIAASSETINFO/MEDIAASSET/@MEDIAASSETID"/></xsl:attribute>
				</input>
			</xsl:if>
			<input type="hidden" name="SiteID" value="{../ARTICLE/ARTICLEINFO/SITEID}"/>
			<font face="Arial" size="2" color="black">
				<table width="100%">
					<tr>
						<td>
							<font face="Arial" size="2" color="black">
								<xsl:apply-templates select="../ARTICLE/ARTICLEINFO/SITEID" mode="showfrom_mod_offsite"/>
							</font>
						</td>
					</tr>
					<tr>
						<td>
							<font face="Arial" size="2" color="black">
								<xsl:if test="@REFERRALS = 1">Referred by 
								<xsl:choose>
										<xsl:when test="number(ARTICLE/REFERRED-BY/USER/USERID) > 0">
											<xsl:apply-templates select="ARTICLE/REFERRED-BY/USER"/>
										</xsl:when>
										<xsl:otherwise>
											<font color="red">Auto Referral</font>
										</xsl:otherwise>
									</xsl:choose>
									<br/>
								</xsl:if>
							</font>
						</td>
						<td align="right">
							<font face="Arial" size="2" color="black">
								<a target="_blank" href="{$rootbase}moderation/ModerationHistory?h2g2ID={ARTICLE/H2G2-ID}">Show History</a>
							</font>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<font face="Arial" size="2" color="black">
								<xsl:if test="@TYPE='COMPLAINTS'">
									<input type="hidden" name="ComplainantID" value="{ARTICLE/COMPLAINT/USER/USERID}"/>
									<input type="hidden" name="CorrespondenceEmail" value="{ARTICLE/COMPLAINT/USER/EMAIL}"/>
									Complaint from
									<xsl:choose>
										<xsl:when test="string-length(ARTICLE/COMPLAINT/USER/EMAIL) > 0">
											<a href="mailto:{ARTICLE/COMPLAINT/USER/EMAIL}">
												<xsl:value-of select="ARTICLE/COMPLAINT/USER/EMAIL"/>
											</a>
										</xsl:when>
										<xsl:when test="number(ARTICLE/USER/USERID) > 0">
											Researcher <a href="{$root}U{ARTICLE/COMPLAINT/USER/USERID}">
												U<xsl:value-of select="ARTICLE/COMPLAINT/USER/USERID"/>
											</a>
										</xsl:when>
										<xsl:otherwise>Anonymous Complainant</xsl:otherwise>
									</xsl:choose>
									<xsl:apply-templates select="ARTICLE/COMPLAINT/USER/GROUPS" mode="user_groups"/>
									<br/>
									<textarea name="ComplaintText" cols="60" rows="10" wrap="virtual">
										<xsl:value-of select="ARTICLE/COMPLAINT/COMPLAINT-TEXT"/>
									</textarea>
									<br/>
								</xsl:if>
							</font>
						</td>
					</tr>
				</table>
			Notes<br/>
				<textarea cols="60" name="notes" rows="10" wrap="virtual">
					<xsl:value-of select="ARTICLE/NOTES"/>
				</textarea>
				<br/>
				<input type="hidden" name="Referrals">
					<xsl:attribute name="value"><xsl:value-of select="@REFERRALS"/></xsl:attribute>
				</input>
				<input type="hidden" name="Show">
					<xsl:attribute name="value"><xsl:value-of select="@TYPE"/></xsl:attribute>
				</input>
				<select name="Decision">
					<!--				<option value="0">No Decision</option>-->
					<xsl:if test="@TYPE='COMPLAINTS'">
						<option value="3" selected="selected">
							<xsl:value-of select="$m_modrejectarticlecomplaint"/>
						</option>
						<option value="4">
							<xsl:value-of select="$m_modacceptarticlecomplaint"/>
						</option>
						<option value="6">
							<xsl:value-of select="$m_modacceptandeditarticle"/>
						</option>
					</xsl:if>
					<xsl:if test="@TYPE!='COMPLAINTS'">
						<option value="3" selected="selected">Pass</option>
						<option value="4">Fail</option>
					</xsl:if>
					<option value="2">Refer</option>
					<xsl:if test="@REFERRALS = 1">
						<option value="5">Unrefer</option>
					</xsl:if>
				</select>
				<xsl:text> </xsl:text>
				<select name="ReferTo" onChange="javascript:if (selectedIndex != 0) Decision.value = 2">
					<xsl:apply-templates select="/H2G2/REFEREE-LIST">
						<xsl:with-param name="SiteID" select="/H2G2/ARTICLE/ARTICLEINFO/SITEID"/>
					</xsl:apply-templates>
				</select>
				<xsl:text> </xsl:text>
				<select name="EmailType" onChange="javascript:if (selectedIndex != 0 &amp;&amp; ArticleModerationForm.Decision.value != 4 &amp;&amp; ArticleModerationForm.Decision.value != 6) ArticleModerationForm.Decision.value = 4" title="Select a reason if you are failing this content">
					<!--
				<option value="None" selected="selected">Failed because:</option>
				<option value="OffensiveInsert">Offensive</option>
				<option value="LibelInsert">Libellous</option>
				<option value="URLInsert">URL</option>
				<option value="PersonalInsert">Personal</option>
				<option value="AdvertInsert">Advertising</option>
				<option value="CopyrightInsert">Copyright</option>
				<option value="PoliticalInsert">Party Political</option>
				<option value="IllegalInsert">Illegal</option>
				<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
					<option value="Custom">Custom (enter below)</option>
				</xsl:if>
-->
					<xsl:call-template name="m_ModerationFailureMenuItems"/>
				</select>
				<br/>
				<br/>
				<input type="submit" name="Next" value="Process" title="Process this Entry and then fetch the next one"/>
				<xsl:text> </xsl:text>
				<input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process and go to Moderation Home"/>
				<br/>
				<br/>
				<a href="{$rootbase}moderation/Moderate?newstyle=1">Moderation Home Page</a>
				<br/>
				<xsl:choose>
					<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
						<br/>
				Text for Custom Email
				<br/>
					</xsl:when>
					<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='MODERATOR' and not(/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')">
						<xsl:value-of select="$m_ModEnterURLandReason"/>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<br/>
				If this entry failed due to broken URLs, please list them here, along with 
				the reason why the URL failed, so the user can correct the article.
				<br/>
					</xsl:otherwise>
				</xsl:choose>
				<textarea cols="60" name="CustomEmailText" rows="10" wrap="virtual"></textarea>
				<br/>
				<xsl:if test="/H2G2/PHRASES">
					<strong>Article's key phrases:</strong>
					<br/>
					<xsl:apply-templates select="/H2G2/PHRASES" mode="DisassociatePhrases">
						<xsl:with-param name="moditempos" select="position()"/>
					</xsl:apply-templates>
				</xsl:if>
			</font>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_style']/VALUE = 'new'">
				<input type="hidden" name="s_returnto" value="moderate?newstyle=1"/>
				<input type="hidden" name="s_style" value="new"/>
			</xsl:if>
		</form>
	</xsl:template>

  <!-- Template for Handling the Removal of KeyPhrases with Namespaces from An Article.  -->
  <xsl:template match="PHRASES" mode="DisassociatePhrases">
    <xsl:param name="moditempos"/>
    <table cellspacing="2" border="0" cellpadding="0">
      <xsl:for-each select="PHRASE">
        <tr>
          <td>
            <xsl:if test="NAMESPACE">
              <xsl:value-of select="NAMESPACE"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
            <xsl:value-of select="NAME"/>
          </td>
          <td align="left">
            <INPUT id="Chk{NAME}" name="DisassociatePhrasenameSpaceIds"  TYPE="CHECKBOX">
              <xsl:attribute name="value">
                <xsl:value-of select="PHRASENAMESPACEID"/>
              </xsl:attribute>
            </INPUT> disassociate
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  <!--
	<xsl:template match="REFEREE-LIST">
	Author:		Igor Loboda
	Generic:	Yes
	Purpose:	fills the options list for ReferTo html select control
-->
	<xsl:template match="REFEREE-LIST">
		<xsl:param name="SiteID"/>
		<option value="0" selected="selected">Refer to:</option>
		<option value="0">Anyone</option>
		<xsl:for-each select="REFEREE[SITEID = $SiteID]/USER">
			<option value="{USERID}">
				<xsl:value-of select="USERNAME"/>
			</option>
		</xsl:for-each>
	</xsl:template>
	<!--
	<xsl:template name="ONEYES">
	Author:		Igor Loboda
	Generic:	Yes
	Purpose:	transforms current value into YES or NO. 1 - Yes, otherwize - 0
-->
	<xsl:template name="ONEYES">
		<xsl:if test=".!='1'">
			<xsl:value-of select="$m_oneyes_no"/>
		</xsl:if>
		<xsl:if test=".='1'">
			<xsl:value-of select="$m_oneyes_yes"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="showfrom">
	Author:		
	Generic:	No
	Purpose:	displays the name of the site
-->
	<xsl:template match="SITEID" mode="showfrom">
		<xsl:variable name="thissiteid">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:value-of select="$m_fromsite"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/SHORTNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="PREMODERATION">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	displays site premoderation flag
-->
	<xsl:template match="PREMODERATION">
		<xsl:value-of select="$m_premoderation"/>
		<xsl:text> </xsl:text>
		<xsl:call-template name="ONEYES"/>
	</xsl:template>
	<!--
	<xsl:template match="OFFSITELINKS">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	displays off-site links availability
-->
	<xsl:template match="OFFSITELINKS">
		<xsl:value-of select="$m_offsiteallowed"/>
		<xsl:text> </xsl:text>
		<xsl:call-template name="ONEYES"/>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="showfrom_mod_offsite">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	Displays site information:site name, premoderation status, 
				are off-site links allowed. The information is displayed 
				each piece on separate line.
-->
	<xsl:template match="SITEID" mode="showfrom_mod_offsite">
		<xsl:variable name="thissiteid">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:apply-templates select="." mode="showfrom"/>
		<br/>
		<br/>
		<xsl:choose>
			<xsl:when test="/H2G2/TOPICLIST/TOPIC[FORUMID = current()/../FORUM-ID]">Topicname: <xsl:value-of select="/H2G2/TOPICLIST/TOPIC[FORUMID = current()/../FORUM-ID]/TITLE"/>
			</xsl:when>
			<xsl:otherwise>No Topic information available</xsl:otherwise>
		</xsl:choose>
		<br/>
		<br/>
		<!--<xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/PREMODERATION"/>
	<br/>
	<br/>
	<xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/OFFSITELINKS"/>-->
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="showfrom_mod_offsite_line">
	Author:		Igor Loboda
	Generic:	No
	Purpose:	Displays site information:site name, premoderation status, 
				are off-site links allowed. The information is displayed all
				in one line.
-->
	<xsl:template match="SITEID" mode="showfrom_mod_offsite_line">
		<xsl:variable name="thissiteid">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:apply-templates select="." mode="showfrom"/>
		<xsl:text> -- </xsl:text>
		<xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/PREMODERATION"/>
		<xsl:text> -- </xsl:text>
		<xsl:apply-templates select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/OFFSITELINKS"/>
	</xsl:template>
	<!--
	Displays username, but truncates names longer than 20 chars
-->
	<xsl:template match="USERNAME" mode="truncated">
		<xsl:variable name="UserName">
			<xsl:choose>
				<xsl:when test="string-length(.) &gt; 20">
					<xsl:value-of select="substring(., 1, 17)"/>...</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$UserName"/>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="MoveToSite">
	Author:		Igor Loboda
	Inputs:		objectID - this id will be submitted to the server when Move button is 
							pressed. Usually this ID identifies entity to move. Like
							to move Article this will be H2G2ID.
	Purpose:	provides move-to-site functinality
	-->
	<xsl:template match="SITEID" mode="MoveToSite">
		<xsl:param name="objectID"/>
		<FORM NAME="MoveToSiteForm" METHOD="get">
			<xsl:value-of select="$m_BelongsToSite"/>
			<xsl:apply-templates select="." mode="SiteList"/>
			<INPUT TYPE="hidden" NAME="cmd" VALUE="MoveToSite"/>
			<xsl:text> </xsl:text>
			<INPUT TYPE="hidden" NAME="moveObjectID">
				<xsl:attribute name="VALUE"><xsl:value-of select="$objectID"/></xsl:attribute>
			</INPUT>
			<INPUT NAME="button" xsl:use-attribute-sets="iMoveToSite"/>
		</FORM>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="SiteList">
	Author:		Igor Loboda
	Generic:	Yes
	Inputs:		-
	Purpose:	presents site list as a <SELECT> element.
	-->
	<xsl:template match="SITEID" mode="SiteList">
		<xsl:variable name="currentSiteID" select="."/>
		<SELECT NAME="SitesList">
			<xsl:for-each select="/H2G2/SITE-LIST/SITE">
				<OPTION VALUE="{@ID}">
					<xsl:if test="@ID = $currentSiteID">
						<xsl:attribute name="SELECTED"/>
					</xsl:if>
					<xsl:value-of select="SHORTNAME"/>
				</OPTION>
			</xsl:for-each>
		</SELECT>
	</xsl:template>
	<xsl:template name="skinfield">
		<!--<input type="text" name="skin"/>-->
	</xsl:template>
	<!--
<xsl:template name="register-mainerror">
Context:    must have @STATUS
Purpose:	displays registration/login error message
Param:		delimiter - will be placed after the message
Call:		<xsl:call-template name="register-mainerror">
-->
	<xsl:template name="register-mainerror">
		<xsl:param name="delimiter">
			<br/>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="@STATUS='NOLOGINNAME'">
				<xsl:value-of select="$m_invalidloginname"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='NOPASSWORD'">
				<xsl:value-of select="$m_invalidpassword"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='UNMATCHEDPASSWORDS'">
				<xsl:value-of select="$m_unmatchedpasswords"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='LOGINFAILED'">
				<xsl:value-of select="$m_loginfailed"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='LOGINUSED'">
				<xsl:value-of select="$m_loginused"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='NOTERMS'">
				<xsl:value-of select="$m_mustagreetoterms"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='HASHFAILED'">
				<xsl:value-of select="$m_problemwithreg"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='NOCONNECTION'">
				<xsl:copy-of select="$m_noconnectionerror"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='INVALIDPASSWORD'">
				<xsl:value-of select="$m_invalidbbcpassword"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='INVALIDUSERNAME'">
				<xsl:value-of select="$m_invalidbbcusername"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='INVALIDEMAIL'">
				<xsl:value-of select="$m_invalidEmail"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
			<xsl:when test="@STATUS='UIDUSED'">
				<xsl:value-of select="$m_uidused"/>
				<xsl:copy-of select="$delimiter"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
<xsl:template match="NEWREGISTER" mode="HiddenInputsNormal">
Author:		Igor Loboda
Context:    -
Purpose:	Generates hidden fields for register page
Call:		<xsl:apply-templates select="USENEWREGISTERRID" mode="HiddenInputsNormal">
-->
	<xsl:template match="NEWREGISTER" mode="HiddenInputsNormal">
		<INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
		<INPUT TYPE="HIDDEN" NAME="cmd" VALUE="normal"/>
	</xsl:template>
	<!--
<xsl:template match="NEWREGISTER" mode="HiddenInputsFasttrack">
Author:		Igor Loboda
Context:    -
Purpose:	Generates hidden fields for login page
Call:		<xsl:apply-templates select="USENEWREGISTERRID" mode="HiddenInputsFasttrack">
-->
	<xsl:template match="NEWREGISTER" mode="HiddenInputsFasttrack">
		<INPUT TYPE="HIDDEN" NAME="bbctest" VALUE="1"/>
		<INPUT TYPE="HIDDEN" NAME="cmd" VALUE="fasttrack"/>
	</xsl:template>
	<!--
<xsl:template match="REGISTER-PASSTHROUGH">
Context:    -
Purpose:	-
Call:		<xsl:apply-templates select="REGISTER-PASSTHROUGH">
-->
	<xsl:template match="REGISTER-PASSTHROUGH">
		<INPUT TYPE="HIDDEN" NAME="pa" VALUE="{@ACTION}"/>
		<xsl:for-each select="PARAM">
			<INPUT TYPE="HIDDEN" NAME="pt" VALUE="{@NAME}"/>
			<INPUT TYPE="HIDDEN" NAME="{@NAME}" VALUE="{.}"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="NEWREGISTER_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_registrationsubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
