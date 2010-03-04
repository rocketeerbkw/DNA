<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<!-- LPorter: This include is for Vanilla skins -->
	<xsl:include href="../../vanilla/boards-admin-new/pages/frontpage-layout.xsl"/>
	
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The templates included in this xsl file are the central chunk of code which controls the templated front pages.
	
	Included here are the templates which display the frontpage to the user, the templates which allow the editor to select 
	how that frontpage appears, the templates which control the display of the topic promos and the main template which 
	creates the central admin page for the frontpage. 
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The following javascript is used in the system to launch the popups which allow the editors to see previews of the 
	different layouts when they are selecting the layout they want.
	
	The remainder of the javascript controls the alert boxes which are used to prompt the editor as they make their selections. 
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template name="FRONTPAGE-LAYOUT_JAVASCRIPT">
		<script type="text/javascript">		
		function openTwoColumnPreview() {
			if (document.templateSelection.tmpltype[0].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/1_1_layout.jpg', 830, 900);
			}
			else if (document.templateSelection.tmpltype[1].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/1_2_layout.jpg', 830, 900);	
			}
			else {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/1_3_layout.jpg', 830, 900);
			}			
		}
		
		function openThreeColumnPreview() {
			if (document.templateSelection.tmpltype[0].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/2_1_layout.jpg', 830, 900);
			}
			else if (document.templateSelection.tmpltype[1].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/2_2_layout.jpg', 830, 900);	
			}
			else if (document.templateSelection.tmpltype[2].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/2_3_layout.jpg', 830, 900);	
			}
			else {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/2_4_layout.jpg', 830, 900);
			}			
		}
		
		function openFourColumnPreview() {
			if (document.templateSelection.tmpltype[0].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/3_1_layout.jpg', 830, 900);
			}
			else {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/3_2_layout.jpg', 830, 900);	
			}		
		}
		
		function openTopicPreview() {
			var layout = <xsl:value-of select="/H2G2/FRONTPAGELAYOUTCOMPONENTS/ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT"/>;
			var template = <xsl:value-of select="/H2G2/FRONTPAGELAYOUTCOMPONENTS/ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE"/>;
			if (document.topicSelection.elemtmpltype[0].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/' + layout + '_' + template + '_' + '1_promo.jpg', 830, 900);
			}
			else if (document.topicSelection.elemtmpltype[1].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/' + layout + '_' + template + '_' + '2_promo.jpg', 830, 900);	
			}
			else if (document.topicSelection.elemtmpltype[2].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/' + layout + '_' + template + '_' + '3_promo.jpg', 830, 900);	
			}
			else if (document.topicSelection.elemtmpltype[3].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/' + layout + '_' + template + '_' + '4_promo.jpg', 830, 900);	
			}
			else if (document.topicSelection.elemtmpltype[4].checked == true) {
				openPreview('<xsl:value-of select="$adminimagesource"/>examples/' + layout + '_' + template + '_' + '5_promo.jpg', 830, 900);
			}			
		}
		
		function alertGuideML() {			
			if (document.layoutSelection.layouttype[3].checked == true) {
				var answer = confirm("If you choose to 'Code your own in GuideML', you will be able to go back to creating the homepage with templates, but you will lose any content you created.")
				if (answer == true) {
					return true;
				}
				else {
					return false;
				}
			}
			else {
				return true;
			}
		}
		
		function changeTemplate() {
			var answer = confirm("You have created content in your current template selection.\n \n If you change the template you may have to edit this content to fit the new style.");
			if (answer == true) {
				if (document.layoutSelection.layouttype[3].checked == true) {
					answer = confirm("You will not be able to use the content you have already created if you code your own homepage in GuideML.");
					if (	answer == true) {
						return true;
					}
					else {
						return false;
					}
				}
				else {
					return true;
				}
			}
			else {
				return false;
			}
		}
		
		function changeTopic() {
			var currentTopic = <xsl:value-of select="/H2G2/FRONTPAGELAYOUTCOMPONENTS/ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE"/>-1;
			if (document.topicSelection.elemtmpltype[currentTopic].checked == true) {
				return true;
			}
			else {
				var answer = confirm("You have created content in your current template selection.\n \nChanging the template may mean you have to edit this content to fit the new style.");
				if (	answer == true) {
					if (document.topicSelection.elemtmpltype[5].checked == true) {
						answer = confirm("You will not be able to use the content you have already created if you code your own topic  promos in GuideML.");
						if (answer == true) {
							return true;
						}
						else {
							return false;
						}
					}
					else {						
						answer = confirm("Some of the content you created may not fit this template.\n \nYou can check this using the preview function.");
						if (answer == true) {
							return true;
						}
						else {
							return false;
						}
					}
				}
				else {
					return false;
				}
			}
		}
		</script>
	</xsl:template>
	<!--
	<xsl:template name="FRONTPAGE-LAYOUT_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="FRONTPAGE-LAYOUT_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Frontpage Layout
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="FRONTPAGE-LAYOUT_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="FRONTPAGE-LAYOUT_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Frontpage Layout
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	FRONTPAGE-LAYOUT_MAINBODY
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template name="FRONTPAGE-LAYOUT_MAINBODY">
	Author:		Andy Harris
	Context:    H2G2
	Purpose:	 Main template call for the frontpagelayout pages
	-->
	<xsl:template name="FRONTPAGE-LAYOUT_MAINBODY">
		<xsl:choose>
			<xsl:when test="FRONTPAGELAYOUTCOMPONENTS/ARTICLE/ARTICLEINFO/EDIT-KEY/CLASH">
				<p>
					Another person has edited your Frontpage set up. Please refresh your page and try again.
					<br/>
					<a href="{root}/FrontPageLayout">FrontPage</a>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="FRONTPAGELAYOUTCOMPONENTS" mode="create_frontpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="create_frontpage">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE
	Purpose:	 Template which chooses which stage of the process you are in
	-->
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="create_frontpage">
	  <xsl:choose>
  	  <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_skin'] and /H2G2/PARAMS/PARAM[NAME = 's_skin']/VALUE = 'vanilla'">
  	    <xsl:apply-templates select="/H2G2" mode="page"/>
  	  </xsl:when>
  	  <xsl:otherwise>
          <xsl:choose>
          <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_updatelayout']/VALUE='yes'">
            <div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
              <div id="subNavText">
                <h1>Content Management - Choose Homepage Layout</h1>
              </div>
            </div>
            <div id="vanilla-instructional">
              <p><strong>Important: </strong> These templates are not used in Vanilla skins. Please design your page layout using CSS.</p>
            </div>
            <br/>
            <div id="contentArea">
              <div class="centralAreaRight">
                <div class="header">
                  <img src="{$adminimagesource}t_l.gif" alt=""/>
                </div>
                <div class="centralArea">
                  <xsl:apply-templates select="." mode="choose_layout"/>
                </div>
                <div class="footer">
                  <img src="{$adminimagesource}b_l.gif" alt=""/>
                </div>
              </div>
            </div>
          </xsl:when>
          <xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/UPDATE[@STEP = 1]">
            <div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
              <div id="subNavText">
                <h1>Content Management - Choose Homepage Template</h1>
              </div>
            </div>
            <br/>
            <div id="contentArea">
              <div class="centralAreaRight">
                <div class="header">
                  <img src="{$adminimagesource}t_l.gif" alt=""/>
                </div>
                <div class="centralArea">
                  <xsl:apply-templates select="." mode="choose_template"/>
                </div>
                <div class="footer">
                  <img src="{$adminimagesource}b_l.gif" alt=""/>
                </div>
              </div>
            </div>
          </xsl:when>
          <xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/UPDATE[@STEP = 2] or /H2G2/PARAMS/PARAM[NAME='s_updatetopictemplate']/VALUE='yes'">
            <div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
              <div id="subNavText">
                <h1>Content Management - Choose Promo Layout</h1>
              </div>
            </div>
            <div id="vanilla-instructional">
              <p><strong>Important: </strong> These templates are not used in Vanilla skins. Please design your promo layout using CSS.</p>
            </div>
            <br/>
            <div id="contentArea">
              <div class="centralAreaRight">
                <div class="header">
                  <img src="{$adminimagesource}t_l.gif" alt=""/>
                </div>
                <div class="centralArea">
                  <xsl:apply-templates select="." mode="choose_promo"/>
                </div>
                <div class="footer">
                  <img src="{$adminimagesource}b_l.gif" alt=""/>
                </div>
              </div>
            </div>
          </xsl:when>
          <xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/UPDATE[@STEP = 3] and ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6">
            <div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
              <div id="subNavText">
                <h1>Content Management - GuideML Template for Topics</h1>
              </div>
            </div>
            <br/>
            <div id="contentArea">
              <div class="centralAreaRight">
                <div class="header">
                  <img src="{$adminimagesource}t_l.gif" alt=""/>
                </div>
                <div class="centralArea">
                  <xsl:apply-templates select="." mode="topic_guideml"/>
                </div>
                <div class="footer">
                  <img src="{$adminimagesource}b_l.gif" alt=""/>
                </div>
              </div>
            </div>
          </xsl:when>
          <xsl:when test="ARTICLE">
            <xsl:apply-templates select="ARTICLE" mode="homepage_sectionselect"/>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <a href="{$root}FrontPageLayout?s_updatelayout=yes">Choose</a> the page layout
            </p>
          </xsl:otherwise>
        </xsl:choose>
  	  </xsl:otherwise>
	  </xsl:choose>
		
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="homepage_sectionselect">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE
	Purpose:	 Display for the main section of the frontpagelayout page, provides links to all the areas which you can change
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	This template creates the main frontpage admin page. It replicates the look and feel of the board home page but with the 
	addition of links allowing the editor to change any settings they are not happy with. 
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template match="ARTICLE" mode="homepage_sectionselect">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Content Management - Homepage Configuration</h1>
			</div>
		</div>
		<br/>
		<div id="vanilla-instructional">
  		<p><strong>Important: </strong> If your messageboard uses Vanilla skins, please <a href="{$root}FrontPageLayout?s_skin=vanilla&amp;s_fromadmin={/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE}&amp;s_host={/H2G2/PARAMS/PARAM[NAME = 's_host']/VALUE}">click here</a> for layout options.</p>
		</div>
		<div id="contentArea" style="width:940px;">
			<div class="centralAreaRight" style="width:940px;">
				<div class="header" style="width:940px;">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td id="frontpage">
								<table cellpadding="0" cellspacing="0">
									<tr>
										<td valign="top">
											<table id="datearea" class="area" cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<xsl:call-template name="datearea_template"/>
														<div class="small">
															<xsl:call-template name="barley_link">
																<xsl:with-param name="return">
																	<xsl:value-of select="root"/>frontpagelayout</xsl:with-param>
																<xsl:with-param name="link">Manage top left nav...</xsl:with-param>
																<xsl:with-param name="submitClass">buttonThreeD</xsl:with-param>
															</xsl:call-template>
														</div>
													</td>
												</tr>
											</table>
										</td>
										<td valign="top">
											<table id="bannerarea" class="area" cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<xsl:choose>
															<xsl:when test="../SITECONFIG/CODEBANNER/node()">
																<xsl:apply-templates select="../SITECONFIG/CODEBANNER/*"/>
															</xsl:when>
															<xsl:otherwise>
																<img src="{$boardpath}images/{../SITECONFIG/IMAGEBANNER/node()}" width="645" height="50" alt="{../SITECONFIG/BOARDNAME/node()} Board"/>
															</xsl:otherwise>
														</xsl:choose>
														<div class="small" align="right" style="padding-right:10px;">
															<xsl:choose>
																<xsl:when test="../SITECONFIG/CODEBANNER/node()">
																	<xsl:call-template name="code_link">
																		<xsl:with-param name="return">
																			<xsl:value-of select="root"/>frontpagelayout</xsl:with-param>
																		<xsl:with-param name="link">Manage banner code...</xsl:with-param>
																		<xsl:with-param name="submitClass">buttonThreeD</xsl:with-param>
																	</xsl:call-template>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:call-template name="image_link">
																		<xsl:with-param name="return">
																			<xsl:value-of select="root"/>frontpagelayout</xsl:with-param>
																		<xsl:with-param name="link">Manage banner asset...</xsl:with-param>
																		<xsl:with-param name="submitClass">buttonThreeD</xsl:with-param>
																	</xsl:call-template>
																</xsl:otherwise>
															</xsl:choose>
														</div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td valign="top">
											<table id="localarea" class="area" cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<font face="arial, helvetica,sans-serif" size="2">
															<xsl:if test="not(../SITECONFIG/BARLEYVARIANT = 'radio' or ../SITECONFIG/BARLEYVARIANT = 'music')">
																<a class="bbcpageCrumb" href="/">BBC Homepage</a>
																<br/>
															</xsl:if>
															<xsl:if test="../SITECONFIG/NAVCRUMB/node()">
																<xsl:copy-of select="../SITECONFIG/NAVCRUMB/node()"/>
															</xsl:if>
														</font>
														<xsl:if test="../SITECONFIG/NAVLHN/node()">
															<xsl:copy-of select="../SITECONFIG/NAVLHN/node()"/>
														</xsl:if>
														<div class="small" align="right">
															<xsl:call-template name="nav_link">
																<xsl:with-param name="return">
																	<xsl:value-of select="root"/>frontpagelayout</xsl:with-param>
																<xsl:with-param name="link">Manage site navigation...</xsl:with-param>
																<xsl:with-param name="submitClass">buttonThreeD</xsl:with-param>
															</xsl:call-template>
														</div>
														<xsl:apply-templates select="../TOPICLIST" mode="lhnavigation"/>
														<br/>
														<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
															<a href="{$root}topicbuilder?s_finishreturnto=frontpagelayout">Manage topics...</a>
														</div>
													</td>
												</tr>
											</table>
										</td>
										<td rowspan="2" valign="top">
											<table id="mainarea" cellpadding="0" cellspacing="0">
												<tr>
													<td id="ssoarea" class="area">
														<xsl:call-template name="sso_statusbar"/>
														<div class="small" align="right">
															<xsl:call-template name="path_link">
																<xsl:with-param name="return">
																	<xsl:value-of select="root"/>frontpagelayout</xsl:with-param>
																<xsl:with-param name="link">Manage asset locations...</xsl:with-param>
																<xsl:with-param name="submitClass">buttonThreeD</xsl:with-param>
															</xsl:call-template>
														</div>
													</td>
												</tr>
												<tr>
													<td id="userarea" class="area">
														<xsl:if test="/H2G2/VIEWING-USER/USER and /H2G2/SITE/IDENTITYSIGNIN = 0">
															<div class="userbar">
																<p align="right">
																	<a href="{$root}MP{/H2G2/VIEWING-USER/USER/USERID}">Your page</a> | Your nickname is <strong>
																		<xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="username"/>
																	</strong>. 
																	<xsl:if test="not(@TYPE = 'USERDETAILS' or /H2G2/CURRENTSITEURLNAME = 'mbks3bitesize' or /H2G2/CURRENTSITEURLNAME = 'mbgcsebitesize' or /H2G2/CURRENTSITEURLNAME = 'mbcbbc' or /H2G2/CURRENTSITEURLNAME = 'mbnewsround')">
																		<a href="{$root}userdetails">Change this</a>
																	</xsl:if>
																</p>
															</div>
														</xsl:if>
													</td>
												</tr>
												<tr>
													<td id="crumbarea" class="area">
														<xsl:if test="(string-length(../SITECONFIG/LINKPATH) = 0) or (../SITECONFIG/LINKPATH = 1)">
															<div id="crumbtrail">
																<h5>
														You are here &gt; <a href="{$homepage}">
																		<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards</a>
																</h5>
															</div>
														</xsl:if>
														<div class="small" align="right">
															<xsl:call-template name="linkpath_link">
																<xsl:with-param name="return">
																	<xsl:value-of select="root"/>frontpagelayout</xsl:with-param>
																<xsl:with-param name="link">Edit link path...</xsl:with-param>
																<xsl:with-param name="submitClass">buttonThreeD</xsl:with-param>
															</xsl:call-template>
														</div>
													</td>
												</tr>
												<tr>
													<td>
														<xsl:choose>
															<xsl:when test="FRONTPAGE/PAGE-LAYOUT and not(FRONTPAGE/PAGE-LAYOUT/LAYOUT = 4)">
																<xsl:apply-templates select="FRONTPAGE/PAGE-LAYOUT" mode="layout_selection"/>
															</xsl:when>
															<xsl:otherwise>
																<p style="clear:both;">
																	<strong>This homepage was created using GuideML</strong>
																</p>
																<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;clear:both;">
																	<a href="{$root}editfrontpage?s_finishreturnto=frontpagelayout&amp;_previewmode=1">Edit GuideML...</a>
																</div>
																<div style="clear:both;">
																	<xsl:apply-templates select="FRONTPAGE/node()"/>
																</div>
																<p style="clear:both;">
																	<strong>This homepage was created using GuideML</strong>
																</p>
																<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;clear:both;">
																	<a href="{$root}editfrontpage?s_finishreturnto=frontpagelayout&amp;_previewmode=1">Edit GuideML...</a>
																</div>
															</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td valign="top">
											<table id="topicarea" class="area" cellpadding="0" cellspacing="0">
												<tr>
													<td>&nbsp;</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
				<div class="footer" style="width:940px;">
					<div class="shadedDivider" style="width:910px;">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<!--<div class="buttonThreeD">
							<a href="{$root}?_previewmode=1" target="_blank">Launch full preview</a>
						</div>-->
					</span>
					<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="{$root}messageboardadmin">Exit homepage creation &gt; &gt;</a>
						</div>
					</span>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="TOPICLIST" mode="lhnavigation">
	Author:		Andy Harris
	Context:    /H2G2/TOPICLIST or /H2G2/FRONTPAGELAYOUTCOMPONENTS/TOPICLIST
	Purpose:	 Provides the container for the left hand navigation generated from the topic information
	-->
	<xsl:template match="TOPICLIST" mode="lhnavigation">
		<div class="lhn-container">
			<xsl:apply-templates select="TOPIC" mode="lhnavigation"/>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="lhnavigation">
	Author:		Andy Harris
	Context:    /H2G2/TOPICLIST or /H2G2/FRONTPAGELAYOUTCOMPONENTS/TOPICLIST
	Purpose:	 Creates the links to each topic for the left hand navigation area
	-->
	<xsl:template match="TOPIC" mode="lhnavigation">
		<p class="lhn-topic">
			<a href="{$root}F{FORUMID}" id="topic{FORUMID}">
				<xsl:value-of select="TITLE"/>
			</a>
		</p>
	</xsl:template>
	<!--
	<xsl:template name="datearea_template">
	Author:		Andy Harris
	Context:    none
	Purpose:	 Provides content for the date area ofr the main display, including link to change the barley choice
	-->
	<xsl:template name="datearea_template">
		<table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr>
				<xsl:choose>
					<xsl:when test="(../SITECONFIG/BARLEYVARIANT = 'radio') or (../SITECONFIG/BARLEYVARIANT = 'music')">
						<td class="bbcpageToplefttd" width="{$bbcpage_navwidth}" valign="top">
							<table cellspacing="0" cellpadding="0" border="0">
								<tr>
									<td width="8">
										<img src="/f/t.gif" width="8" height="1" alt=""/>
									</td>
									<td width="{number($bbcpage_navwidth)-8}">
										<img src="/f/t.gif" width="{number($bbcpage_navwidth)-8}" height="1" alt=""/>
										<br clear="all"/>
										<font face="arial, helvetica, sans-serif" size="1" class="bbcpageToplefttd">
											<img src="/f/t.gif" width="1" height="6" alt=""/>
											<br clear="all"/>
											<xsl:apply-templates select="/H2G2/DATE" mode="titlebar"/>
											<br/>
											<a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/cgi-bin/education/betsie/parser.pl">Text only</a>
											<br/>
											<a href="/" class="bbcpageTopleftlink" style="text-decoration:underline;">BBC Homepage</a>
											<br/>
											<xsl:choose>
												<xsl:when test="../SITECONFIG/BARLEYVARIANT = 'radio'">
													<a href="/radio/" class="bbcpageTopleftlink" style="text-decoration:underline;">BBC Radio</a>
												</xsl:when>
												<xsl:otherwise>
													<a href="/music/" class="bbcpageTopleftlink" style="text-decoration:underline;">BBC Music</a>
												</xsl:otherwise>
											</xsl:choose>
										</font>
									</td>
								</tr>
							</table>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="bbcpageToplefttd" width="{$bbcpage_navwidth}">
							<table cellspacing="0" cellpadding="0" border="0">
								<tr>
									<td width="8">
										<img src="/f/t.gif" width="8" height="1" alt=""/>
									</td>
									<td width="{number($bbcpage_navwidth)-8}">
										<img src="/f/t.gif" width="{number($bbcpage_navwidth)-8}" height="1" alt=""/>
										<br clear="all"/>
										<font face="arial, helvetica, sans-serif" size="1" class="bbcpageToplefttd">
											<xsl:apply-templates select="/H2G2/DATE" mode="titlebar"/>
											<br/>
											<a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/cgi-bin/education/betsie/parser.pl">Text only</a>
										</font>
									</td>
								</tr>
							</table>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
		</table>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The following templates are used on both the FRONTPAGE and the FRONTPAGE-LAYOUT page to work through the template 
	options and create the correct frontpage.
	
	The first template chooses based on the LAYOUT value.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	<xsl:template match="PAGE-LAYOUT" mode="layout_selection">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT
	Purpose:	 Chooses the correct column layout this can be used by both the frontpagelayout page and also the frontpage itself
	-->
	<xsl:template match="PAGE-LAYOUT" mode="layout_selection">
		<xsl:choose>
			<xsl:when test="LAYOUT = 1">
				<xsl:apply-templates select="." mode="two_column_selection"/>
			</xsl:when>
			<xsl:when test="LAYOUT = 2">
				<xsl:apply-templates select="." mode="three_column_selection"/>
			</xsl:when>
			<xsl:when test="LAYOUT = 3">
				<xsl:apply-templates select="." mode="four_column_selection"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The next three based on the TEMPLATE value.Then TOPICLIST and TEXTBOXLIST values are used to fill in the template. 
	If this is the frontpagelayout page then links are also added into the page to allow textboxes, topics and topicpromos to be 
	edited.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	<xsl:template match="PAGE-LAYOUT" mode="two_column_selection">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT
	Purpose:	 Chooses the correct layout from the two column list
	-->
	<xsl:template match="PAGE-LAYOUT" mode="two_column_selection">
		<xsl:choose>
			<xsl:when test="TEMPLATE = 1">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td width="50%" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="50%" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 2) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 2) and (position() mod 2 = 1)]" mode="topic_twocols"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:when test="TEMPLATE = 2">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td width="50%" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="50%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 1) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 1) and (position() mod 2 = 0)]" mode="topic_twocols"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:when test="TEMPLATE = 3">
				<table cellspacing="5" class="frontpagetemplate" width="!00%">
					<tr>
						<td colspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td width="50%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="50%" class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 2) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 2) and (position() mod 2 = 1)]" mode="topic_twocols"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-LAYOUT" mode="three_column_selection">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT
	Purpose:	 Chooses the correct layout from the three column list
	-->
	<xsl:template match="PAGE-LAYOUT" mode="three_column_selection">
		<xsl:choose>
			<xsl:when test="TEMPLATE = 1">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td width="66%" colspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td width="33%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" rowspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="topicbox" valign="top" id="topic3">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic4">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">4</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 4) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
								<td>&nbsp;
									
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 4) and (position() mod 2 = 1)]" mode="topic_threecols1"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:when test="TEMPLATE = 2">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td width="33%" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td rowspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic3">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic4">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">4</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="topicbox" valign="top" id="topic5">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">5</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic6">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">6</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 6) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td>&nbsp;
									
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 6) and (position() mod 2 = 1)]" mode="topic_threecols2"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:when test="TEMPLATE = 3">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td colspan="3" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td width="33%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="topicbox" valign="top" id="topic3">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 3) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 3) and (position() mod 3 = 1)]" mode="topic_threecols3"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:when test="TEMPLATE = 4">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td width="33%" rowspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td colspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td width="33%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="33%" class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic3">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic4">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">4</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 4) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td>&nbsp;
									
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 4) and (position() mod 2 = 1)]" mode="topic_threecols2"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-LAYOUT" mode="four_column_selection">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT
	Purpose:	 Chooses the correct layout from the four column list
	-->
	<xsl:template match="PAGE-LAYOUT" mode="four_column_selection">
		<xsl:choose>
			<xsl:when test="TEMPLATE = 1">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td width="25%" rowspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="25%" class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="25%" class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="25%" rowspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="topicbox" valign="top" id="topic3">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic4">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">4</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic5">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">5</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic6">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">6</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">4</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 6) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td>&nbsp;
									
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
								<td>&nbsp;
									
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 6) and (position() mod 2 = 1)]" mode="topic_fourcols1"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:when test="TEMPLATE = 2">
				<table cellspacing="5" class="frontpagetemplate" width="100%">
					<tr>
						<td colspan="3" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td rowspan="2" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td class="topicbox" valign="top" id="topic1">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">1</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic2">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">2</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td class="topicbox" valign="top" id="topic3">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<tr>
						<td width="25%" class="topicbox" valign="top" id="topic4">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">4</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="25%" class="topicbox" valign="top" id="topic5">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">5</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="25%" class="topicbox" valign="top" id="topic6">
							<xsl:apply-templates select="../../../TOPICLIST" mode="choose_promo">
								<xsl:with-param name="position">6</xsl:with-param>
							</xsl:apply-templates>
						</td>
						<td width="25%" class="textbox" valign="top">
							<xsl:apply-templates select="../../../TEXTBOXLIST" mode="choose_text">
								<xsl:with-param name="number">3</xsl:with-param>
							</xsl:apply-templates>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="(count(../../../TOPICLIST/TOPIC) = 6) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
							<tr>
								<td class="topicbox" valign="top">
									<br/>
									<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
										<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
									</div>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
								<td class="topicbox" valign="top">
									<br/>
									<br/>
									<br/>
								</td>
								<td>&nbsp;
									
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="../../../TOPICLIST/TOPIC[(position() &gt; 6) and (position() mod 3 = 1)]" mode="topic_fourcols2"/>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	Finally, if there are more TOPICs than spaces on the template then these templates cycle through the remaining TOPICs to
	display each of the live topics. Once again, links are added to edit this information if this is the FRONTPAGE-LAYOUT page.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	<xsl:template match="TOPIC" mode="topic_twocols">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST/TOPIC
	Purpose:	 Displays any 'extra' topic boxes for the two column layouts
	-->
	<xsl:template match="TOPIC" mode="topic_twocols">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) + 2 = count(../TOPIC)">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<tr>
						<td class="topicbox" valign="top">
							<br/>
							<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
								<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
							</div>
						</td>
						<td class="topicbox" valign="top">
							<br/>
							<br/>
							<br/>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:when test="following-sibling::TOPIC">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="topic_threecols1">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST/TOPIC
	Purpose:	 Displays any 'extra' topic boxes for the first of the three column layouts
	-->
	<xsl:template match="TOPIC" mode="topic_threecols1">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) + 2 = count(../TOPIC)">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<tr>
						<td class="topicbox" valign="top">
							<br/>
							<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
								<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
							</div>
						</td>
						<td class="topicbox" valign="top">
							<br/>
							<br/>
							<br/>
						</td>
						<td>&nbsp;
							
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:when test="following-sibling::TOPIC">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="topic_threecols2">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST/TOPIC
	Purpose:	 Displays any 'extra' topic boxes for the second and fourth of the three column layouts
	-->
	<xsl:template match="TOPIC" mode="topic_threecols2">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) + 2 = count(../TOPIC)">
				<tr>
					<td>&nbsp;
						
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<tr>
						<td>&nbsp;
							
						</td>
						<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
							<br/>
							<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
								<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
							</div>
						</td>
						<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
							<br/>
							<br/>
							<br/>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:when test="following-sibling::TOPIC">
				<tr>
					<td>&nbsp;
						
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td>&nbsp;
						
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="topic_threecols3">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST/TOPIC
	Purpose:	 Displays any 'extra' topic boxes for the third of the three column layouts
	-->
	<xsl:template match="TOPIC" mode="topic_threecols3">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) + 3 = count(../TOPIC)">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<xsl:apply-templates select="following-sibling::TOPIC[2]" mode="choose_promo"/>
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<tr>
						<td class="topicbox" valign="top">
							<br/>
							<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
								<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
							</div>
						</td>
						<td class="topicbox" valign="top">
							<br/>
							<br/>
							<br/>
						</td>
						<td class="topicbox" valign="top">
							<br/>
							<br/>
							<br/>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:when test="count(preceding-sibling::TOPIC) + 2 = count(/H2G2/TOPICLIST/TOPIC)">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="following-sibling::TOPIC[3]">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<xsl:apply-templates select="following-sibling::TOPIC[2]" mode="choose_promo"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<br/>
						<br/>
						<br/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="topic_fourcols1">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST/TOPIC
	Purpose:	 Displays any 'extra' topic boxes for the first four column layout
	-->
	<xsl:template match="TOPIC" mode="topic_fourcols1">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) + 2 = count(../TOPIC)">
				<tr>
					<td>&nbsp;
						
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<tr>
						<td>&nbsp;
						
					</td>
						<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
							<br/>
							<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
								<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
							</div>
						</td>
						<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
							<br/>
							<br/>
							<br/>
						</td>
						<td>&nbsp;
						
					</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:when test="following-sibling::TOPIC">
				<tr>
					<td>&nbsp;
						
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td>&nbsp;
						
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="topic_fourcols2">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST/TOPIC
	Purpose:	 Displays any 'extra' topic boxes for the second of the four column layouts
	-->
	<xsl:template match="TOPIC" mode="topic_fourcols2">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) + 3 = count(../TOPIC)">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<xsl:apply-templates select="following-sibling::TOPIC[2]" mode="choose_promo"/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<tr>
						<td class="topicbox" valign="top">
							<br/>
							<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
								<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
							</div>
						</td>
						<td class="topicbox" valign="top">
							<br/>
							<br/>
							<br/>
						</td>
						<td class="topicbox" valign="top">
							<br/>
							<br/>
							<br/>
						</td>
						<td>&nbsp;
						
					</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:when test="count(preceding-sibling::TOPIC) + 2 = count(../TOPIC)">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="following-sibling::TOPIC[3]">
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<xsl:apply-templates select="following-sibling::TOPIC[2]" mode="choose_promo"/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 1}">
						<xsl:apply-templates select="." mode="choose_promo"/>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 2}">
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
								<br/>
								<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
									<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
								</div>
							</xsl:when>
							<xsl:otherwise>&nbsp;</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="topicbox" valign="top" id="topic{count(preceding-sibling::TOPIC) + 3}">
						<br/>
						<br/>
						<br/>
					</td>
					<td>&nbsp;
						
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	These templates choose the correct topic promo layout for the topics that appear on the frontpage. Again, links are 
	added to edit this information if this is the FRONTPAGE-LAYOUT page.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	<xsl:template match="TOPICLIST" mode="choose_promo">
	Author:		Andy Harris
	Context:    H2G2/TOPICLIST
	Purpose:	 Displays any 'ordinary' topic boxes based on the position of the box on the frontpage
	-->
	<xsl:template match="TOPICLIST" mode="choose_promo">
		<xsl:param name="position">1</xsl:param>
		<xsl:choose>
			<xsl:when test="count(TOPIC) &gt;= $position">
				<xsl:apply-templates select="TOPIC[position() = $position]" mode="choose_promo"/>
			</xsl:when>
			<xsl:when test="(count(TOPIC)+1 = $position) and (/H2G2/@TYPE = 'FRONTPAGE-LAYOUT')">
				<br/>
				<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
					<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=frontpagelayout">Add new topic</a>
				</div>
			</xsl:when>
			<xsl:otherwise>
			 	&nbsp;
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="choose_promo">
	Author:		Andy Harris
	Context:    H2G2/TOPIC/TOPIC
	Purpose:	 Chooses the correct promo type and fills it
	-->
	<xsl:template match="TOPIC" mode="choose_promo">
		<xsl:choose>
			<xsl:when test="TOPICID = ../../TOPICELEMENTLIST/TOPICELEMENT/TOPICID">
				<xsl:choose>
					<xsl:when test="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 1">
						<table width="100%">
							<tr>
								<td colspan="2">
									<h4>
										<a href="{$root}F{FORUMID}" class="topicpromotitle">
											<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TITLE"/>
										</a>
									</h4>
								</td>
							</tr>
							<tr>
								<td valign="top">
									<a href="{$root}F{FORUMID}" class="topicpromoimage">
										<xsl:apply-templates select="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
											<xsl:with-param name="imagename">
												<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGENAME"/>
											</xsl:with-param>
											<xsl:with-param name="imagealttext">
												<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGEALTTEXT"/>
											</xsl:with-param>
										</xsl:apply-templates>
									</a>
								</td>
								<td valign="top">
									<p>
										<xsl:apply-templates select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TEXT"/>
									</p>
								</td>
							</tr>
							<tr>
								<td colspan="2" align="right">
									<p>
										<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/FORUMPOSTCOUNT"/> posts</p>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:when test="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 2">
						<h4>
							<a href="{$root}F{FORUMID}" class="topicpromotitle">
								<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TITLE"/>
							</a>
						</h4>
						<p align="right">
							<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/FORUMPOSTCOUNT"/> posts</p>
						<a href="{$root}F{FORUMID}" class="topicpromoimage">
							<xsl:apply-templates select="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
								<xsl:with-param name="imagename">
									<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGENAME"/>
								</xsl:with-param>
								<xsl:with-param name="imagealttext">
									<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGEALTTEXT"/>
								</xsl:with-param>
							</xsl:apply-templates>
						</a>
						<p>
							<xsl:apply-templates select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TEXT"/>
						</p>
					</xsl:when>
					<xsl:when test="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 3">
						<h4>
							<a href="{$root}F{FORUMID}" class="topicpromotitle">
								<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TITLE"/>
							</a>
						</h4>
						<p>
							<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/FORUMPOSTCOUNT"/> posts</p>
						<p>
							<a href="{$root}F{FORUMID}" class="topicpromoimage">
								<xsl:apply-templates select="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
									<xsl:with-param name="imagename">
										<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGENAME"/>
									</xsl:with-param>
									<xsl:with-param name="imagealign">right</xsl:with-param>
									<xsl:with-param name="imagealttext">
										<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGEALTTEXT"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</a>
							<xsl:apply-templates select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TEXT"/>
						</p>
					</xsl:when>
					<xsl:when test="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 4">
						<h4>
							<a href="{$root}F{FORUMID}" class="topicpromotitle">
								<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TITLE"/>
							</a>
						</h4>
						<p>
							<a href="{$root}F{FORUMID}" class="topicpromoimage">
								<xsl:apply-templates select="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
									<xsl:with-param name="imagename">
										<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGENAME"/>
									</xsl:with-param>
									<xsl:with-param name="imagealign">right</xsl:with-param>
									<xsl:with-param name="imagealttext">
										<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/IMAGEALTTEXT"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</a>
							<xsl:apply-templates select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TEXT"/>
						</p>
					</xsl:when>
					<xsl:when test="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5">
						<h4>
							<a href="{$root}F{FORUMID}" class="topicpromotitle">
								<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TITLE"/>
							</a>
						</h4>
						<p>
							<xsl:value-of select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/FORUMPOSTCOUNT"/> posts</p>
						<p>
							<xsl:apply-templates select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TEXT"/>
						</p>
					</xsl:when>
					<xsl:when test="../../ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6">
						<xsl:apply-templates select="../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/TEXT"/>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<br/>
					<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
						<a href="{$root}frontpagetopicelementbuilder?page=editpage&amp;elementid={../../TOPICELEMENTLIST/TOPICELEMENT[TOPICID = current()/TOPICID]/ELEMENTID}&amp;s_finishreturnto=frontpagelayout">Edit topic promo</a>
					</div>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<em class="adminText" style="font-size:80%;">
						<span style="font-weight:bold;color:#333333;">
							<xsl:value-of select="TITLE"/>
						</span>
						<br/>
						Please enter topic promo here
					</em>
					<br/>
					<br/>
					<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
						<a href="{$root}frontpagetopicelementbuilder?page=createpage&amp;topicid={TOPICID}&amp;s_finishreturnto=frontpagelayout">Enter topic promo</a>
					</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-LAYOUT" mode="choose_image">
	Author:		Andy Harris
	Context:    H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT
	Purpose:	 Chooses the correct image promo size for the layout
	-->
	<xsl:template match="PAGE-LAYOUT" mode="choose_image">
		<xsl:param name="imagename"/>
		<xsl:param name="imagealign"/>
		<xsl:param name="imagealttext"/>
		<xsl:choose>
			<xsl:when test="LAYOUT = 1">
				<xsl:choose>
					<xsl:when test="ELEMTEMPLATE = 1">
						<img src="{$imagesource}{$imagename}" width="150" height="120" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 2">
						<img src="{$imagesource}{$imagename}" width="300" height="120" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 3">
						<img src="{$imagesource}{$imagename}" width="150" height="120" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 4">
						<img src="{$imagesource}{$imagename}" width="150" height="120" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 5">
						<img src="{$imagesource}{$imagename}" width="150" height="120" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="LAYOUT = 2">
				<xsl:choose>
					<xsl:when test="ELEMTEMPLATE = 1">
						<img src="{$imagesource}{$imagename}" width="97" height="77" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 2">
						<img src="{$imagesource}{$imagename}" width="195" height="77" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 3">
						<img src="{$imagesource}{$imagename}" width="97" height="77" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 4">
						<img src="{$imagesource}{$imagename}" width="97" height="77" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 5">
						<img src="{$imagesource}{$imagename}" width="97" height="77" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="LAYOUT = 3">
				<xsl:choose>
					<xsl:when test="ELEMTEMPLATE = 1">
						<img src="{$imagesource}{$imagename}" width="71" height="56" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 2">
						<img src="{$imagesource}{$imagename}" width="142" height="56" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 3">
						<img src="{$imagesource}{$imagename}" width="71" height="56" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 4">
						<img src="{$imagesource}{$imagename}" width="71" height="56" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
					<xsl:when test="ELEMTEMPLATE = 5">
						<img src="{$imagesource}{$imagename}" width="71" height="56" alt="{$imagealttext}" border="0">
							<xsl:if test="$imagealign = 'right'">
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:if>
						</img>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	*******************************************************************************************
	*******************************************************************************************
	These templates choose the correct textbox layout for the topics that appear on the frontpage. Again, links are 
	added to edit this information if this is the FRONTPAGE-LAYOUT page.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	<xsl:template match="TEXTBOXLIST" mode="choose_text">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXLIST
	Purpose:	 Displays any textbox based on the position of the box on the frontpage
	-->
	<xsl:template match="TEXTBOXLIST" mode="choose_text">
		<xsl:param name="number">1</xsl:param>
		<xsl:choose>
			<xsl:when test="TEXTBOX[FRONTPAGEPOSITION = $number]">
				<xsl:apply-templates select="TEXTBOX[FRONTPAGEPOSITION = $number]" mode="choose_texttemplate"/>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<br/>
					<br/>
					<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
						<a href="{$root}TextBoxBuilder?page=choosetype&amp;textboxid={TEXTBOX[FRONTPAGEPOSITION = $number]/ELEMENTID}&amp;FrontPagePosition={$number}&amp;s_finishreturnto=frontpagelayout">
						Edit text box <xsl:value-of select="$number"/>
						</a>
					</div>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE-LAYOUT'">
					<br/>
					<div class="buttonThreeD" style="font-size:80%;margin:10px;width:180px;text-align:center;">
						<a href="{$root}TextBoxBuilder?TextBoxID=0&amp;FrontPagePosition={$number}&amp;Page=choosetype&amp;s_finishreturnto=frontpagelayout">
						Enter text box <xsl:value-of select="$number"/> contents
					</a>
					</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TEXTBOXLIST" mode="choose_texttemplate">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXLIST/TEXTBOX
	Purpose:	 Chooses the correct textbox type
	-->
	<xsl:template match="TEXTBOX" mode="choose_texttemplate">
		<xsl:choose>
			<xsl:when test="TEXTBOXTYPE = 3">
				<xsl:apply-templates select="TEXT"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="TEXTBOXTYPE = 1">
						<xsl:choose>
							<xsl:when test="TEMPLATETYPE = 1">
								<p>
									<xsl:apply-templates select="TEXT"/>
								</p>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 2">
								<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 3">
								<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
								<p>
									<xsl:apply-templates select="TEXT"/>
								</p>
								<br clear="all"/>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 4">
								<p>
									<xsl:apply-templates select="TEXT"/>
								</p>
								<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
								<br clear="all"/>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 5">
								<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}" align="left"/>
								<p>
									<xsl:apply-templates select="TEXT"/>
								</p>
								<br clear="all"/>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 6">
								<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}" align="right"/>
								<p>
									<xsl:apply-templates select="TEXT"/>
								</p>
								<br clear="all"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="TEXTBOXTYPE = 2">
						<xsl:choose>
							<xsl:when test="TEMPLATETYPE = 1">
								<h2>Top 5 New Discussions</h2>
								<!--<h2>Top 5 Busiest Topics</h2>-->
								<xsl:choose>
									<xsl:when test="../../TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']">
										<ol>
											<xsl:for-each select="../../TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']/TOP-FIVE-FORUM[position() &lt; 6]">
												<li>
													<a href="{$root}F{FORUMID}" class="topfivetopic">
														<xsl:choose>
															<xsl:when test="string-length(SUBJECT) > 15">
																<xsl:value-of select="substring(SUBJECT, 0, 15)"/>
																<xsl:text>...</xsl:text>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="SUBJECT"/>
															</xsl:otherwise>
														</xsl:choose>
													</a>
												</li>
											</xsl:for-each>
										</ol>
									</xsl:when>
									<xsl:otherwise>
										<p>This top 5 will be empty until the board is launched</p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 2">
								<h2>Top 5 New Discussions</h2>
								<xsl:choose>
									<xsl:when test="../../TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']">
										<ol>
											<xsl:for-each select="../../TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']/TOP-FIVE-FORUM[position() &lt; 6]">
												<li>
													<a href="{$root}F{FORUMID}?thread={THREADID}" class="topfivetopic">
														<xsl:choose>
															<xsl:when test="string-length(SUBJECT) > 15">
																<xsl:value-of select="substring(SUBJECT, 0, 15)"/>
																<xsl:text>...</xsl:text>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="SUBJECT"/>
															</xsl:otherwise>
														</xsl:choose>
													</a>
												</li>
											</xsl:for-each>
										</ol>
									</xsl:when>
									<xsl:otherwise>
										<p>This top 5 will be empty until the board is launched</p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="TEMPLATETYPE = 3">
								<h2>Top 5 New Discussions</h2>
								<!--<h2>Top 5 Busiest Discussions</h2>-->
								<xsl:choose>
									<xsl:when test="../../TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']">
										<ol>
											<xsl:for-each select="../../TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']/TOP-FIVE-FORUM[position() &lt; 6]">
												<li>
													<a href="{$root}F{FORUMID}?thread={THREADID}" class="topfivetopic">
														<xsl:choose>
															<xsl:when test="string-length(SUBJECT) > 15">
																<xsl:value-of select="substring(SUBJECT, 0, 15)"/>
																<xsl:text>...</xsl:text>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="SUBJECT"/>
															</xsl:otherwise>
														</xsl:choose>
													</a>
												</li>
											</xsl:for-each>
										</ol>
									</xsl:when>
									<xsl:otherwise>
										<p>This top 5 will be empty until the board is launched</p>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	**********************************************************************************
	**************************************FORMS***************************************
	**********************************************************************************
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	These templates create the forms that are used to set the values for the PAGE-LAYOUT element. The LAYOUT, TEMPLATE 
	and ELEMTEMPLATE objects.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="choose_layout">
	Author:		Andy Harris
	Context:    H2G2/FRONTPAGELAYOUTCOMPONENTS
	Purpose:	 Form for choosing the number of columns
	-->
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="choose_layout">
		<xsl:call-template name="external_link">
			<xsl:with-param name="return">messageboardadmin</xsl:with-param>
			<xsl:with-param name="link">Create and host your own homepage</xsl:with-param>
		</xsl:call-template>
		<form method="post" action="{$root}FrontPageLayout" name="layoutSelection">
			<input type="hidden" name="EditKey" value="{ARTICLE/ARTICLEINFO/EDIT-KEY}"/>
			<input type="hidden" name="cmd" value="chooseLayout"/>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE">
				<input type="hidden" name="s_finishreturnto" value="messageboardadmin"/>
				<input type="hidden" name="s_fromadmin" value="1"/>
			</xsl:if>
			<input type="radio" name="layouttype" value="1">
				<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT=1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
				2 columns			
			<br/>
			<input type="radio" name="layouttype" value="2">
				<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT=2">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
				3 columns			
			<br/>
			<input type="radio" name="layouttype" value="3">
				<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT=3">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
				4 columns
			<br/>
			<input type="radio" name="layouttype" value="4">
				<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT=4">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
				Or code your own in GuideML...
				<a href="http://www.bbc.co.uk/dnaimages/boards/guideml_popup.html" target="_blank" onclick="openPreview('http://www.bbc.co.uk/dnaimages/boards/guideml_popup.html', 600, 400); return false;">
				<img src="{$adminimagesource}questionmark.gif" alt="Whats this?" width="20" height="20" border="0"/>
			</a>
			<br/>
			<!--<input type="radio" name="layouttype" value="5">
				<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT=5">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
				External to DNA
			<br/>-->
			<div>
				<br/>
				<span class="buttonLeftA">
					<div class="buttonThreeD">
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE">
								<a href="{$root}messageboardadmin">Back</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}frontpagelayout">Back</a>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</span>
				<input type="submit" name="submit" value="Show templates >>" class="buttonThreeD" id="buttonRightInput">
					<xsl:attribute name="onclick"><xsl:choose><xsl:when test="(ARTICLE/FRONTPAGE) and (TEXTBOXLIST/TEXTBOX)">return changeTemplate();</xsl:when><xsl:otherwise>return alertGuideML();</xsl:otherwise></xsl:choose></xsl:attribute>
				</input>
				<!-- <input type="hidden" name="skin" value="purexml"/> -->
			</div>
			<br/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="choose_layout">
	Author:		Andy Harris
	Context:    H2G2/FRONTPAGELAYOUTCOMPONENTS
	Purpose:	 Form for choosing the layout
	-->
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="choose_template">
		<xsl:param name="column_number">
			<xsl:choose>
				<xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT = 1">2</xsl:when>
				<xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT = 2">3</xsl:when>
				<xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT = 3">4</xsl:when>
				<xsl:when test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT = 5">external</xsl:when>
			</xsl:choose>
		</xsl:param>
		<xsl:apply-templates select="." mode="choose_layout"/>
		<div class="shadedDivider" style="width:715px;margin-left:5px;">
			<hr/>
		</div>
		<br/>
		<form method="post" action="{$root}FrontPageLayout" name="templateSelection">
			<input type="hidden" name="EditKey" value="{ARTICLE/ARTICLEINFO/EDIT-KEY}"/>
			<input type="hidden" name="cmd" value="chooseTemplate"/>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE">
				<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$column_number = 2">
					<div style="display:inline;margin-right:20px;" class="small">
						<input type="radio" name="tmpltype" value="1">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}twocolumn_layout1.gif" width="101" height="146" alt="2 column layout 1" align="top"/>
						minimum of 2 topics
					</div>
					<div style="display:inline;" class="small">
						<input type="radio" name="tmpltype" value="2">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=2">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}twocolumn_layout2.gif" width="101" height="145" alt="2 column layout 2" align="top"/>
						minimum of 1 topic
					</div>
					<br/>
					<br/>
					<div style="display:inline;margin-right:20px;" class="small">
						<input type="radio" name="tmpltype" value="3">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=3">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}twocolumn_layout3.gif" width="101" height="146" alt="2 column layout 3" align="top"/>
						minimum of 2 topics
					</div>
					<br/>
					<br/>
					<input type="button" name="preview" value="Sample Preview" onclick="openTwoColumnPreview()" class="buttonThreeD"/>
				</xsl:when>
				<xsl:when test="$column_number = 3">
					<div style="display:inline;margin-right:20px;" class="small">
						<input type="radio" name="tmpltype" value="1">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}threecolumn_layout1.gif" width="140" height="146" alt="3 column layout 1" align="top"/>
						minimum of 4 topics
					</div>
					<div style="display:inline;" class="small">
						<input type="radio" name="tmpltype" value="2">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=2">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}threecolumn_layout2.gif" width="140" height="146" alt="3 column layout 2" align="top"/>
						minimum of 6 topics
					</div>
					<br/>
					<br/>
					<div style="display:inline;margin-right:20px;" class="small">
						<input type="radio" name="tmpltype" value="3">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=3">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}threecolumn_layout3.gif" width="140" height="146" alt="3 column layout 3" align="top"/>
						minimum of 3 topics
					</div>
					<div style="display:inline;" class="small">
						<input type="radio" name="tmpltype" value="4">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=4">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}threecolumn_layout4.gif" width="140" height="146" alt="3 column layout 4" align="top"/>
						minimum of 4 topics
					</div>
					<br/>
					<br/>
					<input type="button" name="preview" value="Sample Preview" onclick="openThreeColumnPreview()" class="buttonThreeD"/>
				</xsl:when>
				<xsl:when test="$column_number = 4">
					<div style="display:inline;margin-right:20px;" class="small">
						<input type="radio" name="tmpltype" value="1">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}fourcolumn_layout1.gif" width="183" height="146" alt="4 column layout 1" align="top"/>
						minimum of 6 topics
					</div>
					<div style="display:inline;">
						<input type="radio" name="tmpltype" value="2" class="small">
							<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/TEMPLATE=2">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<img src="{$adminimagesource}fourcolumn_layout2.gif" width="183" height="146" alt="4 column layout 2" align="top"/>
						minimum of 6 topics
					</div>
					<br/>
					<br/>
					<input type="button" name="preview" value="Sample Preview" onclick="openFourColumnPreview()" class="buttonThreeD"/>
				</xsl:when>
				<!--<xsl:when test="$column_number = 'external'">
					<div style="display:inline;margin-right:20px;">
						<p>Some gumph about the need to add a URL and what this all means</p>
					</div>
					<br/>
					<br/>
					<div class="buttonThreeD">
						<a href="{$root}frontpagelayout?s_updatelayout=yes">Add Homepage URL &gt; &gt;</a>
					</div>
				</xsl:when>-->
			</xsl:choose>
			<br/>
			<br/>
			<div class="shadedDivider" style="width:715px;margin-left:5px;">
				<hr/>
			</div>
			<br/>
			<span class="buttonLeftA">
				<div class="buttonThreeD">
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE">
							<a href="{$root}frontpagelayout?s_updatelayout=yes&amp;s_fromadmin=1">&lt; &lt; Back</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}frontpagelayout?s_updatelayout=yes">&lt; &lt; Back</a>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</span>
			<xsl:if test="not($column_number = 'external')">
				<input type="submit" name="submit" value="Save template choice >>" class="buttonThreeD" id="buttonRightInput"/>
			</xsl:if>
			<br/>
			<br/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
		</form>
	</xsl:template>
	<!--
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="choose_layout">
	Author:		Andy Harris
	Context:    H2G2/FRONTPAGELAYOUTCOMPONENTS
	Purpose:	 Form for choosing the promo type
	-->
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="choose_promo">
		<form method="post" action="{$root}FrontPageLayout" name="topicSelection">
			<h2 class="adminFormHeader">Choose Topic Promo Template - Layout</h2>
			<br/>
			<br/>
			<input type="hidden" name="EditKey" value="{ARTICLE/ARTICLEINFO/EDIT-KEY}"/>
			<input type="hidden" name="cmd" value="chooseElemTemplate"/>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE">
				<input type="hidden" name="s_returnto" value="messageboardadmin"/>
			</xsl:if>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<div style="display:inline;margin-right:40px;">
				<input type="radio" name="elemtmpltype" value="1">
					<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE=1">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<img src="{$adminimagesource}promo_layout1.gif" width="111" height="117" alt="promo layout 1" align="top"/>
			</div>
			<div style="display:inline;margin-right:40px;">
				<input type="radio" name="elemtmpltype" value="2">
					<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE=2">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<img src="{$adminimagesource}promo_layout2.gif" width="111" height="117" alt="promo layout 2" align="top"/>
			</div>
			<div style="display:inline;;">
				<input type="radio" name="elemtmpltype" value="3">
					<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE=3">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<img src="{$adminimagesource}promo_layout3.gif" width="111" height="117" alt="promo layout 3" align="top"/>
			</div>
			<br/>
			<br/>
			<div style="display:inline;margin-right:40px;">
				<input type="radio" name="elemtmpltype" value="4">
					<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE=4">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<img src="{$adminimagesource}promo_layout4.gif" width="111" height="117" alt="promo layout 4" align="top"/>
			</div>
			<div style="display:inline;margin-right:40px;">
				<input type="radio" name="elemtmpltype" value="5">
					<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE=5">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<img src="{$adminimagesource}promo_layout5.gif" width="111" height="117" alt="promo layout 5" align="top"/>
			</div>
			<div style="display:inline;">
				<input type="radio" name="elemtmpltype" value="6">
					<xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE=6">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				Code your own in GuideML...
				<a href="http://www.bbc.co.uk/dnaimages/boards/guideml_popup.html" target="_blank" onclick="openPreview('http://www.bbc.co.uk/dnaimages/boards/guideml_popup.html', 600, 400); return false;">
					<img src="{$adminimagesource}questionmark.gif" alt="Whats this?" width="20" height="20" border="0"/>
				</a>
			</div>
			<br/>
			<br/>
			<input type="button" name="preview" value="Sample Preview" onclick="openTopicPreview()" class="buttonThreeD" style="margin-left:520px;"/>
			<br/>
			<br/>
			<div class="shadedDivider" style="width:715px;margin-left:5px;">
				<hr/>
			</div>
			<span class="buttonLeftA" style="margin-left:20px;">
				<div class="buttonThreeD">
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_fromadmin']/VALUE">
							<a href="{$root}messageboardadmin">&lt; &lt; Back</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}frontpagelayout?cmd=chooseLayout&amp;layouttype={ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT}">&lt; &lt; Back</a>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</span>
			<input type="submit" name="submit" value="Save templates >>" class="buttonThreeD" id="buttonRightInput" style="margin-right:40px;">
				<xsl:attribute name="onclick"><xsl:if test="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE">return changeTopic();</xsl:if></xsl:attribute>
			</input>
			<br/>
			<br/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="topic_guideml">
	Author:		Andy Harris
	Context:    H2G2/FRONTPAGELAYOUTCOMPONENTS
	Purpose:	 Form for writing a GuideML template for topics
	-->
	<xsl:template match="FRONTPAGELAYOUTCOMPONENTS" mode="topic_guideml">
		<h3 class="adminFormHeader">Create Topic Promo Template</h3>
		<br/>
		<br/>
		You can code the message boards homepage in GuideML.  This allows you to tailor the layout exactly to your<br/> needs, but will limit some of the options we provide through the templates.<br/>
		<br/>
		
			In addition to the ususal HTML tags, there is one message boards specific GuideML tag that can be used:
			<ul>
			<li class="adminText">&lt;TOPICLINKlink text&lt;/TOPICLINK&gt; - this create a normal hyperlink to the topic</li>
		</ul>
		
			Also, the following articles from h2g2 could be helpful
			<ul>
			<li class="adminText">
				<a href="http://www.bbc.co.uk/dna/h2g2/alabaster/A264520" style="color:#333333;">Using Approved GuideML in the Edited Guide</a>
			</li>
			<li class="adminText">
				<a href="http://www.bbc.co.uk/dna/h2g2/alabaster/GuideML-Clinic" style="color:#333333;">The GuideML Clinic</a>
			</li>
		</ul>
		<form method="post" action="{$root}FrontPageLayout?cmd=CustomElem">
			<input type="hidden" name="EditKey" value="{ARTICLE/ARTICLEINFO/EDIT-KEY}"/>
			<input type="hidden" name="cmd" value="chooseElemTemplate"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<!--<input type="hidden" name="skin" value="purexml"/>-->
			<textarea cols="40" rows="10" wrap="virtual" name="CustomElem">
				<xsl:value-of select="ARTICLE/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE-GUIDEML-ESCAPED"/>
			</textarea>
			<br/>
			<!--<input type="submit" name="preview" value="Quick Preview"/>
			<div class="preview" style="border: 1px dashed #000000; padding: 5px; width: 645px;">
				<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/node()"/>
			</div>-->
			<br/>
			<div class="shadedDivider" style="width:715px;margin-left:5px;">
				<hr/>
			</div>
			<span class="buttonLeftA">
				<div class="buttonThreeD">
					<a href="{$root}frontpagelayout?cmd=chooseLayout&amp;layouttype={ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT}">&lt; &lt; Back</a>
				</div>
			</span>
			<input type="submit" name="submit" value="Save template >>" class="buttonThreeD" id="buttonRightInput" style="margin-right:40px;"/>
			<br/>
			<br/>
		</form>
	</xsl:template>
</xsl:stylesheet>
