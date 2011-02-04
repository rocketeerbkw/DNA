<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <xsl:template match="ARTICLE" mode="library_activitydata" >

		<a href="/dna/h2g2/A{@H2G2ID}" target="_blank">
			<xsl:value-of select="text()"/>
		</a>

    </xsl:template>
    
</xsl:stylesheet>