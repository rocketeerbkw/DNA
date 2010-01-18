<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">


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
    
    <xsl:template match="/H2G2[@TYPE = 'BLOGSUMMARY']" mode="page">
       
            <xsl:variable name="recentComments">
                <xsl:apply-templates select="RECENTCOMMENTS" mode="object_recentcomments"/>  
            </xsl:variable>
        
            <xsl:variable name="beingDiscussedNow">
                <xsl:apply-templates select="COMMENTFORUMLIST" mode="object_commentforumlist" />
            </xsl:variable>
        
            <xsl:apply-templates select="BLOGSUMMARY/COMMENTFORUMLIST/COMMENTFORUM" mode="object_commentforum_blogsummary" />
    
            <xsl:call-template name="library_ssi_escaped">
                <xsl:with-param name="statement">
                    <xsl:text>#set var="dna.commentbox.recentComments" value='</xsl:text>
                    <xsl:copy-of select="$recentComments"/>
                    <xsl:text>'</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="library_ssi_escaped">
                <xsl:with-param name="statement">
                    <xsl:text>#set var="dna.commentbox.beingDiscussedNow" value='</xsl:text>
                    <xsl:copy-of select="$beingDiscussedNow"/>
                    <xsl:text>'</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>