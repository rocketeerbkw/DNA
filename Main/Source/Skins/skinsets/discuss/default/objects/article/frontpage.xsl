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
    
    
    <xsl:template match="ARTICLE" mode="object_article_frontpage">
        
        <div class="column">
            <div class="large-panel module">
                <h2>
                    <xsl:text>Commenting For Everyone</xsl:text>
                    <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2">
                        <a href="{$root}/EditFrontpage">edit the frontpage</a>
                    </xsl:if>
                </h2>
                
                <xsl:apply-templates select="preceding-sibling::ANCESTRY" mode="object_ancestry" />
                
                    <!-- Format the article body text -->
                    <xsl:apply-templates select="GUIDE/BODY" mode="library_GuideML" />
                
                <!-- Adds information about the article, such as when it was created etc -->
                <xsl:apply-templates select="ARTICLEINFO" mode="library_itemdetail"/>
                
            </div>
        </div>
        
        <div class="column">
            
            <div class="module small-panel" id="detail">
                <h2>Getting Started</h2>
                <ul class="endcorners">
                    <li class="outline">
                        <a href="/discuss">
                            See the Example
                            <span>Too much marketing speak? Have a look at our demo of BBC Discuss.</span>
                        </a>
                    </li>
                    <li>
                        <a href="/discuss">
                            Quick Guide
                            <span>What you'll need to get BBC Discuss on your pages in no time at all.</span>
                        </a>
                    </li>
                    <li>
                        <a href="/discuss">
                            Documentation
                            <span>From APIs to service details, everything you need to know about BBC Discuss is here.</span>
                        </a>
                    </li>
                </ul>
            </div>
            <!--
            <div class="module small-panel">
                <h2>Service</h2>
                <p>erm</p>
            </div>
            -->
            
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