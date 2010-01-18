<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a post
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST" mode="object_post_generic">
        
        <li>
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe"/>
                        
            <xsl:apply-templates select="." mode="library_itemdetail"/>
            <p>
            	<xsl:apply-templates select="TEXT" mode="library_Richtext" />
            </p>
        </li>
        
    </xsl:template>
</xsl:stylesheet>
