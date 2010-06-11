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
      
      <xsl:apply-templates select="FORUMSOURCE/ARTICLE" mode="object_article_generic" />
      <xsl:apply-templates select="FORUMTHREADS" mode="object_forumthreads" />
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'THREADS']" mode="breadcrumbs">
        <li>
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li class="current">
            <a href="{$root}/NF{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
              <xsl:choose>
                <xsl:when test="FORUMSOURCE/ARTICLE/SUBJECT = ''">
                  <xsl:text>no subject</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" />
                </xsl:otherwise>
              </xsl:choose>
            </a>
        </li>
    </xsl:template>

</xsl:stylesheet>