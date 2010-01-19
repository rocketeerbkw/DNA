<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Displays the SSO sign in / sign out typically found on user generated pages. 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="SITE" mode="library_siteoptions_get">
        <xsl:param name="name" />
        
        <xsl:choose>
            <xsl:when test="SITEOPTIONS/SITEOPTION[@GLOBAL = 0 and NAME = $name]/VALUE">
                <xsl:value-of select="SITEOPTIONS/SITEOPTION[@GLOBAL = 0 and NAME = $name]/VALUE"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="SITEOPTIONS/SITEOPTION[@GLOBAL = 1 and NAME = $name]/VALUE"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>