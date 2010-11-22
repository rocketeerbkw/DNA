<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

	<doc:documentation>
		<doc:properties common="true" />
		<doc:purpose>
			Library function for user entered text blocks within posts
		</doc:purpose>
		<doc:context>
			Called using:
			xsl:apply-templates select="H2G2POST" mode="library_Post"
		</doc:context>
		<doc:notes>
			Currently matches links and smileys
		</doc:notes>
	</doc:documentation>

	<xsl:template match="H2G2POST" mode="library_Post" >
		<xsl:apply-templates select="* | text()" mode="library_Post" />
	</xsl:template>
</xsl:stylesheet>