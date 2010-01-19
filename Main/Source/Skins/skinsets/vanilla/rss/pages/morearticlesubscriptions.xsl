<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            RSS for More Article Subscriptions
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
          
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'MOREARTICLESUBSCRIPTIONS']" mode="page">
        <xsl:apply-templates select="/H2G2/MOREARTICLESUBSCRIPTIONS/ARTICLESUBSCRIPTIONLIST" />
    </xsl:template>
    
    <xsl:template match="ARTICLESUBSCRIPTIONLIST">
      <title>
        <xsl:text>User Bookmarks by </xsl:text>
        <xsl:value-of select="/H2G2/MOREARTICLESUBSCRIPTIONS/@USERID"/>
      </title>
      <link>
        <xsl:text>http://www.bbc.co.uk/dna/h2g2/</xsl:text>
        <xsl:value-of select="/H2G2/SITE/NAME"/>/U<xsl:value-of select="/H2G2/MOREARTICLESUBSCRIPTIONS/@USERID"/>
      </link>
      <language>en-gb</language>
      <ttl>30</ttl>
      <pubDate>
        <xsl:apply-templates select="/H2G2/DATE" mode="formatted" />
      </pubDate>
      <description>
        A list of article bookmarks by <xsl:value-of select="@USERID"/>
      </description>
        
        <xsl:apply-templates select="ARTICLES/ARTICLE" />
    </xsl:template>
    
    <xsl:template match="ARTICLE">
        <item>
            <title><xsl:value-of select="SUBJECT"/></title>
            <link>
              <xsl:text>http://www.bbc.co.uk/dna/</xsl:text>
              <xsl:value-of select="/H2G2/SITE/NAME"/>/A<xsl:value-of select="@H2G2ID"/>
            </link>
            <description><xsl:value-of select="SUBJECT"/></description>
            <pubDate><xsl:apply-templates select="DATECREATED/DATE" mode="utils" /></pubDate>
        </item>
    </xsl:template>
    

</xsl:stylesheet>