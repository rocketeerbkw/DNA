<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a commentbox page (as used in the acs feature)
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This particluar page also packages various lists in ssi vars, for use
            during output.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTBOX']" mode="page">
        <xsl:apply-templates select="/H2G2/COMMENTBOX/FORUMTHREADPOSTS" />
    </xsl:template>
    
    
    <xsl:template match="FORUMTHREADPOSTS">
        <title>Comments for <xsl:value-of select="@HOSTPAGEURL"/></title>
        <link><xsl:value-of select="@HOSTPAGEURL"/></link>
        <language>en-gb</language>
        <ttl>30</ttl>
        <pubDate><xsl:apply-templates select="/H2G2/DATE" mode="utils" /></pubDate>
        <description>A feed of user comments from the page found at <xsl:value-of select="@HOSTPAGEURL"/></description>
        
        <xsl:apply-templates select="POST" />
    </xsl:template>
    
    <xsl:template match="POST">
        <item>
            <title><xsl:value-of select="USER/USERNAME"/></title>
            <link>
                <xsl:value-of select="ancestor::FORUMTHREADPOSTS/@HOSTPAGEURL"/>
                <xsl:text>?page=</xsl:text>
                <xsl:apply-templates select="." mode="pageNumber" />
                <xsl:text>#comment</xsl:text>
                <xsl:value-of select="@INDEX"/>
            </link>
            <description><xsl:value-of select="TEXT"/></description>
            <pubDate><xsl:apply-templates select="DATEPOSTED/DATE" mode="utils" /></pubDate>
        </item>
    </xsl:template>
    
    <xsl:template match="POST" mode="pageNumber">
        
        <xsl:variable name="totalAmount" select="ancestor::*/@FORUMPOSTCOUNT" />
        <xsl:variable name="amountPerPage" select="ancestor::*/@SHOW" />
        <xsl:variable name="something" select="$totalAmount div $amountPerPage" />
        
        <xsl:value-of select="floor(@INDEX div $something)"/>
        
    </xsl:template>
    
</xsl:stylesheet>