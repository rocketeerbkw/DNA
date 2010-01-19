<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a full DNA article
        </doc:purpose>
        <doc:context>
            Applied by logic layer (common/logic/objects/article.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="ARTICLE" mode="object_article_generic">
        
        <xsl:apply-templates select="." mode="object_article_title" />
        
        <xsl:apply-templates select="preceding-sibling::ANCESTRY" mode="object_ancestry" />
        
        <div class="article text">
            <!-- Format the article body text -->
            <xsl:apply-templates select="GUIDE/BODY" mode="library_GuideML" />
        </div>
        
    </xsl:template>
</xsl:stylesheet>