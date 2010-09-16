<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>

<xsl:template match="/">
  <xsl:variable name="date">
    <xsl:value-of select="/H2G2/POSTING-STATISTICS/STARTDATE/DATE/@YEAR"/>
    <xsl:value-of select="/H2G2/POSTING-STATISTICS/STARTDATE/DATE/@MONTH"/>
    <xsl:value-of select="/H2G2/POSTING-STATISTICS/STARTDATE/DATE/@DAY"/>
  </xsl:variable>
  <xsl:for-each select="/H2G2/POSTING-STATISTICS/POSTINGS">
<xsl:value-of select="$date"/>,<xsl:value-of select="@URLNAME"/>,<xsl:value-of select="@FORUMID"/>,"<xsl:value-of select="@TITLE"/>",<xsl:value-of select="@TOTALPOSTS"/>,<xsl:value-of select="@TOTALUSERS"/>
    <xsl:text>
</xsl:text>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet> 
