<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    <xsl:template match="NOTES" mode="library_activitydata" >
      <blockquote>
        <xsl:choose>
          <xsl:when test="text() = ''">
            <xsl:text>[ Not entered ]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            "<xsl:value-of select="text()"/>"
          </xsl:otherwise>
        </xsl:choose>

      </blockquote>
    </xsl:template>
</xsl:stylesheet>