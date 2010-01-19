<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Logic layer for moderation status.
        </doc:purpose>
        <doc:context>
            Called when wanting to make an output based on moderation status
        </doc:context>
        <doc:notes>
            The moderation status can mean different things in different contexts. For instance, status
            number 1 associated with USER may mean something else from POST.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2/SITE/MODERATIONSTATUS" mode="library_moderation_moderationstatus">
        <xsl:param name="unmod" />
        <xsl:param name="premod" />
        <xsl:param name="postmod" />
        
        <xsl:choose>
            <xsl:when test=". = 0">
                <xsl:copy-of select="$unmod"/>
            </xsl:when>
            <xsl:when test=". = 1">
                <!-- site moderation status is post-mod-->
                <xsl:copy-of select="$postmod"/>
            </xsl:when>
            <xsl:when test=". = 2">
                <!-- site moderation status is pre-mod-->
                <xsl:copy-of select="$premod"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template match="FORUMTHREADPOSTS/@MODERATIONSTATUS" mode="library_moderation_moderationstatus">
        <xsl:param name="unmod" />
        <xsl:param name="postmod" />
        <xsl:param name="premod" />
        
        <xsl:choose>
            <xsl:when test=". = 0">
                <!-- moderation status is undefined by the forum-->
                <xsl:apply-templates select="/H2G2/SITE/MODERATIONSTATUS" mode="library_moderation_moderationstatus">
                    <xsl:with-param name="unmod" select="$unmod"/>
                    <xsl:with-param name="postmod" select="$postmod"/>
                    <xsl:with-param name="premod" select="$premod"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test=". = 1">
                <xsl:copy-of select="$unmod"/>
            </xsl:when>
            <xsl:when test=". = 2">
                <xsl:copy-of select="$postmod"/>
            </xsl:when>
            <xsl:when test=". = 3">
                <xsl:copy-of select="$premod"/>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>