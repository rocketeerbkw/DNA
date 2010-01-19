<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://www.bbc.co.uk/dna/documentation" version="1.0" exclude-result-prefixes="doc">

  <doc:documentation>
    <doc:purpose>
      Page layout for logout page
    </doc:purpose>
    <doc:context>
      Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
    </doc:context>
    <doc:notes>
      Logout page
    </doc:notes>
  </doc:documentation>
  
  <xsl:template match="/H2G2[@TYPE = 'LOGOUT']" mode="page">
   
    <div>
      <p>You have been logged out. Thank you for visiting <xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/>.</p>
    </div>
    
  </xsl:template>

  <xsl:template match="/H2G2[@TYPE = 'LOGOUT']" mode="breadcrumbs">
    <li class="current">
      <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
    </li>
  </xsl:template>
</xsl:stylesheet>
