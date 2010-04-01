<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms PROMO to a promo!
        </doc:purpose>
        <doc:context>
            Applied on the user page to display conversations
        </doc:context>
        <doc:notes>
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="BOARDPROMO" mode="object_promo">
      <div class="dna-promocontainer">
        <xsl:choose>
          <xsl:when test="TEMPLATETYPE = 3 or TEMPLATETYPE = 5">
            <xsl:apply-templates select="IMAGENAME" mode="object_promo"/>
            <xsl:apply-templates select="TEXT" mode="object_promo"/>
          </xsl:when>
          <xsl:when test="TEMPLATETYPE = 4 or TEMPLATETYPE = 6">
            <xsl:apply-templates select="TEXT" mode="object_promo"/>
            <xsl:apply-templates select="IMAGENAME" mode="object_promo"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="TEXT | IMAGENAME" mode="object_promo"/>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:template>
    
    <xsl:template match="TEXT" mode="object_promo">
      <div class="dna-promotype{../TEMPLATETYPE}">
        <xsl:copy-of select="."/>
      </div>
    </xsl:template>
    
    <xsl:template match="IMAGENAME" mode="object_promo">
      <div class="dna-promotype{../TEMPLATETYPE} image">
        <img src="{.}" height="{../IMAGEHEIGHT}" width="{../IMAGEWIDTH}" alt="{../IMAGEALTTEXT}"/>
      </div>
    </xsl:template>
    
</xsl:stylesheet>