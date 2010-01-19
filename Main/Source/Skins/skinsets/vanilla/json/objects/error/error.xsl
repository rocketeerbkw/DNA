<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a full DNA article
        </doc:purpose>
        <doc:context>
            Applied by logic layer (common/logic/objects/article.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="H2G2" mode="object_error">
        <xsl:text>'error': </xsl:text>
        <xsl:text>{</xsl:text>
        <xsl:if test="ERROR">
            <xsl:text>errorType: "</xsl:text><xsl:value-of select="ERROR/@TYPE"/><xsl:text>", </xsl:text>
            <xsl:text>errorMessage: "</xsl:text>
            <xsl:value-of select="ERROR/ERRORMESSAGE"/>
            <xsl:text>"</xsl:text>
        </xsl:if>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>