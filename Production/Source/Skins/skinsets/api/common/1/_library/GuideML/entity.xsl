<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts ENTITY nodes to HTML entities
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
        </doc:notes>
    </doc:documentation>
    
	<xsl:template match="ENTITY" mode="library_GuideML">
		<xsl:text disable-output-escaping="yes">&amp;</xsl:text>
		<xsl:value-of select="@TYPE|@type"/>;</xsl:template>    
		
</xsl:stylesheet>