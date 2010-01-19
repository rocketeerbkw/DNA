<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Holds XML construction of a first post
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            Use this template to specify the html for the first post
            in a list of posts.
            
            To let it reflect object-post-generic, simply remove all
            the HTML and paste:
            
                xsl:apply-template select="." mode="object-post-generic"
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="POST" mode="object_post_first">
        
        <xsl:apply-templates select="." mode="object_post_generic"/>        
    </xsl:template>
</xsl:stylesheet>
