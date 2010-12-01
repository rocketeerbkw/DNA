<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="TEXTBOXELEMENTPAGE_JAVASCRIPT">
		<script language="JavaScript" src="/dnaimages/adminsystem/includes/textboxapp.js"/>
		<script type="text/javascript">
		function openSamplePreview(type) {
			openPreview('/dnaimages/boards/images/' + type + '_sample.gif', 400, 400);	
			return false;	
		}
		</script>
	</xsl:template>
	<!--
	<xsl:template name="TEXTBOXELEMENTPAGE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="TEXTBOXELEMENTPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Frontpage Textbox
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="TEXTBOXELEMENTPAGE_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="TEXTBOXELEMENTPAGE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Frontpage Textbox
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:variable name="layout">
		<xsl:value-of select="/H2G2/FRONTPAGE/PAGE-LAYOUT/LAYOUT"/>
	</xsl:variable>
	<xsl:variable name="template">
		<xsl:value-of select="/H2G2/FRONTPAGE/PAGE-LAYOUT/TEMPLATE"/>
	</xsl:variable>
	<xsl:variable name="topictemplate">
		<xsl:value-of select="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE"/>
	</xsl:variable>
	<xsl:variable name="textbox">
		<xsl:value-of select="/H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[@EDITSTATUS = 'ACTIVE']/FRONTPAGEPOSITION"/>
	</xsl:variable>
	<xsl:variable name="no_of_textboxes">
		<xsl:choose>
			<xsl:when test="($layout=1 and ($template=2 or $template=3)) or ($layout=2 and $template=3)">1</xsl:when>
			<xsl:when test="($layout=1 and $template=1) or ($layout=2 and $template=2)">2</xsl:when>
			<xsl:when test="($layout=2 and ($template=1 or $template=4)) or ($layout=3 and $template=2)">3</xsl:when>
			<xsl:otherwise>4</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	<xsl:template name="TEXTBOXELEMENTPAGE_MAINBODY">
	Author:		Andy Harris
	Context:    H2G2
	Purpose:	 Main template call for the textboxbuilder pages
	-->
	<xsl:template name="TEXTBOXELEMENTPAGE_MAINBODY">
		<!-- <h2>Content Management</h2>
		<xsl:apply-templates select="ERROR"/>
		<table>
			<tr>
				<td width="25%" valign="top">
					<xsl:apply-templates select="TEXTBOXPAGE" mode="navigation"/>
				</td>
				<td width="75%" valign="top"> -->
		<xsl:choose>
			<xsl:when test="TEXTBOXPAGE/@PAGE='choosetype'">
				<xsl:apply-templates select="TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[@EDITSTATUS = 'ACTIVE']" mode="choose_type"/>
			</xsl:when>
			<xsl:when test="TEXTBOXPAGE/@PAGE='choosetemplate'">
				<xsl:apply-templates select="TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[@EDITSTATUS = 'ACTIVE']" mode="choose_template"/>
			</xsl:when>
			<xsl:when test="TEXTBOXPAGE/@PAGE='textandimage'">
				<xsl:apply-templates select="TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[@EDITSTATUS = 'ACTIVE']" mode="choose_text"/>
			</xsl:when>
		</xsl:choose>
		<!-- </td>
			</tr>
		</table>-->
	</xsl:template>
	<!--
	<xsl:template match="TEXTBOXPAGE" mode="navigation">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXPAGE
	Purpose:	 Templateused to navigate around the textboxes
	-->
	<xsl:template match="TEXTBOXPAGE" mode="navigation">
		<xsl:choose>
			<xsl:when test="$no_of_textboxes = 1">
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">1</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$no_of_textboxes = 2">
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">1</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">2</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$no_of_textboxes = 3">
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">1</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">2</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">3</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">1</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">2</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">3</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="textbox_navigation_links">
					<xsl:with-param name="pageposition">4</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="textbox_navigation_links">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXPAGE
	Purpose:	 Template used to create the links for the navigation
	-->
	<xsl:template name="textbox_navigation_links">
		<xsl:param name="pageposition">1</xsl:param>
		<div>
			<xsl:if test="/H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[@EDITSTATUS = 'ACTIVE'][FRONTPAGEPOSITION = $pageposition]">
				<xsl:attribute name="class">selected</xsl:attribute>
			</xsl:if>
			<a>
				<xsl:attribute name="href"><xsl:value-of select="$root"/>textboxbuilder?TextBoxID=
					<xsl:choose><xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[FRONTPAGEPOSITION = $pageposition]"><xsl:value-of select="/H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX[FRONTPAGEPOSITION = $pageposition]/ELEMENTID"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
					&amp;frontpageposition=<xsl:value-of select="$pageposition"/>
					&amp;page=choosetype
					&amp;s_finishreturnto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:attribute>
				Textbox <xsl:value-of select="$pageposition"/>
			</a>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="TEXTBOX" mode="choose_type">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX
	Purpose:	 Form for changing the textbox type.
	-->
	<xsl:template match="TEXTBOX" mode="choose_type">
		<form name="choosetype" method="post" action="{$root}textboxbuilder">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Homepage / Edit text box</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<input type="hidden" name="textboxid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="choosetype"/>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 3">
								<input type="hidden" name="page" value="textandimage"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="page" value="choosetemplate"/>
							</xsl:otherwise>
						</xsl:choose>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<h2 class="adminFormHeader">Choose text box type for Text Box <xsl:value-of select="FRONTPAGEPOSITION"/>
						</h2>
						<br/>
						<br/>
						<input type="radio" name="type" value="1" onclick="promoSelected();">
							<xsl:if test="TEXTBOXTYPE=1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>Promo
						</input>
						<br/>
						<input type="radio" name="type" value="2">
							<xsl:if test="TEXTBOXTYPE=2">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>DNA-Generated
						</input>
						<br/>
						<input type="radio" name="type" value="3" onclick="guideMLSelected();">
							<xsl:if test="TEXTBOXTYPE=3">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>GuideML
							<a href="/dnaimages/boards/guideml_popup.html" target="_blank" onclick="openPreview('/dnaimages/boards/guideml_popup.html', 600, 400); return false;">
								<img src="{$adminimagesource}questionmark.gif" alt="Whats this?" width="20" height="20" border="0" hspace="5"/>
							</a>
						</input>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
							<span class="buttonLeftA"><div class="buttonThreeD">
								<a href="{$root}frontpagelayout?s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div></span>
							<input type="submit" value="Next &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br /><br />
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template name="TEXTBOX">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX
	Purpose:	 Form for changing the textbox template.
	-->
	<xsl:template match="TEXTBOX" mode="choose_template">
		<form name="choosetemplate" method="post" action="{$root}textboxbuilder">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Homepage / Choose text box template</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h3 class="adminFormHeader">Choose a text box template for Text Box <xsl:value-of select="FRONTPAGEPOSITION"/>
						</h3>
						<br/>
						<br/>
						<input type="hidden" name="textboxid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="choosetemplate"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 2">
								<input type="hidden" name="_redirect" value="frontpagelayout"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="page" value="textandimage"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 1">
								<div style="text-align:center;">
									<div style="display:inline;margin-right:40px;">
										<input type="radio" name="template" value="1">
											<xsl:if test="TEMPLATETYPE=1">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout1.gif" width="111" height="117" alt="textbox layout 1" align="top"/>
									</div>
									<div style="display:inline;margin:0px 40px;">
										<input type="radio" name="template" value="2">
											<xsl:if test="TEMPLATETYPE=2">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout2.gif" width="111" height="117" alt="textbox layout 2" align="top"/>
									</div>
									<div style="display:inline;margin-left:40px;">
										<input type="radio" name="template" value="3">
											<xsl:if test="TEMPLATETYPE=3">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout3.gif" width="111" height="117" alt="textbox layout 3" align="top"/>
									</div>
									<br/>
									<br/>
									<div style="display:inline;margin-right:40px;">
										<input type="radio" name="template" value="4">
											<xsl:if test="TEMPLATETYPE=4">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout4.gif" width="111" height="117" alt="textbox layout 4" align="top"/>
									</div>
									<div style="display:inline;margin:0px 40px;">
										<input type="radio" name="template" value="5">
											<xsl:if test="TEMPLATETYPE=5">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout5.gif" width="111" height="117" alt="textbox layout 5" align="top"/>
									</div>
									<div style="display:inline;margin-left:40px;">
										<input type="radio" name="template" value="6">
											<xsl:if test="TEMPLATETYPE=6">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout6.gif" width="111" height="117" alt="textbox layout 6" align="top"/>
									</div>
								</div>
							</xsl:when>
							<xsl:when test="TEXTBOXTYPE = 2">
								<div style="display:inline;margin-right:40px;">
									<input type="radio" name="template" value="1">
										<xsl:if test="TEMPLATETYPE=1">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
						Top 5 busiest topics
						<br/>
						(calculated on total number of messages in the last 12 hours)
						<p class="small">
										<a href="/dnaimages/boards/images/busiest_sample.gif" onclick="return openSamplePreview('busiest');" target="_blank">See sample preview</a>
									</p>
								</div>
								<div style="display:inline;margin:0px 40px;">
									<input type="radio" name="template" value="2">
										<xsl:if test="TEMPLATETYPE=2">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
						Top 5 most recently created discussions
						<br/>
						(calculated on discussions started in the last 1 hour)		
						<p class="small">
										<a href="/dnaimages/boards/images/recent_sample.gif" onclick="return openSamplePreview('recent');" target="_blank">See sample preview</a>
									</p>
								</div>
								<div style="display:inline;margin-left:40px;">
									<input type="radio" name="template" value="3">
										<xsl:if test="TEMPLATETYPE=3">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
						Top 5 busiest discussions
						<br/>
						(calculated on total number of messages in the last 1 hour)
						<p class="small">
										<a href="/dnaimages/boards/images/busiest_hour_sample.gif" onclick="return openSamplePreview('busiest_hour');" target="_blank">See sample preview</a>
									</p>
								</div>
							</xsl:when>
						</xsl:choose>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
							<span class="buttonLeftA"><div class="buttonThreeD">
								<a href="{$root}textboxbuilder?textboxid={ELEMENTID}&amp;page=choosetype&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div></span>
							<input type="submit" value="Next &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br /><br />
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="TEXTBOX" mode="choose_text">
	Author:		Andy Harris
	Context:    H2G2/TEXTBOXPAGE/TEXTBOXLIST/TEXTBOX
	Purpose:	 Form for changing the textbox text.
	-->
	<xsl:template match="TEXTBOX" mode="choose_text">
		<form name="textandimage" method="post" action="{$root}textboxbuilder">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Homepage / Create text box content</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h2 class="adminFormHeader">
			Create text box content for Text Box <xsl:value-of select="FRONTPAGEPOSITION"/>
						</h2>
						<br/>
						<br/>
						<xsl:variable name="width">
							<xsl:choose>
								<xsl:when test="($layout = 1 and not($template = 3))">315</xsl:when>
								<xsl:when test="($layout = 1 and $template = 3) or ($layout = 2 and $template = 3)">635</xsl:when>
								<xsl:when test="($layout = 2 and $template = 1 and $textbox = 1) or ($layout = 2 and $template = 4 and $textbox = 2)">421</xsl:when>
								<xsl:when test="($layout = 2 and $template = 1 and $textbox = 2) or ($layout = 2 and $template = 1 and $textbox = 3) or ($layout = 2 and $template = 2) or ($layout = 2 and $template = 4 and $textbox = 1) or ($layout = 2 and $template = 4 and $textbox = 3)">208</xsl:when>
								<xsl:when test="($layout = 3 and $template = 1) or ($layout = 3 and $template = 2 and $textbox = 2) or ($layout = 3 and $template = 2 and $textbox = 3)">155</xsl:when>
								<xsl:when test="$layout = 3 and $template = 2 and $textbox = 1">475</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="fields">
							<xsl:choose>
								<xsl:when test="TEXTBOXTYPE = 3 or TEMPLATETYPE = 1"><![CDATA[<MULTI-INPUT>
					<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					</MULTI-INPUT>]]></xsl:when>
								<xsl:when test="TEMPLATETYPE = 2"><![CDATA[<MULTI-INPUT>
					<REQUIRED NAME='TEXT'></REQUIRED>
					<REQUIRED NAME='IMAGENAME'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEWIDTH'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEHEIGHT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEALTTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					</MULTI-INPUT>]]></xsl:when>
								<xsl:otherwise><![CDATA[<MULTI-INPUT>
					<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGENAME'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEWIDTH'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEHEIGHT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEALTTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					</MULTI-INPUT>]]></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<input type="hidden" name="textboxid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="textandimage"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="_msxml" value="{$fields}"/>
						<input type="hidden" name="_msfinish" value="yes"/>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 3">
								<textarea name="text" cols="50" rows="5" class="inputBG">
									<xsl:value-of select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
								</textarea>
								<br/>
							</xsl:when>
							<xsl:otherwise>
								<h3 class="adminFormHeader">Enter text</h3>  (character limit depends on size of image: use the preview as a guide)
								<xsl:if test="not(TEMPLATETYPE = 2)">
									<textarea name="text" cols="50" rows="5" class="inputBG">
										<xsl:value-of select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
									</textarea>
									<br/>
									<div class="buttonThreeD" style="margin-left:0px;">
										<a href="#" onclick="format('strong','openclose')">
											<b>B</b>
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('em','openclose')">
											<em>I</em>
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('u','openclose')">
											<u>U</u>
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('a','link')">
											Insert hyperlink...
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('titletext','openclose')">
											Title text
										</a>
									</div>
									<a href="/dnaimages/boards/titletext_popup.html" target="_blank" onclick="openPreview('/dnaimages/boards/titletext_popup.html', 600, 400); return false;">
										<img src="{$adminimagesource}questionmark.gif" alt="Whats this?" width="20" height="20" border="0" hspace="5"/>
									</a>
									<br/>
									<br/>
								</xsl:if>
								<xsl:if test="not(TEMPLATETYPE = 1)">
									<h3 class="adminFormHeader">Image filename:</h3>
									<br/>
									This image should be published in your dev web space to ensure you can preview it here.<br/>
									<input name="imagename" size="50" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/></xsl:attribute>
									</input>
									<br/>
									<br/>
									<h3 class="adminFormHeader">Image dimensions</h3> (max width is <xsl:value-of select="$width"/>px)<br/>
									These need to be entered in order to comply to BBC coding standards<br/>
									Width:
									<input name="imagewidth" size="10" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEWIDTH']/VALUE-EDITABLE"/></xsl:attribute>
									</input> pixels
									<br/>
									Height: 
									<input name="imageheight" size="10" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEHEIGHT']/VALUE-EDITABLE"/></xsl:attribute>
									</input> pixels<br/>
									<br/>
									<h3 class="adminFormHeader">Image alt text:</h3>
									<br/>
									<input name="imagealttext" size="50" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/></xsl:attribute>
									</input>
								</xsl:if>
								<br/>
								<br/>
							</xsl:otherwise>
						</xsl:choose>
						<h3 class="adminFormHeader">Preview</h3>
						<div style="padding:5px; border:dashed #000000 1px; width: {$width}px">
							<xsl:if test="/H2G2/TEXTBOXPAGE/MULTI-STAGE/@CANCEL = 'YES'">
								<xsl:choose>
									<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXTBOXTYPE = 3">
										<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXT"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEMPLATETYPE = 1">
												<p>
													<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXT"/>
												</p>
											</xsl:when>
											<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEMPLATETYPE = 2">
												<img src="{$imagesource}{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGENAME}" width="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEWIDTH}" height="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEHEIGHT}" alt="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEALTTEXT}"/>
											</xsl:when>
											<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEMPLATETYPE = 3">
												<img src="{$imagesource}{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGENAME}" width="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEWIDTH}" height="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEHEIGHT}" alt="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEALTTEXT}"/>
												<p>
													<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXT"/>
												</p>
											</xsl:when>
											<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEMPLATETYPE = 4">
												<p>
													<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXT"/>
												</p>
												<img src="{$imagesource}{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGENAME}" width="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEWIDTH}" height="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEHEIGHT}" alt="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEALTTEXT}"/>
											</xsl:when>
											<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEMPLATETYPE = 5">
												<img src="{$imagesource}{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGENAME}" width="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEWIDTH}" height="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEHEIGHT}" alt="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEALTTEXT}" align="left"/>
												<p>
													<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXT"/>
												</p>
											</xsl:when>
											<xsl:when test="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEMPLATETYPE = 6">
												<img src="{$imagesource}{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGENAME}" width="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEWIDTH}" height="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEHEIGHT}" alt="{/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/IMAGEALTTEXT}" align="right"/>
												<p>
													<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/TEXTBOX-PREVIEW/TEXTBOX/TEXT"/>
												</p>
											</xsl:when>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<br clear="all"/>
						</div>
						<br />
						<input type="submit" name="_mscancel" value="preview" class="buttonThreeD" style="margin-left:325px;"/>
						<br />
						<xsl:if test="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS">
			Parse Errors : 
			<br/>
							<xsl:apply-templates select="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS/ERROR"/>
						</xsl:if>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA"><div class="buttonThreeD">
							<xsl:choose>
								<xsl:when test="TEXTBOXTYPE = 3">									
										<a href="{$root}textboxbuilder?textboxid={ELEMENTID}&amp;page=choosetype&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
								</xsl:when>
								<xsl:otherwise>									
										<a href="{$root}textboxbuilder?textboxid={ELEMENTID}&amp;page=choosetemplate&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>	
								</xsl:otherwise>
							</xsl:choose>
						</div></span>
						<input type="submit" value="Save text box &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br /><br />
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
</xsl:stylesheet>
