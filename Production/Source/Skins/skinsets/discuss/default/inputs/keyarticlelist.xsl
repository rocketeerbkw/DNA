<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Contains HTML for incomplete articles - when body text is missing or empty
        </doc:purpose>
        <doc:context>
            Applied by logic layer (common/logic/objects/article.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="KEYARTICLELIST" mode="input_keyarticlelist">
        
        <p class="endcorners">No Named Articles have been created yet.</p>
    </xsl:template>
    
    <xsl:template match="KEYARTICLELIST[ARTICLE]" mode="input_keyarticlelist">
        
        <form action="{$root}/NamedArticles" method="post" class="endcorners">
            
            <ul>
                <xsl:apply-templates select="ARTICLE" mode="object_article_keyarticlelist" />
            </ul>
            
            <input type="submit" value="Remove Selected Articles" name="remove"/>
        </form>
        
        
        
    </xsl:template>
</xsl:stylesheet>