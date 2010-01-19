<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="FRONTPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="FRONTPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_frontpagetitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVES" mode="c_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/TOP-FIVES
	Purpose:	 Calls the container for the TOP-FIVES object
	-->
	<xsl:template match="TOP-FIVES" mode="c_frontpage">
		<xsl:apply-templates select="." mode="r_frontpage"/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE" mode="c_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/TOP-FIVES/TOP-FIVE
	Purpose:	 Calls the container for the TOP-FIVE object
	-->
	<xsl:template match="TOP-FIVE" mode="c_frontpage">
		<xsl:apply-templates select="." mode="r_frontpage"/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-ARTICLE | TOP-FIVE-FORUM" mode="c_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/TOP-FIVES/TOP-FIVE/TOP-FIVE-ARTICLE | /H2G2/TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM
	Purpose:	 Calls the container for the TOP-FIVE-ARTICLE or TOP-FIVE-FORUM object
	-->
	<xsl:template match="TOP-FIVE-ARTICLE | TOP-FIVE-FORUM" mode="c_frontpage">
		<xsl:apply-templates select="." mode="r_frontpage"/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/TOP-FIVES/TOP-FIVE/TOP-FIVE-ARTICLE
	Purpose:	 Creates the link for the TOP-FIVE-ARTICLE object
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mTOP-FIVE-ARTICLE">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM
	Purpose:	 Creates the link for the TOP-FIVE-FORUM object
	-->
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
		<a href="{$root}F{FORUMID}" xsl:use-attribute-sets="mTOP-FIVE-FORUM">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE
	Purpose:	 Calls the container for the front page ARTICLE
	-->
	<xsl:template match="ARTICLE" mode="c_frontpage">
		<xsl:apply-templates select="." mode="r_frontpage"/>
	</xsl:template>
</xsl:stylesheet>
