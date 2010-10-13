<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Generates a username in an anchor pointing to their profile page
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            Passes responsibility onto site specific skin template object/user/linked
            
            I don't want to lock developers out of being able to do this, hence why
            it is being delegated.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER" mode="library_user_notables">
        <xsl:if test="GROUPS/GROUP[NAME = 'NOTABLES']">
           <xsl:text>notables</xsl:text>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>