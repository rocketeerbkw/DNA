<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for an article page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This defines the article page layout, not to be confused with the article object...
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTBOX']" mode="page">        
        
        <xsl:apply-templates select="." mode="object_error"/>
        <xsl:text>,</xsl:text>
        <!-- Add the comments-->
        <xsl:apply-templates select="COMMENTBOX/FORUMTHREADPOSTS" mode="object_forumthreadposts" />
        
            
    </xsl:template>
    
    
</xsl:stylesheet>