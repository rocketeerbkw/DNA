<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--===============Imported Files=====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
	<!--===============Imported Files=====================-->
	<!--===============Included Files=====================-->
	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="boardpromospage.xsl"/>
	<xsl:include href="boardopeningschedulepage.xsl"/>
	<xsl:include href="boardstext.xsl"/>
	<xsl:include href="editorialpopups.xsl"/>
	<xsl:include href="frontpage.xsl"/>
	<xsl:include href="frontpagelayoutpage.xsl"/>
	<xsl:include href="indexpage.xsl"/>
	<xsl:include href="messageboardadmin.xsl"/>
	<xsl:include href="messageboardtransferpage.xsl"/>
	<xsl:include href="miscpage.xsl"/>
	<xsl:include href="morecommentspage.xsl"/>
	<xsl:include href="morepostspage.xsl"/>
	<xsl:include href="multipostspage.xsl"/>
	<xsl:include href="registerpage.xsl"/>
	<xsl:include href="searchpage.xsl"/>
	<xsl:include href="siteconfigpreviewpage.xsl"/>
	<xsl:include href="smmpage.xsl"/>
	<xsl:include href="textboxelementpage.xsl"/>
	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="topicbuilderpage.xsl"/>
	<xsl:include href="topicelementbuilderpage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="userpage.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>
	<xsl:include href="infopage.xsl"/>
	<xsl:include href="newuserspage.xsl"/>
	<!--===============Included Files=====================-->
	<!--===============Output Setting=====================-->
	<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="yes" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
	<!--===============Output Setting=====================-->
	<!--===============Javascript=====================-->
	<xsl:variable name="scriptlink">
		<xsl:call-template name="insert-javascript"/>
		<script type="text/javascript">
			<xsl:comment>
				<!--Site wide Javascript goes here-->
				function popupwindow(link, target, parameters) {
					popupWin = window.open(link,target,parameters);
				}
				function popusers(link) {
					popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
				}
					
				function openPreview(location, width, height) {
					window.open(location,'Preview','scrollbars=yes,status=0,menubar=no,resizable=yes,width=' + width + ',height=' + height);
				}
				<xsl:text>//</xsl:text>
			</xsl:comment>
		</script>
	</xsl:variable>
	<!--===============Javascript=====================-->
	<!--===============Variable Settings=====================-->
	<xsl:variable name="boardpath">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE = 'MESSAGEBOARDADMIN'">
				<xsl:apply-templates select="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE='12']/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE = 'TEXTBOXELEMENTPAGE'">
				<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE = 'FRONTPAGETOPICELEMENTBUILDER'">
				<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE = 'MESSAGEBOARDPROMOPAGE'">
				<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>
			<!--<xsl:when test="/H2G2/@TYPE = 'TOPICBUILDER'">
				<xsl:apply-templates select="/H2G2/TOPIC_PAGE/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>-->
			<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
				<xsl:apply-templates select="/H2G2/FRONTPAGELAYOUTCOMPONENTS/SITECONFIG" mode="boardpathserver"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/H2G2/SITECONFIG" mode="boardpathserver"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="SITECONFIG" mode="boardpathserver">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS')">
				<xsl:copy-of select="PATHDEV/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="PATHLIVE/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="sso_assets">
		<xsl:value-of select="$boardpath"/>sso_resources</xsl:variable>
	<xsl:variable name="sso_serviceid_link">
		<xsl:copy-of select="/H2G2/SITECONFIG/BOARDSSOLINK/node()"/>
	</xsl:variable>
	<xsl:variable name="imagesource">
		<xsl:value-of select="$boardpath"/>images/</xsl:variable>
	<xsl:variable name="adminimagesource">http://www.bbc.co.uk/dnaimages/adminsystem/images/</xsl:variable>
	<xsl:variable name="root">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/BOARDROOT/node()">
				<xsl:text>/dna/</xsl:text>
				<xsl:copy-of select="/H2G2/SITECONFIG/BOARDROOT/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>/dna/</xsl:text>
				<xsl:copy-of select="/H2G2/SITE/NAME"/>
				<xsl:text>/</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="homepage">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/EXTERNALHOME = 1">
				<xsl:copy-of select="/H2G2/SITECONFIG/EXTERNALHOMEURL/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$root"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="houserulesurl">http://www.bbc.co.uk/dnaimages/boards/houserules.html</xsl:variable>
	<!--<xsl:variable name="skinname">
		<xsl:copy-of select="/H2G2/SITECONFIG/BOARDSKIN/node()"/>
	</xsl:variable>-->
	<xsl:variable name="skinname" select="'boards'" />
	<xsl:variable name="sso_statbar_type">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/PATHSSOTYPE = 1">kids</xsl:when>
			<xsl:otherwise>normal</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="bbcpage_bgcolor">111111</xsl:variable>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">125</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
	<xsl:variable name="bbcpage_contentalign">left</xsl:variable>
	<xsl:variable name="bbcpage_language">english</xsl:variable>
	<xsl:variable name="bbcpage_topleft_bgcolour"/>
	<xsl:variable name="bbcpage_topleft_linkcolour"/>
	<xsl:variable name="bbcpage_topleft_textcolour"/>
	<xsl:variable name="bbcpage_lang"/>
	<xsl:variable name="bbcpage_variant">
		<xsl:copy-of select="/H2G2/SITECONFIG/BARLEYVARIANT/node()"/>
	</xsl:variable>
	<!--===============Variable Settings=====================-->
	<!--===============Message Board Admin System=====================-->
	<xsl:variable name="isAdmin">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE = 'MESSAGEBOARDTRANSFER' or /H2G2/@TYPE = 'MESSAGEBOARDADMIN' or /H2G2/@TYPE = 'FRONTPAGE-EDITOR' or /H2G2/@TYPE='TEXTBOXELEMENTPAGE' or /H2G2/@TYPE='FRONTPAGETOPICELEMENTBUILDER' or /H2G2/@TYPE='MESSAGEBOARDPROMOPAGE' or /H2G2/@TYPE='TOPICBUILDER' or /H2G2/@TYPE='FRONTPAGE-LAYOUT' or /H2G2/@TYPE='MESSAGEBOARDSCHEDULE' or /H2G2/@TYPE='SITECONFIGPREVIEW-EDITOR'">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="adminCSS">
		<link type="text/css" rel="stylesheet" href="/dnaimages/boards/includes/admin.css"/>
		<!--<link type="text/css" rel="stylesheet" href="http://sandbox0.bu.bbc.co.uk/new_messageboards/includes/admin.css"/>-->
		<!-- LINK TYPE="text/css" REL="stylesheet" HREF="http://www.bbc.co.uk/dnaimages/boards/includes/messageboards.css"/ -->
		<xsl:choose>
			<xsl:when test="/H2G2/BOARDPROMOPAGE/SITECONFIG/CSSLOCATION">
				<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/BOARDPROMOPAGE/SITECONFIG/CSSLOCATION/node()}"/>
			</xsl:when>
			<xsl:when test="/H2G2/TOPICELEMENTPAGE/SITECONFIG/CSSLOCATION">
				<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/TOPICELEMENTPAGE/SITECONFIG/CSSLOCATION/node()}"/>
			</xsl:when>
			<xsl:when test="/H2G2/TEXTBOXPAGE/SITECONFIG/CSSLOCATION">
				<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/TEXTBOXPAGE/SITECONFIG/CSSLOCATION/node()}"/>
			</xsl:when>
			<xsl:when test="/H2G2/FRONTPAGELAYOUTCOMPONENTS/SITECONFIG/CSSLOCATION">
				<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/FRONTPAGELAYOUTCOMPONENTS/SITECONFIG/CSSLOCATION/node()}"/>
			</xsl:when>
			<xsl:when test="/H2G2/SITECONFIG/CSSLOCATION">
				<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/SITECONFIG/CSSLOCATION/node()}"/>
			</xsl:when>
		</xsl:choose>
		<style type="text/css"> 
			@import "http://www.bbc.co.uk/dnaimages/boards/includes/fonts.css" ;
		</style>
	</xsl:variable>
	<!--===============Message Board Admin System=====================-->
	<!--===============CSS=====================-->
	<xsl:variable name="csslink">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">
				<xsl:copy-of select="$adminCSS"/>
			</xsl:when>
			<xsl:otherwise>
				<LINK TYPE="text/css" REL="stylesheet" HREF="http://www.bbc.co.uk/dnaimages/boards/includes/messageboards.css"/>
				<!--<LINK TYPE="text/css" REL="stylesheet" HREF="http://sandbox0.bu.bbc.co.uk/new_messageboards/includes/messageboards.css"/>-->
				<xsl:if test="string(/H2G2/SITECONFIG/CSSLOCATION)">
					<LINK TYPE="text/css" REL="stylesheet" HREF="{$boardpath}includes/{/H2G2/SITECONFIG/CSSLOCATION/node()}"/>
				</xsl:if>
				<style type="text/css"> 
					@import "http://www.bbc.co.uk/dnaimages/boards/includes/fonts.css" ;
				</style>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="insert-css"/>
	</xsl:variable>
	<!--===============CSS=====================-->
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<xsl:variable name="banner-content">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/CODEBANNER/node()">
				<xsl:copy-of select="/H2G2/SITECONFIG/CODEBANNER/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$boardpath}images/{/H2G2/SITECONFIG/IMAGEBANNER}" width="645" height="60" alt=""/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<xsl:variable name="crumb-content">
		<xsl:copy-of select="/H2G2/SITECONFIG/NAVCRUMB/node()"/>
	</xsl:variable>
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content">
		<xsl:apply-templates select="/H2G2/SITECONFIG/NAVLHN/node()"/>
		<xsl:if test="not(/H2G2/CURRENTSITEURLNAME = 'mbradio2' or /H2G2/CURRENTSITEURLNAME = 'mb6music' or /H2G2/CURRENTSITEURLNAME = '1xtra' or /H2G2/CURRENTSITEURLNAME = 'mb606')">
			<xsl:apply-templates select="/H2G2/TOPICLIST" mode="lhnavigation"/>
		</xsl:if>
		<xsl:if test="/H2G2/@TYPE = 'THREADS' and not(/H2G2/CURRENTSITEURLNAME = 'mbcbbc')">
			<a href="/dna/{/H2G2/CURRENTSITEURLNAME}/xml/F{/H2G2/FORUMTHREADS/@FORUMID}?s_xml=rss">
				<img src="http://www.bbc.co.uk/collective/dnaimages/icons/logo_rss.gif" alt="RSS" id="rss-image"/>
			</a>
			<xsl:choose>
				<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'mbnewsround'">
					<p id="rss-link">
						<a href="http://news.bbc.co.uk/cbbcnews/hi/newsid_4090000/newsid_4096100/4096192.stm?rss=/rss/cb" class="small">What is RSS?</a>			
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p id="rss-link">
						<a href="http://www.bbc.co.uk/feedfactory/" class="small">What is RSS?</a>
					</p>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:if>
		<xsl:if test="$test_IsEditor and not($isAdmin = 1) and not(/H2G2/@TYPE='ARTICLE')">
			<br/>
			<br/>
			<hr/>
			<p>
				<strong>Admin:</strong>
			</p>
			<p>
				<a href="{$root}messageboardadmin">Message boards Configuration</a>
			</p>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_register">
	Use: Presentation of the Register link
	-->
	<xsl:template match="H2G2" mode="r_register">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_login">
	Use: Presentation of the Login link
	-->
	<xsl:template match="H2G2" mode="r_login">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_userpage">
	Use: Presentation of the User page link
	-->
	<xsl:template match="H2G2" mode="r_userpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_contribute">
	Use: Presentation of the Contribute link
	-->
	<xsl:template match="H2G2" mode="r_contribute">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_preferences">
	Use: Presentation of the Preferences link
	-->
	<xsl:template match="H2G2" mode="r_preferences">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_logout">
	Use: Presentation of the Logout link
	-->
	<xsl:template match="H2G2" mode="r_logout">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<!--===============Searchcolour Template (Barley Stuff)=====================-->
	<xsl:variable name="bbcpage_searchcolour">
		<xsl:choose>
			<xsl:when test="$isAdmin = 1">ff0000</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="/H2G2/SITECONFIG/SEARCHCOLOUR/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--===============Searchcolour (Barley Stuff)=====================-->
	<!--===============Primary Template (Page Stuff)=====================-->
	<xsl:template name="primary-template">
		<xsl:choose>
			<!--  Page layout template for the admin-only pages -->
			<xsl:when test="$isAdmin = 1">
				<html>
					<xsl:call-template name="insert-header"/>
					<body>
						<xsl:attribute name="id">adminBody</xsl:attribute>
						<div id="topNav">
							<div id="bbcLogo">
								<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/bbc_logo.gif" alt="BBC"/>
							</div>
							<h2>Message boards admin - <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME/node()"/>
							</h2>
						</div>
						<div style="width:770px;">
							<xsl:choose>
								<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 1">
									<!-- Identity stuff here? -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="sso_statusbar"/>
								</xsl:otherwise>
							</xsl:choose>
						</div>
						<xsl:call-template name="insert-mainbody"/>
					</body>
				</html>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERDETAILS'">
				<html>
					<xsl:call-template name="insert-header"/>
					<body>
						<xsl:call-template name="toolbar-template"/>
						<table cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top">
									<table cellpadding="0" cellspacing="0">
										<tr>
											<td>
												<xsl:call-template name="datearea_template"/>
											</td>
										</tr>
									</table>
								</td>
								<td valign="top">
									<table cellpadding="0" cellspacing="0">
										<tr>
											<td>
												<xsl:choose>
													<xsl:when test="/H2G2//SITECONFIG/CODEBANNER/node()">
														<xsl:apply-templates select="/H2G2/SITECONFIG/CODEBANNER/*"/>
													</xsl:when>
													<xsl:otherwise>
														<img src="{$boardpath}images/{/H2G2/SITECONFIG/IMAGEBANNER/node()}" width="645" height="50" alt="{/H2G2/SITECONFIG/BOARDNAME/node()} Board"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td valign="top">&nbsp;</td>
								<td valign="top">
									<table cellpadding="0" cellspacing="0" style="margin-left:10px;">
										<tr>
											<td>
												<xsl:call-template name="sso_statusbar"/>
											</td>
										</tr>
										<tr>
											<td>
												<xsl:call-template name="insert-mainbody"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<xsl:call-template name="footer-template"/>
					</body>
				</html>
			</xsl:when>
			<xsl:otherwise>
				<html>
					<!--
					<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
						<xsl:comment>#set var="bbcpage_survey" value="yes" </xsl:comment>
						<xsl:comment>#set var="bbcpage_surveysite" value="test" </xsl:comment>
					</xsl:if>	
					-->
					<xsl:call-template name="insert-header"/>
					<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
						<xsl:choose>
							<xsl:when test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">
								<xsl:attribute name="onload"><xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">previewmode();</xsl:if></xsl:attribute>
							</xsl:when>
							<xsl:when test="/H2G2/@TYPE='ADDTHREAD' and /H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST">
								<xsl:attribute name="onload">setInterval('countDown()', 1000);</xsl:attribute>
							</xsl:when>
							<xsl:when test="/H2G2/PREVIEWMODE=1 and $test_IsEditor and /H2G2/@TYPE='ADDTHREAD' and /H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST">
								<xsl:attribute name="onload"><xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">previewmode();</xsl:if>setInterval('countDown()', 1000);</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<xsl:apply-templates select="/H2G2" mode="c_bodycontent"/>
					</body>
				</html>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--===============Primary Template (Page Stuff)=====================-->
	<!--===============Body Content Template (Global Content Stuff) Content table=====================-->
	<xsl:template match="H2G2" mode="r_bodycontent">
		<table width="100%" cellpadding="0" cellspacing="0" border="0" class="content">
			<tr>
				<td class="mainbody">
					<xsl:call-template name="sso_statusbar-admin"/>
					<xsl:if test="VIEWING-USER/USER and not(/H2G2/@TYPE = 'USERDETAILS') and /H2G2/SITE/IDENTITYSIGNIN = 0">
						<div class="userbar">
							<p align="right">
								<a href="{$root}MP{VIEWING-USER/USER/USERID}">
									<xsl:text>Your discussions</xsl:text>
								</a>
								<xsl:text> | Your nickname is </xsl:text>
								<strong>
									<xsl:apply-templates select="VIEWING-USER/USER" mode="username"/>
								</strong>
								<xsl:text>.</xsl:text>
                <!-- Sites witha  MaxAge < 16 do not display an change this nickname link.-->
								<xsl:if test="not(@TYPE = 'USERDETAILS' or /H2G2/CURRENTSITEMAXAGE &lt; '16' or /H2G2/SITE/MAXAGE &lt;'16' or /H2G2/CURRENTSITEURLNAME = 'mbgcsebitesize' or /H2G2/SITE/NAME='mbgcsebitesize' or /H2G2/CURRENTSITEURLNAME = 'mbks3bitesize' or /H2G2/SITE/NAME='mbks3bitesize' or /H2G2/CURRENTSITEURLNAME = 'mbcbbc' or /H2G2/SITE/NAME='mbcbbc' or /H2G2/CURRENTSITEURLNAME = 'mbnewsround' or /H2G2/SITE/NAME='mbnewsround')">
									<a href="{$root}userdetails">Change this</a>
								</xsl:if>
							</p>
						</div>
					</xsl:if>
					<xsl:call-template name="insert-mainbody"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<xsl:template name="popup-template">
		<html>
			<xsl:call-template name="insert-header"/>
			<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
				<xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">
					<xsl:attribute name="onload"><xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">previewmode();</xsl:if></xsl:attribute>
				</xsl:if>
				<xsl:call-template name="insert-mainbody"/>
			</body>
		</html>
	</xsl:template>
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<!--===============Subject Template (Global Subject Heading Stuff)=====================-->
	<xsl:template match="SUBJECT" mode="nosubject">
		<xsl:choose>
			<xsl:when test=".=''">
				<xsl:value-of select="$m_nosubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--===============Subject Template (Global Subject Heading Stuff)=====================-->
	<!--===============Global Alpha Index=====================-->
	<xsl:template match="letter" mode="alpha">
		<xsl:text> </xsl:text>
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template name="alphaindexdisplay">
		<xsl:param name="letter"/>
		<xsl:copy-of select="$letter"/>
		<xsl:choose>
			<xsl:when test="$letter = 'M'">
				<br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--===============End Global Alpha Index=====================-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="PAGE-LAYOUT[LAYOUT = 4]"/>
	<xsl:template match="BODY">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="HEADER">
		<font size="4">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="SUBHEADER">
		<font size="3">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="TITLETEXT">
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="TOPICLINK">
		<xsl:choose>
			<xsl:when test="not(@NAME)">
				<a href="{$root}F{FORUMID}">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
				<a href="{$root}F{/H2G2/FRONTPAGELAYOUTCOMPONENTS/TOPICLIST/TOPIC[TITLE = current()/@NAME]/FORUMID}">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}F{/H2G2/TOPICLIST/TOPIC[TITLE = current()/@NAME]/FORUMID}">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="INPUT | input | SELECT | select | P | p | I | i | B | b | BLOCKQUOTE | blockquote | CAPTION | caption | CODE | code | UL | ul | OL | ol | LI | li | PRE | pre | SUB | sub | SUP | sup | TABLE | table | TD | td | TH | th | TR | tr | BR | br">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="TEXTAREA">
		<form>
			<xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</form>
	</xsl:template>
	<xsl:template match="INPUT[@SRC]">
		<xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
	</xsl:template>
	<xsl:template match="IMG">
		<!--<xsl:if test="not(starts-with(@SRC,'http://')) or ancestor::FRONTPAGE">
			<xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</xsl:if>-->
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="PICTURE" mode="display">
		<table border="0" cellpadding="0" cellspacing="0">
			<xsl:if test="@EMBED">
				<xsl:attribute name="align"><xsl:value-of select="@EMBED"/></xsl:attribute>
			</xsl:if>
			<tr>
				<td rowspan="4" width="5"/>
				<td height="5"/>
				<td rowspan="4" width="5"/>
			</tr>
			<tr>
				<td>
					<xsl:call-template name="renderimage"/>
				</td>
			</tr>
			<tr>
				<td align="center" valign="top">
					<font xsl:use-attribute-sets="mainfont" size="1">
						<xsl:call-template name="insert-caption"/>
					</font>
				</td>
			</tr>
			<tr>
				<td height="5"/>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="A">
		<xsl:copy-of select="."/>
		<!--<xsl:copy use-attribute-sets="mA">
			<xsl:apply-templates select="*|@CLASS|@HREF|@TARGET|@NAME|@DNAID|text()"/>
		</xsl:copy>-->
	</xsl:template>
	<xsl:template match="LINK">
		<xsl:variable name="location">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="(starts-with($location, 'http://www.b2g5.com/boards/') and contains($location, 'user=peterdow')) or starts-with($location, 'http://scots.8k.com')"/>
			<xsl:when test="starts-with($location, 'http://')">
				<xsl:variable name="shortlocation">
					<xsl:choose>
						<xsl:when test="string-length($location) &gt; 28">
							<xsl:value-of select="substring($location, 8, 20)"/>
							<xsl:text>...</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring($location, 8)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<a href="{@HREF}">
					<xsl:value-of select="$shortlocation"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--<xsl:variable name="smileysource">http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/</xsl:variable>-->
	<xsl:variable name="smileysource">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/EMOTICONLOCATION = 1">
				<xsl:value-of select="$imagesource"/>
				<xsl:text>emoticons/</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>http://www.bbc.co.uk/dnaimages/boards/images/emoticons/</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="SMILEY">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/FEATURESMILEYS = 1 and (@TYPE = 'hug' or @TYPE = 'laugh' or @TYPE = 'ok' or @TYPE = 'smooch' or @TYPE = 'whistle' or @TYPE = 'peacedove' or @TYPE = 'star' or @TYPE = 'ale' or @TYPE = 'bubbly' or @TYPE = 'biggrin' or @TYPE = 'blush' or @TYPE = 'cool' or @TYPE = 'doh' or @TYPE = 'erm' or @TYPE = 'grr' or @TYPE = 'loveblush' or @TYPE = 'sadface' or @TYPE = 'smiley' or @TYPE = 'steam' or @TYPE = 'winkeye' or @TYPE = 'gift' or @TYPE = 'rose' or @TYPE = 'devil' or @TYPE = 'magic' or @TYPE = 'yikes' or @TYPE = 'cracker' or @TYPE = 'holly' or @TYPE = 'mistletoe' or @TYPE = 'reindeer' or @TYPE = 'santa' or @TYPE = 'snowball' or @TYPE = 'llabwons' or @TYPE = 'snowman' or @TYPE = 'xmaspud' or @TYPE = 'xmastree')">
				<img border="0" alt="{@TYPE}" title="{@TYPE}">
					<xsl:attribute name="src"><xsl:value-of select="$smileysource"/>f_<xsl:value-of select="@TYPE"/>.gif</xsl:attribute>
				</img>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="@TYPE = 'cheers'">d_||_b</xsl:when>
					<xsl:when test="@TYPE = 'cry'">:'-(</xsl:when>
					<xsl:when test="@TYPE = 'hug'">{{{}}}</xsl:when>
					<xsl:when test="@TYPE = 'kiss'">:-*</xsl:when>
					<xsl:when test="@TYPE = 'yawn'">:-O</xsl:when>
					<xsl:when test="@TYPE = 'zzz'">|-I</xsl:when>
					<xsl:when test="@TYPE = 'fish'">&gt;&lt;&gt;</xsl:when>
					<xsl:when test="@TYPE = 'hsif'">&lt;&gt;&lt;&lt;</xsl:when>
					<xsl:when test="@TYPE = 'ale'">c|_|</xsl:when>
					<xsl:when test="@TYPE = 'bubbly'">&gt;-|</xsl:when>
					<xsl:when test="@TYPE = 'coffee'">c\_/</xsl:when>
					<xsl:when test="@TYPE = 'drunk'">:*)</xsl:when>
					<xsl:when test="@TYPE = 'empty'">\_/</xsl:when>
					<xsl:when test="@TYPE = 'oj'">|%|</xsl:when>
					<xsl:when test="@TYPE = 'redwine'">\R/</xsl:when>
					<xsl:when test="@TYPE = 'stiffdrink'">\%/</xsl:when>
					<xsl:when test="@TYPE = 'stout'">g|_|</xsl:when>
					<xsl:when test="@TYPE = 'bigeyes'">8-)</xsl:when>
					<xsl:when test="@TYPE = 'biggrin'">:-D</xsl:when>
					<xsl:when test="@TYPE = 'blush'">@'.'@</xsl:when>
					<xsl:when test="@TYPE = 'cool'">B-)</xsl:when>
					<xsl:when test="@TYPE = 'cross'">X-|</xsl:when>
					<xsl:when test="@TYPE = 'erm'">:-/</xsl:when>
					<xsl:when test="@TYPE = 'sadface'">:-(</xsl:when>
					<xsl:when test="@TYPE = 'smiley'">:-)</xsl:when>
					<xsl:when test="@TYPE = 'tongueout'">:-P</xsl:when>
					<xsl:when test="@TYPE = 'winkeye'">;-)</xsl:when>
					<xsl:when test="@TYPE = 'cupcake'">@\_/</xsl:when>
					<xsl:when test="@TYPE = 'musicalnote'">o/~</xsl:when>
					<xsl:when test="@TYPE = 'rose'">@-&gt;--</xsl:when>
					<xsl:when test="@TYPE = 'spork'">--OE</xsl:when>
					<xsl:when test="@TYPE = 'tennisball'">-=@</xsl:when>
					<xsl:when test="@TYPE = 'racket1'">==O</xsl:when>
					<xsl:when test="@TYPE = 'racket2'">O==</xsl:when>
					<xsl:when test="@TYPE = 'borg'">:-)==0</xsl:when>
					<xsl:when test="@TYPE = 'clown'">K:o)</xsl:when>
					<xsl:when test="@TYPE = 'doctor'">o:-)</xsl:when>
					<xsl:when test="@TYPE = 'nurse'">+:-)</xsl:when>
					<xsl:when test="@TYPE = 'xmastree'">=&gt;&gt;&gt;</xsl:when>
					<xsl:when test="@TYPE = 'angel'">O:-)</xsl:when>
					<xsl:when test="@TYPE = 'vampire'">:-[</xsl:when>
					<xsl:otherwise>&lt;<xsl:value-of select="@TYPE"/>&gt;</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<!--<xsl:choose>
					<xsl:when test="@H2G2|@h2g2|@BIO|@bio|@HREF|@href">
						<xsl:variable name="url">
							<xsl:value-of select="@H2G2|@h2g2|@BIO|@bio|@HREF|@href"/>
						</xsl:variable>
						<a href="{$root}{$url}">
						<xsl:if test="substring($url, 0, 1) != '#'">
								<xsl:attribute name="target">_top</xsl:attribute>
							</xsl:if>
						<img border="0" alt="{@TYPE}" title="{@TYPE}">
							<xsl:choose>
								<xsl:when test="@TYPE='fish' and number(../../USER/USERID) = 23">
									<xsl:attribute name="src"><xsl:value-of select="$smileysource"/>s_fish.gif</xsl:attribute>
									<xsl:attribute name="alt">Shim's Blue Fish</xsl:attribute>
									<xsl:attribute name="title">Shim's Blue Fish</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="src"><xsl:value-of select="$smileysource"/>f_<xsl:value-of select="translate(@TYPE,$uppercase,$lowercase)"/>.gif</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</img>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<img border="0" alt="{@TYPE}" title="{@TYPE}">
							<xsl:choose>
								<xsl:when test="@TYPE='fish' and number(../../USER/USERID) = 23">
									<xsl:attribute name="src"><xsl:value-of select="$smileysource"/>s_fish.gif</xsl:attribute>
									<xsl:attribute name="alt">Shim's Blue Fish</xsl:attribute>
									<xsl:attribute name="title">Shim's Blue Fish</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="src"><xsl:value-of select="$smileysource"/>f_<xsl:value-of select="@TYPE"/>.gif</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</img>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>-->
	</xsl:template>
	<xsl:template match="*" mode="removeBrs">
		<xsl:for-each select="*[not(self::BR)]">
			<xsl:copy>
				<xsl:copy-of select="@*|text()"/>
				<xsl:apply-templates select="*" mode="removeBrs"/>
			</xsl:copy>
		</xsl:for-each>
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
										<!-- <xsl:value-of select="/H2G2/FORUMTHREADPOSTS/POST[USER/USERID = current()/@USERID]/USER/USERNAME"/> -->
										<xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS/POST[USER/USERID = current()/@USERID]/USER" mode="username"/>
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
	<xsl:template match="TEXT">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="ERRORS">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>
	<xsl:template match="XMLERROR">
		<span style="font-weight: bold; color: #ff0000; font-size:110%;">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="ERROR" mode="error_popup">
		<xsl:choose>
			<xsl:when test=". = 'A Topic with the same title already exists for this site'">
				<script type="text/javascript">
					alert('This topic name already exists.\n\nPlease edit these details, or click "back" to return to the Topic list.');
				</script>
			</xsl:when>
			<xsl:when test=". = 'A BoardPromo Already Exists With That Name!'">
				<script type="text/javascript">
					alert('This promo name already exists.\n\nPlease edit these details, or click "back" to return to the Promo list.');
				</script>
			</xsl:when>
			<xsl:when test="@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:variable name="input_name">
					<xsl:choose>
						<xsl:when test="../../@NAME = 'ASSETCOMPLAIN'">Complain about this message filename</xsl:when>
						<xsl:when test="../../@NAME = 'ASSETNEW'">New Message filename</xsl:when>
						<xsl:when test="../../@NAME = 'BARLEYVARIANT'">Layout template variant</xsl:when>
						<xsl:when test="../../@NAME = 'BOARDNAME'">Board Name</xsl:when>
						<xsl:when test="../../@NAME = 'BOARDROOT'">Board URL</xsl:when>
						<xsl:when test="../../@NAME = 'BOARDSSOLINK'">Board SSO Link</xsl:when>
						<xsl:when test="../../@NAME = 'CODEBANNER'">Banner HTML</xsl:when>
						<xsl:when test="../../@NAME = 'CSSLOCATION'">Filename</xsl:when>
						<xsl:when test="../../@NAME = 'FEATURESMILEYS'">Emoticons</xsl:when>
						<xsl:when test="../../@NAME = 'LINKPATH'">Link path</xsl:when>
						<xsl:when test="../../@NAME = 'NAVLHN'">Left hand navigation</xsl:when>
						<xsl:when test="../../@NAME = 'PATHDEV'">Development file path</xsl:when>
						<xsl:when test="../../@NAME = 'PATHLIVE'">Live file path</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<script type="text/javascript">
					alert('You must add a value for <xsl:value-of select="$input_name"/>');
				</script>
			</xsl:when>
			<xsl:otherwise>
				<div id="error">
					<xsl:apply-templates select="."/>
					<p class="button">
						<a href="#" onclick="document.getElementById('error').style.display = 'none';">OK</a>
					</p>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Dropdown that the editors use to move threads from one topic to another -->
	<xsl:variable name="movedropdown">
		<xsl:for-each select="/H2G2/TOPICLIST/TOPIC">
			<option value="F{FORUMID}">
				<xsl:value-of select="TITLE"/>
			</option>
		</xsl:for-each>
	</xsl:variable>
	<!--Overriding default sso bar behaviour-->
	<xsl:variable name="sso_managelink">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
				<xsl:value-of select="$sso_resources"/>
				<xsl:value-of select="$sso_script"/>?c=rd&amp;service=<xsl:value-of select="$sso_serviceid_link"/>&amp;ptrt=<xsl:value-of select="$sso_redirectserver"/>
				<xsl:value-of select="$root"/>SSO?pa=editdetails&amp;s_return=<xsl:value-of select="$referrer"/>?s_sync=1
			 </xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$sso_resources"/>
				<xsl:value-of select="$sso_script"/>?c=rd&amp;service=<xsl:value-of select="$sso_serviceid_link"/>&amp;ptrt=<xsl:value-of select="$sso_redirectserver"/>
				<xsl:value-of select="$root"/>SSO%3Fpa=changeddetails?s_return=<xsl:value-of select="$referrer"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
</xsl:stylesheet>
