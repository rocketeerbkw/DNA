<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for the Thread object.
        </doc:purpose>
        <doc:context>
            Currently applied by objects/collections/forumthreads.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="THREAD" mode="object_thread">
        
        <li>
            <xsl:call-template name="library_listitem_stripe"/>
            <a href="{$root}/F{@FORUMID}?thread={@THREADID}">
                <xsl:apply-templates select="LASTPOST/DATE | LASTUSERPOST/DATEPOSTED/DATE" mode="library_date_longformat"/>
                
                <xsl:choose>
                    <xsl:when test="SUBJECT/text()">
                        <xsl:value-of select="SUBJECT"/> 
                    </xsl:when>
                    <xsl:otherwise>
                        (no subject)
                    </xsl:otherwise>
                </xsl:choose>
                
            </a>
            
        </li>
        
    </xsl:template>
</xsl:stylesheet>