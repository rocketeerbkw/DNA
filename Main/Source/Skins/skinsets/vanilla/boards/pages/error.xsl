<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

  <doc:documentation>
    <doc:purpose>
      Page layout for an error page
    </doc:purpose>
    <doc:context>
      Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
    </doc:context>
    <doc:notes>
      This defines the error page layout, not to be confused with the error object...
    </doc:notes>
  </doc:documentation>
  
  <xsl:template match="/H2G2[@TYPE = 'ERROR']" mode="page">
   
    <h2>There has been a problem...</h2>
    
    <p>An error has occurred with your request. The service may be temporarily broken.</p>
    
     <xsl:value-of select="ERROR"/>  
    
  </xsl:template>

  <xsl:template match="/H2G2[@TYPE = 'ERROR']" mode="breadcrumbs">
    <li class="current">
      <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
    </li>
  </xsl:template>
</xsl:stylesheet> 
