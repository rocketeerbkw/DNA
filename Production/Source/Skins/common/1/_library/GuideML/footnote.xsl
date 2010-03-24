<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Coverts HR to horizontal rule
		</doc:purpose>
		<doc:context>
			Applied by _common/_library/GuideML.xsl
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="FOOTNOTE" mode="library_GuideML">
		<a href="#{@INDEX}"><span id="footnote-number"><xsl:value-of select="@INDEX"/></span></a>
	</xsl:template>
	
	<xsl:template match="FOOTNOTE" mode="library_footnotes">
		<li id="footnote-{@INDEX}">
			<span><xsl:value-of select="@INDEX"/>. </span>
			<xsl:apply-templates/>
		</li>
	</xsl:template>
	
	<xsl:template match="FOOTNOTE" mode="library_GuideML_rss">
		(<xsl:value-of select="@INDEX"/>: <xsl:apply-templates/>)
	</xsl:template>
	
</xsl:stylesheet>