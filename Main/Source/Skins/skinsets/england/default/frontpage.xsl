<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-frontpage.xsl"/>
	<!--

	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="FRONTPAGE_MAINBODY">
		<meta http-equiv="refresh" content="0;url={$root}TSP"/>
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE = 'FRONTPAGE-EDITOR'">
				<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
					<div id="subNavText">
						<h1>Content Management - Create Homepage</h1>
					</div>
				</div>
				<br/>
				<div id="contentArea">
					<div class="centralAreaRight">
						<div class="header">
							<img src="{$adminimagesource}t_l.gif" alt=""/>
						</div>
						<div class="centralArea">
							<h3 class="adminFormHeader">Create Homepage - Code your own in GuideML</h3>
							<br/>
							<br/>
							You can code the messageboard homepage in GuideML.  This allows you to tailor the layout exactly to your<br /> needs, but will limit some of the options we provide through the templates.<br/>
							<br/>
							In addition to the ususal HTML tags, there is one messageboard specific GuideML tag that can be used:
							<ul>
								<li class="adminText">&lt;TOPICLINK NAME="topic name"&gt;link text&lt;/TOPICLINK&gt; - this create a normal hyperlink to the topic specified in the NAME attribute</li>
							</ul>
							<br/>
							Also, the following articles from h2g2 could be helpful
							<ul>
								<li class="adminText">
									<a href="http://www.bbc.co.uk/dna/h2g2/alabaster/A264520" style="color:#333333;">Using Approved GuideML in the Edited Guide</a>
								</li>
								<li class="adminText">
									<a href="http://www.bbc.co.uk/dna/h2g2/alabaster/GuideML-Clinic" style="color:#333333;">The GuideML Clinic</a>
								</li>
							</ul>
							<br/>
							<br/>
							<xsl:apply-templates select="FRONTPAGE-EDIT-FORM"/>
						</div>
						<div class="footer">
							<br/>
							<img src="{$adminimagesource}b_l.gif" alt=""/>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length(/H2G2/SITECONFIG/LINKPATH) = 0 or /H2G2/SITECONFIG/LINKPATH = 1">
					<div id="crumbtrail">
						<h5>
							You are here &gt; <a href="{$homepage}">
								<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> messageboard</a>
						</h5>
					</div>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT and not(/H2G2/ARTICLE/FRONTPAGE/PAGE-LAYOUT/LAYOUT = 4)">
						<xsl:apply-templates select="ARTICLE/FRONTPAGE/PAGE-LAYOUT" mode="layout_selection"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_frontpage">
	Use: Apply's templates to the root of the editorially-generated content area (GuideML)
	 -->
	<xsl:template match="ARTICLE" mode="r_frontpage">
		<xsl:apply-templates select="FRONTPAGE"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							TOP-FIVES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="TOP-FIVES" mode="r_frontpage">
	Use: Logical container for area containing the top fives.
	 -->
	<xsl:template match="TOP-FIVES" mode="r_frontpage">
		<xsl:apply-templates select="TOP-FIVE" mode="c_frontpage"/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
	Use: Presentation of one individual top five
	 -->
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
		<b>
			<xsl:value-of select="TITLE"/>
		</b>
		<br/>
		<xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt;=5]|TOP-FIVE-FORUM[position() &lt;=5]" mode="c_frontpage"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
	Use: Presentation of one article link within a top five
	 -->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
	Use: Presentation of one forum link within a top five
	 -->
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					Frontpage only GuideML tags
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	<!-- **********************************************************-->
	<!-- *********************GuideML Frontpage************************-->
	<!-- **********************************************************-->
	<xsl:template name="FRONTPAGE_EDITOR">
		<!--<xsl:apply-templates select="FRONTPAGE-EDIT-FORM"/>
		<xsl:apply-templates select="FRONTPAGE-PREVIEW-PARSEERROR"/>-->
	</xsl:template>
	<xsl:template match="FRONTPAGE-PREVIEW-PARSEERROR">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="FRONTPAGE-EDIT-FORM">
		<xsl:apply-templates select="/H2G2/FRONTPAGE-PREVIEW-PARSEERROR"/>
		<form method="post" action="EditFrontpage">
			<input type="hidden" name="_previewmode" value="1"/>
			<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
			<textarea cols="70" rows="20" wrap="virtual" name="bodytext" class="inputBG">
				<xsl:value-of select="BODY"/>
			</textarea>
			<br/>
			<br/>
			<!--Skin: <input type="text" name="skin" value="{SKIN}"/>
			Date Active: <input type="text" name="date" value="{DATE}"/>
			<input type="checkbox" name="registered" value="1">
				<xsl:if test="REGISTERED=1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input> Registered-->
			<input type="submit" name="preview" value="Quick Preview" class="buttonThreeD" style="margin-left:430px;"/>
			<br/>
			<br/>
			<div class="preview" style="border: 1px dashed #000000; padding: 5px; width: 645px;">
				<xsl:if test="string-length(/H2G2/SITECONFIG/LINKPATH) = 0 or /H2G2/SITECONFIG/LINKPATH = 1">
					<div id="crumbtrail">
						<h5>
							You are here &gt; <a href="{$homepage}">
								<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> messageboard</a>
						</h5>
					</div>
				</xsl:if>
				<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/node()"/>
			</div>
			<br/>
			<br/>
			<div class="shadedDivider" style="width:700px;">
				<hr/>
			</div>
			<br/>
			<input type="submit" name="storepage" value="Exit homepage creation &gt; &gt;" class="buttonThreeD" id="buttonRightInput"/>
		</form>
	</xsl:template>
	<xsl:template match="FRONTPAGE-PREVIEW-PARSEERROR">
	 	<div style="margin:5px; padding:5px;">
	 		<p style="font-weight: bold;">There is an error in your GuideML:</p>
	 		<p><xsl:apply-templates/></p>
	 	</div>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ANDYS CODE
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--<xsl:template match="TOPICS" mode="frontpage">
		<table width="635" cellpadding="5" cellspacing="5" border="0">
			<xsl:apply-templates select="TOPIC[position() mod 2 = 1]" mode="twocols"/>
		</table>
	</xsl:template>
	<xsl:template match="TOPIC" mode="twocols">
		<tr>
			<xsl:apply-templates select="." mode="frontpage"/>
			<xsl:apply-templates select="following-sibling::TOPIC[1]" mode="frontpage"/>
		</tr>
	</xsl:template>
	<xsl:template match="TOPIC" mode="frontpage">
		<td width="50%" valign="top">
			<a href="{$root}{LINK}">
				<img src="{IMAGE}" width="{IMAGE/@WIDTH}" height="{IMAGE/@HEIGHT}" alt="{TITLE}" border="0" align="left"/>
			</a>
			<a href="{$root}{LINK}">
				<xsl:value-of select="TITLE"/>
			</a>
			<br/>
			<font size="2">
				<xsl:apply-templates select="TEASER"/>
			</font>
		</td>
		<xsl:if test="(not(following-sibling::TOPIC)) and ((count(preceding-sibling::TOPIC)) mod 2 = 0)">
			<td width="50%">&nbsp;</td>
		</xsl:if>
	</xsl:template>-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ANDY'S CODE
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					TOM'S CODE
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="EDITORIAL-ITEM">
	Use: Currently used as a frontpage XML tag on many existing sites
	 -->
	<!--xsl:template match="EDITORIAL-ITEM">
		<xsl:if test="(not(@TYPE)) or (@TYPE='REGISTERED' and $fpregistered=1) or (@TYPE='UNREGISTERED' and $fpregistered=0)">
			<xsl:value-of select="SUBJECT"/>
			<br/>
			<xsl:apply-templates select="BODY"/>
		</xsl:if>
	</xsl:template-->
	<!--<xsl:template match="FORUM" mode="columns">
		<tr>
			<xsl:apply-templates select="."/>
			<xsl:apply-templates select="following-sibling::FORUM[1]"/>
			<xsl:apply-templates select="following-sibling::FORUM[2]"/>
		</tr>
	</xsl:template>
	<xsl:template match="FORUM">
		<xsl:param name="pos" select="count(preceding-sibling::FORUM) + 1"/>
		<xsl:param name="class">
			<xsl:choose>
				<xsl:when test="$pos = 1">hp_box1_btm</xsl:when>
				<xsl:when test="$pos = 2">hp_box2_btm</xsl:when>
				<xsl:when test="$pos = 3">hp_box1_nb_btm</xsl:when>
				<xsl:when test="$pos = 4">hp_box2_btm</xsl:when>
				<xsl:when test="$pos = 5">hp_box1_btm</xsl:when>
				<xsl:when test="$pos = 6">hp_box2_nb_btm</xsl:when>
			</xsl:choose>
		</xsl:param>-->
		<!--xsl:param name="classbot">
			<xsl:choose>
				<xsl:when test="$pos = 1">hp_box1_btm</xsl:when>
				<xsl:when test="$pos = 2">hp_box2_btm</xsl:when>
				<xsl:when test="$pos = 3">hp_box1_nb_btm</xsl:when>
				<xsl:when test="$pos = 4">hp_box2_btm</xsl:when>
				<xsl:when test="$pos = 5">hp_box1_btm</xsl:when>
				<xsl:when test="$pos = 6">hp_box2_nb_btm</xsl:when>
			</xsl:choose>
		</xsl:param-->
		<!--<td class="{$class}" width="215" valign="top">
			<xsl:apply-templates select="PICTURE" mode="boards"/>
			<xsl:apply-templates select="SUBJECT" mode="fp"/>
			<font size="2">
				<xsl:apply-templates select="BODY"/>
			</font>
		</td>
	</xsl:template>
	<xsl:template match="PICTURE" mode="boards">
		<xsl:choose>
			<xsl:when test="@DNAID">
				<a href="{@DNAID}">
					<img src="{$imagesource}hp/{@NAME}" width="{@WIDTH}" height="{@HEIGHT}" alt="{@ALT}" border="0" class="hp_image"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$imagesource}hp/{@NAME}" width="{@WIDTH}" height="{@HEIGHT}" alt="{@ALT}" border="0" class="hp_image"/>
			</xsl:otherwise>
		</xsl:choose>
		<br/>
	</xsl:template>
	<xsl:template match="SUBJECT" mode="fp">
		<font size="3" class="hp_title">
			<a href="{@DNAID}">
				<xsl:value-of select="."/>
			</a>
		</font>
		<br/>
	</xsl:template>-->
</xsl:stylesheet>
