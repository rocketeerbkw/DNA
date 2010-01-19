<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="ARTICLE" mode="object_article_incomplete">
        <h2>
            <xsl:value-of select="SUBJECT" />
        </h2>
         
        <div class="article content">
            <p>
                This section of the page has not been completed yet.
            </p>
        </div>
        
    </xsl:template>
</xsl:stylesheet>