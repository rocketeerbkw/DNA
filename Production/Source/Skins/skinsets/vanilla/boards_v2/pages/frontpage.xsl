<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Used here to output the correct HTML for a BBC Homepage module
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE']" mode="page">
        <xsl:variable name="topiccols">
        	<xsl:choose>
		        <xsl:when test="/H2G2/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '1col' or /H2G2/SITECONFIG/V2_BOARDS/TOPICLAYOUT = ''">
		        	<xsl:text> single-col-topics</xsl:text>
		        </xsl:when>
		        <xsl:otherwise>
		        	<xsl:text> double-col-topics</xsl:text>
		        </xsl:otherwise>
	        </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates select="TOPICLIST" mode="object_topiclist">
			      <xsl:with-param name="topic-layout" select="$topiccols" />
        </xsl:apply-templates>
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE']" mode="breadcrumbs">
        <!--<li class="current">
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>-->
    </xsl:template>

</xsl:stylesheet>