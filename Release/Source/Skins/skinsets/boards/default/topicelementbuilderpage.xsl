<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_JAVASCRIPT">
		<script language="JavaScript" src="/dnaimages/adminsystem/includes/textboxapp.js"/>
	</xsl:template>
	<!--
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Frontpage Topic Promo
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Frontpage Topic Promo
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
	<!-- !!!!This page uses a couple of variables defined on the textboxelementpage!!!! -->
	<!--
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_MAINBODY">
	Author:		Andy Harris
	Context:    H2G2
	Purpose:	 Main template call for the textboxbuilder pages
	-->
	<xsl:template name="FRONTPAGETOPICELEMENTBUILDER_MAINBODY">
		<xsl:apply-templates select="ERROR"/>
		<!--<table>
			<tr>
				<td width="25%" valign="top">
					<xsl:apply-templates select="TOPICELEMENTPAGE" mode="navigation"/>
				</td>
				<td width="75%" valign="top">-->
		<xsl:choose>
			<xsl:when test="TOPICELEMENTPAGE/@PAGE='createpage'">
				<xsl:apply-templates select="TOPICELEMENTPAGE" mode="create_topicpromo"/>
			</xsl:when>
			<xsl:when test="TOPICELEMENTPAGE/@PAGE='editpage'">
				<xsl:apply-templates select="TOPICELEMENTPAGE" mode="edit_topicpromo"/>
			</xsl:when>
		</xsl:choose>
		<!-- </td>
			</tr>
		</table> -->
	</xsl:template>
	<!--
	<xsl:template match="TOPICELEMENTPAGE" mode="navigation">
	Author:		Andy Harris
	Context:    H2G2/TOPICELEMENTPAGE
	Purpose:	 Template used to navigate around the textboxes
	-->
	<xsl:template match="TOPICELEMENTPAGE" mode="navigation">
		<xsl:apply-templates select="TOPICLIST/TOPIC" mode="navigation"/>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="navigation">
	Author:		Andy Harris
	Context:    H2G2/TOPICELEMENTPAGE/TOPICLIST/TOPIC
	Purpose:	 Template used to create the links for the navigation
	-->
	<xsl:template match="TOPIC" mode="navigation">
		<div>
			<xsl:if test="TOPICID = /H2G2/TOPICELEMENTPAGE/TOPICELEMENTLIST/TOPICELEMENT[@EDITSTATUS = 'ACTIVE']/TOPICID">
				<xsl:attribute name="class">selected</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="TOPICID = /H2G2/TOPICELEMENTPAGE/TOPICELEMENTLIST/TOPICELEMENT/TOPICID">
					<a href="{$root}frontpagetopicelementbuilder?page=editpage&amp;elementid={/H2G2/TOPICELEMENTPAGE/TOPICELEMENTLIST/TOPICELEMENT[TOPICID= TOPICID]/ELEMENTID}&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">
						<xsl:value-of select="TITLE"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}frontpagetopicelementbuilder?page=createpage&amp;topicid={TOPICID}&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">
						<xsl:value-of select="TITLE"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="TOPICELEMENTPAGE" mode="edit_topicpromo">
	Author:		Andy Harris
	Context:    H2G2/TOPICELEMENTPAGE
	Purpose:	 Form for changing the topicpromo text.
	-->
	<xsl:template match="TOPICELEMENTPAGE" mode="create_topicpromo">
		<form name="textandimage" method="post" action="{$root}frontpagetopicelementbuilder">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Topic Management / Add New Topic (step 2 of 2)</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<xsl:variable name="command">create</xsl:variable>
						<xsl:variable name="width">
							<xsl:choose>
								<xsl:when test="$layout = 1">310</xsl:when>
								<xsl:when test="$layout = 2">205</xsl:when>
								<xsl:when test="$layout = 3">152</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="fields">
							<xsl:choose>
								<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5"><![CDATA[<MULTI-INPUT>						
									<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='IMAGENAME'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='IMAGEALTTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									</MULTI-INPUT>]]></xsl:when>
								<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6"><![CDATA[<MULTI-INPUT>						
									<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									</MULTI-INPUT>]]></xsl:when>
								<xsl:otherwise><![CDATA[<MULTI-INPUT>					
									<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='IMAGENAME'></REQUIRED>
									<REQUIRED NAME='IMAGEALTTEXT'></REQUIRED>						
									</MULTI-INPUT>]]></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<input type="hidden" name="topicid" value="{TOPIC/TOPICID}"/>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input type="hidden" name="cmd" value="{$command}"/>
						<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="_msxml" value="{$fields}"/>
						<input type="hidden" name="_msfinish" value="yes"/>
						<xsl:if test="not(/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6)">
							<h3 class="adminFormHeader">Topic Promo Title</h3>
							<br/>
							<input name="title" size="50" class="inputBG">
								<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></xsl:attribute>
							</input>
							<br/>
							<input type="button" onclick="document.textandimage.title.value = &quot;{TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/TITLE}&quot;;" value="Use topic name" class="buttonThreeD" style="margin-left:0px"/>
							<br/>
							<br/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6">
								<h3 class="adminFormHeader">Topic Promo GuideML</h3>
								<br/>
							</xsl:when>
							<xsl:otherwise>
								<h3 class="adminFormHeader">Topic Promo Text</h3> (approx [x] words)<br/>
							</xsl:otherwise>
						</xsl:choose>
						<textarea name="text" cols="50" rows="5" class="inputBG">
							<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
						</textarea>
						<br/>
						<xsl:if test="not(/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6)">
							<div class="buttonThreeD" style="margin-left:0px">
								<a href="#" onclick="format('strong','openclose')">
									<strong>B</strong>
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
							<input type="button" onclick="document.textandimage.text.value = &quot;{TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/DESCRIPTION}&quot;;" value="Use topic description" class="buttonThreeD"/>
							<br/>
							<br/>
							<br/>
							<xsl:if test="not(/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5)">
								<h3 class="adminFormHeader">Image filename</h3>	 (dimensions - 
							<xsl:choose>
									<xsl:when test="$layout = 1">
										<xsl:choose>
											<xsl:when test="$topictemplate = 2">300 x 120</xsl:when>
											<xsl:otherwise>150 x 120</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$layout = 2">
										<xsl:choose>
											<xsl:when test="$topictemplate = 2">195 x 77</xsl:when>
											<xsl:otherwise>97 x 77</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$layout = 3">
										<xsl:choose>
											<xsl:when test="$topictemplate = 2">142 x 56</xsl:when>
											<xsl:otherwise>71 x 56</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
							)<br/>
								<em>This image should be published in your dev web space to ensure you can preview it here.</em>
								<input name="imagename" size="50" class="inputBG">
									<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/></xsl:attribute>
								</input>
								<br/>
								<br/>
								<h3 class="adminFormHeader">Image alt text</h3>
								<br/>
								<input name="imagealttext" size="50" class="inputBG">
									<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/></xsl:attribute>
								</input>
							</xsl:if>
						</xsl:if>
						<br/>
						<br/>
						<h3 class="adminFormHeader">Preview</h3>
						<div style="padding:5px; border:dashed #000000 1px; width: {$width}px">
							<xsl:if test="MULTI-STAGE/@CANCEL = 'YES'">
								<xsl:choose>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 1">
										<table width="100%">
											<tr>
												<td colspan="2">
													<h4>
														<xsl:value-of select="TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/TITLE"/>
													</h4>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
														<xsl:with-param name="imagename">
															<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/>
														</xsl:with-param>
														<xsl:with-param name="imagealttext">
															<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/>
														</xsl:with-param>
													</xsl:apply-templates>
												</td>
												<td valign="top">
													<p>
														<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2" align="right">
													<p># of posts</p>
												</td>
											</tr>
										</table>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 2">
										<h4>
											<xsl:value-of select="TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/TITLE"/>
										</h4>
										<p align="right"># of posts</p>
										<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
											<xsl:with-param name="imagename">
												<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/>
											</xsl:with-param>
											<xsl:with-param name="imagealttext">
												<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/>
											</xsl:with-param>
										</xsl:apply-templates>
										<p>
											<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 3">
										<h4>
											<xsl:value-of select="TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/TITLE"/>
										</h4>
										<p># of posts</p>
										<p>
											<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
												<xsl:with-param name="imagename">
													<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/>
												</xsl:with-param>
												<xsl:with-param name="imagealign">right</xsl:with-param>
												<xsl:with-param name="imagealttext">
													<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/>
												</xsl:with-param>
											</xsl:apply-templates>
											<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 4">
										<h4>
											<xsl:value-of select="TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/TITLE"/>
										</h4>
										<p>
											<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
												<xsl:with-param name="imagename">
													<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/>
												</xsl:with-param>
												<xsl:with-param name="imagealign">right</xsl:with-param>
												<xsl:with-param name="imagealttext">
													<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/>
												</xsl:with-param>
											</xsl:apply-templates>
											<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5">
										<h4>
											<xsl:value-of select="TOPICLIST/TOPIC[TOPICID = current()/TOPIC/TOPICID]/TITLE"/>
										</h4>
										<p># of posts</p>
										<p>
											<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6">
										<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
									</xsl:when>
								</xsl:choose>
							</xsl:if>
							<br clear="all"/>
						</div>
						<input type="submit" name="_mscancel" value="Preview promo" class="buttonThreeD" style="margin-left:280px;"/>
						<xsl:if test="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS">
							Parse Errors : 
							<br/>
							<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS/ERROR"/>
						</xsl:if>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input type="submit" value="Save promo &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="TOPICELEMENTPAGE" mode="edit_topicpromo">
	Author:		Andy Harris
	Context:    H2G2/TOPICELEMENTPAGE
	Purpose:	 Form for changing the topicpromo text.
	-->
	<xsl:template match="TOPICELEMENTPAGE" mode="edit_topicpromo">
		<form name="textandimage" method="post" action="{$root}frontpagetopicelementbuilder">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Topic Management / Edit Topic Promo for '<xsl:value-of select="TOPICLIST/TOPIC[TOPICID = current()/TOPICELEMENTLIST/TOPICELEMENT[@EDITSTATUS = 'ACTIVE']/TOPICID]/TITLE"/>'</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<xsl:variable name="command">edit</xsl:variable>
						<xsl:variable name="width">
							<xsl:choose>
								<xsl:when test="$layout = 1">310</xsl:when>
								<xsl:when test="$layout = 2">205</xsl:when>
								<xsl:when test="$layout = 3">152</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="fields">
							<xsl:choose>
								<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5"><![CDATA[<MULTI-INPUT>						
									<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='IMAGENAME'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='IMAGEALTTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									</MULTI-INPUT>]]></xsl:when>
								<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6"><![CDATA[<MULTI-INPUT>						
									<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									</MULTI-INPUT>]]></xsl:when>
								<xsl:otherwise><![CDATA[<MULTI-INPUT>					
									<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<REQUIRED NAME='IMAGENAME'></REQUIRED>
									<REQUIRED NAME='IMAGEALTTEXT'></REQUIRED>						
									</MULTI-INPUT>]]></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<input type="hidden" name="elementid" value="{TOPICELEMENTLIST/TOPICELEMENT[@EDITSTATUS='ACTIVE']/ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{TOPICELEMENTLIST/TOPICELEMENT[@EDITSTATUS='ACTIVE']/EDITKEY}"/>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input type="hidden" name="cmd" value="{$command}"/>
						<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="_msxml" value="{$fields}"/>
						<input type="hidden" name="_msfinish" value="yes"/>
						<xsl:if test="not(/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6)">
							<h3 class="adminFormHeader">Topic Promo Title</h3>
							<br/>
							<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/ERRORS"/>
							<input name="title" size="50" class="inputBG">
								<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></xsl:attribute>
							</input>
							<br/>
							<input type="button" onclick="document.textandimage.title.value = '{TOPICLIST/TOPIC[TOPICID = current()/TOPICELEMENTLIST/TOPICELEMENT[@EDITSTATUS = 'ACTIVE']/TOPICID]/TITLE}';" value="Use topic name" class="buttonThreeD" style="margin-left:0px"/>
							<br/>
							<br/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6">
								<h3 class="adminFormHeader">Topic Promo GuideML</h3>
								<br/>
							</xsl:when>
							<xsl:otherwise>
								<h3 class="adminFormHeader">Topic Promo Text</h3> (approx [x] words)<br/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS"/>
						<textarea name="text" cols="50" rows="5" class="inputBG">
							<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
						</textarea>
						<br/>
						<xsl:if test="not(/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6)">
							<div class="buttonThreeD" style="margin-left:0px">
								<a href="#" onclick="format('strong','openclose')">
									<strong>B</strong>
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
							<input type="button" onclick="document.textandimage.text.value = '{TOPICLIST/TOPIC[TOPICID = current()/TOPICELEMENTLIST/TOPICELEMENT[@EDITSTATUS = 'ACTIVE']/TOPICID]/DESCRIPTION}';" value="Use topic description" class="buttonThreeD"/>
							<br/>
							<br/>
							<xsl:if test="not(/H2G2/FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5)">
								<h3 class="adminFormHeader">Image filename</h3> (dimensions - 
								<xsl:choose>
									<xsl:when test="$layout = 1">
										<xsl:choose>
											<xsl:when test="$topictemplate = 2">300 x 120</xsl:when>
											<xsl:otherwise>150 x 120</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$layout = 2">
										<xsl:choose>
											<xsl:when test="$topictemplate = 2">195 x 77</xsl:when>
											<xsl:otherwise>97 x 77</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$layout = 3">
										<xsl:choose>
											<xsl:when test="$topictemplate = 2">142 x 56</xsl:when>
											<xsl:otherwise>71 x 56</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								</xsl:choose>
								)<br/>
								<em>This image should be published in your dev web space to ensure you can preview it here.</em>
								<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/ERRORS"/>
								<input name="imagename" size="50" class="inputBG">
									<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/></xsl:attribute>
								</input>
								<br/>
								<br/>
								<h3 class="adminFormHeader">Image alt text</h3>
								<br/>
								<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/ERRORS"/>
								<input name="imagealttext" size="50" class="inputBG">
									<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/></xsl:attribute>
								</input>
							</xsl:if>
						</xsl:if>
						<br/>
						<br/>
						<p class="subheader">Preview</p>
						<div style="padding:5px; border:dashed #000000 1px; width: {$width}px">
							<xsl:if test="MULTI-STAGE/@CANCEL = 'YES'">
								<xsl:choose>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 1">
										<table width="100%">
											<tr>
												<td colspan="2">
													<h4>
														<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TITLE"/>
													</h4>
												</td>
											</tr>
											<tr>
												<td valign="top">
													<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
														<xsl:with-param name="imagename">
															<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGENAME"/>
														</xsl:with-param>
														<xsl:with-param name="imagealttext">
															<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGEALTTEXT"/>
														</xsl:with-param>
													</xsl:apply-templates>
												</td>
												<td valign="top">
													<p>
														<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
													</p>
												</td>
											</tr>
											<tr>
												<td colspan="2" align="right">
													<p># of posts</p>
												</td>
											</tr>
										</table>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 2">
										<h4>
											<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TITLE"/>
										</h4>
										<p align="right"># of posts</p>
										<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
											<xsl:with-param name="imagename">
												<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGENAME"/>
											</xsl:with-param>
											<xsl:with-param name="imagealttext">
												<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGEALTTEXT"/>
											</xsl:with-param>
										</xsl:apply-templates>
										<p>
											<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 3">
										<h4>
											<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TITLE"/>
										</h4>
										<p># of posts</p>
										<p>
											<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
												<xsl:with-param name="imagename">
													<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGENAME"/>
												</xsl:with-param>
												<xsl:with-param name="imagealign">right</xsl:with-param>
												<xsl:with-param name="imagealttext">
													<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGEALTTEXT"/>
												</xsl:with-param>
											</xsl:apply-templates>
											<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 4">
										<h4>
											<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TITLE"/>
										</h4>
										<p>
											<xsl:apply-templates select="../FRONTPAGE/PAGE-LAYOUT" mode="choose_image">
												<xsl:with-param name="imagename">
													<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGENAME"/>
												</xsl:with-param>
												<xsl:with-param name="imagealign">right</xsl:with-param>
												<xsl:with-param name="imagealttext">
													<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/IMAGEALTTEXT"/>
												</xsl:with-param>
											</xsl:apply-templates>
											<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 5">
										<h4>
											<xsl:value-of select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TITLE"/>
										</h4>
										<p># of posts</p>
										<p>
											<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
										</p>
									</xsl:when>
									<xsl:when test="../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE = 6">
										<xsl:apply-templates select="/H2G2/TOPICELEMENTPAGE/TOPICELEMENT-PREVIEW/TOPICELEMENT/TEXT"/>
									</xsl:when>
								</xsl:choose>
							</xsl:if>
							<br clear="all"/>
						</div>
						<input type="submit" name="_mscancel" value="Preview promo" class="buttonThreeD" style="margin-left:280px;"/>
						<xsl:if test="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS">
							Parse Errors : 
							<br/>
							<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS/ERROR"/>
						</xsl:if>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt; &lt; Back</a>
							</div>
						</span>
						<input type="submit" value="Save promo &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
</xsl:stylesheet>
