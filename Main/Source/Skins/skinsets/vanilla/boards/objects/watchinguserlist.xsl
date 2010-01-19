<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="WATCHING-USER-LIST" mode="object_watchinguserlist">
        
        <ul class="collections watcheduserlist">
            
            <xsl:apply-templates select="USER" mode="object_user_listitem" />
        </ul>
        
    </xsl:template>
    
</xsl:stylesheet>