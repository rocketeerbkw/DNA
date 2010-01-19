<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML Layout for pages of type 'userpage'
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="/H2G2[@TYPE = 'USERPAGE']" mode="page">        
        
        <div class="wide">
            
            <xsl:apply-templates select="ARTICLE" mode="object_article" />
            
            <div>
                <h3 id="Conversations">Conversations</h3>
                <xsl:apply-templates select="RECENT-POSTS/POST-LIST" mode="object_postlist" />
            </div>
            
            <div>
                <h3 id="Messages">Messages</h3>
                <xsl:apply-templates select="ARTICLEFORUM/FORUMTHREADS" mode="object_forumthreads" />
            </div>
            
            <div>
                <h3 id="Friends">Friends</h3>
                <xsl:apply-templates select="WATCHING-USER-LIST" mode="object_watchinguserlist"/>
            </div>
            
        </div>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>
