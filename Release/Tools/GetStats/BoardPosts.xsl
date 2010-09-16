<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text"/>
  <xsl:key name="sites" match="POSTINGS" use="@URLNAME"/>
<xsl:template match="/">
  <xsl:apply-templates select="/H2G2/POSTING-STATISTICS"/>
</xsl:template>

  <xsl:template match="POSTING-STATISTICS">
    <xsl:variable name="date">
      <xsl:value-of select="/H2G2/POSTING-STATISTICS/STARTDATE/DATE/@YEAR"/>
      <xsl:value-of select="/H2G2/POSTING-STATISTICS/STARTDATE/DATE/@MONTH"/>
      <xsl:value-of select="/H2G2/POSTING-STATISTICS/STARTDATE/DATE/@DAY"/>
    </xsl:variable>
      <xsl:for-each select="POSTINGS[count(. | key('sites', @URLNAME)[1]) = 1]">
        <xsl:sort select="@URLNAME" />
        <xsl:value-of select="$date"/>,<xsl:value-of select="@URLNAME" />,<xsl:value-of select="count(key('sites', @URLNAME)/@TOTALPOSTS)"/>,<xsl:value-of select="sum(key('sites', @URLNAME)/@TOTALPOSTS)"/>,<xsl:value-of select="sum(key('sites', @URLNAME)/@TOTALUSERS)"/>
<!--        <xsl:for-each select="key('sites', @URLNAME)">
          <xsl:sort select="@FORUMID" />
          <xsl:value-of select="@TITLE" /> (<xsl:value-of select="@TOTALPOSTS" />)<br />
        </xsl:for-each>
-->
<!--      <xsl:value-of select="$date"/>,<xsl:value-of select="@URLNAME"/>,<xsl:value-of select="@FORUMID"/>,"<xsl:value-of select="@TITLE"/>",<xsl:value-of select="@TOTALPOSTS"/>,<xsl:value-of select="@TOTALUSERS"/>
-->
        <xsl:text>
</xsl:text>
    </xsl:for-each>

  </xsl:template>
  
</xsl:stylesheet> 
