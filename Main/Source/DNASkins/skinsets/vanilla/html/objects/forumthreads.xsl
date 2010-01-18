<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms THREAD elements belonging to a forum. 
        </doc:purpose>
        <doc:context>
            Can be used on ARTICLE AND USERPAGE
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="FORUMTHREADS" mode="object_forumthreads">
        
        <ul class="collections forumthreads">
            <xsl:apply-templates select="THREAD" mode="object_thread">
                <xsl:sort select="DATEPOSTED/DATE/@SORT" order="descending"/>
            </xsl:apply-templates>
        </ul>
        
    </xsl:template>
    
</xsl:stylesheet>