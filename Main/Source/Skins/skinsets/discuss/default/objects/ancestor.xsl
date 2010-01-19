<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article link on the categories page
        </doc:purpose>
        <doc:context>
            Applied in objects/collections/members.xsl
        </doc:context>
        <doc:notes>
            <!-- 
                <xsl:if test="not(position() = last())">
                <xsl:text> / </xsl:text>
                </xsl:if>
                
                  -->
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="ANCESTOR" mode="object_ancestor">
        
        <li>
            <a href="C{NODEID}">
                <xsl:choose>
                    <xsl:when test="TREELEVEL = 0">
                        <xsl:text>Categories</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="NAME"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </a>
            <xsl:text> / </xsl:text>
        </li>
        
    </xsl:template>
</xsl:stylesheet>