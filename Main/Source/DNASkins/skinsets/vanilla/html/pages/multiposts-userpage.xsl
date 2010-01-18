<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"  
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML Layout for pages of type 'multipost'
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'userpage']]" mode="page">        
        
        <div class="column wide">
            
            <h2>
                Message Centre for 
                <xsl:value-of select="FORUMSOURCE/USERPAGE/USER/USERNAME"/>
            </h2>
        
            <!-- Insert posts-->
            <xsl:apply-templates select="FORUMTHREADPOSTS" mode="object_forumthreadposts"/>
        
        </div>
    </xsl:template>
    
    
    
</xsl:stylesheet>
