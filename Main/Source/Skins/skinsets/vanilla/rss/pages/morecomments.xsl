<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
          
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
          
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="page">
        <xsl:apply-templates select="/H2G2/MORECOMMENTS/COMMENTS-LIST" />
    </xsl:template>
    
    <xsl:template match="COMMENTS-LIST">
        <title>
            <xsl:text>Comments made by </xsl:text>
            <xsl:value-of select="USER/USERNAME"/>
        </title>
        <link>
            <xsl:text>http://www.bbc.co.uk/blogs/service/user/</xsl:text>
            <xsl:value-of select="@USERID"/>
        </link>
        <language>en-gb</language>
        <ttl>30</ttl>
        <pubDate><xsl:apply-templates select="/H2G2/DATE" mode="utils" /></pubDate>
        <description>A list of recent comments by <xsl:value-of select="USER/USERNAME"/></description>
        
        <xsl:apply-templates select="COMMENTS/COMMENT" />
    </xsl:template>
    
    <xsl:template match="COMMENT">
        <item>
            <title><xsl:value-of select="SUBJECT"/></title>
            <link>
                <xsl:value-of select="URL"/>
            </link>
            <description><xsl:value-of select="TEXT"/></description>
            <pubDate><xsl:apply-templates select="DATEPOSTED/DATE" mode="utils" /></pubDate>
        </item>
    </xsl:template>
    

</xsl:stylesheet>