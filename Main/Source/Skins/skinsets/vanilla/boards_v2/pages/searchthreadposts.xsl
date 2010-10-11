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
    
    
    <xsl:template match="/H2G2[@TYPE = 'SEARCHTHREADPOSTS']" mode="page">

      <div class="threads" id="blq-content" role="main">
       
      
      <h2>Search <xsl:value-of select="/H2G2/SITE/DESCRIPTION"/></h2>
        <div style="padding-bottom: 10px">
        <form action="searchposts" method="get">
        Search <input id="searchtext" name="searchtext">
          <xsl:attribute name="value">
            <xsl:value-of select="/H2G2/SEARCHTHREADPOSTS/@SEARCHTERM"/>
          </xsl:attribute>
        </input>
        <input type="submit" value="Go"></input>
        
      </form>
        </div>
        <xsl:apply-templates select="/H2G2/ERROR" mode="object_error" />
            <!-- Insert posts-->
            <xsl:apply-templates select="SEARCHTHREADPOSTS" mode="object_forumthreadposts"/>
      </div>
    </xsl:template>

  <xsl:template match="/H2G2[@TYPE = 'SEARCHTHREADPOSTS']" mode="breadcrumbs">
    <li class="current">
      <a href="{$root}">
        <xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/>
      </a>
    </li>
  </xsl:template>


</xsl:stylesheet>
