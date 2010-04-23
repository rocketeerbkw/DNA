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
      <xsl:param name="label" select="'Moderate this user'"/>
      <xsl:choose>
        <xsl:when test="self::USER">
          <a class="popup" target="_blank" href="{$root}/MemberList?UserID={USERID}"><xsl:value-of select="$label"/></a>
        </xsl:when>
        <xsl:otherwise>
          <a class="popup" target="_blank" href="{$root}/MemberList?UserID={.}"><xsl:value-of select="$label"/></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>