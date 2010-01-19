<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="MESSAGEBOARDADMIN_JAVASCRIPT">
		<script type="text/javascript">

		</script>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDADMIN_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MESSAGEBOARDADMIN_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Message boards Admin
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDADMIN_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MESSAGEBOARDADMIN_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Message boards Admin
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	MESSAGEBOARDADMIN_MAINBODY
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The bulk of the complexity in this page is contained within the tests outlines below. These check the state of various pieces 
	of information around the boards and are used to mark a particular task as complete or incomplete.
	
	All the tests are used together to see whether the button for launching the board is revealed to the user.
	*******************************************************************************************
	*******************************************************************************************
	-->	
	<!--
	TEST: Have location been provided for both development and live versions of the site?
	-->
	<xsl:variable name="location_test">
		<xsl:choose>
			<xsl:when test="not(string-length(/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=12]/SITECONFIG/PATHDEV) = 0) and not(string-length(/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=12]/SITECONFIG/PATHLIVE) = 0)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Have assets for the banner been defined?
	-->
	<xsl:variable name="asset_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=12]/SITECONFIG/IMAGEBANNER/node() or /H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=12]/SITECONFIG/CODEBANNER/node()">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has a homepage template been selected?
	-->
	<xsl:variable name="homepagetemplate_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=1]/LAYOUT and (/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=2]/TEMPLATE or /H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=1]/LAYOUT = 4)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has a topic template been selected?
	-->
	<xsl:variable name="topictemplate_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=3]/ELEMTEMPLATE or /H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=1]/LAYOUT = 4">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has at least one topic been created?
	-->
	<xsl:variable name="topic_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=4]/TOPICLIST/TOPIC and not(string-length(/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=4]/TOPICLIST/TOPIC/TITLE) = 0) and not(string-length(/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=4]/TOPICLIST/TOPIC/DESCRIPTION) = 0) and not(/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=4]/TOPICLIST/TOPIC/FP_ELEMENTID = 0)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Are there any topics without a promo for the frontpage?
	-->
	<xsl:variable name="homepage_test">
		<xsl:choose>
			<xsl:when test="not(/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=4]/TOPICLIST/TOPIC/FP_ELEMENTID = 0)">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has the board promo area been visited?
	-->
	<xsl:variable name="boardpromos_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=6]/STATUS = 1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has the explanatory text area been visited?
	-->
	<xsl:variable name="extext_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=8]/STATUS = 1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has some kind of left hand navigation been provided?
	-->
	<xsl:variable name="nav_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=12]/SITECONFIG/NAVCRUMB/node() or /H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=12]/SITECONFIG/NAVLHN/node()">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Has the features area been visited?
	-->
	<xsl:variable name="features_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=11]/STATUS = 1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	TEST: Have the opening times been provided?
	-->
	<xsl:variable name="times_test">
		<xsl:choose>
			<xsl:when test="/H2G2/ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=7]/FORUMSCHEDULES/SCHEDULE/*">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The main template here is just a list of links.
	
	Although the destinations remain the same, which links are there and their posistion in the list are changed depending on 
	whether	you are looking at the system on the development server (meaning you are building a board) or on the live server 
	(meaning you are administering the board). This check is done based on the value of /H2G2/SERVERNAME
	*******************************************************************************************
	*******************************************************************************************
	-->	
	<xsl:template name="MESSAGEBOARDADMIN_MAINBODY">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'BBCDEV') or (/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='dev')">
				<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
					<div id="subNavText">
						<h1>Message boards Administration</h1>
					</div>
				</div>
				<div id="instructional">
					<p>This message board has not been launched yet. The following tasks need to be carried out before you can launch the site.</p>
					<br/>
					<p>The ticks mean you have completed the minimum requirements for a functional message board, but they will probably need a thorough sanity check as well.</p>
				</div>
				<div id="vanilla-instructional">
					<p><strong>Note: </strong>Items marked with an asterisk (*) are used in the new Vanilla skins. Additionally, <a href="{$root}FrontPageLayout?s_skin=vanilla&amp;s_fromadmin={/H2G2/PARAMS/PARAM[NAME='s_fromadmin']/VALUE}&amp;s_host={/H2G2/PARAMS/PARAM[NAME='s_host']/VALUE}">these new settings must also be configured</a>.</p>
				</div>
				<div id="contentArea">
					<div class="centralAreaRight">
						<div class="header">
							<img src="{$adminimagesource}t_l.gif" alt=""/>
						</div>
						<div class="centralArea">
							<table class="adminMenu" summary="Tasks to do before the message board launches" style="width:720px;" border="0">
								<thead>
									<tr>
										<th scope="col">TASK</th>
										<th scope="col" class="adminMenuTime" style="text-align:center;">TIME REQUIRED</th>
										<th scope="col" style="text-align:center;">MINIMUM CRITERIA MET?</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td scope="row">
											<xsl:call-template name="path_link">
												<xsl:with-param name="return">messageboardadmin</xsl:with-param>
												<xsl:with-param name="link">Define Asset Locations *</xsl:with-param>
												<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
											</xsl:call-template>
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_5min.gif" alt="5 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$location_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminMenuBottom">
										<td scope="row">
											<a href="{$root}previewsiteconfig?_previewmode=1&amp;s_view=assets&amp;s_finishreturnto=messageboardadmin%3Fupdatetype=12" style="color:#333333;text-decoration:underline;">Manage Assets</a> *
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_15min.gif" alt="15 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$asset_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminSecondHeader">
										<td>Template setup</td>
										<td class="adminMenuTime">&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td scope="row">
											<a href="{$root}messageboardadmin?cmd=ViewChooseFrontPageTemplate" style="color:#333333;text-decoration:underline;">Choose Homepage Template</a>
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_5min.gif" alt="5 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$homepagetemplate_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminMenuBottom">
										<td scope="row">
											<a href="{$root}messageboardadmin?cmd=ViewChooseTopicFrontPageElement" style="color:#333333;text-decoration:underline;">Choose Topic Promo Template</a> *
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_5min.gif" alt="5 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$topictemplate_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminSecondHeader">
										<td>Content Management</td>
										<td class="adminMenuTime">&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td scope="row">
											<a href="{$root}messageboardadmin?cmd=ViewCreateTopics" style="color:#333333;text-decoration:underline;">Create Topics</a> *
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_20min.gif" alt="20 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$topic_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<td scope="row">
											<a href="{$root}messageboardadmin?cmd=ViewCreateHomepageContent" style="color:#333333;text-decoration:underline;">Create Homepage Content</a>
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_45min.gif" alt="45 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$homepage_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<td scope="row">
											<a href="{$root}messageboardadmin?cmd=ViewCreateBoardPromos" style="color:#333333;text-decoration:underline;">Create Board Promos</a> *
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_15min.gif" alt="15 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$boardpromos_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<td scope="row">
											<xsl:call-template name="extext_link">
												<xsl:with-param name="return">messageboardadmin</xsl:with-param>
												<xsl:with-param name="link">Edit Instructional Text</xsl:with-param>
												<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
											</xsl:call-template>
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_5min.gif" alt="5 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$extext_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminMenuBottom">
										<td scope="row">
											<xsl:call-template name="nav_link">
												<xsl:with-param name="return">messageboardadmin</xsl:with-param>
												<xsl:with-param name="link">Configure Site Navigation</xsl:with-param>
												<xsl:with-param name="submitClass">dataFakeLink</xsl:with-param>
											</xsl:call-template>
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_15min.gif" alt="15 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$nav_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminSecondHeader">
										<td>Feature Manager</td>
										<td class="adminMenuTime">&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr class="adminMenuBottom">
										<td scope="row">
											<a href="{$root}previewsiteconfig?_previewmode=1&amp;s_view=features&amp;s_finishreturnto=messageboardadmin%3Fupdatetype=11" style="color:#333333;text-decoration:underline;">Configure Board Features</a> *
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_15min.gif" alt="15 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$features_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminSecondHeader">
										<td>Opening Times</td>
										<td class="adminMenuTime">&nbsp;</td>
										<td class="adminMenuDone">&nbsp;</td>
									</tr>
									<tr class="adminMenuBottom">
										<td scope="row">
											<a href="{$root}messageboardadmin?cmd=ViewSetMessageBoardSchedule" style="color:#333333;text-decoration:underline;">Set Opening Times</a> *
										</td>
										<td class="adminMenuTime">
											<img src="{$adminimagesource}adminmenu_15min.gif" alt="15 minutes"/>
										</td>
										<td class="adminMenuDone">
											<xsl:choose>
												<xsl:when test="$times_test = 1">
													<img src="{$adminimagesource}adminmenu_yes.gif" alt="Yes"/>
												</xsl:when>
												<xsl:otherwise>
													<img src="{$adminimagesource}adminmenu_no.gif" alt="No"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="footer">
							<div class="shadedDivider">
								<hr/>
							</div>
							<xsl:if test="$location_test=1 and $asset_test=1 and $homepagetemplate_test=1 and $topictemplate_test=1 and $topic_test=1 and $homepage_test=1 and $boardpromos_test=1 and $extext_test=1 and $nav_test=1 and $features_test=1 and $times_test=1">
								<div style="padding:10px;margin-left:275px;">
									<form method="post" action="{$root}messageboardadmin?cmd=ActivateBoard">
										<input type="hidden" name="cmd" value="ActivateBoard"/>
										<input type="submit" name="Launch" value="Launch Message board" class="buttonThreeD" style="width:180px;"/>
									</form>
								</div>
							</xsl:if>
							<div style="padding:10px;margin-left:275px;">
								<form>
									<!--<div class="buttonThreeD" style="width:180px;text-align:center;">
										<a href="{$root}?_previewmode=1" target="_blank">Launch full preview</a>
									</div>-->
									<br/>
									<br/>
									<input type="button" name="Save and Close" value="Save and Close" class="buttonThreeD" onclick="window.close();" style="width:180px;"/>
								</form>
							</div>
							<img src="{$adminimagesource}b_l.gif" alt=""/>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
					<div id="subNavText">
						<h1> board Administration</h1>
					</div>
				</div>
				<div id="instructional">
					<p>This message board is live</p>
				</div>
				<div id="contentArea">
					<div class="centralAreaRight">
						<div class="header">
							<img src="{$adminimagesource}t_l.gif" alt=""/>
						</div>
						<div class="centralArea">
							<div style="text-align:right;">
								<xsl:apply-templates select="ADMINSTATE/READYTOLAUNCH-INDICATORS/TASK[@TYPE=7]/FORUMSCHEDULES/SCHEDULE" mode="setactivelink"/>
							</div>
							<br/>
							<table class="adminMenu" summary="Message boards administration tasks" style="width:720px;" border="0">
								<thead>
									<tr>
										<th scope="col">TASK</th>
										<th scope="col" class="adminMenuTime" style="text-align:center;">STATUS</th>
									</tr>
								</thead>
								<tbody>
									<tr class="adminSecondHeader">
										<td>Content Management</td>
										<td class="adminMenuStatus">&nbsp;</td>
									</tr>
									<tr>
										<td>
											<a href="{$root}messageboardadmin?cmd=ViewCreateTopics" style="color:#333333;text-decoration:underline;">Topic Management</a>
										</td>
										<td class="adminMenuStatus">
											<xsl:choose>
												<xsl:when test="ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=4]/STATUS = 1">Modified</xsl:when>
												<xsl:otherwise>Unmodified</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<td>
											<a href="{$root}messageboardadmin?cmd=ViewCreateHomepageContent" style="color:#333333;text-decoration:underline;">Edit Homepage Content</a>
										</td>
										<td class="adminMenuStatus">
											<xsl:choose>
												<xsl:when test="ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=5]/STATUS = 1">Modified</xsl:when>
												<xsl:otherwise>Unmodified</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr>
										<td>
											<a href="{$root}messageboardadmin?cmd=ViewCreateBoardPromos" style="color:#333333;text-decoration:underline;">Edit Board Promos</a>
										</td>
										<td class="adminMenuStatus">
											<xsl:choose>
												<xsl:when test="ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=6]/STATUS = 1">Modified</xsl:when>
												<xsl:otherwise>Unmodified</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminMenuBottom">
										<td>
											<a href="{$root}previewsiteconfig?_previewmode=1&amp;s_view=assets&amp;s_finishreturnto=messageboardadmin?updatetype=12" style="color:#333333;text-decoration:underline;">Assets</a>
										</td>
										<td class="adminMenuStatus">
											<xsl:choose>
												<xsl:when test="ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=12]/STATUS = 1">Modified</xsl:when>
												<xsl:otherwise>Unmodified</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr class="adminSecondHeader">
										<td>Opening Times</td>
										<td class="adminMenuStatus">&nbsp;</td>
									</tr>
									<tr class="adminMenuBottom">
										<td>
											<a href="{$root}messageboardadmin?cmd=ViewSetMessageBoardSchedule" style="color:#333333;" class="adminMenuLink">Set Opening Times</a>
										</td>
										<td class="adminMenuStatus">
											<xsl:choose>
												<xsl:when test="ADMINSTATE/STATUS-INDICATORS/TASK[@TYPE=7]/STATUS = 1">Modified</xsl:when>
												<xsl:otherwise>Unmodified</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="footer">
							<div class="shadedDivider">
								<hr/>
							</div>
							<div class="buttonThreeD" style="width:180px;text-align:center;margin-left:280px;">
								<a href="{$root}?_previewmode=1" target="_blank">Launch full preview</a>
							</div>
							<br/>
							<br/>
							<div class="buttonThreeD" style="width:180px;text-align:center;margin-left:280px;">
								<a href="/dna/{/H2G2/SITECONFIG/BOARDROOT}boards/?_previewmode=1" target="_blank">Launch Vanilla skin preview</a>
							</div>
							<br/>
							<br/>
							<form method="post" ACTION="{$root}messageboardadmin?cmd=ActivateBoard">
								<input type="hidden" name="cmd" value="ActivateBoard"/>
								<input type="submit" name="Submit changes..." value="Submit changes..." class="buttonThreeD" style="margin-left:280px;"/>
							</form>
							<br/>
							<br/>
							<img src="{$adminimagesource}b_l.gif" alt=""/>
						</div>
					</div>
				</div>
				<div id="instructional">
					<p>
						<a href="{$root}messageboardadmin?s_view=dev">Redesign board... </a>
					</p>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
