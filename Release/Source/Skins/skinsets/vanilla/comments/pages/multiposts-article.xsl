<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY raquo "&#187;">
]>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML Layout for pages of type 'multipost'
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Output from here ends up between the document body tag 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'article']]" mode="page">        
        
        <div class="column wide">
                            
            <h2>Discuss</h2>
            
            <!-- Insert posts-->
            <xsl:apply-templates select="FORUMTHREADPOSTS" mode="object_forumthreadposts"/>
                
            <p class="quicklinks">
                <a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">Read the article &raquo;</a>
                <a href="F{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">Related Conversations &raquo;</a>
            </p>
            
        </div>
        
    
    </xsl:template>
    
    
    
    <!--
        Providing the same xpath and a mode of 'head_additional' allows the skin developer to add extra
        HTML elements to the head, on a page by page basis.
    -->
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'article']]" mode="head_additional">
        <script type="text/javascript" src="/hello.js"></script>
    </xsl:template> 
    
    
</xsl:stylesheet>
