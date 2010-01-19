<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
        
        <div class="column">
            <div class="large-panel module">
                <h2>
                    <xsl:value-of select="SUBJECT" />
                    <span>
                        <a href="{$root}/A{ARTICLEINFO/H2G2ID}">permalink</a>
                    </span>
                    <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2">
                        <a href="useredit{ARTICLEINFO/H2G2ID}">edit this article</a>
                    </xsl:if>
                </h2>
                
                <xsl:apply-templates select="preceding-sibling::ANCESTRY" mode="object_ancestry" />
                
                    <!-- Format the article body text -->
                    <xsl:apply-templates select="GUIDE/BODY" mode="library_GuideML" />
                
                <!-- Adds information about the article, such as when it was created etc -->
                <xsl:apply-templates select="ARTICLEINFO" mode="library_itemdetail"/>
                
            </div>
        </div>
        
        <!--
        <div class="column">
            <div id="detail" class="small-panel module">
                <h2>Info</h2>
            </div>
        </div>
    -->        
        
                
        
            
        
    </xsl:template>
</xsl:stylesheet>