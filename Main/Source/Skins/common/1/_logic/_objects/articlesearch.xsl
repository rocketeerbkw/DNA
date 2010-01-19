<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Logic layer for the Article object
        </doc:purpose>
        <doc:context>
            Commonly applied on a skin specific page layout.
        </doc:context>
        <doc:notes>
            Identifies complete and incomplete Article nodes, and applies the 
            relevant skin template.
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="ARTICLESEARCH" mode="object_articlesearch">
      <xsl:apply-templates select="ARTICLES/ARTICLE" mode="object_articlesearch"/>
    </xsl:template>

    <xsl:template match="ARTICLE" mode="object_articlesearch">
     <div>
       <a href="{$root}/A{@H2G2ID}" class="articlesearch"><xsl:value-of select="SUBJECT"/></a>
     </div>
    </xsl:template>
    
</xsl:stylesheet>