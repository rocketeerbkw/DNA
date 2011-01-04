<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Coverts FOOTNOTE to a html footnote 
		</doc:purpose>
		<doc:context>
			Applied by _common/_library/GuideML.xsl
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>

	<xsl:attribute-set name="textfont">
		<xsl:attribute name="face">Trebuchet MS, arial, helvetica, sans-serif</xsl:attribute>
		<xsl:attribute name="size">2</xsl:attribute>
		<xsl:attribute name="color">#ffffff</xsl:attribute>
		<xsl:attribute name="class">postxt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="face">arial,helvetica,sans-serif</xsl:attribute>
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="FOOTNOTE | footnote" mode="library_GuideML">
		<a>
			<xsl:attribute name="class">footnote</xsl:attribute>
			<xsl:attribute name="title"><xsl:call-template name="renderfootnotetext"/></xsl:attribute>
			<xsl:attribute name="name">back<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:attribute name="href">#footnote<xsl:value-of select="@INDEX"/></xsl:attribute>
			<xsl:apply-templates select="@INDEX" mode="Footnote"/>
		</a>
		<xsl:apply-templates mode="library_GuideML"/>
	</xsl:template>
	
	<xsl:template match="@INDEX" mode="Footnote">
		<font xsl:use-attribute-sets="mainfont">
			<sup>
				<xsl:value-of select="."/>
			</sup>
		</font>
	</xsl:template>

	<xsl:template name="renderfootnotetext">
		<xsl:for-each select="*|text()">
			<xsl:choose>
				<xsl:when test="self::text()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:when test="name()!=string('FOOTNOTE')">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="renderfootnotetext"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="FOOTNOTE | footnote" mode="library_footnotes">
		<span>		
			<a><xsl:attribute name="class">footnotebottom</xsl:attribute>
				<xsl:attribute name="title"><xsl:call-template name="renderfootnotetext"/></xsl:attribute>
				<xsl:attribute name="name">footnote<xsl:value-of select="@INDEX"/></xsl:attribute>
				<xsl:attribute name="href">#back<xsl:value-of select="@INDEX"/></xsl:attribute>
				<xsl:apply-templates select="@INDEX" mode="Footnote"/>
			</a>
			<xsl:apply-templates mode="library_GuideML"/>
		</span>
	</xsl:template>
	
	<xsl:template match="FOOTNOTE | footnote" mode="library_GuideML_rss">
		(<xsl:value-of select="@INDEX"/>: <xsl:apply-templates/>)
	</xsl:template>
	
</xsl:stylesheet>