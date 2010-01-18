<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article link on the categories page
        </doc:purpose>
        <doc:context>
            Applied in objects/collections/members.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="SUBJECTMEMBER" mode="object_member">
        
        <li>
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames" select="'category'" />
            </xsl:call-template>
            
            <a href="C{NODEID}" class="subject">
                <xsl:value-of select="STRIPPEDNAME"/>
                
                <!-- Article count information -->
                <span class="">
                    <xsl:choose>
                        <xsl:when test="ARTICLECOUNT > 1">
                            <xsl:value-of select="ARTICLECOUNT"/> articles
                        </xsl:when>
                        <xsl:when test="ARTICLECOUNT = 1">
                            1 article
                        </xsl:when>
                        <xsl:otherwise>
                            No articles yet
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </a>
        </li>
        
    </xsl:template>
</xsl:stylesheet>