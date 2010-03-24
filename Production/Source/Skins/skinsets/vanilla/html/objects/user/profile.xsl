<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Transforms USER node into contact card HTML 
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="USER" mode="object_user_profile">
        
        <div class="user detail">
            <xsl:call-template name="library_header_h3">
                <xsl:with-param name="text">
                    <a href="?userid={USERID}">
                        <xsl:value-of select="USERNAME"/>
                    </a>
                </xsl:with-param>
            </xsl:call-template>
        </div>
        
    </xsl:template>
</xsl:stylesheet>
