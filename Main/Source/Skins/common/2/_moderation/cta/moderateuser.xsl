<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Tools for moderating users
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER | @USERID" mode="moderation_cta_moderateuser">
      <xsl:param name="label"/>
      <xsl:param name="user"/>
      
      <xsl:choose>
        <xsl:when test="self::USER">
          <a target="_blank" href="{$configuration/host/sslurl}/dna/moderation/admin/MemberDetails?userid={USERID}"><xsl:value-of select="$label"/><span class="blq-hide"><xsl:text>:&#32;</xsl:text><xsl:value-of select="$user"/></span></a>
        </xsl:when>
        <xsl:otherwise>
          <a target="_blank" href="{$configuration/host/sslurl}/dna/moderation/admin/MemberDetails?userid={.}"><xsl:value-of select="$label"/><span class="blq-hide"><xsl:text>:&#32;</xsl:text><xsl:value-of select="$user"/></span></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>