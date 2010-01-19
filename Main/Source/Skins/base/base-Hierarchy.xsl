<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="HIERARCHY_MAINBODY">
	<xsl:apply-templates select="HIERARCHYNODES/NODE"/>
	</xsl:template>

  <xsl:template match="NODE">
    <xsl:value-of select="@NODEID"/>,<xsl:value-of select="@TREELEVEL"/>,<xsl:value-of select="@NAME"/><xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates select="NODE"/>
  </xsl:template>


  
</xsl:stylesheet>