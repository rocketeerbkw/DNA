<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts BR nodes to HTML line breaks
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            Could be improved further to not create double BR elements in a row
            e.g self::*/preceding-sibling::* something something
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_serialise_ptrt_in">
        <xsl:param name="string" />
        
        <xsl:if test="not(contains($string, '@'))">
            
            <xsl:value-of select="translate($string, '?', '@')" />
        </xsl:if>        
    </xsl:template>
    
    <xsl:template name="library_serialise_ptrt_out">
        <xsl:param name="string" />
        
        <xsl:value-of select="translate($string, '@', '?')" />
    </xsl:template>
</xsl:stylesheet>