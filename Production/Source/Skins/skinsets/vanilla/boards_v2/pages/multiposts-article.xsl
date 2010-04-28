<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY raquo "&#187;">
]>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML Layout for pages of type 'multipost'
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Output from here ends up between the document body tag 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'article']]" mode="page">        
            
        <xsl:apply-templates select="FORUMSOURCE/ARTICLE" mode="object_article_title" />
            
            <!-- Insert posts-->
            <xsl:apply-templates select="FORUMTHREADPOSTS" mode="object_forumthreadposts"/>

    </xsl:template>
    
    
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'article']]" mode="breadcrumbs">
        <li>
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li>
            <a href="{$root}/NF{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
                <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" />
            </a>
        </li>
        <li class="current">
            <a href="{$root}/NF{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}?thread={FORUMTHREADPOSTS/@THREADID}">
                <xsl:choose>
                <xsl:when test="FORUMTHREADPOSTS/FIRSTPOSTSUBJECT = ''">
                  <xsl:text>no subject</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="FORUMTHREADPOSTS/FIRSTPOSTSUBJECT" />
                </xsl:otherwise>
              </xsl:choose>
            </a>
        </li>
    </xsl:template>
    
    
    <!--
        Providing the same xpath and a mode of 'head_additional' allows the skin developer to add extra
        HTML elements to the head, on a page by page basis.
    -->
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'article']]" mode="head_additional">
        <script type="text/javascript" src="/hello.js"></script>
    </xsl:template> 
    
    
</xsl:stylesheet>
