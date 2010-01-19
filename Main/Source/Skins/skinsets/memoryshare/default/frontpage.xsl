<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
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
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">FRONTPAGE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">frontpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<div id="topPage">
			<p>
				You are being re-directed to the 'View memories' page.
			</p>
			<p>
				<a href="{$articlesearchroot}">Click here</a> if nothing happens after a few seconds.
			</p>
		</div>
		<div class="tear"><hr/></div>
	</xsl:template>
	
	<xsl:template name="FRONTPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_frontpagetitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
		
		<!-- meta-refresh to 'view memories' page -->
		<meta http-equiv="refresh" content="0;url={$articlesearchroot}"/>
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
	<!--
	<xsl:template match="EDITORIAL-ITEM">
	Use: Currently used as a frontpage XML tag on many existing sites
	 -->
	<xsl:template match="EDITORIAL-ITEM">
		<xsl:if test="(not(@TYPE)) or (@TYPE='REGISTERED' and $fpregistered=1) or (@TYPE='UNREGISTERED' and $fpregistered=0)">
			<xsl:value-of select="SUBJECT"/>
			<br/>
			<xsl:apply-templates select="BODY"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
