<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a post
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="TOP-FIVE-ARTICLE" mode="object_top-fives_top-five-article">
        
        <li>
            <xsl:if test="position() > 5">
                <xsl:attribute name="class">
                    <xsl:text>blocked</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <p>
                <a href="/dna/h2g2/A{H2G2ID}">
                    <xsl:choose>
                        <xsl:when test="SUBJECT/text()">
                            <xsl:value-of select="SUBJECT"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>(no subject)</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </p>
        </li>
        
    </xsl:template>
</xsl:stylesheet>
