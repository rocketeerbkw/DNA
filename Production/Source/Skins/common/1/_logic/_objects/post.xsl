<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:properties common="true" />
        <doc:purpose>
            Logic layer for the Post object
        </doc:purpose>
        <doc:context>
            Usually called by any site specific page layout
        </doc:context>
        <doc:notes>
            Define any common logic that may be used when making the
            HTML for a single Post object
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST" mode="object_post">
        <xsl:choose>
            <xsl:when test="not(@INREPLYTO)">
                
                <xsl:apply-templates select="." mode="object_post_first" />
                
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:apply-templates select="." mode="object_post_generic" />
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>