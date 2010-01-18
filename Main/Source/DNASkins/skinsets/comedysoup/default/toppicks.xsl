<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" method="xml" indent="no"/>

  <xsl:template match="TOPPICKS" mode="soupgetxml">
    <xsl:apply-templates select="./ARTICLESEARCHPHRASE" mode="soupgetxml"/>
  </xsl:template>

  <xsl:template match="ARTICLESEARCHPHRASE" mode="soupgetxml">
    <ARTICLESEARCHPHRASE>
      <xsl:apply-templates select="./ARTICLESEARCH" mode="soupgetxml"></xsl:apply-templates>
    </ARTICLESEARCHPHRASE>
  </xsl:template>

  <xsl:template match="ARTICLESEARCH" mode="soupgetxml">
    <ARTICLESEARCH>
      <xsl:apply-templates select="ARTICLE" mode="soupgetxml"></xsl:apply-templates>
    </ARTICLESEARCH>
  </xsl:template>

  <xsl:template match="ARTICLE" mode="soupgetxml">
  </xsl:template>
  
</xsl:stylesheet> 

