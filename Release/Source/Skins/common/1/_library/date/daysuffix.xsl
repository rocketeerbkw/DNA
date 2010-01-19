<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Add English Ordinal suffix to Month number
        </doc:purpose>
        <doc:context>
            Usually applied internally by library_date templates
        </doc:context>
        <doc:notes>
            e.g 1st, 2nd, 3rd, 4th, 5th etc
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="@DAY" mode="library_date_daysuffix">
        <xsl:choose>
          <xsl:when test="starts-with(string(.), '0')"><xsl:value-of select="substring(., 2)"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="(.) = 1 or (.) = 21 or (.) = 31">
                <xsl:text>st</xsl:text>
            </xsl:when>
            <xsl:when test="(.) = 2 or (.) = 22">
                <xsl:text>nd</xsl:text>
            </xsl:when>
            <xsl:when test="(.) = 3 or (.) = 23">
                <xsl:text>rd</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>th</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>