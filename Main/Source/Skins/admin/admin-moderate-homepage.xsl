<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	The home page for the moderation tools
-->
	<xsl:template match="H2G2[@TYPE=&quot;MODERATE-HOME&quot;]">
		<!-- Since this page has been completely rejigged for the new moderation system, this first choose statement checks the XML that is in the page and 
			works out whether we are using a new style or old style page -->
		<xsl:choose>
			<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES">
        <!-- This is the newModeration Home Page. -->
				<!-- Since this is an old style page we have to include the entire page information at this point, normally the page furniture type content would be
					called in from editorstools.xsl for the new style moderation pages -->
				<html>
					<head>
						<title>
							<xsl:value-of select="$m_pagetitlestart"/>
							<xsl:text>Moderation Homepage</xsl:text>
						</title>
						<link type="text/css" rel="stylesheet" href="{$asset-root}moderation/includes/moderation.css"/>
						<link type="text/css" rel="stylesheet" href="{$asset-root}moderation/includes/moderation_only.css"/>
						<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login.css"/>
						<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login2.css"/>

					</head>
					<body id="modHomepage">
						<xsl:if test="/H2G2/@TYPE = 'USER-DETAILS-PAGE'">
							<xsl:attribute name="onload">durationChange()</xsl:attribute>
						</xsl:if>
						<xsl:call-template name="sso_statusbar-admin"/>
						<h1>
							<img src="{$asset-root}moderation/images/dna_logo.jpg" width="179" height="48" alt="DNA"/>
						</h1>
						<ul id="siteNavigation">
							<li class="selected">
								<a href="moderate?newstyle=1">Main</a>
							</li>
							<!--<li>
								<a href="#">My History</a>
							</li>
							<li class="selected">
								<a href="#">All Histories</a>
							</li>-->
							<xsl:if test="$test_IsEditor">
								<li>
									<a href="memberlist">Members</a>
								</li>
							</xsl:if>
						</ul>
						<!-- The boxes get repeated for each of the moderation classes and so we have a for-each here to cycle through them -->
						<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = /H2G2/MODERATOR-HOME/MODERATOR/CLASSES/CLASSID]">
							<ul id="classNavigation">
								<li>
									<!--<xsl:attribute name="class"><xsl:choose><xsl:when test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/USERS-LIST/@SITEID]/CLASSID = current()/@CLASSID">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>-->
									<xsl:attribute name="class">selected</xsl:attribute>
									<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
									<a>
                    <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS=2">
                      <xsl:attribute name="href">ModerationClassAdmin</xsl:attribute>
                    </xsl:if>
										<xsl:value-of select="NAME"/>
									</a>
								</li>
							</ul>
							<div class="mainContent">
								<!-- Editors and super users get different links in the top section of each box to moderators -->
								<!--<xsl:if test="$test_IsEditor">
									<p class="postModLink">
										<xsl:text>PRE/POST-MODERATION </xsl:text>
										<a href="#">manage</a>
									</p>
								</xsl:if>-->
								<p class="fastModLink">
									<xsl:text>FAST-MODERATION </xsl:text>
									<xsl:if test="$test_IsEditor">
										<a href="managefastmod?s_classview={@CLASSID}">manage</a>
										<xsl:text> | </xsl:text>
									</xsl:if>
									<a href="moderate?newstyle=1&amp;fastmod=1&amp;notfastmod=1">moderate</a>
								</p>
								<div class="columnLeft">
									<!-- This is the posts box -->
									<table class="postItems">
										<thead>
											<tr>
												<td colspan="2">
													<!-- If the user is viewing the fas moderation list then they get that highlighted here -->
													<xsl:if test="/H2G2/MODERATOR-HOME/@FASTMOD = 1">
														<span class="fastmodCrumb">
															<xsl:text>FAST-MODERATED </xsl:text>
														</span>
													</xsl:if>
													<xsl:text>POSTS</xsl:text>
												</td>
											</tr>
										</thead>
										<tbody>
											<!-- This checks to see if the forum complaint queued and forum complaint locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This check to see if the forum complaint queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> alerts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>alerts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This check to see if the forum complaint locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum complaint queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the forum queued and forum locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This checks to see if the forum queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> posts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>posts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This checks to see if the forum locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the forum complaint referred and forum complaint referred locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This checks to see if the forum complaint referred queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;alerts=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> referred alerts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>referred alerts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This checks to see if the forum complaint referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;alerts=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum complaint referred queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the forum referred and forum referred locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This checks to see if the forum reffered queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> referred posts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>referred posts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This checks to see if the forum referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateposts?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum referred queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!--<tr>
												<td>
													<p>
														<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'queued']/@TOTAL"/>
														<xsl:text> referred posts on hold</xsl:text>
													</p>
												</td>
												<td>
													<p>submitted from blah</p>
												</td>
											</tr>-->
											<!-- if any of the queues are not empty then this displays the unlock button for all the post queues -->
											<xsl:if test="(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forumcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0))">
												<tr>
													<td colspan="2">
														<form action="moderate" method="post">
															<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
															<input type="hidden" name="newstyle" value="1"/>
															<input type="hidden" name="fastmod" value="{/H2G2/MODERATOR-HOME/@FASTMOD}"/>
															<input type="hidden" name="modclassid" value="{@CLASSID}"/>
															<input type="hidden" name="unlockuserposts" value="1"/>
															<input type="submit" class="unlock-button" value="Unlock"/>
														</form>
														<!--<xsl:if test="$superuser = 1">
															<form action="moderate" method="post">
															<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
															<input type="hidden" name="newstyle" value="1"/>
															<input type="hidden" name="fastmod" value="{/H2G2/MODERATOR-HOME/@FASTMOD}"/>
															<input type="hidden" name="modclass" value="{@CLASSID}"/>
															<input type="hidden" name="unlockall" value="1"/>
															<input type="submit" class="unlock-button" value="Unlock All"/>
														</form>
														</xsl:if>-->
													</td>
												</tr>
											</xsl:if>
										</tbody>
									</table>
									<!-- general complaints only appear if the user is an editor or a super user -->
									<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreferred'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
										<table class="generalItems">
											<thead>
												<tr>
													<td colspan="2">GENERAL ALERTS</td>
												</tr>
											</thead>
											<tbody>
												<!-- This checks to see if the general complaint and general complaint locked queues exists in the XML -->
												<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
													<tr>
														<td>
															<p>
																<!-- This checks to see if the general complaint queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
																<xsl:choose>
																	<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																		<a>
																			<xsl:attribute name="href"><xsl:text>moderationtopframe?next=process&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/>&amp;s_newstyle=1</xsl:attribute>
																			<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																			<xsl:text> general alerts</xsl:text>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																			<xsl:text>no </xsl:text>
																		</xsl:if>
																		<xsl:text>general alerts</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
																<!-- This checks to see if the general complaint locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
																<xsl:choose>
																	<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																		<a>
																			<xsl:attribute name="href"><xsl:text>moderationtopframe?next=process&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/>&amp;s_newstyle=1</xsl:attribute>
																			<xsl:text> (</xsl:text>
																			<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																			<xsl:text> locked)</xsl:text>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:text> (none locked)</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
															</p>
														</td>
														<td>
															<!-- This displays the age of the items in the general complaint queue if that queue has content -->
															<xsl:choose>
																<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued']">
																	<p>
																		<xsl:text>submitted </xsl:text>
																		<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued']/DATE" mode="mod_home"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>&nbsp;</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</td>
													</tr>
												</xsl:if>
												<!-- This checks to see if the general complaint referred and general compalint referred locked queues exists in the XML -->
												<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreferred'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
													<tr>
														<td>
															<p>
																<!-- This checks to see if the general complaint queue referred has any content, if it does you build the link, if not then simply a piece of text is displayed-->
																<xsl:choose>
																	<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																		<a>
																			<xsl:attribute name="href"><xsl:text>moderationtopframe?next=process&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/>&amp;s_newstyle=1</xsl:attribute>
																			<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																			<xsl:text> referred general alerts</xsl:text>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																			<xsl:text>no </xsl:text>
																		</xsl:if>
																		<xsl:text>referred general alerts</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
																<!-- This checks to see if the general complaint referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
																<xsl:choose>
																	<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																		<a>
																			<xsl:attribute name="href"><xsl:text>moderationtopframe?next=process&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/>&amp;s_newstyle=1</xsl:attribute>
																			<xsl:text> (</xsl:text>
																			<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																			<xsl:text> locked)</xsl:text>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:text> (none locked)</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
															</p>
														</td>
														<td>
															<!-- This displays the age of the items in the general complaint referred queue if that queue has content -->
															<xsl:choose>
																<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered']">
																	<p>
																		<xsl:text>submitted </xsl:text>
																		<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered']/DATE" mode="mod_home"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>&nbsp;</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</td>
													</tr>
												</xsl:if>
												<!-- if any of the queues are not empty then this displays the unlock button for all the post queues -->
												<xsl:if test="(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'generalcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0))">
													<tr>
														<td colspan="2">
															<form action="moderate" method="post">
																<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
																<input type="hidden" name="newstyle" value="1"/>
																<input type="hidden" name="modclassid" value="{@CLASSID}"/>
																<input type="hidden" name="unlockgeneral" value="Unlock General"/>
																<input type="hidden" name="UnlockGeneralReferrals" value="Unlock General Referrals"/>
																<input type="submit" class="unlock-button" value="Unlock"/>
															</form>
														</td>
													</tr>
												</xsl:if>
											</tbody>
										</table>
									</xsl:if>
								</div>
								<div class="columnRight">
									<table class="entryItems">
										<thead>
											<tr>
												<td colspan="2">ENTRIES</td>
											</tr>
										</thead>
										<tbody>
											<!-- This checks to see if the entry complaint queued and entry complaint locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This check to see if the entry complaint queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> entry alerts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>entry alerts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This check to see if the forum complaint locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the entry complaint queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the entry queued and entry locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This check to see if the entry queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> entries</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>entries</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This check to see if the entry locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the entry queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the entry alert referred queued and entry alert referred locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This check to see if the entry complaint referred queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1&amp;referrals=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> referred entry alerts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>referred entry alerts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This check to see if the entry complaint referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1&amp;referrals=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the entry complaint referred queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the entry referred queued and entry referred locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This check to see if the entry referred queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> referred entries</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>referred entries</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This check to see if the entry referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderatearticle?newstyle=1&amp;s_style=new&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the entry complaint referred queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- if any of the queues are not empty then this displays the unlock button for all the post queues -->
											<xsl:if test="(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entrycomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'entry'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'forum'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0))">
												<tr>
													<td colspan="2">
														<form action="moderate" method="post">
															<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
															<input type="hidden" name="newstyle" value="1"/>
															<input type="hidden" name="fastmod" value="{/H2G2/MODERATOR-HOME/@FASTMOD}"/>
															<input type="hidden" name="modclassid" value="{@CLASSID}"/>
															<input type="hidden" name="unlockarticles" value="1"/>
															<input type="submit" class="unlock-button" value="Unlock"/>
														</form>
													</td>
												</tr>
											</xsl:if>
										</tbody>
									</table>
									<!-- nicknames only appear if the queues exist in the XML -->
									<xsl:if test="$test_IsEditor">
										<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
											<table class="nicknameItems">
												<thead>
													<tr>
														<td colspan="2">NICKNAMES</td>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>
															<p>
																<!-- This check to see if the nicknames queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
																<xsl:choose>
																	<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																		<a>
																			<xsl:attribute name="href"><xsl:text>moderatenicknames?newstyle=1&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																			<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																			<xsl:text> nicknames</xsl:text>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																			<xsl:text>no </xsl:text>
																		</xsl:if>
																		<xsl:text>nicknames</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
																<!-- This check to see if the nicknames locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
																<xsl:choose>
																	<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																		<a>
																			<xsl:attribute name="href"><xsl:text>moderatenicknames?newstyle=1&amp;modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																			<xsl:text> (</xsl:text>
																			<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																			<xsl:text> locked)</xsl:text>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:text> (none locked)</xsl:text>
																	</xsl:otherwise>
																</xsl:choose>
															</p>
														</td>
														<td>
															<!-- This displays the age of the items in the nicknames queue if that queue has content -->
															<xsl:choose>
																<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'queued']">
																	<p>
																		<xsl:text>submitted </xsl:text>
																		<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'queued']/DATE" mode="mod_home"/>
																	</p>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> </xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</td>
													</tr>
													<!-- if any of the queues are not empty then this displays the unlock button for all the post queues -->
													<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'nickname'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
														<tr>
															<td colspan="2">
																<form action="moderate" method="post">
																	<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
																	<input type="hidden" name="newstyle" value="1"/>
																	<input type="hidden" name="modclassid" value="{@CLASSID}"/>
																	<input type="submit" name="UnlockNicknames" value="Unlock"/>
																</form>
															</td>
														</tr>
													</xsl:if>
												</tbody>
											</table>
										</xsl:if>
									</xsl:if>
								</div>
								<div style="clear: both;"> </div>
								<div class="columnLeft">
									<table class="postItems">
										<thead>
											<tr>
												<td colspan="2">
													<xsl:text>LINKS</xsl:text>
												</td>
											</tr>
										</thead>
										<tbody>
											<!-- This checks to see if the forum complaint queued and forum complaint locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This check to see if the forum complaint queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> alerts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>alerts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This check to see if the forum complaint locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;alerts=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum complaint queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the forum queued and forum locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This checks to see if the forum queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> items</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>items</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This checks to see if the forum locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queued'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the forum complaint referred and forum complaint referred locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This checks to see if the forum complaint referred queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;alerts=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> referred alerts</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>referred alerts</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This checks to see if the forum complaint referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;alerts=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum complaint referred queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!-- This checks to see if the forum referred and forum referred locked queues exists in the XML -->
											<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] or /H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
												<tr>
													<td>
														<p>
															<!-- This checks to see if the forum reffered queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> referred items</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0">
																		<xsl:text>no </xsl:text>
																	</xsl:if>
																	<xsl:text>referred items</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
															<!-- This checks to see if the forum referred locked queue has any content, if it does you build the link, if not then simply a piece of text is displayed-->
															<xsl:choose>
																<xsl:when test="not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)">
																	<a>
																		<xsl:attribute name="href"><xsl:text>moderateexlinks?modclassid=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;s_classview=</xsl:text><xsl:value-of select="current()/@CLASSID"/><xsl:text>&amp;referrals=1&amp;locked=1</xsl:text><xsl:text>&amp;fastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@FASTMOD"/><xsl:text>&amp;notfastmod=</xsl:text><xsl:value-of select="/H2G2/MODERATOR-HOME/@NOTFASTMOD"/></xsl:attribute>
																		<xsl:text> (</xsl:text>
																		<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL"/>
																		<xsl:text> locked)</xsl:text>
																	</a>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text> (none locked)</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</p>
													</td>
													<td>
														<!-- This displays the age of the items in the forum referred queue if that queue has content -->
														<xsl:choose>
															<xsl:when test="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]">
																<p>
																	<xsl:text>submitted </xsl:text>
																	<xsl:apply-templates select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queuedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/DATE" mode="mod_home"/>
																</p>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>&nbsp;</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
											<!--<tr>
												<td>
												<p>
												<xsl:value-of select="/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'queued']/@TOTAL"/>
												<xsl:text> referred posts on hold</xsl:text>
												</p>
												</td>
												<td>
												<p>submitted from blah</p>
												</td>
												</tr>-->
											<!-- if any of the queues are not empty then this displays the unlock button for all the post queues -->
											<xsl:if test="(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'locked'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlinkcomplaint'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0)) or (/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD] and not(/H2G2/MODERATOR-HOME/MODERATION-QUEUES/MODERATION-QUEUE-SUMMARY[OBJECT-TYPE = 'exlink'][@CLASSID = current()/@CLASSID][STATE = 'lockedreffered'][@FASTMOD = /H2G2/MODERATOR-HOME/@FASTMOD]/@TOTAL = 0))">
												<tr>
													<td colspan="2">
														<form action="moderate" method="post">
															<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
															<input type="hidden" name="newstyle" value="1"/>
															<input type="hidden" name="fastmod" value="{/H2G2/MODERATOR-HOME/@FASTMOD}"/>
															<input type="hidden" name="modclassid" value="{@CLASSID}"/>
															<input type="hidden" name="unlockuserexlinks" value="1"/>
															<input type="submit" class="unlock-button" value="Unlock"/>
															</form>
														<!--<xsl:if test="$superuser = 1">
															<form action="moderate" method="post">
															<input type="hidden" name="UserID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
															<input type="hidden" name="newstyle" value="1"/>
															<input type="hidden" name="fastmod" value="{/H2G2/MODERATOR-HOME/@FASTMOD}"/>
															<input type="hidden" name="modclass" value="{@CLASSID}"/>
															<input type="hidden" name="unlockall" value="1"/>
															<input type="submit" class="unlock-button" value="Unlock All"/>
															</form>
															</xsl:if>-->
													</td>
												</tr>
											</xsl:if>
										</tbody>
									</table>
								</div>
							</div>
						</xsl:for-each>
					</body>
				</html>
			</xsl:when>
			<xsl:otherwise>
				<html>
					<head>
						<!-- prevent browsers caching the page -->
						<meta http-equiv="Cache-Control" content="no cache"/>
						<meta http-equiv="Pragma" content="no cache"/>
						<meta http-equiv="Expires" content="0"/>
						<META NAME="robots" CONTENT="{$robotsetting}"/>
						<title>h2g2 : Moderation</title>
						<style type="text/css">
							<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
						</style>
						<script language="JavaScript">
							<xsl:comment> hide this script from non-javascript-enabled browsers

function confirmUnlockOnOtherUser()
{
	<xsl:if test="$ownerisviewer != 1">
		return confirm('Warning! Unlocking other users moderation items whilst they are working on them can cause confusion. Are you sure you wish to proceed?')
	</xsl:if>
	return true;
}

// unhide </xsl:comment>
						</script>
					</head>
					<body bgColor="lightblue">
						<div class="ModerationTools">
							<h2 align="center">
								<xsl:if test="/H2G2/MODERATOR-HOME/MODERATION/@FASTMOD=1">Fast </xsl:if>Moderation Home Page for <br/>
								<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER"/>
							</h2>
							<form method="post" action="{$root}Moderate">
								<table border="0" cellPadding="0" cellSpacing="0" width="100%">
									<tr>
										<td align="left"> Logged in as <b>
												<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
											</b>
										</td>
										<td align="right">
											<a href="{$root}ModerateStats">Moderation Stats Page</a>
											<br/>
											<a href="{$root}ModerationBilling">Moderation Billing Page</a>
											<br/>
											<a href="{$root}moderate?fastmod=1&amp;notfastmod=0">Fast Mod Homepage</a>
											<br/>
										</td>
									</tr>
								</table>
								<br/>
								<input type="hidden" name="UserID" value="{/H2G2/MODERATOR-HOME/@USER-ID}"/>
								<xsl:if test="$test_IsModerator and /H2G2/MODERATOR-HOME/MODERATION/@FASTMOD=1">
									<input type="hidden" name="fastmod" value="1"/>
									<input type="hidden" name="notfastmod" value="0"/>
									<table border="1" cellPadding="0" cellSpacing="0" width="100%">
										<!-- do the column headings -->
										<tr align="center" vAlign="top">
											<td colspan="4">
												<b>Fast Mod</b>
											</td>
										</tr>
										<tr align="center" vAlign="top">
											<td colspan="2">
												<b>Forum Moderation</b>
											</td>
											<td colspan="2">
												<b>Forum Referrals</b>
											</td>
										</tr>
										<tr align="left" vAlign="top">
											<td width="16.6%">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<xsl:if test="$ownerisviewer = 0">
														<tr>
															<td align="center" valign="top"> New </td>
														</tr>
													</xsl:if>
													<xsl:if test="$ownerisviewer = 1">
														<tr>
															<td align="center" valign="top">
																<a href="{$root}ModerateForums?Next=Process&amp;show=new&amp;Referrals=0&amp;fastmod=1&amp;notfastmod=0">New</a>
															</td>
														</tr>
													</xsl:if>
												</table>
											</td>
											<td width="16.6%">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<xsl:if test="$ownerisviewer = 0">
														<tr>
															<td align="center" valign="top"> Complaints </td>
														</tr>
													</xsl:if>
													<xsl:if test="$ownerisviewer = 1">
														<tr>
															<td align="center" valign="top">
																<a href="{$root}ModerateForums?Next=Process&amp;show=complaints&amp;Referrals=0&amp;fastmod=1&amp;notfastmod=0">Complaints</a>
															</td>
														</tr>
													</xsl:if>
												</table>
											</td>
											<td width="16.6%">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<xsl:if test="$ownerisviewer = 0">
														<tr>
															<td align="center" valign="top"> New </td>
														</tr>
													</xsl:if>
													<xsl:if test="$ownerisviewer = 1">
														<tr>
															<td align="center" valign="top">
																<a href="{$root}ModerateForums?Next=Process&amp;show=new&amp;Referrals=1&amp;fastmod=1&amp;notfastmod=0">New</a>
															</td>
														</tr>
													</xsl:if>
												</table>
											</td>
											<td width="16.6%">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<xsl:if test="$ownerisviewer = 0">
														<tr>
															<td align="center" valign="top"> Complaints </td>
														</tr>
													</xsl:if>
													<xsl:if test="$ownerisviewer = 1">
														<tr>
															<td align="center" valign="top">
																<a href="{$root}ModerateForums?Next=Process&amp;show=complaints&amp;Referrals=1&amp;fastmod=1&amp;notfastmod=0">Complaints</a>
															</td>
														</tr>
													</xsl:if>
												</table>
											</td>
										</tr>
										<tr align="left" vAlign="top">
											<td>
												<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=1]/FORUMS/NEW/LOCKED) > 0">
													<xsl:attribute name="bgColor">red</xsl:attribute>
												</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=1]/FORUMS/NEW/LOCKED"/>
											</td>
											<td>
												<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=1]/FORUMS/COMPLAINTS/LOCKED) > 0">
													<xsl:attribute name="bgColor">red</xsl:attribute>
												</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=1]/FORUMS/COMPLAINTS/LOCKED"/>
											</td>
											<td>
												<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=1]/FORUMS/NEW/LOCKED) > 0">
													<xsl:attribute name="bgColor">red</xsl:attribute>
												</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=1]/FORUMS/NEW/LOCKED"/>
											</td>
											<td>
												<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=1]/FORUMS/COMPLAINTS/LOCKED) > 0">
													<xsl:attribute name="bgColor">red</xsl:attribute>
												</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=1]/FORUMS/COMPLAINTS/LOCKED"/>
											</td>
										</tr>
										<tr align="left" vAlign="top">
											<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=1]/FORUMS/NEW/QUEUED"/>
											</td>
											<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=1]/FORUMS/COMPLAINTS/QUEUED"/>
											</td>
											<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=1]/FORUMS/NEW/QUEUED"/>
											</td>
											<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=1]/FORUMS/COMPLAINTS/QUEUED"/>
											</td>
										</tr>
										<tr align="center" vAlign="top">
											<td colspan="2" rowspan="2">
												<input type="submit" name="UnlockForums" value="Unlock Fastmod Forums" onClick="return confirmUnlockOnOtherUser()"/>
											</td>
											<td colspan="2" rowspan="2">
												<input type="submit" name="UnlockForumReferrals" value="Unlock Fastmod Forum Referrals" onClick="return confirmUnlockOnOtherUser()"/>
											</td>
										</tr>
									</table>
									<br/>
									<br/>
								</xsl:if>
								<xsl:if test="not(/H2G2/MODERATOR-HOME/MODERATION/@FASTMOD=1)">
									<xsl:if test="($test_IsModerator or $test_IsAssetModerator)">
										<table border="1" cellPadding="0" cellSpacing="0" width="100%">
											<!-- do the column headings -->
											<tr align="center" vAlign="top">
												<td colspan="4">
													<b>Moderation</b>
												</td>
											</tr>
											<tr align="center" vAlign="top">
												<td colspan="2">
													<b>Forums</b>
												</td>
												<td colspan="2">
													<b>Entries</b>
												</td>
											</tr>
											<tr align="left" vAlign="top">
												<td width="16.6%">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<xsl:if test="$ownerisviewer = 0">
															<tr>
																<td align="center" valign="top"> New </td>
															</tr>
														</xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<tr>
																<td align="center" valign="top">
																	<a href="{$root}ModerateForums?Next=Process&amp;show=new&amp;Referrals=0">New</a>
																</td>
															</tr>
														</xsl:if>
													</table>
												</td>
												<td width="16.6%">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<xsl:if test="$ownerisviewer = 0">
															<tr>
																<td align="center" valign="top"> Complaints </td>
															</tr>
														</xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<tr>
																<td align="center" valign="top">
																	<a href="{$root}ModerateForums?Next=Process&amp;show=complaints&amp;Referrals=0">Complaints</a>
																</td>
															</tr>
														</xsl:if>
													</table>
												</td>
												<!--
							<td width="16.6%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<xsl:if test="$ownerisviewer = 0">
									<tr>
										<td align="center" valign="top">
											Legacy
										</td>
									</tr>
									</xsl:if>
									<xsl:if test="$ownerisviewer = 1">
										<tr>
											<td align="center" valign="top">
												<a href="{$root}ModerateArticle?Next=Process&amp;show=legacy&amp;Referrals=0">Legacy</a>
											</td>
										</tr>
									</xsl:if>
								</table>
							</td>
							-->
												<td width="16.6%">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<xsl:if test="$ownerisviewer = 0">
															<tr>
																<td align="center" valign="top"> New </td>
															</tr>
														</xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<tr>
																<td align="center" valign="top">
																	<a href="{$root}ModerateArticle?Next=Process&amp;show=new&amp;Referrals=0">New</a>
																</td>
															</tr>
														</xsl:if>
													</table>
												</td>
												<td width="16.6%">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<xsl:if test="$ownerisviewer = 0">
															<tr>
																<td align="center" valign="top"> Complaints </td>
															</tr>
														</xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<tr>
																<td align="center" valign="top">
																	<a href="{$root}ModerateArticle?Next=Process&amp;show=complaints&amp;Referrals=0">Complaints</a>
																</td>
															</tr>
														</xsl:if>
													</table>
												</td>
											</tr>
											<tr align="left" vAlign="top">
												<!--
							<td>
								<xsl:if test="number(MODERATOR-HOME/MODERATION/FORUMS/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
								Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/LEGACY/LOCKED"/>
							</td>
							-->
												<td>
													<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/FORUMS/NEW/LOCKED) > 0">
														<xsl:attribute name="bgColor">red</xsl:attribute>
													</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/FORUMS/NEW/LOCKED"/>
												</td>
												<td>
													<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/FORUMS/COMPLAINTS/LOCKED) > 0">
														<xsl:attribute name="bgColor">red</xsl:attribute>
													</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/FORUMS/COMPLAINTS/LOCKED"/>
												</td>
												<!--
							<td>
								<xsl:if test="number(MODERATOR-HOME/MODERATION/ARTICLES/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
								Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/LEGACY/LOCKED"/>
							</td>
							-->
												<td>
													<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/ARTICLES/NEW/LOCKED) > 0">
														<xsl:attribute name="bgColor">red</xsl:attribute>
													</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/ARTICLES/NEW/LOCKED"/>
												</td>
												<td>
													<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/ARTICLES/COMPLAINTS/LOCKED) > 0">
														<xsl:attribute name="bgColor">red</xsl:attribute>
													</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/ARTICLES/COMPLAINTS/LOCKED"/>
												</td>
											</tr>
											<tr align="left" vAlign="top">
												<!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/FORUMS/LEGACY/QUEUED"/></td> -->
												<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/FORUMS/NEW/QUEUED"/>
												</td>
												<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/FORUMS/COMPLAINTS/QUEUED"/>
												</td>
												<!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION/ARTICLES/LEGACY/QUEUED"/></td> -->
												<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/ARTICLES/NEW/QUEUED"/>
												</td>
												<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/ARTICLES/COMPLAINTS/QUEUED"/>
												</td>
											</tr>
											<tr align="center" vAlign="top">
												<td colspan="2" rowspan="2">
													<input type="submit" name="UnlockForums" value="Unlock Forums" onClick="return confirmUnlockOnOtherUser()"/>
												</td>
												<td colspan="2" rowspan="2">
													<input type="submit" name="UnlockArticles" value="Unlock Entries" onClick="return confirmUnlockOnOtherUser()"/>
												</td>
											</tr>
										</table>
										<br/>
									</xsl:if>
									<xsl:if test="/H2G2/SITECONFIG/SITE = 'ican'">
										<div align="center">
											<table border="1" cellPadding="0" cellSpacing="0">
												<tr align="center" vAlign="top">
													<td colspan="2">
														<b>
															<span class="moderationheader">Images</span>
														</b>
													</td>
												</tr>
												<tr align="center" vAlign="top">
													<td width="50%">
														<xsl:if test="$ownerisviewer = 0"> New </xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<a href="{$root}ModerateImages?Next=Process&amp;Show=new&amp;Referrals=0">New</a>
														</xsl:if>
													</td>
													<td width="50%">
														<xsl:if test="$ownerisviewer = 0"> Complaints </xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<a href="{$root}ModerateImages?Next=Process&amp;Show=complaints&amp;Referrals=0">Complaints</a>
														</xsl:if>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<td>
														<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/IMAGES/NEW/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/IMAGES/NEW/LOCKED"/>
													</td>
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/COMPLAINTS/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/COMPLAINTS/LOCKED"/>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/IMAGES/NEW/QUEUED"/>
													</td>
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/COMPLAINTS/QUEUED"/>
													</td>
												</tr>
												<tr align="center" vAlign="top">
													<td colspan="2">
														<input type="submit" name="UnlockImages" value="Unlock Images" onClick="return confirmUnlockOnOtherUser()"/>
													</td>
												</tr>
											</table>
										</div>
									</xsl:if>
									<br/>
									<!-- stuff for superusers and referees-->
									<xsl:if test="(MODERATOR-HOME/@ISREFEREE = 1 or $superuser = 1)">
										<!-- nickname moderation -->
										<xsl:if test="$test_IsEditor">
											<xsl:if test="(number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/NICKNAMES/NEW/LOCKED) > 0 or number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/NICKNAMES/NEW/QUEUED) > 0)">
												<div align="center">
													<table border="1" cellPadding="0" cellSpacing="0">
														<!-- only one column heading -->
														<tr align="center" vAlign="top">
															<td colspan="1">
																<xsl:if test="$ownerisviewer = 0">
																	<span class="moderationheader">
																		<b>Nicknames</b>
																	</span>
																</xsl:if>
																<xsl:if test="$ownerisviewer = 1">
																	<span class="moderationheader">
																		<b>
																			<a href="{$root}ModerateNicknames?Next=Process">Nicknames</a>
																		</b>
																	</span>
																</xsl:if>
															</td>
														</tr>
														<tr align="left" vAlign="top">
															<td>
																<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/NICKNAMES/NEW/LOCKED) > 0">
																	<xsl:attribute name="bgColor">red</xsl:attribute>
																</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/NICKNAMES/NEW/LOCKED"/>
															</td>
														</tr>
														<tr align="left" vAlign="top">
															<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/NICKNAMES/NEW/QUEUED"/>
															</td>
														</tr>
														<tr align="center" vAlign="top">
															<td colspan="1" rowspan="1">
																<input type="submit" name="UnlockNicknames" value="Unlock Nicknames" onClick="return confirmUnlockOnOtherUser()"/>
															</td>
														</tr>
													</table>
												</div>
											</xsl:if>
										</xsl:if>
										<br/>
										<xsl:if test="$test_IsEditor">
											<table border="1" cellPadding="0" cellSpacing="0" width="100%">
												<tr align="center" vAlign="top">
													<td colspan="6">
														<b>
															<span class="moderationheader">Referrals</span>
														</b>
													</td>
												</tr>
												<tr align="center" vAlign="top">
													<td colspan="2">
														<b>Forums</b>
													</td>
													<td colspan="2">
														<b>Entries</b>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<!--
								<td width="16.6%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$ownerisviewer = 0">
										<tr>
											<td align="center" valign="top">
												Legacy
											</td>
										</tr>
										</xsl:if>
										<xsl:if test="$ownerisviewer = 1">
											<tr>
												<td align="center" valign="top">
													<a href="{$root}ModerateForums?Next=Process&amp;show=legacy&amp;Referrals=1">Legacy</a>
												</td>
											</tr>
										</xsl:if>
									</table>
								</td>
								-->
													<td width="16.6%">
														<table width="100%" border="0" cellspacing="0" cellpadding="0">
															<xsl:if test="$ownerisviewer = 0">
																<tr>
																	<td align="center" valign="top"> New </td>
																</tr>
															</xsl:if>
															<xsl:if test="$ownerisviewer = 1">
																<tr>
																	<td align="center" valign="top">
																		<a href="{$root}ModerateForums?Next=Process&amp;show=new&amp;Referrals=1">New</a>
																	</td>
																</tr>
															</xsl:if>
														</table>
													</td>
													<td width="16.6%">
														<table width="100%" border="0" cellspacing="0" cellpadding="0">
															<xsl:if test="$ownerisviewer = 0">
																<tr>
																	<td align="center" valign="top"> Complaints </td>
																</tr>
															</xsl:if>
															<xsl:if test="$ownerisviewer = 1">
																<tr>
																	<td align="center" valign="top">
																		<a href="{$root}ModerateForums?Next=Process&amp;show=complaints&amp;Referrals=1">Complaints</a>
																	</td>
																</tr>
															</xsl:if>
														</table>
													</td>
													<!--
								<td width="16.6%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$ownerisviewer = 0">
										<tr>
											<td align="center" valign="top">
												Legacy
											</td>
										</tr>
										</xsl:if>
										<xsl:if test="$ownerisviewer = 1">
											<tr>
												<td align="center" valign="top">
													<a href="{$root}ModerateArticle?Next=Process&amp;show=legacy&amp;Referrals=1">Legacy</a>
												</td>
											</tr>
										</xsl:if>
									</table>
								</td>
								-->
													<td width="16.6%">
														<table width="100%" border="0" cellspacing="0" cellpadding="0">
															<xsl:if test="$ownerisviewer = 0">
																<tr>
																	<td align="center" valign="top"> New </td>
																</tr>
															</xsl:if>
															<xsl:if test="$ownerisviewer = 1">
																<tr>
																	<td align="center" valign="top">
																		<a href="{$root}ModerateArticle?Next=Process&amp;show=new&amp;Referrals=1">New</a>
																	</td>
																</tr>
															</xsl:if>
														</table>
													</td>
													<td width="16.6%">
														<table width="100%" border="0" cellspacing="0" cellpadding="0">
															<xsl:if test="$ownerisviewer = 0">
																<tr>
																	<td align="center" valign="top"> Complaints </td>
																</tr>
															</xsl:if>
															<xsl:if test="$ownerisviewer = 1">
																<tr>
																	<td align="center" valign="top">
																		<a href="{$root}ModerateArticle?Next=Process&amp;show=complaints&amp;Referrals=1">Complaints</a>
																	</td>
																</tr>
															</xsl:if>
														</table>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<!--
								<td>
									<xsl:if test="number(MODERATOR-HOME/REFERRALS/FORUMS/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
									Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/LEGACY/LOCKED"/>
								</td>
								-->
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/FORUMS/NEW/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/FORUMS/NEW/LOCKED"/>
													</td>
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/FORUMS/COMPLAINTS/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/FORUMS/COMPLAINTS/LOCKED"/>
													</td>
													<!--
								<td>
									<xsl:if test="number(MODERATOR-HOME/REFERRALS/ARTICLES/LEGACY/LOCKED) > 0"><xsl:attribute name="bgColor">red</xsl:attribute></xsl:if>
									Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/LEGACY/LOCKED"/>
								</td>
								-->
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/ARTICLES/NEW/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/ARTICLES/NEW/LOCKED"/>
													</td>
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/ARTICLES/COMPLAINTS/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/ARTICLES/COMPLAINTS/LOCKED"/>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/FORUMS/LEGACY/QUEUED"/></td> -->
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/FORUMS/NEW/QUEUED"/>
													</td>
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/FORUMS/COMPLAINTS/QUEUED"/>
													</td>
													<!-- <td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS/ARTICLES/LEGACY/QUEUED"/></td> -->
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/ARTICLES/NEW/QUEUED"/>
													</td>
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/ARTICLES/COMPLAINTS/QUEUED"/>
													</td>
												</tr>
												<tr align="center" vAlign="top">
													<td colspan="2" rowspan="2">
														<input type="submit" name="UnlockForumReferrals" value="Unlock Forum Referrals" onClick="return confirmUnlockOnOtherUser()"/>
													</td>
													<td colspan="2" rowspan="2">
														<input type="submit" name="UnlockArticleReferrals" value="Unlock Entry Referrals" onClick="return confirmUnlockOnOtherUser()"/>
													</td>
												</tr>
											</table>
											<br/>
										</xsl:if>
										<div align="center">
											<table border="1" cellPadding="0" cellSpacing="0">
												<tr align="center" vAlign="top">
													<td colspan="2">
														<b>
															<span class="moderationheader">Images</span>
														</b>
													</td>
												</tr>
												<tr align="center" vAlign="top">
													<td width="50%">
														<xsl:if test="$ownerisviewer = 0"> New </xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<a href="{$root}ModerateImages?Next=Process&amp;Show=new&amp;Referrals=1">New</a>
														</xsl:if>
													</td>
													<td width="50%">
														<xsl:if test="$ownerisviewer = 0"> Referrals </xsl:if>
														<xsl:if test="$ownerisviewer = 1">
															<a href="{$root}ModerateImages?Next=Process&amp;Show=complaints&amp;Referrals=1">Complaints</a>
														</xsl:if>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/NEW/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/NEW/LOCKED"/>
													</td>
													<td>
														<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/COMPLAINTS/LOCKED) > 0">
															<xsl:attribute name="bgColor">red</xsl:attribute>
														</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/COMPLAINTS/LOCKED"/>
													</td>
												</tr>
												<tr align="left" vAlign="top">
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/NEW/QUEUED"/>
													</td>
													<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/IMAGES/COMPLAINTS/QUEUED"/>
													</td>
												</tr>
												<tr align="center" vAlign="top">
													<td colspan="2">
														<input type="submit" name="UnlockImagesReferrals" value="Unlock Images" onClick="return confirmUnlockOnOtherUser()"/>
													</td>
												</tr>
											</table>
										</div>
										<br/>
										<xsl:if test="$test_IsModerator or $test_IsEditor">
											<div align="center">
												<table border="1" cellPadding="0" cellSpacing="0" width="50%">
													<tr align="center" vAlign="top">
														<td colspan="2">
															<b>
																<span class="moderationheader">General Complaints</span>
															</b>
														</td>
													</tr>
													<tr align="center" vAlign="top">
														<td width="50%">
															<xsl:if test="$ownerisviewer = 0"> New </xsl:if>
															<xsl:if test="$ownerisviewer = 1">
																<a href="{$root}ModerationTopFrame?Next=Process&amp;Referrals=0">New</a>
															</xsl:if>
														</td>
														<td width="50%">
															<xsl:if test="$ownerisviewer = 0"> Referrals </xsl:if>
															<xsl:if test="$ownerisviewer = 1">
																<a href="{$root}ModerationTopFrame?Next=Process&amp;Referrals=1">Referrals</a>
															</xsl:if>
														</td>
													</tr>
													<tr align="left" vAlign="top">
														<td>
															<xsl:if test="number(MODERATOR-HOME/MODERATION[@FASTMOD=0]/GENERAL/COMPLAINTS/LOCKED) > 0">
																<xsl:attribute name="bgColor">red</xsl:attribute>
															</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/GENERAL/COMPLAINTS/LOCKED"/>
														</td>
														<td>
															<xsl:if test="number(MODERATOR-HOME/REFERRALS[@FASTMOD=0]/GENERAL/COMPLAINTS/LOCKED) > 0">
																<xsl:attribute name="bgColor">red</xsl:attribute>
															</xsl:if> Locked: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/GENERAL/COMPLAINTS/LOCKED"/>
														</td>
													</tr>
													<tr align="left" vAlign="top">
														<td>Queued: <xsl:value-of select="MODERATOR-HOME/MODERATION[@FASTMOD=0]/GENERAL/COMPLAINTS/QUEUED"/>
														</td>
														<td>Queued: <xsl:value-of select="MODERATOR-HOME/REFERRALS[@FASTMOD=0]/GENERAL/COMPLAINTS/QUEUED"/>
														</td>
													</tr>
													<tr align="center" vAlign="top">
														<td>
															<input type="submit" name="UnlockGeneral" value="Unlock General" onClick="return confirmUnlockOnOtherUser()"/>
														</td>
														<td>
															<input type="submit" name="UnlockGeneralReferrals" value="Unlock General Referrals" onClick="return confirmUnlockOnOtherUser()"/>
														</td>
													</tr>
												</table>
											</div>
										</xsl:if>
									</xsl:if>
									<br/>
									<div align="center">
										<input type="submit" name="UnlockAll" value="Unlock Everything" onClick="return confirmUnlockOnOtherUser()"/>
									</div>
									<br/>
									<table border="1" cellPadding="0" cellSpacing="0" width="100%">
										<tr>
											<td width="25%" align="center">
												<b>
													<xsl:value-of select="$m_modsitename"/>
												</b>
											</td>
											<td width="25%" align="center">
												<b>
													<xsl:value-of select="$m_modnumberqueued"/>
												</b>
											</td>
											<td width="25%" align="center">
												<b>
													<xsl:value-of select="$m_modnumbercomplaints"/>
												</b>
											</td>
											<td width="25%" align="center">
												<b>
													<xsl:value-of select="$m_modcurrentlyvisible"/>
												</b>
											</td>
										</tr>
										<xsl:for-each select="MODERATOR-HOME/QUEUED-PER-SITE/SITE">
											<tr>
												<td>
													<xsl:if test="number(ISMODERATOR) = 0">
														<a href="{$rootbase}{URL}/Login">
															<xsl:value-of select="NAME"/>
														</a>
													</xsl:if>
													<xsl:if test="number(ISMODERATOR) = 1">
														<xsl:value-of select="NAME"/>
													</xsl:if>
												</td>
												<xsl:if test="ISMODERATOR = 1">
													<xsl:if test="ISREFEREE = 1">
														<td>
															<xsl:value-of select="NOT-COMPLAINTS"/>(<xsl:value-of select="NOT-COMPLAINTS-REF"/>)</td>
														<td>
															<xsl:value-of select="COMPLAINTS"/>(<xsl:value-of select="COMPLAINTS-REF"/>)</td>
													</xsl:if>
													<xsl:if test="not(ISREFEREE = 1)">
														<td>
															<xsl:value-of select="number(NOT-COMPLAINTS)"/>
														</td>
														<td>
															<xsl:value-of select="number(COMPLAINTS)"/>
														</td>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(ISMODERATOR = 1)">
													<td>
														<xsl:value-of select="NOT-COMPLAINTS"/>(<xsl:value-of select="NOT-COMPLAINTS-REF"/>)</td>
													<td>
														<xsl:value-of select="COMPLAINTS"/>(<xsl:value-of select="COMPLAINTS-REF"/>)</td>
												</xsl:if>
												<td>
													<xsl:if test="number(ISMODERATOR) = 1">
														<xsl:value-of select="$m_modcurrentlyvisibleyes"/>
													</xsl:if>
													<xsl:if test="number(ISMODERATOR) = 0">
														<xsl:value-of select="$m_modcurrentlyvisibleno"/>
													</xsl:if>
												</td>
											</tr>
										</xsl:for-each>
									</table>
									<xsl:value-of select="$m_ModPerSiteTableNote"/>
								</xsl:if>
							</form>
						</div>
					</body>
				</html>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<xsl:template match="DATE" mode="mod_home">
		<xsl:choose>
			<xsl:when test="@SORT = /H2G2/DATE/@SORT">
				<xsl:text>from </xsl:text>
				<xsl:value-of select="@HOURS"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="@MINUTES"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="todays-date">
					<xsl:call-template name="calculate-julian-day">
						<xsl:with-param name="year" select="/H2G2/DATE/@YEAR"/>
						<xsl:with-param name="month" select="/H2G2/DATE/@MONTH"/>
						<xsl:with-param name="day" select="/H2G2/DATE/@DAY"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="submitted-date">
					<xsl:call-template name="calculate-julian-day">
						<xsl:with-param name="year" select="@YEAR"/>
						<xsl:with-param name="month" select="@MONTH"/>
						<xsl:with-param name="day" select="@DAY"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$todays-date - $submitted-date"/>
				<xsl:text> days ago</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
	<!--===========================================================================-->
</xsl:stylesheet>
