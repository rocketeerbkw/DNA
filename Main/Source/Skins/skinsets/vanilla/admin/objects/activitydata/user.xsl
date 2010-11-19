<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    <xsl:template match="USER" mode="library_activitydata" >
      <xsl:choose>
        <xsl:when test="@USERID != '0'">
          <a href="/dna/moderation/admin/memberdetails?userid={@USERID}">
            <xsl:value-of select="text()"/>
          </a>    
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
        
      </xsl:choose>
      
    </xsl:template>
</xsl:stylesheet>