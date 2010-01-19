<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            HTML for a POST entry in a collection, a UL or OL HTML element
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST" mode="object_post_listitem">
        
        <li>
            <xsl:apply-templates select="." mode="library_itemdetail"/>
            <p style="font-style:italic">
                Reply by <xsl:apply-templates select="USER" mode="object_user_inline"/>
            </p>
            <p>
            	<xsl:apply-templates select="TEXT" mode="library_Richtext" />
            </p>
        </li>
        
    </xsl:template>
</xsl:stylesheet>
