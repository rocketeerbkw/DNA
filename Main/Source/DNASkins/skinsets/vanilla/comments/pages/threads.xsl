<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


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
    
    <xsl:template match="/H2G2[@TYPE = 'THREADS']" mode="page">        
        
        <div class="conversations ">
            <xsl:call-template name="library_header_h3">
                <xsl:with-param name="text">Conversations</xsl:with-param>
            </xsl:call-template>
                        
            <!-- Add the forum-->
            <xsl:apply-templates select="FORUMTHREADS" mode="object_forumthreads" />
        </div>
        
    </xsl:template>
    

</xsl:stylesheet>