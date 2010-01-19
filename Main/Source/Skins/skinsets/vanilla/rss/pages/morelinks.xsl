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
    
    <xsl:template match="/H2G2[@TYPE = 'MORELINKS']" mode="page">
        
        <xsl:apply-templates select="/H2G2/MORELINKS/LINKS-LIST" />
        
    </xsl:template>
    
    
    <xsl:template match="LINKS-LIST">
        <title>
            <xsl:text>Links for </xsl:text>
            <xsl:value-of select="USER/USERNAME"/>
        </title>
        <link>
          <xsl:text>http://www.bbc.co.uk/dna/</xsl:text>
          <xsl:value-of select="/H2G2/SITE/NAME"/>/ML<xsl:value-of select="/H2G2/MOREARTICLESUBSCRIPTIONS/@USERID"/>
        </link>
        <language>en-gb</language>
        <ttl>30</ttl>
        <pubDate><xsl:apply-templates select="/H2G2/DATE" mode="utils" /></pubDate>
        <description>A list of bookmarks by <xsl:value-of select="USER/USERNAME"/></description>
        
        <xsl:apply-templates select="LINK" />
    </xsl:template>
    
    <xsl:template match="LINK">
        <item>
            <title><xsl:value-of select="DESCRIPTION"/></title>
            <link>
              <xsl:if test="@TYPE='article'">
                <xsl:text>http://www.bbc.co.uk/dna/</xsl:text>
                <xsl:value-of select="/H2G2/SITE/NAME"/>/<xsl:value-of select="@DNAUID"/>
              </xsl:if>
             </link>
            <description><xsl:value-of select="DESCRIPTION"/></description>
            <pubDate><xsl:apply-templates select="DATELINKED/DATE" mode="utils" /></pubDate>
        </item>
    </xsl:template>
    

</xsl:stylesheet>