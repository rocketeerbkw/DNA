<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic XML construction of a post
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST" mode="object_post_generic">
        
        <item>
            <title>
                <xsl:apply-templates select="USER" mode="object_user_inline"/>
            </title>
            <description>  
                <xsl:apply-templates select="TEXT" mode="library_GuideML_rss"/>      
            </description>   
        </item>
        
    </xsl:template>
</xsl:stylesheet>
