<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            String search and replace
        </doc:purpose>
        <doc:context>
            Skin wide
        </doc:context>
        <doc:notes>
            To use simply select the text and apply e.g.
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_string_searchandreplace">
        
        <xsl:param name="str" />
        <xsl:param name="search" />
        <xsl:param name="replace" />
        
        <xsl:choose>
            <xsl:when test="contains($str, $search)">
                
                <xsl:value-of select="substring-before($str, $search)"/>
                
                <xsl:value-of select="$replace"/>
                
                <xsl:call-template name="library_string_searchandreplace">
                    <xsl:with-param name="str" select="substring-after($str, $search)" />
                    <xsl:with-param name="search" select="$search"/>
                    <xsl:with-param name="replace" select="$replace"/>
                </xsl:call-template>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>